Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361B96087C4
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiJVIFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbiJVIEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:04:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CBF2C634E;
        Sat, 22 Oct 2022 00:52:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C45FB82DF7;
        Sat, 22 Oct 2022 07:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32016C433C1;
        Sat, 22 Oct 2022 07:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425072;
        bh=qI6XQaN06IuKoof2ZGO7xbX8GPjKLgwHHsphrLlDk3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATh5wt7Uvfxh1LkZI5iJI+rnj9uJ5zCL9JsXgMcdE2VgC32mGwsasxgDKJgfpTbtM
         k7UNNGF5dDZIAeNRGQQTN3ZJhXn4hlvY27Gn3GmkwlA619Tmh67RBAgPLsdOBTFCJG
         zOCfw18/jYkhm3Ss4Z3Ggrd39sxHLQ2+C8vYcZhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 380/717] usb: common: debug: Check non-standard control requests
Date:   Sat, 22 Oct 2022 09:24:19 +0200
Message-Id: <20221022072514.062890391@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit b6155eaf6b05e558218b44b88a6cad03f15a586c ]

Previously usb_decode_ctrl() only decodes standard control requests, but
it was used for non-standard requests also. If it's non-standard or
unknown standard bRequest, print the Setup data values.

Fixes: af32423a2d86 ("usb: dwc3: trace: decode ctrl request")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/8d6a30f2f2f953eff833a5bc5aac640a4cc2fc9f.1658971571.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/common/debug.c | 96 +++++++++++++++++++++++++-------------
 1 file changed, 64 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/common/debug.c b/drivers/usb/common/debug.c
index 075f6b1b2a1a..f204cec8d380 100644
--- a/drivers/usb/common/debug.c
+++ b/drivers/usb/common/debug.c
@@ -208,30 +208,28 @@ static void usb_decode_set_isoch_delay(__u8 wValue, char *str, size_t size)
 	snprintf(str, size, "Set Isochronous Delay(Delay = %d ns)", wValue);
 }
 
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
-const char *usb_decode_ctrl(char *str, size_t size, __u8 bRequestType,
-			    __u8 bRequest, __u16 wValue, __u16 wIndex,
-			    __u16 wLength)
+static void usb_decode_ctrl_generic(char *str, size_t size, __u8 bRequestType,
+				    __u8 bRequest, __u16 wValue, __u16 wIndex,
+				    __u16 wLength)
+{
+	u8 recip = bRequestType & USB_RECIP_MASK;
+	u8 type = bRequestType & USB_TYPE_MASK;
+
+	snprintf(str, size,
+		 "Type=%s Recipient=%s Dir=%s bRequest=%u wValue=%u wIndex=%u wLength=%u",
+		 (type == USB_TYPE_STANDARD)    ? "Standard" :
+		 (type == USB_TYPE_VENDOR)      ? "Vendor" :
+		 (type == USB_TYPE_CLASS)       ? "Class" : "Unknown",
+		 (recip == USB_RECIP_DEVICE)    ? "Device" :
+		 (recip == USB_RECIP_INTERFACE) ? "Interface" :
+		 (recip == USB_RECIP_ENDPOINT)  ? "Endpoint" : "Unknown",
+		 (bRequestType & USB_DIR_IN)    ? "IN" : "OUT",
+		 bRequest, wValue, wIndex, wLength);
+}
+
+static void usb_decode_ctrl_standard(char *str, size_t size, __u8 bRequestType,
+				     __u8 bRequest, __u16 wValue, __u16 wIndex,
+				     __u16 wLength)
 {
 	switch (bRequest) {
 	case USB_REQ_GET_STATUS:
@@ -272,14 +270,48 @@ const char *usb_decode_ctrl(char *str, size_t size, __u8 bRequestType,
 		usb_decode_set_isoch_delay(wValue, str, size);
 		break;
 	default:
-		snprintf(str, size, "%02x %02x %02x %02x %02x %02x %02x %02x",
-			 bRequestType, bRequest,
-			 (u8)(cpu_to_le16(wValue) & 0xff),
-			 (u8)(cpu_to_le16(wValue) >> 8),
-			 (u8)(cpu_to_le16(wIndex) & 0xff),
-			 (u8)(cpu_to_le16(wIndex) >> 8),
-			 (u8)(cpu_to_le16(wLength) & 0xff),
-			 (u8)(cpu_to_le16(wLength) >> 8));
+		usb_decode_ctrl_generic(str, size, bRequestType, bRequest,
+					wValue, wIndex, wLength);
+		break;
+	}
+}
+
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
+ */
+const char *usb_decode_ctrl(char *str, size_t size, __u8 bRequestType,
+			    __u8 bRequest, __u16 wValue, __u16 wIndex,
+			    __u16 wLength)
+{
+	switch (bRequestType & USB_TYPE_MASK) {
+	case USB_TYPE_STANDARD:
+		usb_decode_ctrl_standard(str, size, bRequestType, bRequest,
+					 wValue, wIndex, wLength);
+		break;
+	case USB_TYPE_VENDOR:
+	case USB_TYPE_CLASS:
+	default:
+		usb_decode_ctrl_generic(str, size, bRequestType, bRequest,
+					wValue, wIndex, wLength);
+		break;
 	}
 
 	return str;
-- 
2.35.1



