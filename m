Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23AB13B5554
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 23:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbhF0Vzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 17:55:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhF0Vzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 17:55:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE9E461A1D;
        Sun, 27 Jun 2021 21:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830787;
        bh=55PmWQwAkkR+X20Xc1zM57xFDNl9pWWPNBTP/LwoHs4=;
        h=Date:From:To:Subject:From;
        b=XNXk0Rj9bwnziZvPMU53DTemygymG36biuloPI8/i7Yeuzv56YJUNsajezPb3pcPG
         lkg04bTGPdf7cVKaA8BOKPPlHcWUhiFf1pdTrLsWBLDvAL6NWt8sujvBSMHXH8Wrb0
         74JyYTC1sPHo4k2OVPj3tve04vjrp9UzaSaKBkjc=
Date:   Sun, 27 Jun 2021 14:53:06 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com, jack@suse.cz,
        juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com, stable@vger.kernel.org,
        wangyugui@e16-tech.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-thp-try_to_unmap-use-ttu_sync-for-safe-splitting.patch removed from -mm
 tree
Message-ID: <20210627215306.pROuDx9FV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
has been removed from the -mm tree.  Its filename was
     mm-thp-try_to_unmap-use-ttu_sync-for-safe-splitting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: try_to_unmap() use TTU_SYNC for safe splitting

Stressing huge tmpfs often crashed on unmap_page()'s VM_BUG_ON_PAGE
(!unmap_success): with dump_page() showing mapcount:1, but then its raw
struct page output showing _mapcount ffffffff i.e.  mapcount 0.

And even if that particular VM_BUG_ON_PAGE(!unmap_success) is removed, it
is immediately followed by a VM_BUG_ON_PAGE(compound_mapcount(head)), and
further down an IS_ENABLED(CONFIG_DEBUG_VM) total_mapcount BUG(): all
indicative of some mapcount difficulty in development here perhaps.  But
the !CONFIG_DEBUG_VM path handles the failures correctly and silently.

I believe the problem is that once a racing unmap has cleared pte or pmd,
try_to_unmap_one() may skip taking the page table lock, and emerge from
try_to_unmap() before the racing task has reached decrementing mapcount.

Instead of abandoning the unsafe VM_BUG_ON_PAGE(), and the ones that
follow, use PVMW_SYNC in try_to_unmap_one() in this case: adding TTU_SYNC
to the options, and passing that from unmap_page().

When CONFIG_DEBUG_VM, or for non-debug too?  Consensus is to do the same
for both: the slight overhead added should rarely matter, except perhaps
if splitting sparsely-populated multiply-mapped shmem.  Once confident
that bugs are fixed, TTU_SYNC here can be removed, and the race tolerated.

Link: https://lkml.kernel.org/r/c1e95853-8bcd-d8fd-55fa-e7f2488e78f@google.com
Fixes: fec89c109f3a ("thp: rewrite freeze_page()/unfreeze_page() with generic rmap walkers")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jue Wang <juew@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |    1 +
 mm/huge_memory.c     |    2 +-
 mm/page_vma_mapped.c |   11 +++++++++++
 mm/rmap.c            |   17 ++++++++++++++++-
 4 files changed, 29 insertions(+), 2 deletions(-)

--- a/include/linux/rmap.h~mm-thp-try_to_unmap-use-ttu_sync-for-safe-splitting
+++ a/include/linux/rmap.h
@@ -91,6 +91,7 @@ enum ttu_flags {
 
 	TTU_SPLIT_HUGE_PMD	= 0x4,	/* split huge PMD if any */
 	TTU_IGNORE_MLOCK	= 0x8,	/* ignore mlock */
+	TTU_SYNC		= 0x10,	/* avoid racy checks with PVMW_SYNC */
 	TTU_IGNORE_HWPOISON	= 0x20,	/* corrupted page is recoverable */
 	TTU_BATCH_FLUSH		= 0x40,	/* Batch TLB flushes where possible
 					 * and caller guarantees they will
--- a/mm/huge_memory.c~mm-thp-try_to_unmap-use-ttu_sync-for-safe-splitting
+++ a/mm/huge_memory.c
@@ -2350,7 +2350,7 @@ void vma_adjust_trans_huge(struct vm_are
 
 static void unmap_page(struct page *page)
 {
-	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK |
+	enum ttu_flags ttu_flags = TTU_IGNORE_MLOCK | TTU_SYNC |
 		TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD;
 	bool unmap_success;
 
--- a/mm/page_vma_mapped.c~mm-thp-try_to_unmap-use-ttu_sync-for-safe-splitting
+++ a/mm/page_vma_mapped.c
@@ -212,6 +212,17 @@ restart:
 			pvmw->ptl = NULL;
 		}
 	} else if (!pmd_present(pmde)) {
+		/*
+		 * If PVMW_SYNC, take and drop THP pmd lock so that we
+		 * cannot return prematurely, while zap_huge_pmd() has
+		 * cleared *pmd but not decremented compound_mapcount().
+		 */
+		if ((pvmw->flags & PVMW_SYNC) &&
+		    PageTransCompound(pvmw->page)) {
+			spinlock_t *ptl = pmd_lock(mm, pvmw->pmd);
+
+			spin_unlock(ptl);
+		}
 		return false;
 	}
 	if (!map_pte(pvmw))
--- a/mm/rmap.c~mm-thp-try_to_unmap-use-ttu_sync-for-safe-splitting
+++ a/mm/rmap.c
@@ -1405,6 +1405,15 @@ static bool try_to_unmap_one(struct page
 	struct mmu_notifier_range range;
 	enum ttu_flags flags = (enum ttu_flags)(long)arg;
 
+	/*
+	 * When racing against e.g. zap_pte_range() on another cpu,
+	 * in between its ptep_get_and_clear_full() and page_remove_rmap(),
+	 * try_to_unmap() may return false when it is about to become true,
+	 * if page table locking is skipped: use TTU_SYNC to wait for that.
+	 */
+	if (flags & TTU_SYNC)
+		pvmw.flags = PVMW_SYNC;
+
 	/* munlock has nothing to gain from examining un-locked vmas */
 	if ((flags & TTU_MUNLOCK) && !(vma->vm_flags & VM_LOCKED))
 		return true;
@@ -1777,7 +1786,13 @@ bool try_to_unmap(struct page *page, enu
 	else
 		rmap_walk(page, &rwc);
 
-	return !page_mapcount(page) ? true : false;
+	/*
+	 * When racing against e.g. zap_pte_range() on another cpu,
+	 * in between its ptep_get_and_clear_full() and page_remove_rmap(),
+	 * try_to_unmap() may return false when it is about to become true,
+	 * if page table locking is skipped: use TTU_SYNC to wait for that.
+	 */
+	return !page_mapcount(page);
 }
 
 /**
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

