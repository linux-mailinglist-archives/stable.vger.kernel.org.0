Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED0C649FA3
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbiLLNNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232258AbiLLNNO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:13:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2743C13D11
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:12:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9DB8161042
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68453C433EF;
        Mon, 12 Dec 2022 13:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670850773;
        bh=EsTGvV0T6qqDOOQSJoitKIQ9hNR2MkrGTcsnOw00/PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BnopqCm7Lau9WKRqkJ6w19BQC0LwdXkFsDyx0IHsEtVD140a0agfhFlLR9WwL9W3O
         nOI76BSRf9wyAQqM5yYYc5wnLlWT2RwH4Re7O9/3G4iOByTZTx7Ck0Yl6pKQvJIL8H
         vmcc3RVfgGcOjcsJlBblRgJfPXmrMcu8MKHzzips=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Shi <alex.shi@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Hugh Dickins <hughd@google.com>, Yu Zhao <yuzhao@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/106] mm/vmscan: __isolate_lru_page_prepare() cleanup
Date:   Mon, 12 Dec 2022 14:09:08 +0100
Message-Id: <20221212130925.107973988@linuxfoundation.org>
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

[ Upstream commit c2135f7c570bc274035834848d9bf46ea89ba763 ]

The function just returns 2 results, so using a 'switch' to deal with its
result is unnecessary.  Also simplify it to a bool func as Vlastimil
suggested.

Also remove 'goto' by reusing list_move(), and take Matthew Wilcox's
suggestion to update comments in function.

Link: https://lkml.kernel.org/r/728874d7-2d93-4049-68c1-dcc3b2d52ccd@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: 829ae0f81ce0 ("mm: migrate: fix THP's mapcount on isolation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/swap.h |  2 +-
 mm/compaction.c      |  2 +-
 mm/vmscan.c          | 68 ++++++++++++++++++++------------------------
 3 files changed, 33 insertions(+), 39 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3577d3a6ec37..394d5de5d4b4 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -358,7 +358,7 @@ extern void lru_cache_add_inactive_or_unevictable(struct page *page,
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
-extern int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode);
+extern bool __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode);
 extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
diff --git a/mm/compaction.c b/mm/compaction.c
index ba3e907f03b7..ea46aadc7c21 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -980,7 +980,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (unlikely(!get_page_unless_zero(page)))
 			goto isolate_fail;
 
-		if (__isolate_lru_page_prepare(page, isolate_mode) != 0)
+		if (!__isolate_lru_page_prepare(page, isolate_mode))
 			goto isolate_fail_put;
 
 		/* Try isolate the page */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5ada402c8d95..00a47845a15b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1543,19 +1543,17 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
  * page:	page to consider
  * mode:	one of the LRU isolation modes defined above
  *
- * returns 0 on success, -ve errno on failure.
+ * returns true on success, false on failure.
  */
-int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
+bool __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
 {
-	int ret = -EBUSY;
-
 	/* Only take pages on the LRU. */
 	if (!PageLRU(page))
-		return ret;
+		return false;
 
 	/* Compaction should not handle unevictable pages but CMA can do so */
 	if (PageUnevictable(page) && !(mode & ISOLATE_UNEVICTABLE))
-		return ret;
+		return false;
 
 	/*
 	 * To minimise LRU disruption, the caller can indicate that it only
@@ -1568,7 +1566,7 @@ int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
 	if (mode & ISOLATE_ASYNC_MIGRATE) {
 		/* All the caller can do on PageWriteback is block */
 		if (PageWriteback(page))
-			return ret;
+			return false;
 
 		if (PageDirty(page)) {
 			struct address_space *mapping;
@@ -1584,20 +1582,20 @@ int __isolate_lru_page_prepare(struct page *page, isolate_mode_t mode)
 			 * from the page cache.
 			 */
 			if (!trylock_page(page))
-				return ret;
+				return false;
 
 			mapping = page_mapping(page);
 			migrate_dirty = !mapping || mapping->a_ops->migratepage;
 			unlock_page(page);
 			if (!migrate_dirty)
-				return ret;
+				return false;
 		}
 	}
 
 	if ((mode & ISOLATE_UNMAPPED) && page_mapped(page))
-		return ret;
+		return false;
 
-	return 0;
+	return true;
 }
 
 /*
@@ -1679,35 +1677,31 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		 * only when the page is being freed somewhere else.
 		 */
 		scan += nr_pages;
-		switch (__isolate_lru_page_prepare(page, mode)) {
-		case 0:
-			/*
-			 * Be careful not to clear PageLRU until after we're
-			 * sure the page is not being freed elsewhere -- the
-			 * page release code relies on it.
-			 */
-			if (unlikely(!get_page_unless_zero(page)))
-				goto busy;
-
-			if (!TestClearPageLRU(page)) {
-				/*
-				 * This page may in other isolation path,
-				 * but we still hold lru_lock.
-				 */
-				put_page(page);
-				goto busy;
-			}
-
-			nr_taken += nr_pages;
-			nr_zone_taken[page_zonenum(page)] += nr_pages;
-			list_move(&page->lru, dst);
-			break;
+		if (!__isolate_lru_page_prepare(page, mode)) {
+			/* It is being freed elsewhere */
+			list_move(&page->lru, src);
+			continue;
+		}
+		/*
+		 * Be careful not to clear PageLRU until after we're
+		 * sure the page is not being freed elsewhere -- the
+		 * page release code relies on it.
+		 */
+		if (unlikely(!get_page_unless_zero(page))) {
+			list_move(&page->lru, src);
+			continue;
+		}
 
-		default:
-busy:
-			/* else it is being freed elsewhere */
+		if (!TestClearPageLRU(page)) {
+			/* Another thread is already isolating this page */
+			put_page(page);
 			list_move(&page->lru, src);
+			continue;
 		}
+
+		nr_taken += nr_pages;
+		nr_zone_taken[page_zonenum(page)] += nr_pages;
+		list_move(&page->lru, dst);
 	}
 
 	/*
-- 
2.35.1



