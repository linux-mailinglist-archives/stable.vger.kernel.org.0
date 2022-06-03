Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F5C53C6FC
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 10:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239786AbiFCIjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 04:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235243AbiFCIjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 04:39:04 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FE832EF1
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 01:39:02 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id l30so11537537lfj.3
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 01:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gZ4VhR3xg2wPNXdmY+BxCMpH+9UUc5TjlI9nWUQf1Y8=;
        b=pXK4K4dTq1h5nxtKDiK4a4dKE4je/qvzd4DMy7S+WKzKq3MvvdOx74lTF9V6ft2XYg
         2e2jeno+u9fkchLFDYO8WuPT75piyGfFBdioUF9Gh1B8cKJgSpKHrGQiN2OikENmSdKb
         V9X9CHlCL3pZ5Kz2YlRLZH0ZlfeoL5q/YcZlpWtzYn6nQyM5AxDVSFCImuxdbsNcrkS2
         dLWbJEGV8isPpll1hdMVywdv1uArv1xvYG/+jdhTCjmqPMFMhK2lmfgwSJ9lyu80Yauc
         ONfCloPyULuGwNBX6hHMjkRFfbr4GIbq4FF0fiV8a1LS+gcrkuorKr12gXcVjjqvxRYn
         vYcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gZ4VhR3xg2wPNXdmY+BxCMpH+9UUc5TjlI9nWUQf1Y8=;
        b=ZqFPiJmBa9OkRa47e/gdqSnVugJpllCctmPNIzbZB90riX2wZrY/7Foa6phUWBppU1
         pRDboGoMTRTvrm4VZZSBXypb1x2TRQaHDfq7YNuI5UlzQPIGRrJE2pBI5NKr4FoQ3BAb
         WHPaUZsXzrIH55ZTFbqeS7j5qWYIbhIiacrUlnHuMRhwKLQBazErZR7YJZf3Zu63o/d3
         D7Ajx2SjTdoHdrUOqsOT/fhq9nT4Y4bHnAcb0LwAmcQ8VLTuOvZyDrGbSAFQK9dyyrDD
         ntwqlgHFEExE9phNrZoCsdI7QJY6ncYOIvtxJuvkC16dYyUrhXMDHIa2QRX0eoSg0f95
         VoYA==
X-Gm-Message-State: AOAM532M1CxZcm0tGOZPdFcrOVqiR/4jamNgggldnUkru7tUIVOFOwGi
        NWeIeZ38PCVBudTBIepee02ppQ==
X-Google-Smtp-Source: ABdhPJykshnyM8+w+SGcCuK2cgftCBDM8JoGMFgvwzNnfGUIbSTtEg5NEMILqmj7lJSIfUUkcttv4g==
X-Received: by 2002:a05:6512:1698:b0:479:1e5e:1846 with SMTP id bu24-20020a056512169800b004791e5e1846mr46151lfb.669.1654245541276;
        Fri, 03 Jun 2022 01:39:01 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id g28-20020a2eb5dc000000b00253dfbe2522sm1169898ljn.100.2022.06.03.01.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 01:39:00 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH v2 2/3] can: kvaser_usb: kvaser_usb_leaf: Fix CAN clock frequency regression
Date:   Fri,  3 Jun 2022 10:38:19 +0200
Message-Id: <20220603083820.800246-3-extja@kvaser.com>
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

The firmware of M32C based Leaf devices expects bittiming parameters
calculated for 16MHz clock.
Since we use the actual clock frequency of the device, the device may end
up with wrong bittiming parameters, depending on user requested parameters.

This regression affects M32C based Leaf devices with non-16MHz clock.

Fixes: fb12797ab1fe ("can: kvaser_usb: get CAN clock frequency from device")
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
---
Changes in v2:
  - Remove quriks member in struct kvaser_usb_dev_card_data,
    and use quirks in struct kvaser_usb_driver_info instead.

 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   | 14 ++++++++---
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 20 ++++++++-------
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 25 ++++++++++++-------
 3 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index e3b7fce2cd89..383b7144d6b5 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -38,6 +38,7 @@
 /* Kvaser USB device quirks */
 #define KVASER_USB_QUIRK_HAS_SILENT_MODE	BIT(0)
 #define KVASER_USB_QUIRK_HAS_TXRX_ERRORS	BIT(1)
+#define KVASER_USB_QUIRK_IGNORE_CLK_FREQ	BIT(2)
 
 /* Device capabilities */
 #define KVASER_USB_CAP_BERR_CAP			0x01
@@ -199,21 +200,28 @@ static const struct kvaser_usb_driver_info kvaser_usb_driver_info_usbcan = {
 };
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf = {
-	.quirks = 0,
+	.quirks = KVASER_USB_QUIRK_IGNORE_CLK_FREQ,
 	.family = KVASER_LEAF,
 	.ops = &kvaser_usb_leaf_dev_ops,
 };
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf_err = {
-	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS,
+	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS |
+		  KVASER_USB_QUIRK_IGNORE_CLK_FREQ,
 	.family = KVASER_LEAF,
 	.ops = &kvaser_usb_leaf_dev_ops,
 };
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf_err_listen = {
 	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS |
-		  KVASER_USB_QUIRK_HAS_SILENT_MODE,
+		  KVASER_USB_QUIRK_HAS_SILENT_MODE |
+		  KVASER_USB_QUIRK_IGNORE_CLK_FREQ,
 	.family = KVASER_LEAF,
 	.ops = &kvaser_usb_leaf_dev_ops,
 };
+
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leafimx = {
+	.quirks = 0,
+	.ops = &kvaser_usb_leaf_dev_ops,
+};
 #endif /* KVASER_USB_H */
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index 4f0f8849b568..7e63e198b03a 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -89,7 +89,7 @@
 #define USB_HYBRID_PRO_CANLIN_PRODUCT_ID	278
 
 static const struct usb_device_id kvaser_usb_table[] = {
-	/* Leaf USB product IDs */
+	/* Leaf M32C USB product IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_DEVEL_PRODUCT_ID),
 		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_PRODUCT_ID),
@@ -130,22 +130,24 @@ static const struct usb_device_id kvaser_usb_table[] = {
 		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_CAN_R_PRODUCT_ID),
 		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
+
+	/* Leaf i.MX28 USB product IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_V2_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_HS_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_LIGHT_2HS_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_2HS_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_R_V2_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_R_V2_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM2_PRODUCT_ID),
-		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leafimx },
 
 	/* USBCANII USB product IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN2_PRODUCT_ID),
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index 5cf940ba3f7f..957144cee414 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -524,16 +524,23 @@ static void kvaser_usb_leaf_get_software_info_leaf(struct kvaser_usb *dev,
 	dev->fw_version = le32_to_cpu(softinfo->fw_version);
 	dev->max_tx_urbs = le16_to_cpu(softinfo->max_outstanding_tx);
 
-	switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
-	case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
+	if (dev->driver_info->quirks & KVASER_USB_QUIRK_IGNORE_CLK_FREQ) {
+		/* Firmware expects bittiming parameters calculated for 16MHz
+		 * clock, regardless of the actual clock
+		 */
 		dev->cfg = &kvaser_usb_leaf_dev_cfg_16mhz;
-		break;
-	case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_24mhz;
-		break;
-	case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
-		dev->cfg = &kvaser_usb_leaf_dev_cfg_32mhz;
-		break;
+	} else {
+		switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
+		case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
+			dev->cfg = &kvaser_usb_leaf_dev_cfg_16mhz;
+			break;
+		case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
+			dev->cfg = &kvaser_usb_leaf_dev_cfg_24mhz;
+			break;
+		case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
+			dev->cfg = &kvaser_usb_leaf_dev_cfg_32mhz;
+			break;
+		}
 	}
 }
 
-- 
2.36.1

