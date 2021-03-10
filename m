Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1948C333DF4
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhCJNZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:46084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232910AbhCJNYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A45F64FDA;
        Wed, 10 Mar 2021 13:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382680;
        bh=YvgajY/lVqGmMKTtIn92RfSxKE6dqCsFl1pX0dGH06Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgmIwDg+Zdvpk+K59a4JYRCB/CaGlt3jYWqWHMQ80JUwUMqjzJyuygq5Bboe1SdzZ
         zRgn5+OliX1xal8FsBghB1pl7b7QYBIGC3WQsdScXrdoX59hro5pmeQ8Lhb1GaH0k6
         i1iaG5iGPosTncu1Wy3MX7qpJkVYExsVu85kJwpw=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/49] platform/x86: acer-wmi: Add support for SW_TABLET_MODE on Switch devices
Date:   Wed, 10 Mar 2021 14:23:30 +0100
Message-Id: <20210310132322.566512132@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5c54cb6c627e8f50f490e6b5656051a5ac29eab4 ]

Add support for SW_TABLET_MODE on the Acer Switch 10 (SW5-012) and the
acer Switch 10 (S1003) models.

There is no way to detect if this is supported, so this uses DMI based
quirks setting force_caps to ACER_CAP_KBD_DOCK (these devices have no
other acer-wmi based functionality).

The new SW_TABLET_MODE functionality can be tested on devices which
are not in the DMI table by passing acer_wmi.force_caps=0x40 on the
kernel commandline.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201019185628.264473-6-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 109 +++++++++++++++++++++++++++++++-
 1 file changed, 106 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 8662468491a3..1efca84bc1bd 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -30,6 +30,7 @@
 #include <linux/input/sparse-keymap.h>
 #include <acpi/video.h>
 
+ACPI_MODULE_NAME(KBUILD_MODNAME);
 MODULE_AUTHOR("Carlos Corbacho");
 MODULE_DESCRIPTION("Acer Laptop WMI Extras Driver");
 MODULE_LICENSE("GPL");
@@ -80,7 +81,7 @@ MODULE_ALIAS("wmi:676AA15E-6A47-4D9F-A2CC-1E6D18D14026");
 
 enum acer_wmi_event_ids {
 	WMID_HOTKEY_EVENT = 0x1,
-	WMID_ACCEL_EVENT = 0x5,
+	WMID_ACCEL_OR_KBD_DOCK_EVENT = 0x5,
 };
 
 static const struct key_entry acer_wmi_keymap[] __initconst = {
@@ -128,7 +129,9 @@ struct event_return_value {
 	u8 function;
 	u8 key_num;
 	u16 device_state;
-	u32 reserved;
+	u16 reserved1;
+	u8 kbd_dock_state;
+	u8 reserved2;
 } __attribute__((packed));
 
 /*
@@ -212,6 +215,7 @@ struct hotkey_function_type_aa {
 #define ACER_CAP_BRIGHTNESS		BIT(3)
 #define ACER_CAP_THREEG			BIT(4)
 #define ACER_CAP_SET_FUNCTION_MODE	BIT(5)
+#define ACER_CAP_KBD_DOCK		BIT(6)
 
 /*
  * Interface type flags
@@ -320,6 +324,15 @@ static int __init dmi_matched(const struct dmi_system_id *dmi)
 	return 1;
 }
 
+static int __init set_force_caps(const struct dmi_system_id *dmi)
+{
+	if (force_caps == -1) {
+		force_caps = (uintptr_t)dmi->driver_data;
+		pr_info("Found %s, set force_caps to 0x%x\n", dmi->ident, force_caps);
+	}
+	return 1;
+}
+
 static struct quirk_entry quirk_unknown = {
 };
 
@@ -498,6 +511,24 @@ static const struct dmi_system_id acer_quirks[] __initconst = {
 		},
 		.driver_data = &quirk_acer_travelmate_2490,
 	},
+	{
+		.callback = set_force_caps,
+		.ident = "Acer Aspire Switch 10 SW5-012",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire SW5-012"),
+		},
+		.driver_data = (void *)ACER_CAP_KBD_DOCK,
+	},
+	{
+		.callback = set_force_caps,
+		.ident = "Acer One 10 (S1003)",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "One S1003"),
+		},
+		.driver_data = (void *)ACER_CAP_KBD_DOCK,
+	},
 	{}
 };
 
@@ -1542,6 +1573,71 @@ static int acer_gsensor_event(void)
 	return 0;
 }
 
+/*
+ * Switch series keyboard dock status
+ */
+static int acer_kbd_dock_state_to_sw_tablet_mode(u8 kbd_dock_state)
+{
+	switch (kbd_dock_state) {
+	case 0x01: /* Docked, traditional clamshell laptop mode */
+		return 0;
+	case 0x04: /* Stand-alone tablet */
+	case 0x40: /* Docked, tent mode, keyboard not usable */
+		return 1;
+	default:
+		pr_warn("Unknown kbd_dock_state 0x%02x\n", kbd_dock_state);
+	}
+
+	return 0;
+}
+
+static void acer_kbd_dock_get_initial_state(void)
+{
+	u8 *output, input[8] = { 0x05, 0x00, };
+	struct acpi_buffer input_buf = { sizeof(input), input };
+	struct acpi_buffer output_buf = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *obj;
+	acpi_status status;
+	int sw_tablet_mode;
+
+	status = wmi_evaluate_method(WMID_GUID3, 0, 0x2, &input_buf, &output_buf);
+	if (ACPI_FAILURE(status)) {
+		ACPI_EXCEPTION((AE_INFO, status, "Error getting keyboard-dock initial status"));
+		return;
+	}
+
+	obj = output_buf.pointer;
+	if (!obj || obj->type != ACPI_TYPE_BUFFER || obj->buffer.length != 8) {
+		pr_err("Unexpected output format getting keyboard-dock initial status\n");
+		goto out_free_obj;
+	}
+
+	output = obj->buffer.pointer;
+	if (output[0] != 0x00 || (output[3] != 0x05 && output[3] != 0x45)) {
+		pr_err("Unexpected output [0]=0x%02x [3]=0x%02x getting keyboard-dock initial status\n",
+		       output[0], output[3]);
+		goto out_free_obj;
+	}
+
+	sw_tablet_mode = acer_kbd_dock_state_to_sw_tablet_mode(output[4]);
+	input_report_switch(acer_wmi_input_dev, SW_TABLET_MODE, sw_tablet_mode);
+
+out_free_obj:
+	kfree(obj);
+}
+
+static void acer_kbd_dock_event(const struct event_return_value *event)
+{
+	int sw_tablet_mode;
+
+	if (!has_cap(ACER_CAP_KBD_DOCK))
+		return;
+
+	sw_tablet_mode = acer_kbd_dock_state_to_sw_tablet_mode(event->kbd_dock_state);
+	input_report_switch(acer_wmi_input_dev, SW_TABLET_MODE, sw_tablet_mode);
+	input_sync(acer_wmi_input_dev);
+}
+
 /*
  * Rfkill devices
  */
@@ -1769,8 +1865,9 @@ static void acer_wmi_notify(u32 value, void *context)
 			sparse_keymap_report_event(acer_wmi_input_dev, scancode, 1, true);
 		}
 		break;
-	case WMID_ACCEL_EVENT:
+	case WMID_ACCEL_OR_KBD_DOCK_EVENT:
 		acer_gsensor_event();
+		acer_kbd_dock_event(&return_value);
 		break;
 	default:
 		pr_warn("Unknown function number - %d - %d\n",
@@ -1935,6 +2032,9 @@ static int __init acer_wmi_input_setup(void)
 	if (err)
 		goto err_free_dev;
 
+	if (has_cap(ACER_CAP_KBD_DOCK))
+		input_set_capability(acer_wmi_input_dev, EV_SW, SW_TABLET_MODE);
+
 	status = wmi_install_notify_handler(ACERWMID_EVENT_GUID,
 						acer_wmi_notify, NULL);
 	if (ACPI_FAILURE(status)) {
@@ -1942,6 +2042,9 @@ static int __init acer_wmi_input_setup(void)
 		goto err_free_dev;
 	}
 
+	if (has_cap(ACER_CAP_KBD_DOCK))
+		acer_kbd_dock_get_initial_state();
+
 	err = input_register_device(acer_wmi_input_dev);
 	if (err)
 		goto err_uninstall_notifier;
-- 
2.30.1



