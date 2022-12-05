Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B186433E9
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiLETkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbiLETkY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C4E6171
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:37:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 274DAB811F3
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:37:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD00C433C1;
        Mon,  5 Dec 2022 19:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269060;
        bh=6KHX93NsxOJc1GLQB89XPX9yd9l8NIXkkQY3XOaFqYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IgGBqk1Dp8t/ONLFkOrtAA+/4m5EJiQ0VMekiDbseYyNVCa/p4azrvk/Ju8c+MrvR
         hkvP1T0wZVTrM+tJLnH0RNRIo2kAwJJBNAKx2ySF93btjZaPo1vILY5vXFQqOFkoX0
         SKagHcKFnuSoDhEGV7XNn0CS5uIo3SOF99jMC04M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hugh Dickins <hughd@google.com>,
        David Rientjes <rientjes@google.com>,
        Alex Shi <alexs@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/120] mm: __isolate_lru_page_prepare() in isolate_migratepages_block()
Date:   Mon,  5 Dec 2022 20:10:43 +0100
Message-Id: <20221205190809.644443420@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

[ Upstream commit 89f6c88a6ab4a11deb14c270f7f1454cda4f73d6 ]

__isolate_lru_page_prepare() conflates two unrelated functions, with the
flags to one disjoint from the flags to the other; and hides some of the
important checks outside of isolate_migratepages_block(), where the
sequence is better to be visible.  It comes from the days of lumpy
reclaim, before compaction, when the combination made more sense.

Move what's needed by mm/compaction.c isolate_migratepages_block() inline
there, and what's needed by mm/vmscan.c isolate_lru_pages() inline there.

Shorten "isolate_mode" to "mode", so the sequence of conditions is easier
to read.  Declare a "mapping" variable, to save one call to page_mapping()
(but not another: calling again after page is locked is necessary).
Simplify isolate_lru_pages() with a "move_to" list pointer.

Link: https://lkml.kernel.org/r/879d62a8-91cc-d3c6-fb3b-69768236df68@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Alex Shi <alexs@kernel.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 829ae0f81ce0 ("mm: migrate: fix THP's mapcount on isolation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/swap.h |   1 -
 mm/compaction.c      |  51 +++++++++++++++++++---
 mm/vmscan.c          | 101 ++++++++-----------------------------------
 3 files changed, 62 insertions(+), 91 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index ba52f3a3478e..4efd267e2937 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -378,7 +378,6 @@ extern void lru_cache_add_inactive_or_unevictable(struct page *page,
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
-extern bool __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
diff --git a/mm/compaction.c b/mm/compaction.c
index 48a2111ce437..b6bd745a2f7f 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -779,7 +779,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
  * @cc:		Compaction control structure.
  * @low_pfn:	The first PFN to isolate
  * @end_pfn:	The one-past-the-last PFN to isolate, within same pageblock
- * @isolate_mode: Isolation mode to be used.
+ * @mode:	Isolation mode to be used.
  *
  * Isolate all pages that can be migrated from the range specified by
  * [low_pfn, end_pfn). The range is expected to be within same pageblock.
@@ -792,7 +792,7 @@ static bool too_many_isolated(pg_data_t *pgdat)
  */
 static int
 isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
-			unsigned long end_pfn, isolate_mode_t isolate_mode)
+			unsigned long end_pfn, isolate_mode_t mode)
 {
 	pg_data_t *pgdat = cc->zone->zone_pgdat;
 	unsigned long nr_scanned = 0, nr_isolated = 0;
@@ -800,6 +800,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 	unsigned long flags = 0;
 	struct lruvec *locked = NULL;
 	struct page *page = NULL, *valid_page = NULL;
+	struct address_space *mapping;
 	unsigned long start_pfn = low_pfn;
 	bool skip_on_failure = false;
 	unsigned long next_skip_pfn = 0;
@@ -984,7 +985,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					locked = NULL;
 				}
 
-				if (!isolate_movable_page(page, isolate_mode))
+				if (!isolate_movable_page(page, mode))
 					goto isolate_success;
 			}
 
@@ -996,15 +997,15 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		 * so avoid taking lru_lock and isolating it unnecessarily in an
 		 * admittedly racy check.
 		 */
-		if (!page_mapping(page) &&
-		    page_count(page) > page_mapcount(page))
+		mapping = page_mapping(page);
+		if (!mapping && page_count(page) > page_mapcount(page))
 			goto isolate_fail;
 
 		/*
 		 * Only allow to migrate anonymous pages in GFP_NOFS context
 		 * because those do not depend on fs locks.
 		 */
-		if (!(cc->gfp_mask & __GFP_FS) && page_mapping(page))
+		if (!(cc->gfp_mask & __GFP_FS) && mapping)
 			goto isolate_fail;
 
 		/*
@@ -1015,9 +1016,45 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (unlikely(!get_page_unless_zero(page)))
 			goto isolate_fail;
 
-		if (!__isolate_lru_page_prepare(page, isolate_mode))
+		/* Only take pages on LRU: a check now makes later tests safe */
+		if (!PageLRU(page))
+			goto isolate_fail_put;
+
+		/* Compaction might skip unevictable pages but CMA takes them */
+		if (!(mode & ISOLATE_UNEVICTABLE) && PageUnevictable(page))
+			goto isolate_fail_put;
+
+		/*
+		 * To minimise LRU disruption, the caller can indicate with
+		 * ISOLATE_ASYNC_MIGRATE that it only wants to isolate pages
+		 * it will be able to migrate without blocking - clean pages
+		 * for the most part.  PageWriteback would require blocking.
+		 */
+		if ((mode & ISOLATE_ASYNC_MIGRATE) && PageWriteback(page))
 			goto isolate_fail_put;
 
+		if ((mode & ISOLATE_ASYNC_MIGRATE) && PageDirty(page)) {
+			bool migrate_dirty;
+
+			/*
+			 * Only pages without mappings or that have a
+			 * ->migratepage callback are possible to migrate
+			 * without blocking. However, we can be racing with
+			 * truncation so it's necessary to lock the page
+			 * to stabilise the mapping as truncation holds
+			 * the page lock until after the page is removed
+			 * from the page cache.
+			 */
+			if (!trylock_page(page))
+				goto isolate_fail_put;
+
+			mapping = page_mapping(page);
+			migrate_dirty = !mapping || mapping->a_ops->migratepage;
+			unlock_page(page);
+			if (!migrate_dirty)
+				goto isolate_fail_put;
+		}
+
 		/* Try isolate the page */
 		if (!TestClearPageLRU(page))
 			goto isolate_fail_put;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1b63d6155416..201acea81804 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1865,69 +1865,6 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 	return nr_reclaimed;
 }
 
-/*
- * Attempt to remove the specified page from its LRU.  Only take this page
- * if it is of the appropriate PageActive status.  Pages which are being
- * freed elsewhere are also ignored.
- *
- * page:	page to consider
- * mode:	one of the LRU isolation modes defined above
- *
- * returns true on success, false on failure.
- */
-bool __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
-{
-	/* Only take pages on the LRU. */
-	if (!PageLRU(page))
-		return false;
-
-	/* Compaction should not handle unevictable pages but CMA can do so */
-	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
-		return false;
-
-	/*
-	 * To minimise LRU disruption, the caller can indicate that it only
-	 * wants to isolate pages it will be able to operate on without
-	 * blocking - clean pages for the most part.
-	 *
-	 * ISOLATE_ASYNC_MIGRATE is used to indicate that it only wants to pages
-	 * that it is possible to migrate without blocking
-	 */
-	if (mode & ISOLATE_ASYNC_MIGRATE) {
-		/* All the caller can do on PageWriteback is block */
-		if (PageWriteback(page))
-			return false;
-
-		if (PageDirty(page)) {
-			struct address_space *mapping;
-			bool migrate_dirty;
-
-			/*
-			 * Only pages without mappings or that have a
-			 * ->migratepage callback are possible to migrate
-			 * without blocking. However, we can be racing with
-			 * truncation so it's necessary to lock the page
-			 * to stabilise the mapping as truncation holds
-			 * the page lock until after the page is removed
-			 * from the page cache.
-			 */
-			if (!trylock_page(page))
-				return false;
-
-			mapping = page_mapping(page);
-			migrate_dirty = !mapping || mapping->a_ops->migratepage;
-			unlock_page(page);
-			if (!migrate_dirty)
-				return false;
-		}
-	}
-
-	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
-		return false;
-
-	return true;
-}
-
 /*
  * Update LRU sizes after isolating pages. The LRU size updates must
  * be complete before mem_cgroup_update_lru_size due to a sanity check.
@@ -1979,11 +1916,11 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 	unsigned long skipped = 0;
 	unsigned long scan, total_scan, nr_pages;
 	LIST_HEAD(pages_skipped);
-	isolate_mode_t mode = (sc->may_unmap ? 0 : ISOLATE_UNMAPPED);
 
 	total_scan = 0;
 	scan = 0;
 	while (scan < nr_to_scan && !list_empty(src)) {
+		struct list_head *move_to = src;
 		struct page *page;
 
 		page = lru_to_page(src);
@@ -1993,9 +1930,9 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		total_scan += nr_pages;
 
 		if (page_zonenum(page) > sc->reclaim_idx) {
-			list_move(&page->lru, &pages_skipped);
 			nr_skipped[page_zonenum(page)] += nr_pages;
-			continue;
+			move_to = &pages_skipped;
+			goto move;
 		}
 
 		/*
@@ -2003,37 +1940,34 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		 * return with no isolated pages if the LRU mostly contains
 		 * ineligible pages.  This causes the VM to not reclaim any
 		 * pages, triggering a premature OOM.
-		 *
-		 * Account all tail pages of THP.  This would not cause
-		 * premature OOM since __isolate_lru_page() returns -EBUSY
-		 * only when the page is being freed somewhere else.
+		 * Account all tail pages of THP.
 		 */
 		scan += nr_pages;
-		if (!__isolate_lru_page_prepare(page, mode)) {
-			/* It is being freed elsewhere */
-			list_move(&page->lru, src);
-			continue;
-		}
+
+		if (!PageLRU(page))
+			goto move;
+		if (!sc->may_unmap && page_mapped(page))
+			goto move;
+
 		/*
 		 * Be careful not to clear PageLRU until after we're
 		 * sure the page is not being freed elsewhere -- the
 		 * page release code relies on it.
 		 */
-		if (unlikely(!get_page_unless_zero(page))) {
-			list_move(&page->lru, src);
-			continue;
-		}
+		if (unlikely(!get_page_unless_zero(page)))
+			goto move;
 
 		if (!TestClearPageLRU(page)) {
 			/* Another thread is already isolating this page */
 			put_page(page);
-			list_move(&page->lru, src);
-			continue;
+			goto move;
 		}
 
 		nr_taken += nr_pages;
 		nr_zone_taken[page_zonenum(page)] += nr_pages;
-		list_move(&page->lru, dst);
+		move_to = dst;
+move:
+		list_move(&page->lru, move_to);
 	}
 
 	/*
@@ -2057,7 +1991,8 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 	}
 	*nr_scanned = total_scan;
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
-				    total_scan, skipped, nr_taken, mode, lru);
+				    total_scan, skipped, nr_taken,
+				    sc->may_unmap ? 0 : ISOLATE_UNMAPPED, lru);
 	update_lru_sizes(lruvec, lru, nr_zone_taken);
 	return nr_taken;
 }
-- 
2.35.1



