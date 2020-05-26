Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A584D1A0BA6
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgDGKZq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:25:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728992AbgDGKZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:25:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 141882074F;
        Tue,  7 Apr 2020 10:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255144;
        bh=4pHLwaftfoue1jLFWgtZnNla0KEbD+Y0nes/UYDUXW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYGCrxbE5OpP98O/TTLqNYmOrYxoKIYwe4+06AzTrldUK43E1reE7jfYsYHDCFlxE
         4uUyxLheqI0duWFMn5FJMZGqBPcpIZj0x3Gw+UDvOl6gqYLJqrRIMaltxKNnGe6WLS
         9bEL2TXDLU8xmlD79PwhBm4KYPPIQveVBDiBy1Ic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.5 30/46] power: supply: axp288_charger: Add special handling for HP Pavilion x2 10
Date:   Tue,  7 Apr 2020 12:22:01 +0200
Message-Id: <20200407101502.698383372@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 9c80662a74cd2a5d1113f5c69d027face963a556 upstream.

Some HP Pavilion x2 10 models use an AXP288 for charging and fuel-gauge.
We use a native power_supply / PMIC driver in this case, because on most
models with an AXP288 the ACPI AC / Battery code is either completely
missing or relies on custom / proprietary ACPI OpRegions which Linux
does not implement.

The native drivers mostly work fine, but there are 2 problems:

1. These model uses a Type-C connector for charging which the AXP288 does
not support. As long as a Type-A charger (which uses the USB data pins for
charger type detection) is used everything is fine. But if a Type-C
charger is used (such as the charger shipped with the device) then the
charger is not recognized.

So we end up slowly discharging the device even though a charger is
connected, because we are limiting the current from the charger to 500mA.
To make things worse this happens with the device's official charger.

Looking at the ACPI tables HP has "solved" the problem of the AXP288 not
being able to recognize Type-C chargers by simply always programming the
input-current-limit at 3000mA and relying on a Vhold setting of 4.7V
(normally 4.4V) to limit the current intake if the charger cannot handle
this.

2. If no charger is connected when the machine boots then it boots with the
vbus-path disabled. On other devices this is done when a 5V boost converter
is active to avoid the PMIC trying to charge from the 5V boost output.
This is done when an OTG host cable is inserted and the ID pin on the
micro-B receptacle is pulled low, the ID pin has an ACPI event handler
associated with it which re-enables the vbus-path when the ID pin is pulled
high when the OTG cable is removed. The Type-C connector has no ID pin,
there is no ID pin handler and there appears to be no 5V boost converter,
so we end up not charging because the vbus-path is disabled, until we
unplug the charger which automatically clears the vbus-path disable bit and
then on the second plug-in of the adapter we start charging.

The HP Pavilion x2 10 models with an AXP288 do have mostly working ACPI
AC / Battery code which does not rely on custom / proprietary ACPI
OpRegions. So one possible solution would be to blacklist the AXP288
native power_supply drivers and add the HP Pavilion x2 10 with AXP288
DMI ids to the list of devices which should use the ACPI AC / Battery
code even though they have an AXP288 PMIC. This would require changes to
4 files: drivers/acpi/ac.c, drivers/power/supply/axp288_charger.c,
drivers/acpi/battery.c and drivers/power/supply/axp288_fuel_gauge.c.

Beside needing adding the same DMI matches to 4 different files, this
approach also triggers problem 2. from above, but then when suspended,
during suspend the machine will not wakeup because the vbus path is
disabled by the AML code when not charging, so the Vbus low-to-high
IRQ is not triggered, the CPU never wakes up and the device does not
charge even though the user likely things it is charging, esp. since
the charge status LED is directly coupled to an adapter being plugged
in and does not reflect actual charging.

This could be worked by enabling vbus-path explicitly from say the
axp288_charger driver's suspend handler.

So neither situation is ideal, in both cased we need to explicitly enable
the vbus-path to work around different variants of problem 2 above, this
requires a quirk in the axp288_charger code.

If we go the route of using the ACPI AC / Battery drivers then we need
modifications to 3 other drivers; and we need to partially disable the
axp288_charger code, while at the same time keeping it around to enable
vbus-path on suspend.

OTOH we can copy the hardcoding of 3A input-current-limit (we never touch
Vhold, so that would stay at 4.7V) to the axp288_charger code, which needs
changes regardless, then we concentrate all special handling of this
interesting device model in the axp288_charger code. That is what this
commit does.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1791098
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/supply/axp288_charger.c |   57 +++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -21,6 +21,7 @@
 #include <linux/property.h>
 #include <linux/mfd/axp20x.h>
 #include <linux/extcon.h>
+#include <linux/dmi.h>
 
 #define PS_STAT_VBUS_TRIGGER		BIT(0)
 #define PS_STAT_BAT_CHRG_DIR		BIT(2)
@@ -545,6 +546,49 @@ out:
 	return IRQ_HANDLED;
 }
 
+/*
+ * The HP Pavilion x2 10 series comes in a number of variants:
+ * Bay Trail SoC    + AXP288 PMIC, DMI_BOARD_NAME: "815D"
+ * Cherry Trail SoC + AXP288 PMIC, DMI_BOARD_NAME: "813E"
+ * Cherry Trail SoC + TI PMIC,     DMI_BOARD_NAME: "827C" or "82F4"
+ *
+ * The variants with the AXP288 PMIC are all kinds of special:
+ *
+ * 1. All variants use a Type-C connector which the AXP288 does not support, so
+ * when using a Type-C charger it is not recognized. Unlike most AXP288 devices,
+ * this model actually has mostly working ACPI AC / Battery code, the ACPI code
+ * "solves" this by simply setting the input_current_limit to 3A.
+ * There are still some issues with the ACPI code, so we use this native driver,
+ * and to solve the charging not working (500mA is not enough) issue we hardcode
+ * the 3A input_current_limit like the ACPI code does.
+ *
+ * 2. If no charger is connected the machine boots with the vbus-path disabled.
+ * Normally this is done when a 5V boost converter is active to avoid the PMIC
+ * trying to charge from the 5V boost converter's output. This is done when
+ * an OTG host cable is inserted and the ID pin on the micro-B receptacle is
+ * pulled low and the ID pin has an ACPI event handler associated with it
+ * which re-enables the vbus-path when the ID pin is pulled high when the
+ * OTG host cable is removed. The Type-C connector has no ID pin, there is
+ * no ID pin handler and there appears to be no 5V boost converter, so we
+ * end up not charging because the vbus-path is disabled, until we unplug
+ * the charger which automatically clears the vbus-path disable bit and then
+ * on the second plug-in of the adapter we start charging. To solve the not
+ * charging on first charger plugin we unconditionally enable the vbus-path at
+ * probe on this model, which is safe since there is no 5V boost converter.
+ */
+static const struct dmi_system_id axp288_hp_x2_dmi_ids[] = {
+	{
+		/*
+		 * Bay Trail model has "Hewlett-Packard" as sys_vendor, Cherry
+		 * Trail model has "HP", so we only match on product_name.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion x2 Detachable"),
+		},
+	},
+	{} /* Terminating entry */
+};
+
 static void axp288_charger_extcon_evt_worker(struct work_struct *work)
 {
 	struct axp288_chrg_info *info =
@@ -568,7 +612,11 @@ static void axp288_charger_extcon_evt_wo
 	}
 
 	/* Determine cable/charger type */
-	if (extcon_get_state(edev, EXTCON_CHG_USB_SDP) > 0) {
+	if (dmi_check_system(axp288_hp_x2_dmi_ids)) {
+		/* See comment above axp288_hp_x2_dmi_ids declaration */
+		dev_dbg(&info->pdev->dev, "HP X2 with Type-C, setting inlmt to 3A\n");
+		current_limit = 3000000;
+	} else if (extcon_get_state(edev, EXTCON_CHG_USB_SDP) > 0) {
 		dev_dbg(&info->pdev->dev, "USB SDP charger is connected\n");
 		current_limit = 500000;
 	} else if (extcon_get_state(edev, EXTCON_CHG_USB_CDP) > 0) {
@@ -685,6 +733,13 @@ static int charger_init_hw_regs(struct a
 		return ret;
 	}
 
+	if (dmi_check_system(axp288_hp_x2_dmi_ids)) {
+		/* See comment above axp288_hp_x2_dmi_ids declaration */
+		ret = axp288_charger_vbus_path_select(info, true);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* Read current charge voltage and current limit */
 	ret = regmap_read(info->regmap, AXP20X_CHRG_CTRL1, &val);
 	if (ret < 0) {


