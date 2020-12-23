Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FD72E17A8
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgLWDMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:12:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgLWCRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:17:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5854221FF;
        Wed, 23 Dec 2020 02:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689796;
        bh=2Rfq4J6f4OJcIaajTG5vY907c295N61M8VpTD+L7pOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qjmnBMmEJy5bRwj0HxJn59Gc+evMQSSLeEpoLAXTvOGh3ZEE8YjUFJv2x/80kwjQy
         XL2o0Seo7iKgvrBIwfDMBJ19+XOIeAtrRuepcKIVV5RvCHLqAQ1N7Ev3VUiPBsxTJX
         Q37wb5B7Eibe2zVvwRoeqywsgkRH0wF+moRx39vjRP6Ck1EbEEyVDuILBlxSeZPgoY
         tSwmxqHyIgq7Md46/GzOVv78LrSj3lr3RyLTk6Bzx9LE93E6tvZ7D03aHMYEe43aTU
         U5yY6OViy8WAEGP7Uu5hHU8wZsUJ84dVBJeWl7oplCROrzB5pkk/zhcNP2dCVjrfwH
         KYLWOC3jqF4Ew==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 007/217] platform/x86: asus-wmi: Add support for SW_TABLET_MODE on UX360
Date:   Tue, 22 Dec 2020 21:12:56 -0500
Message-Id: <20201223021626.2790791-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Čavoj <samuel@cavoj.net>

[ Upstream commit ea856ec266c1e6aecd2b107032d5b5d661f0686d ]

The UX360CA has a WMI device id 0x00060062, which reports whether the
lid is flipped in tablet mode (1) or in normal laptop mode (0).

Add a quirk (quirk_asus_use_lid_flip_devid) for devices on which this
WMI device should be used to figure out the SW_TABLET_MODE state, as
opposed to the quirk_asus_use_kbd_dock_devid.

Additionally, the device needs to be queried on resume and restore
because the firmware does not generate an event if the laptop is put to
sleep while in tablet mode, flipped to normal mode, and later awoken.

It is assumed other UX360* models have the same WMI device. As such, the
quirk is applied to devices with DMI_MATCH(DMI_PRODUCT_NAME, "UX360").
More devices with this feature need to be tested and added accordingly.

The reason for using an allowlist via the quirk mechanism is that the new
WMI device (0x00060062) is also present on some models which do not have
a 360 degree hinge (at least FX503VD and GL503VD from Hans' DSTS
collection) and therefore its presence cannot be relied on.

Signed-off-by: Samuel Čavoj <samuel@cavoj.net>
Cc: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201020220944.1075530-1-samuel@cavoj.net
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c         | 15 ++++++++
 drivers/platform/x86/asus-wmi.c            | 40 ++++++++++++++++++++++
 drivers/platform/x86/asus-wmi.h            |  1 +
 include/linux/platform_data/x86/asus-wmi.h |  1 +
 4 files changed, 57 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 1d9fbabd02fb7..d41d7ad14be0d 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -119,6 +119,11 @@ static struct quirk_entry quirk_asus_use_kbd_dock_devid = {
 	.use_kbd_dock_devid = true,
 };
 
+static struct quirk_entry quirk_asus_use_lid_flip_devid = {
+	.wmi_backlight_set_devstate = true,
+	.use_lid_flip_devid = true,
+};
+
 static int dmi_matched(const struct dmi_system_id *dmi)
 {
 	pr_info("Identified laptop model '%s'\n", dmi->ident);
@@ -520,6 +525,16 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_use_kbd_dock_devid,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS ZenBook Flip UX360",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			/* Match UX360* */
+			DMI_MATCH(DMI_PRODUCT_NAME, "UX360"),
+		},
+		.driver_data = &quirk_asus_use_lid_flip_devid,
+	},
 	{},
 };
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 39e1a6396e08d..fa884c418f4ea 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -63,6 +63,7 @@ MODULE_LICENSE("GPL");
 #define NOTIFY_KBD_BRTTOGGLE		0xc7
 #define NOTIFY_KBD_FBM			0x99
 #define NOTIFY_KBD_TTP			0xae
+#define NOTIFY_LID_FLIP			0xfa
 
 #define ASUS_WMI_FNLOCK_BIOS_DISABLED	BIT(0)
 
@@ -375,6 +376,20 @@ static int asus_wmi_input_init(struct asus_wmi *asus)
 		}
 	}
 
+	if (asus->driver->quirks->use_lid_flip_devid) {
+		result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP);
+		if (result < 0)
+			asus->driver->quirks->use_lid_flip_devid = 0;
+		if (result >= 0) {
+			input_set_capability(asus->inputdev, EV_SW, SW_TABLET_MODE);
+			input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
+		} else if (result == -ENODEV) {
+			pr_err("This device has lid_flip quirk but got ENODEV checking it. This is a bug.");
+		} else {
+			pr_err("Error checking for lid-flip: %d\n", result);
+		}
+	}
+
 	err = input_register_device(asus->inputdev);
 	if (err)
 		goto err_free_dev;
@@ -394,6 +409,18 @@ static void asus_wmi_input_exit(struct asus_wmi *asus)
 	asus->inputdev = NULL;
 }
 
+/* Tablet mode ****************************************************************/
+
+static void lid_flip_tablet_mode_get_state(struct asus_wmi *asus)
+{
+	int result = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_LID_FLIP);
+
+	if (result >= 0) {
+		input_report_switch(asus->inputdev, SW_TABLET_MODE, result);
+		input_sync(asus->inputdev);
+	}
+}
+
 /* Battery ********************************************************************/
 
 /* The battery maximum charging percentage */
@@ -2128,6 +2155,11 @@ static void asus_wmi_handle_event_code(int code, struct asus_wmi *asus)
 		return;
 	}
 
+	if (asus->driver->quirks->use_lid_flip_devid && code == NOTIFY_LID_FLIP) {
+		lid_flip_tablet_mode_get_state(asus);
+		return;
+	}
+
 	if (asus->fan_boost_mode_available && code == NOTIFY_KBD_FBM) {
 		fan_boost_mode_switch_next(asus);
 		return;
@@ -2719,6 +2751,10 @@ static int asus_hotk_resume(struct device *device)
 
 	if (asus_wmi_has_fnlock_key(asus))
 		asus_wmi_fnlock_update(asus);
+
+	if (asus->driver->quirks->use_lid_flip_devid)
+		lid_flip_tablet_mode_get_state(asus);
+
 	return 0;
 }
 
@@ -2757,6 +2793,10 @@ static int asus_hotk_restore(struct device *device)
 
 	if (asus_wmi_has_fnlock_key(asus))
 		asus_wmi_fnlock_update(asus);
+
+	if (asus->driver->quirks->use_lid_flip_devid)
+		lid_flip_tablet_mode_get_state(asus);
+
 	return 0;
 }
 
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 1a95c172f94b0..b302415bf1d95 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -34,6 +34,7 @@ struct quirk_entry {
 	bool wmi_backlight_set_devstate;
 	bool wmi_force_als_set;
 	bool use_kbd_dock_devid;
+	bool use_lid_flip_devid;
 	int wapf;
 	/*
 	 * For machines with AMD graphic chips, it will send out WMI event
diff --git a/include/linux/platform_data/x86/asus-wmi.h b/include/linux/platform_data/x86/asus-wmi.h
index 897b8332a39f4..2f274cf528050 100644
--- a/include/linux/platform_data/x86/asus-wmi.h
+++ b/include/linux/platform_data/x86/asus-wmi.h
@@ -62,6 +62,7 @@
 
 /* Misc */
 #define ASUS_WMI_DEVID_CAMERA		0x00060013
+#define ASUS_WMI_DEVID_LID_FLIP		0x00060062
 
 /* Storage */
 #define ASUS_WMI_DEVID_CARDREADER	0x00080013
-- 
2.27.0

