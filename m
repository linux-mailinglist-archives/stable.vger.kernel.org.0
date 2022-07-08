Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8409D56C1DC
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239667AbiGHSqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 14:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239671AbiGHSql (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 14:46:41 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716F97E023
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:46:39 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id i18so37697950lfu.8
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 11:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jSDNmPMzfOAVuOLcm9qgdJC+0xCoXkv30Rfa4q0BqJ8=;
        b=rIIm/1wXJo1UXowC1idD847QTANGXHu3lA6fr+0IasMSprY/ETno8fMjtEQAZ1Uckm
         00bKz2koP1TuRARGP+JhvqkyJE4LpP2UggwcG0fDDd6pGudVeEQH1IhdSq9i6n97CXop
         0micNGUVgwyCrCo0mrJy5ahbtcP0M4CvylVBVcmWdh1OufDA84EElQAAXnXysg+JmLg2
         S1W0sCtxkHvfl8gdoMgjOMk91lyYBXyqHkYbDoy78hbpc12bD/6c7St8J86QmR1fY/r1
         3K0L14ybNXHqP+oVsEbdg1nMirfX9/NFAWd7DMl1mMsoDMUMsCkfJgLIgeGmE+iPwUZS
         JP8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jSDNmPMzfOAVuOLcm9qgdJC+0xCoXkv30Rfa4q0BqJ8=;
        b=01w9Uuon0fhHsI6RHJLgnUJwGhf/zJMiMy6qYIctZsfplYakeoTJAhBAbuUxPSY1Cc
         jC+nhhkJQw9tFMP34jFKWMrGWr0ARkCIpuzGc/vFcGEuIW3GCf7y5Yg2TTxWHT5aj3Iz
         MW9RrZtsWBYLGwlBw7fqk9CUDpu0KFW785mQz26ROuMWkb9l3VpQprSKrGqM8201TAXg
         XbaW/J3vFZshEPCBALjjV1kUTFyLKlE1WHRiwJbBXT/3o+oSAQ2It9QTdYn7p4bDkJmn
         +jnl3Q8kxabytJoFbxaiccERcPmTjgI7ZvI00PzfCxO/f7TAUM5aHNCh4SOJCOMBqt+N
         O3GQ==
X-Gm-Message-State: AJIora9w5iNsE6j74xvWeYIhQK7c/rQ3FZIV8fMzq4Hj6usxtbbCCEB+
        33zjAewHyHpgqcDkxKbghFHcso1mGoecFQ==
X-Google-Smtp-Source: AGRyM1vO+HvieAlLQoG0Mmn2U94uwkix2QvbnGkLjpCjKED//eYH8u+RheGM440O2D2hyKi1yH0u/w==
X-Received: by 2002:a05:6512:3b8f:b0:489:c6c9:f522 with SMTP id g15-20020a0565123b8f00b00489c6c9f522mr1349975lfv.244.1657305997815;
        Fri, 08 Jul 2022 11:46:37 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id 23-20020a2e1557000000b0025d4d4b4edbsm1159917ljv.34.2022.07.08.11.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 11:46:37 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH 4.9 3/4] can: kvaser_usb: fix CAN clock frequency regression
Date:   Fri,  8 Jul 2022 20:45:55 +0200
Message-Id: <20220708184556.280751-4-extja@kvaser.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220708184556.280751-1-extja@kvaser.com>
References: <20220708184556.280751-1-extja@kvaser.com>
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

commit e6c80e601053ffdac5709f11ff3ec1e19ed05f7b upstream.

The firmware of M32C based Leaf devices expects bittiming parameters
calculated for 16MHz clock. Since we use the actual clock frequency of
the device, the device may end up with wrong bittiming parameters,
depending on user requested parameters.

This regression affects M32C based Leaf devices with non-16MHz clock.

Fixes: 2e663a0776ed ("can: kvaser_usb: get CAN clock frequency from device")
Link: https://lore.kernel.org/all/20220603083820.800246-3-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/kvaser_usb.c | 53 +++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 18 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index af60789e68db..95fa50927bfe 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -71,6 +71,7 @@
 /* Kvaser USB device quirks */
 #define KVASER_USB_QUIRK_HAS_SILENT_MODE	BIT(0)
 #define KVASER_USB_QUIRK_HAS_TXRX_ERRORS	BIT(1)
+#define KVASER_USB_QUIRK_IGNORE_CLK_FREQ	BIT(2)
 
 /* Message header size */
 #define MSG_HEADER_LEN			2
@@ -541,23 +542,30 @@ static const struct kvaser_usb_driver_info kvaser_usb_driver_info_usbcan = {
 };
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf = {
-	.quirks = 0,
+	.quirks = KVASER_USB_QUIRK_IGNORE_CLK_FREQ,
 	.family = KVASER_LEAF,
 };
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf_err = {
-	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS,
+	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS |
+		  KVASER_USB_QUIRK_IGNORE_CLK_FREQ,
 	.family = KVASER_LEAF,
 };
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf_err_listen = {
 	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS |
-		  KVASER_USB_QUIRK_HAS_SILENT_MODE,
+		  KVASER_USB_QUIRK_HAS_SILENT_MODE |
+		  KVASER_USB_QUIRK_IGNORE_CLK_FREQ,
+	.family = KVASER_LEAF,
+};
+
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leafimx = {
+	.quirks = 0,
 	.family = KVASER_LEAF,
 };
 
 static const struct usb_device_id kvaser_usb_table[] = {
-	/* Leaf family IDs */
+	/* Leaf M32C USB product IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_DEVEL_PRODUCT_ID),
 		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_PRODUCT_ID),
@@ -598,16 +606,18 @@ static const struct usb_device_id kvaser_usb_table[] = {
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
 
 	/* USBCANII family IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN2_PRODUCT_ID),
@@ -724,16 +734,23 @@ static void kvaser_usb_get_software_info_leaf(struct kvaser_usb *dev,
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

