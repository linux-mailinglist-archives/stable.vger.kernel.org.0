Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B401F409FC9
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 00:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348326AbhIMWfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 18:35:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245355AbhIMWfK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 18:35:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2391610FB;
        Mon, 13 Sep 2021 22:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631572433;
        bh=wR2w6YQJg3iCjxa7BhEis6kUqMGE9iGSJ/ZgLWVJ4vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvYrsyGDTnjPVVLzdEEeBKzUTriIUjw5IB5hAhW3Np58Tgb9jvBqq/Q+MGUwg1jvl
         wrJ9fZNmoAkdelBAZdVTUjzu6fpqk6i/3ro+85XxAWZAWckAw8ZmDHyu6+QEu8VeW4
         0A+/xuUIHEN/gHLJfwr/I+/Y+NRO3U5ssF8+MqdxOEldvuBmlVchKjRDS7Re1Qfe8B
         TP5y+hwG/5xBonEzDlcGdz/uqUlA9ow8X3mLVGEUeJkdpZJWL5VHj/6K7TbCDCyJ1s
         D0g9USTOJ4m0j1NUQJ7t2yKjpQWaU+Bh1tXbK/a8r2wwe6eSYDDxBYwdNeqW9UmH+U
         CK/b1mpfX4gMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Maxwell Beck <max@ryt.one>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 10/25] ACPI: PM: s2idle: Run both AMD and Microsoft methods if both are supported
Date:   Mon, 13 Sep 2021 18:33:24 -0400
Message-Id: <20210913223339.435347-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210913223339.435347-1-sashal@kernel.org>
References: <20210913223339.435347-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit fa209644a7124b3f4cf811ced55daef49ae39ac6 ]

It was reported that on "HP ENVY x360" that power LED does not come
back, certain keys like brightness controls do not work, and the fan
never spins up, even under load on 5.14 final.

In analysis of the SSDT it's clear that the Microsoft UUID doesn't
provide functional support, but rather the AMD UUID should be
supporting this system.

Because this is a gap in the expected logic, we checked back with
internal team.  The conclusion was that on Windows AMD uPEP *does*
run even when Microsoft UUID present, but most OEM systems have
adopted value of "0x3" for supported functions and hence nothing
runs.

Henceforth add support for running both Microsoft and AMD methods.
This approach will also allow the same logic on Intel systems if
desired at a future time as well by pulling the evaluation of
`lps0_dsm_func_mask_microsoft` out of the `if` block for
`acpi_s2idle_vendor_amd`.

Link: https://gitlab.freedesktop.org/drm/amd/uploads/9fbcd7ec3a385cc6949c9bacf45dc41b/acpi-f.20.bin
BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1691
Reported-by: Maxwell Beck <max@ryt.one>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
[ rjw: Edits of the new comments ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/s2idle.c | 67 +++++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 28 deletions(-)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index 3a308461246a..bd92b549fd5a 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -449,25 +449,30 @@ int acpi_s2idle_prepare_late(void)
 	if (pm_debug_messages_on)
 		lpi_check_constraints();
 
-	if (lps0_dsm_func_mask_microsoft > 0) {
+	/* Screen off */
+	if (lps0_dsm_func_mask > 0)
+		acpi_sleep_run_lps0_dsm(acpi_s2idle_vendor_amd() ?
+					ACPI_LPS0_SCREEN_OFF_AMD :
+					ACPI_LPS0_SCREEN_OFF,
+					lps0_dsm_func_mask, lps0_dsm_guid);
+
+	if (lps0_dsm_func_mask_microsoft > 0)
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_OFF,
 				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
-		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_ENTRY,
-				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
+
+	/* LPS0 entry */
+	if (lps0_dsm_func_mask > 0)
+		acpi_sleep_run_lps0_dsm(acpi_s2idle_vendor_amd() ?
+					ACPI_LPS0_ENTRY_AMD :
+					ACPI_LPS0_ENTRY,
+					lps0_dsm_func_mask, lps0_dsm_guid);
+	if (lps0_dsm_func_mask_microsoft > 0) {
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_ENTRY,
 				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
-	} else if (acpi_s2idle_vendor_amd()) {
-		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_OFF_AMD,
-				lps0_dsm_func_mask, lps0_dsm_guid);
-		acpi_sleep_run_lps0_dsm(ACPI_LPS0_ENTRY_AMD,
-				lps0_dsm_func_mask, lps0_dsm_guid);
-	} else {
-		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_OFF,
-				lps0_dsm_func_mask, lps0_dsm_guid);
-		acpi_sleep_run_lps0_dsm(ACPI_LPS0_ENTRY,
-				lps0_dsm_func_mask, lps0_dsm_guid);
+		/* modern standby entry */
+		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_ENTRY,
+				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
 	}
-
 	return 0;
 }
 
@@ -476,24 +481,30 @@ void acpi_s2idle_restore_early(void)
 	if (!lps0_device_handle || sleep_no_lps0)
 		return;
 
-	if (lps0_dsm_func_mask_microsoft > 0) {
-		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT,
-				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
+	/* Modern standby exit */
+	if (lps0_dsm_func_mask_microsoft > 0)
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_MS_EXIT,
 				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
-		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_ON,
-				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
-	} else if (acpi_s2idle_vendor_amd()) {
-		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT_AMD,
-				lps0_dsm_func_mask, lps0_dsm_guid);
-		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_ON_AMD,
-				lps0_dsm_func_mask, lps0_dsm_guid);
-	} else {
+
+	/* LPS0 exit */
+	if (lps0_dsm_func_mask > 0)
+		acpi_sleep_run_lps0_dsm(acpi_s2idle_vendor_amd() ?
+					ACPI_LPS0_EXIT_AMD :
+					ACPI_LPS0_EXIT,
+					lps0_dsm_func_mask, lps0_dsm_guid);
+	if (lps0_dsm_func_mask_microsoft > 0)
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_EXIT,
-				lps0_dsm_func_mask, lps0_dsm_guid);
+				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
+
+	/* Screen on */
+	if (lps0_dsm_func_mask_microsoft > 0)
 		acpi_sleep_run_lps0_dsm(ACPI_LPS0_SCREEN_ON,
-				lps0_dsm_func_mask, lps0_dsm_guid);
-	}
+				lps0_dsm_func_mask_microsoft, lps0_dsm_guid_microsoft);
+	if (lps0_dsm_func_mask > 0)
+		acpi_sleep_run_lps0_dsm(acpi_s2idle_vendor_amd() ?
+					ACPI_LPS0_SCREEN_ON_AMD :
+					ACPI_LPS0_SCREEN_ON,
+					lps0_dsm_func_mask, lps0_dsm_guid);
 }
 
 static const struct platform_s2idle_ops acpi_s2idle_ops_lps0 = {
-- 
2.30.2

