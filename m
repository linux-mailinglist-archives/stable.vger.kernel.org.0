Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19716BD5DA
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjCPQfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231185AbjCPQe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:34:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F26C4FF14;
        Thu, 16 Mar 2023 09:33:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BDFFB82289;
        Thu, 16 Mar 2023 16:33:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0184C433D2;
        Thu, 16 Mar 2023 16:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678984410;
        bh=NP0Ls7B1aIxpGe0fZTWet09qyPVhMgouoYrI9T3wV+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TTP6BZEMwb5lfo6VUs7hkT664hiBjEGsf/b9dLnZmTohLxCUDRgnuk9s7gvx0visD
         2i/oGnldGoEavk2jLPdqjJFF1JYxZBYC1HVZ5xZ4j03++dT3OTU+VUiTrRVDcX8FaG
         xVonPs7fOP84gyi7XwHv7uW9RGbSeqXDxrHQ/f9fOaXvyqTskQUfPnae1yz45jOrAN
         t8272SxiRxD6x/QAe5orFbPjs3xVoKM6M3wBPUqjz24OUgme9G5hQsR3XFsBCvTC0k
         RW1dTE3R28tJbuUK9WoIXgEma70uz6eJ5hgGFD/gDQQCAzACn60ODBcaCZVb0HFf2p
         uNAChBqPhiOTg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Anson Tsao <anson.tsao@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        philipp.zabel@gmail.com, hdegoede@redhat.com,
        Shyam-sundar.S-k@amd.com, peterz@infradead.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 4/6] ACPI: x86: Drop quirk for HP Elitebook
Date:   Thu, 16 Mar 2023 12:33:05 -0400
Message-Id: <20230316163309.708796-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230316163309.708796-1-sashal@kernel.org>
References: <20230316163309.708796-1-sashal@kernel.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit e32d546c483a2a0f607687f5b521c2a2f942ffbe ]

There was a quirk in `acpi/x86/s2idle.c` for an HP Elitebook G9
platforms to force AMD GUID codepath instead of Microsoft codepath.

This was due to a bug with WCN6855 WLAN firmware interaction with
the system.

This bug is fixed by WCN6855 firmware:
WLAN.HSP.1.1-03125-QCAHSPSWPL_V1_V2_SILICONZ_LITE-3.6510.23

Remove the quirk as it's no longer necessary with this firmware.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/commit/?id=c7a57ef688f7d99d8338a5d8edddc8836ff0e6de
Tested-by: Anson Tsao <anson.tsao@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/s2idle.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index c7afce465a071..e499c60c45791 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -384,29 +384,6 @@ static const struct acpi_device_id amd_hid_ids[] = {
 	{}
 };
 
-static int lps0_prefer_amd(const struct dmi_system_id *id)
-{
-	pr_debug("Using AMD GUID w/ _REV 2.\n");
-	rev_id = 2;
-	return 0;
-}
-static const struct dmi_system_id s2idle_dmi_table[] __initconst = {
-	{
-		/*
-		 * AMD Rembrandt based HP EliteBook 835/845/865 G9
-		 * Contains specialized AML in AMD/_REV 2 path to avoid
-		 * triggering a bug in Qualcomm WLAN firmware. This may be
-		 * removed in the future if that firmware is fixed.
-		 */
-		.callback = lps0_prefer_amd,
-		.matches = {
-			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
-			DMI_MATCH(DMI_BOARD_NAME, "8990"),
-		},
-	},
-	{}
-};
-
 static int lps0_device_attach(struct acpi_device *adev,
 			      const struct acpi_device_id *not_used)
 {
@@ -586,7 +563,6 @@ static const struct platform_s2idle_ops acpi_s2idle_ops_lps0 = {
 
 void __init acpi_s2idle_setup(void)
 {
-	dmi_check_system(s2idle_dmi_table);
 	acpi_scan_add_handler(&lps0_handler);
 	s2idle_set_ops(&acpi_s2idle_ops_lps0);
 }
-- 
2.39.2

