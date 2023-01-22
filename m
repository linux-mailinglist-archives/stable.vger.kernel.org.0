Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22AB676E59
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjAVPJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjAVPJh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:09:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BCC1DBBA
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:09:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66AB4B80AF8
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB05AC433D2;
        Sun, 22 Jan 2023 15:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400173;
        bh=C9t1DFItWPykAuRfVjDqJoMwXZ2TfuKwThQFlbCEHGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOLnVLK3J53KdsLYtXB/SnzyS319QhoZ7AmxzRjTw99omsogusep94p2aNqH20L2U
         zSuthiPZbr2Et9YyQLqy2YlUPchiVHnNYlMawLWr7HICGlvnkVPpMybnKNHc2nBNRU
         7kGD7y3Zmvvqg45ylhp9iVlKl4ehweNTrCcOEvho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Flavio Suligoi <f.suligoi@asem.it>,
        stable <stable@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.4 29/55] usb: core: hub: disable autosuspend for TI TUSB8041
Date:   Sun, 22 Jan 2023 16:04:16 +0100
Message-Id: <20230122150223.437325703@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Flavio Suligoi <f.suligoi@asem.it>

commit 7171b0e261b17de96490adf053b8bb4b00061bcf upstream.

The Texas Instruments TUSB8041 has an autosuspend problem at high
temperature.

If there is not USB traffic, after a couple of ms, the device enters in
autosuspend mode. In this condition the external clock stops working, to
save energy. When the USB activity turns on, ther hub exits the
autosuspend state, the clock starts running again and all works fine.

At ambient temperature all works correctly, but at high temperature,
when the USB activity turns on, the external clock doesn't restart and
the hub disappears from the USB bus.

Disabling the autosuspend mode for this hub solves the issue.

Signed-off-by: Flavio Suligoi <f.suligoi@asem.it>
Cc: stable <stable@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20221219124759.3207032-1-f.suligoi@asem.it
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -41,6 +41,9 @@
 #define USB_PRODUCT_USB5534B			0x5534
 #define USB_VENDOR_CYPRESS			0x04b4
 #define USB_PRODUCT_CY7C65632			0x6570
+#define USB_VENDOR_TEXAS_INSTRUMENTS		0x0451
+#define USB_PRODUCT_TUSB8041_USB3		0x8140
+#define USB_PRODUCT_TUSB8041_USB2		0x8142
 #define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
 #define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
 
@@ -5587,6 +5590,16 @@ static const struct usb_device_id hub_id
       .idVendor = USB_VENDOR_GENESYS_LOGIC,
       .bInterfaceClass = USB_CLASS_HUB,
       .driver_info = HUB_QUIRK_CHECK_PORT_AUTOSUSPEND},
+    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+			| USB_DEVICE_ID_MATCH_PRODUCT,
+      .idVendor = USB_VENDOR_TEXAS_INSTRUMENTS,
+      .idProduct = USB_PRODUCT_TUSB8041_USB2,
+      .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
+    { .match_flags = USB_DEVICE_ID_MATCH_VENDOR
+			| USB_DEVICE_ID_MATCH_PRODUCT,
+      .idVendor = USB_VENDOR_TEXAS_INSTRUMENTS,
+      .idProduct = USB_PRODUCT_TUSB8041_USB3,
+      .driver_info = HUB_QUIRK_DISABLE_AUTOSUSPEND},
     { .match_flags = USB_DEVICE_ID_MATCH_DEV_CLASS,
       .bDeviceClass = USB_CLASS_HUB},
     { .match_flags = USB_DEVICE_ID_MATCH_INT_CLASS,


