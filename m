Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973396674A2
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbjALOKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbjALOJb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:09:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7995882E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:05:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97B7660110
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5588C433EF;
        Thu, 12 Jan 2023 14:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532304;
        bh=kbu1vVHx9t7b1FIZZW/ZmvZBmnndYlTOUDbH3KYCrGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTHhWP6nhBk/FHqRCm+De5S0n9AGndb4BmyQ+8wG083HqXKY5oBDM1jNwFAY/v4DS
         ACrM7FJ/JAAyw3IgLihuGYRhbisXGXe79lcUyxyR9MEo6fM7YtfTK8xPEV5bTX/tbN
         5VDA0FHw3zn+WZZrvonQl5xUb8Z9cTtFklqSvf9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anssi Hannula <anssi.hannula@bitwise.fi>,
        Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/783] can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT
Date:   Thu, 12 Jan 2023 14:47:14 +0100
Message-Id: <20230112135529.686683574@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit b24cb2d169e0c9dce664a959e1f2aa9781285dc9 ]

The device will send an error event command, to indicate certain errors.
This indicates a misbehaving driver, and should never occur.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Tested-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Co-developed-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Anssi Hannula <anssi.hannula@bitwise.fi>
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20221010185237.319219-5-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 4f3d1150b2b2..3c3e78992b55 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -69,6 +69,7 @@
 #define CMD_GET_CARD_INFO_REPLY		35
 #define CMD_GET_SOFTWARE_INFO		38
 #define CMD_GET_SOFTWARE_INFO_REPLY	39
+#define CMD_ERROR_EVENT			45
 #define CMD_FLUSH_QUEUE			48
 #define CMD_TX_ACKNOWLEDGE		50
 #define CMD_CAN_ERROR_EVENT		51
@@ -257,6 +258,28 @@ struct usbcan_cmd_can_error_event {
 	__le16 time;
 } __packed;
 
+/* CMD_ERROR_EVENT error codes */
+#define KVASER_USB_LEAF_ERROR_EVENT_TX_QUEUE_FULL 0x8
+#define KVASER_USB_LEAF_ERROR_EVENT_PARAM 0x9
+
+struct leaf_cmd_error_event {
+	u8 tid;
+	u8 error_code;
+	__le16 timestamp[3];
+	__le16 padding;
+	__le16 info1;
+	__le16 info2;
+} __packed;
+
+struct usbcan_cmd_error_event {
+	u8 tid;
+	u8 error_code;
+	__le16 info1;
+	__le16 info2;
+	__le16 timestamp;
+	__le16 padding;
+} __packed;
+
 struct kvaser_cmd_ctrl_mode {
 	u8 tid;
 	u8 channel;
@@ -320,6 +343,7 @@ struct kvaser_cmd {
 			struct leaf_cmd_chip_state_event chip_state_event;
 			struct leaf_cmd_can_error_event can_error_event;
 			struct leaf_cmd_log_message log_message;
+			struct leaf_cmd_error_event error_event;
 			struct kvaser_cmd_cap_req cap_req;
 			struct kvaser_cmd_cap_res cap_res;
 		} __packed leaf;
@@ -329,6 +353,7 @@ struct kvaser_cmd {
 			struct usbcan_cmd_rx_can rx_can;
 			struct usbcan_cmd_chip_state_event chip_state_event;
 			struct usbcan_cmd_can_error_event can_error_event;
+			struct usbcan_cmd_error_event error_event;
 		} __packed usbcan;
 
 		struct kvaser_cmd_tx_can tx_can;
@@ -352,6 +377,7 @@ static const u8 kvaser_usb_leaf_cmd_sizes_leaf[] = {
 	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.leaf.chip_state_event),
 	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.leaf.can_error_event),
 	[CMD_GET_CAPABILITIES_RESP]	= kvaser_fsize(u.leaf.cap_res),
+	[CMD_ERROR_EVENT]		= kvaser_fsize(u.leaf.error_event),
 	/* ignored events: */
 	[CMD_FLUSH_QUEUE_REPLY]		= CMD_SIZE_ANY,
 };
@@ -366,6 +392,7 @@ static const u8 kvaser_usb_leaf_cmd_sizes_usbcan[] = {
 	[CMD_RX_EXT_MESSAGE]		= kvaser_fsize(u.usbcan.rx_can),
 	[CMD_CHIP_STATE_EVENT]		= kvaser_fsize(u.usbcan.chip_state_event),
 	[CMD_CAN_ERROR_EVENT]		= kvaser_fsize(u.usbcan.can_error_event),
+	[CMD_ERROR_EVENT]		= kvaser_fsize(u.usbcan.error_event),
 	/* ignored events: */
 	[CMD_USBCAN_CLOCK_OVERFLOW_EVENT] = CMD_SIZE_ANY,
 };
@@ -1308,6 +1335,74 @@ static void kvaser_usb_leaf_rx_can_msg(const struct kvaser_usb *dev,
 	netif_rx(skb);
 }
 
+static void kvaser_usb_leaf_error_event_parameter(const struct kvaser_usb *dev,
+						  const struct kvaser_cmd *cmd)
+{
+	u16 info1 = 0;
+
+	switch (dev->driver_info->family) {
+	case KVASER_LEAF:
+		info1 = le16_to_cpu(cmd->u.leaf.error_event.info1);
+		break;
+	case KVASER_USBCAN:
+		info1 = le16_to_cpu(cmd->u.usbcan.error_event.info1);
+		break;
+	}
+
+	/* info1 will contain the offending cmd_no */
+	switch (info1) {
+	case CMD_SET_CTRL_MODE:
+		dev_warn(&dev->intf->dev,
+			 "CMD_SET_CTRL_MODE error in parameter\n");
+		break;
+
+	case CMD_SET_BUS_PARAMS:
+		dev_warn(&dev->intf->dev,
+			 "CMD_SET_BUS_PARAMS error in parameter\n");
+		break;
+
+	default:
+		dev_warn(&dev->intf->dev,
+			 "Unhandled parameter error event cmd_no (%u)\n",
+			 info1);
+		break;
+	}
+}
+
+static void kvaser_usb_leaf_error_event(const struct kvaser_usb *dev,
+					const struct kvaser_cmd *cmd)
+{
+	u8 error_code = 0;
+
+	switch (dev->driver_info->family) {
+	case KVASER_LEAF:
+		error_code = cmd->u.leaf.error_event.error_code;
+		break;
+	case KVASER_USBCAN:
+		error_code = cmd->u.usbcan.error_event.error_code;
+		break;
+	}
+
+	switch (error_code) {
+	case KVASER_USB_LEAF_ERROR_EVENT_TX_QUEUE_FULL:
+		/* Received additional CAN message, when firmware TX queue is
+		 * already full. Something is wrong with the driver.
+		 * This should never happen!
+		 */
+		dev_err(&dev->intf->dev,
+			"Received error event TX_QUEUE_FULL\n");
+		break;
+	case KVASER_USB_LEAF_ERROR_EVENT_PARAM:
+		kvaser_usb_leaf_error_event_parameter(dev, cmd);
+		break;
+
+	default:
+		dev_warn(&dev->intf->dev,
+			 "Unhandled error event (%d)\n", error_code);
+		break;
+	}
+}
+
 static void kvaser_usb_leaf_start_chip_reply(const struct kvaser_usb *dev,
 					     const struct kvaser_cmd *cmd)
 {
@@ -1386,6 +1481,10 @@ static void kvaser_usb_leaf_handle_command(const struct kvaser_usb *dev,
 		kvaser_usb_leaf_tx_acknowledge(dev, cmd);
 		break;
 
+	case CMD_ERROR_EVENT:
+		kvaser_usb_leaf_error_event(dev, cmd);
+		break;
+
 	/* Ignored commands */
 	case CMD_USBCAN_CLOCK_OVERFLOW_EVENT:
 		if (dev->driver_info->family != KVASER_USBCAN)
-- 
2.35.1



