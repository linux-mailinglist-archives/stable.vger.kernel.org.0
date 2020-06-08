Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6DA1F2E78
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgFIAmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:42:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729151AbgFHXMf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:12:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA52320B80;
        Mon,  8 Jun 2020 23:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657955;
        bh=spO/HSfwf6g4rkiQIWvgoVADYVbHoa3Xxggv51hytNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6cnTAed4SCE1iVd2jSl7sjbdG744fztjOyxXZP3dfgpbkMi+f9UskzptCXzqtlSJ
         x07WQUzx1SicRq0NLIE5bIH1lO9VrUjteQj8w+oKTz7IiN71DGJh85Q/+PrgXLlVj4
         +tB+dZPW5zegfoNyMQGM4Zy7MQq4t9RNhXgMARfg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 020/606] usb: usbfs: correct kernel->user page attribute mismatch
Date:   Mon,  8 Jun 2020 19:02:25 -0400
Message-Id: <20200608231211.3363633-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
2.25.1

