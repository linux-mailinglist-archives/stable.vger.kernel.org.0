Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C7956C444
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbiGHSqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 14:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239675AbiGHSqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 14:46:45 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF2F8239A
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:46:43 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id z25so20137223lfr.2
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 11:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AMy8de6TpQ7SDUMaeXNoVmhUUEvnSjx81HEUyA4WtSM=;
        b=F+lS8fEpZYa4Gr7+T+drTdP9VWuaX27VQtTRfPL5xEtdIIMjSPYpAhKYX3ExhlabT7
         3BBov48Vx7WzYZZM1kz2xwnnfIXDm3OwG7OMN0RarADoDC6bkb3eMZVz5KRRan+rJgcp
         Kwa0U8KM+hCYfymMq5oQuTspfP0uFpSuSMYWTxV2ICyfgVvWYw/ZCrK/vX85H95K5ojU
         hbSj3hCOEVPDw/ns17oJaSSpeRKgoMNcqCZw6GE+g/elb4hfeCw0qFLaZfwmgfIQzgn8
         LVNOZwkhCJNY0cMv5GFK2e08Y/VX0HwUYNWF6ASUQq2wW6dSm7KMB/6GRzL9sI2dAats
         UwBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AMy8de6TpQ7SDUMaeXNoVmhUUEvnSjx81HEUyA4WtSM=;
        b=Yipv+CLToWzSma/XeThkhqo7e4wBejSvX8c/hUOvde2wg+SnCoeOBVU0PR/5RJK2MD
         k2cwDRP9VDAqEqgJZsZrF2zeblesHePXvaCMjW91YYr4qZRwYg2DUZQ2Ydz/mHRLNMoo
         5a1lWdq1uqpnLrTH4EcKqfR0vfOU6gu1tOVIT14tPyTVW45ALAWEWNfCAfurT+UkvOQs
         dDCKYivZORIVoTFBLHuGYdrtLerKIVMSJ4Un0z6qtDfWtaiAMgyGSStZcTxCcUBCL42L
         AOLL1mOXpFlGcowXynvS3mUgvIuvJg9hfI5F8eVyxLM4ysG03yyb/1wu2JgcrfRX+aD1
         6bcQ==
X-Gm-Message-State: AJIora8gUGs01FpgD3Bp6PnVP7d5tQ1iWPLZGuDbVxE+7QcAqZ8iVF9L
        rhx1oeWMoBt6knXZWIS+3EoDZCfGlUZ7XA==
X-Google-Smtp-Source: AGRyM1vxpehDd+MUWk6HSBRzZ+tvBVnldppP0AyFgQwz6/SadQhfZouHYJZRn9idTSCEaPfvLLdO/Q==
X-Received: by 2002:a19:640e:0:b0:479:5347:b86e with SMTP id y14-20020a19640e000000b004795347b86emr3102029lfb.563.1657306002027;
        Fri, 08 Jul 2022 11:46:42 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id 23-20020a2e1557000000b0025d4d4b4edbsm1159917ljv.34.2022.07.08.11.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 11:46:41 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH 4.9 4/4] can: kvaser_usb: fix bittiming limits
Date:   Fri,  8 Jul 2022 20:45:56 +0200
Message-Id: <20220708184556.280751-5-extja@kvaser.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708184556.280751-1-extja@kvaser.com>
References: <20220708184556.280751-1-extja@kvaser.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit b3b6df2c56d80b8c6740433cff5f016668b8de70 upstream.

Use correct bittiming limits depending on device. For devices based on
USBcanII, Leaf M32C or Leaf i.MX28.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Fixes: b4f20130af23 ("can: kvaser_usb: add support for Kvaser Leaf v2 and usb mini PCIe")
Fixes: f5d4abea3ce0 ("can: kvaser_usb: Add support for the USBcan-II family")
Link: https://lore.kernel.org/all/20220603083820.800246-4-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
---
 drivers/net/can/usb/kvaser_usb.c | 87 ++++++++++++++++++++------------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index 95fa50927bfe..0412b568c29f 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -154,16 +154,6 @@
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
@@ -495,44 +485,75 @@ struct kvaser_usb_dev_cfg {
 	const struct can_bittiming_const * const bittiming_const;
 };
 
-static const struct can_bittiming_const kvaser_usb_bittiming_const = {
-	.name = "kvaser_usb",
-	.tseg1_min = KVASER_USB_TSEG1_MIN,
-	.tseg1_max = KVASER_USB_TSEG1_MAX,
-	.tseg2_min = KVASER_USB_TSEG2_MIN,
-	.tseg2_max = KVASER_USB_TSEG2_MAX,
-	.sjw_max = KVASER_USB_SJW_MAX,
-	.brp_min = KVASER_USB_BRP_MIN,
-	.brp_max = KVASER_USB_BRP_MAX,
-	.brp_inc = KVASER_USB_BRP_INC,
+static const struct can_bittiming_const kvaser_usb_m16c_bittiming_const = {
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
+static const struct can_bittiming_const kvaser_usb_m32c_bittiming_const = {
+	.name = "kvaser_usb_leaf",
+	.tseg1_min = 3,
+	.tseg1_max = 16,
+	.tseg2_min = 2,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 2,
+	.brp_max = 128,
+	.brp_inc = 2,
+};
+
+static const struct can_bittiming_const kvaser_usb_flexc_bittiming_const = {
+	.name = "kvaser_usb_flex",
+	.tseg1_min = 4,
+	.tseg1_max = 16,
+	.tseg2_min = 2,
+	.tseg2_max = 8,
+	.sjw_max = 4,
+	.brp_min = 1,
+	.brp_max = 256,
+	.brp_inc = 1,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_8mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_usbcan_dev_cfg = {
 	.clock = {
 		.freq = 8000000,
 	},
-	.bittiming_const = &kvaser_usb_bittiming_const,
+	.bittiming_const = &kvaser_usb_m16c_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_m32c_dev_cfg = {
+	.clock = {
+		.freq = 16000000,
+	},
+	.bittiming_const = &kvaser_usb_m32c_bittiming_const,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_16mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_16mhz = {
 	.clock = {
 		.freq = 16000000,
 	},
-	.bittiming_const = &kvaser_usb_bittiming_const,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_24mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_24mhz = {
 	.clock = {
 		.freq = 24000000,
 	},
-	.bittiming_const = &kvaser_usb_bittiming_const,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_32mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_32mhz = {
 	.clock = {
 		.freq = 32000000,
 	},
-	.bittiming_const = &kvaser_usb_bittiming_const,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_usbcan = {
@@ -738,17 +759,17 @@ static void kvaser_usb_get_software_info_leaf(struct kvaser_usb *dev,
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
@@ -775,7 +796,7 @@ static int kvaser_usb_get_software_info(struct kvaser_usb *dev)
 		dev->fw_version = le32_to_cpu(msg.u.usbcan.softinfo.fw_version);
 		dev->max_tx_urbs =
 			le16_to_cpu(msg.u.usbcan.softinfo.max_outstanding_tx);
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_8mhz;
+		dev->cfg = &kvaser_usb_leaf_usbcan_dev_cfg;
 		break;
 	}
 
-- 
2.36.1

