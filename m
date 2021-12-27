Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DC747FE5E
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbhL0P2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237563AbhL0P2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:28:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F64C061398;
        Mon, 27 Dec 2021 07:28:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39B63610A5;
        Mon, 27 Dec 2021 15:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EEABC36AE7;
        Mon, 27 Dec 2021 15:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618897;
        bh=6hiFfT3Okr3x7F8HApRm7/RqZrcZQ/0xTZVyytzHz5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0j3QDwA2B69Fjn5lMntBiOiKn9evCC0XDiQ/R11Qx7XqPdjBghBihkQ6pvuV5z39
         kN+2eO+8FYHmPaQSjxDjo0clIUAfkOax5KUmI8/YYj2kKkmgHX6y9DBlYD/jDbSWyx
         cUl6O8Thbtc4MF5k5OGmTwrRO1jp1YMzdXgAFpGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.9 02/19] can: kvaser_usb: get CAN clock frequency from device
Date:   Mon, 27 Dec 2021 16:27:04 +0100
Message-Id: <20211227151316.635570716@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151316.558965545@linuxfoundation.org>
References: <20211227151316.558965545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

commit fb12797ab1fef480ad8a32a30984844444eeb00d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb.c |   41 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -31,7 +31,10 @@
 #define USB_SEND_TIMEOUT		1000 /* msecs */
 #define USB_RECV_TIMEOUT		1000 /* msecs */
 #define RX_BUFFER_SIZE			3072
-#define CAN_USB_CLOCK			8000000
+#define KVASER_USB_CAN_CLOCK_8MHZ	8000000
+#define KVASER_USB_CAN_CLOCK_16MHZ	16000000
+#define KVASER_USB_CAN_CLOCK_24MHZ	24000000
+#define KVASER_USB_CAN_CLOCK_32MHZ	32000000
 #define MAX_NET_DEVICES			3
 #define MAX_USBCAN_NET_DEVICES		2
 
@@ -142,6 +145,12 @@ static inline bool kvaser_is_usbcan(cons
 #define CMD_LEAF_USB_THROTTLE		77
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
@@ -472,6 +481,8 @@ struct kvaser_usb {
 	bool rxinitdone;
 	void *rxbuf[MAX_RX_URBS];
 	dma_addr_t rxbuf_dma[MAX_RX_URBS];
+
+	struct can_clock clock;
 };
 
 struct kvaser_usb_net_priv {
@@ -652,6 +663,27 @@ static int kvaser_usb_send_simple_msg(co
 	return rc;
 }
 
+static void kvaser_usb_get_software_info_leaf(struct kvaser_usb *dev,
+					      const struct leaf_msg_softinfo *softinfo)
+{
+	u32 sw_options = le32_to_cpu(softinfo->sw_options);
+
+	dev->fw_version = le32_to_cpu(softinfo->fw_version);
+	dev->max_tx_urbs = le16_to_cpu(softinfo->max_outstanding_tx);
+
+	switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
+	case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
+		dev->clock.freq = KVASER_USB_CAN_CLOCK_16MHZ;
+		break;
+	case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
+		dev->clock.freq = KVASER_USB_CAN_CLOCK_24MHZ;
+		break;
+	case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
+		dev->clock.freq = KVASER_USB_CAN_CLOCK_32MHZ;
+		break;
+	}
+}
+
 static int kvaser_usb_get_software_info(struct kvaser_usb *dev)
 {
 	struct kvaser_msg msg;
@@ -667,14 +699,13 @@ static int kvaser_usb_get_software_info(
 
 	switch (dev->family) {
 	case KVASER_LEAF:
-		dev->fw_version = le32_to_cpu(msg.u.leaf.softinfo.fw_version);
-		dev->max_tx_urbs =
-			le16_to_cpu(msg.u.leaf.softinfo.max_outstanding_tx);
+		kvaser_usb_get_software_info_leaf(dev, &msg.u.leaf.softinfo);
 		break;
 	case KVASER_USBCAN:
 		dev->fw_version = le32_to_cpu(msg.u.usbcan.softinfo.fw_version);
 		dev->max_tx_urbs =
 			le16_to_cpu(msg.u.usbcan.softinfo.max_outstanding_tx);
+		dev->clock.freq = KVASER_USB_CAN_CLOCK_8MHZ;
 		break;
 	}
 
@@ -1926,7 +1957,7 @@ static int kvaser_usb_init_one(struct us
 	kvaser_usb_reset_tx_urb_contexts(priv);
 
 	priv->can.state = CAN_STATE_STOPPED;
-	priv->can.clock.freq = CAN_USB_CLOCK;
+	priv->can.clock.freq = dev->clock.freq;
 	priv->can.bittiming_const = &kvaser_usb_bittiming_const;
 	priv->can.do_set_bittiming = kvaser_usb_set_bittiming;
 	priv->can.do_set_mode = kvaser_usb_set_mode;


