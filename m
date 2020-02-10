Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 084FE157A2F
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728987AbgBJNUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728820AbgBJMhh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:37 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96CEB2051A;
        Mon, 10 Feb 2020 12:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338256;
        bh=V3KZXuaCciVHdUE9nXWXaaEJybBGYjvFOmK9/bmg+Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=070gP7+p5kg4AI7LFDXr6O436NdwUJqm5uHuSs0wuVGZdDkOs9CncownUUpxE0kvJ
         2qlUTUUW3fCpigKEsghCpg/JomS3OpqldXoykztnm6mlKsEtmVa47UsebR+pkxcrds
         r/MqPShqt6uu8c+f2NcIimKxaGYTYpXrak9nBKzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 088/309] ACPI / battery: Use design-cap for capacity calculations if full-cap is not available
Date:   Mon, 10 Feb 2020 04:30:44 -0800
Message-Id: <20200210122414.385413513@linuxfoundation.org>
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

commit 5b74d1d16e2f5753fcbdecd6771b2d8370dda414 upstream.

The ThunderSoft TS178 tablet's _BIX implementation reports design_capacity
but not full_charge_capacity.

Before this commit this would cause us to return -ENODEV for the capacity
attribute, which userspace does not like. Specifically upower does this:

        if (sysfs_file_exists (native_path, "capacity")) {
                percentage = sysfs_get_double (native_path, "capacity");

Where the sysfs_get_double() helper returns 0 when we return -ENODEV,
so the battery always reads 0% if we return -ENODEV.

This commit fixes this by using the design-capacity instead of the
full-charge-capacity when the full-charge-capacity is not available.

Fixes: b41901a2cf06 ("ACPI / battery: Do not export energy_full[_design] on devices without full_charge_capacity")
Cc: 4.19+ <stable@vger.kernel.org> # 4.19+
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/battery.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -217,7 +217,7 @@ static int acpi_battery_get_property(str
 				     enum power_supply_property psp,
 				     union power_supply_propval *val)
 {
-	int ret = 0;
+	int full_capacity = ACPI_BATTERY_VALUE_UNKNOWN, ret = 0;
 	struct acpi_battery *battery = to_acpi_battery(psy);
 
 	if (acpi_battery_present(battery)) {
@@ -286,12 +286,17 @@ static int acpi_battery_get_property(str
 			val->intval = battery->capacity_now * 1000;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
+		if (ACPI_BATTERY_CAPACITY_VALID(battery->full_charge_capacity))
+			full_capacity = battery->full_charge_capacity;
+		else if (ACPI_BATTERY_CAPACITY_VALID(battery->design_capacity))
+			full_capacity = battery->design_capacity;
+
 		if (battery->capacity_now == ACPI_BATTERY_VALUE_UNKNOWN ||
-		    !ACPI_BATTERY_CAPACITY_VALID(battery->full_charge_capacity))
+		    full_capacity == ACPI_BATTERY_VALUE_UNKNOWN)
 			ret = -ENODEV;
 		else
 			val->intval = battery->capacity_now * 100/
-					battery->full_charge_capacity;
+					full_capacity;
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
 		if (battery->state & ACPI_BATTERY_STATE_CRITICAL)


