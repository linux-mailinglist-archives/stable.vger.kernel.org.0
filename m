Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D063833B788
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbhCOOAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232659AbhCON71 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00F4D64F29;
        Mon, 15 Mar 2021 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816743;
        bh=05QGkojovRUw6LUeW3+N95lixTqR8zyEomaA76ylCBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyqMRJk77R01LO9P/mtVzDoXY+KkmMgmLpCmx64N8KGXxGuj4gfPsZQdMXW4+4UEE
         gJdt6zcb0OaBnAMKenZsA7CLMpl+ggNAiwbCsTvY5mN7Pygn1wOGTx6HBNeWR6YsEX
         cj1zMUyaghYHSmPjPf1TprOq9XE+ezO0akK5ZviA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Feng <kenneth.feng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 088/290] drm/amd/pm: bug fix for pcie dpm
Date:   Mon, 15 Mar 2021 14:53:01 +0100
Message-Id: <20210315135544.894169884@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Kenneth Feng <kenneth.feng@amd.com>

commit 50ceb1fe7acd50831180f4b5597bf7b39e8059c8 upstream.

Currently the pcie dpm has two problems.
1. Only the high dpm level speed/width can be overrided
if the requested values are out of the pcie capability.
2. The high dpm level is always overrided though sometimes
it's not necesarry.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c |   48 +++++++++++++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c |   66 ++++++++++++++++++
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c |   48 +++++++------
 3 files changed, 141 insertions(+), 21 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -1506,6 +1506,48 @@ static int vega10_populate_single_lclk_l
 	return 0;
 }
 
+static int vega10_override_pcie_parameters(struct pp_hwmgr *hwmgr)
+{
+	struct amdgpu_device *adev = (struct amdgpu_device *)(hwmgr->adev);
+	struct vega10_hwmgr *data =
+			(struct vega10_hwmgr *)(hwmgr->backend);
+	uint32_t pcie_gen = 0, pcie_width = 0;
+	PPTable_t *pp_table = &(data->smc_state_table.pp_table);
+	int i;
+
+	if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN4)
+		pcie_gen = 3;
+	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN3)
+		pcie_gen = 2;
+	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN2)
+		pcie_gen = 1;
+	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN1)
+		pcie_gen = 0;
+
+	if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X16)
+		pcie_width = 6;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X12)
+		pcie_width = 5;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X8)
+		pcie_width = 4;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X4)
+		pcie_width = 3;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X2)
+		pcie_width = 2;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X1)
+		pcie_width = 1;
+
+	for (i = 0; i < NUM_LINK_LEVELS; i++) {
+		if (pp_table->PcieGenSpeed[i] > pcie_gen)
+			pp_table->PcieGenSpeed[i] = pcie_gen;
+
+		if (pp_table->PcieLaneCount[i] > pcie_width)
+			pp_table->PcieLaneCount[i] = pcie_width;
+	}
+
+	return 0;
+}
+
 static int vega10_populate_smc_link_levels(struct pp_hwmgr *hwmgr)
 {
 	int result = -1;
@@ -2557,6 +2599,11 @@ static int vega10_init_smc_table(struct
 			"Failed to initialize Link Level!",
 			return result);
 
+	result = vega10_override_pcie_parameters(hwmgr);
+	PP_ASSERT_WITH_CODE(!result,
+			"Failed to override pcie parameters!",
+			return result);
+
 	result = vega10_populate_all_graphic_levels(hwmgr);
 	PP_ASSERT_WITH_CODE(!result,
 			"Failed to initialize Graphics Level!",
@@ -2923,6 +2970,7 @@ static int vega10_start_dpm(struct pp_hw
 	return 0;
 }
 
+
 static int vega10_enable_disable_PCC_limit_feature(struct pp_hwmgr *hwmgr, bool enable)
 {
 	struct vega10_hwmgr *data = hwmgr->backend;
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
@@ -481,6 +481,67 @@ static void vega12_init_dpm_state(struct
 	dpm_state->hard_max_level = 0xffff;
 }
 
+static int vega12_override_pcie_parameters(struct pp_hwmgr *hwmgr)
+{
+	struct amdgpu_device *adev = (struct amdgpu_device *)(hwmgr->adev);
+	struct vega12_hwmgr *data =
+			(struct vega12_hwmgr *)(hwmgr->backend);
+	uint32_t pcie_gen = 0, pcie_width = 0, smu_pcie_arg, pcie_gen_arg, pcie_width_arg;
+	PPTable_t *pp_table = &(data->smc_state_table.pp_table);
+	int i;
+	int ret;
+
+	if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN4)
+		pcie_gen = 3;
+	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN3)
+		pcie_gen = 2;
+	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN2)
+		pcie_gen = 1;
+	else if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN1)
+		pcie_gen = 0;
+
+	if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X16)
+		pcie_width = 6;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X12)
+		pcie_width = 5;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X8)
+		pcie_width = 4;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X4)
+		pcie_width = 3;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X2)
+		pcie_width = 2;
+	else if (adev->pm.pcie_mlw_mask & CAIL_PCIE_LINK_WIDTH_SUPPORT_X1)
+		pcie_width = 1;
+
+	/* Bit 31:16: LCLK DPM level. 0 is DPM0, and 1 is DPM1
+	 * Bit 15:8:  PCIE GEN, 0 to 3 corresponds to GEN1 to GEN4
+	 * Bit 7:0:   PCIE lane width, 1 to 7 corresponds is x1 to x32
+	 */
+	for (i = 0; i < NUM_LINK_LEVELS; i++) {
+		pcie_gen_arg = (pp_table->PcieGenSpeed[i] > pcie_gen) ? pcie_gen :
+			pp_table->PcieGenSpeed[i];
+		pcie_width_arg = (pp_table->PcieLaneCount[i] > pcie_width) ? pcie_width :
+			pp_table->PcieLaneCount[i];
+
+		if (pcie_gen_arg != pp_table->PcieGenSpeed[i] || pcie_width_arg !=
+		    pp_table->PcieLaneCount[i]) {
+			smu_pcie_arg = (i << 16) | (pcie_gen_arg << 8) | pcie_width_arg;
+			ret = smum_send_msg_to_smc_with_parameter(hwmgr,
+				PPSMC_MSG_OverridePcieParameters, smu_pcie_arg,
+				NULL);
+			PP_ASSERT_WITH_CODE(!ret,
+				"[OverridePcieParameters] Attempt to override pcie params failed!",
+				return ret);
+		}
+
+		/* update the pptable */
+		pp_table->PcieGenSpeed[i] = pcie_gen_arg;
+		pp_table->PcieLaneCount[i] = pcie_width_arg;
+	}
+
+	return 0;
+}
+
 static int vega12_get_number_of_dpm_level(struct pp_hwmgr *hwmgr,
 		PPCLK_e clk_id, uint32_t *num_of_levels)
 {
@@ -969,6 +1030,11 @@ static int vega12_enable_dpm_tasks(struc
 			"Failed to enable all smu features!",
 			return result);
 
+	result = vega12_override_pcie_parameters(hwmgr);
+	PP_ASSERT_WITH_CODE(!result,
+			"[EnableDPMTasks] Failed to override pcie parameters!",
+			return result);
+
 	tmp_result = vega12_power_control_set_level(hwmgr);
 	PP_ASSERT_WITH_CODE(!tmp_result,
 			"Failed to power control set level!",
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -832,7 +832,9 @@ static int vega20_override_pcie_paramete
 	struct amdgpu_device *adev = (struct amdgpu_device *)(hwmgr->adev);
 	struct vega20_hwmgr *data =
 			(struct vega20_hwmgr *)(hwmgr->backend);
-	uint32_t pcie_gen = 0, pcie_width = 0, smu_pcie_arg;
+	uint32_t pcie_gen = 0, pcie_width = 0, smu_pcie_arg, pcie_gen_arg, pcie_width_arg;
+	PPTable_t *pp_table = &(data->smc_state_table.pp_table);
+	int i;
 	int ret;
 
 	if (adev->pm.pcie_gen_mask & CAIL_PCIE_LINK_SPEED_SUPPORT_GEN4)
@@ -861,17 +863,27 @@ static int vega20_override_pcie_paramete
 	 * Bit 15:8:  PCIE GEN, 0 to 3 corresponds to GEN1 to GEN4
 	 * Bit 7:0:   PCIE lane width, 1 to 7 corresponds is x1 to x32
 	 */
-	smu_pcie_arg = (1 << 16) | (pcie_gen << 8) | pcie_width;
-	ret = smum_send_msg_to_smc_with_parameter(hwmgr,
-			PPSMC_MSG_OverridePcieParameters, smu_pcie_arg,
-			NULL);
-	PP_ASSERT_WITH_CODE(!ret,
-		"[OverridePcieParameters] Attempt to override pcie params failed!",
-		return ret);
+	for (i = 0; i < NUM_LINK_LEVELS; i++) {
+		pcie_gen_arg = (pp_table->PcieGenSpeed[i] > pcie_gen) ? pcie_gen :
+			pp_table->PcieGenSpeed[i];
+		pcie_width_arg = (pp_table->PcieLaneCount[i] > pcie_width) ? pcie_width :
+			pp_table->PcieLaneCount[i];
+
+		if (pcie_gen_arg != pp_table->PcieGenSpeed[i] || pcie_width_arg !=
+		    pp_table->PcieLaneCount[i]) {
+			smu_pcie_arg = (i << 16) | (pcie_gen_arg << 8) | pcie_width_arg;
+			ret = smum_send_msg_to_smc_with_parameter(hwmgr,
+				PPSMC_MSG_OverridePcieParameters, smu_pcie_arg,
+				NULL);
+			PP_ASSERT_WITH_CODE(!ret,
+				"[OverridePcieParameters] Attempt to override pcie params failed!",
+				return ret);
+		}
 
-	data->pcie_parameters_override = true;
-	data->pcie_gen_level1 = pcie_gen;
-	data->pcie_width_level1 = pcie_width;
+		/* update the pptable */
+		pp_table->PcieGenSpeed[i] = pcie_gen_arg;
+		pp_table->PcieLaneCount[i] = pcie_width_arg;
+	}
 
 	return 0;
 }
@@ -3320,9 +3332,7 @@ static int vega20_print_clock_levels(str
 			data->od8_settings.od8_settings_array;
 	OverDriveTable_t *od_table =
 			&(data->smc_state_table.overdrive_table);
-	struct phm_ppt_v3_information *pptable_information =
-		(struct phm_ppt_v3_information *)hwmgr->pptable;
-	PPTable_t *pptable = (PPTable_t *)pptable_information->smc_pptable;
+	PPTable_t *pptable = &(data->smc_state_table.pp_table);
 	struct pp_clock_levels_with_latency clocks;
 	struct vega20_single_dpm_table *fclk_dpm_table =
 			&(data->dpm_table.fclk_table);
@@ -3421,13 +3431,9 @@ static int vega20_print_clock_levels(str
 		current_lane_width =
 			vega20_get_current_pcie_link_width_level(hwmgr);
 		for (i = 0; i < NUM_LINK_LEVELS; i++) {
-			if (i == 1 && data->pcie_parameters_override) {
-				gen_speed = data->pcie_gen_level1;
-				lane_width = data->pcie_width_level1;
-			} else {
-				gen_speed = pptable->PcieGenSpeed[i];
-				lane_width = pptable->PcieLaneCount[i];
-			}
+			gen_speed = pptable->PcieGenSpeed[i];
+			lane_width = pptable->PcieLaneCount[i];
+
 			size += sprintf(buf + size, "%d: %s %s %dMhz %s\n", i,
 					(gen_speed == 0) ? "2.5GT/s," :
 					(gen_speed == 1) ? "5.0GT/s," :


