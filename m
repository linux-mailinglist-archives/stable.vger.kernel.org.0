Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07DE499C7A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579434AbiAXWFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576508AbiAXV7Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:59:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4168FC02B8F0;
        Mon, 24 Jan 2022 12:39:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5497061383;
        Mon, 24 Jan 2022 20:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC12C340E5;
        Mon, 24 Jan 2022 20:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056781;
        bh=dXBOlCuoOPukKy5ijeo0ko66jl0mtrClLVGnUYITNaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mV57kZJsgNtXd+E1Rv44j4oJYaTgdYBSQlPQC9/BEycqhtOMmbww3uebgg9D1mBxG
         i3Vp9Yesu+6OVUSlrkk4ZCRIpLrr8lkNN7qs6+3GSh2M5guRWtFaVqLKYG9JSZctaW
         fqJMMOA0fToXw32OkinWWvDLUd9+dI1UN1pEh400=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 598/846] ACPI: battery: Add the ThinkPad "Not Charging" quirk
Date:   Mon, 24 Jan 2022 19:41:55 +0100
Message-Id: <20220124184121.661468406@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit e96c1197aca628f7d2480a1cc3214912b40b3414 ]

The EC/ACPI firmware on Lenovo ThinkPads used to report a status
of "Unknown" when the battery is between the charge start and
charge stop thresholds. On Windows, it reports "Not Charging"
so the quirk has been added to also report correctly.

Now the "status" attribute returns "Not Charging" when the
battery on ThinkPads is not physicaly charging.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 8afa85d6eb6a7..ead0114f27c9f 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -53,6 +53,7 @@ static int battery_bix_broken_package;
 static int battery_notification_delay_ms;
 static int battery_ac_is_broken;
 static int battery_check_pmic = 1;
+static int battery_quirk_notcharging;
 static unsigned int cache_time = 1000;
 module_param(cache_time, uint, 0644);
 MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
@@ -217,6 +218,8 @@ static int acpi_battery_get_property(struct power_supply *psy,
 			val->intval = POWER_SUPPLY_STATUS_CHARGING;
 		else if (acpi_battery_is_charged(battery))
 			val->intval = POWER_SUPPLY_STATUS_FULL;
+		else if (battery_quirk_notcharging)
+			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
 		else
 			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
 		break;
@@ -1111,6 +1114,12 @@ battery_do_not_check_pmic_quirk(const struct dmi_system_id *d)
 	return 0;
 }
 
+static int __init battery_quirk_not_charging(const struct dmi_system_id *d)
+{
+	battery_quirk_notcharging = 1;
+	return 0;
+}
+
 static const struct dmi_system_id bat_dmi_table[] __initconst = {
 	{
 		/* NEC LZ750/LS */
@@ -1155,6 +1164,19 @@ static const struct dmi_system_id bat_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo MIIX 320-10ICR"),
 		},
 	},
+	{
+		/*
+		 * On Lenovo ThinkPads the BIOS specification defines
+		 * a state when the bits for charging and discharging
+		 * are both set to 0. That state is "Not Charging".
+		 */
+		.callback = battery_quirk_not_charging,
+		.ident = "Lenovo ThinkPad",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad"),
+		},
+	},
 	{},
 };
 
-- 
2.34.1



