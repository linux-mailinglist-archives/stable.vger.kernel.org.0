Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C0F47CA41
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 01:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhLVA3v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 19:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbhLVA3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 19:29:51 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B962C061574
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 16:29:50 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id k37so1503782lfv.3
        for <stable@vger.kernel.org>; Tue, 21 Dec 2021 16:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RSwt6nc97ki98nU3MI3VkFKTuYbUI1gzNkM0vpTGI20=;
        b=kD7wDfyjQSoEnBmVAJiUgJDpoMUWebcCxJxNhQG5gSc95bZcp+05qhtvwyxhVRZKzS
         Jl74dA1K+GIVd+BY4UZ3JC7Mp47vbie2TrCwEU30Wm2f2KNHNSmZ12oUBTnF4DTssPnd
         8dPiux8/rna2C4W0nSHFEY0hfRk7MtOlbTlueMPIxXPKd+xLl4jh+ROsGn88KkGtnQdp
         G8haK1meRvkm3rTveU/Yvp4iGT8a16fihfmxJ8EhutmXz6KH6CJe6OFCapmshou/s/sS
         klv1RXg9M0JDWK3XX7EdfaRkHh54CPMI2e1Q3FjsXkzrHYoynIC3qlcRRCNIL2qJCdcC
         XWmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RSwt6nc97ki98nU3MI3VkFKTuYbUI1gzNkM0vpTGI20=;
        b=1mL8Y79ZQ+tsb5peXuztnjuhQYo7j757Ru9eHKnd6otlagYsksh7GBeVoyamyCkwg0
         zz31kXPsHfzGKMODaS0qrloYip4LzCylKVdnPBByDLgPBHDZDccH34XH0Bes7rBfbZw5
         vUHfs0BBvEpjwtw08wd31TB5ooLTGSN+RVxRG8NFo68Ir3Ekx6GgouLro4W/fsXxmJGb
         SKydPQAPoIslhfG8WT3hC1Vv98A5wwU8nw1A2fbQbEA3dcx4DLoTYZ2ix99XOf0bDsZO
         JkEVgWtJ2sA4Y5aJlRoGYZ6ylRNo3Nwq9c/rgEygbqUkQLpTauadiyPNWlftEJIm6Zs/
         48rw==
X-Gm-Message-State: AOAM531mWoNsxlaXDlXEIcuol20NxdUflWDFUL/siuKxMKWdcs2GUZY/
        FdLipvYWrYtBGsYzUi82Q62SCg==
X-Google-Smtp-Source: ABdhPJz7TeQaivsFrj9w0fYgDCZ4XJJFlxatfF7o5dW2ImkDg7O0QGntZw2nmgYZ80Umx/p9xYvWCQ==
X-Received: by 2002:a05:6512:2355:: with SMTP id p21mr592390lfu.640.1640132988753;
        Tue, 21 Dec 2021 16:29:48 -0800 (PST)
Received: from localhost (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with UTF8SMTPSA id bn30sm42635ljb.29.2021.12.21.16.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 16:29:48 -0800 (PST)
From:   Jimmy Assarsson <extja@kvaser.com>
To:     linux-can@vger.kernel.org, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>,
        Jimmy Assarsson <extja@kvaser.com>
Subject: [PATCH] can: kvaser_usb: get CAN clock frequency from device
Date:   Wed, 22 Dec 2021 01:28:27 +0100
Message-Id: <20211222002826.1398761-1-extja@kvaser.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit fb12797ab1fef480ad8a32a30984844444eeb00d upstream.

The CAN clock frequency is used when calculating the CAN bittiming
parameters. When wrong clock frequency is used, the device may end up
with wrong bittiming parameters, depending on user requested bittiming
parameters.

To avoid this, get the CAN clock frequency from the device. Various
existing Kvaser Leaf products use different CAN clocks.

Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
Link: https://lore.kernel.org/all/20211208152122.250852-2-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
[backport note: kvaser_usb was split into multiple files in 4.19]
---
 drivers/net/can/usb/kvaser_usb.c | 41 ++++++++++++++++++++++++++++----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
index 9991ee93735a..81abb30d9ec0 100644
--- a/drivers/net/can/usb/kvaser_usb.c
+++ b/drivers/net/can/usb/kvaser_usb.c
@@ -31,7 +31,10 @@
 #define USB_SEND_TIMEOUT		1000 /* msecs */
 #define USB_RECV_TIMEOUT		1000 /* msecs */
 #define RX_BUFFER_SIZE			3072
-#define CAN_USB_CLOCK			8000000
+#define KVASER_USB_CAN_CLOCK_8MHZ	8000000
+#define KVASER_USB_CAN_CLOCK_16MHZ	16000000
+#define KVASER_USB_CAN_CLOCK_24MHZ	24000000
+#define KVASER_USB_CAN_CLOCK_32MHZ	32000000
 #define MAX_NET_DEVICES			3
 #define MAX_USBCAN_NET_DEVICES		2
 
@@ -139,6 +142,12 @@ static inline bool kvaser_is_usbcan(const struct usb_device_id *id)
 #define CMD_LEAF_USB_THROTTLE		77
 #define CMD_LEAF_LOG_MESSAGE		106
 
+/* Leaf frequency options */
+#define KVASER_USB_LEAF_SWOPTION_FREQ_MASK 0x60
+#define KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK 0
+#define KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK BIT(5)
+#define KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK BIT(6)
+
 /* error factors */
 #define M16C_EF_ACKE			BIT(0)
 #define M16C_EF_CRCE			BIT(1)
@@ -469,6 +478,8 @@ struct kvaser_usb {
 	bool rxinitdone;
 	void *rxbuf[MAX_RX_URBS];
 	dma_addr_t rxbuf_dma[MAX_RX_URBS];
+
+	struct can_clock clock;
 };
 
 struct kvaser_usb_net_priv {
@@ -646,6 +657,27 @@ static int kvaser_usb_send_simple_msg(const struct kvaser_usb *dev,
 	return rc;
 }
 
+static void kvaser_usb_get_software_info_leaf(struct kvaser_usb *dev,
+					      const struct leaf_msg_softinfo *softinfo)
+{
+	u32 sw_options = le32_to_cpu(softinfo->sw_options);
+
+	dev->fw_version = le32_to_cpu(softinfo->fw_version);
+	dev->max_tx_urbs = le16_to_cpu(softinfo->max_outstanding_tx);
+
+	switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
+	case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
+		dev->clock.freq = KVASER_USB_CAN_CLOCK_16MHZ;
+		break;
+	case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
+		dev->clock.freq = KVASER_USB_CAN_CLOCK_24MHZ;
+		break;
+	case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
+		dev->clock.freq = KVASER_USB_CAN_CLOCK_32MHZ;
+		break;
+	}
+}
+
 static int kvaser_usb_get_software_info(struct kvaser_usb *dev)
 {
 	struct kvaser_msg msg;
@@ -661,14 +693,13 @@ static int kvaser_usb_get_software_info(struct kvaser_usb *dev)
 
 	switch (dev->family) {
 	case KVASER_LEAF:
-		dev->fw_version = le32_to_cpu(msg.u.leaf.softinfo.fw_version);
-		dev->max_tx_urbs =
-			le16_to_cpu(msg.u.leaf.softinfo.max_outstanding_tx);
+		kvaser_usb_get_software_info_leaf(dev, &msg.u.leaf.softinfo);
 		break;
 	case KVASER_USBCAN:
 		dev->fw_version = le32_to_cpu(msg.u.usbcan.softinfo.fw_version);
 		dev->max_tx_urbs =
 			le16_to_cpu(msg.u.usbcan.softinfo.max_outstanding_tx);
+		dev->clock.freq = KVASER_USB_CAN_CLOCK_8MHZ;
 		break;
 	}
 
@@ -1925,7 +1956,7 @@ static int kvaser_usb_init_one(struct usb_interface *intf,
 	kvaser_usb_reset_tx_urb_contexts(priv);
 
 	priv->can.state = CAN_STATE_STOPPED;
-	priv->can.clock.freq = CAN_USB_CLOCK;
+	priv->can.clock.freq = dev->clock.freq;
 	priv->can.bittiming_const = &kvaser_usb_bittiming_const;
 	priv->can.do_set_bittiming = kvaser_usb_set_bittiming;
 	priv->can.do_set_mode = kvaser_usb_set_mode;
-- 
2.31.1

