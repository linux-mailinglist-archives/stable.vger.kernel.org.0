Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7D02E6595
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389939AbgL1N2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:28:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:57278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389914AbgL1N2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1C47207CF;
        Mon, 28 Dec 2020 13:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162070;
        bh=0SNkv9WRtjEi8ZFcxzNhkn6QqEyGrzSBGHpKDnejghQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMMfZI34600Kz9Ptn4VH3ApVNY2BoIRR84oRVUAgPqSVmC/G+m4ayUjFEkQEBV6CM
         Z+KkzXtmxL+0W613yIrSoWTmqox9GV9X7jAEDMN3aNi0LikxqnLOY5itC8kplxVB6V
         csfXR5dKNFw3cMqcUL7u7Unkj1kuvuGBy3aVwjhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 177/346] power: supply: axp288_charger: Fix HP Pavilion x2 10 DMI matching
Date:   Mon, 28 Dec 2020 13:48:16 +0100
Message-Id: <20201228124928.343574539@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a0f1ccd96c7049377d892a4299b6d5e47ec9179d ]

Commit 9c80662a74cd ("power: supply: axp288_charger: Add special handling
for HP Pavilion x2 10") added special handling for HP Pavilion x2 10
models which use the weird combination of a Type-C connector and the
non Type-C aware AXP288 PMIC.

This special handling was activated by a DMI match a the product-name
of "HP Pavilion x2 Detachable". Recently I've learned that there are
also older "HP Pavilion x2 Detachable" models with an AXP288 PMIC +
a micro-usb connector where we should not activate the special handling
for the Type-C connectors.

Extend the matching to also match on the DMI board-name and match on the
2 boards (one Bay Trail based one Cherry Trail based) of which we are
certain that they use the AXP288 + Type-C connector combination.

Note the DSDT code from these older (AXP288 + micro-USB) models contains
some AML code (which never runs under Linux) which reads the micro-USB
connector id-pin and if it is pulled to ground, which would normally mean
the port is in host mode!, then it sets the input-current-limit to 3A,
it seems HP is using the micro-USB port as a charging only connector
and identifies their own 3A capable charger though this hack which is a
major violation of the USB specs. Note HP also hardcodes a 2A limit
when the id-pin is not pulled to ground, which is also in violation
of the specs.

I've no intention to add support for HP's hack to support 3A charging
on these older models. By making the DMI matches for the Type-C equipped
models workaround more tighter, these older models will be treated just
like any other AXP288 + micro-USB equipped device and the input-current
limit will follow the BC 1.2 spec (using the defacto standard values
there where the BC 1.2 spec defines a range).

Fixes: 9c80662a74cd ("power: supply: axp288_charger: Add special handling for HP Pavilion x2 10")
BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1896924
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/axp288_charger.c | 28 ++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/power/supply/axp288_charger.c b/drivers/power/supply/axp288_charger.c
index 46eb7716c35c8..84106a9836c8f 100644
--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -555,14 +555,15 @@ out:
 
 /*
  * The HP Pavilion x2 10 series comes in a number of variants:
- * Bay Trail SoC    + AXP288 PMIC, DMI_BOARD_NAME: "815D"
- * Cherry Trail SoC + AXP288 PMIC, DMI_BOARD_NAME: "813E"
- * Cherry Trail SoC + TI PMIC,     DMI_BOARD_NAME: "827C" or "82F4"
+ * Bay Trail SoC    + AXP288 PMIC, Micro-USB, DMI_BOARD_NAME: "8021"
+ * Bay Trail SoC    + AXP288 PMIC, Type-C,    DMI_BOARD_NAME: "815D"
+ * Cherry Trail SoC + AXP288 PMIC, Type-C,    DMI_BOARD_NAME: "813E"
+ * Cherry Trail SoC + TI PMIC,     Type-C,    DMI_BOARD_NAME: "827C" or "82F4"
  *
- * The variants with the AXP288 PMIC are all kinds of special:
+ * The variants with the AXP288 + Type-C connector are all kinds of special:
  *
- * 1. All variants use a Type-C connector which the AXP288 does not support, so
- * when using a Type-C charger it is not recognized. Unlike most AXP288 devices,
+ * 1. They use a Type-C connector which the AXP288 does not support, so when
+ * using a Type-C charger it is not recognized. Unlike most AXP288 devices,
  * this model actually has mostly working ACPI AC / Battery code, the ACPI code
  * "solves" this by simply setting the input_current_limit to 3A.
  * There are still some issues with the ACPI code, so we use this native driver,
@@ -585,12 +586,17 @@ out:
  */
 static const struct dmi_system_id axp288_hp_x2_dmi_ids[] = {
 	{
-		/*
-		 * Bay Trail model has "Hewlett-Packard" as sys_vendor, Cherry
-		 * Trail model has "HP", so we only match on product_name.
-		 */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion x2 Detachable"),
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "HP Pavilion x2 Detachable"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "815D"),
+		},
+	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "HP Pavilion x2 Detachable"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "813E"),
 		},
 	},
 	{} /* Terminating entry */
-- 
2.27.0



