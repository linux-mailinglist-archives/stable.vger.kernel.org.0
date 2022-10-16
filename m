Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FC55FFDC3
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiJPHQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbiJPHQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:16:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC323EA70
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:16:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F67F609AE
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:16:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECA5C433D6;
        Sun, 16 Oct 2022 07:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665904591;
        bh=V3Yt4JJsXJN53nOFj5BBU8esBsOEMhUNa+qh+0U/Hm4=;
        h=Subject:To:Cc:From:Date:From;
        b=vgB+pW6NhxrtxVMPfwJu0pidJO9dHMwR+7uUgwAoqohkXjIw4q0tO3ESgH9b3t2Zq
         s750tQkkKwttNNoU+ewaWI2b56EFMLmVaUs2wop8qJAAUq5pwnMIcFSsa4G6A5ZsZO
         iqPi2J68hzebBY7jscVd2IabbfLW0ygDIZA5i6Kw=
Subject: FAILED: patch "[PATCH] can: kvaser_usb_leaf: Fix overread with an invalid command" failed to apply to 4.14-stable tree
To:     anssi.hannula@bitwise.fi, extja@kvaser.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:17:18 +0200
Message-ID: <1665904638113213@kroah.com>
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1499ecaea9d2 ("can: kvaser_usb_leaf: Fix overread with an invalid command")
fb12797ab1fe ("can: kvaser_usb: get CAN clock frequency from device")
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

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1499ecaea9d2ba68d5e18d80573b4561a8dc4ee7 Mon Sep 17 00:00:00 2001
From: Anssi Hannula <anssi.hannula@bitwise.fi>
Date: Mon, 10 Oct 2022 17:08:26 +0200
Subject: [PATCH] can: kvaser_usb_leaf: Fix overread with an invalid command

For command events read from the device,
kvaser_usb_leaf_read_bulk_callback() verifies that cmd->len does not
exceed the size of the received data, but the actual kvaser_cmd handlers
will happily read any kvaser_cmd fields without checking for cmd->len.

This can cause an overread if the last cmd in the buffer is shorter than
expected for the command type (with cmd->len showing the actual short
size).

Maximum overread seems to be 22 bytes (CMD_LEAF_LOG_MESSAGE), some of
which are delivered to userspace as-is.

Fix that by verifying the length of command before handling it.

This issue can only occur after RX URBs have been set up, i.e. the
interface has been opened at least once.

Cc: stable@vger.kernel.org
Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010150829.199676-2-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 07f687f29b34..8e11cda85624 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -310,6 +310,38 @@ struct kvaser_cmd {
 	} u;
 } __packed;
 
+#define CMD_SIZE_ANY 0xff
+#define kvaser_fsize(field) sizeof_field(struct kvaser_cmd, field)
+
+static const u8 kvaser_usb_leaf_cmd_sizes_leaf[] = {
+	[CMD_START_CHIP_REPLY]		= kvaser_fsize(u.simple),
+	[CMD_STOP_CHIP_REPLY]		= kvaser_fsize(u.simple),
+	[CMD_GET_CARD_INFO_REPLY]	= kvaser_fsize(u.cardinfo),
+	[CMD_TX_ACKNOWLEDGE]		= kvaser_fsize(u.tx_acknowledge_header),
+	[CMD_GET_SOFTWARE_INFO_REPLY]	= kvaser_fsize(u.leaf.softinfo),
+	[CMD_RX_STD_MESSAGE]		= kvaser_fsize(u.leaf.rx_can),
+	[CMD_RX_EXT_MESSAGE]		= kvaser_fsize(u.leaf.rx_can),
+	[CMD_LEAF_LOG_MESSAGE]		= kvaser_fsize(u.leaf.log_message),
+	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.leaf.chip_state_event),
+	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.leaf.error_event),
+	/* ignored events: */
+	[CMD_FLUSH_QUEUE_REPLY]		= CMD_SIZE_ANY,
+};
+
+static const u8 kvaser_usb_leaf_cmd_sizes_usbcan[] = {
+	[CMD_START_CHIP_REPLY]		= kvaser_fsize(u.simple),
+	[CMD_STOP_CHIP_REPLY]		= kvaser_fsize(u.simple),
+	[CMD_GET_CARD_INFO_REPLY]	= kvaser_fsize(u.cardinfo),
+	[CMD_TX_ACKNOWLEDGE]		= kvaser_fsize(u.tx_acknowledge_header),
+	[CMD_GET_SOFTWARE_INFO_REPLY]	= kvaser_fsize(u.usbcan.softinfo),
+	[CMD_RX_STD_MESSAGE]		= kvaser_fsize(u.usbcan.rx_can),
+	[CMD_RX_EXT_MESSAGE]		= kvaser_fsize(u.usbcan.rx_can),
+	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.usbcan.chip_state_event),
+	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.usbcan.error_event),
+	/* ignored events: */
+	[CMD_USBCAN_CLOCK_OVERFLOW_EVENT] = CMD_SIZE_ANY,
+};
+
 /* Summary of a kvaser error event, for a unified Leaf/Usbcan error
  * handling. Some discrepancies between the two families exist:
  *
@@ -397,6 +429,43 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_32mhz = {
 	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
+static int kvaser_usb_leaf_verify_size(const struct kvaser_usb *dev,
+				       const struct kvaser_cmd *cmd)
+{
+	/* buffer size >= cmd->len ensured by caller */
+	u8 min_size = 0;
+
+	switch (dev->driver_info->family) {
+	case KVASER_LEAF:
+		if (cmd->id < ARRAY_SIZE(kvaser_usb_leaf_cmd_sizes_leaf))
+			min_size = kvaser_usb_leaf_cmd_sizes_leaf[cmd->id];
+		break;
+	case KVASER_USBCAN:
+		if (cmd->id < ARRAY_SIZE(kvaser_usb_leaf_cmd_sizes_usbcan))
+			min_size = kvaser_usb_leaf_cmd_sizes_usbcan[cmd->id];
+		break;
+	}
+
+	if (min_size == CMD_SIZE_ANY)
+		return 0;
+
+	if (min_size) {
+		min_size += CMD_HEADER_LEN;
+		if (cmd->len >= min_size)
+			return 0;
+
+		dev_err_ratelimited(&dev->intf->dev,
+				    "Received command %u too short (size %u, needed %u)",
+				    cmd->id, cmd->len, min_size);
+		return -EIO;
+	}
+
+	dev_warn_ratelimited(&dev->intf->dev,
+			     "Unhandled command (%d, size %d)\n",
+			     cmd->id, cmd->len);
+	return -EINVAL;
+}
+
 static void *
 kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
 			     const struct sk_buff *skb, int *cmd_len,
@@ -502,6 +571,9 @@ static int kvaser_usb_leaf_wait_cmd(const struct kvaser_usb *dev, u8 id,
 end:
 	kfree(buf);
 
+	if (err == 0)
+		err = kvaser_usb_leaf_verify_size(dev, cmd);
+
 	return err;
 }
 
@@ -1133,6 +1205,9 @@ static void kvaser_usb_leaf_stop_chip_reply(const struct kvaser_usb *dev,
 static void kvaser_usb_leaf_handle_command(const struct kvaser_usb *dev,
 					   const struct kvaser_cmd *cmd)
 {
+	if (kvaser_usb_leaf_verify_size(dev, cmd) < 0)
+		return;
+
 	switch (cmd->id) {
 	case CMD_START_CHIP_REPLY:
 		kvaser_usb_leaf_start_chip_reply(dev, cmd);

