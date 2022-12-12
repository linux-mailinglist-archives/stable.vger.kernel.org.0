Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6573564A15C
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbiLLNjV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:39:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbiLLNiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:38:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F00B14096
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:38:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C20461089
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FE8C433EF;
        Mon, 12 Dec 2022 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852286;
        bh=4GScXyhq651+QiSsEyMyZidQkBo8jWNDhH9jRyFz9Wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzBemds2xuwxw8TGtZnIjL3kairYhTnoNEYrXzf3B6ULW8WN1q2XeylMVUsfBDsWr
         pqKX0ons9Mhq8U927skUZy7M+QUd93gmhdRSCx6fy27KDnpGj5ipJbSZwdj/ns5j+z
         ZQBrFbAqFsxVUbacQE9U2X1ZvVsaL1vGYmabeea0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Luke D. Jones" <luke@ljones.dev>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 050/157] platform/x86: asus-wmi: Add support for ROG X13 tablet mode
Date:   Mon, 12 Dec 2022 14:16:38 +0100
Message-Id: <20221212130936.564281200@linuxfoundation.org>
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

[ Upstream commit e397c3c460bf3849384f2f55516d1887617cfca9 ]

Add quirk for ASUS ROG X13 Flow 2-in-1 to enable tablet mode with
lid flip (all screen rotations).

Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20220813092753.6635-2-luke@ljones.dev
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c         | 15 +++++++++
 drivers/platform/x86/asus-wmi.c            | 37 ++++++++++++++++++++++
 drivers/platform/x86/asus-wmi.h            |  1 +
 include/linux/platform_data/x86/asus-wmi.h |  1 +
 4 files changed, 54 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 4672a2b8322e..d9e7cf6e4a0e 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -123,6 +123,11 @@ static struct quirk_entry quirk_asus_use_lid_flip_devid = {
 	.tablet_switch_mode = asus_wmi_lid_flip_devid,
 };
 
+static struct quirk_entry quirk_asus_tablet_mode = {
+	.wmi_backlight_set_devstate = true,
+	.tablet_switch_mode = asus_wmi_lid_flip_rog_devid,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	pr_info("Identified laptop model '%s'\n", dmi->ident);
@@ -471,6 +476,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_use_lid_flip_devid,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS ROG FLOW X13",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GV301Q"),
+		},
+		.driver_data = &quirk_asus_tablet_mode,
+	},
 	{},
 };
 
@@ -578,6 +592,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0xC5, { KEY_KBDILLUMDOWN } },
 	{ KE_IGNORE, 0xC6, },  /* Ambient Light Sensor notification */
 	{ KE_KEY, 0xFA, { KEY_PROG2 } },           /* Lid flip action */
+	{ KE_KEY, 0xBD, { KEY_PROG2 } },           /* Lid flip action on ROG xflow laptops */
 	{ KE_END, 0},
 };
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 26f75c984448..dce93187e11f 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -68,6 +68,7 @@ module_param(fnlock_default, bool, 0444);
 #define NOTIFY_KBD_FBM			0x99
 #define NOTIFY_KBD_TTP			0xae
 #define NOTIFY_LID_FLIP			0xfa
+#define NOTIFY_LID_FLIP_ROG		0xbd
 
 #define ASUS_WMI_FNLOCK_BIOS_DISABLED	BIT(0)
 
@@ -533,6 +534,19 @@ static int asus_wmi_input_init(struct asus_wmi *asus)
 			dev_err(dev, "Error checking for lid-flip: %d\n", result);
 		}
 		break;
+	case asus_wmi_lid_flip_rog_devid:
+		result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP_ROG);
+		if (result < 0)
+			asus->driver->quirks->tablet_switch_mode = asus_wmi_no_tablet_switch;
+		if (result >= 0) {
+			input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
+			input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
+		} else if (result == -ENODEV) {
+			dev_err(dev, "This device has lid-flip-rog quirk but got ENODEV checking it. This is a bug.");
+		} else {
+			dev_err(dev, "Error checking for lid-flip: %d\n", result);
+		}
+		break;
 	}
 
 	err = input_register_device(asus->inputdev);
@@ -567,6 +581,17 @@ static void lid_flip_tablet_mode_get_state(struct asus_wmi *asus)
 	}
 }
 
+static void lid_flip_rog_tablet_mode_get_state(struct asus_wmi *asus)
+{
+	int result;
+
+	result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP_ROG);
+	if (result >= 0) {
+		input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
+		input_sync(asus->inputdev);
+	}
+}
+
 /* dGPU ********************************************************************/
 static int dgpu_disable_check_present(struct asus_wmi *asus)
 {
@@ -3134,6 +3159,12 @@ static void asus_wmi_handle_event_code(int code, struct asus_wmi *asus)
 		return;
 	}
 
+	if (asus->driver->quirks->tablet_switch_mode == asus_wmi_lid_flip_rog_devid &&
+	    code == NOTIFY_LID_FLIP_ROG) {
+		lid_flip_rog_tablet_mode_get_state(asus);
+		return;
+	}
+
 	if (asus->fan_boost_mode_available && code == NOTIFY_KBD_FBM) {
 		fan_boost_mode_switch_next(asus);
 		return;
@@ -3773,6 +3804,9 @@ static int asus_hotk_resume(struct device *device)
 	case asus_wmi_lid_flip_devid:
 		lid_flip_tablet_mode_get_state(asus);
 		break;
+	case asus_wmi_lid_flip_rog_devid:
+		lid_flip_rog_tablet_mode_get_state(asus);
+		break;
 	}
 
 	return 0;
@@ -3821,6 +3855,9 @@ static int asus_hotk_restore(struct device *device)
 	case asus_wmi_lid_flip_devid:
 		lid_flip_tablet_mode_get_state(asus);
 		break;
+	case asus_wmi_lid_flip_rog_devid:
+		lid_flip_rog_tablet_mode_get_state(asus);
+		break;
 	}
 
 	return 0;
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 413920bad0c6..0187f13d2414 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -29,6 +29,7 @@ enum asus_wmi_tablet_switch_mode {
 	asus_wmi_no_tablet_switch,
 	asus_wmi_kbd_dock_devid,
 	asus_wmi_lid_flip_devid,
+	asus_wmi_lid_flip_rog_devid,
 };
 
 struct quirk_entry {
diff --git a/include/linux/platform_data/x86/asus-wmi.h b/include/linux/platform_data/x86/asus-wmi.h
index 98f2b2f20f3e..7c96db7f3060 100644
--- a/include/linux/platform_data/x86/asus-wmi.h
+++ b/include/linux/platform_data/x86/asus-wmi.h
@@ -65,6 +65,7 @@
 #define ASUS_WMI_DEVID_PANEL_OD		0x00050019
 #define ASUS_WMI_DEVID_CAMERA		0x00060013
 #define ASUS_WMI_DEVID_LID_FLIP		0x00060062
+#define ASUS_WMI_DEVID_LID_FLIP_ROG	0x00060077
 
 /* Storage */
 #define ASUS_WMI_DEVID_CARDREADER	0x00080013
-- 
2.35.1



