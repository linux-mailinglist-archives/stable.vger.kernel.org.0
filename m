Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37A4612FAC
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 06:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiJaF3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 01:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJaF3B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 01:29:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3499A9FD1
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 22:29:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A60E7B81117
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 05:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3A7C433D6;
        Mon, 31 Oct 2022 05:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667194137;
        bh=2273c2AYivUy2G+n+JDlJ99tWlt2YpsyWy4HMwkpfFU=;
        h=Subject:To:Cc:From:Date:From;
        b=Zowfoxo1ogzCocSM/WPZQo0FIvZjIx1k6sZfgpoXEtfSpq5M4ddvhLSPJhRoVEOpB
         W4RhkXyAlnCS771/wZ1z73FFp7Bg5ybckblrH2qoKJ+nA6kwkP/t2LiKpUas5RU5U/
         RxByRenJjaKeyWpfqzPvbTnqj3rfxedmIp/xXq3w=
Subject: FAILED: patch "[PATCH] can: kvaser_usb: Fix possible completions during" failed to apply to 4.9-stable tree
To:     anssi.hannula@bitwise.fi, extja@kvaser.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 06:29:45 +0100
Message-ID: <166719418517611@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

2871edb32f46 ("can: kvaser_usb: Fix possible completions during init_completion")
aec5fb2268b7 ("can: kvaser_usb: Add support for Kvaser USB hydra family")
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

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2871edb32f4622c3a25ce4b3977bad9050b91974 Mon Sep 17 00:00:00 2001
From: Anssi Hannula <anssi.hannula@bitwise.fi>
Date: Mon, 10 Oct 2022 20:52:27 +0200
Subject: [PATCH] can: kvaser_usb: Fix possible completions during
 init_completion

kvaser_usb uses completions to signal when a response event is received
for outgoing commands.

However, it uses init_completion() to reinitialize the start_comp and
stop_comp completions before sending the start/stop commands.

In case the device sends the corresponding response just before the
actual command is sent, complete() may be called concurrently with
init_completion() which is not safe.

This might be triggerable even with a properly functioning device by
stopping the interface (CMD_STOP_CHIP) just after it goes bus-off (which
also causes the driver to send CMD_STOP_CHIP when restart-ms is off),
but that was not tested.

Fix the issue by using reinit_completion() instead.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010185237.319219-2-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index 7b52fda73d82..66f672ea631b 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -1875,7 +1875,7 @@ static int kvaser_usb_hydra_start_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->start_comp);
+	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_hydra_send_simple_cmd(priv->dev, CMD_START_CHIP_REQ,
 					       priv->channel);
@@ -1893,7 +1893,7 @@ static int kvaser_usb_hydra_stop_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->stop_comp);
+	reinit_completion(&priv->stop_comp);
 
 	/* Make sure we do not report invalid BUS_OFF from CMD_CHIP_STATE_EVENT
 	 * see comment in kvaser_usb_hydra_update_state()
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 50f2ac8319ff..19958037720f 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -1320,7 +1320,7 @@ static int kvaser_usb_leaf_start_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->start_comp);
+	reinit_completion(&priv->start_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_START_CHIP,
 					      priv->channel);
@@ -1338,7 +1338,7 @@ static int kvaser_usb_leaf_stop_chip(struct kvaser_usb_net_priv *priv)
 {
 	int err;
 
-	init_completion(&priv->stop_comp);
+	reinit_completion(&priv->stop_comp);
 
 	err = kvaser_usb_leaf_send_simple_cmd(priv->dev, CMD_STOP_CHIP,
 					      priv->channel);

