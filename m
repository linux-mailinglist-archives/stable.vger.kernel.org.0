Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8586D63908E
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 21:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiKYURl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Nov 2022 15:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiKYURk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Nov 2022 15:17:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B043E10040
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 12:17:35 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyf8f-0001bV-LY
        for stable@vger.kernel.org; Fri, 25 Nov 2022 21:17:33 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 18649129EAB
        for <stable@vger.kernel.org>; Fri, 25 Nov 2022 20:17:33 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id EC375129EA6;
        Fri, 25 Nov 2022 20:17:31 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5f039a5a;
        Fri, 25 Nov 2022 20:17:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Peter Fink <pfink@christ-es.de>, stable@vger.kernel.org,
        Ryan Edwards <ryan.edwards@gmail.com>
Subject: [PATCH] can: gs_usb: fix size parameter to usb_free_coherent() calls
Date:   Fri, 25 Nov 2022 21:17:27 +0100
Message-Id: <20221125201727.1558965-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In commit c359931d2545 ("can: gs_usb: use union and FLEX_ARRAY for
data in struct gs_host_frame") the driver was extended from a compile
time constant USB transfer size to a transfer size depending on
attached USB device and configured CAN mode.

During this conversion the size parameter of some usb_free_coherent()
calls were not converted. To fix this issue replace the compile time
constant sizeof(struct gs_host_frame) by hf_size_{rx,tx} for RX
respectively TX USB transfers.

Fixes: c359931d2545 ("can: gs_usb: use union and FLEX_ARRAY for data in struct gs_host_frame")
Cc: Peter Fink <pfink@christ-es.de>
Cc: stable@vger.kernel.org
Reported-by: Ryan Edwards <ryan.edwards@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/gs_usb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index cd4115a1b81c..57917955b8e4 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -699,7 +699,7 @@ static netdev_tx_t gs_can_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
  badidx:
-	usb_free_coherent(dev->udev, urb->transfer_buffer_length,
+	usb_free_coherent(dev->udev, dev->hf_size_tx,
 			  urb->transfer_buffer, urb->transfer_dma);
  nomem_hf:
 	usb_free_urb(urb);
@@ -787,7 +787,7 @@ static int gs_can_open(struct net_device *netdev)
 
 				usb_unanchor_urb(urb);
 				usb_free_coherent(dev->udev,
-						  sizeof(struct gs_host_frame),
+						  dev->parent->hf_size_rx,
 						  buf,
 						  buf_dma);
 				usb_free_urb(urb);
@@ -864,7 +864,7 @@ static int gs_can_close(struct net_device *netdev)
 		usb_kill_anchored_urbs(&parent->rx_submitted);
 		for (i = 0; i < GS_MAX_RX_URBS; i++)
 			usb_free_coherent(dev->udev,
-					  sizeof(struct gs_host_frame),
+					  dev->parent->hf_size_rx,
 					  dev->rxbuf[i],
 					  dev->rxbuf_dma[i]);
 	}
-- 
2.35.1


