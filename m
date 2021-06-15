Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19E83A74BA
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 05:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhFODNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 23:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229613AbhFODNh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 23:13:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E105F61400;
        Tue, 15 Jun 2021 01:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623719775;
        bh=xwQc7b5FVqpaHdLEqf/i93gl6NuucKx5snQBja45nho=;
        h=Date:From:To:Subject:From;
        b=QCYIBlMkdWLA5JOW31cIPnhJjvsxlj9E164lDKj+sLpI95oxlKgfowCuNeKl/7zMD
         DIh8oJUQxO56JArk+rr2sjKpv7XOThd8Eb9jYqQejeE2ZqzzReMAS33NFwcHg2a/ZH
         eor9q9EN1sQyInJPhp5Xh5i84HagRkMUAT8VSkkA=
Date:   Mon, 14 Jun 2021 18:16:14 -0700
From:   akpm@linux-foundation.org
To:     dave@stgolabs.net, dvhart@infradead.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, mgorman@techsingularity.net,
        mike.kravetz@oracle.com, mingo@redhat.com,
        mm-commits@vger.kernel.org, neelnatu@google.com,
        peterz@infradead.org, stable@vger.kernel.org, tglx@linutronix.de,
        wetpzy@gmail.com, willy@infradead.org
Subject:  +
 mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch added to -mm tree
Message-ID: <20210615011614.07wwVNwhz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, futex: fix shared futex pgoff on shmem huge page
has been added to the -mm tree.  Its filename is
     mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch

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
Subject: mm, futex: fix shared futex pgoff on shmem huge page

If more than one futex is placed on a shmem huge page, it can happen that
waking the second wakes the first instead, and leaves the second waiting:
the key's shared.pgoff is wrong.

When 3.11 commit 13d60f4b6ab5 ("futex: Take hugepages into account when
generating futex_key"), the only shared huge pages came from hugetlbfs,
and the code added to deal with its exceptional page->index was put into
hugetlb source.  Then that was missed when 4.8 added shmem huge pages.

page_to_pgoff() is what others use for this nowadays: except that, as
currently written, it gives the right answer on hugetlbfs head, but
nonsense on hugetlbfs tails.  Fix that by calling hugetlbfs-specific
hugetlb_basepage_index() on PageHuge tails as well as on head.

Yes, it's unconventional to declare hugetlb_basepage_index() there in
pagemap.h, rather than in hugetlb.h; but I do not expect anything but
page_to_pgoff() ever to need it.

Link: https://lkml.kernel.org/r/b17d946b-d09-326e-b42a-52884c36df32@google.com
Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
Reported-by: Neel Natu <neelnatu@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Zhang Yi <wetpzy@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   16 ----------------
 include/linux/pagemap.h |   13 +++++++------
 kernel/futex.c          |    3 +--
 mm/hugetlb.c            |    5 +----
 4 files changed, 9 insertions(+), 28 deletions(-)

--- a/include/linux/hugetlb.h~mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page
+++ a/include/linux/hugetlb.h
@@ -741,17 +741,6 @@ static inline int hstate_index(struct hs
 	return h - hstates;
 }
 
-pgoff_t __basepage_index(struct page *page);
-
-/* Return page->index in PAGE_SIZE units */
-static inline pgoff_t basepage_index(struct page *page)
-{
-	if (!PageCompound(page))
-		return page->index;
-
-	return __basepage_index(page);
-}
-
 extern int dissolve_free_huge_page(struct page *page);
 extern int dissolve_free_huge_pages(unsigned long start_pfn,
 				    unsigned long end_pfn);
@@ -988,11 +977,6 @@ static inline int hstate_index(struct hs
 	return 0;
 }
 
-static inline pgoff_t basepage_index(struct page *page)
-{
-	return page->index;
-}
-
 static inline int dissolve_free_huge_page(struct page *page)
 {
 	return 0;
--- a/include/linux/pagemap.h~mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page
+++ a/include/linux/pagemap.h
@@ -516,7 +516,7 @@ static inline struct page *read_mapping_
 }
 
 /*
- * Get index of the page with in radix-tree
+ * Get index of the page within radix-tree (but not for hugetlb pages).
  * (TODO: remove once hugetlb pages will have ->index in PAGE_SIZE)
  */
 static inline pgoff_t page_to_index(struct page *page)
@@ -536,14 +536,15 @@ static inline pgoff_t page_to_index(stru
 }
 
 /*
- * Get the offset in PAGE_SIZE.
- * (TODO: hugepage should have ->index in PAGE_SIZE)
+ * Get the offset in PAGE_SIZE (even for hugetlb pages).
+ * (TODO: hugetlb pages should have ->index in PAGE_SIZE)
  */
 static inline pgoff_t page_to_pgoff(struct page *page)
 {
-	if (unlikely(PageHeadHuge(page)))
-		return page->index << compound_order(page);
-
+	if (unlikely(PageHuge(page))) {
+		extern pgoff_t hugetlb_basepage_index(struct page *page);
+		return hugetlb_basepage_index(page);
+	}
 	return page_to_index(page);
 }
 
--- a/kernel/futex.c~mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page
+++ a/kernel/futex.c
@@ -35,7 +35,6 @@
 #include <linux/jhash.h>
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
-#include <linux/hugetlb.h>
 #include <linux/freezer.h>
 #include <linux/memblock.h>
 #include <linux/fault-inject.h>
@@ -650,7 +649,7 @@ again:
 
 		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
 		key->shared.i_seq = get_inode_sequence_number(inode);
-		key->shared.pgoff = basepage_index(tail);
+		key->shared.pgoff = page_to_pgoff(tail);
 		rcu_read_unlock();
 	}
 
--- a/mm/hugetlb.c~mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page
+++ a/mm/hugetlb.c
@@ -1588,15 +1588,12 @@ struct address_space *hugetlb_page_mappi
 	return NULL;
 }
 
-pgoff_t __basepage_index(struct page *page)
+pgoff_t hugetlb_basepage_index(struct page *page)
 {
 	struct page *page_head = compound_head(page);
 	pgoff_t index = page_index(page_head);
 	unsigned long compound_idx;
 
-	if (!PageHuge(page_head))
-		return page_index(page);
-
 	if (compound_order(page_head) >= MAX_ORDER)
 		compound_idx = page_to_pfn(page) - page_to_pfn(page_head);
 	else
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
mm-futex-fix-shared-futex-pgoff-on-shmem-huge-page.patch
mm-thp-remap_page-is-only-needed-on-anonymous-thp.patch
mm-hwpoison_user_mappings-try_to_unmap-with-ttu_sync.patch

