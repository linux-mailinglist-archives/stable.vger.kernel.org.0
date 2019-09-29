Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E664CC1544
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730194AbfI2OC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 10:02:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:45178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730220AbfI2OC2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 10:02:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92F362082F;
        Sun, 29 Sep 2019 14:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765748;
        bh=LNhH+DAAmF6IDi+AxFJ4GguOaZjC2sVTm/JMgj4MUzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=giVT078EOSZMBUuXL1O29XJzBN18Y9lzaHmQ9dcDTpdlUkdr8TyhQ+I4LNnnW2Me2
         7Z/z3hNkQEpNhPrkvbEburaXLkSiX+KrSOy2Wn3vIC05F4zbbwjHtQqQYng2AEA4X6
         V/Tv7bCIE1uBYelnYXTSSG15UoYdDjV7Zoq7uC3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Kacper=20Piwi=C5=84ski?= <cosiekvfj@o2.pl>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 38/45] ACPI: video: Add new hw_changes_brightness quirk, set it on PB Easynote MZ35
Date:   Sun, 29 Sep 2019 15:56:06 +0200
Message-Id: <20190929135033.030560273@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
References: <20190929135024.387033930@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 4f7f96453b462b3de0fa18d18fe983960bb5ee7f ]

Some machines change the brightness themselves when a brightness hotkey
gets pressed, despite us telling them not to. This causes the brightness to
go two steps up / down when the hotkey is pressed. This is esp. a problem
on older machines with only a few brightness levels.

This commit adds a new hw_changes_brightness quirk which makes
acpi_video_device_notify() only call backlight_force_update(...,
BACKLIGHT_UPDATE_HOTKEY) and not do anything else, notifying userspace
that the brightness was changed and leaving it at that fixing the dual
step problem.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=204077
Reported-by: Kacper Piwiński <cosiekvfj@o2.pl>
Tested-by: Kacper Piwiński <cosiekvfj@o2.pl>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 9489ffc064117..4f325e47519f5 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -60,6 +60,12 @@ module_param(report_key_events, int, 0644);
 MODULE_PARM_DESC(report_key_events,
 	"0: none, 1: output changes, 2: brightness changes, 3: all");
 
+static int hw_changes_brightness = -1;
+module_param(hw_changes_brightness, int, 0644);
+MODULE_PARM_DESC(hw_changes_brightness,
+	"Set this to 1 on buggy hw which changes the brightness itself when "
+	"a hotkey is pressed: -1: auto, 0: normal 1: hw-changes-brightness");
+
 /*
  * Whether the struct acpi_video_device_attrib::device_id_scheme bit should be
  * assumed even if not actually set.
@@ -405,6 +411,14 @@ static int video_set_report_key_events(const struct dmi_system_id *id)
 	return 0;
 }
 
+static int video_hw_changes_brightness(
+	const struct dmi_system_id *d)
+{
+	if (hw_changes_brightness == -1)
+		hw_changes_brightness = 1;
+	return 0;
+}
+
 static const struct dmi_system_id video_dmi_table[] = {
 	/*
 	 * Broken _BQC workaround http://bugzilla.kernel.org/show_bug.cgi?id=13121
@@ -529,6 +543,21 @@ static const struct dmi_system_id video_dmi_table[] = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "Vostro V131"),
 		},
 	},
+	/*
+	 * Some machines change the brightness themselves when a brightness
+	 * hotkey gets pressed, despite us telling them not to. In this case
+	 * acpi_video_device_notify() should only call backlight_force_update(
+	 * BACKLIGHT_UPDATE_HOTKEY) and not do anything else.
+	 */
+	{
+	 /* https://bugzilla.kernel.org/show_bug.cgi?id=204077 */
+	 .callback = video_hw_changes_brightness,
+	 .ident = "Packard Bell EasyNote MZ35",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Packard Bell"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "EasyNote MZ35"),
+		},
+	},
 	{}
 };
 
@@ -1612,6 +1641,14 @@ static void acpi_video_device_notify(acpi_handle handle, u32 event, void *data)
 	bus = video_device->video;
 	input = bus->input;
 
+	if (hw_changes_brightness > 0) {
+		if (video_device->backlight)
+			backlight_force_update(video_device->backlight,
+					       BACKLIGHT_UPDATE_HOTKEY);
+		acpi_notifier_call_chain(device, event, 0);
+		return;
+	}
+
 	switch (event) {
 	case ACPI_VIDEO_NOTIFY_CYCLE_BRIGHTNESS:	/* Cycle brightness */
 		brightness_switch_event(video_device, event);
-- 
2.20.1



