Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05603568D1D
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 17:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233912AbiGFPbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 11:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbiGFPbQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 11:31:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D79021EEE6;
        Wed,  6 Jul 2022 08:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BE80B81D99;
        Wed,  6 Jul 2022 15:31:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0EEC385A2;
        Wed,  6 Jul 2022 15:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121473;
        bh=H+TKFBipJhA7HPW+ujs5yr4devkAIpq0A6i7zpwMw7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LzMflmjidDu0CYt7U9cyXV05kT7SEVpBDQVIFXB0MkIKVlzzgzNi+VOEX8yru/hfF
         j+IJ/xW4ZluUFNaBWbEKT3N8zf58MDQ6QXgwVpQ1gxtkANLWMAr4iqKtNlzTbWikq+
         2ZLnJDlyc4JeYkZoChGwSGCGyoenKHn+CXtECXpGVZwMK6mVelib9hnWr+uDWLiVTu
         frr5LLzZ+Bv+NRVIUs9qUp9Jvu7qDHLjcPX5yPXlXvuKOdlohGY2El8XGvONMcXGdO
         EK8t2oz51h46/KdxKATzON3CovkaJedvrite5zzg4FlNqo47xEDsGY4YJAfjR/QDn1
         M/lIK6YeYYsAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Pearson <markpearson@lenovo.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>, hmh@hmh.eng.br,
        markgross@kernel.org, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 12/22] platform/x86: thinkpad-acpi: profile capabilities as integer
Date:   Wed,  6 Jul 2022 11:30:30 -0400
Message-Id: <20220706153041.1597639-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220706153041.1597639-1-sashal@kernel.org>
References: <20220706153041.1597639-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <markpearson@lenovo.com>

[ Upstream commit 42504af775361ca2330a2bfde496a5ebc5655c86 ]

Currently the active mode (PSC/MMC) is stored in an enum and queried
throughout the driver.

Other driver changes will enumerate additional submodes that are relevant
to be tracked, so instead track PSC/MMC in a single integer variable.

Co-developed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mark Pearson <markpearson@lenovo.com>
Link: https://lore.kernel.org/r/20220603170212.164963-1-markpearson@lenovo.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 45 +++++++++++-----------------
 1 file changed, 18 insertions(+), 27 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index e6cb4a14cdd4..5d1e0a3a5c1e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -10299,21 +10299,15 @@ static struct ibm_struct proxsensor_driver_data = {
 #define DYTC_DISABLE_CQL DYTC_SET_COMMAND(DYTC_FUNCTION_CQL, DYTC_MODE_MMC_BALANCE, 0)
 #define DYTC_ENABLE_CQL DYTC_SET_COMMAND(DYTC_FUNCTION_CQL, DYTC_MODE_MMC_BALANCE, 1)
 
-enum dytc_profile_funcmode {
-	DYTC_FUNCMODE_NONE = 0,
-	DYTC_FUNCMODE_MMC,
-	DYTC_FUNCMODE_PSC,
-};
-
-static enum dytc_profile_funcmode dytc_profile_available;
 static enum platform_profile_option dytc_current_profile;
 static atomic_t dytc_ignore_event = ATOMIC_INIT(0);
 static DEFINE_MUTEX(dytc_mutex);
+static int dytc_capabilities;
 static bool dytc_mmc_get_available;
 
 static int convert_dytc_to_profile(int dytcmode, enum platform_profile_option *profile)
 {
-	if (dytc_profile_available == DYTC_FUNCMODE_MMC) {
+	if (dytc_capabilities & BIT(DYTC_FC_MMC)) {
 		switch (dytcmode) {
 		case DYTC_MODE_MMC_LOWPOWER:
 			*profile = PLATFORM_PROFILE_LOW_POWER;
@@ -10330,7 +10324,7 @@ static int convert_dytc_to_profile(int dytcmode, enum platform_profile_option *p
 		}
 		return 0;
 	}
-	if (dytc_profile_available == DYTC_FUNCMODE_PSC) {
+	if (dytc_capabilities & BIT(DYTC_FC_PSC)) {
 		switch (dytcmode) {
 		case DYTC_MODE_PSC_LOWPOWER:
 			*profile = PLATFORM_PROFILE_LOW_POWER;
@@ -10352,21 +10346,21 @@ static int convert_profile_to_dytc(enum platform_profile_option profile, int *pe
 {
 	switch (profile) {
 	case PLATFORM_PROFILE_LOW_POWER:
-		if (dytc_profile_available == DYTC_FUNCMODE_MMC)
+		if (dytc_capabilities & BIT(DYTC_FC_MMC))
 			*perfmode = DYTC_MODE_MMC_LOWPOWER;
-		else if (dytc_profile_available == DYTC_FUNCMODE_PSC)
+		else if (dytc_capabilities & BIT(DYTC_FC_PSC))
 			*perfmode = DYTC_MODE_PSC_LOWPOWER;
 		break;
 	case PLATFORM_PROFILE_BALANCED:
-		if (dytc_profile_available == DYTC_FUNCMODE_MMC)
+		if (dytc_capabilities & BIT(DYTC_FC_MMC))
 			*perfmode = DYTC_MODE_MMC_BALANCE;
-		else if (dytc_profile_available == DYTC_FUNCMODE_PSC)
+		else if (dytc_capabilities & BIT(DYTC_FC_PSC))
 			*perfmode = DYTC_MODE_PSC_BALANCE;
 		break;
 	case PLATFORM_PROFILE_PERFORMANCE:
-		if (dytc_profile_available == DYTC_FUNCMODE_MMC)
+		if (dytc_capabilities & BIT(DYTC_FC_MMC))
 			*perfmode = DYTC_MODE_MMC_PERFORM;
-		else if (dytc_profile_available == DYTC_FUNCMODE_PSC)
+		else if (dytc_capabilities & BIT(DYTC_FC_PSC))
 			*perfmode = DYTC_MODE_PSC_PERFORM;
 		break;
 	default: /* Unknown profile */
@@ -10445,7 +10439,7 @@ static int dytc_profile_set(struct platform_profile_handler *pprof,
 	if (err)
 		goto unlock;
 
-	if (dytc_profile_available == DYTC_FUNCMODE_MMC) {
+	if (dytc_capabilities & BIT(DYTC_FC_MMC)) {
 		if (profile == PLATFORM_PROFILE_BALANCED) {
 			/*
 			 * To get back to balanced mode we need to issue a reset command.
@@ -10464,7 +10458,7 @@ static int dytc_profile_set(struct platform_profile_handler *pprof,
 				goto unlock;
 		}
 	}
-	if (dytc_profile_available == DYTC_FUNCMODE_PSC) {
+	if (dytc_capabilities & BIT(DYTC_FC_PSC)) {
 		err = dytc_command(DYTC_SET_COMMAND(DYTC_FUNCTION_PSC, perfmode, 1), &output);
 		if (err)
 			goto unlock;
@@ -10483,12 +10477,12 @@ static void dytc_profile_refresh(void)
 	int perfmode;
 
 	mutex_lock(&dytc_mutex);
-	if (dytc_profile_available == DYTC_FUNCMODE_MMC) {
+	if (dytc_capabilities & BIT(DYTC_FC_MMC)) {
 		if (dytc_mmc_get_available)
 			err = dytc_command(DYTC_CMD_MMC_GET, &output);
 		else
 			err = dytc_cql_command(DYTC_CMD_GET, &output);
-	} else if (dytc_profile_available == DYTC_FUNCMODE_PSC)
+	} else if (dytc_capabilities & BIT(DYTC_FC_PSC))
 		err = dytc_command(DYTC_CMD_GET, &output);
 
 	mutex_unlock(&dytc_mutex);
@@ -10517,7 +10511,6 @@ static int tpacpi_dytc_profile_init(struct ibm_init_struct *iibm)
 	set_bit(PLATFORM_PROFILE_BALANCED, dytc_profile.choices);
 	set_bit(PLATFORM_PROFILE_PERFORMANCE, dytc_profile.choices);
 
-	dytc_profile_available = DYTC_FUNCMODE_NONE;
 	err = dytc_command(DYTC_CMD_QUERY, &output);
 	if (err)
 		return err;
@@ -10530,13 +10523,12 @@ static int tpacpi_dytc_profile_init(struct ibm_init_struct *iibm)
 		return -ENODEV;
 
 	/* Check what capabilities are supported */
-	err = dytc_command(DYTC_CMD_FUNC_CAP, &output);
+	err = dytc_command(DYTC_CMD_FUNC_CAP, &dytc_capabilities);
 	if (err)
 		return err;
 
-	if (output & BIT(DYTC_FC_MMC)) { /* MMC MODE */
-		dytc_profile_available = DYTC_FUNCMODE_MMC;
-
+	if (dytc_capabilities & BIT(DYTC_FC_MMC)) { /* MMC MODE */
+		pr_debug("MMC is supported\n");
 		/*
 		 * Check if MMC_GET functionality available
 		 * Version > 6 and return success from MMC_GET command
@@ -10547,8 +10539,8 @@ static int tpacpi_dytc_profile_init(struct ibm_init_struct *iibm)
 			if (!err && ((output & DYTC_ERR_MASK) == DYTC_ERR_SUCCESS))
 				dytc_mmc_get_available = true;
 		}
-	} else if (output & BIT(DYTC_FC_PSC)) { /* PSC MODE */
-		dytc_profile_available = DYTC_FUNCMODE_PSC;
+	} else if (dytc_capabilities & BIT(DYTC_FC_PSC)) { /* PSC MODE */
+		pr_debug("PSC is supported\n");
 	} else {
 		dbg_printk(TPACPI_DBG_INIT, "No DYTC support available\n");
 		return -ENODEV;
@@ -10574,7 +10566,6 @@ static int tpacpi_dytc_profile_init(struct ibm_init_struct *iibm)
 
 static void dytc_profile_exit(void)
 {
-	dytc_profile_available = DYTC_FUNCMODE_NONE;
 	platform_profile_remove();
 }
 
-- 
2.35.1

