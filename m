Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080B75B660
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 10:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfGAIKn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 04:10:43 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34985 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbfGAIKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 04:10:43 -0400
Received: by mail-pf1-f195.google.com with SMTP id d126so6176644pfd.2
        for <stable@vger.kernel.org>; Mon, 01 Jul 2019 01:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=E/CZW9HTMtXTzsWNO626jk1uoh4yKNXGp5gpm1i8SNo=;
        b=Y1Jl7Q3riwientCHluxuBavS3le3r8ZkQ6ZthBM24QSSsseeTqeNZmXcJEXfC9QeP8
         l6bbotOduPtoFStTdwPBkP9o7qaDEjwmJ6Le1PbbVtSbBiZqF22uqzR5WevH/mqIxbXS
         auNIogcG5elmi+eckCW5UoPAoVU7+6A7QfwDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E/CZW9HTMtXTzsWNO626jk1uoh4yKNXGp5gpm1i8SNo=;
        b=NK/6h1zO0+GyL/Hb/CKgScpxbqFsOV3P7TP5v7oHCp5TuaAo+8S+lam0+DL+DKHOGn
         plSyPm4LXpUlhLFH7J/R9CE/6Y9fbBcTItstB1y0ZSjqupaBJQ4M8c1IdwVPxBi7lspx
         kKjdRu2jxhwOTjmGWO4FRDJM7uS7CzMPGI0hnkWPkLILBl5Zt1cYg1BiLD+pnBfLWbi3
         AA25IFno2+cHOBRrHQ20JqJMPCDSJon1ZSgNdfw7siQPkGMPRus4jK/j3ZjqV8Wg/api
         rmV5lZzhs5tZCVLG226a4Wxv/5NHUH/Bbjrw4IzWdnQPz2EW1g3NxbZg1NL2G/Hn9gYv
         ii6Q==
X-Gm-Message-State: APjAAAUsr+MEO6rwuuW/QZhYAjf4Jwc1mtsjxBePOLeyhESkWXHrsPOf
        XiI6LWHPRatQNRXYbF5b2yxD
X-Google-Smtp-Source: APXvYqw/mugHN9o8pQ1MjJFOIOtoYW8do+1rzm25p+7GQndefP86Q2v1wR+6xWqkKyU8+6gIl6y1tA==
X-Received: by 2002:a63:dd53:: with SMTP id g19mr22552755pgj.3.1561968642410;
        Mon, 01 Jul 2019 01:10:42 -0700 (PDT)
Received: from google.com ([2401:fa00:1:b:d89e:cfa6:3c8:e61b])
        by smtp.gmail.com with ESMTPSA id a16sm14383490pfd.68.2019.07.01.01.10.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 01 Jul 2019 01:10:41 -0700 (PDT)
Date:   Mon, 1 Jul 2019 16:10:38 +0800
From:   Kuo-Hsin Yang <vovoy@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc:     Minchan Kim <minchan@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org
Subject: [PATCH] mm: vmscan: scan anonymous pages on file refaults
Message-ID: <20190701081038.GA83398@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628111627.GA107040@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When file refaults are detected and there are many inactive file pages,
the system never reclaim anonymous pages, the file pages are dropped
aggressively when there are still a lot of cold anonymous pages and
system thrashes.  This issue impacts the performance of applications
with large executable, e.g. chrome.

With this patch, when file refault is detected, inactive_list_is_low()
always returns true for file pages in get_scan_count() to enable
scanning anonymous pages.

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
		printf("File access time, round %d: %f (sec)\n", i,
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
		printf("usage: thrash ANON_MB FILE_MB FILE_ROUNDS\n");
		exit(0);
	}
	anon_mb = atoi(argv[1]);
	file_mb = atoi(argv[2]);
	file_rounds = atoi(argv[3]);

	fallocate_file(filename, file_mb * MB);
	printf("Allocate %ld MB anonymous pages\n", anon_mb);
	ret1 = alloc_anon(anon_mb * MB);
	printf("Access %ld MB file pages\n", file_mb);
	ret2 = access_file(filename, file_mb * MB, file_rounds);
	printf("Print result to prevent optimization: %ld\n",
	       *ret1 + ret2);
	return 0;
}
---8<---

Running the test program on 2GB RAM VM with kernel 5.2.0-rc5, the
program fills ram with 2048 MB memory, access a 200 MB file for 10
times.  Without this patch, the file cache is dropped aggresively and
every access to the file is from disk.

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

Fixes: e9868505987a ("mm,vmscan: only evict file pages when we have plenty")
Fixes: 7c5bd705d8f9 ("mm: memcg: only evict file pages when we have plenty")
Signed-off-by: Kuo-Hsin Yang <vovoy@chromium.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org> # 4.12+
---
 mm/vmscan.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7889f583ced9f..da0b97204372e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2125,7 +2125,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
  *   10TB     320        32GB
  */
 static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
-				 struct scan_control *sc, bool actual_reclaim)
+				 struct scan_control *sc, bool trace)
 {
 	enum lru_list active_lru = file * LRU_FILE + LRU_ACTIVE;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -2151,7 +2151,7 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
 	 * rid of the stale workingset quickly.
 	 */
 	refaults = lruvec_page_state_local(lruvec, WORKINGSET_ACTIVATE);
-	if (file && actual_reclaim && lruvec->refaults != refaults) {
+	if (file && lruvec->refaults != refaults) {
 		inactive_ratio = 0;
 	} else {
 		gb = (inactive + active) >> (30 - PAGE_SHIFT);
@@ -2161,7 +2161,7 @@ static bool inactive_list_is_low(struct lruvec *lruvec, bool file,
 			inactive_ratio = 1;
 	}
 
-	if (actual_reclaim)
+	if (trace)
 		trace_mm_vmscan_inactive_list_is_low(pgdat->node_id, sc->reclaim_idx,
 			lruvec_lru_size(lruvec, inactive_lru, MAX_NR_ZONES), inactive,
 			lruvec_lru_size(lruvec, active_lru, MAX_NR_ZONES), active,
-- 
2.22.0.410.gd8fdbe21b5-goog

