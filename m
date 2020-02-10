Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60339157715
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgBJM5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:57:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:43688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729995AbgBJMl2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:28 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79645208C4;
        Mon, 10 Feb 2020 12:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338487;
        bh=MPpDI4Bsafh6FxZF1indLaeR3QiuTyqhd1vn0kQxvzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ayodWADbYOAJO8M/06/cCbjtqAT/EdCmclAdYiIgMIws+qDqYWdD2fTkLNSq7cq7B
         ZpXsHERCfuhQE0izHK8To8VB1KCA3DK5M8YpYpnlQMeVhQpFBhRJ0fSPgug5R4vqqO
         asGLxIBgn/SgqBPwkivB0DEZPaYD+KZx4ZhqtlE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Feifei Xu <Feifei.Xu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.5 269/367] drm/amd/powerplay: fix navi10 system intermittent reboot issue V2
Date:   Mon, 10 Feb 2020 04:33:02 -0800
Message-Id: <20200210122449.182432318@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 1cf8c930b378016846c88ef0f1444248033326ec upstream.

This workaround is needed only for Navi10 12 Gbps SKUs.

V2: added SMU firmware version guard

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/powerplay/amdgpu_smu.c          |   18 ++++++
 drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h      |    1 
 drivers/gpu/drm/amd/powerplay/inc/smu_types.h       |    2 
 drivers/gpu/drm/amd/powerplay/inc/smu_v11_0_ppsmc.h |    5 +
 drivers/gpu/drm/amd/powerplay/navi10_ppt.c          |   58 ++++++++++++++++++++
 drivers/gpu/drm/amd/powerplay/smu_internal.h        |    3 +
 6 files changed, 86 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/powerplay/amdgpu_smu.c
@@ -21,6 +21,7 @@
  */
 
 #include <linux/firmware.h>
+#include <linux/pci.h>
 
 #include "pp_debug.h"
 #include "amdgpu.h"
@@ -1125,6 +1126,23 @@ static int smu_smc_table_hw_init(struct
 		ret = smu_get_power_limit(smu, &smu->default_power_limit, false, false);
 		if (ret)
 			return ret;
+
+		if (adev->asic_type == CHIP_NAVI10) {
+			if ((adev->pdev->device == 0x731f && (adev->pdev->revision == 0xc2 ||
+							      adev->pdev->revision == 0xc3 ||
+							      adev->pdev->revision == 0xca ||
+							      adev->pdev->revision == 0xcb)) ||
+			    (adev->pdev->device == 0x66af && (adev->pdev->revision == 0xf3 ||
+							      adev->pdev->revision == 0xf4 ||
+							      adev->pdev->revision == 0xf5 ||
+							      adev->pdev->revision == 0xf6))) {
+				ret = smu_disable_umc_cdr_12gbps_workaround(smu);
+				if (ret) {
+					pr_err("Workaround failed to disable UMC CDR feature on 12Gbps SKU!\n");
+					return ret;
+				}
+			}
+		}
 	}
 
 	/*
--- a/drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/amdgpu_smu.h
@@ -550,6 +550,7 @@ struct pptable_funcs {
 	int (*set_soft_freq_limited_range)(struct smu_context *smu, enum smu_clk_type clk_type, uint32_t min, uint32_t max);
 	int (*override_pcie_parameters)(struct smu_context *smu);
 	uint32_t (*get_pptable_power_limit)(struct smu_context *smu);
+	int (*disable_umc_cdr_12gbps_workaround)(struct smu_context *smu);
 };
 
 int smu_load_microcode(struct smu_context *smu);
--- a/drivers/gpu/drm/amd/powerplay/inc/smu_types.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/smu_types.h
@@ -170,6 +170,8 @@
 	__SMU_DUMMY_MAP(SetSoftMinJpeg),              \
 	__SMU_DUMMY_MAP(SetHardMinFclkByFreq),        \
 	__SMU_DUMMY_MAP(DFCstateControl), \
+	__SMU_DUMMY_MAP(DAL_DISABLE_DUMMY_PSTATE_CHANGE), \
+	__SMU_DUMMY_MAP(DAL_ENABLE_DUMMY_PSTATE_CHANGE), \
 
 #undef __SMU_DUMMY_MAP
 #define __SMU_DUMMY_MAP(type)	SMU_MSG_##type
--- a/drivers/gpu/drm/amd/powerplay/inc/smu_v11_0_ppsmc.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/smu_v11_0_ppsmc.h
@@ -120,7 +120,10 @@
 #define PPSMC_MSG_GetVoltageByDpmOverdrive       0x45
 #define PPSMC_MSG_BacoAudioD3PME                 0x48
 
-#define PPSMC_Message_Count                      0x49
+#define PPSMC_MSG_DALDisableDummyPstateChange    0x49
+#define PPSMC_MSG_DALEnableDummyPstateChange     0x4A
+
+#define PPSMC_Message_Count                      0x4B
 
 typedef uint32_t PPSMC_Result;
 typedef uint32_t PPSMC_Msg;
--- a/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/navi10_ppt.c
@@ -119,6 +119,8 @@ static struct smu_11_0_cmn2aisc_mapping
 	MSG_MAP(PowerDownJpeg,		PPSMC_MSG_PowerDownJpeg),
 	MSG_MAP(BacoAudioD3PME,		PPSMC_MSG_BacoAudioD3PME),
 	MSG_MAP(ArmD3,			PPSMC_MSG_ArmD3),
+	MSG_MAP(DAL_DISABLE_DUMMY_PSTATE_CHANGE,PPSMC_MSG_DALDisableDummyPstateChange),
+	MSG_MAP(DAL_ENABLE_DUMMY_PSTATE_CHANGE,	PPSMC_MSG_DALEnableDummyPstateChange),
 };
 
 static struct smu_11_0_cmn2aisc_mapping navi10_clk_map[SMU_CLK_COUNT] = {
@@ -2000,6 +2002,61 @@ static int navi10_run_btc(struct smu_con
 	return ret;
 }
 
+static int navi10_dummy_pstate_control(struct smu_context *smu, bool enable)
+{
+	int result = 0;
+
+	if (!enable)
+		result = smu_send_smc_msg(smu, SMU_MSG_DAL_DISABLE_DUMMY_PSTATE_CHANGE);
+	else
+		result = smu_send_smc_msg(smu, SMU_MSG_DAL_ENABLE_DUMMY_PSTATE_CHANGE);
+
+	return result;
+}
+
+static int navi10_disable_umc_cdr_12gbps_workaround(struct smu_context *smu)
+{
+	uint32_t uclk_count, uclk_min, uclk_max;
+	uint32_t smu_version;
+	int ret = 0;
+
+	ret = smu_get_smc_version(smu, NULL, &smu_version);
+	if (ret)
+		return ret;
+
+	/* This workaround is available only for 42.50 or later SMC firmwares */
+	if (smu_version < 0x2A3200)
+		return 0;
+
+	ret = smu_get_dpm_level_count(smu, SMU_UCLK, &uclk_count);
+	if (ret)
+		return ret;
+
+	ret = smu_get_dpm_freq_by_index(smu, SMU_UCLK, (uint16_t)0, &uclk_min);
+	if (ret)
+		return ret;
+
+	ret = smu_get_dpm_freq_by_index(smu, SMU_UCLK, (uint16_t)(uclk_count - 1), &uclk_max);
+	if (ret)
+		return ret;
+
+	/* Force UCLK out of the highest DPM */
+	ret = smu_set_hard_freq_range(smu, SMU_UCLK, 0, uclk_min);
+	if (ret)
+		return ret;
+
+	/* Revert the UCLK Hardmax */
+	ret = smu_set_hard_freq_range(smu, SMU_UCLK, 0, uclk_max);
+	if (ret)
+		return ret;
+
+	/*
+	 * In this case, SMU already disabled dummy pstate during enablement
+	 * of UCLK DPM, we have to re-enabled it.
+	 * */
+	return navi10_dummy_pstate_control(smu, true);
+}
+
 static const struct pptable_funcs navi10_ppt_funcs = {
 	.tables_init = navi10_tables_init,
 	.alloc_dpm_context = navi10_allocate_dpm_context,
@@ -2091,6 +2148,7 @@ static const struct pptable_funcs navi10
 	.od_edit_dpm_table = navi10_od_edit_dpm_table,
 	.get_pptable_power_limit = navi10_get_pptable_power_limit,
 	.run_btc = navi10_run_btc,
+	.disable_umc_cdr_12gbps_workaround = navi10_disable_umc_cdr_12gbps_workaround,
 };
 
 void navi10_set_ppt_funcs(struct smu_context *smu)
--- a/drivers/gpu/drm/amd/powerplay/smu_internal.h
+++ b/drivers/gpu/drm/amd/powerplay/smu_internal.h
@@ -201,4 +201,7 @@ int smu_send_smc_msg(struct smu_context
 #define smu_update_pcie_parameters(smu, pcie_gen_cap, pcie_width_cap) \
 		((smu)->ppt_funcs->update_pcie_parameters ? (smu)->ppt_funcs->update_pcie_parameters((smu), (pcie_gen_cap), (pcie_width_cap)) : 0)
 
+#define smu_disable_umc_cdr_12gbps_workaround(smu) \
+	((smu)->ppt_funcs->disable_umc_cdr_12gbps_workaround ? (smu)->ppt_funcs->disable_umc_cdr_12gbps_workaround((smu)) : 0)
+
 #endif


