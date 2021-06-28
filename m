Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF233B628D
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbhF1OsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235101AbhF1OoN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:44:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2E4B61CFA;
        Mon, 28 Jun 2021 14:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890839;
        bh=4RCXcoz1/ZVvUEgTx/CeqYRAKBy3/tBsrHbwA/2kIiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFVqy58oUZQSxRaH5BQtGGmiO+RpSzf8ebVd1QWJBiAMGEwdaePxmK5ADZopSGSOJ
         ukhu9Wmx0nmfk0fLRUW6lHnEtx2Vh8rq3YH1dWip1Xy2+rBenEObE15CpakI3RJvMr
         D+8XiuJn1PKz/hsBzrPHjHUJjtIpQcfQKOmRVjvzdlHkbeVlUcDEWqtPM2NOlTzbjy
         6agVP+xwsQlgPiQrAIz++oGRNrVGe9QvnbbASZL7GQYi9b/Lty+/mGyB3LwHr1MEaC
         jd1xZ2Xp2C6P/D4QNzbSJsw+8J8HuTQHT2czUMEfo6hMneZaf5kxf9beDtrrmOunMo
         XMtXp9QwZkD3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+57281c762a3922e14dfe@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 059/109] can: mcba_usb: fix memory leak in mcba_usb
Date:   Mon, 28 Jun 2021 10:32:15 -0400
Message-Id: <20210628143305.32978-60-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/net/can/usb/mcba_usb.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 896f5b022729..3215ba69a9e7 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -93,6 +93,8 @@ struct mcba_priv {
 	bool can_ka_first_pass;
 	bool can_speed_check;
 	atomic_t free_ctx_cnt;
+	void *rxbuf[MCBA_MAX_RX_URBS];
+	dma_addr_t rxbuf_dma[MCBA_MAX_RX_URBS];
 };
 
 /* CAN frame */
@@ -644,6 +646,7 @@ static int mcba_usb_start(struct mcba_priv *priv)
 	for (i = 0; i < MCBA_MAX_RX_URBS; i++) {
 		struct urb *urb = NULL;
 		u8 *buf;
+		dma_addr_t buf_dma;
 
 		/* create a URB, and a buffer for it */
 		urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -653,7 +656,7 @@ static int mcba_usb_start(struct mcba_priv *priv)
 		}
 
 		buf = usb_alloc_coherent(priv->udev, MCBA_USB_RX_BUFF_SIZE,
-					 GFP_KERNEL, &urb->transfer_dma);
+					 GFP_KERNEL, &buf_dma);
 		if (!buf) {
 			netdev_err(netdev, "No memory left for USB buffer\n");
 			usb_free_urb(urb);
@@ -672,11 +675,14 @@ static int mcba_usb_start(struct mcba_priv *priv)
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
@@ -719,7 +725,14 @@ static int mcba_usb_open(struct net_device *netdev)
 
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
 
-- 
2.30.2

