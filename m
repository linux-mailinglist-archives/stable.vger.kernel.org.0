Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE0356C1C4
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239693AbiGHSrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 14:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239695AbiGHSrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 14:47:19 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC308239B
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:47:17 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id z25so20139370lfr.2
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 11:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZgCtZcov20NqulCUHUKAHXDHkTjEVK1BEotR1UEfV0c=;
        b=deAFesEB39hskutveYI1kqvOOtqwMwONu7Gem7KWVe90zABq7A47LOLwIwwp6kx0T4
         aOG8aHJiuaA6x42nhqRkl6eiwZms3KIUcw63Ww40z9cTsBHGu5CKMArpdyOxlQ0uvjyq
         5YnkjLZgoHp8W6W5dudSRdv1H9Ykwh+qXvHgMwhZhvX66OLGc2wMZ0kqoINC7AnURlYS
         JPvzhzzw3RZKYyP68sT73TMLvpuvQpJ6c9wVEHdqrE5p6AQ46tJm8fOuvG0KSZwF1BQM
         tvdW3ZS/6i5nM48Ntz0Od7aLKKRP9p63FqHPiYPHqo03nLqehD/7yvU9JNV++EEI+P12
         WhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZgCtZcov20NqulCUHUKAHXDHkTjEVK1BEotR1UEfV0c=;
        b=wBqobVV/g3GjF7XjZdLclVpqM5s7COBs/5V9+lUm/5B7/LDKN46xChEMFjIA+Z0RhK
         1WLpi0nqwhbt8MINQMYWPste1Mz2oo14F7JA4VQC9DEDDbz0aqV5syAZHdVseUbGddbc
         05ti1T4klmj2H0f8lMiNnjzS8X5ysegaDRJ5/Iv93R8et3ohxEEVIblALaFjdPwvpMvn
         RKkB2svZXwuOSlmu8BoVk5F9SFL9/H1AUJJi1jjQrYTcv+HuSWbeTIflNMo/KEGrMvne
         MRoE86UjEnDP5G4+8rfqe9vdHHpqUfqpzOssqmkwXdm76PPzxic8fhJ10hQZyeI10H4i
         wHQg==
X-Gm-Message-State: AJIora8Fy/+9inU1Ihk5EKByyy4Nk/B8TWaoSrXLrdNCr7iynk9/Cgo0
        6ULqhCTLS4SXUJIw1ExmFbsrEGYlNDuclA==
X-Google-Smtp-Source: AGRyM1vAm25QMMO5SbGF8ktaSMQ+8itjTMwQwOlwMYEsRjbuABAR1qAg/TKUuNBM7XYglipgYH0yEQ==
X-Received: by 2002:a05:6512:3a91:b0:47f:8dd6:cd05 with SMTP id q17-20020a0565123a9100b0047f8dd6cd05mr3231148lfu.547.1657306035352;
        Fri, 08 Jul 2022 11:47:15 -0700 (PDT)
Received: from freke.kvaser.se (rota.kvaser.com. [195.22.86.90])
        by smtp.gmail.com with ESMTPSA id u22-20020a197916000000b0047fa941067fsm7558386lfc.29.2022.07.08.11.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 11:47:15 -0700 (PDT)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH 4.14 2/4] can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info
Date:   Fri,  8 Jul 2022 20:46:51 +0200
Message-Id: <20220708184653.280882-3-extja@kvaser.com>
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

commit 49f274c72357d2d74cba70b172cf369768909707 upstream.

Unify and move compile-time known information into new struct
kvaser_usb_driver_info, in favor of run-time checks.

All Kvaser USBcanII supports listen-only mode and error counter
reporting.

Link: https://lore.kernel.org/all/20220603083820.800246-2-extja@kvaser.com
Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
---
 drivers/net/can/usb/kvaser_usb.c | 175 ++++++++++++++++---------------
 1 file changed, 93 insertions(+), 82 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index 6759868924b2..7564194f4c87 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -62,27 +62,15 @@
 #define USB_USBCAN_LIGHT_2HS_PRODUCT_ID	291
 #define USB_MINI_PCIE_2HS_PRODUCT_ID	292
 
-static inline bool kvaser_is_leaf(const struct usb_device_id *id)
-{
-	return id->idProduct >= USB_LEAF_DEVEL_PRODUCT_ID &&
-	       id->idProduct <= USB_MINI_PCIE_2HS_PRODUCT_ID;
-}
-
 /* Kvaser USBCan-II devices */
 #define USB_USBCAN_REVB_PRODUCT_ID	2
 #define USB_VCI2_PRODUCT_ID		3
 #define USB_USBCAN2_PRODUCT_ID		4
 #define USB_MEMORATOR_PRODUCT_ID	5
 
-static inline bool kvaser_is_usbcan(const struct usb_device_id *id)
-{
-	return id->idProduct >= USB_USBCAN_REVB_PRODUCT_ID &&
-	       id->idProduct <= USB_MEMORATOR_PRODUCT_ID;
-}
-
-/* USB devices features */
-#define KVASER_HAS_SILENT_MODE		BIT(0)
-#define KVASER_HAS_TXRX_ERRORS		BIT(1)
+/* Kvaser USB device quirks */
+#define KVASER_USB_QUIRK_HAS_SILENT_MODE	BIT(0)
+#define KVASER_USB_QUIRK_HAS_TXRX_ERRORS	BIT(1)
 
 /* Message header size */
 #define MSG_HEADER_LEN			2
@@ -461,6 +449,7 @@ struct kvaser_usb_tx_urb_context {
 struct kvaser_usb {
 	struct usb_device *udev;
 	struct kvaser_usb_net_priv *nets[MAX_NET_DEVICES];
+	const struct kvaser_usb_driver_info *driver_info;
 	const struct kvaser_usb_dev_cfg *cfg;
 
 	struct usb_endpoint_descriptor *bulk_in, *bulk_out;
@@ -473,7 +462,6 @@ struct kvaser_usb {
 	u32 fw_version;
 	unsigned int nchannels;
 	unsigned int max_tx_urbs;
-	enum kvaser_usb_family family;
 
 	bool rxinitdone;
 	void *rxbuf[MAX_RX_URBS];
@@ -496,6 +484,11 @@ struct kvaser_usb_net_priv {
 	struct kvaser_usb_tx_urb_context tx_contexts[];
 };
 
+struct kvaser_usb_driver_info {
+	u32 quirks;
+	enum kvaser_usb_family family;
+};
+
 struct kvaser_usb_dev_cfg {
 	const struct can_clock clock;
 	const struct can_bittiming_const * const bittiming_const;
@@ -541,70 +534,90 @@ static const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_32mhz = {
 	.bittiming_const = &kvaser_usb_bittiming_const,
 };
 
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_usbcan = {
+	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS |
+		  KVASER_USB_QUIRK_HAS_SILENT_MODE,
+	.family = KVASER_USBCAN,
+};
+
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf = {
+	.quirks = 0,
+	.family = KVASER_LEAF,
+};
+
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf_err = {
+	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS,
+	.family = KVASER_LEAF,
+};
+
+static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leaf_err_listen = {
+	.quirks = KVASER_USB_QUIRK_HAS_TXRX_ERRORS |
+		  KVASER_USB_QUIRK_HAS_SILENT_MODE,
+	.family = KVASER_LEAF,
+};
+
 static const struct usb_device_id kvaser_usb_table[] = {
 	/* Leaf family IDs */
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_DEVEL_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_PRODUCT_ID) },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_DEVEL_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS |
-			       KVASER_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_SPRO_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS |
-			       KVASER_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_LS_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS |
-			       KVASER_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_SWC_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS |
-			       KVASER_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_LIN_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS |
-			       KVASER_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_SPRO_LS_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS |
-			       KVASER_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_SPRO_SWC_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS |
-			       KVASER_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO2_DEVEL_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS |
-			       KVASER_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO2_HSHS_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS |
-			       KVASER_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_UPRO_HSHS_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_GI_PRODUCT_ID) },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_GI_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_PRO_OBDII_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS |
-			       KVASER_HAS_SILENT_MODE },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err_listen },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMO2_HSLS_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_CH_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_BLACKBIRD_SPRO_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_OEM_MERCURY_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_OEM_LEAF_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_CAN_R_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_V2_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_HS_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_LIGHT_2HS_PRODUCT_ID) },
-	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_2HS_PRODUCT_ID) },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf_err },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LITE_V2_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_HS_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_LEAF_LIGHT_HS_V2_OEM_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_LIGHT_2HS_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
+	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MINI_PCIE_2HS_PRODUCT_ID),
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_leaf },
 
 	/* USBCANII family IDs */
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN2_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_usbcan },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_USBCAN_REVB_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_usbcan },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_MEMORATOR_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_usbcan },
 	{ USB_DEVICE(KVASER_VENDOR_ID, USB_VCI2_PRODUCT_ID),
-		.driver_info = KVASER_HAS_TXRX_ERRORS },
+		.driver_info = (kernel_ulong_t)&kvaser_usb_driver_info_usbcan },
 
 	{ }
 };
@@ -737,7 +750,7 @@ static int kvaser_usb_get_software_info(struct kvaser_usb *dev)
 	if (err)
 		return err;
 
-	switch (dev->family) {
+	switch (dev->driver_info->family) {
 	case KVASER_LEAF:
 		kvaser_usb_get_software_info_leaf(dev, &msg.u.leaf.softinfo);
 		break;
@@ -767,7 +780,7 @@ static int kvaser_usb_get_card_info(struct kvaser_usb *dev)
 
 	dev->nchannels = msg.u.cardinfo.nchannels;
 	if ((dev->nchannels > MAX_NET_DEVICES) ||
-	    (dev->family == KVASER_USBCAN &&
+	    (dev->driver_info->family == KVASER_USBCAN &&
 	     dev->nchannels > MAX_USBCAN_NET_DEVICES))
 		return -EINVAL;
 
@@ -938,7 +951,7 @@ static void kvaser_usb_rx_error_update_can_state(struct kvaser_usb_net_priv *pri
 		priv->can.can_stats.restarts++;
 	}
 
-	switch (dev->family) {
+	switch (dev->driver_info->family) {
 	case KVASER_LEAF:
 		if (es->leaf.error_factor) {
 			priv->can.can_stats.bus_error++;
@@ -1015,7 +1028,7 @@ static void kvaser_usb_rx_error(const struct kvaser_usb *dev,
 		}
 	}
 
-	switch (dev->family) {
+	switch (dev->driver_info->family) {
 	case KVASER_LEAF:
 		if (es->leaf.error_factor) {
 			cf->can_id |= CAN_ERR_BUSERROR | CAN_ERR_PROT;
@@ -1224,7 +1237,8 @@ static void kvaser_usb_rx_can_msg(const struct kvaser_usb *dev,
 	stats = &priv->netdev->stats;
 
 	if ((msg->u.rx_can_header.flag & MSG_FLAG_ERROR_FRAME) &&
-	    (dev->family == KVASER_LEAF && msg->id == CMD_LEAF_LOG_MESSAGE)) {
+	    (dev->driver_info->family == KVASER_LEAF &&
+	     msg->id == CMD_LEAF_LOG_MESSAGE)) {
 		kvaser_leaf_rx_error(dev, msg);
 		return;
 	} else if (msg->u.rx_can_header.flag & (MSG_FLAG_ERROR_FRAME |
@@ -1239,7 +1253,7 @@ static void kvaser_usb_rx_can_msg(const struct kvaser_usb *dev,
 		return;
 	}
 
-	switch (dev->family) {
+	switch (dev->driver_info->family) {
 	case KVASER_LEAF:
 		rx_msg = msg->u.leaf.rx_can.msg;
 		break;
@@ -1254,7 +1268,8 @@ static void kvaser_usb_rx_can_msg(const struct kvaser_usb *dev,
 		return;
 	}
 
-	if (dev->family == KVASER_LEAF && msg->id == CMD_LEAF_LOG_MESSAGE) {
+	if (dev->driver_info->family == KVASER_LEAF && msg->id ==
+	    CMD_LEAF_LOG_MESSAGE) {
 		cf->can_id = le32_to_cpu(msg->u.leaf.log_message.id);
 		if (cf->can_id & KVASER_EXTENDED_FRAME)
 			cf->can_id &= CAN_EFF_MASK | CAN_EFF_FLAG;
@@ -1351,14 +1366,14 @@ static void kvaser_usb_handle_message(const struct kvaser_usb *dev,
 		break;
 
 	case CMD_LEAF_LOG_MESSAGE:
-		if (dev->family != KVASER_LEAF)
+		if (dev->driver_info->family != KVASER_LEAF)
 			goto warn;
 		kvaser_usb_rx_can_msg(dev, msg);
 		break;
 
 	case CMD_CHIP_STATE_EVENT:
 	case CMD_CAN_ERROR_EVENT:
-		if (dev->family == KVASER_LEAF)
+		if (dev->driver_info->family == KVASER_LEAF)
 			kvaser_leaf_rx_error(dev, msg);
 		else
 			kvaser_usbcan_rx_error(dev, msg);
@@ -1370,12 +1385,12 @@ static void kvaser_usb_handle_message(const struct kvaser_usb *dev,
 
 	/* Ignored messages */
 	case CMD_USBCAN_CLOCK_OVERFLOW_EVENT:
-		if (dev->family != KVASER_USBCAN)
+		if (dev->driver_info->family != KVASER_USBCAN)
 			goto warn;
 		break;
 
 	case CMD_FLUSH_QUEUE_REPLY:
-		if (dev->family != KVASER_LEAF)
+		if (dev->driver_info->family != KVASER_LEAF)
 			goto warn;
 		break;
 
@@ -1764,7 +1779,7 @@ static netdev_tx_t kvaser_usb_start_xmit(struct sk_buff *skb,
 	msg->len = MSG_HEADER_LEN + sizeof(struct kvaser_msg_tx_can);
 	msg->u.tx_can.channel = priv->channel;
 
-	switch (dev->family) {
+	switch (dev->driver_info->family) {
 	case KVASER_LEAF:
 		msg_tx_can_flags = &msg->u.tx_can.leaf.flags;
 		break;
@@ -1951,12 +1966,12 @@ static void kvaser_usb_remove_interfaces(struct kvaser_usb *dev)
 	}
 }
 
-static int kvaser_usb_init_one(struct usb_interface *intf,
-			       const struct usb_device_id *id, int channel)
+static int kvaser_usb_init_one(struct usb_interface *intf, int channel)
 {
 	struct kvaser_usb *dev = usb_get_intfdata(intf);
 	struct net_device *netdev;
 	struct kvaser_usb_net_priv *priv;
+	const struct kvaser_usb_driver_info *driver_info = dev->driver_info;
 	int err;
 
 	err = kvaser_usb_send_simple_msg(dev, CMD_RESET_CHIP, channel);
@@ -1989,10 +2004,10 @@ static int kvaser_usb_init_one(struct usb_interface *intf,
 	priv->can.bittiming_const = dev->cfg->bittiming_const;
 	priv->can.do_set_bittiming = kvaser_usb_set_bittiming;
 	priv->can.do_set_mode = kvaser_usb_set_mode;
-	if (id->driver_info & KVASER_HAS_TXRX_ERRORS)
+	if (driver_info->quirks & KVASER_USB_QUIRK_HAS_TXRX_ERRORS)
 		priv->can.do_get_berr_counter = kvaser_usb_get_berr_counter;
 	priv->can.ctrlmode_supported = CAN_CTRLMODE_3_SAMPLES;
-	if (id->driver_info & KVASER_HAS_SILENT_MODE)
+	if (driver_info->quirks & KVASER_USB_QUIRK_HAS_SILENT_MODE)
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_LISTENONLY;
 
 	netdev->flags |= IFF_ECHO;
@@ -2050,21 +2065,17 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 	struct kvaser_usb *dev;
 	int err = -ENOMEM;
 	int i, retry = 3;
+	const struct kvaser_usb_driver_info *driver_info;
+
+	driver_info = (const struct kvaser_usb_driver_info *)id->driver_info;
+	if (!driver_info)
+		return -ENODEV;
 
 	dev = devm_kzalloc(&intf->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
 		return -ENOMEM;
 
-	if (kvaser_is_leaf(id)) {
-		dev->family = KVASER_LEAF;
-	} else if (kvaser_is_usbcan(id)) {
-		dev->family = KVASER_USBCAN;
-	} else {
-		dev_err(&intf->dev,
-			"Product ID (%d) does not belong to any known Kvaser USB family",
-			id->idProduct);
-		return -ENODEV;
-	}
+	dev->driver_info = driver_info;
 
 	err = kvaser_usb_get_endpoints(intf, &dev->bulk_in, &dev->bulk_out);
 	if (err) {
@@ -2108,7 +2119,7 @@ static int kvaser_usb_probe(struct usb_interface *intf,
 	}
 
 	for (i = 0; i < dev->nchannels; i++) {
-		err = kvaser_usb_init_one(intf, id, i);
+		err = kvaser_usb_init_one(intf, i);
 		if (err) {
 			kvaser_usb_remove_interfaces(dev);
 			return err;
-- 
2.36.1

