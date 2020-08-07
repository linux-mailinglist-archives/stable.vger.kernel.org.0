Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0848323E74B
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 08:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgHGG0Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 02:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGG0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 02:26:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EABA22CAE;
        Fri,  7 Aug 2020 06:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781583;
        bh=+H9h3gbZQV/nqeTyWDou5z8jxCRM8miFBCjcPPPwNUE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CnzQKDTO/GhwIWZl+lmurwcUcn9cgAM7w/bTtkuKYNLmooK4exhSIJgt/KwHs7zdl
         exq6ia374gVa1Ux3ey3bZ6+s2BOj7+X+cK+4lZafT1Z7RsdOFbIWUV7+AuOcQ+Xnr2
         6ajky4vnFJLz+0lHTv3/Ucj2AHSLWfmGq9PGF9gc=
Date:   Thu, 06 Aug 2020 23:26:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, hughd@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        songliubraving@fb.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 160/163] khugepaged: retract_page_tables()
 remember to test exit
Message-ID: <20200807062622.MKPXQwQaY%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: khugepaged: retract_page_tables() remember to test exit

Only once have I seen this scenario (and forgot even to notice what forced
the eventual crash): a sequence of "BUG: Bad page map" alerts from
vm_normal_page(), from zap_pte_range() servicing exit_mmap();
pmd:00000000, pte values corresponding to data in physical page 0.

The pte mappings being zapped in this case were supposed to be from a huge
page of ext4 text (but could as well have been shmem): my belief is that
it was racing with collapse_file()'s retract_page_tables(), found *pmd
pointing to a page table, locked it, but *pmd had become 0 by the time
start_pte was decided.

In most cases, that possibility is excluded by holding mmap lock; but
exit_mmap() proceeds without mmap lock.  Most of what's run by khugepaged
checks khugepaged_test_exit() after acquiring mmap lock:
khugepaged_collapse_pte_mapped_thps() and hugepage_vma_revalidate() do so,
for example.  But retract_page_tables() did not: fix that.

The fix is for retract_page_tables() to check khugepaged_test_exit(),
after acquiring mmap lock, before doing anything to the page table. 
Getting the mmap lock serializes with __mmput(), which briefly takes and
drops it in __khugepaged_exit(); then the khugepaged_test_exit() check on
mm_users makes sure we don't touch the page table once exit_mmap() might
reach it, since exit_mmap() will be proceeding without mmap lock, not
expecting anyone to be racing with it.

Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008021215400.27773@eggly.anvils
Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: <stable@vger.kernel.org>	[4.8+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/mm/khugepaged.c~khugepaged-retract_page_tables-remember-to-test-exit
+++ a/mm/khugepaged.c
@@ -1532,6 +1532,7 @@ out:
 static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 {
 	struct vm_area_struct *vma;
+	struct mm_struct *mm;
 	unsigned long addr;
 	pmd_t *pmd, _pmd;
 
@@ -1560,7 +1561,8 @@ static void retract_page_tables(struct a
 			continue;
 		if (vma->vm_end < addr + HPAGE_PMD_SIZE)
 			continue;
-		pmd = mm_find_pmd(vma->vm_mm, addr);
+		mm = vma->vm_mm;
+		pmd = mm_find_pmd(mm, addr);
 		if (!pmd)
 			continue;
 		/*
@@ -1570,17 +1572,19 @@ static void retract_page_tables(struct a
 		 * mmap_lock while holding page lock. Fault path does it in
 		 * reverse order. Trylock is a way to avoid deadlock.
 		 */
-		if (mmap_write_trylock(vma->vm_mm)) {
-			spinlock_t *ptl = pmd_lock(vma->vm_mm, pmd);
-			/* assume page table is clear */
-			_pmd = pmdp_collapse_flush(vma, addr, pmd);
-			spin_unlock(ptl);
-			mmap_write_unlock(vma->vm_mm);
-			mm_dec_nr_ptes(vma->vm_mm);
-			pte_free(vma->vm_mm, pmd_pgtable(_pmd));
+		if (mmap_write_trylock(mm)) {
+			if (!khugepaged_test_exit(mm)) {
+				spinlock_t *ptl = pmd_lock(mm, pmd);
+				/* assume page table is clear */
+				_pmd = pmdp_collapse_flush(vma, addr, pmd);
+				spin_unlock(ptl);
+				mm_dec_nr_ptes(mm);
+				pte_free(mm, pmd_pgtable(_pmd));
+			}
+			mmap_write_unlock(mm);
 		} else {
 			/* Try again later */
-			khugepaged_add_pte_mapped_thp(vma->vm_mm, addr);
+			khugepaged_add_pte_mapped_thp(mm, addr);
 		}
 	}
 	i_mmap_unlock_write(mapping);
_
