Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517EA579C86
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbiGSMkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240983AbiGSMih (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:38:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD1765CF;
        Tue, 19 Jul 2022 05:15:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA50AB81B08;
        Tue, 19 Jul 2022 12:15:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7B0C341C6;
        Tue, 19 Jul 2022 12:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232913;
        bh=cYAwYbrCovmlUOXI8ZeD6uGS35GcV0fsOYWzd1PqXrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hs8gj/bg4xeTQMPwfGRRUaQoVX5ZZbviu1KRVM5L1Z9rJXYMFlDgNUbV8UOXLCDwT
         QuUbHjhZILZaDyVezu1V0K7tOxvyuks3mO4jMIFkignUkVDhUnGV8DmvowL+TSJcgC
         Pe1Bzfldb0e14P/Opw3gtR6TrUHVIEMC/Z3XV7Aw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Ben Greening <bgreening@gmail.com>
Subject: [PATCH 5.15 109/167] ACPI: video: Fix acpi_video_handles_brightness_key_presses()
Date:   Tue, 19 Jul 2022 13:54:01 +0200
Message-Id: <20220719114706.998852816@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5ad26161a371e4aa2d2553286f0cac580987a493 ]

Commit 3a0cf7ab8df3 ("ACPI: video: Change how we determine if brightness
key-presses are handled") made acpi_video_handles_brightness_key_presses()
report false when none of the ACPI Video Devices support backlight control.

But it turns out that at least on a Dell Inspiron N4010 there is no ACPI
backlight control, yet brightness hotkeys are still reported through
the ACPI Video Bus; and since acpi_video_handles_brightness_key_presses()
now returns false, brightness keypresses are now reported twice.

To fix this rename the has_backlight flag to may_report_brightness_keys and
also set it the first time a brightness key press event is received.

Depending on the delivery of the other ACPI (WMI) event vs the ACPI Video
Bus event this means that the first brightness key press might still get
reported twice, but all further keypresses will be filtered as before.

Note that this relies on other drivers reporting brightness key events
calling acpi_video_handles_brightness_key_presses() when delivering
the events (rather then once during driver probe). This is already
required and documented in include/acpi/video.h:

/*
 * Note: The value returned by acpi_video_handles_brightness_key_presses()
 * may change over time and should not be cached.
 */

Fixes: 3a0cf7ab8df3 ("ACPI: video: Change how we determine if brightness key-presses are handled")
Link: https://lore.kernel.org/regressions/CALF=6jEe5G8+r1Wo0vvz4GjNQQhdkLT5p8uCHn6ZXhg4nsOWow@mail.gmail.com/
Reported-and-tested-by: Ben Greening <bgreening@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20220713211101.85547-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 007deb3a8ea3..390af28f6faf 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -73,7 +73,7 @@ module_param(device_id_scheme, bool, 0444);
 static int only_lcd = -1;
 module_param(only_lcd, int, 0444);
 
-static bool has_backlight;
+static bool may_report_brightness_keys;
 static int register_count;
 static DEFINE_MUTEX(register_count_mutex);
 static DEFINE_MUTEX(video_list_lock);
@@ -1224,7 +1224,7 @@ acpi_video_bus_get_one_device(struct acpi_device *device,
 	acpi_video_device_find_cap(data);
 
 	if (data->cap._BCM && data->cap._BCL)
-		has_backlight = true;
+		may_report_brightness_keys = true;
 
 	mutex_lock(&video->device_list_lock);
 	list_add_tail(&data->entry, &video->video_device_list);
@@ -1693,6 +1693,9 @@ static void acpi_video_device_notify(acpi_handle handle, u32 event, void *data)
 		break;
 	}
 
+	if (keycode)
+		may_report_brightness_keys = true;
+
 	acpi_notifier_call_chain(device, event, 0);
 
 	if (keycode && (report_key_events & REPORT_BRIGHTNESS_KEY_EVENTS)) {
@@ -2255,7 +2258,7 @@ void acpi_video_unregister(void)
 	if (register_count) {
 		acpi_bus_unregister_driver(&acpi_video_bus);
 		register_count = 0;
-		has_backlight = false;
+		may_report_brightness_keys = false;
 	}
 	mutex_unlock(&register_count_mutex);
 }
@@ -2277,7 +2280,7 @@ void acpi_video_unregister_backlight(void)
 
 bool acpi_video_handles_brightness_key_presses(void)
 {
-	return has_backlight &&
+	return may_report_brightness_keys &&
 	       (report_key_events & REPORT_BRIGHTNESS_KEY_EVENTS);
 }
 EXPORT_SYMBOL(acpi_video_handles_brightness_key_presses);
-- 
2.35.1



