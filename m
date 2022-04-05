Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 570E44F253C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiDEHsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbiDEHq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:46:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4CF899685;
        Tue,  5 Apr 2022 00:41:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C486B81B14;
        Tue,  5 Apr 2022 07:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688F2C340EE;
        Tue,  5 Apr 2022 07:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144512;
        bh=pol35tleRDTuGvRqTHMK7qDa4oCsmemWL50nN29IMSY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zbz0xHQqnBh8A+nl4gL3jm2iV9c50KgQCaCva9/WkfjorALxIKW0UswSYNAg/JS3O
         2rl/KsKdRB1oNPkVHQPjQzP7A5jAOXtTk7wiak8gmmHp6s0DEyZUuQ4jvj0D/acQav
         UTzv3JnZ6ObOUn3Ru42FAZvlv4+iCqY+hoCs4N5Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.17 0072/1126] can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path
Date:   Tue,  5 Apr 2022 09:13:39 +0200
Message-Id: <20220405070409.683164747@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/usb_8dev.c |   30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

--- a/drivers/net/can/usb/usb_8dev.c
+++ b/drivers/net/can/usb/usb_8dev.c
@@ -663,9 +663,20 @@ static netdev_tx_t usb_8dev_start_xmit(s
 	atomic_inc(&priv->active_tx_urbs);
 
 	err = usb_submit_urb(urb, GFP_ATOMIC);
-	if (unlikely(err))
-		goto failed;
-	else if (atomic_read(&priv->active_tx_urbs) >= MAX_TX_URBS)
+	if (unlikely(err)) {
+		can_free_echo_skb(netdev, context->echo_index, NULL);
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
 
@@ -684,19 +695,6 @@ nofreecontext:
 
 	return NETDEV_TX_BUSY;
 
-failed:
-	can_free_echo_skb(netdev, context->echo_index, NULL);
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
 


