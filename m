Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DF56C55A1
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 20:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbjCVT7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 15:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjCVT7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:59:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9073A122;
        Wed, 22 Mar 2023 12:58:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4019BB81DE9;
        Wed, 22 Mar 2023 19:58:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD3EC43443;
        Wed, 22 Mar 2023 19:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515079;
        bh=hLSYB7UTVsXMBrQV2LGiYizOvK4Bhs+xq17IN95rbnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LmJREYe65U4qmi2L8c2CUSlxyrHNXV4Riy4fZ5l2xO1LybmY/GDQQaPpOJP38Xujw
         NXW2jNRYt10yeKQvpVF84gZ959ZUPN4Z9+gxxPTMZZv+EbtfWjpkw1CMU/lgHw4Y4h
         2j+aO2P5MLYTSTazdW/M7oC7CCnxgc/IQrk8MwuNHaFbA3SL2orXBEd9CusU5To9Ss
         j4rX9GS6HEaSbIZaJgii48MJPX9yRUp9Ga4t8tCiogSHs9opECBrFShDW37Pj2XeKj
         dQDAqQfDb049Z03VxkRc5DQgCo3Pn84xVuOPQ9qs+19ZtSgQOk1uNr0L7z5lFAuO5M
         AcjDrsQya90qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, mario.limonciello@amd.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 12/45] ACPI: x86: Add skip i2c clients quirk for Acer Iconia One 7 B1-750
Date:   Wed, 22 Mar 2023 15:56:06 -0400
Message-Id: <20230322195639.1995821-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a5cb0695c5f0ac2ab0cedf2c1c0d75826cb73448 ]

The Acer Iconia One 7 B1-750 is a x86 tablet which ships with Android x86
as factory OS. The Android x86 kernel fork ignores I2C devices described
in the DSDT, except for the PMIC and Audio codecs.

As usual the Acer Iconia One 7 B1-750's DSDT contains a bunch of extra I2C
devices which are not actually there, causing various resource conflicts.
Add an ACPI_QUIRK_SKIP_I2C_CLIENTS quirk for the Acer Iconia One 7 B1-750
to the acpi_quirk_skip_dmi_ids table to woraround this.

The DSDT also contains broken ACPI GPIO event handlers, disable those too.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 4a6f3a6726d04..644e2a7f4213b 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -291,6 +291,16 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 	 *    need the x86-android-tablets module to properly work.
 	 */
 #if IS_ENABLED(CONFIG_X86_ANDROID_TABLETS)
+	{
+		/* Acer Iconia One 7 B1-750 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VESPA2"),
+		},
+		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
+					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
+	},
 	{
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
2.39.2

