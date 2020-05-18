Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4131D8445
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732917AbgERSFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732915AbgERSFQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:05:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E04DA20671;
        Mon, 18 May 2020 18:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825115;
        bh=Bf23uZnLV3OlKoZqeEjp8dJdg25q3YALsYaxnGvftpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXQDxTREor8w7WS1DgiQsO0W4C/JPmUhgYT721s7tgPgkWywkypghSySHD6e+UZjK
         ZFwcCagB7VmD9UglLUlaeJHFTJ/fRPjKQT4NLXXgAG+k5ZYjvTwAZ6OBGdFuubz/cP
         QBsDF/8BFP42PKGZJhJyGYlMHP+jlXrZE1zy7hiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeremy Linton <jeremy.linton@arm.com>
Subject: [PATCH 5.6 136/194] usb: usbfs: correct kernel->user page attribute mismatch
Date:   Mon, 18 May 2020 19:37:06 +0200
Message-Id: <20200518173542.716290256@linuxfoundation.org>
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

From: Jeremy Linton <jeremy.linton@arm.com>

commit 2bef9aed6f0e22391c8d4570749b1acc9bc3981e upstream.

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
 drivers/usb/core/devio.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -217,6 +217,7 @@ static int usbdev_mmap(struct file *file
 {
 	struct usb_memory *usbm = NULL;
 	struct usb_dev_state *ps = file->private_data;
+	struct usb_hcd *hcd = bus_to_hcd(ps->dev->bus);
 	size_t size = vma->vm_end - vma->vm_start;
 	void *mem;
 	unsigned long flags;
@@ -250,9 +251,7 @@ static int usbdev_mmap(struct file *file
 	usbm->vma_use_count = 1;
 	INIT_LIST_HEAD(&usbm->memlist);
 
-	if (remap_pfn_range(vma, vma->vm_start,
-			virt_to_phys(usbm->mem) >> PAGE_SHIFT,
-			size, vma->vm_page_prot) < 0) {
+	if (dma_mmap_coherent(hcd->self.sysdev, vma, mem, dma_handle, size)) {
 		dec_usb_memory_use_count(usbm, &usbm->vma_use_count);
 		return -EAGAIN;
 	}


