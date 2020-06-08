Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065651F2440
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 01:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730820AbgFHXTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:19:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730807AbgFHXTe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ACE821556;
        Mon,  8 Jun 2020 23:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658374;
        bh=Aay7g+6QoqcAa867zA6NxerJV2IzWmFYYUuikQsOEp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UitV0NYQIiE2TkALyDzAj3bVuMrEoWi1WOmpMHKcVE8iBlpiYkOq9oVtRYioP5FnE
         xbYBr35bOUfTIyHK7vMSu2F0JFfm7OG8ryeEJKvY1n4+WkVn6pWPYE5fgay4SipCw4
         mSB94S3H25yKLbZ6gU3m4OlLJoTB+fgWFaqFpELo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Koba Ko <koba.ko@canonical.com>,
        Mario Limonciello <Mario.limonciello@dell.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 036/175] platform/x86: dell-laptop: don't register micmute LED if there is no token
Date:   Mon,  8 Jun 2020 19:16:29 -0400
Message-Id: <20200608231848.3366970-36-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koba Ko <koba.ko@canonical.com>

[ Upstream commit 257e03a334ccb96e657bf5f6ab3b5693a22c2aa4 ]

On Dell G3-3590, error message is issued during boot up,
"platform::micmute: Setting an LED's brightness failed (-19)",
but there's no micmute led on the machine.

Get the related tokens of SMBIOS, GLOBAL_MIC_MUTE_DISABLE/ENABLE.
If one of two tokens doesn't exist,
don't call led_classdev_register() for platform::micmute.
After that, you wouldn't see the platform::micmute in /sys/class/leds/,
and the error message wouldn't see in dmesg.

Fixes: d00fa46e0a2c6 ("platform/x86: dell-laptop: Add micmute LED trigger support")
Signed-off-by: Koba Ko <koba.ko@canonical.com>
Reviewed-by: Mario Limonciello <Mario.limonciello@dell.com>
Reviewed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-laptop.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 74e988f839e8..4c1dd1d4e60b 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -2204,10 +2204,13 @@ static int __init dell_init(void)
 
 	dell_laptop_register_notifier(&dell_laptop_notifier);
 
-	micmute_led_cdev.brightness = ledtrig_audio_get(LED_AUDIO_MICMUTE);
-	ret = led_classdev_register(&platform_device->dev, &micmute_led_cdev);
-	if (ret < 0)
-		goto fail_led;
+	if (dell_smbios_find_token(GLOBAL_MIC_MUTE_DISABLE) &&
+	    dell_smbios_find_token(GLOBAL_MIC_MUTE_ENABLE)) {
+		micmute_led_cdev.brightness = ledtrig_audio_get(LED_AUDIO_MICMUTE);
+		ret = led_classdev_register(&platform_device->dev, &micmute_led_cdev);
+		if (ret < 0)
+			goto fail_led;
+	}
 
 	if (acpi_video_get_backlight_type() != acpi_backlight_vendor)
 		return 0;
-- 
2.25.1

