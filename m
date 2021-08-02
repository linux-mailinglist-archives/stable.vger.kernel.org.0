Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5981D3DD8C6
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhHBNz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234675AbhHBNxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:53:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DD526113C;
        Mon,  2 Aug 2021 13:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912321;
        bh=M1dnuu1326fDTRjfoPgMtMUakHQlTPMsA7VBwe345h4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tV4Lp5rP+zWTw6GW5Z3UTfYwZl4W/kTuFqJ2sqTClZ0QZO+GSDjrV0wyGvhaCh4js
         DOq4OvzWSOsuln1v5aqRMrgj4Nqo/LaCAyFXNQOmWrJG1hfOQPJdikPm76b9ll6MEA
         s9XkGVTsDzx4gn7Nyb4o5/q8kPVmsQ57V7fqyX50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 15/40] can: esd_usb2: fix memory leak
Date:   Mon,  2 Aug 2021 15:44:55 +0200
Message-Id: <20210802134335.881595766@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134335.408294521@linuxfoundation.org>
References: <20210802134335.408294521@linuxfoundation.org>
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
@@ -195,6 +195,8 @@ struct esd_usb2 {
 	int net_count;
 	u32 version;
 	int rxinitdone;
+	void *rxbuf[MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[MAX_RX_URBS];
 };
 
 struct esd_usb2_net_priv {
@@ -544,6 +546,7 @@ static int esd_usb2_setup_rx_urbs(struct
 	for (i = 0; i < MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf = NULL;
+		dma_addr_t buf_dma;
 
 		/* create a URB, and a buffer for it */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -553,7 +556,7 @@ static int esd_usb2_setup_rx_urbs(struct
 		}
 
 		buf = usb_alloc_coherent(dev->udev, RX_BUFFER_SIZE, GFP_KERNEL,
-					 &urb->transfer_dma);
+					 &buf_dma);
 		if (!buf) {
 			dev_warn(dev->udev->dev.parent,
 				 "No memory left for USB buffer\n");
@@ -561,6 +564,8 @@ static int esd_usb2_setup_rx_urbs(struct
 			goto freeurb;
 		}
 
+		urb->transfer_dma = buf_dma;
+
 		usb_fill_bulk_urb(urb, dev->udev,
 				  usb_rcvbulkpipe(dev->udev, 1),
 				  buf, RX_BUFFER_SIZE,
@@ -573,8 +578,12 @@ static int esd_usb2_setup_rx_urbs(struct
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
@@ -662,6 +671,11 @@ static void unlink_all_urbs(struct esd_u
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


