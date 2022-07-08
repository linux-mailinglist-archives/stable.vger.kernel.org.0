Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B45556C388
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239745AbiGHStK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 14:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239755AbiGHStI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 14:49:08 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A7B86410
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:49:06 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id f39so37722767lfv.3
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 11:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qWNx/q9XpNCx9/Y/tfsZ/q8IwlhfSr5MDCuqvjZpFcc=;
        b=johKV8gKIYlM70NAC3xjMcEHoCYSe2WdZMl1rVPENYVjoUNgeFuGw9dSzJwl6bqCld
         vW+m5PeF+RgoVBdcuo36Mxyodqp7casXtKJjrt+uVzgBXtBUNVhzumHMVr4XuOXP0Ioc
         WvnGoK3sTx+/7qnwkRi/OOd22ev+x58pJ4gwqWevMKMmUwlwF8kf9zJuFd73GCJneB0l
         Jj3OF0zZ05sXNQyY3XBAj/rLCPF8VCuEsMb1qcJmGiBTeoYtxQzSSIlrzAWBZolm9loD
         TS+PwYkexk2BrgZEJnk1V69dBk3TAdQ2Sf8mXFFPnNdBY5J8XctoPD+OeaWkq+fiCXQc
         fiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qWNx/q9XpNCx9/Y/tfsZ/q8IwlhfSr5MDCuqvjZpFcc=;
        b=LNOgC+ssfd3LiGW1CncP7iWpvosh5k7vrqMXI19Nt0KDoORci9b1aNRn5RO28RvQhQ
         lM/99qVeKz0RG0nY+EMijLFi9ga3SSP0voVMLR+ldLeVeRxT4rhaul7yetPY2t8vCJAi
         uXq6WLo52PMF5/fIbnm6ZvSGg61Lk6LaPODDRjPNfxJHH4LTlwfMnathFpudOhdjfveP
         qKacwCkJ4Lpt/t9fye0wrz3ooemMvcnD+Wi3/Fm3lUFDNpVvh7/WxMBGzcGUglpjB+n1
         6PjzEIwQyij0f4w947eqhgk/knRVRcS7NRO5IARfNqAW3EA251plJFJRFwIeZZamOARw
         ohdA==
X-Gm-Message-State: AJIora8Tlgy3g0jpLt2gm9LRjJEhFonrqvdJxu109ZYVM7V/74FJx8Sx
        f/N6VbR4RSedlvCkepQeQOs5FplejdvH0g==
X-Google-Smtp-Source: AGRyM1vTSUyGnt1X9gx4UOz1msYoqijMP3We5KpBASuzm6O692+4miMH28JlRCSTiwDW5YJ4p097+Q==
X-Received: by 2002:a05:6512:3194:b0:487:5879:3b84 with SMTP id i20-20020a056512319400b0048758793b84mr3271666lfe.336.1657306144706;
        Fri, 08 Jul 2022 11:49:04 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id b8-20020a056512218800b0047f7c897b61sm7541684lft.129.2022.07.08.11.49.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 11:49:04 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH 5.15 3/3] can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits
Date:   Fri,  8 Jul 2022 20:48:46 +0200
Message-Id: <20220708184846.281174-4-extja@kvaser.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708184846.281174-1-extja@kvaser.com>
References: <20220708184846.281174-1-extja@kvaser.com>
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
[mkl: remove stray netlink.h include]
[mkl: keep struct can_bittiming_const kvaser_usb_flexc_bittiming_const in kvaser_usb_hydra.c]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  2 +
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c |  4 +-
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 76 +++++++++++--------
 3 files changed, 47 insertions(+), 35 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index 478e2eeec136..61e67986b625 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -188,4 +188,6 @@ int kvaser_usb_send_cmd_async(struct kvaser_usb_net_priv *priv, void *cmd,
 
 int kvaser_usb_can_rx_over_error(struct net_device *netdev);
 
+extern const struct can_bittiming_const kvaser_usb_flexc_bittiming_const;
+
 #endif /* KVASER_USB_H */
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index dcee8dc828ec..fce3f069cdbc 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -373,7 +373,7 @@ static const struct can_bittiming_const kvaser_usb_hydra_kcan_bittiming_c = {
 	.brp_inc = 1,
 };
 
-static const struct can_bittiming_const kvaser_usb_hydra_flexc_bittiming_c = {
+const struct can_bittiming_const kvaser_usb_flexc_bittiming_const = {
 	.name = "kvaser_usb_flex",
 	.tseg1_min = 4,
 	.tseg1_max = 16,
@@ -2052,7 +2052,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_flexc = {
 		.freq = 24000000,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_hydra_flexc_bittiming_c,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_rt = {
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index d94101c46508..b9c2231e4b43 100644
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
@@ -529,17 +539,17 @@ static void kvaser_usb_leaf_get_software_info_leaf(struct kvaser_usb *dev,
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
@@ -566,7 +576,7 @@ static int kvaser_usb_leaf_get_software_info_inner(struct kvaser_usb *dev)
 		dev->fw_version = le32_to_cpu(cmd.u.usbcan.softinfo.fw_version);
 		dev->max_tx_urbs =
 			le16_to_cpu(cmd.u.usbcan.softinfo.max_outstanding_tx);
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_8mhz;
+		dev->cfg = &kvaser_usb_leaf_usbcan_dev_cfg;
 		break;
 	}
 
-- 
2.36.1

