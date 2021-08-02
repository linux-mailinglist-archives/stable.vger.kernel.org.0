Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8C03DD7AA
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhHBNrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:56810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234212AbhHBNrA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:47:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E29B6052B;
        Mon,  2 Aug 2021 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912011;
        bh=deBmtcRWW/p0+KRXgcRsVKFFIRUBZWniE7lLe/nYgTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=go2JST2C23uoQSnu79PCdTHSp7K+wdqLohYqUsdO297/tbPA7sfurlKJraoq0saAi
         SU9Je4jA70usV99Ks/SR/hRhwG6HmvCd6O8qdfF1OCT/xcA8JLr+gBhFmR8+GVzzPh
         NQwv3auVUNV4tgHjQQyJ7po9rO8rERPb/3onKvoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.4 17/26] can: esd_usb2: fix memory leak
Date:   Mon,  2 Aug 2021 15:44:27 +0200
Message-Id: <20210802134332.594527674@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134332.033552261@linuxfoundation.org>
References: <20210802134332.033552261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 928150fad41ba16df7fcc9f7f945747d0f56cbb6 upstream.

In esd_usb2_setup_rx_urbs() MAX_RX_URBS coherent buffers are allocated
and there is nothing, that frees them:

1) In callback function the urb is resubmitted and that's all
2) In disconnect function urbs are simply killed, but URB_FREE_BUFFER
   is not set (see esd_usb2_setup_rx_urbs) and this flag cannot be used
   with coherent buffers.

So, all allocated buffers should be freed with usb_free_coherent()
explicitly.

Side note: This code looks like a copy-paste of other can drivers. The
same patch was applied to mcba_usb driver and it works nice with real
hardware. There is no change in functionality, only clean-up code for
coherent buffers.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Link: https://lore.kernel.org/r/b31b096926dcb35998ad0271aac4b51770ca7cc8.1627404470.git.paskripkin@gmail.com
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/esd_usb2.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -207,6 +207,8 @@ struct esd_usb2 {
 	int net_count;
 	u32 version;
 	int rxinitdone;
+	void *rxbuf[MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[MAX_RX_URBS];
 };
 
 struct esd_usb2_net_priv {
@@ -556,6 +558,7 @@ static int esd_usb2_setup_rx_urbs(struct
 	for (i = 0; i < MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf = NULL;
+		dma_addr_t buf_dma;
 
 		/* create a URB, and a buffer for it */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -567,7 +570,7 @@ static int esd_usb2_setup_rx_urbs(struct
 		}
 
 		buf = usb_alloc_coherent(dev->udev, RX_BUFFER_SIZE, GFP_KERNEL,
-					 &urb->transfer_dma);
+					 &buf_dma);
 		if (!buf) {
 			dev_warn(dev->udev->dev.parent,
 				 "No memory left for USB buffer\n");
@@ -575,6 +578,8 @@ static int esd_usb2_setup_rx_urbs(struct
 			goto freeurb;
 		}
 
+		urb->transfer_dma = buf_dma;
+
 		usb_fill_bulk_urb(urb, dev->udev,
 				  usb_rcvbulkpipe(dev->udev, 1),
 				  buf, RX_BUFFER_SIZE,
@@ -587,8 +592,12 @@ static int esd_usb2_setup_rx_urbs(struct
 			usb_unanchor_urb(urb);
 			usb_free_coherent(dev->udev, RX_BUFFER_SIZE, buf,
 					  urb->transfer_dma);
+			goto freeurb;
 		}
 
+		dev->rxbuf[i] = buf;
+		dev->rxbuf_dma[i] = buf_dma;
+
 freeurb:
 		/* Drop reference, USB core will take care of freeing it */
 		usb_free_urb(urb);
@@ -676,6 +685,11 @@ static void unlink_all_urbs(struct esd_u
 	int i, j;
 
 	usb_kill_anchored_urbs(&dev->rx_submitted);
+
+	for (i = 0; i < MAX_RX_URBS; ++i)
+		usb_free_coherent(dev->udev, RX_BUFFER_SIZE,
+				  dev->rxbuf[i], dev->rxbuf_dma[i]);
+
 	for (i = 0; i < dev->net_count; i++) {
 		priv = dev->nets[i];
 		if (priv) {


