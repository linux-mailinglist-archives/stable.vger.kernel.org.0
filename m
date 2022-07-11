Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24FAF56FB06
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbiGKJZI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbiGKJY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:24:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCB731DD6;
        Mon, 11 Jul 2022 02:14:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96861610A5;
        Mon, 11 Jul 2022 09:14:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45ECC34115;
        Mon, 11 Jul 2022 09:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530862;
        bh=KjuQQVvvy/2MK2aBnoVMiXW2330YgfuGXKz1Nwiq64s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBlbHq4VoDRETbg/2/NHwlewakwAC+by4QELuqAUCQnUYu0BO0+iguLigSI2RrxtH
         IPC7x+GI9dfmYEeyemaG2wqH5bgX+8JpcBt2hf+YcvJ+sXzG/XNkcL60kp8Fk2zzCF
         KhBIfQaFBYsWgHFeUKoUcTv3LEgEEz3Mmt/cErL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jimmy Assarsson <extja@kvaser.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.18 011/112] can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression
Date:   Mon, 11 Jul 2022 11:06:11 +0200
Message-Id: <20220711090549.878870010@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
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

commit e6c80e601053ffdac5709f11ff3ec1e19ed05f7b upstream.

The firmware of M32C based Leaf devices expects bittiming parameters
calculated for 16MHz clock. Since we use the actual clock frequency of
the device, the device may end up with wrong bittiming parameters,
depending on user requested parameters.

This regression affects M32C based Leaf devices with non-16MHz clock.

Fixes: fb12797ab1fe ("can: kvaser_usb: get CAN clock frequency from device")
Link: https://lore.kernel.org/all/20220603083820.800246-3-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h      |    1 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |   33 ++++++++++++++---------
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c |   25 +++++++++++------
 3 files changed, 38 insertions(+), 21 deletions(-)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
@@ -38,6 +38,7 @@
 /* Kvaser USB device quirks */
 #define KVASER_USB_QUIRK_HAS_SILENT_MODE	BIT(0)
 #define KVASER_USB_QUIRK_HAS_TXRX_ERRORS	BIT(1)
+#define KVASER_USB_QUIRK_IGNORE_CLK_FREQ	BIT(2)
 
 /* Device capabilities */
 #define KVASER_USB_CAP_BERR_CAP			0x01
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -101,26 +101,33 @@ static const struct kvaser_usb_driver_in
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
 
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leafimx = {
+	.quirks = 0,
+	.ops = &kvaser_usb_leaf_dev_ops,
+};
+
 static const struct usb_device_id kvaser_usb_table[] = {
-	/* Leaf USB product IDs */
+	/* Leaf M32C USB product IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_DEVEL_PRODUCT_ID),
 		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_PRODUCT_ID),
@@ -161,22 +168,24 @@ static const struct usb_device_id kvaser
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
--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c
@@ -524,16 +524,23 @@ static void kvaser_usb_leaf_get_software
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
 


