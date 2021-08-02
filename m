Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3675F3DD9A6
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235732AbhHBOCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhHBOAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C436610FE;
        Mon,  2 Aug 2021 13:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912572;
        bh=clgrHobsiQI8T2m75NAfQ28teNYga/M3DAbAeAcFJ6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ip9YhtQ4kHvBL5hMnmp5CUCVBAayE5Dvq/RUQmtxfsn/y7pJFqpilhF7YSatRak0Q
         kRir0W/5PgJ7G8uHxnPZ7X4vNLOdzhanL0Vj2rZfidd+LvQvlgEoHLRegQrRci5Buj
         mZlsm+0MdppuTACS9MdlUeNY4LkED0fLfI0htqWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.13 020/104] can: esd_usb2: fix memory leak
Date:   Mon,  2 Aug 2021 15:44:17 +0200
Message-Id: <20210802134344.674013212@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
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
@@ -545,6 +547,7 @@ static int esd_usb2_setup_rx_urbs(struct
 	for (i = 0; i < MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf = NULL;
+		dma_addr_t buf_dma;
 
 		/* create a URB, and a buffer for it */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -554,7 +557,7 @@ static int esd_usb2_setup_rx_urbs(struct
 		}
 
 		buf = usb_alloc_coherent(dev->udev, RX_BUFFER_SIZE, GFP_KERNEL,
-					 &urb->transfer_dma);
+					 &buf_dma);
 		if (!buf) {
 			dev_warn(dev->udev->dev.parent,
 				 "No memory left for USB buffer\n");
@@ -562,6 +565,8 @@ static int esd_usb2_setup_rx_urbs(struct
 			goto freeurb;
 		}
 
+		urb->transfer_dma = buf_dma;
+
 		usb_fill_bulk_urb(urb, dev->udev,
 				  usb_rcvbulkpipe(dev->udev, 1),
 				  buf, RX_BUFFER_SIZE,
@@ -574,8 +579,12 @@ static int esd_usb2_setup_rx_urbs(struct
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
@@ -663,6 +672,11 @@ static void unlink_all_urbs(struct esd_u
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


