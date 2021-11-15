Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32A014520CB
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241982AbhKPA4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343588AbhKOTVX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23B36635AF;
        Mon, 15 Nov 2021 18:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001760;
        bh=ynEjvJ9eOv/+wi7yFyxjulEG8fBQlgfvtPdt/3huhA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cyMvzfe6chpLXyoNSYyDQVaUdvS0jpbXmcX6WNE2xr9hmnL1gZ3CsgzaeDvRjitNp
         17Ta/MLFPR9H65FAkfrv7jteQk7XHQYTTi1HHLmGiiRr2ywz619uhgnbwrO2dT7cuJ
         uUErjcDXQEjQsYJj2KTiZmTeSjple7buN6ldNyfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/917] drm/amdgpu/pm: properly handle sclk for profiling modes on vangogh
Date:   Mon, 15 Nov 2021 17:56:12 +0100
Message-Id: <20211115165438.168062112@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 68e3871dcd6e547f6c47454492bc452356cb9eac ]

When selecting between levels in the force performance levels interface
sclk (gfxclk) was not set correctly for all levels.  Select the proper
sclk settings for all levels.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1726
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c  | 89 ++++++-------------
 1 file changed, 29 insertions(+), 60 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
index f6ef0ce6e9e2c..a9dceef4a7011 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
@@ -1386,52 +1386,38 @@ static int vangogh_set_performance_level(struct smu_context *smu,
 	uint32_t soc_mask, mclk_mask, fclk_mask;
 	uint32_t vclk_mask = 0, dclk_mask = 0;
 
+	smu->cpu_actual_soft_min_freq = smu->cpu_default_soft_min_freq;
+	smu->cpu_actual_soft_max_freq = smu->cpu_default_soft_max_freq;
+
 	switch (level) {
 	case AMD_DPM_FORCED_LEVEL_HIGH:
-		smu->gfx_actual_hard_min_freq = smu->gfx_default_hard_min_freq;
+		smu->gfx_actual_hard_min_freq = smu->gfx_default_soft_max_freq;
 		smu->gfx_actual_soft_max_freq = smu->gfx_default_soft_max_freq;
 
-		smu->cpu_actual_soft_min_freq = smu->cpu_default_soft_min_freq;
-		smu->cpu_actual_soft_max_freq = smu->cpu_default_soft_max_freq;
 
 		ret = vangogh_force_dpm_limit_value(smu, true);
+		if (ret)
+			return ret;
 		break;
 	case AMD_DPM_FORCED_LEVEL_LOW:
 		smu->gfx_actual_hard_min_freq = smu->gfx_default_hard_min_freq;
-		smu->gfx_actual_soft_max_freq = smu->gfx_default_soft_max_freq;
-
-		smu->cpu_actual_soft_min_freq = smu->cpu_default_soft_min_freq;
-		smu->cpu_actual_soft_max_freq = smu->cpu_default_soft_max_freq;
+		smu->gfx_actual_soft_max_freq = smu->gfx_default_hard_min_freq;
 
 		ret = vangogh_force_dpm_limit_value(smu, false);
+		if (ret)
+			return ret;
 		break;
 	case AMD_DPM_FORCED_LEVEL_AUTO:
 		smu->gfx_actual_hard_min_freq = smu->gfx_default_hard_min_freq;
 		smu->gfx_actual_soft_max_freq = smu->gfx_default_soft_max_freq;
 
-		smu->cpu_actual_soft_min_freq = smu->cpu_default_soft_min_freq;
-		smu->cpu_actual_soft_max_freq = smu->cpu_default_soft_max_freq;
-
 		ret = vangogh_unforce_dpm_levels(smu);
-		break;
-	case AMD_DPM_FORCED_LEVEL_PROFILE_STANDARD:
-		smu->gfx_actual_hard_min_freq = smu->gfx_default_hard_min_freq;
-		smu->gfx_actual_soft_max_freq = smu->gfx_default_soft_max_freq;
-
-		smu->cpu_actual_soft_min_freq = smu->cpu_default_soft_min_freq;
-		smu->cpu_actual_soft_max_freq = smu->cpu_default_soft_max_freq;
-
-		ret = smu_cmn_send_smc_msg_with_param(smu,
-					SMU_MSG_SetHardMinGfxClk,
-					VANGOGH_UMD_PSTATE_STANDARD_GFXCLK, NULL);
-		if (ret)
-			return ret;
-
-		ret = smu_cmn_send_smc_msg_with_param(smu,
-					SMU_MSG_SetSoftMaxGfxClk,
-					VANGOGH_UMD_PSTATE_STANDARD_GFXCLK, NULL);
 		if (ret)
 			return ret;
+		break;
+	case AMD_DPM_FORCED_LEVEL_PROFILE_STANDARD:
+		smu->gfx_actual_hard_min_freq = VANGOGH_UMD_PSTATE_STANDARD_GFXCLK;
+		smu->gfx_actual_soft_max_freq = VANGOGH_UMD_PSTATE_STANDARD_GFXCLK;
 
 		ret = vangogh_get_profiling_clk_mask(smu, level,
 							&vclk_mask,
@@ -1446,32 +1432,15 @@ static int vangogh_set_performance_level(struct smu_context *smu,
 		vangogh_force_clk_levels(smu, SMU_SOCCLK, 1 << soc_mask);
 		vangogh_force_clk_levels(smu, SMU_VCLK, 1 << vclk_mask);
 		vangogh_force_clk_levels(smu, SMU_DCLK, 1 << dclk_mask);
-
 		break;
 	case AMD_DPM_FORCED_LEVEL_PROFILE_MIN_SCLK:
 		smu->gfx_actual_hard_min_freq = smu->gfx_default_hard_min_freq;
-		smu->gfx_actual_soft_max_freq = smu->gfx_default_soft_max_freq;
-
-		smu->cpu_actual_soft_min_freq = smu->cpu_default_soft_min_freq;
-		smu->cpu_actual_soft_max_freq = smu->cpu_default_soft_max_freq;
-
-		ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetHardMinVcn,
-								VANGOGH_UMD_PSTATE_PEAK_DCLK, NULL);
-		if (ret)
-			return ret;
-
-		ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetSoftMaxVcn,
-								VANGOGH_UMD_PSTATE_PEAK_DCLK, NULL);
-		if (ret)
-			return ret;
+		smu->gfx_actual_soft_max_freq = smu->gfx_default_hard_min_freq;
 		break;
 	case AMD_DPM_FORCED_LEVEL_PROFILE_MIN_MCLK:
 		smu->gfx_actual_hard_min_freq = smu->gfx_default_hard_min_freq;
 		smu->gfx_actual_soft_max_freq = smu->gfx_default_soft_max_freq;
 
-		smu->cpu_actual_soft_min_freq = smu->cpu_default_soft_min_freq;
-		smu->cpu_actual_soft_max_freq = smu->cpu_default_soft_max_freq;
-
 		ret = vangogh_get_profiling_clk_mask(smu, level,
 							NULL,
 							NULL,
@@ -1484,29 +1453,29 @@ static int vangogh_set_performance_level(struct smu_context *smu,
 		vangogh_force_clk_levels(smu, SMU_FCLK, 1 << fclk_mask);
 		break;
 	case AMD_DPM_FORCED_LEVEL_PROFILE_PEAK:
-		smu->gfx_actual_hard_min_freq = smu->gfx_default_hard_min_freq;
-		smu->gfx_actual_soft_max_freq = smu->gfx_default_soft_max_freq;
-
-		smu->cpu_actual_soft_min_freq = smu->cpu_default_soft_min_freq;
-		smu->cpu_actual_soft_max_freq = smu->cpu_default_soft_max_freq;
-
-		ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetHardMinGfxClk,
-				VANGOGH_UMD_PSTATE_PEAK_GFXCLK, NULL);
-		if (ret)
-			return ret;
+		smu->gfx_actual_hard_min_freq = VANGOGH_UMD_PSTATE_PEAK_GFXCLK;
+		smu->gfx_actual_soft_max_freq = VANGOGH_UMD_PSTATE_PEAK_GFXCLK;
 
-		ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetSoftMaxGfxClk,
-				VANGOGH_UMD_PSTATE_PEAK_GFXCLK, NULL);
+		ret = vangogh_set_peak_clock_by_device(smu);
 		if (ret)
 			return ret;
-
-		ret = vangogh_set_peak_clock_by_device(smu);
 		break;
 	case AMD_DPM_FORCED_LEVEL_MANUAL:
 	case AMD_DPM_FORCED_LEVEL_PROFILE_EXIT:
 	default:
-		break;
+		return 0;
 	}
+
+	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetHardMinGfxClk,
+					      smu->gfx_actual_hard_min_freq, NULL);
+	if (ret)
+		return ret;
+
+	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetSoftMaxGfxClk,
+					      smu->gfx_actual_soft_max_freq, NULL);
+	if (ret)
+		return ret;
+
 	return ret;
 }
 
-- 
2.33.0



