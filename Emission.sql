-- Q1. 
-- Table considered: <greenhouse_gas_inventory_data_data> 
-- What are the unique [categories]?
SELECT DISTINCT category 
FROM greenhouse_gas_inventory_data_data;

-- Q2. 
-- Tables considered: <greenhouse_gas_inventory_data_data>
-- What is the sum of emission [value] in the [year] 2010 to 2014 for European Union?
SELECT SUM(value) AS total_value
FROM greenhouse_gas_inventory_data_data
WHERE `year` BETWEEN 2010 AND 2014 AND
	  country_or_area = "European Union";

-- Q3. 
-- Table considered: <greenhouse_gas_inventory_data_data>
-- What are the [year], [category], and [value] for Australia where emission [value] is
-- greater than 530,000?
SELECT 	`year`, `category`, `value`
FROM greenhouse_gas_inventory_data_data
WHERE `value` > 530000 AND
	  country_or_area = "Australia";

-- Q4
-- Tables considered: <seaice> + <greenhouse_gas_inventory_data_data>
-- For each year (2010 to 2014), display the average [extent] of sea ice, maximum
-- [extent] of sea ice, minimum [extent] of sea ice, and the total amount of emission [value].
select T2.year, T2.avg_extent, T2.max_extent, T2.min_extent, T1.total_value
from
(select year, sum(value) as total_value
from greenhouse_gas_inventory_data_data
where year = 2010
union
select year, sum(value) as total_value
from greenhouse_gas_inventory_data_data
where year = 2011
union
select year, sum(value) as total_value
from greenhouse_gas_inventory_data_data
where year = 2012
union
select year, sum(value) as total_value
from greenhouse_gas_inventory_data_data
where year = 2013
union
select year, sum(value) as total_value
from greenhouse_gas_inventory_data_data
where year = 2014) T1,
(select year, avg(convert(Extent, double)) avg_extent, max(convert(Extent, double)) max_extent, min(convert(Extent, double)) min_extent
from seaice
where year = 2010
union
select year, avg(convert(Extent, double)) avg_extent, max(convert(Extent, double)) max_extent, min(convert(Extent, double)) min_extent
from seaice
where year = 2011
union
select year, avg(convert(Extent, double)) avg_extent, max(convert(Extent, double)) max_extent, min(convert(Extent, double)) min_extent
from seaice
where year = 2012
union
select year, avg(convert(Extent, double)) avg_extent, max(convert(Extent, double)) max_extent, min(convert(Extent, double)) min_extent
from seaice
where year = 2013
union
select year, avg(convert(Extent, double)) avg_extent, max(convert(Extent, double)) max_extent, min(convert(Extent, double)) min_extent
from seaice
where year = 2014) T2
where T1.Year = T2.Year;

-- Q5. 
-- Tables considered: <seaice> + <globaltemperatures>
-- For each year (2010 to 2014), display the average [extent] of sea ice, maximum
-- [extent] of sea ice, minimum [extent] of sea ice, average [landaveragetemperature],
-- minimum [landaveragetemperature], and maximum [landaveragetemperature].
SELECT seaice.`year` AS `Year`,
       AVG(convert(extent,double)) AS avg_extent, 
       MAX(convert(extent,double)) AS max_extent, 
       MIN(convert(extent,double)) AS min_extent, 
       AVG(convert(landaveragetemperature,double)) AS avgLandTemperature,
       MIN(convert(landaveragetemperature,double)) AS minLandTemperature,
       MAX(convert(landaveragetemperature,double)) AS maxLandTemperature
FROM globaltemperatures, seaice 
WHERE seaice.`year` BETWEEN 2010 AND 2014 AND
      DATE_FORMAT(globaltemperatures.recordedDate, "%Y") BETWEEN 2010 AND 2014 AND
      seaice.`year` = DATE_FORMAT(globaltemperatures.recordedDate, "%Y")
GROUP BY `Year`;
  
-- Q6.
-- Tables considered: <greenhouse_gas_inventory_data_data> + <temperaturechangebycountry>
-- For each year (2010 to 2014), display the sum of emission [value], average
-- temperature change [temperaturechangebycountry.value], minimum temperature
-- change, and maximum temperature change in Australia.
select T1.year, T1.total_emission, T2.avgTempChange, T2.minTempChange, T2.maxTempChange
from
(select year, sum(value) as total_emission
from greenhouse_gas_inventory_data_data
where year = 2010 and country_or_area = "Australia"
union
select year, sum(value) as total_emission
from greenhouse_gas_inventory_data_data
where year = 2011 and country_or_area = "Australia"
union
select year, sum(value) as total_emission
from greenhouse_gas_inventory_data_data
where year = 2012 and country_or_area = "Australia"
union
select year, sum(value) as total_emission
from greenhouse_gas_inventory_data_data
where year = 2013 and country_or_area = "Australia"
union
select year, sum(value) as total_emission
from greenhouse_gas_inventory_data_data
where year = 2014 and country_or_area = "Australia") T1,

(select year, avg(convert(Value,double)) as avgTempChange, min(convert(Value,double)) as minTempChange, max(convert(Value,double)) as maxTempChange
from temperaturechangebycountry
where year="2010" and Area="Australia"
union
select year, avg(convert(Value,double)) as avgTempChange, min(convert(Value,double)) as minTempChange, max(convert(Value,double)) as maxTempChange
from temperaturechangebycountry
where year="2011" and Area="Australia"
union
select year, avg(convert(Value,double)) as avgTempChange, min(convert(Value,double)) as minTempChange, max(convert(Value,double)) as maxTempChange
from temperaturechangebycountry
where year="2012" and Area="Australia"
union
select year, avg(convert(Value,double)) as avgTempChange, min(convert(Value,double)) as minTempChange, max(convert(Value,double)) as maxTempChange
from temperaturechangebycountry
where year="2013" and Area="Australia"
union
select year, avg(convert(Value,double)) as avgTempChange, min(convert(Value,double)) as minTempChange, max(convert(Value,double)) as maxTempChange
from temperaturechangebycountry
where year="2014" and Area="Australia") T2
where T1.year = T2.year;

-- Q7.
-- Table considered: <mass_balance_data>
-- Display a list of glaciers [name], [investigator], and amount of surveyed on the
-- glacier done by the investigator, when the investigator has conducted more than
-- 11 surveys on the glacier. Sort the output in alphabetic order of [name].
SELECT `Name`,
	   Investigator,
       SurveyedAmt
FROM (SELECT `NAME` AS `Name`,
	         INVESTIGATOR AS Investigator,
             COUNT(*) AS SurveyedAmt 
	  FROM mass_balance_data
      GROUP BY `NAME`, INVESTIGATOR) T
WHERE SurveyedAmt > 11
GROUP BY `Name`, Investigator
ORDER BY `Name`;

-- Q8
-- Table considered: <temperaturechangebycountry>
-- For each year (2010 to 2014), display a list of [area], [year], average [value] of
-- temperature change of the ASEAN countries (see https://asean.org/aboutPageasean
-- /member-states/for the list of member states). Include the overall average
-- of temperature change of all the ASEAN countries of each year.
-- Brunei, Cambodia, Indonesia, Laos, Malaysia, Myanmar, the Philippines, Singapore, Thailand and Vietnam

SELECT Area, YearCode AS Year, AVG(convert(Value, double)) AS avgValueChange
FROM temperaturechangebycountry
WHERE Area IN ("Brunei Darussalam", "Cambodia", "Indonesia", "Laos", "Malaysia", "Myanmar", "Philippines", "Singapore", 
	  "Thailand", "Vietnam", "ASEAN") AND
	  YearCode BETWEEN 2010 AND 2014
GROUP BY Area, Year
UNION
SELECT "ASEAN", year, avg(convert(Value,double)) avgValueChange
FROM temperaturechangebycountry
WHERE area in ("Brunei Darussalam","Cambodia","Indonesia","Lao PDR","Malaysia","Myanmar","Philippines","Singapore","Thailand","Viet Nam")
	and year BETWEEN 2010 AND 2014
GROUP BY year
ORDER BY year;

-- Q9
-- Table considered: <greenhouse_gas_inventory_data_data>
-- Display a list of [country_or_area], [year], [category], and average emission [value]
-- when the [country_or_area]’s emission [value] of the [year] is less than the
-- average emission [value] of the [country_or_area].

SELECT T2.country_or_area, T2.year, T2.value, T2.category, T1.avgEmission
FROM (SELECT country_or_area, AVG(CONVERT(`value`, double)) AS avgEmission
	  FROM greenhouse_gas_inventory_data_data
      GROUP BY country_or_area) AS T1, 
      greenhouse_gas_inventory_data_data AS T2
WHERE T2.`value` < T1.avgEmission AND
      T1.country_or_area = T2.country_or_area;

-- Q10.
-- Tables considered: <temperaturechangebycountry> + <seaice> + <elevation_change_data>
-- For each year (2008 to 2017), display the average [value] of temperature change
-- in “United States of America”, the year’s average [extent] of [seaice.extent] sea
-- ice, and the corresponding average [value] of
-- [temperaturechangebycountry.elevation_change_unc] glacier elevation change
-- surveyed by “Martina Barandun Robert McNabb” in the same year.\

SELECT T1.YearCode, avgValue, avgExtent, avgElevationChange
from 
	(
    SELECT YearCode, 
		AVG(convert(Value,double)) AS avgValue
	FROM temperaturechangebycountry
	WHERE Area = "United States of America" AND
		  YearCode BETWEEN 2008 AND 2017
	GROUP BY YearCode
    ) T1,
	(
    SELECT Year, 
		AVG(convert(Extent,double)) AS avgExtent
	FROM seaice
	WHERE Year BETWEEN 2008 AND 2017
	GROUP BY Year
    ) T2,
	(
    SELECT left(SURVEY_DATE, 4) AS Year, 
		   AVG(convert(elevation_change_unc,double)) AS avgElevationChange
	FROM elevation_change_data
	WHERE INVESTIGATOR = "Martina Barandun Robert McNabb" 
	GROUP BY left(SURVEY_DATE, 4)
    ) T3
WHERE T1.YearCode = T2.Year AND
	  T1.YearCode = T3.Year;