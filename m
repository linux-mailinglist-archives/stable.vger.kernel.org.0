Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0256369F8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 20:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbiKWTjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 14:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237291AbiKWTjt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 14:39:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C0C91513;
        Wed, 23 Nov 2022 11:39:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8669C61EDA;
        Wed, 23 Nov 2022 19:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6698C433D7;
        Wed, 23 Nov 2022 19:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669232386;
        bh=BQJdeb+r2L6JJCwDjpFik/KEsSCP8mZl2Pt1dDk3DIg=;
        h=Date:To:From:Subject:From;
        b=gwhCO7EwvN7alc3PCJsoPHrXFKcrpEFgIcf8X/W/dbIpEbgPB7TIbEYTSPvuV8Cv/
         SNTjmYoG9Z1ETz/m7Y9cYbdnk1YEGNZriR19Yz+N+pDRuYCgY8Incn1NEgHaXXqUc2
         AHaYbEw/WgyUJszLiA72y9TvqSiC5Ar3CxcbSEtQ=
Date:   Wed, 23 Nov 2022 11:39:46 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shy828301@gmail.com, peterx@redhat.com, mike.kravetz@oracle.com,
        jhubbard@nvidia.com, david@redhat.com, jannh@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather.patch added to mm-hotfixes-unstable branch
Message-Id: <20221123193946.D6698C433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/khugepaged: fix GUP-fast interaction by freeing ptes via mmu_gather
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/khugepaged: fix GUP-fast interaction by freeing ptes via mmu_gather
Date: Wed, 23 Nov 2022 17:56:51 +0100

Since commit 70cbc3cc78a99 ("mm: gup: fix the fast GUP race against THP
collapse"), the lockless_pages_from_mm() fastpath rechecks the pmd_t to
ensure that the page table was not removed by khugepaged in between.

However, lockless_pages_from_mm() still requires that the page table is
not concurrently freed.  We could provide this guarantee in khugepaged by
using some variant of pte_free() with appropriate delay; but such a helper
doesn't really exist outside the mmu_gather infrastructure.

To avoid having to wire up a new codepath for freeing page tables that
might have been in use in the past, fix the issue by letting khugepaged
deposit a fresh page table (if required) instead of depositing the
existing page table, and free the old page table via mmu_gather.

Link: https://lkml.kernel.org/r/20221123165652.2204925-4-jannh@google.com
Fixes: ba76149f47d8 ("thp: khugepaged")
Signed-off-by: Jann Horn <jannh@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   47 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather
+++ a/mm/khugepaged.c
@@ -975,6 +975,8 @@ static int collapse_huge_page(struct mm_
 	int result = SCAN_FAIL;
 	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
+	struct mmu_gather tlb;
+	pgtable_t deposit_table = NULL;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -989,6 +991,11 @@ static int collapse_huge_page(struct mm_
 	result = alloc_charge_hpage(&hpage, mm, cc);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
+	deposit_table = pte_alloc_one(mm);
+	if (!deposit_table) {
+		result = SCAN_FAIL;
+		goto out_nolock;
+	}
 
 	mmap_read_lock(mm);
 	result = hugepage_vma_revalidate(mm, address, true, &vma, cc);
@@ -1041,12 +1048,12 @@ static int collapse_huge_page(struct mm_
 
 	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
 	/*
-	 * This removes any huge TLB entry from the CPU so we won't allow
-	 * huge and small TLB entries for the same virtual address to
-	 * avoid the risk of CPU bugs in that area.
-	 *
-	 * Parallel fast GUP is fine since fast GUP will back off when
-	 * it detects PMD is changed.
+	 * Unlink the page table from the PMD and do a TLB flush.
+	 * This ensures that the CPUs can't write to the old pages anymore by
+	 * the time __collapse_huge_page_copy() copies their contents, and it
+	 * allows __collapse_huge_page_copy() to free the old pages.
+	 * This also prevents lockless_pages_from_mm() from grabbing references
+	 * on the old pages from here on.
 	 */
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
@@ -1090,6 +1097,16 @@ static int collapse_huge_page(struct mm_
 	__SetPageUptodate(hpage);
 	pgtable = pmd_pgtable(_pmd);
 
+	/*
+	 * Discard the old page table.
+	 * The TLB flush that's implied here is redundant, but hard to avoid
+	 * with the current API.
+	 */
+	tlb_gather_mmu(&tlb, mm);
+	tlb_flush_pte_range(&tlb, address, HPAGE_PMD_SIZE);
+	pte_free_tlb(&tlb, pgtable, address);
+	tlb_finish_mmu(&tlb);
+
 	_pmd = mk_huge_pmd(hpage, vma->vm_page_prot);
 	_pmd = maybe_pmd_mkwrite(pmd_mkdirty(_pmd), vma);
 
@@ -1097,7 +1114,8 @@ static int collapse_huge_page(struct mm_
 	BUG_ON(!pmd_none(*pmd));
 	page_add_new_anon_rmap(hpage, vma, address);
 	lru_cache_add_inactive_or_unevictable(hpage, vma);
-	pgtable_trans_huge_deposit(mm, pmd, pgtable);
+	pgtable_trans_huge_deposit(mm, pmd, deposit_table);
+	deposit_table = NULL;
 	set_pmd_at(mm, address, pmd, _pmd);
 	update_mmu_cache_pmd(vma, address, pmd);
 	spin_unlock(pmd_ptl);
@@ -1112,6 +1130,8 @@ out_nolock:
 		mem_cgroup_uncharge(page_folio(hpage));
 		put_page(hpage);
 	}
+	if (deposit_table)
+		pte_free(mm, deposit_table);
 	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result);
 	return result;
 }
@@ -1393,11 +1413,14 @@ static int set_huge_pmd(struct vm_area_s
  * The mmap lock together with this VMA's rmap locks covers all paths towards
  * the page table entries we're messing with here, except for hardware page
  * table walks and lockless_pages_from_mm().
+ *
+ * This function is similar to free_pte_range().
  */
 static void collapse_and_free_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
 				  unsigned long addr, pmd_t *pmdp)
 {
 	pmd_t pmd;
+	struct mmu_gather tlb;
 
 	mmap_assert_write_locked(mm);
 	if (vma->vm_file)
@@ -1408,11 +1431,15 @@ static void collapse_and_free_pmd(struct
 	 */
 	if (vma->anon_vma)
 		lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
+	page_table_check_pte_clear_range(mm, addr, pmd);
 
-	pmd = pmdp_collapse_flush(vma, addr, pmdp);
+	tlb_gather_mmu(&tlb, mm);
+	pmd = READ_ONCE(*pmdp);
+	pmd_clear(pmdp);
+	tlb_flush_pte_range(&tlb, addr, HPAGE_PMD_SIZE);
+	pte_free_tlb(&tlb, pmd_pgtable(pmd), addr);
+	tlb_finish_mmu(&tlb);
 	mm_dec_nr_ptes(mm);
-	page_table_check_pte_clear_range(mm, addr, pmd);
-	pte_free(mm, pmd_pgtable(pmd));
 }
 
 /**
_

Patches currently in -mm which might be from jannh@google.com are

mm-khugepaged-take-the-right-locks-for-page-table-retraction.patch
mmu_gather-use-macro-arguments-more-carefully.patch
mm-khugepaged-fix-gup-fast-interaction-by-freeing-ptes-via-mmu_gather.patch
mm-khugepaged-invoke-mmu-notifiers-in-shmem-file-collapse-paths.patch

