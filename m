Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 686283A36FB
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 00:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhFJW1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 18:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230251AbhFJW1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 18:27:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D2F8613E7;
        Thu, 10 Jun 2021 22:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623363894;
        bh=WyCaeHKdwE0SH6SPzu23XbffgHuMF33n7z0lIB9X/V4=;
        h=Date:From:To:Subject:From;
        b=1F+pjBvXrnML7ta5Sw4ttcEPRfNlJMN/esecjpmFYeyw2iqxsKizqzocabVSGwW8k
         KVGTCRlIHeYsMtGiPCBFEnjdXUm9ubGiczw/Bv2eH4iEFZWno41Ek6FcNOlpgAVvgB
         NqUC0Ic6SFk/ubIteF6gURBzjJYeOC/gv3eG6D/c=
Date:   Thu, 10 Jun 2021 15:24:53 -0700
From:   akpm@linux-foundation.org
To:     apopple@nvidia.com, hughd@google.com, jack@suse.cz,
        juew@google.com, kirill.shutemov@linux.intel.com,
        linmiaohe@huawei.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, rcampbell@nvidia.com,
        shakeelb@google.com, shy828301@gmail.com, stable@vger.kernel.org,
        wangyugui@e16-tech.com, willy@infradead.org, ziy@nvidia.com
Subject:  +
 mm-thp-fix-vma_address-if-virtual-address-below-file-offset.patch added to
 -mm tree
Message-ID: <20210610222453.qXtsa9a7u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/thp: fix vma_address() if virtual address below file offset
has been added to the -mm tree.  Its filename is
     mm-thp-fix-vma_address-if-virtual-address-below-file-offset.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-fix-vma_address-if-virtual-address-below-file-offset.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-fix-vma_address-if-virtual-address-below-file-offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: fix vma_address() if virtual address below file offset

Running certain tests with a DEBUG_VM kernel would crash within hours, on
the total_mapcount BUG() in split_huge_page_to_list(), while trying to
free up some memory by punching a hole in a shmem huge page: split's
try_to_unmap() was unable to find all the mappings of the page (which, on
a !DEBUG_VM kernel, would then keep the huge page pinned in memory).

When that BUG() was changed to a WARN(), it would later crash on the
VM_BUG_ON_VMA(end < vma->vm_start || start >= vma->vm_end, vma) in
mm/internal.h:vma_address(), used by rmap_walk_file() for try_to_unmap().

vma_address() is usually correct, but there's a wraparound case when the
vm_start address is unusually low, but vm_pgoff not so low: vma_address()
chooses max(start, vma->vm_start), but that decides on the wrong address,
because start has become almost ULONG_MAX.

Rewrite vma_address() to be more careful about vm_pgoff; move the
VM_BUG_ON_VMA() out of it, returning -EFAULT for errors, so that it can be
safely used from page_mapped_in_vma() and page_address_in_vma() too.

Add vma_address_end() to apply similar care to end address calculation, in
page_vma_mapped_walk() and page_mkclean_one() and try_to_unmap_one();
though it raises a question of whether callers would do better to supply
pvmw->end to page_vma_mapped_walk() - I chose not, for a smaller patch.

An irritation is that their apparent generality breaks down on KSM pages,
which cannot be located by the page->index that page_to_pgoff() uses: as
4b0ece6fa016 ("mm: migrate: fix remove_migration_pte() for ksm pages")
once discovered.  I dithered over the best thing to do about that, and
have ended up with a VM_BUG_ON_PAGE(PageKsm) in both vma_address() and
vma_address_end(); though the only place in danger of using it on them was
try_to_unmap_one().

Sidenote: vma_address() and vma_address_end() now use compound_nr() on a
head page, instead of thp_size(): to make the right calculation on a
hugetlbfs page, whether or not THPs are configured.  try_to_unmap() is
used on hugetlbfs pages, but perhaps the wrong calculation never mattered.

Link: https://lkml.kernel.org/r/caf1c1a3-7cfb-7f8f-1beb-ba816e932825@google.com
Fixes: a8fa41ad2f6f ("mm, rmap: check all VMAs that PTE-mapped THP can be part of")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
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
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h        |   51 ++++++++++++++++++++++++++++++-----------
 mm/page_vma_mapped.c |   16 ++++--------
 mm/rmap.c            |   16 ++++++------
 3 files changed, 52 insertions(+), 31 deletions(-)

--- a/mm/internal.h~mm-thp-fix-vma_address-if-virtual-address-below-file-offset
+++ a/mm/internal.h
@@ -384,27 +384,52 @@ static inline void mlock_migrate_page(st
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 /*
- * At what user virtual address is page expected in @vma?
+ * At what user virtual address is page expected in vma?
+ * Returns -EFAULT if all of the page is outside the range of vma.
+ * If page is a compound head, the entire compound page is considered.
  */
 static inline unsigned long
-__vma_address(struct page *page, struct vm_area_struct *vma)
+vma_address(struct page *page, struct vm_area_struct *vma)
 {
-	pgoff_t pgoff = page_to_pgoff(page);
-	return vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+	pgoff_t pgoff;
+	unsigned long address;
+
+	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
+	pgoff = page_to_pgoff(page);
+	if (pgoff >= vma->vm_pgoff) {
+		address = vma->vm_start +
+			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+		/* Check for address beyond vma (or wrapped through 0?) */
+		if (address < vma->vm_start || address >= vma->vm_end)
+			address = -EFAULT;
+	} else if (PageHead(page) &&
+		   pgoff + compound_nr(page) - 1 >= vma->vm_pgoff) {
+		/* Test above avoids possibility of wrap to 0 on 32-bit */
+		address = vma->vm_start;
+	} else {
+		address = -EFAULT;
+	}
+	return address;
 }
 
+/*
+ * Then at what user virtual address will none of the page be found in vma?
+ * Assumes that vma_address() already returned a good starting address.
+ * If page is a compound head, the entire compound page is considered.
+ */
 static inline unsigned long
-vma_address(struct page *page, struct vm_area_struct *vma)
+vma_address_end(struct page *page, struct vm_area_struct *vma)
 {
-	unsigned long start, end;
-
-	start = __vma_address(page, vma);
-	end = start + thp_size(page) - PAGE_SIZE;
-
-	/* page should be within @vma mapping range */
-	VM_BUG_ON_VMA(end < vma->vm_start || start >= vma->vm_end, vma);
+	pgoff_t pgoff;
+	unsigned long address;
 
-	return max(start, vma->vm_start);
+	VM_BUG_ON_PAGE(PageKsm(page), page);	/* KSM page->index unusable */
+	pgoff = page_to_pgoff(page) + compound_nr(page);
+	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+	/* Check for address beyond vma (or wrapped through 0?) */
+	if (address < vma->vm_start || address > vma->vm_end)
+		address = vma->vm_end;
+	return address;
 }
 
 static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
--- a/mm/page_vma_mapped.c~mm-thp-fix-vma_address-if-virtual-address-below-file-offset
+++ a/mm/page_vma_mapped.c
@@ -228,18 +228,18 @@ restart:
 	if (!map_pte(pvmw))
 		goto next_pte;
 	while (1) {
+		unsigned long end;
+
 		if (check_pte(pvmw))
 			return true;
 next_pte:
 		/* Seek to next pte only makes sense for THP */
 		if (!PageTransHuge(pvmw->page) || PageHuge(pvmw->page))
 			return not_found(pvmw);
+		end = vma_address_end(pvmw->page, pvmw->vma);
 		do {
 			pvmw->address += PAGE_SIZE;
-			if (pvmw->address >= pvmw->vma->vm_end ||
-			    pvmw->address >=
-					__vma_address(pvmw->page, pvmw->vma) +
-					thp_size(pvmw->page))
+			if (pvmw->address >= end)
 				return not_found(pvmw);
 			/* Did we cross page table boundary? */
 			if (pvmw->address % PMD_SIZE == 0) {
@@ -277,14 +277,10 @@ int page_mapped_in_vma(struct page *page
 		.vma = vma,
 		.flags = PVMW_SYNC,
 	};
-	unsigned long start, end;
-
-	start = __vma_address(page, vma);
-	end = start + thp_size(page) - PAGE_SIZE;
 
-	if (unlikely(end < vma->vm_start || start >= vma->vm_end))
+	pvmw.address = vma_address(page, vma);
+	if (pvmw.address == -EFAULT)
 		return 0;
-	pvmw.address = max(start, vma->vm_start);
 	if (!page_vma_mapped_walk(&pvmw))
 		return 0;
 	page_vma_mapped_walk_done(&pvmw);
--- a/mm/rmap.c~mm-thp-fix-vma_address-if-virtual-address-below-file-offset
+++ a/mm/rmap.c
@@ -707,7 +707,6 @@ static bool should_defer_flush(struct mm
  */
 unsigned long page_address_in_vma(struct page *page, struct vm_area_struct *vma)
 {
-	unsigned long address;
 	if (PageAnon(page)) {
 		struct anon_vma *page__anon_vma = page_anon_vma(page);
 		/*
@@ -722,10 +721,8 @@ unsigned long page_address_in_vma(struct
 			return -EFAULT;
 	} else
 		return -EFAULT;
-	address = __vma_address(page, vma);
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
-		return -EFAULT;
-	return address;
+
+	return vma_address(page, vma);
 }
 
 pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
@@ -919,7 +916,7 @@ static bool page_mkclean_one(struct page
 	 */
 	mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_PAGE,
 				0, vma, vma->vm_mm, address,
-				min(vma->vm_end, address + page_size(page)));
+				vma_address_end(page, vma));
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
@@ -1435,9 +1432,10 @@ static bool try_to_unmap_one(struct page
 	 * Note that the page can not be free in this function as call of
 	 * try_to_unmap() must hold a reference on the page.
 	 */
+	range.end = PageKsm(page) ?
+			address + PAGE_SIZE : vma_address_end(page, vma);
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				address,
-				min(vma->vm_end, address + page_size(page)));
+				address, range.end);
 	if (PageHuge(page)) {
 		/*
 		 * If sharing is possible, start and end will be adjusted
@@ -1889,6 +1887,7 @@ static void rmap_walk_anon(struct page *
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
 
+		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
 
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
@@ -1943,6 +1942,7 @@ static void rmap_walk_file(struct page *
 			pgoff_start, pgoff_end) {
 		unsigned long address = vma_address(page, vma);
 
+		VM_BUG_ON_VMA(address == -EFAULT, vma);
 		cond_resched();
 
 		if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
_

Patches currently in -mm which might be from hughd@google.com are

mm-thp-fix-__split_huge_pmd_locked-on-shmem-migration-entry.patch
mm-thp-make-is_huge_zero_pmd-safe-and-quicker.patch
mm-thp-try_to_unmap-use-ttu_sync-for-safe-splitting.patch
mm-thp-fix-vma_address-if-virtual-address-below-file-offset.patch
mm-thp-unmap_mapping_page-to-fix-thp-truncate_cleanup_page.patch
mm-page_vma_mapped_walk-use-page-for-pvmw-page.patch
mm-page_vma_mapped_walk-settle-pagehuge-on-entry.patch
mm-page_vma_mapped_walk-use-pmd_read_atomic.patch
mm-page_vma_mapped_walk-use-pmde-for-pvmw-pmd.patch
mm-page_vma_mapped_walk-prettify-pvmw_migration-block.patch
mm-page_vma_mapped_walk-crossing-page-table-boundary.patch
mm-page_vma_mapped_walk-add-a-level-of-indentation.patch
mm-page_vma_mapped_walk-use-goto-instead-of-while-1.patch
mm-page_vma_mapped_walk-get-vma_address_end-earlier.patch
mm-thp-fix-page_vma_mapped_walk-if-thp-mapped-by-ptes.patch
mm-thp-another-pvmw_sync-fix-in-page_vma_mapped_walk.patch
mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

