Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0AFF6CCAF5
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 21:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjC1Txz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 15:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjC1Txy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 15:53:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86138C3;
        Tue, 28 Mar 2023 12:53:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 225EF618CB;
        Tue, 28 Mar 2023 19:53:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75EEDC433D2;
        Tue, 28 Mar 2023 19:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680033231;
        bh=dIZQCNFrFZwFibQdTBjWKJTTP6EA1JOLLqyc8V/4yr8=;
        h=Date:To:From:Subject:From;
        b=hPBoMQmd8dxbXB1TqfNOGz46HTYfjhdwIaqV0MrtQU9atkCgTPVpuJG5JOqjkWdZH
         GIZ4n+OtTFeteSHZOGmZZarjwzS9iL4heOFKUVW9UHXNQqkqxeAdTHY+afnkBVgjPY
         kCvXwD6AcXl1kjdagtOM5Wxo9i1AA8Jf5stfGs+4=
Date:   Tue, 28 Mar 2023 12:53:50 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rcampbell@nvidia.com, jhubbard@nvidia.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-take-a-page-reference-when-removing-device-exclusive-entries.patch added to mm-hotfixes-unstable branch
Message-Id: <20230328195351.75EEDC433D2@smtp.kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm: take a page reference when removing device exclusive entries
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-take-a-page-reference-when-removing-device-exclusive-entries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-take-a-page-reference-when-removing-device-exclusive-entries.patch

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
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
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

mm-take-a-page-reference-when-removing-device-exclusive-entries.patch

