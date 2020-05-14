Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5010E1D36D3
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 18:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgENQnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 12:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgENQnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 12:43:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74472206A5;
        Thu, 14 May 2020 16:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589474600;
        bh=HeWbvhyTSO+XFHJB83iPRRTwt1aItSZnoe+pSmxsTEA=;
        h=Subject:To:From:Date:From;
        b=laGB1jlLcVkvgTJ3zzzZV2LyidPv6LW3nB98yLjOYKWsRhLdYhMFfAs52DzZOXf1l
         2AHGPC3KOYA3DOme4CRHoI6sTAM3mtA39VAlu8HUMVet7QbppUlHKsQlSN+V8Gd8S4
         ngSOJ6MmO/mVcRLv6MNKT4aoPMq/T3PyM6EeEsvA=
Subject: patch "USB: usbfs: fix mmap dma mismatch" added to usb-linus
To:     gregkh@linuxfoundation.org, hch@lst.de, hdanton@sina.com,
        jeremy.linton@arm.com, stable@vger.kernel.org, tglx@linutronix.de
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 14 May 2020 18:43:18 +0200
Message-ID: <1589474598134212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: usbfs: fix mmap dma mismatch

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a0e710a7def471b8eb779ff551fc27701da49599 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 14 May 2020 13:27:11 +0200
Subject: USB: usbfs: fix mmap dma mismatch

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
 drivers/usb/core/devio.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index b9db9812d6c5..d93d94d7ff50 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -251,9 +251,19 @@ static int usbdev_mmap(struct file *file, struct vm_area_struct *vma)
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
-- 
2.26.2


