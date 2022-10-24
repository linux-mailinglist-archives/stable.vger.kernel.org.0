Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E624960B061
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbiJXQFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbiJXQES (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:04:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156D31C93C;
        Mon, 24 Oct 2022 07:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64A2AB81202;
        Mon, 24 Oct 2022 12:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B82B1C433B5;
        Mon, 24 Oct 2022 12:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614258;
        bh=NRSfbYdbXRVMYB9NY6/edprAupDWT9LhGIIB9kC9TEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FMTi2A0pNtDg8N7GHr5SgVOvPv7zk9jA9kCh3mTMs5vbihZOUtQLkuzz9lISXQ0lV
         mWIYk7fzUcOrncfGo1U0evmaAJzAVFep440cY6+Shh6CmTgDnlM7MpBnt7DJ2u2jX6
         XIhAUvMmCRmBQcyl+dxkYgdemQIpKst87BK0FMZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/390] usb: common: add function to get interval expressed in us unit
Date:   Mon, 24 Oct 2022 13:29:50 +0200
Message-Id: <20221024113030.992402303@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit fb95c7cf5600b7b74412f27dfb39a1e13fd8a90d ]

Add a new function to convert bInterval into the time expressed
in 1us unit.

Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/25c8a09b055f716c1e5bf11fea72c3418f844482.1615170625.git.chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b6155eaf6b05 ("usb: common: debug: Check non-standard control requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/common/common.c | 41 +++++++++++++++++++++++++++++++++++++
 drivers/usb/core/devices.c  | 21 ++++---------------
 drivers/usb/core/endpoint.c | 35 ++++---------------------------
 include/linux/usb/ch9.h     |  3 +++
 4 files changed, 52 insertions(+), 48 deletions(-)

diff --git a/drivers/usb/common/common.c b/drivers/usb/common/common.c
index fc21cf2d36f6..675e8a4e683a 100644
--- a/drivers/usb/common/common.c
+++ b/drivers/usb/common/common.c
@@ -165,6 +165,47 @@ enum usb_dr_mode usb_get_dr_mode(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(usb_get_dr_mode);
 
+/**
+ * usb_decode_interval - Decode bInterval into the time expressed in 1us unit
+ * @epd: The descriptor of the endpoint
+ * @speed: The speed that the endpoint works as
+ *
+ * Function returns the interval expressed in 1us unit for servicing
+ * endpoint for data transfers.
+ */
+unsigned int usb_decode_interval(const struct usb_endpoint_descriptor *epd,
+				 enum usb_device_speed speed)
+{
+	unsigned int interval = 0;
+
+	switch (usb_endpoint_type(epd)) {
+	case USB_ENDPOINT_XFER_CONTROL:
+		/* uframes per NAK */
+		if (speed == USB_SPEED_HIGH)
+			interval = epd->bInterval;
+		break;
+	case USB_ENDPOINT_XFER_ISOC:
+		interval = 1 << (epd->bInterval - 1);
+		break;
+	case USB_ENDPOINT_XFER_BULK:
+		/* uframes per NAK */
+		if (speed == USB_SPEED_HIGH && usb_endpoint_dir_out(epd))
+			interval = epd->bInterval;
+		break;
+	case USB_ENDPOINT_XFER_INT:
+		if (speed >= USB_SPEED_HIGH)
+			interval = 1 << (epd->bInterval - 1);
+		else
+			interval = epd->bInterval;
+		break;
+	}
+
+	interval *= (speed >= USB_SPEED_HIGH) ? 125 : 1000;
+
+	return interval;
+}
+EXPORT_SYMBOL_GPL(usb_decode_interval);
+
 #ifdef CONFIG_OF
 /**
  * of_usb_get_dr_mode_by_phy - Get dual role mode for the controller device
diff --git a/drivers/usb/core/devices.c b/drivers/usb/core/devices.c
index 1ef2de6e375a..d8b0041de612 100644
--- a/drivers/usb/core/devices.c
+++ b/drivers/usb/core/devices.c
@@ -157,38 +157,25 @@ static char *usb_dump_endpoint_descriptor(int speed, char *start, char *end,
 	switch (usb_endpoint_type(desc)) {
 	case USB_ENDPOINT_XFER_CONTROL:
 		type = "Ctrl";
-		if (speed == USB_SPEED_HIGH)	/* uframes per NAK */
-			interval = desc->bInterval;
-		else
-			interval = 0;
 		dir = 'B';			/* ctrl is bidirectional */
 		break;
 	case USB_ENDPOINT_XFER_ISOC:
 		type = "Isoc";
-		interval = 1 << (desc->bInterval - 1);
 		break;
 	case USB_ENDPOINT_XFER_BULK:
 		type = "Bulk";
-		if (speed == USB_SPEED_HIGH && dir == 'O') /* uframes per NAK */
-			interval = desc->bInterval;
-		else
-			interval = 0;
 		break;
 	case USB_ENDPOINT_XFER_INT:
 		type = "Int.";
-		if (speed == USB_SPEED_HIGH || speed >= USB_SPEED_SUPER)
-			interval = 1 << (desc->bInterval - 1);
-		else
-			interval = desc->bInterval;
 		break;
 	default:	/* "can't happen" */
 		return start;
 	}
-	interval *= (speed == USB_SPEED_HIGH ||
-		     speed >= USB_SPEED_SUPER) ? 125 : 1000;
-	if (interval % 1000)
+
+	interval = usb_decode_interval(desc, speed);
+	if (interval % 1000) {
 		unit = 'u';
-	else {
+	} else {
 		unit = 'm';
 		interval /= 1000;
 	}
diff --git a/drivers/usb/core/endpoint.c b/drivers/usb/core/endpoint.c
index 1c2c04079676..fc3341f2bb61 100644
--- a/drivers/usb/core/endpoint.c
+++ b/drivers/usb/core/endpoint.c
@@ -84,40 +84,13 @@ static ssize_t interval_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
 	struct ep_device *ep = to_ep_device(dev);
+	unsigned int interval;
 	char unit;
-	unsigned interval = 0;
-	unsigned in;
 
-	in = (ep->desc->bEndpointAddress & USB_DIR_IN);
-
-	switch (usb_endpoint_type(ep->desc)) {
-	case USB_ENDPOINT_XFER_CONTROL:
-		if (ep->udev->speed == USB_SPEED_HIGH)
-			/* uframes per NAK */
-			interval = ep->desc->bInterval;
-		break;
-
-	case USB_ENDPOINT_XFER_ISOC:
-		interval = 1 << (ep->desc->bInterval - 1);
-		break;
-
-	case USB_ENDPOINT_XFER_BULK:
-		if (ep->udev->speed == USB_SPEED_HIGH && !in)
-			/* uframes per NAK */
-			interval = ep->desc->bInterval;
-		break;
-
-	case USB_ENDPOINT_XFER_INT:
-		if (ep->udev->speed == USB_SPEED_HIGH)
-			interval = 1 << (ep->desc->bInterval - 1);
-		else
-			interval = ep->desc->bInterval;
-		break;
-	}
-	interval *= (ep->udev->speed == USB_SPEED_HIGH) ? 125 : 1000;
-	if (interval % 1000)
+	interval = usb_decode_interval(ep->desc, ep->udev->speed);
+	if (interval % 1000) {
 		unit = 'u';
-	else {
+	} else {
 		unit = 'm';
 		interval /= 1000;
 	}
diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
index abdd310c77f0..74debc824645 100644
--- a/include/linux/usb/ch9.h
+++ b/include/linux/usb/ch9.h
@@ -90,6 +90,9 @@ extern enum usb_ssp_rate usb_get_maximum_ssp_rate(struct device *dev);
  */
 extern const char *usb_state_string(enum usb_device_state state);
 
+unsigned int usb_decode_interval(const struct usb_endpoint_descriptor *epd,
+				 enum usb_device_speed speed);
+
 #ifdef CONFIG_TRACING
 /**
  * usb_decode_ctrl - Returns human readable representation of control request.
-- 
2.35.1



