Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D356C55A7
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 21:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbjCVT74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 15:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbjCVT72 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 15:59:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E8662FE2;
        Wed, 22 Mar 2023 12:58:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FD46622B0;
        Wed, 22 Mar 2023 19:58:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0880C433D2;
        Wed, 22 Mar 2023 19:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515082;
        bh=Tn66IFL7Td3Mux1UE6o01BUXTDt1Mkbu7IlLgwR2btk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7pu5BWiA31KGxpRJX6sIDdM2Q0YDhP5wiStpYeGbxBSHq/BY6AUwT5Fh72Ak3e43
         c0eE1RvbZMb+o4+A13GFeMxLgjEyi9pWwZ9ea3VgRBUDDzBSPWs2ZdWGqwDCZe15zu
         jJ3TsRiBQmLpXsNkj6pmHypVKaHYiuy58osaBZBT68aAeiIcEqH8Gz/3l2902DBPLh
         da6kH5eVURgC7ZBaMj1tu0+pgdy/5Cx8/zRkeP+jdT5p6Bd1znj1ve4p/CWVsJBaIp
         D53GJ8/8IjOYBh46R+FoZx9luqhEvw7CF/CRs9E7aOBarOHn7i+t03OHvOC/FUWp3z
         NVg9dUFy3JhPw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, mario.limonciello@amd.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 13/45] ACPI: x86: Add skip i2c clients quirk for Lenovo Yoga Book X90
Date:   Wed, 22 Mar 2023 15:56:07 -0400
Message-Id: <20230322195639.1995821-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322195639.1995821-1-sashal@kernel.org>
References: <20230322195639.1995821-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 1a1e7540cf501dd5c8b57a577a155cdd13c7e202 ]

The Lenovo Yoga Book X90 is a x86 tablet which ships with Android x86
as factory OS. The Android x86 kernel fork ignores I2C devices described
in the DSDT, except for the PMIC and Audio codecs.

As usual the Lenovo Yoga Book X90's DSDT contains a bunch of extra I2C
devices which are not actually there, causing various resource conflicts.
Add an ACPI_QUIRK_SKIP_I2C_CLIENTS quirk for the Lenovo Yoga Book X90
to the acpi_quirk_skip_dmi_ids table to woraround this.

The DSDT also contains broken ACPI GPIO event handlers, disable those too.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 644e2a7f4213b..4973a37843819 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -311,6 +311,17 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
 					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
 	},
+	{
+		/* Lenovo Yoga Book X90F/L */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "YETI-11"),
+		},
+		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
+					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-- 
2.39.2

