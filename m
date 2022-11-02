Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6F961572D
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 02:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiKBB7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 21:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiKBB7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 21:59:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF3A140BB;
        Tue,  1 Nov 2022 18:59:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2977B82057;
        Wed,  2 Nov 2022 01:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F040C433D6;
        Wed,  2 Nov 2022 01:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667354378;
        bh=az2Wz96x1qpo+Qj9MnlZp7VPRGGuI7lpThYxrqbeRe4=;
        h=Date:To:From:Subject:From;
        b=iKq2uT4mrHM8d3PmAMwmURZ+1STvbxsomDDeMty200xJgFUVkeUBtIp3/Am2xvRAO
         d9AwfyI1tZFZKd9WQBvmAG/CMqU/8b5TJVvoMfxGFPA7sIhNgUD0w4D1T6EUxRGeL3
         NicTStcB+ynmZq+q1rM0PecbljTXAVWybxiVAumE=
Date:   Tue, 01 Nov 2022 18:59:36 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        stable@vger.kernel.org, riel@surriel.com, peterx@redhat.com,
        naoya.horiguchi@linux.dev, nadav.amit@gmail.com,
        harperchen1110@gmail.com, david@redhat.com,
        axelrasmussen@google.com, almasrymina@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch added to mm-hotfixes-unstable branch
Message-Id: <20221102015938.3F040C433D6@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch

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
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing
Date: Tue, 1 Nov 2022 18:31:00 -0700

madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear page
tables associated with the address range.  For hugetlb vmas,
zap_page_range will call __unmap_hugepage_range_final.  However,
__unmap_hugepage_range_final assumes the passed vma is about to be removed
and deletes the vma_lock to prevent pmd sharing as the vma is on the way
out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
missing vma_lock prevents pmd sharing and could potentially lead to issues
with truncation/fault races.

This issue was originally reported here [1] as a BUG triggered in
page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
prevent pmd sharing.  Subsequent faults on this vma were confused as
VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping was
not set in new pages added to the page table.  This resulted in pages that
appeared anonymous in a VM_SHARED vma and triggered the BUG.

Address issue by:
- Add a new zap flag ZAP_FLAG_UNMAP to indicate an unmap call from
  unmap_vmas().  This is used to indicate the 'final' unmapping of a vma.
  When called via MADV_DONTNEED, this flag is not set and the vm_lock is
  not deleted.
- mmu notification is removed from __unmap_hugepage_range to avoid
  duplication, and notification is added to the other calling routine
  (unmap_hugepage_range).
- notification calls are updated in zap_page range to take into account
  the possibility of multiple vmas.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/
Link: https://lkml.kernel.org/r/20221102013100.455139-1-mike.kravetz@oracle.com
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++
 mm/hugetlb.c       |   45 +++++++++++++++++++++++++------------------
 mm/memory.c        |   21 ++++++++++++++------
 3 files changed, 45 insertions(+), 24 deletions(-)

--- a/include/linux/mm.h~hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing
+++ a/include/linux/mm.h
@@ -3475,4 +3475,7 @@ madvise_set_anon_name(struct mm_struct *
  */
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
 
+/* Set in unmap_vmas() to indicate an unmap call.  Only used by hugetlb */
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
+
 #endif /* _LINUX_MM_H */
--- a/mm/hugetlb.c~hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing
+++ a/mm/hugetlb.c
@@ -5064,7 +5064,6 @@ static void __unmap_hugepage_range(struc
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	struct mmu_notifier_range range;
 	unsigned long last_addr_mask;
 	bool force_flush = false;
 
@@ -5079,13 +5078,6 @@ static void __unmap_hugepage_range(struc
 	tlb_change_page_size(tlb, sz);
 	tlb_start_vma(tlb, vma);
 
-	/*
-	 * If sharing possible, alert mmu notifiers of worst case.
-	 */
-	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, start,
-				end);
-	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
-	mmu_notifier_invalidate_range_start(&range);
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
@@ -5174,7 +5166,6 @@ static void __unmap_hugepage_range(struc
 		if (ref_page)
 			break;
 	}
-	mmu_notifier_invalidate_range_end(&range);
 	tlb_end_vma(tlb, vma);
 
 	/*
@@ -5199,32 +5190,50 @@ void __unmap_hugepage_range_final(struct
 			  unsigned long end, struct page *ref_page,
 			  zap_flags_t zap_flags)
 {
+	bool final = zap_flags & ZAP_FLAG_UNMAP;
+
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
 	/*
-	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
-	 * the vma_lock is freed, this makes the vma ineligible for pmd
-	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
-	 * This is important as page tables for this unmapped range will
-	 * be asynchrously deleted.  If the page tables are shared, there
-	 * will be issues when accessed by someone else.
+	 * When called via zap_page_range (MADV_DONTNEED), this is not the
+	 * final unmap of the vma, and we do not want to delete the vma_lock.
 	 */
-	__hugetlb_vma_unlock_write_free(vma);
-
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
+	if (final) {
+		/*
+		 * Unlock and free the vma lock before releasing i_mmap_rwsem.
+		 * When the vma_lock is freed, this makes the vma ineligible
+		 * for pmd sharing.  And, i_mmap_rwsem is required to set up
+		 * pmd sharing.  This is important as page tables for this
+		 * unmapped range will be asynchrously deleted.  If the page
+		 * tables are shared, there will be issues when accessed by
+		 * someone else.
+		 */
+		__hugetlb_vma_unlock_write_free(vma);
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+	} else {
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+		hugetlb_vma_unlock_write(vma);
+	}
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
 			  zap_flags_t zap_flags)
 {
+	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+				start, end);
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
+
 	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
+
+	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 }
 
--- a/mm/memory.c~hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing
+++ a/mm/memory.c
@@ -1720,7 +1720,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
-		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};
@@ -1753,15 +1753,24 @@ void zap_page_range(struct vm_area_struc
 	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
 
 	lru_add_drain();
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				start, start + size);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 	update_hiwater_rss(vma->vm_mm);
-	mmu_notifier_invalidate_range_start(&range);
 	do {
-		unmap_single_vma(&tlb, vma, start, range.end, NULL);
+		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma,
+					vma->vm_mm,
+					max(start, vma->vm_start),
+					min(end, vma->vm_end));
+		if (is_vm_hugetlb_page(vma))
+			adjust_range_if_pmd_sharing_possible(vma,
+						&range.start, &range.end);
+		mmu_notifier_invalidate_range_start(&range);
+		/*
+		 * unmap 'start-end' not 'range.start-range.end' as range
+		 * could have been expanded for pmd sharing.
+		 */
+		unmap_single_vma(&tlb, vma, start, end, NULL);
+		mmu_notifier_invalidate_range_end(&range);
 	} while ((vma = mas_find(&mas, end - 1)) != NULL);
-	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v4.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask-v5.patch

