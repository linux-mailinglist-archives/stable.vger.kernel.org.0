Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14D976355D8
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237634AbiKWJYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:24:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237506AbiKWJXr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:23:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D008E2BF4
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:22:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12A0161A00
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EEEC433D7;
        Wed, 23 Nov 2022 09:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195350;
        bh=eq9O2r8vATktBa4oxrQYVJbvqGquaEqH60oMbgsZRgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D89iSYXtpdM6FPmdxqah+TLqwwtU222WKzSZHIKFEA4R0Z6BliLi70OPtwgqe+U68
         l7KRORzMUiiVWzI1R/upOfMZgF2M34UnJZBoD6+CmWRTS9nhlETm8GeBmCV6U0YEZQ
         lGP2H0cmIv4J9NrRAJbn/PcgxdedEE46Xuay16ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lijo Lazar <lijo.lazar@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/149] drm/amd/pm: Read BIF STRAP also for BACO check
Date:   Wed, 23 Nov 2022 09:50:12 +0100
Message-Id: <20221123084559.061046701@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 458020dd4f7109693d4857ed320398e662e8899a ]

Avoid reading BIF STRAP each time for BACO capability. Read the STRAP
value while checking BACO capability in PPTable.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 0c85c067c9d9 ("drm/amdgpu: disable BACO on special BEIGE_GOBY card")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c | 25 ++++++++++++-----
 .../gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c   | 27 ++++++++++++++-----
 .../amd/pm/swsmu/smu11/sienna_cichlid_ppt.c   | 27 ++++++++++++++-----
 3 files changed, 59 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index 1c526cb239e0..3a31058b029e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -379,16 +379,31 @@ static int arcturus_set_default_dpm_table(struct smu_context *smu)
 	return 0;
 }
 
-static int arcturus_check_powerplay_table(struct smu_context *smu)
+static void arcturus_check_bxco_support(struct smu_context *smu)
 {
 	struct smu_table_context *table_context = &smu->smu_table;
 	struct smu_11_0_powerplay_table *powerplay_table =
 		table_context->power_play_table;
 	struct smu_baco_context *smu_baco = &smu->smu_baco;
+	struct amdgpu_device *adev = smu->adev;
+	uint32_t val;
 
 	if (powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_BACO ||
-	    powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_MACO)
-		smu_baco->platform_support = true;
+	    powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_MACO) {
+		val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
+		smu_baco->platform_support =
+			(val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true :
+									false;
+	}
+}
+
+static int arcturus_check_powerplay_table(struct smu_context *smu)
+{
+	struct smu_table_context *table_context = &smu->smu_table;
+	struct smu_11_0_powerplay_table *powerplay_table =
+		table_context->power_play_table;
+
+	arcturus_check_bxco_support(smu);
 
 	table_context->thermal_controller_type =
 		powerplay_table->thermal_controller_type;
@@ -2131,13 +2146,11 @@ static void arcturus_get_unique_id(struct smu_context *smu)
 static bool arcturus_is_baco_supported(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
-	uint32_t val;
 
 	if (!smu_v11_0_baco_is_support(smu) || amdgpu_sriov_vf(adev))
 		return false;
 
-	val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
-	return (val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true : false;
+	return true;
 }
 
 static int arcturus_set_df_cstate(struct smu_context *smu,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
index 2937784bc824..a7773b6453d5 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c
@@ -338,19 +338,34 @@ navi10_get_allowed_feature_mask(struct smu_context *smu,
 	return 0;
 }
 
-static int navi10_check_powerplay_table(struct smu_context *smu)
+static void navi10_check_bxco_support(struct smu_context *smu)
 {
 	struct smu_table_context *table_context = &smu->smu_table;
 	struct smu_11_0_powerplay_table *powerplay_table =
 		table_context->power_play_table;
 	struct smu_baco_context *smu_baco = &smu->smu_baco;
+	struct amdgpu_device *adev = smu->adev;
+	uint32_t val;
+
+	if (powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_BACO ||
+	    powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_MACO) {
+		val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
+		smu_baco->platform_support =
+			(val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true :
+									false;
+	}
+}
+
+static int navi10_check_powerplay_table(struct smu_context *smu)
+{
+	struct smu_table_context *table_context = &smu->smu_table;
+	struct smu_11_0_powerplay_table *powerplay_table =
+		table_context->power_play_table;
 
 	if (powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_HARDWAREDC)
 		smu->dc_controlled_by_gpio = true;
 
-	if (powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_BACO ||
-	    powerplay_table->platform_caps & SMU_11_0_PP_PLATFORM_CAP_MACO)
-		smu_baco->platform_support = true;
+	navi10_check_bxco_support(smu);
 
 	table_context->thermal_controller_type =
 		powerplay_table->thermal_controller_type;
@@ -1948,13 +1963,11 @@ static int navi10_overdrive_get_gfx_clk_base_voltage(struct smu_context *smu,
 static bool navi10_is_baco_supported(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
-	uint32_t val;
 
 	if (amdgpu_sriov_vf(adev) || (!smu_v11_0_baco_is_support(smu)))
 		return false;
 
-	val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
-	return (val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true : false;
+	return true;
 }
 
 static int navi10_set_default_od_settings(struct smu_context *smu)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index 834ac633281c..def32b6897f9 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -294,19 +294,34 @@ sienna_cichlid_get_allowed_feature_mask(struct smu_context *smu,
 	return 0;
 }
 
-static int sienna_cichlid_check_powerplay_table(struct smu_context *smu)
+static void sienna_cichlid_check_bxco_support(struct smu_context *smu)
 {
 	struct smu_table_context *table_context = &smu->smu_table;
 	struct smu_11_0_7_powerplay_table *powerplay_table =
 		table_context->power_play_table;
 	struct smu_baco_context *smu_baco = &smu->smu_baco;
+	struct amdgpu_device *adev = smu->adev;
+	uint32_t val;
+
+	if (powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_BACO ||
+	    powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_MACO) {
+		val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
+		smu_baco->platform_support =
+			(val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true :
+									false;
+	}
+}
+
+static int sienna_cichlid_check_powerplay_table(struct smu_context *smu)
+{
+	struct smu_table_context *table_context = &smu->smu_table;
+	struct smu_11_0_7_powerplay_table *powerplay_table =
+		table_context->power_play_table;
 
 	if (powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_HARDWAREDC)
 		smu->dc_controlled_by_gpio = true;
 
-	if (powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_BACO ||
-	    powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_MACO)
-		smu_baco->platform_support = true;
+	sienna_cichlid_check_bxco_support(smu);
 
 	table_context->thermal_controller_type =
 		powerplay_table->thermal_controller_type;
@@ -1739,13 +1754,11 @@ static int sienna_cichlid_run_btc(struct smu_context *smu)
 static bool sienna_cichlid_is_baco_supported(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
-	uint32_t val;
 
 	if (amdgpu_sriov_vf(adev) || (!smu_v11_0_baco_is_support(smu)))
 		return false;
 
-	val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
-	return (val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true : false;
+	return true;
 }
 
 static bool sienna_cichlid_is_mode1_reset_supported(struct smu_context *smu)
-- 
2.35.1



