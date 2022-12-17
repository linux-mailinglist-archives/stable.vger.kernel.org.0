Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F31264FA86
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiLQPd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiLQPcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:32:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0931F1A82E;
        Sat, 17 Dec 2022 07:28:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0DB2B802C3;
        Sat, 17 Dec 2022 15:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913D8C433EF;
        Sat, 17 Dec 2022 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290933;
        bh=BLlwjED9foaFr6NRfsmlEjhhZNQfzou4e6Mo/ntC5+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8D4i8lPhAW7X3ENU22wtd6VFWwDvlJJpIJUUOLDUYmud1KMOvLV3TXOR9XWUFB+o
         t+XZKcqDUnFuDcUgHmuvMjtGlUrPdHKiNWzrIbtAAZoXa86NUAt+ZxjlcUGYrEC1WU
         D1Y76HQ0l+iNducncnVhBFxdiRcfdo8I8rRUbg2cy17WGeMNNdGFNUX+FnpP3hO3N8
         EVzdM2nn/TgSmDxXPL/WsdraAbwnyyiYHhLcZoA5kxmyhyA5DfnC8qRmKhhg8bcqYE
         2jvb/XxmqEj8/KpfQL11raytz1EvkvPrMmdd102sx6yz/3b2+cSWebf7VjckFMna9X
         SVQkKVfXobw6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        mario.limonciello@amd.com, andriy.shevchenko@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 14/16] ACPI: x86: Add skip i2c clients quirk for Lenovo Yoga Tab 3 Pro (YT3-X90F)
Date:   Sat, 17 Dec 2022 10:28:17 -0500
Message-Id: <20221217152821.98618-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152821.98618-1-sashal@kernel.org>
References: <20221217152821.98618-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit fe820db35275561d8bf86ad19044d40ffc95bc04 ]

The Lenovo Yoga Tab 3 Pro (YT3-X90F) is a x86 (Cherry Trail) tablet which
ships with Android x86 as factory OS. The Android x86 kernel fork ignores
I2C devices described in the DSDT, except for the PMIC and Audio codecs.

As usual the Lenovo Yoga Tab 3 Pro's DSDT contains a bunch of extra I2C
devices which are not actually there, causing various resource conflicts.
Add an ACPI_QUIRK_SKIP_I2C_CLIENTS quirk for the Lenovo Yoga Tab 3 Pro to
the acpi_quirk_skip_dmi_ids table to woraround this.

ACPI_QUIRK_SKIP_I2C_CLIENTS handling uses i2c_acpi_known_good_ids[],
so that PMICs and Audio codecs will still be enumerated properly.
The Lenovo Yoga Tab 3 Pro uses a Whiskey Cove PMIC, add the INT34D3 HID
for this PMIC to the i2c_acpi_known_good_ids[] list.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 950a93922ca8..fb999597a3f0 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -308,7 +308,7 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
 	},
 	{
-		/* Lenovo Yoga Tablet 1050F/L */
+		/* Lenovo Yoga Tablet 2 1050F/L */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corp."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "VALLEYVIEW C0 PLATFORM"),
@@ -319,6 +319,16 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
 	},
+	{
+		/* Lenovo Yoga Tab 3 Pro X90F */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
+		},
+		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
+	},
 	{
 		/* Nextbook Ares 8 */
 		.matches = {
@@ -348,6 +358,7 @@ static const struct acpi_device_id i2c_acpi_known_good_ids[] = {
 	{ "10EC5640", 0 }, /* RealTek ALC5640 audio codec */
 	{ "INT33F4", 0 },  /* X-Powers AXP288 PMIC */
 	{ "INT33FD", 0 },  /* Intel Crystal Cove PMIC */
+	{ "INT34D3", 0 },  /* Intel Whiskey Cove PMIC */
 	{ "NPCE69A", 0 },  /* Asus Transformer keyboard dock */
 	{}
 };
-- 
2.35.1

