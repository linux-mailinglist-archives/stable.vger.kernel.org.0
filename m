Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2A8321628
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhBVMSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:18:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230412AbhBVMQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:16:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 598D360C3E;
        Mon, 22 Feb 2021 12:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996153;
        bh=pmdFR3p1Jl/qgiNd85/vhQMz3r4b0/uDSUkG17/wa78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xd8QA74EXQrmbh3itWsSZwDgIFSO4c3nrtQbDtnsg0R9p1k4jhlcF5GyZ0f3dnFi/
         cx8VQOHP9LHqRxgoqMdWgvVwdSiIOYzJxyupoCLH439B8pVyCYJ01iVyVf0ILISCNP
         zVV6K5nMZZ9ly3aChzS/bM/h2pcLKu+o3sCmULA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Matwey V. Kornilov" <matwey@sai.msu.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 13/13] media: pwc: Use correct device for DMA
Date:   Mon, 22 Feb 2021 13:13:30 +0100
Message-Id: <20210222121019.289884558@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.583922436@linuxfoundation.org>
References: <20210222121013.583922436@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matwey V. Kornilov <matwey@sai.msu.ru>

commit 69c9e825e812ec6d663e64ebf14bd3bc7f37e2c7 upstream.

This fixes the following newly introduced warning:

[   15.518253] ------------[ cut here ]------------
[   15.518941] WARNING: CPU: 0 PID: 246 at kernel/dma/mapping.c:149 dma_map_page_attrs+0x1a8/0x1d0
[   15.520634] Modules linked in: pwc videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common videodev mc efivarfs
[   15.522335] CPU: 0 PID: 246 Comm: v4l2-test Not tainted 5.11.0-rc1+ #1
[   15.523281] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[   15.524438] RIP: 0010:dma_map_page_attrs+0x1a8/0x1d0
[   15.525135] Code: 10 5b 5d 41 5c 41 5d c3 4d 89 d0 eb d7 4d 89 c8 89 e9 48 89 da e8 68 29 00 00 eb d1 48 89 f2 48 2b 50 18 48 89 d0 eb 83 0f 0b <0f> 0b 48 c7 c0 ff ff ff ff eb b8 48 89 d9 48 8b 40 40 e8 61 69 d2
[   15.527938] RSP: 0018:ffffa2694047bca8 EFLAGS: 00010246
[   15.528716] RAX: 0000000000000000 RBX: 0000000000002580 RCX: 0000000000000000
[   15.529782] RDX: 0000000000000000 RSI: ffffcdce000ecc00 RDI: ffffa0b4bdb888a0
[   15.530849] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[   15.531881] R10: 0000000000000004 R11: 000000000002d8c0 R12: 0000000000000000
[   15.532911] R13: ffffa0b4bdb88800 R14: ffffa0b483820000 R15: ffffa0b4bdb888a0
[   15.533942] FS:  00007fc5fbb5e4c0(0000) GS:ffffa0b4fc000000(0000) knlGS:0000000000000000
[   15.535141] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   15.535988] CR2: 00007fc5fb6ea138 CR3: 0000000003812000 CR4: 00000000001506f0
[   15.537025] Call Trace:
[   15.537425]  start_streaming+0x2e9/0x4b0 [pwc]
[   15.538143]  vb2_start_streaming+0x5e/0x110 [videobuf2_common]
[   15.538989]  vb2_core_streamon+0x107/0x140 [videobuf2_common]
[   15.539831]  __video_do_ioctl+0x18f/0x4a0 [videodev]
[   15.540670]  video_usercopy+0x13a/0x5b0 [videodev]
[   15.541349]  ? video_put_user+0x230/0x230 [videodev]
[   15.542096]  ? selinux_file_ioctl+0x143/0x200
[   15.542752]  v4l2_ioctl+0x40/0x50 [videodev]
[   15.543360]  __x64_sys_ioctl+0x89/0xc0
[   15.543930]  do_syscall_64+0x33/0x40
[   15.544448]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   15.545236] RIP: 0033:0x7fc5fb671587
[   15.545780] Code: b3 66 90 48 8b 05 11 49 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e1 48 2c 00 f7 d8 64 89 01 48
[   15.548486] RSP: 002b:00007fff0f71f038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[   15.549578] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fc5fb671587
[   15.550664] RDX: 00007fff0f71f060 RSI: 0000000040045612 RDI: 0000000000000003
[   15.551706] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[   15.552738] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fff0f71f060
[   15.553817] R13: 00007fff0f71f1d0 R14: 0000000000de1270 R15: 0000000000000000
[   15.554914] ---[ end trace 7be03122966c2486 ]---

Fixes: 1161db6776bd ("media: usb: pwc: Don't use coherent DMA buffers for ISO transfer")
Signed-off-by: Matwey V. Kornilov <matwey@sai.msu.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/pwc/pwc-if.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/media/usb/pwc/pwc-if.c
+++ b/drivers/media/usb/pwc/pwc-if.c
@@ -147,16 +147,17 @@ static const struct video_device pwc_tem
 /***************************************************************************/
 /* Private functions */
 
-static void *pwc_alloc_urb_buffer(struct device *dev,
+static void *pwc_alloc_urb_buffer(struct usb_device *dev,
 				  size_t size, dma_addr_t *dma_handle)
 {
+	struct device *dmadev = dev->bus->sysdev;
 	void *buffer = kmalloc(size, GFP_KERNEL);
 
 	if (!buffer)
 		return NULL;
 
-	*dma_handle = dma_map_single(dev, buffer, size, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dev, *dma_handle)) {
+	*dma_handle = dma_map_single(dmadev, buffer, size, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dmadev, *dma_handle)) {
 		kfree(buffer);
 		return NULL;
 	}
@@ -164,12 +165,14 @@ static void *pwc_alloc_urb_buffer(struct
 	return buffer;
 }
 
-static void pwc_free_urb_buffer(struct device *dev,
+static void pwc_free_urb_buffer(struct usb_device *dev,
 				size_t size,
 				void *buffer,
 				dma_addr_t dma_handle)
 {
-	dma_unmap_single(dev, dma_handle, size, DMA_FROM_DEVICE);
+	struct device *dmadev = dev->bus->sysdev;
+
+	dma_unmap_single(dmadev, dma_handle, size, DMA_FROM_DEVICE);
 	kfree(buffer);
 }
 
@@ -274,6 +277,7 @@ static void pwc_frame_complete(struct pw
 static void pwc_isoc_handler(struct urb *urb)
 {
 	struct pwc_device *pdev = (struct pwc_device *)urb->context;
+	struct device *dmadev = urb->dev->bus->sysdev;
 	int i, fst, flen;
 	unsigned char *iso_buf = NULL;
 
@@ -320,7 +324,7 @@ static void pwc_isoc_handler(struct urb
 	/* Reset ISOC error counter. We did get here, after all. */
 	pdev->visoc_errors = 0;
 
-	dma_sync_single_for_cpu(&urb->dev->dev,
+	dma_sync_single_for_cpu(dmadev,
 				urb->transfer_dma,
 				urb->transfer_buffer_length,
 				DMA_FROM_DEVICE);
@@ -371,7 +375,7 @@ static void pwc_isoc_handler(struct urb
 		pdev->vlast_packet_size = flen;
 	}
 
-	dma_sync_single_for_device(&urb->dev->dev,
+	dma_sync_single_for_device(dmadev,
 				   urb->transfer_dma,
 				   urb->transfer_buffer_length,
 				   DMA_FROM_DEVICE);
@@ -453,7 +457,7 @@ retry:
 		urb->pipe = usb_rcvisocpipe(udev, pdev->vendpoint);
 		urb->transfer_flags = URB_ISO_ASAP | URB_NO_TRANSFER_DMA_MAP;
 		urb->transfer_buffer_length = ISO_BUFFER_SIZE;
-		urb->transfer_buffer = pwc_alloc_urb_buffer(&udev->dev,
+		urb->transfer_buffer = pwc_alloc_urb_buffer(udev,
 							    urb->transfer_buffer_length,
 							    &urb->transfer_dma);
 		if (urb->transfer_buffer == NULL) {
@@ -516,7 +520,7 @@ static void pwc_iso_free(struct pwc_devi
 		if (urb) {
 			PWC_DEBUG_MEMORY("Freeing URB\n");
 			if (urb->transfer_buffer)
-				pwc_free_urb_buffer(&urb->dev->dev,
+				pwc_free_urb_buffer(urb->dev,
 						    urb->transfer_buffer_length,
 						    urb->transfer_buffer,
 						    urb->transfer_dma);


