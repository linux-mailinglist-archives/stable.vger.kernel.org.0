Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D0932EA09
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:38:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhCEMgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:36:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:48246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232032AbhCEMfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:35:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4441B65023;
        Fri,  5 Mar 2021 12:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947738;
        bh=RIJhnoM5UxUY11bh/UKBnxFWhgfleX+QY8WyJL7ZNZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwtX+7BbHKSsoq0vXdVi+BM6gM67JOFjR+jJDbzWN0D3fPNI21tkSBScXxi0EDMUq
         bmz7N+0vbnXTOFlVUyboe8Ghn+TVwLBwl1HszbzeBI91grtlMKgvOs7Wytp2BMBCx7
         R1uFzf6l0wmqTl4XLY6HKgUAdmPeMbwLFB0D0SkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rokudo Yan <wu-yan@tcl.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 67/72] zsmalloc: account the number of compacted pages correctly
Date:   Fri,  5 Mar 2021 13:22:09 +0100
Message-Id: <20210305120900.620164431@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120857.341630346@linuxfoundation.org>
References: <20210305120857.341630346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rokudo Yan <wu-yan@tcl.com>

commit 2395928158059b8f9858365fce7713ce7fef62e4 upstream.

There exists multiple path may do zram compaction concurrently.
1. auto-compaction triggered during memory reclaim
2. userspace utils write zram<id>/compaction node

So, multiple threads may call zs_shrinker_scan/zs_compact concurrently.
But pages_compacted is a per zsmalloc pool variable and modification
of the variable is not serialized(through under class->lock).
There are two issues here:
1. the pages_compacted may not equal to total number of pages
freed(due to concurrently add).
2. zs_shrinker_scan may not return the correct number of pages
freed(issued by current shrinker).

The fix is simple:
1. account the number of pages freed in zs_compact locally.
2. use actomic variable pages_compacted to accumulate total number.

Link: https://lkml.kernel.org/r/20210202122235.26885-1-wu-yan@tcl.com
Fixes: 860c707dca155a56 ("zsmalloc: account the number of compacted pages")
Signed-off-by: Rokudo Yan <wu-yan@tcl.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    2 +-
 include/linux/zsmalloc.h      |    2 +-
 mm/zsmalloc.c                 |   17 +++++++++++------
 3 files changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1072,7 +1072,7 @@ static ssize_t mm_stat_show(struct devic
 			zram->limit_pages << PAGE_SHIFT,
 			max_used << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.same_pages),
-			pool_stats.pages_compacted,
+			atomic_long_read(&pool_stats.pages_compacted),
 			(u64)atomic64_read(&zram->stats.huge_pages));
 	up_read(&zram->init_lock);
 
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -35,7 +35,7 @@ enum zs_mapmode {
 
 struct zs_pool_stats {
 	/* How many pages were migrated (freed) */
-	unsigned long pages_compacted;
+	atomic_long_t pages_compacted;
 };
 
 struct zs_pool;
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2216,11 +2216,13 @@ static unsigned long zs_can_compact(stru
 	return obj_wasted * class->pages_per_zspage;
 }
 
-static void __zs_compact(struct zs_pool *pool, struct size_class *class)
+static unsigned long __zs_compact(struct zs_pool *pool,
+				  struct size_class *class)
 {
 	struct zs_compact_control cc;
 	struct zspage *src_zspage;
 	struct zspage *dst_zspage = NULL;
+	unsigned long pages_freed = 0;
 
 	spin_lock(&class->lock);
 	while ((src_zspage = isolate_zspage(class, true))) {
@@ -2250,7 +2252,7 @@ static void __zs_compact(struct zs_pool
 		putback_zspage(class, dst_zspage);
 		if (putback_zspage(class, src_zspage) == ZS_EMPTY) {
 			free_zspage(pool, class, src_zspage);
-			pool->stats.pages_compacted += class->pages_per_zspage;
+			pages_freed += class->pages_per_zspage;
 		}
 		spin_unlock(&class->lock);
 		cond_resched();
@@ -2261,12 +2263,15 @@ static void __zs_compact(struct zs_pool
 		putback_zspage(class, src_zspage);
 
 	spin_unlock(&class->lock);
+
+	return pages_freed;
 }
 
 unsigned long zs_compact(struct zs_pool *pool)
 {
 	int i;
 	struct size_class *class;
+	unsigned long pages_freed = 0;
 
 	for (i = ZS_SIZE_CLASSES - 1; i >= 0; i--) {
 		class = pool->size_class[i];
@@ -2274,10 +2279,11 @@ unsigned long zs_compact(struct zs_pool
 			continue;
 		if (class->index != i)
 			continue;
-		__zs_compact(pool, class);
+		pages_freed += __zs_compact(pool, class);
 	}
+	atomic_long_add(pages_freed, &pool->stats.pages_compacted);
 
-	return pool->stats.pages_compacted;
+	return pages_freed;
 }
 EXPORT_SYMBOL_GPL(zs_compact);
 
@@ -2294,13 +2300,12 @@ static unsigned long zs_shrinker_scan(st
 	struct zs_pool *pool = container_of(shrinker, struct zs_pool,
 			shrinker);
 
-	pages_freed = pool->stats.pages_compacted;
 	/*
 	 * Compact classes and calculate compaction delta.
 	 * Can run concurrently with a manually triggered
 	 * (by user) compaction.
 	 */
-	pages_freed = zs_compact(pool) - pages_freed;
+	pages_freed = zs_compact(pool);
 
 	return pages_freed ? pages_freed : SHRINK_STOP;
 }


