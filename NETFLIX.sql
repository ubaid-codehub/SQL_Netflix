CREATE TABLE NETFLIX(
show_id VARCHAR(2000),	
type VARCHAR(2000),
title VARCHAR(3500),
director VARCHAR(1000),
cast_name VARCHAR(5000),
country VARCHAR(3000),
date_added DATE,
release_year INT,
rating  VARCHAR(1000),
duration VARCHAR(500),
listed_in VARCHAR(5000),
description VARCHAR(3000)
);   

---- 15 Business Problems & Solutions

--1. Count the number of Movies vs TV Shows

SELECT type,COUNT(*) FROM NETFLIX
GROUP BY type;

--2. Find the most common rating for movies and TV shows
SELECT rating, COUNT(*) AS common_rating FROM NETFLIX
GROUP BY rating
ORDER BY common_rating DESC
LIMIT 1;

--3. List all movies released in a specific year (e.g., 2020)
SELECT *FROM NETFLIX
WHERE release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix
SELECT COUNTRY , COUNT(*) AS total_content FROM NETFLIX
GROUP BY COUNTRY
ORDER BY total_content DESC
LIMIT 5;

--5. Identify the longest movie
SELECT * FROM NETFLIX 
WHERE TYPE='Movie'
AND DURATION IS NOT NULL
ORDER BY CAST(SPLIT_PART(duration,' ',1) AS INTEGER) DESC
LIMIT 1;

--6. Find content added in the last 5 years
SELECT DISTINCT * FROM NETFLIX
WHERE date_added >= CURRENT_DATE - INTERVAL '5 YEARS'

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * FROM NETFLIX
WHERE director = 'Rajiv Chilaka'

--8. List all TV shows with more than 5 seasons
SELECT TYPE,TITLE,DURATION FROM NETFLIX
WHERE TYPE = 'TV Show' AND
CAST(SPLIT_PART(duration,' ',1) AS INT )>5
ORDER BY DURATION ;

--9. Count the number of content items in each genre
SELECT LISTED_IN AS GENRE,COUNT(*) AS TOTAL_CONTENT FROM NETFLIX
GROUP BY GENRE
ORDER BY TOTAL_CONTENT;

--10.Find each year and the average numbers of content release in India on netflix return top 5 year with highest avg content release!. 
SELECT COUNTRY,RELEASE_YEAR,COUNT(SHOW_ID) AS CONTENT_NO ,
   ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release FROM NETFLIX
WHERE COUNTRY = 'India'
GROUP BY RELEASE_YEAR,COUNTRY
ORDER BY AVG_RELEASE DESC
LIMIT 5;

--11. List all movies that are documentaries
SELECT TITLE,LISTED_IN FROM NETFLIX 
WHERE TYPE='Movie' AND LISTED_IN LIKE '%Documentaries';

--12. Find all content without a director
SELECT *FROM NETFLIX
WHERE director IS NULL;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT COUNT(*) FROM NETFLIX
WHERE TYPE = 'Movie'
AND CAST_NAME ILIKE '%Salman Khan%' 
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;

--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT  UNNEST(STRING_TO_ARRAY(cast_name, ',')) AS actor, COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

SELECT 
    CASE 
        WHEN description LIKE '%kill%' OR description LIKE '%violence%' THEN 'Bad'
        ELSE 'Good'
    END AS content_category,
    COUNT(*) AS total_count
FROM netflix
GROUP BY content_category;



