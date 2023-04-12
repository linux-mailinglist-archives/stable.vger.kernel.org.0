Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B776DEE47
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjDLIlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbjDLIk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6F37ABA
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:40:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 130DF629BC
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28529C4339B;
        Wed, 12 Apr 2023 08:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288739;
        bh=oMT2R2Foa4wOad4EX6fd1c+6fMvn1/GgbHWxdd1bEX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQzWJz8Y5IQ5kWeTbTmzgwZFdfQHs3jZgNVqrjq2C1dDz2lrqmaiGR7mYVrf/Myd7
         Kw19J5dN0kZody9ZngJYkPJ+cUtnylbqNFnb8FtPAHHRKVpXwQ7iQUvfWitCjNPmiT
         3udQe2aXpJAL1JIw8/Scpq+hWnNkKvBW2ZfAd0E4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alistair Popple <apopple@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 93/93] mm: take a page reference when removing device exclusive entries
Date:   Wed, 12 Apr 2023 10:34:34 +0200
Message-Id: <20230412082827.068122936@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Popple <apopple@nvidia.com>

commit 7c7b962938ddda6a9cd095de557ee5250706ea88 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3462,8 +3462,21 @@ static vm_fault_t remove_device_exclusiv
 	struct vm_area_struct *vma = vmf->vma;
 	struct mmu_notifier_range range;
 
-	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags))
+	/*
+	 * We need a reference to lock the page because we don't hold
+	 * the PTL so a racing thread can remove the device-exclusive
+	 * entry and unmap it. If the page is free the entry must
+	 * have been removed already. If it happens to have already
+	 * been re-allocated after being freed all we do is lock and
+	 * unlock it.
+	 */
+	if (!get_page_unless_zero(page))
+		return 0;
+
+	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags)) {
+		put_page(page);
 		return VM_FAULT_RETRY;
+	}
 	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_EXCLUSIVE, 0, vma,
 				vma->vm_mm, vmf->address & PAGE_MASK,
 				(vmf->address & PAGE_MASK) + PAGE_SIZE, NULL);
@@ -3476,6 +3489,7 @@ static vm_fault_t remove_device_exclusiv
 
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	unlock_page(page);
+	put_page(page);
 
 	mmu_notifier_invalidate_range_end(&range);
 	return 0;


