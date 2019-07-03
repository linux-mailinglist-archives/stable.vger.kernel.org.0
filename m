Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814935E6BA
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 16:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfGCObA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 10:31:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:47884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725830AbfGCObA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jul 2019 10:31:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F3C80AD76;
        Wed,  3 Jul 2019 14:30:58 +0000 (UTC)
Date:   Wed, 3 Jul 2019 16:30:57 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Kuo-Hsin Yang <vovoy@chromium.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: scan anonymous pages on file refaults
Message-ID: <20190703143057.GQ978@dhcp22.suse.cz>
References: <20190628111627.GA107040@google.com>
 <20190701081038.GA83398@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701081038.GA83398@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 01-07-19 16:10:38, Kuo-Hsin Yang wrote:
> When file refaults are detected and there are many inactive file pages,
> the system never reclaim anonymous pages, the file pages are dropped
> aggressively when there are still a lot of cold anonymous pages and
> system thrashes.  This issue impacts the performance of applications
> with large executable, e.g. chrome.
> 
> With this patch, when file refault is detected, inactive_list_is_low()
> always returns true for file pages in get_scan_count() to enable
> scanning anonymous pages.
> 
> The problem can be reproduced by the following test program.
> 
> ---8<---
> void fallocate_file(const char *filename, off_t size)
> {
> 	struct stat st;
> 	int fd;
> 
> 	if (!stat(filename, &st) && st.st_size >= size)
> 		return;
> 
> 	fd = open(filename, O_WRONLY | O_CREAT, 0600);
> 	if (fd < 0) {
> 		perror("create file");
> 		exit(1);
> 	}
> 	if (posix_fallocate(fd, 0, size)) {
> 		perror("fallocate");
> 		exit(1);
> 	}
> 	close(fd);
> }
> 
> long *alloc_anon(long size)
> {
> 	long *start = malloc(size);
> 	memset(start, 1, size);
> 	return start;
> }
> 
> long access_file(const char *filename, long size, long rounds)
> {
> 	int fd, i;
> 	volatile char *start1, *end1, *start2;
> 	const int page_size = getpagesize();
> 	long sum = 0;
> 
> 	fd = open(filename, O_RDONLY);
> 	if (fd == -1) {
> 		perror("open");
> 		exit(1);
> 	}
> 
> 	/*
> 	 * Some applications, e.g. chrome, use a lot of executable file
> 	 * pages, map some of the pages with PROT_EXEC flag to simulate
> 	 * the behavior.
> 	 */
> 	start1 = mmap(NULL, size / 2, PROT_READ | PROT_EXEC, MAP_SHARED,
> 		      fd, 0);
> 	if (start1 == MAP_FAILED) {
> 		perror("mmap");
> 		exit(1);
> 	}
> 	end1 = start1 + size / 2;
> 
> 	start2 = mmap(NULL, size / 2, PROT_READ, MAP_SHARED, fd, size / 2);
> 	if (start2 == MAP_FAILED) {
> 		perror("mmap");
> 		exit(1);
> 	}
> 
> 	for (i = 0; i < rounds; ++i) {
> 		struct timeval before, after;
> 		volatile char *ptr1 = start1, *ptr2 = start2;
> 		gettimeofday(&before, NULL);
> 		for (; ptr1 < end1; ptr1 += page_size, ptr2 += page_size)
> 			sum += *ptr1 + *ptr2;
> 		gettimeofday(&after, NULL);
> 		printf("File access time, round %d: %f (sec)\n", i,
> 		       (after.tv_sec - before.tv_sec) +
> 		       (after.tv_usec - before.tv_usec) / 1000000.0);
> 	}
> 	return sum;
> }
> 
> int main(int argc, char *argv[])
> {
> 	const long MB = 1024 * 1024;
> 	long anon_mb, file_mb, file_rounds;
> 	const char filename[] = "large";
> 	long *ret1;
> 	long ret2;
> 
> 	if (argc != 4) {
> 		printf("usage: thrash ANON_MB FILE_MB FILE_ROUNDS\n");
> 		exit(0);
> 	}
> 	anon_mb = atoi(argv[1]);
> 	file_mb = atoi(argv[2]);
> 	file_rounds = atoi(argv[3]);
> 
> 	fallocate_file(filename, file_mb * MB);
> 	printf("Allocate %ld MB anonymous pages\n", anon_mb);
> 	ret1 = alloc_anon(anon_mb * MB);
> 	printf("Access %ld MB file pages\n", file_mb);
> 	ret2 = access_file(filename, file_mb * MB, file_rounds);
> 	printf("Print result to prevent optimization: %ld\n",
> 	       *ret1 + ret2);
> 	return 0;
> }
> ---8<---
> 
> Running the test program on 2GB RAM VM with kernel 5.2.0-rc5, the
> program fills ram with 2048 MB memory, access a 200 MB file for 10
> times.  Without this patch, the file cache is dropped aggresively and
> every access to the file is from disk.
> 
>   $ ./thrash 2048 200 10
>   Allocate 2048 MB anonymous pages
>   Access 200 MB file pages
>   File access time, round 0: 2.489316 (sec)
>   File access time, round 1: 2.581277 (sec)
>   File access time, round 2: 2.487624 (sec)
>   File access time, round 3: 2.449100 (sec)
>   File access time, round 4: 2.420423 (sec)
>   File access time, round 5: 2.343411 (sec)
>   File access time, round 6: 2.454833 (sec)
>   File access time, round 7: 2.483398 (sec)
>   File access time, round 8: 2.572701 (sec)
>   File access time, round 9: 2.493014 (sec)
> 
> With this patch, these file pages can be cached.
> 
>   $ ./thrash 2048 200 10
>   Allocate 2048 MB anonymous pages
>   Access 200 MB file pages
>   File access time, round 0: 2.475189 (sec)
>   File access time, round 1: 2.440777 (sec)
>   File access time, round 2: 2.411671 (sec)
>   File access time, round 3: 1.955267 (sec)
>   File access time, round 4: 0.029924 (sec)
>   File access time, round 5: 0.000808 (sec)
>   File access time, round 6: 0.000771 (sec)
>   File access time, round 7: 0.000746 (sec)
>   File access time, round 8: 0.000738 (sec)
>   File access time, round 9: 0.000747 (sec)

How does the reclaim behave with workloads with file backed data set
not fitting into the memory? Aren't we going to to swap a lot -
something that the heuristic is protecting from?

> Fixes: e9868505987a ("mm,vmscan: only evict file pages when we have plenty")
> Fixes: 7c5bd705d8f9 ("mm: memcg: only evict file pages when we have plenty")
> Signed-off-by: Kuo-Hsin Yang <vovoy@chromium.org>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: <stable@vger.kernel.org> # 4.12+

-- 
Michal Hocko
SUSE Labs
