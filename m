Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC0364FA25
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiLQPbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiLQPak (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:30:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3849186EF;
        Sat, 17 Dec 2022 07:28:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E2B6B803F1;
        Sat, 17 Dec 2022 15:28:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8F1C433F0;
        Sat, 17 Dec 2022 15:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290896;
        bh=Nr7Czi64UOU5LI7QtmOhNRgux5NWwntjgCqwpLPPEEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/e2kv34ukb4kuBDnS/kMO/tQC7OwcIUsAWNQpDa3oiaLkwLCMchWEcFMAQVdjB9f
         RhNYSPXymHzPP2YIHcqLcqUxMLZdQyWQYzMj1w//4oegzU8Yr2Xx44uKJx1Xyr9WI0
         uePu9tsisrQX+Aj1TdpCxnahtu5WVcuoOqVZZkiReAn0yR+BphkGBaKk017xwrnFji
         3qXM/Vhh1qk5qBM0YINfGiXfjjY0QRbuqMScSCPjS0pEA+Sf1+laGHlwAUh2jYSea9
         tfS5pqcXvXkm+wjIxWUdN85fC12h/TAPy1os97fKNhWy9hO9B4TqbwVKhsA/GxwSRl
         +dJajVeZSkvJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        mario.limonciello@amd.com, andriy.shevchenko@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 21/22] ACPI: x86: Add skip i2c clients quirk for Medion Lifetab S10346
Date:   Sat, 17 Dec 2022 10:27:22 -0500
Message-Id: <20221217152727.98061-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152727.98061-1-sashal@kernel.org>
References: <20221217152727.98061-1-sashal@kernel.org>
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

[ Upstream commit ecc6aaabcedc276128315f57755364106017c606 ]

The Medion Lifetab S10346 is a x86 tablet which ships with Android x86 as
factory OS. The Android x86 kernel fork ignores I2C devices described in
the DSDT, except for the PMIC and Audio codecs.

As usual the Medion Lifetab S10346's DSDT contains a bunch of extra I2C
devices which are not actually there, causing various resource conflicts.
Add an ACPI_QUIRK_SKIP_I2C_CLIENTS quirk for the Medion Lifetab S10346 to
the acpi_quirk_skip_dmi_ids table to woraround this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 635de40b5822..4e816bb402f6 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -329,6 +329,17 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
 	},
+	{
+		/* Medion Lifetab S10346 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Way too generic, also match on BIOS data */
+			DMI_MATCH(DMI_BIOS_DATE, "10/22/2015"),
+		},
+		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
+	},
 	{
 		/* Nextbook Ares 8 */
 		.matches = {
-- 
2.35.1

