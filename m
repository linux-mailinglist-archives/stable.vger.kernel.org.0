Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF12D3C2434
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 15:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhGINVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 09:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231937AbhGINVc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 09:21:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7215613C0;
        Fri,  9 Jul 2021 13:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1625836729;
        bh=bNSmK2y1b/XZc5iNW3WFr4NxiD4+Gxx1It4MXlJlVeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G3fA6IIc3xNR/Y0NMG+sjWK2zO5mcvpDrpQ3TbpAmiOJV2MsIDzUl+RNvzKVP+K79
         IFiX3jm1BTzI3h0UiALZZ33h/f/7m/NV63/p1ERBM6Aw87+aexUW6GCPetJwwJTeMz
         dBEiLt3kSichzEP+m/kVjkUTCICOGpRDoLVHdih4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Shi <shy828301@gmail.com>,
        Zi Yan <ziy@nvidia.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>,
        Alistair Popple <apopple@nvidia.com>, Jan Kara <jack@suse.cz>,
        Jue Wang <juew@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Minchan Kim <minchan@kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Xu <peterx@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Shakeel Butt <shakeelb@google.com>,
        Wang Yugui <wangyugui@e16-tech.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 3/9] mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
Date:   Fri,  9 Jul 2021 15:18:30 +0200
Message-Id: <20210709131547.603899343@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709131542.410636747@linuxfoundation.org>
References: <20210709131542.410636747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>

[ Upstream commit 504e070dc08f757bccaed6d05c0f53ecbfac8a23 ]

When debugging the bug reported by Wang Yugui [1], try_to_unmap() may
fail, but the first VM_BUG_ON_PAGE() just checks page_mapcount() however
it may miss the failure when head page is unmapped but other subpage is
mapped.  Then the second DEBUG_VM BUG() that check total mapcount would
catch it.  This may incur some confusion.

As this is not a fatal issue, so consolidate the two DEBUG_VM checks
into one VM_WARN_ON_ONCE_PAGE().

[1] https://lore.kernel.org/linux-mm/20210412180659.B9E3.409509F4@e16-tech.com/

Link: https://lkml.kernel.org/r/d0f0db68-98b8-ebfb-16dc-f29df24cf012@google.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jue Wang <juew@google.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Note on stable backport: fixed up variables, split_queue_lock, tree_lock
in split_huge_page_to_list(); adapted to early version of unmap_page().

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 14cd0ef33b62..177ca028b986 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1891,7 +1891,7 @@ static void unmap_page(struct page *page)
 {
 	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS |
 		TTU_RMAP_LOCKED;
-	int i, ret;
+	int i;
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
@@ -1899,15 +1899,16 @@ static void unmap_page(struct page *page)
 		ttu_flags |= TTU_MIGRATION;
 
 	/* We only need TTU_SPLIT_HUGE_PMD once */
-	ret = try_to_unmap(page, ttu_flags | TTU_SPLIT_HUGE_PMD);
-	for (i = 1; !ret && i < HPAGE_PMD_NR; i++) {
+	try_to_unmap(page, ttu_flags | TTU_SPLIT_HUGE_PMD);
+	for (i = 1; i < HPAGE_PMD_NR; i++) {
 		/* Cut short if the page is unmapped */
 		if (page_count(page) == 1)
 			return;
 
-		ret = try_to_unmap(page + i, ttu_flags);
+		try_to_unmap(page + i, ttu_flags);
 	}
-	VM_BUG_ON_PAGE(ret, page + i - 1);
+
+	VM_WARN_ON_ONCE_PAGE(page_mapped(page), page);
 }
 
 static void remap_page(struct page *page)
@@ -2137,7 +2138,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	struct pglist_data *pgdata = NODE_DATA(page_to_nid(head));
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
-	int count, mapcount, extra_pins, ret;
+	int extra_pins, ret;
 	bool mlocked;
 	unsigned long flags;
 	pgoff_t end;
@@ -2200,7 +2201,6 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 
 	mlocked = PageMlocked(page);
 	unmap_page(head);
-	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
 	/* Make sure the page is not on per-CPU pagevec as it takes pin */
 	if (mlocked)
@@ -2226,9 +2226,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&pgdata->split_queue_lock);
-	count = page_count(head);
-	mapcount = total_mapcount(head);
-	if (!mapcount && page_ref_freeze(head, 1 + extra_pins)) {
+	if (page_ref_freeze(head, 1 + extra_pins)) {
 		if (!list_empty(page_deferred_list(head))) {
 			pgdata->split_queue_len--;
 			list_del(page_deferred_list(head));
@@ -2239,16 +2237,9 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 		__split_huge_page(page, list, end, flags);
 		ret = 0;
 	} else {
-		if (IS_ENABLED(CONFIG_DEBUG_VM) && mapcount) {
-			pr_alert("total_mapcount: %u, page_count(): %u\n",
-					mapcount, count);
-			if (PageTail(page))
-				dump_page(head, NULL);
-			dump_page(page, "total_mapcount(head) > 0");
-			BUG();
-		}
 		spin_unlock(&pgdata->split_queue_lock);
-fail:		if (mapping)
+fail:
+		if (mapping)
 			spin_unlock(&mapping->tree_lock);
 		spin_unlock_irqrestore(zone_lru_lock(page_zone(head)), flags);
 		remap_page(head);
-- 
2.30.2



