Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9E464A187
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbiLLNle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbiLLNlC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:41:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F825F4A
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:40:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 912F2CE0F7D
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A5CC433D2;
        Mon, 12 Dec 2022 13:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852430;
        bh=H5grS12utAQ9fmXh0vZHxLIzSa29iEFLbEKBhLderhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wq3Uw1u+kEyRRSVUGknoPbEdvIzPcJJ1YZPgfLlPuNoTYd6FmxkJsjX+L0Dc8bXjd
         honw1sgbt6+n3zDLGk3I9GHAJJP4TPFnHHTaRRnXxprJ5oEweffhOOF0Ea8fQrdNzG
         ZirP/6AFBVoE4BuBybq7ExywtSZ9s6tabLlz0pXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ankit Patel <anpatel@nvidia.com>,
        Haotien Hsu <haotienh@nvidia.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.0 078/157] HID: usbhid: Add ALWAYS_POLL quirk for some mice
Date:   Mon, 12 Dec 2022 14:17:06 +0100
Message-Id: <20221212130937.878295934@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ankit Patel <anpatel@nvidia.com>

commit f6d910a89a2391e5ce1f275d205023880a33d3f8 upstream.

Some additional USB mouse devices are needing ALWAYS_POLL quirk without
which they disconnect and reconnect every 60s.

Add below devices to the known quirk list.
CHERRY    VID 0x046a, PID 0x000c
MICROSOFT VID 0x045e, PID 0x0783
PRIMAX    VID 0x0461, PID 0x4e2a

Signed-off-by: Ankit Patel <anpatel@nvidia.com>
Signed-off-by: Haotien Hsu <haotienh@nvidia.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ids.h    |    3 +++
 drivers/hid/hid-quirks.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -274,6 +274,7 @@
 #define USB_DEVICE_ID_CH_AXIS_295	0x001c
 
 #define USB_VENDOR_ID_CHERRY		0x046a
+#define USB_DEVICE_ID_CHERRY_MOUSE_000C	0x000c
 #define USB_DEVICE_ID_CHERRY_CYMOTION	0x0023
 #define USB_DEVICE_ID_CHERRY_CYMOTION_SOLAR	0x0027
 
@@ -917,6 +918,7 @@
 #define USB_DEVICE_ID_MS_XBOX_ONE_S_CONTROLLER	0x02fd
 #define USB_DEVICE_ID_MS_PIXART_MOUSE    0x00cb
 #define USB_DEVICE_ID_8BITDO_SN30_PRO_PLUS      0x02e0
+#define USB_DEVICE_ID_MS_MOUSE_0783      0x0783
 
 #define USB_VENDOR_ID_MOJO		0x8282
 #define USB_DEVICE_ID_RETRO_ADAPTER	0x3201
@@ -1379,6 +1381,7 @@
 
 #define USB_VENDOR_ID_PRIMAX	0x0461
 #define USB_DEVICE_ID_PRIMAX_MOUSE_4D22	0x4d22
+#define USB_DEVICE_ID_PRIMAX_MOUSE_4E2A	0x4e2a
 #define USB_DEVICE_ID_PRIMAX_KEYBOARD	0x4e05
 #define USB_DEVICE_ID_PRIMAX_REZEL	0x4e72
 #define USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4D0F	0x4d0f
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -54,6 +54,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_YOKE), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_PEDALS), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_THROTTLE), HID_QUIRK_NOGET },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_MOUSE_000C), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K65RGB), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K65RGB_RAPIDFIRE), HID_QUIRK_NO_INIT_REPORTS | HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K70RGB), HID_QUIRK_NO_INIT_REPORTS },
@@ -122,6 +123,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOUSE_C05A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_LOGITECH_MOUSE_C06A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MCS, USB_DEVICE_ID_MCS_GAMEPADBLOCK), HID_QUIRK_MULTI_INPUT },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_MOUSE_0783), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PIXART_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_POWER_COVER), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_SURFACE3_COVER), HID_QUIRK_NO_INIT_REPORTS },
@@ -146,6 +148,7 @@ static const struct hid_device_id hid_qu
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_USB_OPTICAL_MOUSE), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_MOUSE_4D22), HID_QUIRK_ALWAYS_POLL },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_MOUSE_4E2A), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4D0F), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4D65), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_PRIMAX, USB_DEVICE_ID_PRIMAX_PIXART_MOUSE_4E22), HID_QUIRK_ALWAYS_POLL },


