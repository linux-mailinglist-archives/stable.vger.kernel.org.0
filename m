Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974531C53EE
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 13:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728565AbgEELIX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 07:08:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728584AbgEELIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 07:08:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37570206B8;
        Tue,  5 May 2020 11:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588676900;
        bh=rTS4sAWRIKpMhi7hEVazwFvLHrINZkWfgmyIZpewiR4=;
        h=Subject:To:From:Date:From;
        b=IF7sLI2KQ/4GWZ5TFXli1G6eCEq2/CtbdSE4H32N34aSlkuNHltVgC2WJxTlM/sTI
         Pylhy81IX8OdIJoLBVqdhJQDzUVWpHg5S0v/sOxMeRAnz8YwyLdTIRXQ0jDGp/cnql
         iYKRGHGKrQYi4OGzA9E5RS6bryB9C01eFriJoKZg=
Subject: patch "usb: usbfs: correct kernel->user page attribute mismatch" added to usb-linus
To:     jeremy.linton@arm.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 May 2020 13:08:06 +0200
Message-ID: <158867688647127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: usbfs: correct kernel->user page attribute mismatch

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2bef9aed6f0e22391c8d4570749b1acc9bc3981e Mon Sep 17 00:00:00 2001
From: Jeremy Linton <jeremy.linton@arm.com>
Date: Mon, 4 May 2020 15:13:48 -0500
Subject: usb: usbfs: correct kernel->user page attribute mismatch

On some architectures (e.g. arm64) requests for
IO coherent memory may use non-cachable attributes if
the relevant device isn't cache coherent. If these
pages are then remapped into userspace as cacheable,
they may not be coherent with the non-cacheable mappings.

In particular this happens with libusb, when it attempts
to create zero-copy buffers for use by rtl-sdr
(https://github.com/osmocom/rtl-sdr/). On low end arm
devices with non-coherent USB ports, the application will
be unexpectedly killed, while continuing to work fine on
arm machines with coherent USB controllers.

This bug has been discovered/reported a few times over
the last few years. In the case of rtl-sdr a compile time
option to enable/disable zero copy was implemented to
work around it.

Rather than relaying on application specific workarounds,
dma_mmap_coherent() can be used instead of remap_pfn_range().
The page cache/etc attributes will then be correctly set in
userspace to match the kernel mapping.

Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200504201348.1183246-1-jeremy.linton@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/devio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 6833c918abce..b9db9812d6c5 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -217,6 +217,7 @@ static int usbdev_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct usb_memory *usbm = NULL;
 	struct usb_dev_state *ps = file->private_data;
+	struct usb_hcd *hcd = bus_to_hcd(ps->dev->bus);
 	size_t size = vma->vm_end - vma->vm_start;
 	void *mem;
 	unsigned long flags;
@@ -250,9 +251,7 @@ static int usbdev_mmap(struct file *file, struct vm_area_struct *vma)
 	usbm->vma_use_count = 1;
 	INIT_LIST_HEAD(&usbm->memlist);
 
-	if (remap_pfn_range(vma, vma->vm_start,
-			virt_to_phys(usbm->mem) >> PAGE_SHIFT,
-			size, vma->vm_page_prot) < 0) {
+	if (dma_mmap_coherent(hcd->self.sysdev, vma, mem, dma_handle, size)) {
 		dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
 		return -EAGAIN;
 	}
-- 
2.26.2


