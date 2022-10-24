Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3402960A90C
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235673AbiJXNPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235956AbiJXNOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:14:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28ED44D25C;
        Mon, 24 Oct 2022 05:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52ED161014;
        Mon, 24 Oct 2022 12:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63928C433D6;
        Mon, 24 Oct 2022 12:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614260;
        bh=G7yQmlG15qLGRBXl5CbjEbT4FRrYyB5hzuKiF+8nL4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6iPPK0x5pYjn6MoYJhrXmQGRxYPHeZmQNtRJ5yB4c66Gy/lAcpE9fZ4YXQCA2+V5
         Zy+6ZI6rHkzrGOzW3g3xHnchdk4WxHUzcNv8Ep/UKIi+tass9IXn+RNBclvKJQZoZH
         7UoPt8KbD1Q3L0lsBlEN/je9Rt6YS0BuEBKyji1c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/390] usb: common: move functions kerneldoc next to its definition
Date:   Mon, 24 Oct 2022 13:29:51 +0200
Message-Id: <20221024113031.042222617@linuxfoundation.org>
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

[ Upstream commit 365038f24b3e9d2b7c9e499f03f432040e28a35c ]

Following a general rule, add the kerneldoc for a function next
to it's definition, but not next to its declaration in a header
file.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/c4d2e010ae2bf67cdfa0b55e6d1deb9339d9d3dc.1615170625.git.chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b6155eaf6b05 ("usb: common: debug: Check non-standard control requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/common/common.c | 35 +++++++++++++++++++++
 drivers/usb/common/debug.c  | 22 +++++++++++--
 include/linux/usb/ch9.h     | 61 -------------------------------------
 3 files changed, 55 insertions(+), 63 deletions(-)

diff --git a/drivers/usb/common/common.c b/drivers/usb/common/common.c
index 675e8a4e683a..347fb3d3894a 100644
--- a/drivers/usb/common/common.c
+++ b/drivers/usb/common/common.c
@@ -25,6 +25,12 @@ static const char *const ep_type_names[] = {
 	[USB_ENDPOINT_XFER_INT] = "intr",
 };
 
+/**
+ * usb_ep_type_string() - Returns human readable-name of the endpoint type.
+ * @ep_type: The endpoint type to return human-readable name for.  If it's not
+ *   any of the types: USB_ENDPOINT_XFER_{CONTROL, ISOC, BULK, INT},
+ *   usually got by usb_endpoint_type(), the string 'unknown' will be returned.
+ */
 const char *usb_ep_type_string(int ep_type)
 {
 	if (ep_type < 0 || ep_type >= ARRAY_SIZE(ep_type_names))
@@ -76,6 +82,12 @@ static const char *const ssp_rate[] = {
 	[USB_SSP_GEN_2x2] = "super-speed-plus-gen2x2",
 };
 
+/**
+ * usb_speed_string() - Returns human readable-name of the speed.
+ * @speed: The speed to return human-readable name for.  If it's not
+ *   any of the speeds defined in usb_device_speed enum, string for
+ *   USB_SPEED_UNKNOWN will be returned.
+ */
 const char *usb_speed_string(enum usb_device_speed speed)
 {
 	if (speed < 0 || speed >= ARRAY_SIZE(speed_names))
@@ -84,6 +96,14 @@ const char *usb_speed_string(enum usb_device_speed speed)
 }
 EXPORT_SYMBOL_GPL(usb_speed_string);
 
+/**
+ * usb_get_maximum_speed - Get maximum requested speed for a given USB
+ * controller.
+ * @dev: Pointer to the given USB controller device
+ *
+ * The function gets the maximum speed string from property "maximum-speed",
+ * and returns the corresponding enum usb_device_speed.
+ */
 enum usb_device_speed usb_get_maximum_speed(struct device *dev)
 {
 	const char *maximum_speed;
@@ -102,6 +122,15 @@ enum usb_device_speed usb_get_maximum_speed(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(usb_get_maximum_speed);
 
+/**
+ * usb_get_maximum_ssp_rate - Get the signaling rate generation and lane count
+ *	of a SuperSpeed Plus capable device.
+ * @dev: Pointer to the given USB controller device
+ *
+ * If the string from "maximum-speed" property is super-speed-plus-genXxY where
+ * 'X' is the generation number and 'Y' is the number of lanes, then this
+ * function returns the corresponding enum usb_ssp_rate.
+ */
 enum usb_ssp_rate usb_get_maximum_ssp_rate(struct device *dev)
 {
 	const char *maximum_speed;
@@ -116,6 +145,12 @@ enum usb_ssp_rate usb_get_maximum_ssp_rate(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(usb_get_maximum_ssp_rate);
 
+/**
+ * usb_state_string - Returns human readable name for the state.
+ * @state: The state to return a human-readable name for. If it's not
+ *	any of the states devices in usb_device_state_string enum,
+ *	the string UNKNOWN will be returned.
+ */
 const char *usb_state_string(enum usb_device_state state)
 {
 	static const char *const names[] = {
diff --git a/drivers/usb/common/debug.c b/drivers/usb/common/debug.c
index ba849c7bc5c7..a76a086b9c54 100644
--- a/drivers/usb/common/debug.c
+++ b/drivers/usb/common/debug.c
@@ -207,8 +207,26 @@ static void usb_decode_set_isoch_delay(__u8 wValue, char *str, size_t size)
 	snprintf(str, size, "Set Isochronous Delay(Delay = %d ns)", wValue);
 }
 
-/*
- * usb_decode_ctrl - returns a string representation of ctrl request
+/**
+ * usb_decode_ctrl - Returns human readable representation of control request.
+ * @str: buffer to return a human-readable representation of control request.
+ *       This buffer should have about 200 bytes.
+ * @size: size of str buffer.
+ * @bRequestType: matches the USB bmRequestType field
+ * @bRequest: matches the USB bRequest field
+ * @wValue: matches the USB wValue field (CPU byte order)
+ * @wIndex: matches the USB wIndex field (CPU byte order)
+ * @wLength: matches the USB wLength field (CPU byte order)
+ *
+ * Function returns decoded, formatted and human-readable description of
+ * control request packet.
+ *
+ * The usage scenario for this is for tracepoints, so function as a return
+ * use the same value as in parameters. This approach allows to use this
+ * function in TP_printk
+ *
+ * Important: wValue, wIndex, wLength parameters before invoking this function
+ * should be processed by le16_to_cpu macro.
  */
 const char *usb_decode_ctrl(char *str, size_t size, __u8 bRequestType,
 			    __u8 bRequest, __u16 wValue, __u16 wIndex,
diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
index 74debc824645..1cffa34740b0 100644
--- a/include/linux/usb/ch9.h
+++ b/include/linux/usb/ch9.h
@@ -45,76 +45,15 @@ enum usb_ssp_rate {
 	USB_SSP_GEN_2x2,
 };
 
-/**
- * usb_ep_type_string() - Returns human readable-name of the endpoint type.
- * @ep_type: The endpoint type to return human-readable name for.  If it's not
- *   any of the types: USB_ENDPOINT_XFER_{CONTROL, ISOC, BULK, INT},
- *   usually got by usb_endpoint_type(), the string 'unknown' will be returned.
- */
 extern const char *usb_ep_type_string(int ep_type);
-
-/**
- * usb_speed_string() - Returns human readable-name of the speed.
- * @speed: The speed to return human-readable name for.  If it's not
- *   any of the speeds defined in usb_device_speed enum, string for
- *   USB_SPEED_UNKNOWN will be returned.
- */
 extern const char *usb_speed_string(enum usb_device_speed speed);
-
-/**
- * usb_get_maximum_speed - Get maximum requested speed for a given USB
- * controller.
- * @dev: Pointer to the given USB controller device
- *
- * The function gets the maximum speed string from property "maximum-speed",
- * and returns the corresponding enum usb_device_speed.
- */
 extern enum usb_device_speed usb_get_maximum_speed(struct device *dev);
-
-/**
- * usb_get_maximum_ssp_rate - Get the signaling rate generation and lane count
- *	of a SuperSpeed Plus capable device.
- * @dev: Pointer to the given USB controller device
- *
- * If the string from "maximum-speed" property is super-speed-plus-genXxY where
- * 'X' is the generation number and 'Y' is the number of lanes, then this
- * function returns the corresponding enum usb_ssp_rate.
- */
 extern enum usb_ssp_rate usb_get_maximum_ssp_rate(struct device *dev);
-
-/**
- * usb_state_string - Returns human readable name for the state.
- * @state: The state to return a human-readable name for. If it's not
- *	any of the states devices in usb_device_state_string enum,
- *	the string UNKNOWN will be returned.
- */
 extern const char *usb_state_string(enum usb_device_state state);
-
 unsigned int usb_decode_interval(const struct usb_endpoint_descriptor *epd,
 				 enum usb_device_speed speed);
 
 #ifdef CONFIG_TRACING
-/**
- * usb_decode_ctrl - Returns human readable representation of control request.
- * @str: buffer to return a human-readable representation of control request.
- *       This buffer should have about 200 bytes.
- * @size: size of str buffer.
- * @bRequestType: matches the USB bmRequestType field
- * @bRequest: matches the USB bRequest field
- * @wValue: matches the USB wValue field (CPU byte order)
- * @wIndex: matches the USB wIndex field (CPU byte order)
- * @wLength: matches the USB wLength field (CPU byte order)
- *
- * Function returns decoded, formatted and human-readable description of
- * control request packet.
- *
- * The usage scenario for this is for tracepoints, so function as a return
- * use the same value as in parameters. This approach allows to use this
- * function in TP_printk
- *
- * Important: wValue, wIndex, wLength parameters before invoking this function
- * should be processed by le16_to_cpu macro.
- */
 extern const char *usb_decode_ctrl(char *str, size_t size, __u8 bRequestType,
 				   __u8 bRequest, __u16 wValue, __u16 wIndex,
 				   __u16 wLength);
-- 
2.35.1



