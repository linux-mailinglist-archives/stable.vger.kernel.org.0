Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967136DDC8B
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjDKNqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjDKNqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:46:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50701421E
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:46:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7AB1626B0
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80E5C433D2;
        Tue, 11 Apr 2023 13:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681220769;
        bh=fWgR2AZE7LhbEMIFzTq17gSxEyTJAWjgS7eIaeNES9Q=;
        h=Subject:To:Cc:From:Date:From;
        b=Z0vFHiDxsjeto+L4Y48gLVOLSdyo2JC/2qMrtOnZlMJGW9t+eowKzEBRwhXCaDkQs
         2n6B5GHiYJ13YoNxeMQkqeRGkX+XRfZNutSBuAX6aqO9BNqTzgpxEYQpp1fSpQKq3k
         2wjAUOAmbErJaEaC/05fHaBAoZIC4FVm48RXnyKY=
Subject: FAILED: patch "[PATCH] mm: take a page reference when removing device exclusive" failed to apply to 5.15-stable tree
To:     apopple@nvidia.com, akpm@linux-foundation.org, david@redhat.com,
        hch@infradead.org, jhubbard@nvidia.com, rcampbell@nvidia.com,
        stable@vger.kernel.org, willy@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 15:45:57 +0200
Message-ID: <2023041157-hyperlink-prognosis-e6db@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x 7c7b962938ddda6a9cd095de557ee5250706ea88
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041157-hyperlink-prognosis-e6db@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

7c7b962938dd ("mm: take a page reference when removing device exclusive entries")
7d4a8be0c4b2 ("mm/mmu_notifier: remove unused mmu_notifier_range_update_to_read_only export")
369258ce41c6 ("hugetlb: remove duplicate mmu notifications")
f268f6cf875f ("mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths")
2ba99c5e0881 ("mm/khugepaged: fix GUP-fast interaction by sending IPI")
8d3c106e19e8 ("mm/khugepaged: take the right locks for page table retraction")
21b85b09527c ("madvise: use zap_page_range_single for madvise dontneed")
131a79b474e9 ("hugetlb: fix vma lock handling during split vma and range unmapping")
34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds")
780a4b6fb865 ("mm/khugepaged: check compound_order() in collapse_pte_mapped_thp()")
40549ba8f8e0 ("hugetlb: use new vma_lock for pmd sharing synchronization")
378397ccb8e5 ("hugetlb: create hugetlb_unmap_file_folio to unmap single file folio")
8d9bfb260814 ("hugetlb: add vma based lock for pmd sharing")
12710fd69634 ("hugetlb: rename vma_shareable() and refactor code")
c86272287bc6 ("hugetlb: create remove_inode_single_folio to remove single file folio")
7e1813d48dd3 ("hugetlb: rename remove_huge_page to hugetlb_delete_from_page_cache")
3a47c54f09c4 ("hugetlbfs: revert use i_mmap_rwsem for more pmd sharing synchronization")
188a39725ad7 ("hugetlbfs: revert use i_mmap_rwsem to address page fault/truncate race")
19672a9e4a75 ("mm: convert lock_page_or_retry() to folio_lock_or_retry()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7c7b962938ddda6a9cd095de557ee5250706ea88 Mon Sep 17 00:00:00 2001
From: Alistair Popple <apopple@nvidia.com>
Date: Thu, 30 Mar 2023 12:25:19 +1100
Subject: [PATCH] mm: take a page reference when removing device exclusive
 entries

Device exclusive page table entries are used to prevent CPU access to a
page whilst it is being accessed from a device.  Typically this is used to
implement atomic operations when the underlying bus does not support
atomic access.  When a CPU thread encounters a device exclusive entry it
locks the page and restores the original entry after calling mmu notifiers
to signal drivers that exclusive access is no longer available.

The device exclusive entry holds a reference to the page making it safe to
access the struct page whilst the entry is present.  However the fault
handling code does not hold the PTL when taking the page lock.  This means
if there are multiple threads faulting concurrently on the device
exclusive entry one will remove the entry whilst others will wait on the
page lock without holding a reference.

This can lead to threads locking or waiting on a folio with a zero
refcount.  Whilst mmap_lock prevents the pages getting freed via munmap()
they may still be freed by a migration.  This leads to warnings such as
PAGE_FLAGS_CHECK_AT_FREE due to the page being locked when the refcount
drops to zero.

Fix this by trying to take a reference on the folio before locking it.
The code already checks the PTE under the PTL and aborts if the entry is
no longer there.  It is also possible the folio has been unmapped, freed
and re-allocated allowing a reference to be taken on an unrelated folio.
This case is also detected by the PTE check and the folio is unlocked
without further changes.

Link: https://lkml.kernel.org/r/20230330012519.804116-1-apopple@nvidia.com
Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/mm/memory.c b/mm/memory.c
index f456f3b5049c..01a23ad48a04 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3563,8 +3563,21 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 	struct vm_area_struct *vma = vmf->vma;
 	struct mmu_notifier_range range;
 
-	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags))
+	/*
+	 * We need a reference to lock the folio because we don't hold
+	 * the PTL so a racing thread can remove the device-exclusive
+	 * entry and unmap it. If the folio is free the entry must
+	 * have been removed already. If it happens to have already
+	 * been re-allocated after being freed all we do is lock and
+	 * unlock it.
+	 */
+	if (!folio_try_get(folio))
+		return 0;
+
+	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags)) {
+		folio_put(folio);
 		return VM_FAULT_RETRY;
+	}
 	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0,
 				vma->vm_mm, vmf->address & PAGE_MASK,
 				(vmf->address & PAGE_MASK) + PAGE_SIZE, NULL);
@@ -3577,6 +3590,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	folio_unlock(folio);
+	folio_put(folio);
 
 	mmu_notifier_invalidate_range_end(&range);
 	return 0;

