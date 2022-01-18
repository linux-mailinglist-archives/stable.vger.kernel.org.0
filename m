Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F90D491792
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346263AbiARCmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345573AbiARCbn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:31:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88089C0612E1;
        Mon, 17 Jan 2022 18:29:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49481B81256;
        Tue, 18 Jan 2022 02:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D113C36AF2;
        Tue, 18 Jan 2022 02:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472982;
        bh=dXBOlCuoOPukKy5ijeo0ko66jl0mtrClLVGnUYITNaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5C4EDyLNJ2N3KH98ZDb1yF2kSVdE1oW+wwhVaTvzklom4z+vbQxhYO2LLzut5r4o
         wFe5liy2cTmZcJHFmjtOdWpVPzpVaR+M8+nM+pOjQWHdBHmFEvHJlY/I0gqvw4ew8/
         X0qLer50uDmRvM+A6eTCZbgfKVtxjXUkQ+So4f9U2DPm19AXrZf3At0+GGS4iX/tD5
         dSYa4iKhLDpKUVv22d+PJoF5u0IUhSxp/HFRritAoRzVxJz2vnvCAqUUhUz76Ua+8B
         uisHpdm9/dHCWjVbRj3V/E7VzLY3kq0lXyhmyroCGn7MxL8D8owLajff2T904SS3/0
         dJixTnVgdbrrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 189/217] ACPI: battery: Add the ThinkPad "Not Charging" quirk
Date:   Mon, 17 Jan 2022 21:19:12 -0500
Message-Id: <20220118021940.1942199-189-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

