Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D43C53C6FD
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 10:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242713AbiFCIjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 04:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbiFCIjH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 04:39:07 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF40132EF1
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 01:39:05 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id a2so11544827lfc.2
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 01:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VE+yOBZ5b6FGB8bFZDZ4zKAzK/d/aGYeDxgjxDS2P+0=;
        b=X1NOJ7Gb5VBZlLADGP0fWkBWePJQEGCIPVVfrIbcH+O2nTypPnwvWmdJAkDz6bygFl
         sYbhgdXRaMYdA2qAiICQqUXTjxysWoKQ6ehfmu9OdzazLU9OV+SfU9cPfDno64zQrdOA
         pclUet/waVe3SMn/ly9uCycFgPiMcSLnl1vgMaw3PmXrri0y9wANFpO+KevxbaZEozjG
         8UWLWA3QPdaFsYmtKH8vwAFrWQ1/r25w+qa28+QoCptDyOiFMTJwUV3uH7PQIRuF45ST
         lsQjhRtdhjdLQ+7oGnR0gM2TLQhTlaQSTqmG5NPifHHBY9Nw1coLjuzT8liLIlKGu62k
         WB/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VE+yOBZ5b6FGB8bFZDZ4zKAzK/d/aGYeDxgjxDS2P+0=;
        b=URxCeNLOG65csTVfB1aX0VqaLJcTfY2Ch9YhCgdoH6MdP1mAhIag2Rt+WdxZFbijWt
         gJMBxko4+ngEoBAu66CMm4Ten5IDrrjrTHPvoX2Gq6GtOYhglOo3NC1ljYJ7f02UBahC
         ZfrOcJ0SGiAnsLDgn/XILSZ1OS6Lpx0Y+BMkxeYhQenwAdhBfeOICfchI0J/x/9m7XfE
         DmMI3bobNvE54CTyNplC9hQJgkT6fHdEFUxG4jlscpfP9dwsBApK6Vbn4TkeNArg5t5R
         PR4a2qmPFWf0L6lp8tWRnGxtfjhCWvfqAZusVPy2WP2uy436tS6G49h7AkM8QMdVM/FZ
         WkdQ==
X-Gm-Message-State: AOAM531ZcFIkSbz4EMU5QOX0SfobcKXx+dyrzfK3QGF2TIFc2qjNMPtg
        bpomd80BgNxzd80MY2/OU/cy5A==
X-Google-Smtp-Source: ABdhPJxDttWt2J1rneIbZ9UTMbZjbWNkPHxWCbvQs16LrORUY0xUeSLiuAe4KA3u341M90cAtTkj0w==
X-Received: by 2002:ac2:5e6e:0:b0:479:693:eb45 with SMTP id a14-20020ac25e6e000000b004790693eb45mr6442569lfr.582.1654245544051;
        Fri, 03 Jun 2022 01:39:04 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id g28-20020a2eb5dc000000b00253dfbe2522sm1169898ljn.100.2022.06.03.01.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 01:39:03 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v2 3/3] can: kvaser_usb: kvaser_usb_leaf: Fix bittiming limits
Date:   Fri,  3 Jun 2022 10:38:20 +0200
Message-Id: <20220603083820.800246-4-extja@kvaser.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603083820.800246-1-extja@kvaser.com>
References: <20220603083820.800246-1-extja@kvaser.com>
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

Use correct bittiming limits depending on device.
For devices based on USBcanII, Leaf M32C or Leaf i.MX28.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Fixes: b4f20130af23 ("can: kvaser_usb: add support for Kvaser Leaf v2 and usb mini PCIe")
Fixes: f5d4abea3ce0 ("can: kvaser_usb: Add support for the USBcan-II family")
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
---
Changes in v2:
  - Rebased patch

 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   | 13 ++++
 .../net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 14 +---
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 76 +++++++++++--------
 3 files changed, 57 insertions(+), 46 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index 383b7144d6b5..2813ec58ae1c 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -28,6 +28,7 @@
 
 #include <linux/can.h>
 #include <linux/can/dev.h>
+#include <linux/can/netlink.h>
 
 #define KVASER_USB_MAX_RX_URBS			4
 #define KVASER_USB_MAX_TX_URBS			128
@@ -224,4 +225,16 @@ static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leafimx = {
 	.quirks = 0,
 	.ops = &kvaser_usb_leaf_dev_ops,
 };
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
+};
 #endif /* KVASER_USB_H */
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
index a26823c5b62a..faf901e7e568 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c
@@ -375,18 +375,6 @@ static const struct can_bittiming_const kvaser_usb_hydra_kcan_bittiming_c = {
 	.brp_inc = 1,
 };
 
-static const struct can_bittiming_const kvaser_usb_hydra_flexc_bittiming_c = {
-	.name = "kvaser_usb_flex",
-	.tseg1_min = 4,
-	.tseg1_max = 16,
-	.tseg2_min = 2,
-	.tseg2_max = 8,
-	.sjw_max = 4,
-	.brp_min = 1,
-	.brp_max = 256,
-	.brp_inc = 1,
-};
-
 static const struct can_bittiming_const kvaser_usb_hydra_rt_bittiming_c = {
 	.name = "kvaser_usb_rt",
 	.tseg1_min = 2,
@@ -2052,7 +2040,7 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_flexc = {
 		.freq = 24 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_hydra_flexc_bittiming_c,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
 static const struct kvaser_usb_dev_cfg kvaser_usb_hydra_dev_cfg_rt = {
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 957144cee414..cc809ecd1e62 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -101,16 +101,6 @@
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
@@ -343,48 +333,68 @@ struct kvaser_usb_err_summary {
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
 		.freq = 8 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+	.bittiming_const = &kvaser_usb_leaf_m16c_bittiming_const,
+};
+
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_m32c_dev_cfg = {
+	.clock = {
+		.freq = 16 * MEGA /* Hz */,
+	},
+	.timestamp_freq = 1,
+	.bittiming_const = &kvaser_usb_leaf_m32c_bittiming_const,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_16mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_16mhz = {
 	.clock = {
 		.freq = 16 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_24mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_24mhz = {
 	.clock = {
 		.freq = 24 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
-static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_32mhz = {
+static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_imx_dev_cfg_32mhz = {
 	.clock = {
 		.freq = 32 * MEGA /* Hz */,
 	},
 	.timestamp_freq = 1,
-	.bittiming_const = &kvaser_usb_leaf_bittiming_const,
+	.bittiming_const = &kvaser_usb_flexc_bittiming_const,
 };
 
 static void *
@@ -528,17 +538,17 @@ static void kvaser_usb_leaf_get_software_info_leaf(struct kvaser_usb *dev,
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
@@ -565,7 +575,7 @@ static int kvaser_usb_leaf_get_software_info_inner(struct kvaser_usb *dev)
 		dev->fw_version = le32_to_cpu(cmd.u.usbcan.softinfo.fw_version);
 		dev->max_tx_urbs =
 			le16_to_cpu(cmd.u.usbcan.softinfo.max_outstanding_tx);
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_8mhz;
+		dev->cfg = &kvaser_usb_leaf_usbcan_dev_cfg;
 		break;
 	}
 
-- 
2.36.1

