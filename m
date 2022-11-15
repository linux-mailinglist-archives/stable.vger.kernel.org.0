Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F77B628EE8
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 02:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbiKOBIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 20:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiKOBIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 20:08:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC52F05;
        Mon, 14 Nov 2022 17:08:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C11A5614E7;
        Tue, 15 Nov 2022 01:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6C0C433D6;
        Tue, 15 Nov 2022 01:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668474510;
        bh=eNgm8jzWztFGkaoZgOrlyNTrUu6Ed9ds/XEOsGuA+UM=;
        h=Date:To:From:Subject:From;
        b=adSiGcJcFIDyEV9uEHhaWyPxCKNFI9oSqPZBkT/BRU5r7Qx/jsxtKbPR5KwqsofH9
         WCqH9E7UmaQR6Je2y4SSpdOtB5aMIbOkokQjWfYWVVLujYU9bfssMFIxlPvNlEtghx
         QJ2kfk6fKcmgW0TQp89BwckjtLe0Yy52PQemZi20=
Date:   Mon, 14 Nov 2022 17:08:29 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        stable@vger.kernel.org, riel@surriel.com, peterx@redhat.com,
        naoya.horiguchi@linux.dev, nadav.amit@gmail.com,
        harperchen1110@gmail.com, david@redhat.com,
        axelrasmussen@google.com, almasrymina@google.com,
        mike.kravetz@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch added to mm-hotfixes-unstable branch
Message-Id: <20221115010830.1D6C0C433D6@smtp.kernel.org>
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
Date: Mon, 14 Nov 2022 15:55:06 -0800

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

Address issue by adding a new zap flag ZAP_FLAG_UNMAP to indicate an unmap
call from unmap_vmas().  This is used to indicate the 'final' unmapping of
a hugetlb vma.  When called via MADV_DONTNEED, this flag is not set and
the vm_lock is not deleted.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/

Link: https://lkml.kernel.org/r/20221114235507.294320-3-mike.kravetz@oracle.com
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 ++
 mm/hugetlb.c       |   27 ++++++++++++++++-----------
 mm/memory.c        |    2 +-
 3 files changed, 19 insertions(+), 12 deletions(-)

--- a/include/linux/mm.h~hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing
+++ a/include/linux/mm.h
@@ -1868,6 +1868,8 @@ struct zap_details {
  * default, the flag is not set.
  */
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
+/* Set in unmap_vmas() to indicate a final unmap call.  Only used by hugetlb */
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
 
 #ifdef CONFIG_MMU
 extern bool can_do_mlock(void);
--- a/mm/hugetlb.c~hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing
+++ a/mm/hugetlb.c
@@ -5204,17 +5204,22 @@ void __unmap_hugepage_range_final(struct
 
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
-
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
+	if (zap_flags & ZAP_FLAG_UNMAP) {	/* final unmap */
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
--- a/mm/memory.c~hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing
+++ a/mm/memory.c
@@ -1711,7 +1711,7 @@ void unmap_vmas(struct mmu_gather *tlb,
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
-		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are

ipc-shm-call-underlying-open-close-vm_ops.patch
madvise-use-zap_page_range_single-for-madvise-dontneed.patch
hugetlb-dont-delete-vma_lock-in-hugetlb-madv_dontneed-processing.patch
selftests-vm-update-hugetlb-madvise.patch
hugetlb-remove-duplicate-mmu-notifications.patch

