Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF24D3787D7
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhEJLTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:19:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:44332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236685AbhEJLIc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7935F619CE;
        Mon, 10 May 2021 11:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644600;
        bh=Foo0oml7Ot69CzxMUT/sNgkbu3oPVJHm19/WvKVEHpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WD1tcBIzq0YE3e30Uy0LW7FJhreWeEDOGgNvgAL9Ed56gs/yNMJLIOrVsC/LLPhhc
         Kk20OlrgLkm9S/k3TLBKAQTkMiVyDQQfJxg7ED+xv68yTjBFTFDuKw1oh+2oNAySFH
         4deU2YkIcxFMNUWvH/b4eGygE5reiES/W0yY3zrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 147/384] drm/amd/pm: do not issue message while write "r" into pp_od_clk_voltage
Date:   Mon, 10 May 2021 12:18:56 +0200
Message-Id: <20210510102019.731753991@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huang Rui <ray.huang@amd.com>

[ Upstream commit ca1203d7d7295c49e5707d7def457bdc524a8edb ]

We should commit the value after restore them back to default as well.

$ echo "r" > pp_od_clk_voltage
$ echo "c" > pp_od_clk_voltage

Signed-off-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c  | 14 -------
 .../gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c  | 38 -------------------
 .../gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c   | 18 ---------
 3 files changed, 70 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
index ed05a30d1139..e2a56a7f3d7a 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
@@ -1526,20 +1526,6 @@ static int smu10_set_fine_grain_clk_vol(struct pp_hwmgr *hwmgr,
 
 		smu10_data->gfx_actual_soft_min_freq = min_freq;
 		smu10_data->gfx_actual_soft_max_freq = max_freq;
-
-		ret = smum_send_msg_to_smc_with_parameter(hwmgr,
-					PPSMC_MSG_SetHardMinGfxClk,
-					min_freq,
-					NULL);
-		if (ret)
-			return ret;
-
-		ret = smum_send_msg_to_smc_with_parameter(hwmgr,
-					PPSMC_MSG_SetSoftMaxGfxClk,
-					max_freq,
-					NULL);
-		if (ret)
-			return ret;
 	} else if (type == PP_OD_COMMIT_DPM_TABLE) {
 		if (size != 0) {
 			pr_err("Input parameter number not correct\n");
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
index 101eaa20db9b..a80f551771b9 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/vangogh_ppt.c
@@ -1462,7 +1462,6 @@ static int vangogh_od_edit_dpm_table(struct smu_context *smu, enum PP_OD_DPM_TAB
 					long input[], uint32_t size)
 {
 	int ret = 0;
-	int i;
 	struct smu_dpm_context *smu_dpm_ctx = &(smu->smu_dpm);
 
 	if (!(smu_dpm_ctx->dpm_level == AMD_DPM_FORCED_LEVEL_MANUAL)) {
@@ -1535,43 +1534,6 @@ static int vangogh_od_edit_dpm_table(struct smu_context *smu, enum PP_OD_DPM_TAB
 			smu->gfx_actual_soft_max_freq = smu->gfx_default_soft_max_freq;
 			smu->cpu_actual_soft_min_freq = smu->cpu_default_soft_min_freq;
 			smu->cpu_actual_soft_max_freq = smu->cpu_default_soft_max_freq;
-
-			ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetHardMinGfxClk,
-									smu->gfx_actual_hard_min_freq, NULL);
-			if (ret) {
-				dev_err(smu->adev->dev, "Restore the default hard min sclk failed!");
-				return ret;
-			}
-
-			ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetSoftMaxGfxClk,
-									smu->gfx_actual_soft_max_freq, NULL);
-			if (ret) {
-				dev_err(smu->adev->dev, "Restore the default soft max sclk failed!");
-				return ret;
-			}
-
-			if (smu->adev->pm.fw_version < 0x43f1b00) {
-				dev_warn(smu->adev->dev, "CPUSoftMax/CPUSoftMin are not supported, please update SBIOS!\n");
-				break;
-			}
-
-			for (i = 0; i < smu->cpu_core_num; i++) {
-				ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetSoftMinCclk,
-								      (i << 20) | smu->cpu_actual_soft_min_freq,
-								      NULL);
-				if (ret) {
-					dev_err(smu->adev->dev, "Set hard min cclk failed!");
-					return ret;
-				}
-
-				ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetSoftMaxCclk,
-								      (i << 20) | smu->cpu_actual_soft_max_freq,
-								      NULL);
-				if (ret) {
-					dev_err(smu->adev->dev, "Set soft max cclk failed!");
-					return ret;
-				}
-			}
 		}
 		break;
 	case PP_OD_COMMIT_DPM_TABLE:
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
index 5493388fcb10..dbe6d0caddb7 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
@@ -389,24 +389,6 @@ static int renoir_od_edit_dpm_table(struct smu_context *smu,
 		}
 		smu->gfx_actual_hard_min_freq = smu->gfx_default_hard_min_freq;
 		smu->gfx_actual_soft_max_freq = smu->gfx_default_soft_max_freq;
-
-		ret = smu_cmn_send_smc_msg_with_param(smu,
-								SMU_MSG_SetHardMinGfxClk,
-								smu->gfx_actual_hard_min_freq,
-								NULL);
-		if (ret) {
-			dev_err(smu->adev->dev, "Restore the default hard min sclk failed!");
-			return ret;
-		}
-
-		ret = smu_cmn_send_smc_msg_with_param(smu,
-								SMU_MSG_SetSoftMaxGfxClk,
-								smu->gfx_actual_soft_max_freq,
-								NULL);
-		if (ret) {
-			dev_err(smu->adev->dev, "Restore the default soft max sclk failed!");
-			return ret;
-		}
 		break;
 	case PP_OD_COMMIT_DPM_TABLE:
 		if (size != 0) {
-- 
2.30.2



