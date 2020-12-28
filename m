Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C90472E4058
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437909AbgL1OuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:50:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:55430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437760AbgL1OUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF416224D2;
        Mon, 28 Dec 2020 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165208;
        bh=Z8PETxuY5AMWFlrnQF+Ox5F8Y3Kvpa5/eHjZE3FU6TM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JJHoO48lDr3FBKak/hU4AUi/CLsdELOheOHkI8AbnsMndCtiJ6o1QHQRT1eRPGRK5
         fJmLunt1T+/MG8/HSj5jTsUyqj9m4SEAe8D9qmWwSeFCPJMjKjwsPjqlqBdxwyKDaW
         TpY4TW9RCoLVCcGYwiSx2pUfxFPBoF56PRcwV8Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 451/717] mm/rmap: always do TTU_IGNORE_ACCESS
Date:   Mon, 28 Dec 2020 13:47:29 +0100
Message-Id: <20201228125042.581126869@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shakeel Butt <shakeelb@google.com>

[ Upstream commit 013339df116c2ee0d796dd8bfb8f293a2030c063 ]

Since commit 369ea8242c0f ("mm/rmap: update to new mmu_notifier semantic
v2"), the code to check the secondary MMU's page table access bit is
broken for !(TTU_IGNORE_ACCESS) because the page is unmapped from the
secondary MMU's page table before the check.  More specifically for those
secondary MMUs which unmap the memory in
mmu_notifier_invalidate_range_start() like kvm.

However memory reclaim is the only user of !(TTU_IGNORE_ACCESS) or the
absence of TTU_IGNORE_ACCESS and it explicitly performs the page table
access check before trying to unmap the page.  So, at worst the reclaim
will miss accesses in a very short window if we remove page table access
check in unmapping code.

There is an unintented consequence of !(TTU_IGNORE_ACCESS) for the memcg
reclaim.  From memcg reclaim the page_referenced() only account the
accesses from the processes which are in the same memcg of the target page
but the unmapping code is considering accesses from all the processes, so,
decreasing the effectiveness of memcg reclaim.

The simplest solution is to always assume TTU_IGNORE_ACCESS in unmapping
code.

Link: https://lkml.kernel.org/r/20201104231928.1494083-1-shakeelb@google.com
Fixes: 369ea8242c0f ("mm/rmap: update to new mmu_notifier semantic v2")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rmap.h |  1 -
 mm/huge_memory.c     |  2 +-
 mm/memory-failure.c  |  2 +-
 mm/memory_hotplug.c  |  2 +-
 mm/migrate.c         |  8 +++-----
 mm/rmap.c            |  9 ---------
 mm/vmscan.c          | 14 +++++---------
 7 files changed, 11 insertions(+), 27 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 3a6adfa70fb0e..70085ca1a3fc9 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -91,7 +91,6 @@ enum ttu_flags {
 
 	TTU_SPLIT_HUGE_PMD	= 0x4,	/* split huge PMD if any */
 	TTU_IGNORE_MLOCK	= 0x8,	/* ignore mlock */
-	TTU_IGNORE_ACCESS	= 0x10,	/* don't age */
 	TTU_IGNORE_HWPOISON	= 0x20,	/* corrupted page is recoverable */
 	TTU_BATCH_FLUSH		= 0x40,	/* Batch TLB flushes where possible
 					 * and caller guarantees they will
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ec2bb93f74314..85eda66eb625d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2321,7 +2321,7 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
 
 static void unmap_page(struct page *page)
 {
-	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS |
+	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK |
 		TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD;
 	bool unmap_success;
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5d880d4eb9a26..71295bb984af6 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -989,7 +989,7 @@ static int get_hwpoison_page(struct page *page)
 static bool hwpoison_user_mappings(struct page *p, unsigned long pfn,
 				  int flags, struct page **hpagep)
 {
-	enum ttu_flags ttu = TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
+	enum ttu_flags ttu = TTU_IGNORE_MLOCK;
 	struct address_space *mapping;
 	LIST_HEAD(tokill);
 	bool unmap_success = true;
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 63b2e46b65552..0f855deea4b2d 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1304,7 +1304,7 @@ do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 			if (WARN_ON(PageLRU(page)))
 				isolate_lru_page(page);
 			if (page_mapped(page))
-				try_to_unmap(page, TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS);
+				try_to_unmap(page, TTU_IGNORE_MLOCK);
 			continue;
 		}
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 5795cb82e27c3..8ea0c65f10756 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1122,8 +1122,7 @@ static int __unmap_and_move(struct page *page, struct page *newpage,
 		/* Establish migration ptes */
 		VM_BUG_ON_PAGE(PageAnon(page) && !PageKsm(page) && !anon_vma,
 				page);
-		try_to_unmap(page,
-			TTU_MIGRATION|TTU_IGNORE_MLOCK|TTU_IGNORE_ACCESS);
+		try_to_unmap(page, TTU_MIGRATION|TTU_IGNORE_MLOCK);
 		page_was_mapped = 1;
 	}
 
@@ -1329,8 +1328,7 @@ static int unmap_and_move_huge_page(new_page_t get_new_page,
 
 	if (page_mapped(hpage)) {
 		bool mapping_locked = false;
-		enum ttu_flags ttu = TTU_MIGRATION|TTU_IGNORE_MLOCK|
-					TTU_IGNORE_ACCESS;
+		enum ttu_flags ttu = TTU_MIGRATION|TTU_IGNORE_MLOCK;
 
 		if (!PageAnon(hpage)) {
 			/*
@@ -2688,7 +2686,7 @@ static void migrate_vma_prepare(struct migrate_vma *migrate)
  */
 static void migrate_vma_unmap(struct migrate_vma *migrate)
 {
-	int flags = TTU_MIGRATION | TTU_IGNORE_MLOCK | TTU_IGNORE_ACCESS;
+	int flags = TTU_MIGRATION | TTU_IGNORE_MLOCK;
 	const unsigned long npages = migrate->npages;
 	const unsigned long start = migrate->start;
 	unsigned long addr, i, restore = 0;
diff --git a/mm/rmap.c b/mm/rmap.c
index 31b29321adfe1..6657000b18d41 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1533,15 +1533,6 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 			goto discard;
 		}
 
-		if (!(flags & TTU_IGNORE_ACCESS)) {
-			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte)) {
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
-			}
-		}
-
 		/* Nuke the page table entry. */
 		flush_cache_page(vma, address, pte_pfn(*pvmw.pte));
 		if (should_defer_flush(mm, flags)) {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7b4e31eac2cff..0ec6321e98878 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1072,7 +1072,6 @@ static void page_check_dirty_writeback(struct page *page,
 static unsigned int shrink_page_list(struct list_head *page_list,
 				     struct pglist_data *pgdat,
 				     struct scan_control *sc,
-				     enum ttu_flags ttu_flags,
 				     struct reclaim_stat *stat,
 				     bool ignore_references)
 {
@@ -1297,7 +1296,7 @@ static unsigned int shrink_page_list(struct list_head *page_list,
 		 * processes. Try to unmap it here.
 		 */
 		if (page_mapped(page)) {
-			enum ttu_flags flags = ttu_flags | TTU_BATCH_FLUSH;
+			enum ttu_flags flags = TTU_BATCH_FLUSH;
 			bool was_swapbacked = PageSwapBacked(page);
 
 			if (unlikely(PageTransHuge(page)))
@@ -1514,7 +1513,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
 	}
 
 	nr_reclaimed = shrink_page_list(&clean_pages, zone->zone_pgdat, &sc,
-			TTU_IGNORE_ACCESS, &stat, true);
+					&stat, true);
 	list_splice(&clean_pages, page_list);
 	mod_node_page_state(zone->zone_pgdat, NR_ISOLATED_FILE,
 			    -(long)nr_reclaimed);
@@ -1958,8 +1957,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (nr_taken == 0)
 		return 0;
 
-	nr_reclaimed = shrink_page_list(&page_list, pgdat, sc, 0,
-				&stat, false);
+	nr_reclaimed = shrink_page_list(&page_list, pgdat, sc, &stat, false);
 
 	spin_lock_irq(&pgdat->lru_lock);
 
@@ -2131,8 +2129,7 @@ unsigned long reclaim_pages(struct list_head *page_list)
 
 		nr_reclaimed += shrink_page_list(&node_page_list,
 						NODE_DATA(nid),
-						&sc, 0,
-						&dummy_stat, false);
+						&sc, &dummy_stat, false);
 		while (!list_empty(&node_page_list)) {
 			page = lru_to_page(&node_page_list);
 			list_del(&page->lru);
@@ -2145,8 +2142,7 @@ unsigned long reclaim_pages(struct list_head *page_list)
 	if (!list_empty(&node_page_list)) {
 		nr_reclaimed += shrink_page_list(&node_page_list,
 						NODE_DATA(nid),
-						&sc, 0,
-						&dummy_stat, false);
+						&sc, &dummy_stat, false);
 		while (!list_empty(&node_page_list)) {
 			page = lru_to_page(&node_page_list);
 			list_del(&page->lru);
-- 
2.27.0



