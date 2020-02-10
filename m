Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDA1157C1E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgBJNfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:35:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:51476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbgBJMfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:35:24 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A0A524681;
        Mon, 10 Feb 2020 12:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338124;
        bh=sTqRcbBJ4s963eDB5vlihpgrDDqfveOvNlzs1M7gh+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2cgIg91TBtGPXfU8UZj7xpNN9ywTsWxW+DBpgesR4ZHpBrl9p9MS7UTVETTdLrDz
         nXgWhSegs2ESVufzgLixgMYiNTPHVGxOgrtqJbXUN6QUFiiUY1MErUBuwm/jNxrxjY
         7nElw4a1H6zTNdt4odJTAO76eAt1BvpatoNIlfpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.19 062/195] ACPI / battery: Deal better with neither design nor full capacity not being reported
Date:   Mon, 10 Feb 2020 04:32:00 -0800
Message-Id: <20200210122311.891936965@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit ff3154d1d89a2343fd5f82e65bc0cf1d4e6659b3 upstream.

Commit b41901a2cf06 ("ACPI / battery: Do not export energy_full[_design] on
devices without full_charge_capacity") added support for some (broken)
devices which always report 0 for both design_capacity and
full_charge_capacity.

Since the device that commit was written as a fix for is not reporting any
form of "full" capacity we cannot calculate the value for the
POWER_SUPPLY_PROP_CAPACITY, this is worked around by using an alternative
array of available properties which does not contain this property.

This is necessary because userspace (upower) treats us returning -ENODEV
as 0 and then typically will trigger an emergency shutdown because of that.
Userspace does not do this if the capacity sysfs attribute is not present
at all.

There are two potential problems with that commit:
 1) It assumes that both full_charge- and design-capacity are broken at the
    same time and only checks if full_charge- is broken.
 2) It assumes that this only ever happens for devices which report energy
    units rather then charge units.

This commit fixes both issues by only using the alternative
array of available properties if both full_charge- and design-capacity are
broken and by also adding an alternative array of available properties for
devices using mA units.

Fixes: b41901a2cf06 ("ACPI / battery: Do not export energy_full[_design] on devices without full_charge_capacity")
Cc: 4.19+ <stable@vger.kernel.org> # 4.19+
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/battery.c |   51 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 12 deletions(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -355,6 +355,20 @@ static enum power_supply_property charge
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
 };
 
+static enum power_supply_property charge_battery_full_cap_broken_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_TECHNOLOGY,
+	POWER_SUPPLY_PROP_CYCLE_COUNT,
+	POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_CURRENT_NOW,
+	POWER_SUPPLY_PROP_CHARGE_NOW,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+	POWER_SUPPLY_PROP_MANUFACTURER,
+	POWER_SUPPLY_PROP_SERIAL_NUMBER,
+};
+
 static enum power_supply_property energy_battery_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_PRESENT,
@@ -816,21 +830,34 @@ static void __exit battery_hook_exit(voi
 static int sysfs_add_battery(struct acpi_battery *battery)
 {
 	struct power_supply_config psy_cfg = { .drv_data = battery, };
+	bool full_cap_broken = false;
+
+	if (!ACPI_BATTERY_CAPACITY_VALID(battery->full_charge_capacity) &&
+	    !ACPI_BATTERY_CAPACITY_VALID(battery->design_capacity))
+		full_cap_broken = true;
 
 	if (battery->power_unit == ACPI_BATTERY_POWER_UNIT_MA) {
-		battery->bat_desc.properties = charge_battery_props;
-		battery->bat_desc.num_properties =
-			ARRAY_SIZE(charge_battery_props);
-	} else if (!ACPI_BATTERY_CAPACITY_VALID(
-					battery->full_charge_capacity)) {
-		battery->bat_desc.properties =
-			energy_battery_full_cap_broken_props;
-		battery->bat_desc.num_properties =
-			ARRAY_SIZE(energy_battery_full_cap_broken_props);
+		if (full_cap_broken) {
+			battery->bat_desc.properties =
+			    charge_battery_full_cap_broken_props;
+			battery->bat_desc.num_properties =
+			    ARRAY_SIZE(charge_battery_full_cap_broken_props);
+		} else {
+			battery->bat_desc.properties = charge_battery_props;
+			battery->bat_desc.num_properties =
+			    ARRAY_SIZE(charge_battery_props);
+		}
 	} else {
-		battery->bat_desc.properties = energy_battery_props;
-		battery->bat_desc.num_properties =
-			ARRAY_SIZE(energy_battery_props);
+		if (full_cap_broken) {
+			battery->bat_desc.properties =
+			    energy_battery_full_cap_broken_props;
+			battery->bat_desc.num_properties =
+			    ARRAY_SIZE(energy_battery_full_cap_broken_props);
+		} else {
+			battery->bat_desc.properties = energy_battery_props;
+			battery->bat_desc.num_properties =
+			    ARRAY_SIZE(energy_battery_props);
+		}
 	}
 
 	battery->bat_desc.name = acpi_device_bid(battery->device);


