Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9095C649FA4
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiLLNNc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiLLNNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:13:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC9B12D2C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:12:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DA48B80D0C
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DFDC433EF;
        Mon, 12 Dec 2022 13:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850769;
        bh=BFf2XNrEiugRUeJYDBGPYs4xlKVOPZ7tLijc7lXclXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xNLj/a0+vmW6nofWYoFZ3uWWdQBFjVb1epeD0HIhs6iQVhMTpc9mDQl96P/FAquBX
         9VNcumna/Qvu/1u18KeTklVeEShrmlDpcycIS+NoNJ7IoxDs/ST3zGOkqxipluAHx+
         uluOU+zO81TtXitX7BC5rRzAUUimPcpLHyOe13Sw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Hugh Dickins <hughd@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        "Chen, Rong A" <rong.a.chen@intel.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "Huang, Ying" <ying.huang@intel.com>, Jann Horn <jannh@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Mel Gorman <mgorman@techsingularity.net>,
        Michal Hocko <mhocko@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        =?UTF-8?q?Mika=20Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Minchan Kim <minchan@kernel.org>,
        Shakeel Butt <shakeelb@google.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Wei Yang <richard.weiyang@gmail.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 004/106] mm/compaction: do page isolation first in compaction
Date:   Mon, 12 Dec 2022 14:09:07 +0100
Message-Id: <20221212130925.062376171@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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

From: Alex Shi <alex.shi@linux.alibaba.com>

[ Upstream commit 9df41314390b81a541ca6e84c8340bad0959e4b5 ]

Currently, compaction would get the lru_lock and then do page isolation
which works fine with pgdat->lru_lock, since any page isoltion would
compete for the lru_lock.  If we want to change to memcg lru_lock, we have
to isolate the page before getting lru_lock, thus isoltion would block
page's memcg change which relay on page isoltion too.  Then we could
safely use per memcg lru_lock later.

The new page isolation use previous introduced TestClearPageLRU() + pgdat
lru locking which will be changed to memcg lru lock later.

Hugh Dickins <hughd@google.com> fixed following bugs in this patch's early
version:

Fix lots of crashes under compaction load: isolate_migratepages_block()
must clean up appropriately when rejecting a page, setting PageLRU again
if it had been cleared; and a put_page() after get_page_unless_zero()
cannot safely be done while holding locked_lruvec - it may turn out to be
the final put_page(), which will take an lruvec lock when PageLRU.

And move __isolate_lru_page_prepare back after get_page_unless_zero to
make trylock_page() safe: trylock_page() is not safe to use at this time:
its setting PG_locked can race with the page being freed or allocated
("Bad page"), and can also erase flags being set by one of those "sole
owners" of a freshly allocated page who use non-atomic __SetPageFlag().

Link: https://lkml.kernel.org/r/1604566549-62481-16-git-send-email-alex.shi@linux.alibaba.com
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttilä <mika.penttila@nextfour.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 829ae0f81ce0 ("mm: migrate: fix THP's mapcount on isolation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/swap.h |  2 +-
 mm/compaction.c      | 42 +++++++++++++++++++++++++++++++++---------
 mm/vmscan.c          | 43 ++++++++++++++++++++++---------------------
 3 files changed, 56 insertions(+), 31 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index fbc6805358da..3577d3a6ec37 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -358,7 +358,7 @@ extern void lru_cache_add_inactive_or_unevictable(struct page *page,
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
-extern int __isolate_lru_page(struct page *page, isolate_mode_t mode);
+extern int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
diff --git a/mm/compaction.c b/mm/compaction.c
index 8dfbe86bd74f..ba3e907f03b7 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -890,6 +890,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (!valid_page && IS_ALIGNED(low_pfn, pageblock_nr_pages)) {
 			if (!cc->ignore_skip_hint && get_pageblock_skip(page)) {
 				low_pfn = end_pfn;
+				page = NULL;
 				goto isolate_abort;
 			}
 			valid_page = page;
@@ -971,6 +972,21 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (!(cc->gfp_mask & __GFP_FS) && page_mapping(page))
 			goto isolate_fail;
 
+		/*
+		 * Be careful not to clear PageLRU until after we're
+		 * sure the page is not being freed elsewhere -- the
+		 * page release code relies on it.
+		 */
+		if (unlikely(!get_page_unless_zero(page)))
+			goto isolate_fail;
+
+		if (__isolate_lru_page_prepare(page, isolate_mode) != 0)
+			goto isolate_fail_put;
+
+		/* Try isolate the page */
+		if (!TestClearPageLRU(page))
+			goto isolate_fail_put;
+
 		/* If we already hold the lock, we can skip some rechecking */
 		if (!locked) {
 			locked = compact_lock_irqsave(&pgdat->lru_lock,
@@ -983,10 +999,6 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 					goto isolate_abort;
 			}
 
-			/* Recheck PageLRU and PageCompound under lock */
-			if (!PageLRU(page))
-				goto isolate_fail;
-
 			/*
 			 * Page become compound since the non-locked check,
 			 * and it's on LRU. It can only be a THP so the order
@@ -994,16 +1006,13 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			 */
 			if (unlikely(PageCompound(page) && !cc->alloc_contig)) {
 				low_pfn += compound_nr(page) - 1;
-				goto isolate_fail;
+				SetPageLRU(page);
+				goto isolate_fail_put;
 			}
 		}
 
 		lruvec = mem_cgroup_page_lruvec(page, pgdat);
 
-		/* Try isolate the page */
-		if (__isolate_lru_page(page, isolate_mode) != 0)
-			goto isolate_fail;
-
 		/* The whole page is taken off the LRU; skip the tail pages. */
 		if (PageCompound(page))
 			low_pfn += compound_nr(page) - 1;
@@ -1032,6 +1041,15 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		}
 
 		continue;
+
+isolate_fail_put:
+		/* Avoid potential deadlock in freeing page under lru_lock */
+		if (locked) {
+			spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+			locked = false;
+		}
+		put_page(page);
+
 isolate_fail:
 		if (!skip_on_failure)
 			continue;
@@ -1068,9 +1086,15 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 	if (unlikely(low_pfn > end_pfn))
 		low_pfn = end_pfn;
 
+	page = NULL;
+
 isolate_abort:
 	if (locked)
 		spin_unlock_irqrestore(&pgdat->lru_lock, flags);
+	if (page) {
+		SetPageLRU(page);
+		put_page(page);
+	}
 
 	/*
 	 * Updated the cached scanner pfn once the pageblock has been scanned
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 8d62eedfc794..5ada402c8d95 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1545,7 +1545,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
  *
  * returns 0 on success, -ve errno on failure.
  */
-int __isolate_lru_page(struct page *page, isolate_mode_t mode)
+int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
 {
 	int ret = -EBUSY;
 
@@ -1597,22 +1597,9 @@ int __isolate_lru_page(struct page *page, isolate_mode_t mode)
 	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
 		return ret;
 
-	if (likely(get_page_unless_zero(page))) {
-		/*
-		 * Be careful not to clear PageLRU until after we're
-		 * sure the page is not being freed elsewhere -- the
-		 * page release code relies on it.
-		 */
-		if (TestClearPageLRU(page))
-			ret = 0;
-		else
-			put_page(page);
-	}
-
-	return ret;
+	return 0;
 }
 
-
 /*
  * Update LRU sizes after isolating pages. The LRU size updates must
  * be complete before mem_cgroup_update_lru_size due to a sanity check.
@@ -1692,20 +1679,34 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		 * only when the page is being freed somewhere else.
 		 */
 		scan += nr_pages;
-		switch (__isolate_lru_page(page, mode)) {
+		switch (__isolate_lru_page_prepare(page, mode)) {
 		case 0:
+			/*
+			 * Be careful not to clear PageLRU until after we're
+			 * sure the page is not being freed elsewhere -- the
+			 * page release code relies on it.
+			 */
+			if (unlikely(!get_page_unless_zero(page)))
+				goto busy;
+
+			if (!TestClearPageLRU(page)) {
+				/*
+				 * This page may in other isolation path,
+				 * but we still hold lru_lock.
+				 */
+				put_page(page);
+				goto busy;
+			}
+
 			nr_taken += nr_pages;
 			nr_zone_taken[page_zonenum(page)] += nr_pages;
 			list_move(&page->lru, dst);
 			break;
 
-		case -EBUSY:
+		default:
+busy:
 			/* else it is being freed elsewhere */
 			list_move(&page->lru, src);
-			continue;
-
-		default:
-			BUG();
 		}
 	}
 
-- 
2.35.1



