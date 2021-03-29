Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6065534C841
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhC2IVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233400AbhC2IUM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:20:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BAAD61601;
        Mon, 29 Mar 2021 08:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006011;
        bh=0RkUMIz5i3QrNRCJ4RyxRBfmTqMh9VGLT80ALDZPD/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GgfB/gp7ckwQB/rshStOlWIlBIES2W0WJ0kw5BCXe6ZmL5DKcsGWIZvrRt9Glliaj
         3HV8+tqX+eYoINngkPx1wZofpKAHykKZWlfUF9syzhrMcTh8SulOULe8EzsF1SU7kT
         1iVUS//bdRTWa+Ta40rMOQEjMHFvWRagoBEtHfJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 085/221] drm/amd/pm: workaround for audio noise issue
Date:   Mon, 29 Mar 2021 09:56:56 +0200
Message-Id: <20210329075632.049990490@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

commit 9d03730ecbc5afabfda26d4dbb014310bc4ea4d9 upstream.

On some Intel platforms, audio noise can be detected due to
high pcie speed switch latency.
This patch leaverages ppfeaturemask to fix to the highest pcie
speed then disable pcie switching.

v2:
coding style fix

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c   |   54 +++++++++++++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c |   74 +++++++++++++++---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c |   24 +++++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c |   25 ++++++
 4 files changed, 166 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -524,6 +524,48 @@ static int smu7_force_switch_to_arbf0(st
 			tmp, MC_CG_ARB_FREQ_F0);
 }
 
+static uint16_t smu7_override_pcie_speed(struct pp_hwmgr *hwmgr)
+{
+	struct amdgpu_device *adev = (struct amdgpu_device *)(hwmgr->adev);
+	uint16_t pcie_gen = 0;
+
+	if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN4 &&
+	    adev->pm.pcie_gen_mask & CAIL_ASIC_PCIE_LINK_SPEED_SUPPORT_GEN4)
+		pcie_gen = 3;
+	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN3 &&
+		adev->pm.pcie_gen_mask & CAIL_ASIC_PCIE_LINK_SPEED_SUPPORT_GEN3)
+		pcie_gen = 2;
+	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN2 &&
+		adev->pm.pcie_gen_mask & CAIL_ASIC_PCIE_LINK_SPEED_SUPPORT_GEN2)
+		pcie_gen = 1;
+	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN1 &&
+		adev->pm.pcie_gen_mask & CAIL_ASIC_PCIE_LINK_SPEED_SUPPORT_GEN1)
+		pcie_gen = 0;
+
+	return pcie_gen;
+}
+
+static uint16_t smu7_override_pcie_width(struct pp_hwmgr *hwmgr)
+{
+	struct amdgpu_device *adev = (struct amdgpu_device *)(hwmgr->adev);
+	uint16_t pcie_width = 0;
+
+	if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X16)
+		pcie_width = 16;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X12)
+		pcie_width = 12;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X8)
+		pcie_width = 8;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X4)
+		pcie_width = 4;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X2)
+		pcie_width = 2;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X1)
+		pcie_width = 1;
+
+	return pcie_width;
+}
+
 static int smu7_setup_default_pcie_table(struct pp_hwmgr *hwmgr)
 {
 	struct smu7_hwmgr *data = (struct smu7_hwmgr *)(hwmgr->backend);
@@ -620,6 +662,11 @@ static int smu7_setup_default_pcie_table
 					PP_Min_PCIEGen),
 			get_pcie_lane_support(data->pcie_lane_cap,
 					PP_Max_PCIELane));
+
+		if (data->pcie_dpm_key_disabled)
+			phm_setup_pcie_table_entry(&data->dpm_table.pcie_speed_table,
+				data->dpm_table.pcie_speed_table.count,
+				smu7_override_pcie_speed(hwmgr), smu7_override_pcie_width(hwmgr));
 	}
 	return 0;
 }
@@ -1180,6 +1227,13 @@ static int smu7_start_dpm(struct pp_hwmg
 						NULL)),
 				"Failed to enable pcie DPM during DPM Start Function!",
 				return -EINVAL);
+	} else {
+		PP_ASSERT_WITH_CODE(
+				(0 == smum_send_msg_to_smc(hwmgr,
+						PPSMC_MSG_PCIeDPM_Disable,
+						NULL)),
+				"Failed to disble pcie DPM during DPM Start Function!",
+				return -EINVAL);
 	}
 
 	if (phm_cap_enabled(hwmgr->platform_descriptor.platformCaps,
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -54,6 +54,9 @@
 #include "smuio/smuio_9_0_offset.h"
 #include "smuio/smuio_9_0_sh_mask.h"
 
+#define smnPCIE_LC_SPEED_CNTL			0x11140290
+#define smnPCIE_LC_LINK_WIDTH_CNTL		0x11140288
+
 #define HBM_MEMORY_CHANNEL_WIDTH    128
 
 static const uint32_t channel_number[] = {1, 2, 0, 4, 0, 8, 0, 16, 2};
@@ -443,8 +446,7 @@ static void vega10_init_dpm_defaults(str
 	if (PP_CAP(PHM_PlatformCaps_VCEDPM))
 		data->smu_features[GNLD_DPM_VCE].supported = true;
 
-	if (!data->registry_data.pcie_dpm_key_disabled)
-		data->smu_features[GNLD_DPM_LINK].supported = true;
+	data->smu_features[GNLD_DPM_LINK].supported = true;
 
 	if (!data->registry_data.dcefclk_dpm_key_disabled)
 		data->smu_features[GNLD_DPM_DCEFCLK].supported = true;
@@ -1545,6 +1547,13 @@ static int vega10_override_pcie_paramete
 			pp_table->PcieLaneCount[i] = pcie_width;
 	}
 
+	if (data->registry_data.pcie_dpm_key_disabled) {
+		for (i = 0; i < NUM_LINK_LEVELS; i++) {
+			pp_table->PcieGenSpeed[i] = pcie_gen;
+			pp_table->PcieLaneCount[i] = pcie_width;
+		}
+	}
+
 	return 0;
 }
 
@@ -2967,6 +2976,14 @@ static int vega10_start_dpm(struct pp_hw
 		}
 	}
 
+	if (data->registry_data.pcie_dpm_key_disabled) {
+		PP_ASSERT_WITH_CODE(!vega10_enable_smc_features(hwmgr,
+				false, data->smu_features[GNLD_DPM_LINK].smu_feature_bitmap),
+		"Attempt to Disable Link DPM feature Failed!", return -EINVAL);
+		data->smu_features[GNLD_DPM_LINK].enabled = false;
+		data->smu_features[GNLD_DPM_LINK].supported = false;
+	}
+
 	return 0;
 }
 
@@ -4583,6 +4600,24 @@ static int vega10_set_ppfeature_status(s
 	return 0;
 }
 
+static int vega10_get_current_pcie_link_width_level(struct pp_hwmgr *hwmgr)
+{
+	struct amdgpu_device *adev = hwmgr->adev;
+
+	return (RREG32_PCIE(smnPCIE_LC_LINK_WIDTH_CNTL) &
+		PCIE_LC_LINK_WIDTH_CNTL__LC_LINK_WIDTH_RD_MASK)
+		>> PCIE_LC_LINK_WIDTH_CNTL__LC_LINK_WIDTH_RD__SHIFT;
+}
+
+static int vega10_get_current_pcie_link_speed_level(struct pp_hwmgr *hwmgr)
+{
+	struct amdgpu_device *adev = hwmgr->adev;
+
+	return (RREG32_PCIE(smnPCIE_LC_SPEED_CNTL) &
+		PSWUSP0_PCIE_LC_SPEED_CNTL__LC_CURRENT_DATA_RATE_MASK)
+		>> PSWUSP0_PCIE_LC_SPEED_CNTL__LC_CURRENT_DATA_RATE__SHIFT;
+}
+
 static int vega10_print_clock_levels(struct pp_hwmgr *hwmgr,
 		enum pp_clock_type type, char *buf)
 {
@@ -4591,8 +4626,9 @@ static int vega10_print_clock_levels(str
 	struct vega10_single_dpm_table *mclk_table = &(data->dpm_table.mem_table);
 	struct vega10_single_dpm_table *soc_table = &(data->dpm_table.soc_table);
 	struct vega10_single_dpm_table *dcef_table = &(data->dpm_table.dcef_table);
-	struct vega10_pcie_table *pcie_table = &(data->dpm_table.pcie_table);
 	struct vega10_odn_clock_voltage_dependency_table *podn_vdd_dep = NULL;
+	uint32_t gen_speed, lane_width, current_gen_speed, current_lane_width;
+	PPTable_t *pptable = &(data->smc_state_table.pp_table);
 
 	int i, now, size = 0, count = 0;
 
@@ -4649,15 +4685,31 @@ static int vega10_print_clock_levels(str
 					"*" : "");
 		break;
 	case PP_PCIE:
-		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetCurrentLinkIndex, &now);
-
-		for (i = 0; i < pcie_table->count; i++)
-			size += sprintf(buf + size, "%d: %s %s\n", i,
-					(pcie_table->pcie_gen[i] == 0) ? "2.5GT/s, x1" :
-					(pcie_table->pcie_gen[i] == 1) ? "5.0GT/s, x16" :
-					(pcie_table->pcie_gen[i] == 2) ? "8.0GT/s, x16" : "",
-					(i == now) ? "*" : "");
+		current_gen_speed =
+			vega10_get_current_pcie_link_speed_level(hwmgr);
+		current_lane_width =
+			vega10_get_current_pcie_link_width_level(hwmgr);
+		for (i = 0; i < NUM_LINK_LEVELS; i++) {
+			gen_speed = pptable->PcieGenSpeed[i];
+			lane_width = pptable->PcieLaneCount[i];
+
+			size += sprintf(buf + size, "%d: %s %s %s\n", i,
+					(gen_speed == 0) ? "2.5GT/s," :
+					(gen_speed == 1) ? "5.0GT/s," :
+					(gen_speed == 2) ? "8.0GT/s," :
+					(gen_speed == 3) ? "16.0GT/s," : "",
+					(lane_width == 1) ? "x1" :
+					(lane_width == 2) ? "x2" :
+					(lane_width == 3) ? "x4" :
+					(lane_width == 4) ? "x8" :
+					(lane_width == 5) ? "x12" :
+					(lane_width == 6) ? "x16" : "",
+					(current_gen_speed == gen_speed) &&
+					(current_lane_width == lane_width) ?
+					"*" : "");
+		}
 		break;
+
 	case OD_SCLK:
 		if (hwmgr->od_enabled) {
 			size = sprintf(buf, "%s:\n", "OD_SCLK");
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
@@ -133,6 +133,7 @@ static void vega12_set_default_registry_
 	data->registry_data.auto_wattman_debug = 0;
 	data->registry_data.auto_wattman_sample_period = 100;
 	data->registry_data.auto_wattman_threshold = 50;
+	data->registry_data.pcie_dpm_key_disabled = !(hwmgr->feature_mask & PP_PCIE_DPM_MASK);
 }
 
 static int vega12_set_features_platform_caps(struct pp_hwmgr *hwmgr)
@@ -539,6 +540,29 @@ static int vega12_override_pcie_paramete
 		pp_table->PcieLaneCount[i] = pcie_width_arg;
 	}
 
+	/* override to the highest if it's disabled from ppfeaturmask */
+	if (data->registry_data.pcie_dpm_key_disabled) {
+		for (i = 0; i < NUM_LINK_LEVELS; i++) {
+			smu_pcie_arg = (i << 16) | (pcie_gen << 8) | pcie_width;
+			ret = smum_send_msg_to_smc_with_parameter(hwmgr,
+				PPSMC_MSG_OverridePcieParameters, smu_pcie_arg,
+				NULL);
+			PP_ASSERT_WITH_CODE(!ret,
+				"[OverridePcieParameters] Attempt to override pcie params failed!",
+				return ret);
+
+			pp_table->PcieGenSpeed[i] = pcie_gen;
+			pp_table->PcieLaneCount[i] = pcie_width;
+		}
+		ret = vega12_enable_smc_features(hwmgr,
+				false,
+				data->smu_features[GNLD_DPM_LINK].smu_feature_bitmap);
+		PP_ASSERT_WITH_CODE(!ret,
+				"Attempt to Disable DPM LINK Failed!",
+				return ret);
+		data->smu_features[GNLD_DPM_LINK].enabled = false;
+		data->smu_features[GNLD_DPM_LINK].supported = false;
+	}
 	return 0;
 }
 
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -171,6 +171,7 @@ static void vega20_set_default_registry_
 	data->registry_data.gfxoff_controlled_by_driver = 1;
 	data->gfxoff_allowed = false;
 	data->counter_gfxoff = 0;
+	data->registry_data.pcie_dpm_key_disabled = !(hwmgr->feature_mask & PP_PCIE_DPM_MASK);
 }
 
 static int vega20_set_features_platform_caps(struct pp_hwmgr *hwmgr)
@@ -885,6 +886,30 @@ static int vega20_override_pcie_paramete
 		pp_table->PcieLaneCount[i] = pcie_width_arg;
 	}
 
+	/* override to the highest if it's disabled from ppfeaturmask */
+	if (data->registry_data.pcie_dpm_key_disabled) {
+		for (i = 0; i < NUM_LINK_LEVELS; i++) {
+			smu_pcie_arg = (i << 16) | (pcie_gen << 8) | pcie_width;
+			ret = smum_send_msg_to_smc_with_parameter(hwmgr,
+				PPSMC_MSG_OverridePcieParameters, smu_pcie_arg,
+				NULL);
+			PP_ASSERT_WITH_CODE(!ret,
+				"[OverridePcieParameters] Attempt to override pcie params failed!",
+				return ret);
+
+			pp_table->PcieGenSpeed[i] = pcie_gen;
+			pp_table->PcieLaneCount[i] = pcie_width;
+		}
+		ret = vega20_enable_smc_features(hwmgr,
+				false,
+				data->smu_features[GNLD_DPM_LINK].smu_feature_bitmap);
+		PP_ASSERT_WITH_CODE(!ret,
+				"Attempt to Disable DPM LINK Failed!",
+				return ret);
+		data->smu_features[GNLD_DPM_LINK].enabled = false;
+		data->smu_features[GNLD_DPM_LINK].supported = false;
+	}
+
 	return 0;
 }
 


