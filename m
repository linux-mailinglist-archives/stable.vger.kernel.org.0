Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4185AB057
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237659AbiIBMwu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237811AbiIBMvt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:51:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A08EF8EED;
        Fri,  2 Sep 2022 05:37:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1BAEB82ADF;
        Fri,  2 Sep 2022 12:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E453C433B5;
        Fri,  2 Sep 2022 12:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122157;
        bh=mf1teGMEOWSgwfn7Vz5ipwIsBvF8fMKbCe1bwBIL/fU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nECcDZLZ1JwFbf3cKYxLOHaZPCkD0vCnR9oV60ImdUU+W4k3gCP5dIIngLU45Sglj
         +Fxd2dN4WJHKQJ5HY4LufSJOOXbyZi/FuBy/wzQFdrHk3FgQfCqHSZoylRJ/DO+kwi
         sER/pRKOq+l4IaZa4JGpYbY2bFaIUTQ4WhNNYBfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Garg <gargaditya08@live.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.19 23/72] HID: Add Apple Touchbar on T2 Macs in hid_have_special_driver list
Date:   Fri,  2 Sep 2022 14:18:59 +0200
Message-Id: <20220902121405.549386554@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

commit 750ec977288d96e9a11424e3507ede097af732c4 upstream.

The touchbar on Apple T2 Macs has 2 modes, one that shows the function
keys and other that shows the media controls. The user can use the fn
key on his keyboard to switch between the 2 modes.

On Linux, if people were using an external keyboard or mouse, the
touchbar failed to change modes on pressing the fn key with the following
in dmesg :-

[   10.661445] apple-ib-als 0003:05AC:8262.0001: : USB HID v1.01 Device [Apple Inc. Ambient Light Sensor] on usb-bce-vhci-3/input0
[   11.830992] apple-ib-touchbar 0003:05AC:8302.0007: input: USB HID v1.01 Keyboard [Apple Inc. Touch Bar Display] on usb-bce-vhci-6/input0
[   12.139407] apple-ib-touchbar 0003:05AC:8102.0008: : USB HID v1.01 Device [Apple Inc. Touch Bar Backlight] on usb-bce-vhci-7/input0
[   12.211824] apple-ib-touchbar 0003:05AC:8102.0009: : USB HID v1.01 Device [Apple Inc. Touch Bar Backlight] on usb-bce-vhci-7/input1
[   14.219759] apple-ib-touchbar 0003:05AC:8302.0007: tb: Failed to set touch bar mode to 2 (-110)
[   24.395670] apple-ib-touchbar 0003:05AC:8302.0007: tb: Failed to set touch bar mode to 2 (-110)
[   34.635791] apple-ib-touchbar 0003:05AC:8302.0007: tb: Failed to set touch bar mode to 2 (-110)
[  269.579233] apple-ib-touchbar 0003:05AC:8302.0007: tb: Failed to set touch bar mode to 1 (-110)

Add the USB IDs of the touchbar found in T2 Macs to HID have special
driver list to fix the issue.

Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    2 ++
 drivers/hid/hid-quirks.c |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -185,6 +185,8 @@
 #define USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021   0x029c
 #define USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021   0x029a
 #define USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_NUMPAD_2021   0x029f
+#define USB_DEVICE_ID_APPLE_TOUCHBAR_BACKLIGHT 0x8102
+#define USB_DEVICE_ID_APPLE_TOUCHBAR_DISPLAY 0x8302
 
 #define USB_VENDOR_ID_ASUS		0x0486
 #define USB_DEVICE_ID_ASUS_T91MT	0x0185
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -314,6 +314,8 @@ static const struct hid_device_id hid_ha
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER1_TP_ONLY) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_TOUCHBAR_BACKLIGHT) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_TOUCHBAR_DISPLAY) },
 #endif
 #if IS_ENABLED(CONFIG_HID_APPLEIR)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_IRCONTROL) },


