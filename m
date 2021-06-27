Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BC53B5556
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 23:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhF0Vzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 17:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231768AbhF0Vzo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 17:55:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA5B461A1D;
        Sun, 27 Jun 2021 21:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830799;
        bh=d1/GCIZDvobJoHIGkhoGVpGTwgQ8R+haafKe1Kf4zOE=;
        h=Date:From:To:Subject:From;
        b=W8l8gp1NCYuvh3mpkSqIheitNp0TxtD/19EwH66FFN2dKUu21wGE7ShMZl7DZHqv8
         pjMwWLdsWR0IF7XG3xaXFpWh6U1s0ZHlZDQZ/O5/WwTBLovNJP8eOMWpS/2Z4nK14X
         gsDpe2tpkihLeVYu8SDCDFEGsbGcJEw48EDO9xSE=
Date:   Sun, 27 Jun 2021 14:53:18 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com, jack@suse.cz,
        juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com, stable@vger.kernel.org,
        wangyugui@e16-tech.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-thp-replace-debug_vm-bug-with-vm_warn-when-unmap-fails-for-split.patch
 removed from -mm tree
Message-ID: <20210627215318._aqb_uDbh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split
has been removed from the -mm tree.  Its filename was
     mm-thp-replace-debug_vm-bug-with-vm_warn-when-unmap-fails-for-split.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: thp: replace DEBUG_VM BUG with VM_WARN when unmap fails for split

When debugging the bug reported by Wang Yugui [1], try_to_unmap() may
fail, but the first VM_BUG_ON_PAGE() just checks page_mapcount() however
it may miss the failure when head page is unmapped but other subpage is
mapped.  Then the second DEBUG_VM BUG() that check total mapcount would
catch it.  This may incur some confusion.  And this is not a fatal issue,
so consolidate the two DEBUG_VM checks into one VM_WARN_ON_ONCE_PAGE().

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
---

 mm/huge_memory.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

--- a/mm/huge_memory.c~mm-thp-replace-debug_vm-bug-with-vm_warn-when-unmap-fails-for-split
+++ a/mm/huge_memory.c
@@ -2352,15 +2352,15 @@ static void unmap_page(struct page *page
 {
 	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK | TTU_SYNC |
 		TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD;
-	bool unmap_success;
 
 	VM_BUG_ON_PAGE(!PageHead(page), page);
 
 	if (PageAnon(page))
 		ttu_flags |= TTU_SPLIT_FREEZE;
 
-	unmap_success = try_to_unmap(page, ttu_flags);
-	VM_BUG_ON_PAGE(!unmap_success, page);
+	try_to_unmap(page, ttu_flags);
+
+	VM_WARN_ON_ONCE_PAGE(page_mapped(page), page);
 }
 
 static void remap_page(struct page *page, unsigned int nr)
@@ -2671,7 +2671,7 @@ int split_huge_page_to_list(struct page
 	struct deferred_split *ds_queue = get_deferred_split_queue(head);
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
-	int count, mapcount, extra_pins, ret;
+	int extra_pins, ret;
 	pgoff_t end;
 
 	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
@@ -2730,7 +2730,6 @@ int split_huge_page_to_list(struct page
 	}
 
 	unmap_page(head);
-	VM_BUG_ON_PAGE(compound_mapcount(head), head);
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
@@ -2748,9 +2747,7 @@ int split_huge_page_to_list(struct page
 
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	spin_lock(&ds_queue->split_queue_lock);
-	count = page_count(head);
-	mapcount = total_mapcount(head);
-	if (!mapcount && page_ref_freeze(head, 1 + extra_pins)) {
+	if (page_ref_freeze(head, 1 + extra_pins)) {
 		if (!list_empty(page_deferred_list(head))) {
 			ds_queue->split_queue_len--;
 			list_del(page_deferred_list(head));
@@ -2770,16 +2767,9 @@ int split_huge_page_to_list(struct page
 		__split_huge_page(page, list, end);
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
 		spin_unlock(&ds_queue->split_queue_lock);
-fail:		if (mapping)
+fail:
+		if (mapping)
 			xa_unlock(&mapping->i_pages);
 		local_irq_enable();
 		remap_page(head, thp_nr_pages(head));
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-mempolicy-dont-have-to-split-pmd-for-huge-zero-page.patch
mm-memory-add-orig_pmd-to-struct-vm_fault.patch
mm-memory-make-numa_migrate_prep-non-static.patch
mm-thp-refactor-numa-fault-handling.patch
mm-migrate-account-thp-numa-migration-counters-correctly.patch
mm-migrate-dont-split-thp-for-misplaced-numa-page.patch
mm-migrate-check-mapcount-for-thp-instead-of-refcount.patch
mm-thp-skip-make-pmd-prot_none-if-thp-migration-is-not-supported.patch
mm-rmap-make-try_to_unmap-void-function.patch

