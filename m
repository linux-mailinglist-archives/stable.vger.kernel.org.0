Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B48579F23
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243219AbiGSNLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243224AbiGSNK2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 09:10:28 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB8C65541;
        Tue, 19 Jul 2022 05:29:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4F5FBCE1B7D;
        Tue, 19 Jul 2022 12:28:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F985C341D1;
        Tue, 19 Jul 2022 12:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233728;
        bh=6egDnfLx31jfxdqK3K+JaWDNB/se+vJa4Ry3gxod+sg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fn3ByTBxrcyZe3cIXWLpu2riu9pOx3Suh+1EI06WJ5oz6ZHfDNN8xzmxXh9fJfL5
         s/zsizzPu2gBGRQsvly4nq2CqwgtuPR4PENklwgQWy7FROV2Odb5yp/T4zZVsFuXqR
         mCU0tW+1TiCBE8UHevtX0PeqFlgwjUk6oshxztg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        Ben Greening <bgreening@gmail.com>
Subject: [PATCH 5.18 221/231] ACPI: video: Fix acpi_video_handles_brightness_key_presses()
Date:   Tue, 19 Jul 2022 13:55:06 +0200
Message-Id: <20220719114732.326909106@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
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
 drivers/acpi/acpi_video.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -73,7 +73,7 @@ module_param(device_id_scheme, bool, 044
 static int only_lcd = -1;
 module_param(only_lcd, int, 0444);
 
-static bool has_backlight;
+static bool may_report_brightness_keys;
 static int register_count;
 static DEFINE_MUTEX(register_count_mutex);
 static DEFINE_MUTEX(video_list_lock);
@@ -1224,7 +1224,7 @@ acpi_video_bus_get_one_device(struct acp
 	acpi_video_device_find_cap(data);
 
 	if (data->cap._BCM && data->cap._BCL)
-		has_backlight = true;
+		may_report_brightness_keys = true;
 
 	mutex_lock(&video->device_list_lock);
 	list_add_tail(&data->entry, &video->video_device_list);
@@ -1693,6 +1693,9 @@ static void acpi_video_device_notify(acp
 		break;
 	}
 
+	if (keycode)
+		may_report_brightness_keys = true;
+
 	acpi_notifier_call_chain(device, event, 0);
 
 	if (keycode && (report_key_events & REPORT_BRIGHTNESS_KEY_EVENTS)) {
@@ -2254,7 +2257,7 @@ void acpi_video_unregister(void)
 	if (register_count) {
 		acpi_bus_unregister_driver(&acpi_video_bus);
 		register_count = 0;
-		has_backlight = false;
+		may_report_brightness_keys = false;
 	}
 	mutex_unlock(&register_count_mutex);
 }
@@ -2276,7 +2279,7 @@ void acpi_video_unregister_backlight(voi
 
 bool acpi_video_handles_brightness_key_presses(void)
 {
-	return has_backlight &&
+	return may_report_brightness_keys &&
 	       (report_key_events & REPORT_BRIGHTNESS_KEY_EVENTS);
 }
 EXPORT_SYMBOL(acpi_video_handles_brightness_key_presses);


