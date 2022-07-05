Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 255D8566D48
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiGEMWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236384AbiGEMRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:17:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D241219283;
        Tue,  5 Jul 2022 05:12:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4407A6196E;
        Tue,  5 Jul 2022 12:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505C3C341C7;
        Tue,  5 Jul 2022 12:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023144;
        bh=DdUNAMG4syaPuHLzx6elQsunbUmmz6FIMULsfgtSHDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AzO51/+/Qd3vPuGRH1v/VIRDE8x85yfBFCB55p6hfcQBp1qTtCLi6htJWRhkuSY2v
         QiZk9AWg2UsvMB4rnSEMMSHmg5uT5gqwIpZT508lwLM7/UfB2qQqmUs5/2+wldn2IC
         P2QX9QvCALNs6ewZWFvRQIRrr3tSyudHOsey1HQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Stefan Seyfried <seife+kernel@b1-systems.com>,
        Kenneth Chan <kenneth.t.chan@gmail.com>
Subject: [PATCH 5.15 53/98] ACPI: video: Change how we determine if brightness key-presses are handled
Date:   Tue,  5 Jul 2022 13:58:11 +0200
Message-Id: <20220705115619.088923525@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 3a0cf7ab8df3878a7e2f3d29275b785cf4e7afb6 upstream.

Some systems have an ACPI video bus but not ACPI video devices with
backlight capability. On these devices brightness key-presses are
(logically) not reported through the ACPI video bus.

Change how acpi_video_handles_brightness_key_presses() determines if
brightness key-presses are handled by the ACPI video driver to avoid
vendor specific drivers/platform/x86 drivers filtering out their
brightness key-presses even though they are the only ones reporting
these presses.

Fixes: ed83c9171829 ("platform/x86: panasonic-laptop: Resolve hotkey double trigger bug")
Reported-and-tested-by: Stefan Seyfried <seife+kernel@b1-systems.com>
Reported-and-tested-by: Kenneth Chan <kenneth.t.chan@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220624112340.10130-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_video.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -73,6 +73,7 @@ module_param(device_id_scheme, bool, 044
 static int only_lcd = -1;
 module_param(only_lcd, int, 0444);
 
+static bool has_backlight;
 static int register_count;
 static DEFINE_MUTEX(register_count_mutex);
 static DEFINE_MUTEX(video_list_lock);
@@ -1222,6 +1223,9 @@ acpi_video_bus_get_one_device(struct acp
 	acpi_video_device_bind(video, data);
 	acpi_video_device_find_cap(data);
 
+	if (data->cap._BCM && data->cap._BCL)
+		has_backlight = true;
+
 	mutex_lock(&video->device_list_lock);
 	list_add_tail(&data->entry, &video->video_device_list);
 	mutex_unlock(&video->device_list_lock);
@@ -2251,6 +2255,7 @@ void acpi_video_unregister(void)
 	if (register_count) {
 		acpi_bus_unregister_driver(&acpi_video_bus);
 		register_count = 0;
+		has_backlight = false;
 	}
 	mutex_unlock(&register_count_mutex);
 }
@@ -2272,13 +2277,7 @@ void acpi_video_unregister_backlight(voi
 
 bool acpi_video_handles_brightness_key_presses(void)
 {
-	bool have_video_busses;
-
-	mutex_lock(&video_list_lock);
-	have_video_busses = !list_empty(&video_bus_head);
-	mutex_unlock(&video_list_lock);
-
-	return have_video_busses &&
+	return has_backlight &&
 	       (report_key_events & REPORT_BRIGHTNESS_KEY_EVENTS);
 }
 EXPORT_SYMBOL(acpi_video_handles_brightness_key_presses);


