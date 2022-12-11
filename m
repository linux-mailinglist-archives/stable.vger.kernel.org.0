Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D932964936D
	for <lists+stable@lfdr.de>; Sun, 11 Dec 2022 10:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLKJxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Dec 2022 04:53:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiLKJxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Dec 2022 04:53:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC2711806
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 01:53:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 230CB60D34
        for <stable@vger.kernel.org>; Sun, 11 Dec 2022 09:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D106C433D2;
        Sun, 11 Dec 2022 09:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670752393;
        bh=3fndgVM14/7AafbSifGIjxG+KI5gIO/OJcVmV5lDxl0=;
        h=Subject:To:Cc:From:Date:From;
        b=paiw8IN4g4KSi3ARk0slcMuG9emOoSFP07OyJ6Wqy/dHsVdFwtKp7lWeRQutzSRH7
         KSIM24FpgdAgLyyzYXJtmmNObQoJBUhOs6Wt97C+k8XJmRcmTcJRfANHazwed959tU
         lVigRq2TRS+LP0KdxRLszHnP5/8gVklm//7Idk1c=
Subject: FAILED: patch "[PATCH] can: esd_usb: Allow REC and TEC to return to zero" failed to apply to 5.10-stable tree
To:     frank.jungclaus@esd.eu, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Dec 2022 10:53:08 +0100
Message-ID: <1670752388116121@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

918ee4911f7a ("can: esd_usb: Allow REC and TEC to return to zero")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 918ee4911f7a41fb4505dff877c1d7f9f64eb43e Mon Sep 17 00:00:00 2001
From: Frank Jungclaus <frank.jungclaus@esd.eu>
Date: Wed, 30 Nov 2022 21:22:42 +0100
Subject: [PATCH] can: esd_usb: Allow REC and TEC to return to zero

We don't get any further EVENT from an esd CAN USB device for changes
on REC or TEC while those counters converge to 0 (with ecc == 0). So
when handling the "Back to Error Active"-event force txerr = rxerr =
0, otherwise the berr-counters might stay on values like 95 forever.

Also, to make life easier during the ongoing development a
netdev_dbg() has been introduced to allow dumping error events send by
an esd CAN USB device.

Fixes: 96d8e90382dc ("can: Add driver for esd CAN-USB/2 device")
Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>
Link: https://lore.kernel.org/all/20221130202242.3998219-2-frank.jungclaus@esd.eu
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/usb/esd_usb.c b/drivers/net/can/usb/esd_usb.c
index 81b88e9e5bdc..42323f5e6f3a 100644
--- a/drivers/net/can/usb/esd_usb.c
+++ b/drivers/net/can/usb/esd_usb.c
@@ -234,6 +234,10 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 		u8 rxerr = msg->msg.rx.data[2];
 		u8 txerr = msg->msg.rx.data[3];
 
+		netdev_dbg(priv->netdev,
+			   "CAN_ERR_EV_EXT: dlc=%#02x state=%02x ecc=%02x rec=%02x tec=%02x\n",
+			   msg->msg.rx.dlc, state, ecc, rxerr, txerr);
+
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {
 			stats->rx_dropped++;
@@ -260,6 +264,8 @@ static void esd_usb_rx_event(struct esd_usb_net_priv *priv,
 				break;
 			default:
 				priv->can.state = CAN_STATE_ERROR_ACTIVE;
+				txerr = 0;
+				rxerr = 0;
 				break;
 			}
 		} else {

