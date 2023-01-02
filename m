Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 207B565B0B1
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233035AbjABL13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235980AbjABL04 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:26:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9FB6454
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 03:25:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5EFBB80CA9
        for <stable@vger.kernel.org>; Mon,  2 Jan 2023 11:25:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FFFAC433D2;
        Mon,  2 Jan 2023 11:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672658737;
        bh=qS78GR4cPsQXWAQr0kYVK08W+uNAJy5SsAjZXYvwqks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2bW06KdnDSJXUQBbAxvrcRSo9cT+JETcJANLbjv57lCflNL+7I+07edSXIT7L9IQ
         StqnAt6nMEzdGFleWph/8sbCc6U2IOR9sYRQhMWd1ueM5sMI2OxO3tQmTYrnbcjdk5
         AEZ8GEwyrxCE/U3Z1dH5JWlFvihl5PYFn1mMbihA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Cheng <ben@bcheng.me>,
        bilkow@tutanota.com, Paul <paul@zogpog.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.1 52/71] ACPI: x86: s2idle: Stop using AMD specific codepath for Rembrandt+
Date:   Mon,  2 Jan 2023 12:22:17 +0100
Message-Id: <20230102110553.663640932@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
References: <20230102110551.509937186@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit e555c85792bd5f9828a2fd2ca9761f70efb1c77b upstream.

After we introduced a module parameter and quirk infrastructure for
picking the Microsoft GUID over the SOC vendor GUID we discovered
that lots and lots of systems are getting this wrong.

The table continues to grow, and is becoming unwieldy.

We don't really have any benefit to forcing vendors to populate the
AMD GUID. This is just extra work, and more and more vendors seem
to mess it up.  As the Microsoft GUID is used by Windows as well,
it's very likely that it won't be messed up like this.

So drop all the quirks forcing it and the Rembrandt behavior. This
means that Cezanne or later effectively only run the Microsoft GUID
codepath with the exception of HP Elitebook 8*5 G9.

Fixes: fd894f05cf30 ("ACPI: x86: s2idle: If a new AMD _HID is missing assume Rembrandt")
Cc: stable@vger.kernel.org # 6.1
Reported-by: Benjamin Cheng <ben@bcheng.me>
Reported-by: bilkow@tutanota.com
Reported-by: Paul <paul@zogpog.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2292
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216768
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Philipp Zabel <philipp.zabel@gmail.com>
Tested-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/x86/s2idle.c | 87 ++-------------------------------------
 1 file changed, 3 insertions(+), 84 deletions(-)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index 422415cb14f4..c7afce465a07 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -28,10 +28,6 @@ static bool sleep_no_lps0 __read_mostly;
 module_param(sleep_no_lps0, bool, 0644);
 MODULE_PARM_DESC(sleep_no_lps0, "Do not use the special LPS0 device interface");
 
-static bool prefer_microsoft_dsm_guid __read_mostly;
-module_param(prefer_microsoft_dsm_guid, bool, 0644);
-MODULE_PARM_DESC(prefer_microsoft_dsm_guid, "Prefer using Microsoft GUID in LPS0 device _DSM evaluation");
-
 static const struct acpi_device_id lps0_device_ids[] = {
 	{"PNP0D80", },
 	{"", },
@@ -369,27 +365,15 @@ out:
 }
 
 struct amd_lps0_hid_device_data {
-	const unsigned int rev_id;
 	const bool check_off_by_one;
-	const bool prefer_amd_guid;
 };
 
 static const struct amd_lps0_hid_device_data amd_picasso = {
-	.rev_id = 0,
 	.check_off_by_one = true,
-	.prefer_amd_guid = false,
 };
 
 static const struct amd_lps0_hid_device_data amd_cezanne = {
-	.rev_id = 0,
 	.check_off_by_one = false,
-	.prefer_amd_guid = false,
-};
-
-static const struct amd_lps0_hid_device_data amd_rembrandt = {
-	.rev_id = 2,
-	.check_off_by_one = false,
-	.prefer_amd_guid = true,
 };
 
 static const struct acpi_device_id amd_hid_ids[] = {
@@ -397,7 +381,6 @@ static const struct acpi_device_id amd_hid_ids[] = {
 	{"AMD0005",	(kernel_ulong_t)&amd_picasso,	},
 	{"AMDI0005",	(kernel_ulong_t)&amd_picasso,	},
 	{"AMDI0006",	(kernel_ulong_t)&amd_cezanne,	},
-	{"AMDI0007",	(kernel_ulong_t)&amd_rembrandt,	},
 	{}
 };
 
@@ -407,68 +390,7 @@ static int lps0_prefer_amd(const struct dmi_system_id *id)
 	rev_id = 2;
 	return 0;
 }
-
-static int lps0_prefer_microsoft(const struct dmi_system_id *id)
-{
-	pr_debug("Preferring Microsoft GUID.\n");
-	prefer_microsoft_dsm_guid = true;
-	return 0;
-}
-
 static const struct dmi_system_id s2idle_dmi_table[] __initconst = {
-	{
-		/*
-		 * ASUS TUF Gaming A17 FA707RE
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=216101
-		 */
-		.callback = lps0_prefer_microsoft,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ASUS TUF Gaming A17"),
-		},
-	},
-	{
-		/* ASUS ROG Zephyrus G14 (2022) */
-		.callback = lps0_prefer_microsoft,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ROG Zephyrus G14 GA402"),
-		},
-	},
-	{
-		/*
-		 * Lenovo Yoga Slim 7 Pro X 14ARH7
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=216473 : 82V2
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=216438 : 82TL
-		 */
-		.callback = lps0_prefer_microsoft,
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "82"),
-		},
-	},
-	{
-		/*
-		 * ASUSTeK COMPUTER INC. ROG Flow X13 GV301RE_GV301RE
-		 * https://gitlab.freedesktop.org/drm/amd/-/issues/2148
-		 */
-		.callback = lps0_prefer_microsoft,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ROG Flow X13 GV301"),
-		},
-	},
-	{
-		/*
-		 * ASUSTeK COMPUTER INC. ROG Flow X16 GV601RW_GV601RW
-		 * https://gitlab.freedesktop.org/drm/amd/-/issues/2148
-		 */
-		.callback = lps0_prefer_microsoft,
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "ROG Flow X16 GV601"),
-		},
-	},
 	{
 		/*
 		 * AMD Rembrandt based HP EliteBook 835/845/865 G9
@@ -504,16 +426,14 @@ static int lps0_device_attach(struct acpi_device *adev,
 		if (dev_id->id[0])
 			data = (const struct amd_lps0_hid_device_data *) dev_id->driver_data;
 		else
-			data = &amd_rembrandt;
-		rev_id = data->rev_id;
+			data = &amd_cezanne;
 		lps0_dsm_func_mask = validate_dsm(adev->handle,
 					ACPI_LPS0_DSM_UUID_AMD, rev_id, &lps0_dsm_guid);
 		if (lps0_dsm_func_mask > 0x3 && data->check_off_by_one) {
 			lps0_dsm_func_mask = (lps0_dsm_func_mask << 1) | 0x1;
 			acpi_handle_debug(adev->handle, "_DSM UUID %s: Adjusted function mask: 0x%x\n",
 					  ACPI_LPS0_DSM_UUID_AMD, lps0_dsm_func_mask);
-		} else if (lps0_dsm_func_mask_microsoft > 0 && data->prefer_amd_guid &&
-				!prefer_microsoft_dsm_guid) {
+		} else if (lps0_dsm_func_mask_microsoft > 0 && rev_id) {
 			lps0_dsm_func_mask_microsoft = -EINVAL;
 			acpi_handle_debug(adev->handle, "_DSM Using AMD method\n");
 		}
@@ -521,8 +441,7 @@ static int lps0_device_attach(struct acpi_device *adev,
 		rev_id = 1;
 		lps0_dsm_func_mask = validate_dsm(adev->handle,
 					ACPI_LPS0_DSM_UUID, rev_id, &lps0_dsm_guid);
-		if (!prefer_microsoft_dsm_guid)
-			lps0_dsm_func_mask_microsoft = -EINVAL;
+		lps0_dsm_func_mask_microsoft = -EINVAL;
 	}
 
 	if (lps0_dsm_func_mask < 0 && lps0_dsm_func_mask_microsoft < 0)
-- 
2.39.0



