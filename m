Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E04D46FFE7
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 12:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237335AbhLJLfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 06:35:07 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52598 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234921AbhLJLfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 06:35:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1BB6CCE2ABA
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 11:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE973C341C6;
        Fri, 10 Dec 2021 11:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639135889;
        bh=0yLyALgsi4drLg6yoPA37T9GAOLMK8yPKvAjNtDiLQA=;
        h=Subject:To:Cc:From:Date:From;
        b=cLRSJfqkgQcwsV0LUB2VjhaaCm3OXlJBwLA96+syrKVyFC/chO13dR+Rm2S1KqBay
         8SpFM2e64HVey4Gg7HeGGwhr9E2xr1mCKwxr/DF2cnI7XzRmrNL43/bxkuNpM1w3oh
         E5l2I+kZNZNF5v/l3P1+IV1RLVlPQKlASOLZhU7g=
Subject: FAILED: patch "[PATCH] can: kvaser_usb: get CAN clock frequency from device" failed to apply to 4.4-stable tree
To:     extja@kvaser.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 12:31:16 +0100
Message-ID: <163913587663117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fb12797ab1fef480ad8a32a30984844444eeb00d Mon Sep 17 00:00:00 2001
From: Jimmy Assarsson <extja@kvaser.com>
Date: Wed, 8 Dec 2021 16:21:22 +0100
Subject: [PATCH] can: kvaser_usb: get CAN clock frequency from device

The CAN clock frequency is used when calculating the CAN bittiming
parameters. When wrong clock frequency is used, the device may end up
with wrong bittiming parameters, depending on user requested bittiming
parameters.

To avoid this, get the CAN clock frequency from the device. Various
existing Kvaser Leaf products use different CAN clocks.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Link: https://lore.kernel.org/all/20211208152122.250852-2-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 59ba7c7beec0..f7af1bf5ab46 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -28,10 +28,6 @@
 
 #include "kvaser_usb.h"
 
-/* Forward declaration */
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg;
-
-#define CAN_USB_CLOCK			8000000
 #define MAX_USBCAN_NET_DEVICES		2
 
 /* Command header size */
@@ -80,6 +76,12 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg;
 
 #define CMD_LEAF_LOG_MESSAGE		106
 
+/* Leaf frequency options */
+#define KVASER_USB_LEAF_SWOPTION_FREQ_MASK 0x60
+#define KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK 0
+#define KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK BIT(5)
+#define KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK BIT(6)
+
 /* error factors */
 #define M16C_EF_ACKE			BIT(0)
 #define M16C_EF_CRCE			BIT(1)
@@ -340,6 +342,50 @@ struct kvaser_usb_err_summary {
 	};
 };
 
+static const struct can_bittiming_const kvaser_usb_leaf_bittiming_const = {
+	.name = "kvaser_usb",
+	.tseg1_min = KVASER_USB_TSEG1_MIN,
+	.tseg1_max = KVASER_USB_TSEG1_MAX,
+	.tseg2_min = KVASER_USB_TSEG2_MIN,
+	.tseg2_max = KVASER_USB_TSEG2_MAX,
+	.sjw_max = KVASER_USB_SJW_MAX,
+	.brp_min = KVASER_USB_BRP_MIN,
+	.brp_max = KVASER_USB_BRP_MAX,
+	.brp_inc = KVASER_USB_BRP_INC,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_8mhz = {
+	.clock = {
+		.freq = 8000000,
+	},
+	.timestamp_freq = 1,
+	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_16mhz = {
+	.clock = {
+		.freq = 16000000,
+	},
+	.timestamp_freq = 1,
+	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_24mhz = {
+	.clock = {
+		.freq = 24000000,
+	},
+	.timestamp_freq = 1,
+	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_32mhz = {
+	.clock = {
+		.freq = 32000000,
+	},
+	.timestamp_freq = 1,
+	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+};
+
 static void *
 kvaser_usb_leaf_frame_to_cmd(const struct kvaser_usb_net_priv *priv,
 			     const struct sk_buff *skb, int *frame_len,
@@ -471,6 +517,27 @@ static int kvaser_usb_leaf_send_simple_cmd(const struct kvaser_usb *dev,
 	return rc;
 }
 
+static void kvaser_usb_leaf_get_software_info_leaf(struct kvaser_usb *dev,
+						   const struct leaf_cmd_softinfo *softinfo)
+{
+	u32 sw_options = le32_to_cpu(softinfo->sw_options);
+
+	dev->fw_version = le32_to_cpu(softinfo->fw_version);
+	dev->max_tx_urbs = le16_to_cpu(softinfo->max_outstanding_tx);
+
+	switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
+	case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_16mhz;
+		break;
+	case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_24mhz;
+		break;
+	case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_32mhz;
+		break;
+	}
+}
+
 static int kvaser_usb_leaf_get_software_info_inner(struct kvaser_usb *dev)
 {
 	struct kvaser_cmd cmd;
@@ -486,14 +553,13 @@ static int kvaser_usb_leaf_get_software_info_inner(struct kvaser_usb *dev)
 
 	switch (dev->card_data.leaf.family) {
 	case KVASER_LEAF:
-		dev->fw_version = le32_to_cpu(cmd.u.leaf.softinfo.fw_version);
-		dev->max_tx_urbs =
-			le16_to_cpu(cmd.u.leaf.softinfo.max_outstanding_tx);
+		kvaser_usb_leaf_get_software_info_leaf(dev, &cmd.u.leaf.softinfo);
 		break;
 	case KVASER_USBCAN:
 		dev->fw_version = le32_to_cpu(cmd.u.usbcan.softinfo.fw_version);
 		dev->max_tx_urbs =
 			le16_to_cpu(cmd.u.usbcan.softinfo.max_outstanding_tx);
+		dev->cfg = &kvaser_usb_leaf_dev_cfg_8mhz;
 		break;
 	}
 
@@ -1225,24 +1291,11 @@ static int kvaser_usb_leaf_init_card(struct kvaser_usb *dev)
 {
 	struct kvaser_usb_dev_card_data *card_data = &dev->card_data;
 
-	dev->cfg = &kvaser_usb_leaf_dev_cfg;
 	card_data->ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
 
 	return 0;
 }
 
-static const struct can_bittiming_const kvaser_usb_leaf_bittiming_const = {
-	.name = "kvaser_usb",
-	.tseg1_min = KVASER_USB_TSEG1_MIN,
-	.tseg1_max = KVASER_USB_TSEG1_MAX,
-	.tseg2_min = KVASER_USB_TSEG2_MIN,
-	.tseg2_max = KVASER_USB_TSEG2_MAX,
-	.sjw_max = KVASER_USB_SJW_MAX,
-	.brp_min = KVASER_USB_BRP_MIN,
-	.brp_max = KVASER_USB_BRP_MAX,
-	.brp_inc = KVASER_USB_BRP_INC,
-};
-
 static int kvaser_usb_leaf_set_bittiming(struct net_device *netdev)
 {
 	struct kvaser_usb_net_priv *priv = netdev_priv(netdev);
@@ -1348,11 +1401,3 @@ const struct kvaser_usb_dev_ops kvaser_usb_leaf_dev_ops = {
 	.dev_read_bulk_callback = kvaser_usb_leaf_read_bulk_callback,
 	.dev_frame_to_cmd = kvaser_usb_leaf_frame_to_cmd,
 };
-
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg = {
-	.clock = {
-		.freq = CAN_USB_CLOCK,
-	},
-	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
-};

