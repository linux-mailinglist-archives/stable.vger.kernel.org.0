Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C1764A15B
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbiLLNjS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232905AbiLLNiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:38:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4B91409E
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:38:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 82649CE0F7F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DC9C433EF;
        Mon, 12 Dec 2022 13:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852281;
        bh=ot5abapp/2gERYLXTOKwY3Ew2RAkE/IYRjoQrHYDAK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUofMtZ7vONrj6ly0CmGUUbx0VGJ4nw/0UtyrHug2AE3N5ZRkiHc8MsnloGCZrWFk
         Ei280y/NAiDmPzWpnIFcU5Ctz8oal9t9R55MsF4IftrmjIwK37Eil/OaNYh8JiAf2I
         zacyWEaTEbdXN42Wen5J1kjLvQSWrLN7dIMznDG4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Luke D. Jones" <luke@ljones.dev>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 049/157] platform/x86: asus-wmi: Adjust tablet/lidflip handling to use enum
Date:   Mon, 12 Dec 2022 14:16:37 +0100
Message-Id: <20221212130936.523235179@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit 00aa846955fbfb04f7bc0c26c49febfe5395eca1 ]

Due to multiple types of tablet/lidflip, the existing code for
handling these events is refactored to use an enum for each type.

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20220813092753.6635-1-luke@ljones.dev
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: e397c3c460bf ("platform/x86: asus-wmi: Add support for ROG X13 tablet mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 13 +++-----
 drivers/platform/x86/asus-wmi.c    | 49 +++++++++++++++++++++---------
 drivers/platform/x86/asus-wmi.h    |  9 ++++--
 3 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 478dd300b9c9..4672a2b8322e 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -115,12 +115,12 @@ static struct quirk_entry quirk_asus_forceals = {
 };
 
 static struct quirk_entry quirk_asus_use_kbd_dock_devid = {
-	.use_kbd_dock_devid = true,
+	.tablet_switch_mode = asus_wmi_kbd_dock_devid,
 };
 
 static struct quirk_entry quirk_asus_use_lid_flip_devid = {
 	.wmi_backlight_set_devstate = true,
-	.use_lid_flip_devid = true,
+	.tablet_switch_mode = asus_wmi_lid_flip_devid,
 };
 
 static int dmi_matched(const struct dmi_system_id *dmi)
@@ -492,16 +492,13 @@ static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 
 	switch (tablet_mode_sw) {
 	case 0:
-		quirks->use_kbd_dock_devid = false;
-		quirks->use_lid_flip_devid = false;
+		quirks->tablet_switch_mode = asus_wmi_no_tablet_switch;
 		break;
 	case 1:
-		quirks->use_kbd_dock_devid = true;
-		quirks->use_lid_flip_devid = false;
+		quirks->tablet_switch_mode = asus_wmi_kbd_dock_devid;
 		break;
 	case 2:
-		quirks->use_kbd_dock_devid = false;
-		quirks->use_lid_flip_devid = true;
+		quirks->tablet_switch_mode = asus_wmi_lid_flip_devid;
 		break;
 	}
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 8e1979b477a7..26f75c984448 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -489,8 +489,11 @@ static bool asus_wmi_dev_is_present(struct asus_wmi *asus, u32 dev_id)
 
 static int asus_wmi_input_init(struct asus_wmi *asus)
 {
+	struct device *dev;
 	int err, result;
 
+	dev = &asus->platform_device->dev;
+
 	asus->inputdev = input_allocate_device();
 	if (!asus->inputdev)
 		return -ENOMEM;
@@ -498,35 +501,38 @@ static int asus_wmi_input_init(struct asus_wmi *asus)
 	asus->inputdev->name = asus->driver->input_name;
 	asus->inputdev->phys = asus->driver->input_phys;
 	asus->inputdev->id.bustype = BUS_HOST;
-	asus->inputdev->dev.parent = &asus->platform_device->dev;
+	asus->inputdev->dev.parent = dev;
 	set_bit(EV_REP, asus->inputdev->evbit);
 
 	err = sparse_keymap_setup(asus->inputdev, asus->driver->keymap, NULL);
 	if (err)
 		goto err_free_dev;
 
-	if (asus->driver->quirks->use_kbd_dock_devid) {
+	switch (asus->driver->quirks->tablet_switch_mode) {
+	case asus_wmi_no_tablet_switch:
+		break;
+	case asus_wmi_kbd_dock_devid:
 		result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_KBD_DOCK);
 		if (result >= 0) {
 			input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
 			input_report_switch(asus->inputdev, SW_TABLET_MODE, !result);
 		} else if (result != -ENODEV) {
-			pr_err("Error checking for keyboard-dock: %d\n", result);
+			dev_err(dev, "Error checking for keyboard-dock: %d\n", result);
 		}
-	}
-
-	if (asus->driver->quirks->use_lid_flip_devid) {
+		break;
+	case asus_wmi_lid_flip_devid:
 		result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP);
 		if (result < 0)
-			asus->driver->quirks->use_lid_flip_devid = 0;
+			asus->driver->quirks->tablet_switch_mode = asus_wmi_no_tablet_switch;
 		if (result >= 0) {
 			input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
 			input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
 		} else if (result == -ENODEV) {
-			pr_err("This device has lid_flip quirk but got ENODEV checking it. This is a bug.");
+			dev_err(dev, "This device has lid_flip quirk but got ENODEV checking it. This is a bug.");
 		} else {
-			pr_err("Error checking for lid-flip: %d\n", result);
+			dev_err(dev, "Error checking for lid-flip: %d\n", result);
 		}
+		break;
 	}
 
 	err = input_register_device(asus->inputdev);
@@ -552,8 +558,9 @@ static void asus_wmi_input_exit(struct asus_wmi *asus)
 
 static void lid_flip_tablet_mode_get_state(struct asus_wmi *asus)
 {
-	int result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP);
+	int result;
 
+	result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP);
 	if (result >= 0) {
 		input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
 		input_sync(asus->inputdev);
@@ -3109,7 +3116,8 @@ static void asus_wmi_handle_event_code(int code, struct asus_wmi *asus)
 		return;
 	}
 
-	if (asus->driver->quirks->use_kbd_dock_devid && code == NOTIFY_KBD_DOCK_CHANGE) {
+	if (asus->driver->quirks->tablet_switch_mode == asus_wmi_kbd_dock_devid &&
+	    code == NOTIFY_KBD_DOCK_CHANGE) {
 		result = asus_wmi_get_devstate_simple(asus,
 						      ASUS_WMI_DEVID_KBD_DOCK);
 		if (result >= 0) {
@@ -3120,7 +3128,8 @@ static void asus_wmi_handle_event_code(int code, struct asus_wmi *asus)
 		return;
 	}
 
-	if (asus->driver->quirks->use_lid_flip_devid && code == NOTIFY_LID_FLIP) {
+	if (asus->driver->quirks->tablet_switch_mode == asus_wmi_lid_flip_devid &&
+	    code == NOTIFY_LID_FLIP) {
 		lid_flip_tablet_mode_get_state(asus);
 		return;
 	}
@@ -3757,8 +3766,14 @@ static int asus_hotk_resume(struct device *device)
 	if (asus_wmi_has_fnlock_key(asus))
 		asus_wmi_fnlock_update(asus);
 
-	if (asus->driver->quirks->use_lid_flip_devid)
+	switch (asus->driver->quirks->tablet_switch_mode) {
+	case asus_wmi_no_tablet_switch:
+	case asus_wmi_kbd_dock_devid:
+		break;
+	case asus_wmi_lid_flip_devid:
 		lid_flip_tablet_mode_get_state(asus);
+		break;
+	}
 
 	return 0;
 }
@@ -3799,8 +3814,14 @@ static int asus_hotk_restore(struct device *device)
 	if (asus_wmi_has_fnlock_key(asus))
 		asus_wmi_fnlock_update(asus);
 
-	if (asus->driver->quirks->use_lid_flip_devid)
+	switch (asus->driver->quirks->tablet_switch_mode) {
+	case asus_wmi_no_tablet_switch:
+	case asus_wmi_kbd_dock_devid:
+		break;
+	case asus_wmi_lid_flip_devid:
 		lid_flip_tablet_mode_get_state(asus);
+		break;
+	}
 
 	return 0;
 }
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index b302415bf1d9..413920bad0c6 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -25,6 +25,12 @@ struct module;
 struct key_entry;
 struct asus_wmi;
 
+enum asus_wmi_tablet_switch_mode {
+	asus_wmi_no_tablet_switch,
+	asus_wmi_kbd_dock_devid,
+	asus_wmi_lid_flip_devid,
+};
+
 struct quirk_entry {
 	bool hotplug_wireless;
 	bool scalar_panel_brightness;
@@ -33,8 +39,7 @@ struct quirk_entry {
 	bool wmi_backlight_native;
 	bool wmi_backlight_set_devstate;
 	bool wmi_force_als_set;
-	bool use_kbd_dock_devid;
-	bool use_lid_flip_devid;
+	enum asus_wmi_tablet_switch_mode tablet_switch_mode;
 	int wapf;
 	/*
 	 * For machines with AMD graphic chips, it will send out WMI event
-- 
2.35.1



