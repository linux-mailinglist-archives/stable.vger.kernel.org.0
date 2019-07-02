Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946455C646
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 02:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfGBAS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 20:18:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbfGBAS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 20:18:28 -0400
Received: from localhost.localdomain (c-73-223-200-170.hsd1.ca.comcast.net [73.223.200.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D03720652;
        Tue,  2 Jul 2019 00:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562026707;
        bh=kcJQ49e2vbm99n8JEcSxAtHIX/vcUA+/3ssA7LuckdE=;
        h=Date:From:To:Subject:From;
        b=EnVXC03XOfugeBfpClIT0AWdLeAlE2oL6tgnb3yrKHh5/WUeURcirVAP0YkuBWNOB
         ZOpkIv4z3v4EwmpjLuQiDQK2v0Fwc8Ll4szte1HET4wbf8rqgDsrCrO0W1KMN5YqkP
         distSjpIgBSM8I65VTM+/yu0DiRBLRvmTUaLQcvo=
Date:   Mon, 01 Jul 2019 17:18:26 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, riel@redhat.com, sonnyrao@chromium.org,
        stable@vger.kernel.org, vdavydov.dev@gmail.com, vovoy@chromium.org
Subject:  + mm-vmscan-scan-anonymous-pages-on-file-refaults.patch
 added to -mm tree
Message-ID: <20190702001826.d0iOa2ws0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: vmscan: scan anonymous pages on file refaults
has been added to the -mm tree.  Its filename is
     mm-vmscan-scan-anonymous-pages-on-file-refaults.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-scan-anonymous-pages-on-file-refaults.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-scan-anonymous-pages-on-file-refaults.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kuo-Hsin Yang <vovoy@chromium.org>
Subject: mm: vmscan: scan anonymous pages on file refaults

When file refaults are detected and there are many inactive file pages,
the system never reclaim anonymous pages, the file pages are dropped
aggressively when there are still a lot of cold anonymous pages and system
thrashes.  This issue impacts the performance of applications with large
executable, e.g.  chrome.

With this patch, when file refault is detected, inactive_list_is_low()
always returns true for file pages in get_scan_count() to enable scanning
anonymous pages.

The problem can be reproduced by the following test program.

---8<---
void fallocate_file(const char *filename, off_t size)
{
	struct stat st;
	int fd;

	if (!stat(filename, &st) && st.st_size >= size)
		return;

	fd = open(filename, O_WRONLY | O_CREAT, 0600);
	if (fd < 0) {
		perror("create file");
		exit(1);
	}
	if (posix_fallocate(fd, 0, size)) {
		perror("fallocate");
		exit(1);
	}
	close(fd);
}

long *alloc_anon(long size)
{
	long *start = malloc(size);
	memset(start, 1, size);
	return start;
}

long access_file(const char *filename, long size, long rounds)
{
	int fd, i;
	volatile char *start1, *end1, *start2;
	const int page_size = getpagesize();
	long sum = 0;

	fd = open(filename, O_RDONLY);
	if (fd == -1) {
		perror("open");
		exit(1);
	}

	/*
	 * Some applications, e.g. chrome, use a lot of executable file
	 * pages, map some of the pages with PROT_EXEC flag to simulate
	 * the behavior.
	 */
	start1 = mmap(NULL, size / 2, PROT_READ | PROT_EXEC, MAP_SHARED,
		      fd, 0);
	if (start1 == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}
	end1 = start1 + size / 2;

	start2 = mmap(NULL, size / 2, PROT_READ, MAP_SHARED, fd, size / 2);
	if (start2 == MAP_FAILED) {
		perror("mmap");
		exit(1);
	}

	for (i = 0; i < rounds; ++i) {
		struct timeval before, after;
		volatile char *ptr1 = start1, *ptr2 = start2;
		gettimeofday(&before, NULL);
		for (; ptr1 < end1; ptr1 += page_size, ptr2 += page_size)
			sum += *ptr1 + *ptr2;
		gettimeofday(&after, NULL);
		printf("File access time, round %d: %f (sec)
", i,
		       (after.tv_sec - before.tv_sec) +
		       (after.tv_usec - before.tv_usec) / 1000000.0);
	}
	return sum;
}

int main(int argc, char *argv[])
{
	const long MB = 1024 * 1024;
	long anon_mb, file_mb, file_rounds;
	const char filename[] = "large";
	long *ret1;
	long ret2;

	if (argc != 4) {
		printf("usage: thrash ANON_MB FILE_MB FILE_ROUNDS
");
		exit(0);
	}
	anon_mb = atoi(argv[1]);
	file_mb = atoi(argv[2]);
	file_rounds = atoi(argv[3]);

	fallocate_file(filename, file_mb * MB);
	printf("Allocate %ld MB anonymous pages
", anon_mb);
	ret1 = alloc_anon(anon_mb * MB);
	printf("Access %ld MB file pages
", file_mb);
	ret2 = access_file(filename, file_mb * MB, file_rounds);
	printf("Print result to prevent optimization: %ld
",
	       *ret1 + ret2);
	return 0;
}
---8<---

Running the test program on 2GB RAM VM with kernel 5.2.0-rc5, the program
fills ram with 2048 MB memory, access a 200 MB file for 10 times.  Without
this patch, the file cache is dropped aggresively and every access to the
file is from disk.

  $ ./thrash 2048 200 10
  Allocate 2048 MB anonymous pages
  Access 200 MB file pages
  File access time, round 0: 2.489316 (sec)
  File access time, round 1: 2.581277 (sec)
  File access time, round 2: 2.487624 (sec)
  File access time, round 3: 2.449100 (sec)
  File access time, round 4: 2.420423 (sec)
  File access time, round 5: 2.343411 (sec)
  File access time, round 6: 2.454833 (sec)
  File access time, round 7: 2.483398 (sec)
  File access time, round 8: 2.572701 (sec)
  File access time, round 9: 2.493014 (sec)

With this patch, these file pages can be cached.

  $ ./thrash 2048 200 10
  Allocate 2048 MB anonymous pages
  Access 200 MB file pages
  File access time, round 0: 2.475189 (sec)
  File access time, round 1: 2.440777 (sec)
  File access time, round 2: 2.411671 (sec)
  File access time, round 3: 1.955267 (sec)
  File access time, round 4: 0.029924 (sec)
  File access time, round 5: 0.000808 (sec)
  File access time, round 6: 0.000771 (sec)
  File access time, round 7: 0.000746 (sec)
  File access time, round 8: 0.000738 (sec)
  File access time, round 9: 0.000747 (sec)

Link: http://lkml.kernel.org/r/20190701081038.GA83398@google.com
Fixes: e9868505987a ("mm,vmscan: only evict file pages when we have plenty")
Fixes: 7c5bd705d8f9 ("mm: memcg: only evict file pages when we have plenty")
Signed-off-by: Kuo-Hsin Yang <vovoy@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Sonny Rao <sonnyrao@chromium.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>	[4.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-scan-anonymous-pages-on-file-refaults
+++ a/mm/vmscan.c
@@ -2125,7 +2125,7 @@ static void shrink_active_list(unsigned
  *   10TB     320        32GB
  */
 static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
-				 struct scan_control *sc, bool actual_reclaim)
+				 struct scan_control *sc, bool trace)
 {
 	enum lru_list active_lru = file * LRU_FILE + LRU_ACTIVE;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -2151,7 +2151,7 @@ static bool inactive_list_is_low(struct
 	 * rid of the stale workingset quickly.
 	 */
 	refaults = lruvec_page_state_local(lruvec, WORKINGSET_ACTIVATE);
-	if (file && actual_reclaim && lruvec->refaults != refaults) {
+	if (file && lruvec->refaults != refaults) {
 		inactive_ratio = 0;
 	} else {
 		gb = (inactive + active) >> (30 - PAGE_SHIFT);
@@ -2161,7 +2161,7 @@ static bool inactive_list_is_low(struct
 			inactive_ratio = 1;
 	}
 
-	if (actual_reclaim)
+	if (trace)
 		trace_mm_vmscan_inactive_list_is_low(pgdat->node_id, sc->reclaim_idx,
 			lruvec_lru_size(lruvec, inactive_lru, MAX_NR_ZONES), inactive,
 			lruvec_lru_size(lruvec, active_lru, MAX_NR_ZONES), active,
_

Patches currently in -mm which might be from vovoy@chromium.org are

mm-vmscan-scan-anonymous-pages-on-file-refaults.patch

