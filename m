Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693AA417425
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344515AbhIXNDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:03:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345646AbhIXNBR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:01:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 205D96134F;
        Fri, 24 Sep 2021 12:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488049;
        bh=1PT5m1YrfvB1GNQkRl4aS1FMIUI9LKT6EXmG6KWYb94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOD+ddA1OLF5xX8Nf+uGojPLLQ2Y6AT0JROCG4NmCOMDztOKq7jk24L0EhVml54HJ
         zioTqLl/GSV3YtLUARw1M1t/hCXyTPiNXzhZSOdC9JjmeHCIbtofebnaKqOC55EYZR
         Vmr9JVSu18cTPBl1goPpICXRZ8L1ZBYBYAAfZU/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxwell Beck <max@ryt.one>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 063/100] ACPI: PM: s2idle: Run both AMD and Microsoft methods if both are supported
Date:   Fri, 24 Sep 2021 14:44:12 +0200
Message-Id: <20210924124343.529991570@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.33.0



