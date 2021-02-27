Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E996F326B25
	for <lists+stable@lfdr.de>; Sat, 27 Feb 2021 03:31:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhB0Cau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 21:30:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:51460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhB0Can (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Feb 2021 21:30:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 639E964F3F;
        Sat, 27 Feb 2021 02:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614393014;
        bh=sI7BfWONZ/HA8qEH3AF2YyNel4NSBxBuQuQloDIiU8c=;
        h=Date:From:To:Subject:From;
        b=XFL2vsXb9UfJzRK3sQRFIzFE33ub7eGLgKuqqfGBr6y9RVQD3Y7TKuVR+XxALehro
         Z2dlHopDf/F2dP5wtY6ZNrAvHFynij7+VJGFH0SgnR9fVLe8AEZGv1AfAZnkUUZWzu
         9JwdQItmjQgAlwOUptadCUjITQiLSyAvj56JGgnw=
Date:   Fri, 26 Feb 2021 18:30:14 -0800
From:   akpm@linux-foundation.org
To:     minchan@kernel.org, mm-commits@vger.kernel.org,
        sergey.senozhatsky@gmail.com, stable@vger.kernel.org,
        wu-yan@tcl.com
Subject:  [merged]
 zsmalloc-account-the-number-of-compacted-pages-correctly.patch removed from
 -mm tree
Message-ID: <20210227023014.Zd1jDtoyd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: zsmalloc: account the number of compacted pages correctly
has been removed from the -mm tree.  Its filename was
     zsmalloc-account-the-number-of-compacted-pages-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rokudo Yan <wu-yan@tcl.com>
Subject: zsmalloc: account the number of compacted pages correctly

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
---

 drivers/block/zram/zram_drv.c |    2 +-
 include/linux/zsmalloc.h      |    2 +-
 mm/zsmalloc.c                 |   17 +++++++++++------
 3 files changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zsmalloc-account-the-number-of-compacted-pages-correctly
+++ a/drivers/block/zram/zram_drv.c
@@ -1081,7 +1081,7 @@ static ssize_t mm_stat_show(struct devic
 			zram->limit_pages << PAGE_SHIFT,
 			max_used << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.same_pages),
-			pool_stats.pages_compacted,
+			atomic_long_read(&pool_stats.pages_compacted),
 			(u64)atomic64_read(&zram->stats.huge_pages),
 			(u64)atomic64_read(&zram->stats.huge_pages_since));
 	up_read(&zram->init_lock);
--- a/include/linux/zsmalloc.h~zsmalloc-account-the-number-of-compacted-pages-correctly
+++ a/include/linux/zsmalloc.h
@@ -35,7 +35,7 @@ enum zs_mapmode {
 
 struct zs_pool_stats {
 	/* How many pages were migrated (freed) */
-	unsigned long pages_compacted;
+	atomic_long_t pages_compacted;
 };
 
 struct zs_pool;
--- a/mm/zsmalloc.c~zsmalloc-account-the-number-of-compacted-pages-correctly
+++ a/mm/zsmalloc.c
@@ -2212,11 +2212,13 @@ static unsigned long zs_can_compact(stru
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
@@ -2246,7 +2248,7 @@ static void __zs_compact(struct zs_pool
 		putback_zspage(class, dst_zspage);
 		if (putback_zspage(class, src_zspage) == ZS_EMPTY) {
 			free_zspage(pool, class, src_zspage);
-			pool->stats.pages_compacted += class->pages_per_zspage;
+			pages_freed += class->pages_per_zspage;
 		}
 		spin_unlock(&class->lock);
 		cond_resched();
@@ -2257,12 +2259,15 @@ static void __zs_compact(struct zs_pool
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
@@ -2270,10 +2275,11 @@ unsigned long zs_compact(struct zs_pool
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
 
@@ -2290,13 +2296,12 @@ static unsigned long zs_shrinker_scan(st
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
_

Patches currently in -mm which might be from wu-yan@tcl.com are


