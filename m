Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A5932E15C
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 06:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbhCEFXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 00:23:03 -0500
Received: from relay.corp-email.com ([222.73.234.233]:14402 "EHLO
        relay.corp-email.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhCEFXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 00:23:02 -0500
Received: from ([183.47.25.45])
        by relay.corp-email.com ((LNX1044)) with ASMTP (SSL) id YYB00155;
        Fri, 05 Mar 2021 13:22:55 +0800
Received: from GCY-EXS-15.TCL.com (10.74.128.165) by GCY-EXS-10.TCL.com
 (10.74.128.160) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 5 Mar 2021
 13:22:56 +0800
Received: from localhost.localdomain (172.16.34.11) by GCY-EXS-15.TCL.com
 (10.74.128.165) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 5 Mar 2021
 13:22:55 +0800
From:   Rokudo Yan <wu-yan@tcl.com>
To:     <gregkh@linuxfoundation.org>
CC:     <akpm@linux-foundation.org>, <minchan@kernel.org>,
        <sergey.senozhatsky@gmail.com>, <stable@vger.kernel.org>,
        <torvalds@linux-foundation.org>, <wu-yan@tcl.com>
Subject: Re: FAILED: patch "[PATCH] zsmalloc: account the number of compacted pages correctly" failed to apply to 4.14-stable tree
Date:   Fri, 5 Mar 2021 13:22:44 +0800
Message-ID: <20210305052244.2640301-1-wu-yan@tcl.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <161452062913468@kroah.com>
References: <161452062913468@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.16.34.11]
X-ClientProxiedBy: GCY-EXS-04.TCL.com (10.74.128.154) To GCY-EXS-15.TCL.com
 (10.74.128.165)
tUid:   2021305132255ac9e295c1d21cefe9dc783de22086bda
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2395928158059b8f9858365fce7713ce7fef62e4 backported to
4.14-stable tree.

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
 drivers/block/zram/zram_drv.c |  2 +-
 include/linux/zsmalloc.h      |  2 +-
 mm/zsmalloc.c                 | 17 +++++++++++------
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 0d906ca8d4f5..0798d6aacedd 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -738,7 +738,7 @@ static ssize_t mm_stat_show(struct device *dev,
 			zram->limit_pages << PAGE_SHIFT,
 			max_used << PAGE_SHIFT,
 			(u64)atomic64_read(&zram->stats.same_pages),
-			pool_stats.pages_compacted);
+			atomic_long_read(&pool_stats.pages_compacted));
 	up_read(&zram->init_lock);
 
 	return ret;
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 57a8e98f2708..6c871102c273 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -36,7 +36,7 @@ enum zs_mapmode {
 
 struct zs_pool_stats {
 	/* How many pages were migrated (freed) */
-	unsigned long pages_compacted;
+	atomic_long_t pages_compacted;
 };
 
 struct zs_pool;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index c6df483b3751..6ed736ea9b59 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -2281,11 +2281,13 @@ static unsigned long zs_can_compact(struct size_class *class)
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
@@ -2315,7 +2317,7 @@ static void __zs_compact(struct zs_pool *pool, struct size_class *class)
 		putback_zspage(class, dst_zspage);
 		if (putback_zspage(class, src_zspage) == ZS_EMPTY) {
 			free_zspage(pool, class, src_zspage);
-			pool->stats.pages_compacted += class->pages_per_zspage;
+			pages_freed += class->pages_per_zspage;
 		}
 		spin_unlock(&class->lock);
 		cond_resched();
@@ -2326,12 +2328,15 @@ static void __zs_compact(struct zs_pool *pool, struct size_class *class)
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
@@ -2339,10 +2344,11 @@ unsigned long zs_compact(struct zs_pool *pool)
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
 
@@ -2359,13 +2365,12 @@ static unsigned long zs_shrinker_scan(struct shrinker *shrinker,
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
-- 
2.25.1

