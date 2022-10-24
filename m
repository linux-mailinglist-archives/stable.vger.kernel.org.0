Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1669760BC72
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 23:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiJXVqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 17:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiJXVqR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 17:46:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C9F2EA955;
        Mon, 24 Oct 2022 12:58:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D1AEB815A0;
        Mon, 24 Oct 2022 12:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BD6C433D6;
        Mon, 24 Oct 2022 12:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613879;
        bh=FfZJQ7cgeQy24SFeoZdkQ03d0JuMApp87TbnvR3NJuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBAGGF4VP2/TstTJSuvbjFA+00r5iAsHYwq8vJTMpEjgQGA1xH8bqQ12NyKCjRnaN
         UVhV/fy1QYDBKboRK3hHCO7QQ8/5grDdI5Zjr1gh4091f94utsCs+E89Yryc+W3NA5
         KK3hyEtvrNTmzMRLpGTzNv2OAgRmUeJCrimHim0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Anssi Hannula <anssi.hannula@bitwise.fi>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 019/390] can: kvaser_usb_leaf: Fix overread with an invalid command
Date:   Mon, 24 Oct 2022 13:26:56 +0200
Message-Id: <20221024113023.359221079@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anssi Hannula <anssi.hannula@bitwise.fi>

commit 1499ecaea9d2ba68d5e18d80573b4561a8dc4ee7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c |   75 +++++++++++++++++++++++
 1 file changed, 75 insertions(+)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -309,6 +309,38 @@ struct kvaser_cmd {
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
@@ -396,6 +428,43 @@ static const struct kvaser_usb_dev_cfg k
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
 			     const struct sk_buff *skb, int *frame_len,
@@ -503,6 +572,9 @@ static int kvaser_usb_leaf_wait_cmd(cons
 end:
 	kfree(buf);
 
+	if (err == 0)
+		err = kvaser_usb_leaf_verify_size(dev, cmd);
+
 	return err;
 }
 
@@ -1137,6 +1209,9 @@ static void kvaser_usb_leaf_stop_chip_re
 static void kvaser_usb_leaf_handle_command(const struct kvaser_usb *dev,
 					   const struct kvaser_cmd *cmd)
 {
+	if (kvaser_usb_leaf_verify_size(dev, cmd) < 0)
+		return;
+
 	switch (cmd->id) {
 	case CMD_START_CHIP_REPLY:
 		kvaser_usb_leaf_start_chip_reply(dev, cmd);


