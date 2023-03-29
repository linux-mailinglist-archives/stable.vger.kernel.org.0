Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDFE6CF623
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 00:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjC2WFc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 18:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjC2WFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 18:05:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F89D3;
        Wed, 29 Mar 2023 15:05:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FE3B61E40;
        Wed, 29 Mar 2023 22:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91585C433D2;
        Wed, 29 Mar 2023 22:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680127527;
        bh=R/7u4KPs6mZSMViaEmawvtJ1k16I7IpU1u836QM6Yq4=;
        h=Date:To:From:Subject:From;
        b=RniCIN+TdX1Hm7zn6TYqmkjuI/mRXbEPq0O7nyTs7q00LYqxmeNS2mrVwQSdVAJLK
         4PvvpkAYDtVnRL4n3NuhApARPiqdRC3Lynsch9W3KJ0BCW5httSyS6JG4OYyjJkWrK
         1fid/785ZROkVI6zm5siYbSAQJyyaZfoP/gvu4tU=
Date:   Wed, 29 Mar 2023 15:05:26 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rcampbell@nvidia.com, jhubbard@nvidia.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-take-a-page-reference-when-removing-device-exclusive-entries.patch removed from -mm tree
Message-Id: <20230329220527.91585C433D2@smtp.kernel.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm: take a page reference when removing device exclusive entries
has been removed from the -mm tree.  Its filename was
     mm-take-a-page-reference-when-removing-device-exclusive-entries.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm: take a page reference when removing device exclusive entries
Date: Tue, 28 Mar 2023 13:14:34 +1100

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

This can lead to threads locking or waiting on a page with a zero
refcount.  Whilst mmap_lock prevents the pages getting freed via munmap()
they may still be freed by a migration.  This leads to warnings such as
PAGE_FLAGS_CHECK_AT_FREE due to the page being locked when the refcount
drops to zero.  Note that during removal of the device exclusive entry the
PTE is currently re-checked under the PTL so no futher bad page accesses
occur once it is locked.

Link: https://lkml.kernel.org/r/20230328021434.292971-1-apopple@nvidia.com
Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-take-a-page-reference-when-removing-device-exclusive-entries
+++ a/mm/memory.c
@@ -3563,8 +3563,19 @@ static vm_fault_t remove_device_exclusiv
 	struct vm_area_struct *vma = vmf->vma;
 	struct mmu_notifier_range range;
 
-	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags))
+	/*
+	 * We need a page reference to lock the page because we don't hold the
+	 * PTL so a racing thread can remove the device-exclusive entry and
+	 * unmap the page. If the page is free the entry must have been
+	 * removed already.
+	 */
+	if (!get_page_unless_zero(vmf->page))
+		return 0;
+
+	if (!folio_lock_or_retry(folio, vma->vm_mm, vmf->flags)) {
+		put_page(vmf->page);
 		return VM_FAULT_RETRY;
+	}
 	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0,
 				vma->vm_mm, vmf->address & PAGE_MASK,
 				(vmf->address & PAGE_MASK) + PAGE_SIZE, NULL);
@@ -3577,6 +3588,7 @@ static vm_fault_t remove_device_exclusiv
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	folio_unlock(folio);
+	put_page(vmf->page);
 
 	mmu_notifier_invalidate_range_end(&range);
 	return 0;
_

Patches currently in -mm which might be from apopple@nvidia.com are


