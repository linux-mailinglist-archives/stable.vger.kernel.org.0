Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B420A16986A
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 16:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgBWPcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Feb 2020 10:32:17 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:29076 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726490AbgBWPcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Feb 2020 10:32:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582471936;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=POaDZ53SA/pMrv5TYUBp4G8GkG/+aCfF+ftNGPFIJw8=;
        b=GSMdQSanENgVmN9A/wodxyUPiv+oc0ViqdwLH3E+pMKXvK2r377E27SlhuesCBuCk+3j0z
        EfoBleXmrsuE7E1VDjMbG0N0LLVDh/WTf03ULQDM8F8LbfYtr2esDPv+exYUJMq8sWVc1W
        whdfBgumY82jJZsVmSGcbiVq1tuEBmI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-PLuGJVleP_-p_QsHNmXdnA-1; Sun, 23 Feb 2020 10:32:12 -0500
X-MC-Unique: PLuGJVleP_-p_QsHNmXdnA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C6DB184B121;
        Sun, 23 Feb 2020 15:32:11 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-116-120.ams2.redhat.com [10.36.116.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E831393;
        Sun, 23 Feb 2020 15:32:09 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-pm@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] power: supply: axp288_charger: Add special handling for HP Pavilion x2 10
Date:   Sun, 23 Feb 2020 16:32:08 +0100
Message-Id: <20200223153208.312005-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some HP Pavilion x2 10 models use an AXP288 for charging and fuel-gauge.
We use a native power_supply / PMIC driver in this case, because on most
models with an AXP288 the ACPI AC / Battery code is either completely
missing or relies on custom / proprietary ACPI OpRegions which Linux
does not implement.

The native drivers mostly work fine, but there are 2 problems:

1. These model uses a Type-C connector for charging which the AXP288 does
not support. As long as a Type-A charger (which uses the USB data pins fo=
r
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

2. If no charger is connected when the machine boots then it boots with t=
he
vbus-path disabled. On other devices this is done when a 5V boost convert=
er
is active to avoid the PMIC trying to charge from the 5V boost output.
This is done when an OTG host cable is inserted and the ID pin on the
micro-B receptacle is pulled low, the ID pin has an ACPI event handler
associated with it which re-enables the vbus-path when the ID pin is pull=
ed
high when the OTG cable is removed. The Type-C connector has no ID pin,
there is no ID pin handler and there appears to be no 5V boost converter,
so we end up not charging because the vbus-path is disabled, until we
unplug the charger which automatically clears the vbus-path disable bit a=
nd
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
Vhold, so that would stay at 4.7V) to the axp288_charger code, which need=
s
changes regardless, then we concentrate all special handling of this
interesting device model in the axp288_charger code. That is what this
commit does.

Cc: stable@vger.kernel.org
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D1791098
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/power/supply/axp288_charger.c | 57 ++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/axp288_charger.c b/drivers/power/supply=
/axp288_charger.c
index 1bbba6bba673..cf4c67b2d235 100644
--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -21,6 +21,7 @@
 #include <linux/property.h>
 #include <linux/mfd/axp20x.h>
 #include <linux/extcon.h>
+#include <linux/dmi.h>
=20
 #define PS_STAT_VBUS_TRIGGER		BIT(0)
 #define PS_STAT_BAT_CHRG_DIR		BIT(2)
@@ -545,6 +546,49 @@ static irqreturn_t axp288_charger_irq_thread_handler=
(int irq, void *dev)
 	return IRQ_HANDLED;
 }
=20
+/*
+ * The HP Pavilion x2 10 series comes in a number of variants:
+ * Bay Trail SoC    + AXP288 PMIC, DMI_BOARD_NAME: "815D"
+ * Cherry Trail SoC + AXP288 PMIC, DMI_BOARD_NAME: "813E"
+ * Cherry Trail SoC + TI PMIC,     DMI_BOARD_NAME: "827C" or "82F4"
+ *
+ * The variants with the AXP288 PMIC are all kinds of special:
+ *
+ * 1. All variants use a Type-C connector which the AXP288 does not supp=
ort, so
+ * when using a Type-C charger it is not recognized. Unlike most AXP288 =
devices,
+ * this model actually has mostly working ACPI AC / Battery code, the AC=
PI code
+ * "solves" this by simply setting the input_current_limit to 3A.
+ * There are still some issues with the ACPI code, so we use this native=
 driver,
+ * and to solve the charging not working (500mA is not enough) issue we =
hardcode
+ * the 3A input_current_limit like the ACPI code does.
+ *
+ * 2. If no charger is connected the machine boots with the vbus-path di=
sabled.
+ * Normally this is done when a 5V boost converter is active to avoid th=
e PMIC
+ * trying to charge from the 5V boost converter's output. This is done w=
hen
+ * an OTG host cable is inserted and the ID pin on the micro-B receptacl=
e is
+ * pulled low and the ID pin has an ACPI event handler associated with i=
t
+ * which re-enables the vbus-path when the ID pin is pulled high when th=
e
+ * OTG host cable is removed. The Type-C connector has no ID pin, there =
is
+ * no ID pin handler and there appears to be no 5V boost converter, so w=
e
+ * end up not charging because the vbus-path is disabled, until we unplu=
g
+ * the charger which automatically clears the vbus-path disable bit and =
then
+ * on the second plug-in of the adapter we start charging. To solve the =
not
+ * charging on first charger plugin we unconditionally enable the vbus-p=
ath at
+ * probe on this model, which is safe since there is no 5V boost convert=
er.
+ */
+static const struct dmi_system_id axp288_hp_x2_dmi_ids[] =3D {
+	{
+		/*
+		 * Bay Trail model has "Hewlett-Packard" as sys_vendor, Cherry
+		 * Trail model has "HP", so we only match on product_name.
+		 */
+		.matches =3D {
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion x2 Detachable"),
+		},
+	},
+	{} /* Terminating entry */
+};
+
 static void axp288_charger_extcon_evt_worker(struct work_struct *work)
 {
 	struct axp288_chrg_info *info =3D
@@ -568,7 +612,11 @@ static void axp288_charger_extcon_evt_worker(struct =
work_struct *work)
 	}
=20
 	/* Determine cable/charger type */
-	if (extcon_get_state(edev, EXTCON_CHG_USB_SDP) > 0) {
+	if (dmi_check_system(axp288_hp_x2_dmi_ids)) {
+		/* See comment above axp288_hp_x2_dmi_ids declaration */
+		dev_dbg(&info->pdev->dev, "HP X2 with Type-C, setting inlmt to 3A\n");
+		current_limit =3D 3000000;
+	} else if (extcon_get_state(edev, EXTCON_CHG_USB_SDP) > 0) {
 		dev_dbg(&info->pdev->dev, "USB SDP charger is connected\n");
 		current_limit =3D 500000;
 	} else if (extcon_get_state(edev, EXTCON_CHG_USB_CDP) > 0) {
@@ -685,6 +733,13 @@ static int charger_init_hw_regs(struct axp288_chrg_i=
nfo *info)
 		return ret;
 	}
=20
+	if (dmi_check_system(axp288_hp_x2_dmi_ids)) {
+		/* See comment above axp288_hp_x2_dmi_ids declaration */
+		ret =3D axp288_charger_vbus_path_select(info, true);
+		if (ret < 0)
+			return ret;
+	}
+
 	/* Read current charge voltage and current limit */
 	ret =3D regmap_read(info->regmap, AXP20X_CHRG_CTRL1, &val);
 	if (ret < 0) {
--=20
2.25.0

