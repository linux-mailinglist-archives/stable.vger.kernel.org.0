Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5A537C9E0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236847AbhELQXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240476AbhELQSI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6EF861D75;
        Wed, 12 May 2021 15:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834256;
        bh=2oFtuUTODshxbFHwas6/hd2zei2d7kLtiLCkPMAHtto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T10CD3fTAtWXFix1SY/9ROOGzDas6rmvElU2ZpyOADEFg3l0RnJgaiB+8Hlwrk2qE
         rZaoRCdqZE/P4l4gNPe70fES2rSIiZtMh0ZAVpilKWVKXkTc30cHiZqLeHp8Am+tqD
         tDLaawnGF1x6QqH7Q7Ozuz1ofQTw5vUlJRP8wdes=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 444/601] HID: lenovo: Use brightness_set_blocking callback for setting LEDs brightness
Date:   Wed, 12 May 2021 16:48:41 +0200
Message-Id: <20210512144842.465575190@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit bbf62645255f120bc2e7488c237e3f04da42ec70 ]

The lenovo_led_brightness_set function may sleep, so we should have the
the led_class_dev's brightness_set_blocking callback point to it, rather
then the regular brightness_set callback.

When toggled through sysfs this is not a problem, but the brightness_set
callback may be called from atomic context when using LED-triggers.

Fixes: bc04b37ea0ec ("HID: lenovo: Add ThinkPad 10 Ultrabook Keyboard support")
Reviewed-by: Marek Behún <kabel@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-lenovo.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index c6c8e20f3e8d..4dc5e5f932ed 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -777,7 +777,7 @@ static enum led_brightness lenovo_led_brightness_get(
 				: LED_OFF;
 }
 
-static void lenovo_led_brightness_set(struct led_classdev *led_cdev,
+static int lenovo_led_brightness_set(struct led_classdev *led_cdev,
 			enum led_brightness value)
 {
 	struct device *dev = led_cdev->dev->parent;
@@ -802,6 +802,8 @@ static void lenovo_led_brightness_set(struct led_classdev *led_cdev,
 		lenovo_led_set_tp10ubkbd(hdev, tp10ubkbd_led[led_nr], value);
 		break;
 	}
+
+	return 0;
 }
 
 static int lenovo_register_leds(struct hid_device *hdev)
@@ -822,7 +824,7 @@ static int lenovo_register_leds(struct hid_device *hdev)
 
 	data->led_mute.name = name_mute;
 	data->led_mute.brightness_get = lenovo_led_brightness_get;
-	data->led_mute.brightness_set = lenovo_led_brightness_set;
+	data->led_mute.brightness_set_blocking = lenovo_led_brightness_set;
 	data->led_mute.dev = &hdev->dev;
 	ret = led_classdev_register(&hdev->dev, &data->led_mute);
 	if (ret < 0)
@@ -830,7 +832,7 @@ static int lenovo_register_leds(struct hid_device *hdev)
 
 	data->led_micmute.name = name_micm;
 	data->led_micmute.brightness_get = lenovo_led_brightness_get;
-	data->led_micmute.brightness_set = lenovo_led_brightness_set;
+	data->led_micmute.brightness_set_blocking = lenovo_led_brightness_set;
 	data->led_micmute.dev = &hdev->dev;
 	ret = led_classdev_register(&hdev->dev, &data->led_micmute);
 	if (ret < 0) {
-- 
2.30.2



