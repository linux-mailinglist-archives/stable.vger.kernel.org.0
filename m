Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53CA9157A3C
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgBJNVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:21:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:59358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728279AbgBJMhc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:32 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 050312051A;
        Mon, 10 Feb 2020 12:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338251;
        bh=viCN2OLrdVaSy6OC4bX/zxx4udJHBfesir8T4kojJ2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5ZsrSr2bA1tpRsZXeVJUHdJ6LPvzRPUu+L+YsUrNWPwYWpM4CZfC3RrDXnurRJpX
         sz1rK4YSsam5A+P0eWZQXyMTSpjmVhcini+SkfrYZd/ko6DUT06DBgJ5v/y1qPF5pl
         jdfMAmdzI1gmDwYu8yaDzsAPODkzQIvLnY/2oB7I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 087/309] ACPI / battery: Deal with design or full capacity being reported as -1
Date:   Mon, 10 Feb 2020 04:30:43 -0800
Message-Id: <20200210122414.262820527@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit cc99f0ad52467028cb1251160f23ad4bb65baf20 upstream.

Commit b41901a2cf06 ("ACPI / battery: Do not export energy_full[_design]
on devices without full_charge_capacity") added support for some (broken)
devices which always report 0 for both design- and full_charge-capacity.

This assumes that if the capacity is not being reported it is 0. The
ThunderSoft TS178 tablet's _BIX implementation falsifies this assumption.
It reports ACPI_BATTERY_VALUE_UNKNOWN (-1) as full_charge_capacity, which
we treat as a valid value which causes several problems.

This commit fixes this by adding a new ACPI_BATTERY_CAPACITY_VALID() helper
which checks that the value is not 0 and not -1; and using this whenever we
need to test if either design_capacity or full_charge_capacity is valid.

Fixes: b41901a2cf06 ("ACPI / battery: Do not export energy_full[_design] on devices without full_charge_capacity")
Cc: 4.19+ <stable@vger.kernel.org> # 4.19+
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/battery.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -38,6 +38,8 @@
 #define PREFIX "ACPI: "
 
 #define ACPI_BATTERY_VALUE_UNKNOWN 0xFFFFFFFF
+#define ACPI_BATTERY_CAPACITY_VALID(capacity) \
+	((capacity) != 0 && (capacity) != ACPI_BATTERY_VALUE_UNKNOWN)
 
 #define ACPI_BATTERY_DEVICE_NAME	"Battery"
 
@@ -192,7 +194,8 @@ static int acpi_battery_is_charged(struc
 
 static bool acpi_battery_is_degraded(struct acpi_battery *battery)
 {
-	return battery->full_charge_capacity && battery->design_capacity &&
+	return ACPI_BATTERY_CAPACITY_VALID(battery->full_charge_capacity) &&
+		ACPI_BATTERY_CAPACITY_VALID(battery->design_capacity) &&
 		battery->full_charge_capacity < battery->design_capacity;
 }
 
@@ -263,14 +266,14 @@ static int acpi_battery_get_property(str
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN:
 	case POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN:
-		if (battery->design_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
+		if (!ACPI_BATTERY_CAPACITY_VALID(battery->design_capacity))
 			ret = -ENODEV;
 		else
 			val->intval = battery->design_capacity * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CHARGE_FULL:
 	case POWER_SUPPLY_PROP_ENERGY_FULL:
-		if (battery->full_charge_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
+		if (!ACPI_BATTERY_CAPACITY_VALID(battery->full_charge_capacity))
 			ret = -ENODEV;
 		else
 			val->intval = battery->full_charge_capacity * 1000;
@@ -283,11 +286,12 @@ static int acpi_battery_get_property(str
 			val->intval = battery->capacity_now * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		if (battery->capacity_now && battery->full_charge_capacity)
+		if (battery->capacity_now == ACPI_BATTERY_VALUE_UNKNOWN ||
+		    !ACPI_BATTERY_CAPACITY_VALID(battery->full_charge_capacity))
+			ret = -ENODEV;
+		else
 			val->intval = battery->capacity_now * 100/
 					battery->full_charge_capacity;
-		else
-			val->intval = 0;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
 		if (battery->state & ACPI_BATTERY_STATE_CRITICAL)
@@ -799,7 +803,8 @@ static int sysfs_add_battery(struct acpi
 		battery->bat_desc.properties = charge_battery_props;
 		battery->bat_desc.num_properties =
 			ARRAY_SIZE(charge_battery_props);
-	} else if (battery->full_charge_capacity == 0) {
+	} else if (!ACPI_BATTERY_CAPACITY_VALID(
+					battery->full_charge_capacity)) {
 		battery->bat_desc.properties =
 			energy_battery_full_cap_broken_props;
 		battery->bat_desc.num_properties =


