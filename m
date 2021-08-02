Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103D13DD8C5
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234186AbhHBNz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:55:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:33468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234358AbhHBNxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:53:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 073DA60FC2;
        Mon,  2 Aug 2021 13:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912317;
        bh=kIzYnuZFMrxLllh/y9GtgzQuBkfdQkXRMCDWVGkflII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1x7I6if52nyWVKQNn8jF1C5UzqSBpv3rCvO3Yqrbx+1ClJaCHSFyGYH8j7bo7wxl
         cMtTwsL55A08eHRWKuRrF8O3fuHxKd3pTsvppVU8b0KOc9GjHwpGW/Kk6aWMYMGLj6
         PqEVrPVBlYcN0ky3mCqwczsctWeo2PIzSzmMI90o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 13/40] can: usb_8dev: fix memory leak
Date:   Mon,  2 Aug 2021 15:44:53 +0200
Message-Id: <20210802134335.815516209@linuxfoundation.org>
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

commit 0e865f0c31928d6a313269ef624907eec55287c4 upstream.

In usb_8dev_start() MAX_RX_URBS coherent buffers are allocated and
there is nothing, that frees them:

1) In callback function the urb is resubmitted and that's all
2) In disconnect function urbs are simply killed, but URB_FREE_BUFFER
   is not set (see usb_8dev_start) and this flag cannot be used with
   coherent buffers.

So, all allocated buffers should be freed with usb_free_coherent()
explicitly.

Side note: This code looks like a copy-paste of other can drivers. The
same patch was applied to mcba_usb driver and it works nice with real
hardware. There is no change in functionality, only clean-up code for
coherent buffers.

Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
Link: https://lore.kernel.org/r/d39b458cd425a1cf7f512f340224e6e9563b07bd.1627404470.git.paskripkin@gmail.com
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/usb_8dev.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -137,7 +137,8 @@ struct usb_8dev_priv {
 	u8 *cmd_msg_buffer;
 
 	struct mutex usb_8dev_cmd_lock;
-
+	void *rxbuf[MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[MAX_RX_URBS];
 };
 
 /* tx frame */
@@ -733,6 +734,7 @@ static int usb_8dev_start(struct usb_8de
 	for (i = 0; i < MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf;
+		dma_addr_t buf_dma;
 
 		/* create a URB, and a buffer for it */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -742,7 +744,7 @@ static int usb_8dev_start(struct usb_8de
 		}
 
 		buf = usb_alloc_coherent(priv->udev, RX_BUFFER_SIZE, GFP_KERNEL,
-					 &urb->transfer_dma);
+					 &buf_dma);
 		if (!buf) {
 			netdev_err(netdev, "No memory left for USB buffer\n");
 			usb_free_urb(urb);
@@ -750,6 +752,8 @@ static int usb_8dev_start(struct usb_8de
 			break;
 		}
 
+		urb->transfer_dma = buf_dma;
+
 		usb_fill_bulk_urb(urb, priv->udev,
 				  usb_rcvbulkpipe(priv->udev,
 						  USB_8DEV_ENDP_DATA_RX),
@@ -767,6 +771,9 @@ static int usb_8dev_start(struct usb_8de
 			break;
 		}
 
+		priv->rxbuf[i] = buf;
+		priv->rxbuf_dma[i] = buf_dma;
+
 		/* Drop reference, USB core will take care of freeing it */
 		usb_free_urb(urb);
 	}
@@ -836,6 +843,10 @@ static void unlink_all_urbs(struct usb_8
 
 	usb_kill_anchored_urbs(&priv->rx_submitted);
 
+	for (i = 0; i < MAX_RX_URBS; ++i)
+		usb_free_coherent(priv->udev, RX_BUFFER_SIZE,
+				  priv->rxbuf[i], priv->rxbuf_dma[i]);
+
 	usb_kill_anchored_urbs(&priv->tx_submitted);
 	atomic_set(&priv->active_tx_urbs, 0);
 


