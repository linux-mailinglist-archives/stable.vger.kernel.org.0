Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065FE3AEDB3
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhFUQWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:22:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbhFUQVI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:21:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7401611C1;
        Mon, 21 Jun 2021 16:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292334;
        bh=DHAxnpUEXkMbtydLit97tKQ01mF9G1yJqfRoaatq2Ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Yiuy5r+cuH+SiKmakLeoby9xNZQ8w7ofO2pW+o0k/hAE9OnDAERE8/jNHObWkqD6
         QVICdOLMAF3mwYEMrr/gcWIqF7npMbSZu5pAKS6GMr11iwYHqAhDnHUvanRchAO4Qe
         ch295COqJ4rV5P2NIjNMQ9IbVawJo0KS3ob5pyYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        syzbot+57281c762a3922e14dfe@syzkaller.appspotmail.com
Subject: [PATCH 5.4 53/90] can: mcba_usb: fix memory leak in mcba_usb
Date:   Mon, 21 Jun 2021 18:15:28 +0200
Message-Id: <20210621154905.942577639@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

commit 91c02557174be7f72e46ed7311e3bea1939840b0 upstream.

Syzbot reported memory leak in SocketCAN driver for Microchip CAN BUS
Analyzer Tool. The problem was in unfreed usb_coherent.

In mcba_usb_start() 20 coherent buffers are allocated and there is
nothing, that frees them:

1) In callback function the urb is resubmitted and that's all
2) In disconnect function urbs are simply killed, but URB_FREE_BUFFER
   is not set (see mcba_usb_start) and this flag cannot be used with
   coherent buffers.

Fail log:
| [ 1354.053291][ T8413] mcba_usb 1-1:0.0 can0: device disconnected
| [ 1367.059384][ T8420] kmemleak: 20 new suspected memory leaks (see /sys/kernel/debug/kmem)

So, all allocated buffers should be freed with usb_free_coherent()
explicitly

NOTE:
The same pattern for allocating and freeing coherent buffers
is used in drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c

Fixes: 51f3baad7de9 ("can: mcba_usb: Add support for Microchip CAN BUS Analyzer")
Link: https://lore.kernel.org/r/20210609215833.30393-1-paskripkin@gmail.com
Cc: linux-stable <stable@vger.kernel.org>
Reported-and-tested-by: syzbot+57281c762a3922e14dfe@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/mcba_usb.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -82,6 +82,8 @@ struct mcba_priv {
 	bool can_ka_first_pass;
 	bool can_speed_check;
 	atomic_t free_ctx_cnt;
+	void *rxbuf[MCBA_MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[MCBA_MAX_RX_URBS];
 };
 
 /* CAN frame */
@@ -633,6 +635,7 @@ static int mcba_usb_start(struct mcba_pr
 	for (i = 0; i < MCBA_MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf;
+		dma_addr_t buf_dma;
 
 		/* create a URB, and a buffer for it */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -642,7 +645,7 @@ static int mcba_usb_start(struct mcba_pr
 		}
 
 		buf = usb_alloc_coherent(priv->udev, MCBA_USB_RX_BUFF_SIZE,
-					 GFP_KERNEL, &urb->transfer_dma);
+					 GFP_KERNEL, &buf_dma);
 		if (!buf) {
 			netdev_err(netdev, "No memory left for USB buffer\n");
 			usb_free_urb(urb);
@@ -661,11 +664,14 @@ static int mcba_usb_start(struct mcba_pr
 		if (err) {
 			usb_unanchor_urb(urb);
 			usb_free_coherent(priv->udev, MCBA_USB_RX_BUFF_SIZE,
-					  buf, urb->transfer_dma);
+					  buf, buf_dma);
 			usb_free_urb(urb);
 			break;
 		}
 
+		priv->rxbuf[i] = buf;
+		priv->rxbuf_dma[i] = buf_dma;
+
 		/* Drop reference, USB core will take care of freeing it */
 		usb_free_urb(urb);
 	}
@@ -708,7 +714,14 @@ static int mcba_usb_open(struct net_devi
 
 static void mcba_urb_unlink(struct mcba_priv *priv)
 {
+	int i;
+
 	usb_kill_anchored_urbs(&priv->rx_submitted);
+
+	for (i = 0; i < MCBA_MAX_RX_URBS; ++i)
+		usb_free_coherent(priv->udev, MCBA_USB_RX_BUFF_SIZE,
+				  priv->rxbuf[i], priv->rxbuf_dma[i]);
+
 	usb_kill_anchored_urbs(&priv->tx_submitted);
 }
 


