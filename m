Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F44B3DD9A7
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234694AbhHBOCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:02:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:44350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236922AbhHBOAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 10:00:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 327AA611BF;
        Mon,  2 Aug 2021 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912570;
        bh=aD7IiEmTI7yrt/iGBkXHMfaZrzPwI37ZRx3xDpsq6lc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vEJkHSgrgLtZIWLT9nLpvRKVIl55kqhwzWicJJPxTk+T49ALzrL0N/qgIfaqvvCA8
         cmwauhMPz2h9ZcKknClJnkEBt88YfKAlb04HrdMSf+qAIrnEoHzfdK8twX6ZWxoRW6
         iU1W65yLFMugTMcwybuLLiiGHcS59J8yfEKh5DLA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.13 019/104] can: ems_usb: fix memory leak
Date:   Mon,  2 Aug 2021 15:44:16 +0200
Message-Id: <20210802134344.645690280@linuxfoundation.org>
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

commit 9969e3c5f40c166e3396acc36c34f9de502929f6 upstream.

In ems_usb_start() MAX_RX_URBS coherent buffers are allocated and
there is nothing, that frees them:

1) In callback function the urb is resubmitted and that's all
2) In disconnect function urbs are simply killed, but URB_FREE_BUFFER
   is not set (see ems_usb_start) and this flag cannot be used with
   coherent buffers.

So, all allocated buffers should be freed with usb_free_coherent()
explicitly.

Side note: This code looks like a copy-paste of other can drivers. The
same patch was applied to mcba_usb driver and it works nice with real
hardware. There is no change in functionality, only clean-up code for
coherent buffers.

Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Link: https://lore.kernel.org/r/59aa9fbc9a8cbf9af2bbd2f61a659c480b415800.1627404470.git.paskripkin@gmail.com
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ems_usb.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -255,6 +255,8 @@ struct ems_usb {
 	unsigned int free_slots; /* remember number of available slots */
 
 	struct ems_cpc_msg active_params; /* active controller parameters */
+	void *rxbuf[MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[MAX_RX_URBS];
 };
 
 static void ems_usb_read_interrupt_callback(struct urb *urb)
@@ -587,6 +589,7 @@ static int ems_usb_start(struct ems_usb
 	for (i = 0; i < MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf = NULL;
+		dma_addr_t buf_dma;
 
 		/* create a URB, and a buffer for it */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -596,7 +599,7 @@ static int ems_usb_start(struct ems_usb
 		}
 
 		buf = usb_alloc_coherent(dev->udev, RX_BUFFER_SIZE, GFP_KERNEL,
-					 &urb->transfer_dma);
+					 &buf_dma);
 		if (!buf) {
 			netdev_err(netdev, "No memory left for USB buffer\n");
 			usb_free_urb(urb);
@@ -604,6 +607,8 @@ static int ems_usb_start(struct ems_usb
 			break;
 		}
 
+		urb->transfer_dma = buf_dma;
+
 		usb_fill_bulk_urb(urb, dev->udev, usb_rcvbulkpipe(dev->udev, 2),
 				  buf, RX_BUFFER_SIZE,
 				  ems_usb_read_bulk_callback, dev);
@@ -619,6 +624,9 @@ static int ems_usb_start(struct ems_usb
 			break;
 		}
 
+		dev->rxbuf[i] = buf;
+		dev->rxbuf_dma[i] = buf_dma;
+
 		/* Drop reference, USB core will take care of freeing it */
 		usb_free_urb(urb);
 	}
@@ -684,6 +692,10 @@ static void unlink_all_urbs(struct ems_u
 
 	usb_kill_anchored_urbs(&dev->rx_submitted);
 
+	for (i = 0; i < MAX_RX_URBS; ++i)
+		usb_free_coherent(dev->udev, RX_BUFFER_SIZE,
+				  dev->rxbuf[i], dev->rxbuf_dma[i]);
+
 	usb_kill_anchored_urbs(&dev->tx_submitted);
 	atomic_set(&dev->active_tx_urbs, 0);
 


