Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BF45FFDC7
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiJPHRF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiJPHRE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:17:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 195763ECF4
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:17:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAC8960AB3
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16AFC433D7;
        Sun, 16 Oct 2022 07:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665904623;
        bh=T6vSQGervhVTnbSmCTws7kkx0hUkk9virDDS0znx/8I=;
        h=Subject:To:Cc:From:Date:From;
        b=VYZT08dvKBUlOD2IkF1/MDFI/1GDMeYVNcpNcnJPoNGOKRHvlVGq30YlPb6ZAW1IO
         jcJwNA8uTU4MG5uf1yyWIbwkebluexZLqv42uNC4c+RGghAKgjtQTe/xOGdFetyAGq
         l3e7tiuHKX/gb8i1J6JDWO1REz3LvuCsJjZg0CB4=
Subject: FAILED: patch "[PATCH] can: kvaser_usb_leaf: Fix TX queue out of sync after restart" failed to apply to 4.9-stable tree
To:     anssi.hannula@bitwise.fi, extja@kvaser.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:17:41 +0200
Message-ID: <1665904661117144@kroah.com>
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


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

455561fb618f ("can: kvaser_usb_leaf: Fix TX queue out of sync after restart")
7259124eac7d ("can: kvaser_usb: Split driver into kvaser_usb_core.c and kvaser_usb_leaf.c")
e0543f2479f8 ("can: kvaser_usb: Add SPDX GPL-2.0 license identifier")
2b049c150080 ("can: kvaser_usb: Fix typos")
6ba0b9294bca ("can: kvaser_usb: Improve logging messages")
7c4780146177 ("can: kvaser_usb: Refactor kvaser_usb_init_one()")
99ce1bc17462 ("can: kvaser_usb: Refactor kvaser_usb_get_endpoints()")
0e30619fd6fa ("can: kvaser_usb: Add pointer to struct usb_interface into struct kvaser_usb")
75d2b4c3e399 ("can: kvaser_usb: Replace USB timeout constants with one define")
f741f938556d ("can: kvaser_usb: Rename message/msg to command/cmd")
237572220121 ("can: kvaser_usb: Remove unused commands and defines")
deaa1c984be7 ("can: kvaser_usb: Remove unnecessary return")
ffbdd9172ee2 ("can: usb: Kconfig/Makefile: sort alphabetically")
6ee00865ffe4 ("can: kvaser_usb: Increase correct stats counter in kvaser_usb_rx_can_msg()")
6aa8d5945502 ("can: kvaser_usb: cancel urb on -EPIPE and -EPROTO")
8bd13bd522ff ("can: kvaser_usb: ratelimit errors if incomplete messages are received")
e84f44eb5523 ("can: kvaser_usb: Fix comparison bug in kvaser_usb_read_bulk_callback()")
435019b48033 ("can: kvaser_usb: free buf in error paths")
e1d2d1329a57 ("can: kvaser_usb: Ignore CMD_FLUSH_QUEUE_REPLY messages")
8f65a923e6b6 ("can: kvaser_usb: Correct return value in printout")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 455561fb618fde40558776b5b8435f9420f335db Mon Sep 17 00:00:00 2001
From: Anssi Hannula <anssi.hannula@bitwise.fi>
Date: Mon, 10 Oct 2022 17:08:28 +0200
Subject: [PATCH] can: kvaser_usb_leaf: Fix TX queue out of sync after restart

The TX queue seems to be implicitly flushed by the hardware during
bus-off or bus-off recovery, but the driver does not reset the TX
bookkeeping.

Despite not resetting TX bookkeeping the driver still re-enables TX
queue unconditionally, leading to "cannot find free context" /
NETDEV_TX_BUSY errors if the TX queue was full at bus-off time.

Fix that by resetting TX bookkeeping on CAN restart.

Tested with 0bfd:0124 Kvaser Mini PCI Express 2xHS FW 4.18.778.

Cc: stable@vger.kernel.org
Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010150829.199676-4-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index 841da29cef93..f6c0938027ec 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -178,6 +178,8 @@ struct kvaser_usb_dev_cfg {
 extern const struct kvaser_usb_dev_ops kvaser_usb_hydra_dev_ops;
 extern const struct kvaser_usb_dev_ops kvaser_usb_leaf_dev_ops;
 
+void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv);
+
 int kvaser_usb_recv_cmd(const struct kvaser_usb *dev, void *cmd, int len,
 			int *actual_len);
 
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index c2bce6773adc..e91648ed7386 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -477,7 +477,7 @@ static void kvaser_usb_reset_tx_urb_contexts(struct kvaser_usb_net_priv *priv)
 /* This method might sleep. Do not call it in the atomic context
  * of URB completions.
  */
-static void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv)
+void kvaser_usb_unlink_tx_urbs(struct kvaser_usb_net_priv *priv)
 {
 	usb_kill_anchored_urbs(&priv->tx_submitted);
 	kvaser_usb_reset_tx_urb_contexts(priv);
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 8e11cda85624..59c220ef3049 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1426,6 +1426,8 @@ static int kvaser_usb_leaf_set_mode(struct net_device *netdev,
 
 	switch (mode) {
 	case CAN_MODE_START:
+		kvaser_usb_unlink_tx_urbs(priv);
+
 		err = kvaser_usb_leaf_simple_cmd_async(priv, CMD_START_CHIP);
 		if (err)
 			return err;

