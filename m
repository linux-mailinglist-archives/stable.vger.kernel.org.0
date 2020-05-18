Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1CE51D8440
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730696AbgERSKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:10:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:52790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732923AbgERSFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:05:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F579207D3;
        Mon, 18 May 2020 18:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825117;
        bh=FjxbjY8TPADnA/AF5u+7Spbw+rwAX8aoWlhgy1tMX3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDOZrX3k3zhNp5bIuEnDz4ksHLioMhksrKWhKVbxtME3rI4p2BxpgVk2FR7auo6bc
         0Zcd96lbUlAXgLOB6w1VrT2lj7hnV/SE4MMW0RSsU1bpbCQmh8fiu7gJjq5ceKR7t0
         KjT04/gj0b8f/CsBvPyRu+/O9t24OkKvomcyxXkA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hillf Danton <hdanton@sina.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Linton <jeremy.linton@arm.com>,
        syzbot+353be47c9ce21b68b7ed@syzkaller.appspotmail.com
Subject: [PATCH 5.6 137/194] USB: usbfs: fix mmap dma mismatch
Date:   Mon, 18 May 2020 19:37:07 +0200
Message-Id: <20200518173542.781416927@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit a0e710a7def471b8eb779ff551fc27701da49599 upstream.

In commit 2bef9aed6f0e ("usb: usbfs: correct kernel->user page attribute
mismatch") we switched from always calling remap_pfn_range() to call
dma_mmap_coherent() to handle issues with systems with non-coherent USB host
controller drivers.  Unfortunatly, as syzbot quickly told us, not all the world
is host controllers with DMA support, so we need to check what host controller
we are attempting to talk to before doing this type of allocation.

Thanks to Christoph for the quick idea of how to fix this.

Fixes: 2bef9aed6f0e ("usb: usbfs: correct kernel->user page attribute mismatch")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeremy Linton <jeremy.linton@arm.com>
Cc: stable <stable@vger.kernel.org>
Reported-by: syzbot+353be47c9ce21b68b7ed@syzkaller.appspotmail.com
Reviewed-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20200514112711.1858252-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/devio.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -251,9 +251,19 @@ static int usbdev_mmap(struct file *file
 	usbm->vma_use_count = 1;
 	INIT_LIST_HEAD(&usbm->memlist);
 
-	if (dma_mmap_coherent(hcd->self.sysdev, vma, mem, dma_handle, size)) {
-		dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
-		return -EAGAIN;
+	if (hcd->localmem_pool || !hcd_uses_dma(hcd)) {
+		if (remap_pfn_range(vma, vma->vm_start,
+				    virt_to_phys(usbm->mem) >> PAGE_SHIFT,
+				    size, vma->vm_page_prot) < 0) {
+			dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
+			return -EAGAIN;
+		}
+	} else {
+		if (dma_mmap_coherent(hcd->self.sysdev, vma, mem, dma_handle,
+				      size)) {
+			dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
+			return -EAGAIN;
+		}
 	}
 
 	vma->vm_flags |= VM_IO;


