Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393853EE104
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 02:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235487AbhHQAgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 20:36:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235457AbhHQAgP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02CFD60F58;
        Tue, 17 Aug 2021 00:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160542;
        bh=/HcD1gZjW68MD8xhS0+XUFDfAo6EZrmRC8YzTyDeRH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBbfbUVZ4hcDsBT1mekWiwsiQ1IwPn3juWOELD86n6qlD2aVbY2UBOBzOFpKzgOua
         jYfQ3pSIt8LEvlIy+zqMs69MgWPtmP3pxLZQPLRnbJ9oclvwfwcrqrMVDYZkCis/7F
         pO5CiX5Zxqp+Z3BQW6It+5zh2hY3sMMaEO/kNNKqd7kPgFQxKjOD3Yhz9IyaXTLW2U
         Ki5sg5eLC6YuYhWe780ydI0PXatlmaFJs3uatsOb/beI/iGvqNdI8h91t9XbPUR90j
         6kRioCKnqy7Bh3zSe20iZaH9omYq5JFEg2QqaMhkYLmAEMbYY0nJO4k4gCK+k99Yw7
         OvTVUoE0sxrJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Julius Lehmann <julius@devpi.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.13 04/12] platform/x86: Add and use a dual_accel_detect() helper
Date:   Mon, 16 Aug 2021 20:35:28 -0400
Message-Id: <20210817003536.83063-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003536.83063-1-sashal@kernel.org>
References: <20210817003536.83063-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 153cca9caa81ca8912a70528daca4b9a523c6898 ]

Various 360 degree hinges (yoga) style 2-in-1 devices use 2 accelerometers
to allow the OS to determine the angle between the display and the base of
the device.

On Windows these are read by a special HingeAngleService process which
calls undocumented ACPI methods, to let the firmware know if the 2-in-1 is
in tablet- or laptop-mode. The firmware may use this to disable the kbd and
touchpad to avoid spurious input in tablet-mode as well as to report
SW_TABLET_MODE info to the OS.

Since Linux does not call these undocumented methods, the SW_TABLET_MODE
info reported by various pdx86 drivers is incorrect on these devices.

Before this commit the intel-hid and thinkpad_acpi code already had 2
hardcoded checks for ACPI hardware-ids of dual-accel sensors to avoid
reporting broken info.

And now we also have a bug-report about the same problem in the intel-vbtn
code. Since there are at least 3 different ACPI hardware-ids in play, add
a new dual_accel_detect() helper which checks for all 3, rather then
adding different hardware-ids to the drivers as bug-reports trickle in.
Having shared code which checks all known hardware-ids is esp. important
for the intel-hid and intel-vbtn drivers as these are generic drivers
which are used on a lot of devices.

The BOSC0200 hardware-id requires special handling, because often it is
used for a single-accelerometer setup. Only in a few cases it refers to
a dual-accel setup, in which case there will be 2 I2cSerialBus resources
in the device's resource-list, so the helper checks for this.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=209011
Reported-and-tested-by: Julius Lehmann <julius@devpi.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20210729082134.6683-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig             |  3 +
 drivers/platform/x86/dual_accel_detect.h | 75 ++++++++++++++++++++++++
 drivers/platform/x86/intel-hid.c         | 21 ++-----
 drivers/platform/x86/intel-vbtn.c        | 18 +++++-
 drivers/platform/x86/thinkpad_acpi.c     |  3 +-
 5 files changed, 101 insertions(+), 19 deletions(-)
 create mode 100644 drivers/platform/x86/dual_accel_detect.h

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 60592fb88e7a..e878ac192758 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -507,6 +507,7 @@ config THINKPAD_ACPI
 	depends on RFKILL || RFKILL = n
 	depends on ACPI_VIDEO || ACPI_VIDEO = n
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on I2C
 	select ACPI_PLATFORM_PROFILE
 	select HWMON
 	select NVRAM
@@ -701,6 +702,7 @@ config INTEL_HID_EVENT
 	tristate "INTEL HID Event"
 	depends on ACPI
 	depends on INPUT
+	depends on I2C
 	select INPUT_SPARSEKMAP
 	help
 	  This driver provides support for the Intel HID Event hotkey interface.
@@ -752,6 +754,7 @@ config INTEL_VBTN
 	tristate "INTEL VIRTUAL BUTTON"
 	depends on ACPI
 	depends on INPUT
+	depends on I2C
 	select INPUT_SPARSEKMAP
 	help
 	  This driver provides support for the Intel Virtual Button interface.
diff --git a/drivers/platform/x86/dual_accel_detect.h b/drivers/platform/x86/dual_accel_detect.h
new file mode 100644
index 000000000000..1a069159da91
--- /dev/null
+++ b/drivers/platform/x86/dual_accel_detect.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Helper code to detect 360 degree hinges (yoga) style 2-in-1 devices using 2 accelerometers
+ * to allow the OS to determine the angle between the display and the base of the device.
+ *
+ * On Windows these are read by a special HingeAngleService process which calls undocumented
+ * ACPI methods, to let the firmware know if the 2-in-1 is in tablet- or laptop-mode.
+ * The firmware may use this to disable the kbd and touchpad to avoid spurious input in
+ * tablet-mode as well as to report SW_TABLET_MODE info to the OS.
+ *
+ * Since Linux does not call these undocumented methods, the SW_TABLET_MODE info reported
+ * by various drivers/platform/x86 drivers is incorrect. These drivers use the detection
+ * code in this file to disable SW_TABLET_MODE reporting to avoid reporting broken info
+ * (instead userspace can derive the status itself by directly reading the 2 accels).
+ */
+
+#include <linux/acpi.h>
+#include <linux/i2c.h>
+
+static int dual_accel_i2c_resource_count(struct acpi_resource *ares, void *data)
+{
+	struct acpi_resource_i2c_serialbus *sb;
+	int *count = data;
+
+	if (i2c_acpi_get_i2c_resource(ares, &sb))
+		*count = *count + 1;
+
+	return 1;
+}
+
+static int dual_accel_i2c_client_count(struct acpi_device *adev)
+{
+	int ret, count = 0;
+	LIST_HEAD(r);
+
+	ret = acpi_dev_get_resources(adev, &r, dual_accel_i2c_resource_count, &count);
+	if (ret < 0)
+		return ret;
+
+	acpi_dev_free_resource_list(&r);
+	return count;
+}
+
+static bool dual_accel_detect_bosc0200(void)
+{
+	struct acpi_device *adev;
+	int count;
+
+	adev = acpi_dev_get_first_match_dev("BOSC0200", NULL, -1);
+	if (!adev)
+		return false;
+
+	count = dual_accel_i2c_client_count(adev);
+
+	acpi_dev_put(adev);
+
+	return count == 2;
+}
+
+static bool dual_accel_detect(void)
+{
+	/* Systems which use a pair of accels with KIOX010A / KIOX020A ACPI ids */
+	if (acpi_dev_present("KIOX010A", NULL, -1))
+		return true;
+
+	/* Systems which use a single DUAL250E ACPI device to model 2 accels */
+	if (acpi_dev_present("DUAL250E", NULL, -1))
+		return true;
+
+	/* Systems which use a single BOSC0200 ACPI device to model 2 accels */
+	if (dual_accel_detect_bosc0200())
+		return true;
+
+	return false;
+}
diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index 078648a9201b..7135d720af60 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/suspend.h>
+#include "dual_accel_detect.h"
 
 /* When NOT in tablet mode, VGBS returns with the flag 0x40 */
 #define TABLET_MODE_FLAG BIT(6)
@@ -121,6 +122,7 @@ struct intel_hid_priv {
 	struct input_dev *array;
 	struct input_dev *switches;
 	bool wakeup_mode;
+	bool dual_accel;
 };
 
 #define HID_EVENT_FILTER_UUID	"eeec56b3-4442-408f-a792-4edd4d758054"
@@ -450,22 +452,9 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 	 * SW_TABLET_MODE report, in these cases we enable support when receiving
 	 * the first event instead of during driver setup.
 	 *
-	 * Some 360 degree hinges (yoga) style 2-in-1 devices use 2 accelerometers
-	 * to allow the OS to determine the angle between the display and the base
-	 * of the device. On Windows these are read by a special HingeAngleService
-	 * process which calls an ACPI DSM (Device Specific Method) on the
-	 * ACPI KIOX010A device node for the sensor in the display, to let the
-	 * firmware know if the 2-in-1 is in tablet- or laptop-mode so that it can
-	 * disable the kbd and touchpad to avoid spurious input in tablet-mode.
-	 *
-	 * The linux kxcjk1013 driver calls the DSM for this once at probe time
-	 * to ensure that the builtin kbd and touchpad work. On some devices this
-	 * causes a "spurious" 0xcd event on the intel-hid ACPI dev. In this case
-	 * there is not a functional tablet-mode switch, so we should not register
-	 * the tablet-mode switch device.
+	 * See dual_accel_detect.h for more info on the dual_accel check.
 	 */
-	if (!priv->switches && (event == 0xcc || event == 0xcd) &&
-	    !acpi_dev_present("KIOX010A", NULL, -1)) {
+	if (!priv->switches && !priv->dual_accel && (event == 0xcc || event == 0xcd)) {
 		dev_info(&device->dev, "switch event received, enable switches supports\n");
 		err = intel_hid_switches_setup(device);
 		if (err)
@@ -606,6 +595,8 @@ static int intel_hid_probe(struct platform_device *device)
 		return -ENOMEM;
 	dev_set_drvdata(&device->dev, priv);
 
+	priv->dual_accel = dual_accel_detect();
+
 	err = intel_hid_input_setup(device);
 	if (err) {
 		pr_err("Failed to setup Intel HID hotkeys\n");
diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 888a764efad1..309166431063 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/suspend.h>
+#include "dual_accel_detect.h"
 
 /* Returned when NOT in tablet mode on some HP Stream x360 11 models */
 #define VGBS_TABLET_MODE_FLAG_ALT	0x10
@@ -66,6 +67,7 @@ static const struct key_entry intel_vbtn_switchmap[] = {
 struct intel_vbtn_priv {
 	struct input_dev *buttons_dev;
 	struct input_dev *switches_dev;
+	bool dual_accel;
 	bool has_buttons;
 	bool has_switches;
 	bool wakeup_mode;
@@ -160,6 +162,10 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 		input_dev = priv->buttons_dev;
 	} else if ((ke = sparse_keymap_entry_from_scancode(priv->switches_dev, event))) {
 		if (!priv->has_switches) {
+			/* See dual_accel_detect.h for more info */
+			if (priv->dual_accel)
+				return;
+
 			dev_info(&device->dev, "Registering Intel Virtual Switches input-dev after receiving a switch event\n");
 			ret = input_register_device(priv->switches_dev);
 			if (ret)
@@ -248,11 +254,15 @@ static const struct dmi_system_id dmi_switches_allow_list[] = {
 	{} /* Array terminator */
 };
 
-static bool intel_vbtn_has_switches(acpi_handle handle)
+static bool intel_vbtn_has_switches(acpi_handle handle, bool dual_accel)
 {
 	unsigned long long vgbs;
 	acpi_status status;
 
+	/* See dual_accel_detect.h for more info */
+	if (dual_accel)
+		return false;
+
 	if (!dmi_check_system(dmi_switches_allow_list))
 		return false;
 
@@ -263,13 +273,14 @@ static bool intel_vbtn_has_switches(acpi_handle handle)
 static int intel_vbtn_probe(struct platform_device *device)
 {
 	acpi_handle handle = ACPI_HANDLE(&device->dev);
-	bool has_buttons, has_switches;
+	bool dual_accel, has_buttons, has_switches;
 	struct intel_vbtn_priv *priv;
 	acpi_status status;
 	int err;
 
+	dual_accel = dual_accel_detect();
 	has_buttons = acpi_has_method(handle, "VBDL");
-	has_switches = intel_vbtn_has_switches(handle);
+	has_switches = intel_vbtn_has_switches(handle, dual_accel);
 
 	if (!has_buttons && !has_switches) {
 		dev_warn(&device->dev, "failed to read Intel Virtual Button driver\n");
@@ -281,6 +292,7 @@ static int intel_vbtn_probe(struct platform_device *device)
 		return -ENOMEM;
 	dev_set_drvdata(&device->dev, priv);
 
+	priv->dual_accel = dual_accel;
 	priv->has_buttons = has_buttons;
 	priv->has_switches = has_switches;
 
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index edd71e744d27..f8cfb529d1a2 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -73,6 +73,7 @@
 #include <linux/uaccess.h>
 #include <acpi/battery.h>
 #include <acpi/video.h>
+#include "dual_accel_detect.h"
 
 /* ThinkPad CMOS commands */
 #define TP_CMOS_VOLUME_DOWN	0
@@ -3232,7 +3233,7 @@ static int hotkey_init_tablet_mode(void)
 		 * the laptop/tent/tablet mode to the EC. The bmc150 iio driver
 		 * does not support this, so skip the hotkey on these models.
 		 */
-		if (has_tablet_mode && !acpi_dev_present("BOSC0200", "1", -1))
+		if (has_tablet_mode && !dual_accel_detect())
 			tp_features.hotkey_tablet = TP_HOTKEY_TABLET_USES_GMMS;
 		type = "GMMS";
 	} else if (acpi_evalf(hkey_handle, &res, "MHKG", "qd")) {
-- 
2.30.2

