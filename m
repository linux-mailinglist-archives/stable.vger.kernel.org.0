Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A9C34BE3C
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 20:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhC1S1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 14:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhC1S0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Mar 2021 14:26:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7706E61949;
        Sun, 28 Mar 2021 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616956014;
        bh=pnNWdIME3IeQCaaZLvUUJ9mzGHwuJwgUsQCR6MKF9mk=;
        h=Date:From:To:Subject:From;
        b=bvk2KbDGP1c+uNY6X7OhodNtIqfy78+SnInIDLgyNyF5CFqPGN7vi/uZhv1Ix2Dsl
         oHDjxykTHavxH740kCyBR+8S0Kdg/1iLv1IBx0meAmbkPJTEbcz7H+cxAUg7E7mn9Z
         0WtTvU/vKF7g2gfpYAmXa8httDyu+2OsI6mxTI1Q=
Date:   Sun, 28 Mar 2021 11:26:53 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com,
        stable@vger.kernel.org, willy@infradead.org,
        zhouguanghui1@huawei.com, ziy@nvidia.com
Subject:  [to-be-updated]
 mm-page_alloc-fix-memcg-accounting-leak-in-speculative-cache-lookup.patch
 removed from -mm tree
Message-ID: <20210328182653.u2dXqlPMl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: fix allocation imbalances from speculative cache lookup
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-memcg-accounting-leak-in-speculative-cache-lookup.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: fix allocation imbalances from speculative cache lookup

When the freeing of a higher-order page block (non-compound) races with a
speculative page cache lookup, __free_pages() needs to leave the first
order-0 page in the chunk to the lookup but free the buddy pages that the
lookup doesn't know about separately.

There are currently two problems with it:

1. It checks PageHead() to see whether we're dealing with a compound
   page after put_page_testzero().  But the speculative lookup could have
   freed the page after our put and cleared PageHead, in which case we
   would double free the tail pages.

   To fix this, test PageHead before the put and cache the result for
   afterwards.

2. If such a higher-order page is charged to a memcg (e.g.  !vmap
   kernel stack)), only the first page of the block has page->memcg set. 
   That means we'll uncharge only one order-0 page from the entire block,
   and leak the remainder.

   To fix this, add a split_page_memcg() before it starts freeing tail
   pages, to ensure they all have page->memcg set up.

While at it, also update the comments a bit to clarify what exactly is
happening to the page during that race.

Link: https://lkml.kernel.org/r/20210319071547.60973-1-hannes@cmpxchg.org
Fixes: e320d3012d25 ("mm/page_alloc.c: fix freeing non-compound pages")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Hugh Dickins <hughd@google.com>
Reported-by: Matthew Wilcox <willy@infradead.org>
Acked-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Hugh Dickins <hughd@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Zhou Guanghui <zhouguanghui1@huawei.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-memcg-accounting-leak-in-speculative-cache-lookup
+++ a/mm/page_alloc.c
@@ -5072,10 +5072,9 @@ static inline void free_the_page(struct
  * the allocation, so it is easy to leak memory.  Freeing more memory
  * than was allocated will probably emit a warning.
  *
- * If the last reference to this page is speculative, it will be released
- * by put_page() which only frees the first page of a non-compound
- * allocation.  To prevent the remaining pages from being leaked, we free
- * the subsequent pages here.  If you want to use the page's reference
+ * This function isn't a put_page(). Don't let the put_page_testzero()
+ * fool you, it's only to deal with speculative cache references. It
+ * WILL free pages directly. If you want to use the page's reference
  * count to decide when to free the allocation, you should allocate a
  * compound page, and use put_page() instead of __free_pages().
  *
@@ -5084,11 +5083,33 @@ static inline void free_the_page(struct
  */
 void __free_pages(struct page *page, unsigned int order)
 {
-	if (put_page_testzero(page))
+	/*
+	 * Drop the base reference from __alloc_pages and free. In
+	 * case there is an outstanding speculative reference, from
+	 * e.g. the page cache, it will put and free the page later.
+	 */
+	if (likely(put_page_testzero(page))) {
 		free_the_page(page, order);
-	else if (!PageHead(page))
+		return;
+	}
+
+	/*
+	 * The speculative reference will put and free the page.
+	 *
+	 * However, if the speculation was into a higher-order page
+	 * chunk that isn't marked compound, the other side will know
+	 * nothing about our buddy pages and only free the order-0
+	 * page at the start of our chunk! We must split off and free
+	 * the buddy pages here.
+	 *
+	 * The buddy pages aren't individually refcounted, so they
+	 * can't have any pending speculative references themselves.
+	 */
+	if (!PageHead(page) && order > 0) {
+		split_page_memcg(page, 1 << order);
 		while (order-- > 0)
 			free_the_page(page + (1 << order), order);
+	}
 }
 EXPORT_SYMBOL(__free_pages);
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page_alloc-fix-allocation-imbalances-from-speculative-cache-lookup.patch
mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback.patch
mm-memcontrol-fix-cpuhotplug-statistics-flushing.patch
mm-memcontrol-kill-mem_cgroup_nodeinfo.patch
mm-memcontrol-privatize-memcg_page_state-query-functions.patch
cgroup-rstat-support-cgroup1.patch
cgroup-rstat-punt-root-level-optimization-to-individual-controllers.patch
mm-memcontrol-switch-to-rstat.patch
mm-memcontrol-switch-to-rstat-fix-2.patch
mm-memcontrol-consolidate-lruvec-stat-flushing.patch
kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch

