Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A3C56C27A
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239684AbiGHSrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 14:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239691AbiGHSrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 14:47:23 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6657C1AA
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:47:21 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id bu42so17872425lfb.0
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 11:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EKxwT1+g83OS35d/oGd+WSJ3CUbjUlmFhBzM2UJwvEU=;
        b=ZSoXR/yYO7A0dDwURnrfMjOCmN0AqlI2xW9SFiV2IThyIw8Zpd/cspbf6FBXlpdK2I
         8X17L06Yxweh7pl489OQlv12b/awVG77fTvDkTOEVGeXroCPlzSqOMyCLm2FjouG/gRs
         Z0rHYUC7wWwGsk6ekLMipAF812kB3FAkogBrtALWjPGIUhgtK60NC9y3Xvh4yrf5wnFv
         ZRCG1wa+z1jiept8FTnJfjGT9mIULTT7WCPdqk4i6RlGvgpSE9s8sxA7Vmdy4jEtX8/d
         7b6lesmP8DdKNT18QFwLdKWgFAmdQIWaWoNgzgu0jjh918J4IWS/skPRhsjjJKrIMKON
         2UaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EKxwT1+g83OS35d/oGd+WSJ3CUbjUlmFhBzM2UJwvEU=;
        b=ySX+ge2LbIlrUn02jUwmG8leUBsiSkvlYvACi2iRdXH27jjaUcN6ll/g4+nrH4EUJU
         +bnkb5Zri5ihep9w8MaXaVkifpLjBFOsSXmmIWvPcdbshG3F2WIm8OhEC4m8uv4N4Ddr
         PG5JiGZOM6FqB4MbW7OBUKBXOGRmVEHEYNEefmDtWSTdQZM+ie8Cu2X5/IabjChv2uuO
         S++dlFlaDnknfilY0CpYFNllak5nEefne1fqwzWIKvqRtqZqY++2nvvRF2VW6HNTISHK
         RaQ9xoG2qyFZPwDhBJZ08+Y0aeDe+nH4tNYkXUjbQ0aBhgV0pR4GjpiUqcFh2oZ5XqgK
         bvRA==
X-Gm-Message-State: AJIora9lcD2jcsA7y7vN4tdiiwBwUyxbyrBTxUza34FN5spxmk4PJyxU
        T1cHLAlECTAJL9P3H1Jo+P+Gt1REPRgVOA==
X-Google-Smtp-Source: AGRyM1tiV7tA0gAQ7ckHgmEY9hxmiIsOpjp5wDDlbOyL9Jd8+FXFxnRI5P0SZuReUQrF2eSnNOtYnQ==
X-Received: by 2002:a05:6512:4029:b0:489:c7a7:42c8 with SMTP id br41-20020a056512402900b00489c7a742c8mr819272lfb.461.1657306039386;
        Fri, 08 Jul 2022 11:47:19 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id u22-20020a197916000000b0047fa941067fsm7558386lfc.29.2022.07.08.11.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 11:47:18 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH 4.14 4/4] can: kvaser_usb: fix bittiming limits
Date:   Fri,  8 Jul 2022 20:46:53 +0200
Message-Id: <20220708184653.280882-5-extja@kvaser.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708184653.280882-1-extja@kvaser.com>
References: <20220708184653.280882-1-extja@kvaser.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
index 5190897ec6c9..b1a140a39773 100644
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

