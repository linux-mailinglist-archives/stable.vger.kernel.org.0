Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FE24E1D80
	for <lists+stable@lfdr.de>; Sun, 20 Mar 2022 20:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343564AbiCTTIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Mar 2022 15:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240008AbiCTTIA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Mar 2022 15:08:00 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0B33892;
        Sun, 20 Mar 2022 12:06:36 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id m30so8316732wrb.1;
        Sun, 20 Mar 2022 12:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=frlCbdyFyD1efBwmWi9qLpV5969GST9bIqCrV9sqk5c=;
        b=XsgbBnLt/oiOU+NDZG8PYfCVthkFDPKHAlruSVtEfoJx8vob+TYPBDlhJS9lVKrkLa
         kytIwBDZtlObX4ocpRAV9qXhSr2VUvrZeSerfmyPCWByeicoe9ZZmWIKPSg0bOm09AyE
         4R/WEaoSxzxjr0XUtF6gv/rZN+yDUW2PO0GusikJWfBd9oeh9pYn4kbloY7Nn7BRbKeM
         YJai/K8Lg7xAucWZJvUH/t51kjzgn11iBnW5WQx36dQWnZ9Zr6P4VB+QQiii84HjFhRz
         kquoZYmfZ4FfUGa6KAUeOlwQMwH8/V4PlyDQMJ+AQdAEgLv36lBbTexr6ad8wIGVVxL3
         G2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=frlCbdyFyD1efBwmWi9qLpV5969GST9bIqCrV9sqk5c=;
        b=aGDCVtr8vLuj7ZK+fXuPFxceSRrMBCjF+VajN+1QMj2nPhGAC3eMuAEqEaWCYIt0bq
         kM9fPwGdgmo/rAu89xJS6HZu2llxbhqZk5m381ahVpnUjzHJiRTkBQ/BLaKY3cwfWUOY
         l4XO4/uZnsmROLfdaSVmdOn/y8Z78kRu8ufD/krijMz7c+i2T8Tu8ePSiV3iKTQSXb4k
         aK4t93kqpCrc7u0K1+BsTKKVYv2UONkSImknVtqLdK74akJTVtJuhCWuyBdED1leqhsr
         neP0qS9l6FIoR/o/dnC+aCkQjAVyC2/iYb4QAsEL5on8XBChgCgRhBBbJgbz5JAn3B7y
         Iinw==
X-Gm-Message-State: AOAM530yYkq9AiPzBcGn/E3rGn0/lqK1RAk+C5hnNhxcNvuEhssu/IO1
        l4xzYAa1l2FwUDYgKGZoUgg=
X-Google-Smtp-Source: ABdhPJynItxADWZh1P60ypxNl2Sw+ab7jartcfeWHi1oRqI22xfsSiah++wiC6G/hGWOVEgRfXq3WQ==
X-Received: by 2002:adf:b64c:0:b0:1e3:16d0:3504 with SMTP id i12-20020adfb64c000000b001e316d03504mr15540948wre.333.1647803194799;
        Sun, 20 Mar 2022 12:06:34 -0700 (PDT)
Received: from localhost.localdomain ([94.73.33.246])
        by smtp.gmail.com with ESMTPSA id bg42-20020a05600c3caa00b00380deeaae72sm14211454wmb.1.2022.03.20.12.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Mar 2022 12:06:34 -0700 (PDT)
From:   =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
To:     jkosina@suse.cz
Cc:     tiwai@suse.de, benjamin.tissoires@redhat.com,
        regressions@leemhuis.info, peter.hutterer@who-t.net,
        linux-input@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>
Subject: [PATCH] HID: multitouch: fix Dell Precision 7550 and 7750 button type
Date:   Sun, 20 Mar 2022 20:06:03 +0100
Message-Id: <20220320190602.7484-1-jose.exposito89@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The touchpad present in the Dell Precision 7550 and 7750 laptops
reports a HID_DG_BUTTONTYPE of type MT_BUTTONTYPE_CLICKPAD. However,
the device is not a clickpad, it is a touchpad with physical buttons.

In order to fix this issue, a quirk for the device was introduced in
libinput [1] [2] to disable the INPUT_PROP_BUTTONPAD property:

	[Precision 7x50 Touchpad]
	MatchBus=i2c
	MatchUdevType=touchpad
	MatchDMIModalias=dmi:*svnDellInc.:pnPrecision7?50*
	AttrInputPropDisable=INPUT_PROP_BUTTONPAD

However, because of the change introduced in 37ef4c19b4 ("Input: clear
BTN_RIGHT/MIDDLE on buttonpads") the BTN_RIGHT key bit is not mapped
anymore breaking the device right click button.

In order to fix the issue, create a quirk for the device forcing its
button type to touchpad regardless of the value reported by the
firmware.

[1] https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/481
[2] https://bugzilla.redhat.com/show_bug.cgi?id=1868789

Fixes: 37ef4c19b4 ("Input: clear BTN_RIGHT/MIDDLE on buttonpads")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
---
 drivers/hid/hid-ids.h        |  3 +++
 drivers/hid/hid-multitouch.c | 20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 78bd3ddda442..6cf7a5b6835b 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -287,6 +287,9 @@
 
 #define USB_VENDOR_ID_CIDC		0x1677
 
+#define USB_VENDOR_ID_CIRQUE_CORP		0x0488
+#define USB_DEVICE_ID_DELL_PRECISION_7X50	0x120A
+
 #define USB_VENDOR_ID_CJTOUCH		0x24b8
 #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0020	0x0020
 #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0040	0x0040
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 99eabfb4145b..f012cf8e0b8c 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -71,6 +71,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_SEPARATE_APP_REPORT	BIT(19)
 #define MT_QUIRK_FORCE_MULTI_INPUT	BIT(20)
 #define MT_QUIRK_DISABLE_WAKEUP		BIT(21)
+#define MT_QUIRK_BUTTONTYPE_TOUCHPAD	BIT(22)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -194,6 +195,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_WIN_8_FORCE_MULTI_INPUT		0x0015
 #define MT_CLS_WIN_8_DISABLE_WAKEUP		0x0016
 #define MT_CLS_WIN_8_NO_STICKY_FINGERS		0x0017
+#define MT_CLS_BUTTONTYPE_TOUCHPAD		0x0018
 
 /* vendor specific classes */
 #define MT_CLS_3M				0x0101
@@ -302,6 +304,15 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_WIN8_PTP_BUTTONS,
 		.export_all_inputs = true },
+	{ .name = MT_CLS_BUTTONTYPE_TOUCHPAD,
+		.quirks = MT_QUIRK_ALWAYS_VALID |
+			MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_HOVERING |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_STICKY_FINGERS |
+			MT_QUIRK_WIN8_PTP_BUTTONS |
+			MT_QUIRK_BUTTONTYPE_TOUCHPAD,
+		.export_all_inputs = true },
 
 	/*
 	 * vendor specific classes
@@ -1286,6 +1297,9 @@ static int mt_touch_input_configured(struct hid_device *hdev,
 	    (app->buttons_count == 1))
 		td->is_buttonpad = true;
 
+	if (app->quirks & MT_QUIRK_BUTTONTYPE_TOUCHPAD)
+		td->is_buttonpad = false;
+
 	if (td->is_buttonpad)
 		__set_bit(INPUT_PROP_BUTTONPAD, input->propbit);
 
@@ -1872,6 +1886,12 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT,
 			USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
 
+	/* Cirque Corp (Dell Precision 7550 and 7750 touchpad) */
+	{ .driver_data = MT_CLS_BUTTONTYPE_TOUCHPAD,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			USB_VENDOR_ID_CIRQUE_CORP,
+			USB_DEVICE_ID_DELL_PRECISION_7X50) },
+
 	/* CJTouch panels */
 	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_CJTOUCH,
-- 
2.25.1

