Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0604F1AFC
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379356AbiDDVTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380280AbiDDT1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 15:27:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47733B037
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 12:25:39 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nbSKY-0004NP-8S
        for stable@vger.kernel.org; Mon, 04 Apr 2022 21:25:38 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9F90B5A44B
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 19:25:37 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 716C35A446;
        Mon,  4 Apr 2022 19:25:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8cfab1e6;
        Mon, 4 Apr 2022 19:25:37 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     linux-can@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        Hangyu Hua <hbh25y@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH] can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path
Date:   Mon,  4 Apr 2022 21:25:36 +0200
Message-Id: <20220404192536.1243729-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

commit 3d3925ff6433f98992685a9679613a2cc97f3ce2 upstream.

There is no need to call dev_kfree_skb() when usb_submit_urb() fails
because can_put_echo_skb() deletes original skb and
can_free_echo_skb() deletes the cloned skb.

Fixes: 0024d8ad1639 ("can: usb_8dev: Add support for USB2CAN interface from 8 devices")
Link: https://lore.kernel.org/all/20220311080614.45229-1-hbh25y@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
Hello Greg, hello Sasha,

This is

| 3d3925ff6433 can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path

ported to v5.10.109.

regards,
Marc

 drivers/net/can/usb/usb_8dev.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/can/usb/usb_8dev.c b/drivers/net/can/usb/usb_8dev.c
index ca7c55d6a41d..985e00aee4ee 100644
--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -670,9 +670,20 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 	atomic_inc(&priv->active_tx_urbs);
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if (unlikely(err))
-		goto failed;
-	else if (atomic_read(&priv->active_tx_urbs) >= MAX_TX_URBS)
+	if (unlikely(err)) {
+		can_free_echo_skb(netdev, context->echo_index);
+
+		usb_unanchor_urb(urb);
+		usb_free_coherent(priv->udev, size, buf, urb->transfer_dma);
+
+		atomic_dec(&priv->active_tx_urbs);
+
+		if (err == -ENODEV)
+			netif_device_detach(netdev);
+		else
+			netdev_warn(netdev, "failed tx_urb %d\n", err);
+		stats->tx_dropped++;
+	} else if (atomic_read(&priv->active_tx_urbs) >= MAX_TX_URBS)
 		/* Slow down tx path */
 		netif_stop_queue(netdev);
 
@@ -691,19 +702,6 @@ static netdev_tx_t usb_8dev_start_xmit(struct sk_buff *skb,
 
 	return NETDEV_TX_BUSY;
 
-failed:
-	can_free_echo_skb(netdev, context->echo_index);
-
-	usb_unanchor_urb(urb);
-	usb_free_coherent(priv->udev, size, buf, urb->transfer_dma);
-
-	atomic_dec(&priv->active_tx_urbs);
-
-	if (err == -ENODEV)
-		netif_device_detach(netdev);
-	else
-		netdev_warn(netdev, "failed tx_urb %d\n", err);
-
 nomembuf:
 	usb_free_urb(urb);
 
-- 
2.35.1


