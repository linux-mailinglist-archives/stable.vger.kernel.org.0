Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC8053B384
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 08:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiFBG0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 02:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiFBG0q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 02:26:46 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E806156448
        for <stable@vger.kernel.org>; Wed,  1 Jun 2022 23:26:45 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id s6so6224007lfo.13
        for <stable@vger.kernel.org>; Wed, 01 Jun 2022 23:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vx44E2oNIOZA/XKGla9wfxRtqAjvs0UAprqCzA4Z4jY=;
        b=TddMfYC8dxntOr7LPLDcHl83/930FP1mtfpjLp/b7D85IjMAmPUisD5Vc8Vg4LlFKy
         E1ItmFtAZiQgnfnHcZJutlX+lEpb31zCdhx8WniyEUylU3aZeeWtH6F1D42625nYsqm1
         8O4KM7oSPmiytUfK9u8U1p8309YTIgHQBi0gyOb2VG5lVEPO9Yya5wMXMm6RV1SUp0K8
         uiS1hJtXsXVNdDppzPwdwNyi1aktTBoDmYRVZAh3RaYsuAlqI4KZ5Kf2ACCSX+44z4yd
         SmkIRp7cYzmCDpFPLdL/9UIWyWdHF7A3PBOAtyoD4CpHdT0ZE9A08S/nzxUgTfXZAanA
         23Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vx44E2oNIOZA/XKGla9wfxRtqAjvs0UAprqCzA4Z4jY=;
        b=6yhOOo5iEvKqvbZxHS0M1Q/3GRptGaJeL7LeLZuTvi+U577KglGmHpgIVYofpJ1A7N
         un2KgsL18bhZGSUIdD+efsRutAjTNB7DXDoaidIWHKKSvcM3acRizKxSKghPuttGXKxT
         ZUm0slC60h1BOX3Cz7wV2IQi7SNLRJcSsfSD9PNaMC4n8z8CxHwWYedKy7l3iqXUIb0b
         3cw3mbcvc6zW7CqXmVDW3JQM5FRx2zxAIEkWjxkMn27tHVLmGH9vmjrHPGI3f9NzCK1m
         c+3jhtNO4/q+ksZ51YZPniBw8JPgKFoxTM/zXugzGOmSqiMmz458BFtA45AhdwrQMGld
         +aRw==
X-Gm-Message-State: AOAM532i+Hzcp0G7ZtVZTGMU2gtyCd7qMeiRfeK4kZkXzL/o65sjyd4Z
        8ptlwbSnV/HE04YRMlVUuJxJMF7BpXQl8zaD
X-Google-Smtp-Source: ABdhPJwRNzLfxbcoZ9Lqt7cLMwHCM35Rv+HW9rbiE12Y0w/EwofCdyfyF58S0+n8K0KK4ZJsxj7gtQ==
X-Received: by 2002:a05:6512:1508:b0:478:e689:ba9f with SMTP id bq8-20020a056512150800b00478e689ba9fmr2414340lfb.51.1654151203381;
        Wed, 01 Jun 2022 23:26:43 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id y9-20020a2e4b09000000b002553ab60e17sm675381lja.122.2022.06.01.23.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 23:26:42 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     jimmyassarsson@hotmail.com
Cc:     Jimmy Assarsson <extja@kvaser.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] can: kvaser_usb: kvaser_usb_leaf: Fix CAN clock frequency regression
Date:   Thu,  2 Jun 2022 08:26:19 +0200
Message-Id: <20220602062620.414733-2-extja@kvaser.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220602062620.414733-1-extja@kvaser.com>
References: <20220602062620.414733-1-extja@kvaser.com>
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
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  4 +++
 .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 20 +++++++++++----
 .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 25 ++++++++++++-------
 3 files changed, 35 insertions(+), 14 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
index 3a49257f9fa6..cb588228d7a1 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -44,6 +44,9 @@
 #define KVASER_USB_CAP_EXT_CAP			0x02
 #define KVASER_USB_HYDRA_CAP_EXT_CMD		0x04
 
+/* Quriks */
+#define KVASER_USB_QUIRK_IGNORE_CLK_FREQ BIT(0)
+
 struct kvaser_usb_dev_cfg;
 
 enum kvaser_usb_leaf_family {
@@ -65,6 +68,7 @@ struct kvaser_usb_dev_card_data_hydra {
 struct kvaser_usb_dev_card_data {
 	u32 ctrlmode_supported;
 	u32 capabilities;
+	u32 quirks;
 	union {
 		struct {
 			enum kvaser_usb_leaf_family family;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
index e67658b53d02..5880e9719c9d 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -94,10 +94,14 @@
 
 static inline bool kvaser_is_leaf(const struct usb_device_id *id)
 {
-	return (id->idProduct >= USB_LEAF_DEVEL_PRODUCT_ID &&
-		id->idProduct <= USB_CAN_R_PRODUCT_ID) ||
-		(id->idProduct >= USB_LEAF_LITE_V2_PRODUCT_ID &&
-		 id->idProduct <= USB_LEAF_PRODUCT_ID_END);
+	return id->idProduct >= USB_LEAF_DEVEL_PRODUCT_ID &&
+	       id->idProduct <= USB_CAN_R_PRODUCT_ID;
+}
+
+static inline bool kvaser_is_leafimx(const struct usb_device_id *id)
+{
+	return id->idProduct >= USB_LEAF_LITE_V2_PRODUCT_ID &&
+	       id->idProduct <= USB_LEAF_PRODUCT_ID_END;
 }
 
 static inline bool kvaser_is_usbcan(const struct usb_device_id *id)
@@ -113,7 +117,7 @@ static inline bool kvaser_is_hydra(const struct usb_device_id *id)
 }
 
 static const struct usb_device_id kvaser_usb_table[] = {
-	/* Leaf USB product IDs */
+	/* Leaf M32C USB product IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_DEVEL_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_PRODUCT_ID),
@@ -161,6 +165,8 @@ static const struct usb_device_id kvaser_usb_table[] = {
 		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_CAN_R_PRODUCT_ID),
 		.driver_info = KVASER_USB_HAS_TXRX_ERRORS },
+
+	/* Leaf i.MX28 USB product IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_V2_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_HS_PRODUCT_ID) },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM_PRODUCT_ID) },
@@ -737,6 +743,10 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 	if (kvaser_is_leaf(id)) {
 		dev->card_data.leaf.family = KVASER_LEAF;
 		dev->ops = &kvaser_usb_leaf_dev_ops;
+		dev->card_data.quirks = KVASER_USB_QUIRK_IGNORE_CLK_FREQ;
+	} else if (kvaser_is_leafimx(id)) {
+		dev->card_data.leaf.family = KVASER_LEAF;
+		dev->ops = &kvaser_usb_leaf_dev_ops;
 	} else if (kvaser_is_usbcan(id)) {
 		dev->card_data.leaf.family = KVASER_USBCAN;
 		dev->ops = &kvaser_usb_leaf_dev_ops;
diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
index c805b999c543..68c698e3b2b2 100644
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -524,16 +524,23 @@ static void kvaser_usb_leaf_get_software_info_leaf(struct kvaser_usb *dev,
 	dev->fw_version = le32_to_cpu(softinfo->fw_version);
 	dev->max_tx_urbs = le16_to_cpu(softinfo->max_outstanding_tx);
 
-	switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
-	case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
+	if (dev->card_data.quirks & KVASER_USB_QUIRK_IGNORE_CLK_FREQ) {
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

