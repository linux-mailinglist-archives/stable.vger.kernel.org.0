Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F8B60BABC
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234788AbiJXUkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234852AbiJXUjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:39:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85B6102DF1;
        Mon, 24 Oct 2022 11:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C1CEB819C1;
        Mon, 24 Oct 2022 12:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A0DC433C1;
        Mon, 24 Oct 2022 12:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615494;
        bh=7AuFi6EBGKuPcwP8T4Kg4oFE8Bg46RXanDC8ZkVyVKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XN2fLrspz65v1qeTp79Nkj99c8O8pLyyT0yLZqiRXkiXL+lpTXN8qE9B7b2ncsit4
         wYfMOD5H1HENNgWhvk+blt1EospTBhZgvl4aYFdsfY6JdjXMEwqP3YEyPCPGjQfW2K
         Z17BbCdrt/famfwzjnVkmevFQAP2z+AbKnLR+dLM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/530] usb: common: debug: Check non-standard control requests
Date:   Mon, 24 Oct 2022 13:30:17 +0200
Message-Id: <20221024113057.433882827@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
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
index a76a086b9c54..f0c0e8db7038 100644
--- a/drivers/usb/common/debug.c
+++ b/drivers/usb/common/debug.c
@@ -207,30 +207,28 @@ static void usb_decode_set_isoch_delay(__u8 wValue, char *str, size_t size)
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
@@ -271,14 +269,48 @@ const char *usb_decode_ctrl(char *str, size_t size, __u8 bRequestType,
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



