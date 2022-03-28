Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D884E937A
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240816AbiC1LYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240863AbiC1LWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:22:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D3A57175;
        Mon, 28 Mar 2022 04:19:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 620E96114A;
        Mon, 28 Mar 2022 11:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56BDC340ED;
        Mon, 28 Mar 2022 11:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466381;
        bh=MJvPpz9dYJStREh6QLBJhvjzV7MS/kHzAg9ejIrAUvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iJpjTQZKaCKbPJbfmYZp8BAmshIaiW3T4QzYzcnN2T4T+nHrf5usiBootznglBzTC
         dhrNn1pEQJbfbdlP3ivYazfBWn2AHtABOd6d7Y/VxzPbZi1WMYeMgVFehDZoBFWtZV
         AuRSoWWysjeIlenBoR+zyppwayspmTZjwKgKlM6OMUWsKkEvIjcOWfzvrwCmKNjNma
         fsjch+/wodzm2LB/uRUwYWxwdOIet25e77LukZ2VuM8olCdJcHP8GJZ6C1bnxrP+gU
         KEv7UfS+C0A0L5jZmspxkgC1ZaMowbhQ6qhGRV9jW/jpLtlA0I+3fGRT0n/SZXdUgm
         Iwn3u9sjOqgwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        mario.limonciello@amd.com, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 33/43] ACPI / x86: Add skip i2c clients quirk for Lenovo Yoga Tablet 1050F/L
Date:   Mon, 28 Mar 2022 07:18:17 -0400
Message-Id: <20220328111828.1554086-33-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328111828.1554086-1-sashal@kernel.org>
References: <20220328111828.1554086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 4fecb1e93e4914fc0bc1fb467ca79741f9f94abb ]

The Yoga Tablet 1050F/L is a x86 ACPI tablet which ships with Android x86
as factory OS. Its DSDT contains a bunch of I2C devices which are not
actually there, causing various resource conflicts (the Android x86
kernel fork ignores I2C devices described in the DSDT).

Add a ACPI_QUIRK_SKIP_I2C_CLIENTS for the Nextbook Ares 8 to the
acpi_quirk_skip_dmi_ids table to woraround this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 9b991294f1e5..664070fc8349 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -284,6 +284,18 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
 	},
+	{
+		/* Lenovo Yoga Tablet 1050F/L */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corp."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "VALLEYVIEW C0 PLATFORM"),
+			DMI_MATCH(DMI_BOARD_NAME, "BYT-T FFD8"),
+			/* Partial match on beginning of BIOS version */
+			DMI_MATCH(DMI_BIOS_VERSION, "BLADE_21"),
+		},
+		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
+	},
 	{
 		/* Nextbook Ares 8 */
 		.matches = {
-- 
2.34.1

