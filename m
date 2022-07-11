Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C458756FA33
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiGKJPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbiGKJOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:14:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A58D33A3F;
        Mon, 11 Jul 2022 02:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F08E7B80D2C;
        Mon, 11 Jul 2022 09:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1B6C34115;
        Mon, 11 Jul 2022 09:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530616;
        bh=ISSddOJwrfYJ67l+qWRGRS53lNFwLCrHeQ3tWTBa6Yg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HibgTc4U++bnuZXWjuxlmyHGxRHvq8MKbHbd4BRBvA5N6rz11UAa5JMBGegbpEALn
         1PLgYJt3DAsfTTFgNEPrz8MQpUJKKT39Buz2odyQlwdXkKu+OjgC4FSEsOx1tVhAUO
         tea/ics9ycPCIuXUMszd+ebliLNPGS1vRdQk6UYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        "stable@vger.kernel.org, linux-can@vger.kernel.org, Marc Kleine-Budde" 
        <mkl@pengutronix.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH 5.4 17/38] can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits
Date:   Mon, 11 Jul 2022 11:06:59 +0200
Message-Id: <20220711090539.239691835@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Assarsson <extja@kvaser.com>

commit b3b6df2c56d80b8c6740433cff5f016668b8de70 upstream.

Use correct bittiming limits depending on device. For devices based on
USBcanII, Leaf M32C or Leaf i.MX28.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Fixes: b4f20130af23 ("can: kvaser_usb: add support for Kvaser Leaf v2 and usb mini PCIe")
Fixes: f5d4abea3ce0 ("can: kvaser_usb: Add support for the USBcan-II family")
Link: https://lore.kernel.org/all/20220603083820.800246-4-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
[mkl: remove stray netlink.h include]
[mkl: keep struct can_bittiming_const kvaser_usb_flexc_bittiming_const in kvaser_usb_hydra.c]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h       |    2 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |    4 -
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  |   76 ++++++++++++----------
 3 files changed, 47 insertions(+), 35 deletions(-)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -188,4 +188,6 @@ int kvaser_usb_send_cmd_async(struct kva
 
 int kvaser_usb_can_rx_over_error(struct net_device *netdev);
 
+extern const struct can_bittiming_const kvaser_usb_flexc_bittiming_const;
+
 #endif /* KVASER_USB_H */
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -371,7 +371,7 @@ static const struct can_bittiming_const
 	.brp_inc = 1,
 };
 
-static const struct can_bittiming_const kvaser_usb_hydra_flexc_bittiming_c = {
+const struct can_bittiming_const kvaser_usb_flexc_bittiming_const = {
 	.name = "kvaser_usb_flex",
 	.tseg1_min = 4,
 	.tseg1_max = 16,
@@ -2024,5 +2024,5 @@ static const struct kvaser_usb_dev_cfg k
 		.freq = 24000000,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_hydra_flexc_bittiming_c,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -100,16 +100,6 @@
 #define USBCAN_ERROR_STATE_RX_ERROR	BIT(1)
 #define USBCAN_ERROR_STATE_BUSERROR	BIT(2)
 
-/* bittiming parameters */
-#define KVASER_USB_TSEG1_MIN		1
-#define KVASER_USB_TSEG1_MAX		16
-#define KVASER_USB_TSEG2_MIN		1
-#define KVASER_USB_TSEG2_MAX		8
-#define KVASER_USB_SJW_MAX		4
-#define KVASER_USB_BRP_MIN		1
-#define KVASER_USB_BRP_MAX		64
-#define KVASER_USB_BRP_INC		1
-
 /* ctrl modes */
 #define KVASER_CTRL_MODE_NORMAL		1
 #define KVASER_CTRL_MODE_SILENT		2
@@ -342,48 +332,68 @@ struct kvaser_usb_err_summary {
 	};
 };
 
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
+static const struct can_bittiming_const kvaser_usb_leaf_m16c_bittiming_const = {
+	.name = "kvaser_usb_ucii",
+	.tseg1_min = 4,
+	.tseg1_max = 16,
+	.tseg2_min = 2,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 1,
+	.brp_max = 16,
+	.brp_inc = 1,
+};
+
+static const struct can_bittiming_const kvaser_usb_leaf_m32c_bittiming_const = {
+	.name = "kvaser_usb_leaf",
+	.tseg1_min = 3,
+	.tseg1_max = 16,
+	.tseg2_min = 2,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 2,
+	.brp_max = 128,
+	.brp_inc = 2,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_8mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_usbcan_dev_cfg = {
 	.clock = {
 		.freq = 8000000,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+	.bittiming_const = &kvaser_usb_leaf_m16c_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_m32c_dev_cfg = {
+	.clock = {
+		.freq = 16000000,
+	},
+	.timestamp_freq = 1,
+	.bittiming_const = &kvaser_usb_leaf_m32c_bittiming_const,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_16mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_16mhz = {
 	.clock = {
 		.freq = 16000000,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_24mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_24mhz = {
 	.clock = {
 		.freq = 24000000,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_32mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_32mhz = {
 	.clock = {
 		.freq = 32000000,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
 static void *
@@ -529,17 +539,17 @@ static void kvaser_usb_leaf_get_software
 		/* Firmware expects bittiming parameters calculated for 16MHz
 		 * clock, regardless of the actual clock
 		 */
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_16mhz;
+		dev->cfg = &kvaser_usb_leaf_m32c_dev_cfg;
 	} else {
 		switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
 		case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
-			dev->cfg = &kvaser_usb_leaf_dev_cfg_16mhz;
+			dev->cfg = &kvaser_usb_leaf_imx_dev_cfg_16mhz;
 			break;
 		case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
-			dev->cfg = &kvaser_usb_leaf_dev_cfg_24mhz;
+			dev->cfg = &kvaser_usb_leaf_imx_dev_cfg_24mhz;
 			break;
 		case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
-			dev->cfg = &kvaser_usb_leaf_dev_cfg_32mhz;
+			dev->cfg = &kvaser_usb_leaf_imx_dev_cfg_32mhz;
 			break;
 		}
 	}
@@ -566,7 +576,7 @@ static int kvaser_usb_leaf_get_software_
 		dev->fw_version = le32_to_cpu(cmd.u.usbcan.softinfo.fw_version);
 		dev->max_tx_urbs =
 			le16_to_cpu(cmd.u.usbcan.softinfo.max_outstanding_tx);
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_8mhz;
+		dev->cfg = &kvaser_usb_leaf_usbcan_dev_cfg;
 		break;
 	}
 


