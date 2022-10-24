Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA7560BF88
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 02:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJYA14 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 20:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiJYA1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 20:27:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020992FACE9;
        Mon, 24 Oct 2022 15:50:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 486C6615C5;
        Mon, 24 Oct 2022 22:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984E1C433C1;
        Mon, 24 Oct 2022 22:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666651838;
        bh=kBpMU9jnXAoVzKusj74FBB6tfC1ISE3oAwtR7HQijpI=;
        h=Date:To:From:Subject:From;
        b=mdyTf6ioES5GVgtqtvyWuOUv2o8XU1Y+pq5+x9I2I0a5V5FS6wynkoF3MSyyVgqnK
         NDWFtYXhh7N103srxulmLyDoV4w8inYmteMML+mPFhFz7mHG9YCzHAGZJ2Bbk+DfsA
         GWmGG+2I6MeMlWA7xRXFfQ5S8jX8bDyfA2PVCtoo=
Date:   Mon, 24 Oct 2022 15:50:37 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        stable@vger.kernel.org, riel@surriel.com, peterx@redhat.com,
        naoya.horiguchi@linux.dev, harperchen1110@gmail.com,
        david@redhat.com, axelrasmussen@google.com, almasrymina@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch added to mm-hotfixes-unstable branch
Message-Id: <20221024225038.984E1C433C1@smtp.kernel.org>
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
Date: Sat, 22 Oct 2022 19:50:47 -0700

madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear the page
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

Create a new routine clear_hugetlb_page_range() that can be called from
madvise(MADV_DONTNEED) for hugetlb vmas.  It has the same setup as
zap_page_range, but does not delete the vma_lock.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/

Link: https://lkml.kernel.org/r/20221023025047.470646-1-mike.kravetz@oracle.com
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    7 ++++
 mm/hugetlb.c            |   62 ++++++++++++++++++++++++++++++--------
 mm/madvise.c            |    5 ++-
 3 files changed, 61 insertions(+), 13 deletions(-)

--- a/include/linux/hugetlb.h~hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing
+++ a/include/linux/hugetlb.h
@@ -156,6 +156,8 @@ long follow_hugetlb_page(struct mm_struc
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *,
 			  zap_flags_t);
+void clear_hugetlb_page_range(struct vm_area_struct *vma,
+			unsigned long start, unsigned long end);
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma,
 			  unsigned long start, unsigned long end,
@@ -460,6 +462,11 @@ static inline void __unmap_hugepage_rang
 	BUG();
 }
 
+static void __maybe_unused clear_hugetlb_page_range(struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+
 static inline vm_fault_t hugetlb_fault(struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long address,
 			unsigned int flags)
--- a/mm/hugetlb.c~hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing
+++ a/mm/hugetlb.c
@@ -5194,28 +5194,66 @@ static void __unmap_hugepage_range(struc
 		tlb_flush_mmu_tlbonly(tlb);
 }
 
-void __unmap_hugepage_range_final(struct mmu_gather *tlb,
+static void __unmap_hugepage_range_locking(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
-			  zap_flags_t zap_flags)
+			  zap_flags_t zap_flags, bool final)
 {
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
-	/*
-	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
-	 * the vma_lock is freed, this makes the vma ineligible for pmd
-	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
-	 * This is important as page tables for this unmapped range will
-	 * be asynchrously deleted.  If the page tables are shared, there
-	 * will be issues when accessed by someone else.
-	 */
-	__hugetlb_vma_unlock_write_free(vma);
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
+}
+
+void __unmap_hugepage_range_final(struct mmu_gather *tlb,
+			  struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, struct page *ref_page,
+			  zap_flags_t zap_flags)
+{
+	__unmap_hugepage_range_locking(tlb, vma, start, end, ref_page,
+					zap_flags, true);
+}
+
+#ifdef CONFIG_ADVISE_SYSCALLS
+/*
+ * Similar setup as in zap_page_range().  madvise(MADV_DONTNEED) can not call
+ * zap_page_range for hugetlb vmas as __unmap_hugepage_range_final will delete
+ * the associated vma_lock.
+ */
+void clear_hugetlb_page_range(struct vm_area_struct *vma, unsigned long start,
+				unsigned long end)
+{
+	struct mmu_notifier_range range;
+	struct mmu_gather tlb;
+
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+				start, end);
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	update_hiwater_rss(vma->vm_mm);
+
+	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0, false);
 
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
+	mmu_notifier_invalidate_range_end(&range);
+	tlb_finish_mmu(&tlb);
 }
+#endif
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
--- a/mm/madvise.c~hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing
+++ a/mm/madvise.c
@@ -790,7 +790,10 @@ static int madvise_free_single_vma(struc
 static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
-	zap_page_range(vma, start, end - start);
+	if (!is_vm_hugetlb_page(vma))
+		zap_page_range(vma, start, end - start);
+	else
+		clear_hugetlb_page_range(vma, start, end);
 	return 0;
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch
hugetlb-simplify-hugetlb-handling-in-follow_page_mask.patch

