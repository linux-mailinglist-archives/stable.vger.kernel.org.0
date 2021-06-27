Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 221933B5552
	for <lists+stable@lfdr.de>; Sun, 27 Jun 2021 23:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhF0Vz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Jun 2021 17:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231707AbhF0Vz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Jun 2021 17:55:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C819D61C31;
        Sun, 27 Jun 2021 21:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624830781;
        bh=odaWNh2QNtJiBgmds5a66qcIZTKnsoVt4gTJxzJ7QFE=;
        h=Date:From:To:Subject:From;
        b=OwKuNp5P5LE0WySqCZSg5rISbcwMLyubSVruYMsmAask2cW6DMgSGVMgjreX8ovb3
         MwB3dl1QwE2WJZ6BOEjxBeekOb/09r6thaoyIUHC7fNHDvQNoAyYcqgS91uIITiApG
         OeNGbVc9iqEyGxL65GJNw71oWEtvSSArhuUUI0G0=
Date:   Sun, 27 Jun 2021 14:53:00 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com, jack@suse.cz,
        juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com, stable@vger.kernel.org,
        wangyugui@e16-tech.com, willy@infradead.org, ziy@nvidia.com
Subject:  [merged]
 mm-thp-fix-__split_huge_pmd_locked-on-shmem-migration-entry.patch removed
 from -mm tree
Message-ID: <20210627215300.aGBRDYTEL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/thp: fix __split_huge_pmd_locked() on shmem migration entry
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-__split_huge_pmd_locked-on-shmem-migration-entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: fix __split_huge_pmd_locked() on shmem migration entry

Patch series "mm/thp: fix THP splitting unmap BUGs and related", v10.

Here is v2 batch of long-standing THP bug fixes that I had not got around
to sending before, but prompted now by Wang Yugui's report
https://lore.kernel.org/linux-mm/20210412180659.B9E3.409509F4@e16-tech.com/

Wang Yugui has tested a rollup of these fixes applied to 5.10.39, and they
have done no harm, but have *not* fixed that issue: something more is
needed and I have no idea of what.


This patch (of 7):

Stressing huge tmpfs page migration racing hole punch often crashed on the
VM_BUG_ON(!pmd_present) in pmdp_huge_clear_flush(), with DEBUG_VM=y
kernel; or shortly afterwards, on a bad dereference in
__split_huge_pmd_locked() when DEBUG_VM=n.  They forgot to allow for pmd
migration entries in the non-anonymous case.

Full disclosure: those particular experiments were on a kernel with more
relaxed mmap_lock and i_mmap_rwsem locking, and were not repeated on the
vanilla kernel: it is conceivable that stricter locking happens to avoid
those cases, or makes them less likely; but __split_huge_pmd_locked()
already allowed for pmd migration entries when handling anonymous THPs, so
this commit brings the shmem and file THP handling into line.

And while there: use old_pmd rather than _pmd, as in the following blocks;
and make it clearer to the eye that the !vma_is_anonymous() block is
self-contained, making an early return after accounting for unmapping.

Link: https://lkml.kernel.org/r/af88612-1473-2eaa-903-8d1a448b26@google.com
Link: https://lkml.kernel.org/r/dd221a99-efb3-cd1d-6256-7e646af29314@google.com
Fixes: e71769ae5260 ("mm: enable thp migration for shmem thp")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Wang Yugui <wangyugui@e16-tech.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jue Wang <juew@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c     |   27 ++++++++++++++++++---------
 mm/pgtable-generic.c |    5 ++---
 2 files changed, 20 insertions(+), 12 deletions(-)

--- a/mm/huge_memory.c~mm-thp-fix-__split_huge_pmd_locked-on-shmem-migration-entry
+++ a/mm/huge_memory.c
@@ -2044,7 +2044,7 @@ static void __split_huge_pmd_locked(stru
 	count_vm_event(THP_SPLIT_PMD);
 
 	if (!vma_is_anonymous(vma)) {
-		_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
+		old_pmd = pmdp_huge_clear_flush_notify(vma, haddr, pmd);
 		/*
 		 * We are going to unmap this huge page. So
 		 * just go ahead and zap it
@@ -2053,16 +2053,25 @@ static void __split_huge_pmd_locked(stru
 			zap_deposited_table(mm, pmd);
 		if (vma_is_special_huge(vma))
 			return;
-		page = pmd_page(_pmd);
-		if (!PageDirty(page) && pmd_dirty(_pmd))
-			set_page_dirty(page);
-		if (!PageReferenced(page) && pmd_young(_pmd))
-			SetPageReferenced(page);
-		page_remove_rmap(page, true);
-		put_page(page);
+		if (unlikely(is_pmd_migration_entry(old_pmd))) {
+			swp_entry_t entry;
+
+			entry = pmd_to_swp_entry(old_pmd);
+			page = migration_entry_to_page(entry);
+		} else {
+			page = pmd_page(old_pmd);
+			if (!PageDirty(page) && pmd_dirty(old_pmd))
+				set_page_dirty(page);
+			if (!PageReferenced(page) && pmd_young(old_pmd))
+				SetPageReferenced(page);
+			page_remove_rmap(page, true);
+			put_page(page);
+		}
 		add_mm_counter(mm, mm_counter_file(page), -HPAGE_PMD_NR);
 		return;
-	} else if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
+	}
+
+	if (pmd_trans_huge(*pmd) && is_huge_zero_pmd(*pmd)) {
 		/*
 		 * FIXME: Do we want to invalidate secondary mmu by calling
 		 * mmu_notifier_invalidate_range() see comments below inside
--- a/mm/pgtable-generic.c~mm-thp-fix-__split_huge_pmd_locked-on-shmem-migration-entry
+++ a/mm/pgtable-generic.c
@@ -135,9 +135,8 @@ pmd_t pmdp_huge_clear_flush(struct vm_ar
 {
 	pmd_t pmd;
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	VM_BUG_ON(!pmd_present(*pmdp));
-	/* Below assumes pmd_present() is true */
-	VM_BUG_ON(!pmd_trans_huge(*pmdp) && !pmd_devmap(*pmdp));
+	VM_BUG_ON(pmd_present(*pmdp) && !pmd_trans_huge(*pmdp) &&
+			   !pmd_devmap(*pmdp));
 	pmd = pmdp_huge_get_and_clear(vma->vm_mm, address, pmdp);
 	flush_pmd_tlb_range(vma, address, address + HPAGE_PMD_SIZE);
 	return pmd;
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

