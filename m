Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94FA123B1F3
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 02:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbgHDA4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 20:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbgHDA4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 20:56:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E82420781;
        Tue,  4 Aug 2020 00:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596502606;
        bh=IQXvaMHiM6zoBwLCrMACpz/aJ0Y3pYELVI11+Z+Om6g=;
        h=Date:From:To:Subject:From;
        b=AFLLXQ9l4HTgelFUA+SbbsJTvJVzmY0OoPeDskDvBlzQdsOSyWpAgFNwP4g7bKgL3
         jK9XoLX96chfAnngfAtn2fwwJJtku2fUMYRqBZ4blBTLWBNiM5XujPHfxr4mjYrw8V
         rtxW44392tUzEdrtq/A7huUwIpeZj1jlEpUh43U0=
Date:   Mon, 03 Aug 2020 17:56:45 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, songliubraving@fb.com,
        stable@vger.kernel.org
Subject:  +
 khugepaged-collapse_pte_mapped_thp-protect-the-pmd-lock.patch added to -mm
 tree
Message-ID: <20200804005645.p_FtbeH0R%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: khugepaged: collapse_pte_mapped_thp() protect the pmd lock
has been added to the -mm tree.  Its filename is
     khugepaged-collapse_pte_mapped_thp-protect-the-pmd-lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/khugepaged-collapse_pte_mapped_thp-protect-the-pmd-lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/khugepaged-collapse_pte_mapped_thp-protect-the-pmd-lock.patch

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
Subject: khugepaged: collapse_pte_mapped_thp() protect the pmd lock

When retract_page_tables() removes a page table to make way for a huge
pmd, it holds huge page lock, i_mmap_lock_write, mmap_write_trylock and
pmd lock; but when collapse_pte_mapped_thp() does the same (to handle the
case when the original mmap_write_trylock had failed), only
mmap_write_trylock and pmd lock are held.

That's not enough.  One machine has twice crashed under load, with "BUG:
spinlock bad magic" and GPF on 6b6b6b6b6b6b6b6b.  Examining the second
crash, page_vma_mapped_walk_done()'s spin_unlock of pvmw->ptl (serving
page_referenced() on a file THP, that had found a page table at *pmd)
discovers that the page table page and its lock have already been freed by
the time it comes to unlock.

Follow the example of retract_page_tables(), but we only need one of huge
page lock or i_mmap_lock_write to secure against this: because it's the
narrower lock, and because it simplifies collapse_pte_mapped_thp() to know
the hpage earlier, choose to rely on huge page lock here.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008021213070.27773@eggly.anvils
Fixes: 27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   44 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 25 deletions(-)

--- a/mm/khugepaged.c~khugepaged-collapse_pte_mapped_thp-protect-the-pmd-lock
+++ a/mm/khugepaged.c
@@ -1412,7 +1412,7 @@ void collapse_pte_mapped_thp(struct mm_s
 {
 	unsigned long haddr = addr & HPAGE_PMD_MASK;
 	struct vm_area_struct *vma = find_vma(mm, haddr);
-	struct page *hpage = NULL;
+	struct page *hpage;
 	pte_t *start_pte, *pte;
 	pmd_t *pmd, _pmd;
 	spinlock_t *ptl;
@@ -1432,9 +1432,17 @@ void collapse_pte_mapped_thp(struct mm_s
 	if (!hugepage_vma_check(vma, vma->vm_flags | VM_HUGEPAGE))
 		return;
 
+	hpage = find_lock_page(vma->vm_file->f_mapping,
+			       linear_page_index(vma, haddr));
+	if (!hpage)
+		return;
+
+	if (!PageHead(hpage))
+		goto drop_hpage;
+
 	pmd = mm_find_pmd(mm, haddr);
 	if (!pmd)
-		return;
+		goto drop_hpage;
 
 	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
 
@@ -1453,30 +1461,11 @@ void collapse_pte_mapped_thp(struct mm_s
 
 		page = vm_normal_page(vma, addr, *pte);
 
-		if (!page || !PageCompound(page))
-			goto abort;
-
-		if (!hpage) {
-			hpage = compound_head(page);
-			/*
-			 * The mapping of the THP should not change.
-			 *
-			 * Note that uprobe, debugger, or MAP_PRIVATE may
-			 * change the page table, but the new page will
-			 * not pass PageCompound() check.
-			 */
-			if (WARN_ON(hpage->mapping != vma->vm_file->f_mapping))
-				goto abort;
-		}
-
 		/*
-		 * Confirm the page maps to the correct subpage.
-		 *
-		 * Note that uprobe, debugger, or MAP_PRIVATE may change
-		 * the page table, but the new page will not pass
-		 * PageCompound() check.
+		 * Note that uprobe, debugger, or MAP_PRIVATE may change the
+		 * page table, but the new page will not be a subpage of hpage.
 		 */
-		if (WARN_ON(hpage + i != page))
+		if (hpage + i != page)
 			goto abort;
 		count++;
 	}
@@ -1495,7 +1484,7 @@ void collapse_pte_mapped_thp(struct mm_s
 	pte_unmap_unlock(start_pte, ptl);
 
 	/* step 3: set proper refcount and mm_counters. */
-	if (hpage) {
+	if (count) {
 		page_ref_sub(hpage, count);
 		add_mm_counter(vma->vm_mm, mm_counter_file(hpage), -count);
 	}
@@ -1506,10 +1495,15 @@ void collapse_pte_mapped_thp(struct mm_s
 	spin_unlock(ptl);
 	mm_dec_nr_ptes(mm);
 	pte_free(mm, pmd_pgtable(_pmd));
+
+drop_hpage:
+	unlock_page(hpage);
+	put_page(hpage);
 	return;
 
 abort:
 	pte_unmap_unlock(start_pte, ptl);
+	goto drop_hpage;
 }
 
 static int khugepaged_collapse_pte_mapped_thps(struct mm_slot *mm_slot)
_

Patches currently in -mm which might be from hughd@google.com are

mm-memcontrol-decouple-reference-counting-from-page-accounting-fix.patch
khugepaged-collapse_pte_mapped_thp-flush-the-right-range.patch
khugepaged-collapse_pte_mapped_thp-protect-the-pmd-lock.patch
khugepaged-retract_page_tables-remember-to-test-exit.patch
khugepaged-khugepaged_test_exit-check-mmget_still_valid.patch

