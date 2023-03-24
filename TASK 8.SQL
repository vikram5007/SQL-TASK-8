create table semester(
studentid int primary key, 
studentname varchar(20), 
semester int, 
securedmarks int, 
totalmarks int )

sp_rename 'semester.semester','sno';

alter table semester 
ALTER COLUMN securedmarks decimal;

--- CREATING A VIEW FOR THE SEMESTER TABLE ----
create view sem as

SELECT * FROM SEM

--- INSERTING VALUES INTO THE SEMESTER TABLE ----

insert into semester values(1,'VIKRAM',3,480,500),(2,'VIJAY',2,450,500),(3,'VASANTH',3,485,500),(4,'HARI',2,490,500),(5,'VIKRANTH',3,465,500),(6,'THILAK',3,483,500)
insert into semester values(7,'VIKRAM',1,482,500),(8,'VIJAYA KUMAR',1,490,500)
SELECT * FROM SEM

---2. Create user-defined function to generate a table that contains result of Sem 3 students.---

alter function semfun(@SNO INT)
RETURNS table 
as
return(SELECT * from dbo.semester where sno=@SNO)

SELECT * from dbo.semfun(3)

---1. Create User-define Scalar function to calculate percentage of all students after creating the following table---
alter function perc_calc(@marks decimal)
returns decimal(4,2)
as 
begin
declare @percentage decimal
set @percentage=(@marks/500.0)*100
return @percentage
end

select studentid,studentname,sno,securedmarks,totalmarks,dbo.perc_calc(securedmarks)as percentage from semester


---3. Write SQL stored procedure to retrieve all students details. (No parameters)---

create procedure disp
as
begin
select * from semester
end;

exec disp


---4. Write SQL store procedure to display Sem 1 students details. (One parameter)---

 create procedure sem1_pro(@sno int)
as begin
select * from semester where sno=@sno
end


exec sem1_pro '1'

---5. Write SQL Stored Procedure to retrieve total number of students details. (OUTPUT Parameter)----


CREATE procedure count(@count int output)
as begin 
select @count=Count(studentid)from semester ;
end

declare @res int
exec count @res out
print'THE TOTAL NO OF VALUES IN THE SEMESTER TABLE IS : '+convert(varchar(10),@res) 


---6. Show the working of Merge Statement by creating a backup for the students details of only students in Sem 1.----
create table semesterbackup(studentid int primary key, 
studentname varchar(20), 
sno int, 
securedmarks int, 
totalmarks int )

--- MOVING ONLY RECORDS WITH THE SEM NUMBER 1 --------

select * into semesterbackups from semester where sno=1

---MERGING THE SOURCE TABLE WITH THE TARGET -------

merge semesterbackups t
using semester s
on(t.studentid=s.studentid)
when matched
then update set
t.studentid=s.studentid,
t.studentname=s.studentname,
t.sno= s.sno,
t.securedmarks=s.securedmarks,
t.totalmarks=s.totalmarks
when not matched by target 
then insert(studentid,studentname,sno,securedmarks,totalmarks)
values(s.studentid,s.studentname,s.sno,s.securedmarks,s.totalmarks)
when not matched by source 
then delete;

select * from semester
select * from semesterbackups

---UPDATING THE SOURCE TABLE  -------

update semester set studentname='VASANTHY' where studentname='VASANTH'
select * from semester

--INSERTING INTO THE BACKUP TABLE  -------

insert into semesterbackups values(9,'HARSHAN',1,520,500)
select * from semesterbackups

 
--------------------------------- END --------------------------------------------

