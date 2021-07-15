Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC9F3CA9C1
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242691AbhGOTIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:08:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242350AbhGOTHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:07:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C59C613E0;
        Thu, 15 Jul 2021 19:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375832;
        bh=KRP1Cyi2W3dJWgDmqHI0jiFZG7iLyI9OiCvn3Dzv2g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Im/kw2+CPE/kH2pZIN2g7twzUpi1/MYI+c8RzHN7Y3VA/umv5mmBxEZ1dz0UG3dWC
         u5gWV8niyTuejXcQEuBpR+bi8Zj34O5wXyOJtcH8I88MPm3rjGRKzqsvCoBdOk9o32
         HLcjsh3kM/xbWKQn0jEgtGZoBFdNnDdnZ3skmaNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Bakoulin <Ilya.Bakoulin@amd.com>,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 013/266] drm/amd/display: Fix clock table filling logic
Date:   Thu, 15 Jul 2021 20:36:08 +0200
Message-Id: <20210715182616.215822162@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilya Bakoulin <Ilya.Bakoulin@amd.com>

[ Upstream commit c31bef1cb1203b26f901a511a3246204cfaf8a57 ]

[Why]
Currently, the code that fills the clock table can miss filling
information about some of the higher voltage states advertised
by the SMU. This, in turn, may cause some of the higher pixel clock
modes (e.g. 8k60) to fail validation.

[How]
Fill the table with one entry per DCFCLK level instead of one entry
per FCLK level. This is needed because the maximum FCLK does not
necessarily need maximum voltage, whereas DCFCLK values from SMU
cover the full voltage range.

Signed-off-by: Ilya Bakoulin <Ilya.Bakoulin@amd.com>
Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c | 80 ++++++++++++-------
 .../drm/amd/display/dc/dcn21/dcn21_resource.c | 33 +++++---
 2 files changed, 74 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
index 49d19fdd750b..1f56ceab5922 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn21/rn_clk_mgr.c
@@ -834,46 +834,67 @@ static struct wm_table lpddr4_wm_table_rn = {
 		},
 	}
 };
-static unsigned int find_socclk_for_voltage(struct dpm_clocks *clock_table, unsigned int voltage)
+
+static unsigned int find_max_fclk_for_voltage(struct dpm_clocks *clock_table,
+		unsigned int voltage)
 {
 	int i;
+	uint32_t max_clk = 0;
 
-	for (i = 0; i < PP_SMU_NUM_SOCCLK_DPM_LEVELS; i++) {
-		if (clock_table->SocClocks[i].Vol == voltage)
-			return clock_table->SocClocks[i].Freq;
+	for (i = 0; i < PP_SMU_NUM_FCLK_DPM_LEVELS; i++) {
+		if (clock_table->FClocks[i].Vol <= voltage) {
+			max_clk = clock_table->FClocks[i].Freq > max_clk ?
+				clock_table->FClocks[i].Freq : max_clk;
+		}
 	}
 
-	ASSERT(0);
-	return 0;
+	return max_clk;
 }
-static unsigned int find_dcfclk_for_voltage(struct dpm_clocks *clock_table, unsigned int voltage)
+
+static unsigned int find_max_memclk_for_voltage(struct dpm_clocks *clock_table,
+		unsigned int voltage)
 {
 	int i;
+	uint32_t max_clk = 0;
 
-	for (i = 0; i < PP_SMU_NUM_DCFCLK_DPM_LEVELS; i++) {
-		if (clock_table->DcfClocks[i].Vol == voltage)
-			return clock_table->DcfClocks[i].Freq;
+	for (i = 0; i < PP_SMU_NUM_MEMCLK_DPM_LEVELS; i++) {
+		if (clock_table->MemClocks[i].Vol <= voltage) {
+			max_clk = clock_table->MemClocks[i].Freq > max_clk ?
+				clock_table->MemClocks[i].Freq : max_clk;
+		}
 	}
 
-	ASSERT(0);
-	return 0;
+	return max_clk;
+}
+
+static unsigned int find_max_socclk_for_voltage(struct dpm_clocks *clock_table,
+		unsigned int voltage)
+{
+	int i;
+	uint32_t max_clk = 0;
+
+	for (i = 0; i < PP_SMU_NUM_SOCCLK_DPM_LEVELS; i++) {
+		if (clock_table->SocClocks[i].Vol <= voltage) {
+			max_clk = clock_table->SocClocks[i].Freq > max_clk ?
+				clock_table->SocClocks[i].Freq : max_clk;
+		}
+	}
+
+	return max_clk;
 }
 
 static void rn_clk_mgr_helper_populate_bw_params(struct clk_bw_params *bw_params, struct dpm_clocks *clock_table, struct integrated_info *bios_info)
 {
 	int i, j = 0;
+	unsigned int volt;
 
 	j = -1;
 
-	ASSERT(PP_SMU_NUM_FCLK_DPM_LEVELS <= MAX_NUM_DPM_LVL);
-
-	/* Find lowest DPM, FCLK is filled in reverse order*/
-
-	for (i = PP_SMU_NUM_FCLK_DPM_LEVELS - 1; i >= 0; i--) {
-		if (clock_table->FClocks[i].Freq != 0 && clock_table->FClocks[i].Vol != 0) {
+	/* Find max DPM */
+	for (i = 0; i < PP_SMU_NUM_DCFCLK_DPM_LEVELS; ++i) {
+		if (clock_table->DcfClocks[i].Freq != 0 &&
+				clock_table->DcfClocks[i].Vol != 0)
 			j = i;
-			break;
-		}
 	}
 
 	if (j == -1) {
@@ -884,13 +905,18 @@ static void rn_clk_mgr_helper_populate_bw_params(struct clk_bw_params *bw_params
 
 	bw_params->clk_table.num_entries = j + 1;
 
-	for (i = 0; i < bw_params->clk_table.num_entries; i++, j--) {
-		bw_params->clk_table.entries[i].fclk_mhz = clock_table->FClocks[j].Freq;
-		bw_params->clk_table.entries[i].memclk_mhz = clock_table->MemClocks[j].Freq;
-		bw_params->clk_table.entries[i].voltage = clock_table->FClocks[j].Vol;
-		bw_params->clk_table.entries[i].dcfclk_mhz = find_dcfclk_for_voltage(clock_table, clock_table->FClocks[j].Vol);
-		bw_params->clk_table.entries[i].socclk_mhz = find_socclk_for_voltage(clock_table,
-									bw_params->clk_table.entries[i].voltage);
+	for (i = 0; i < bw_params->clk_table.num_entries; i++) {
+		volt = clock_table->DcfClocks[i].Vol;
+
+		bw_params->clk_table.entries[i].voltage = volt;
+		bw_params->clk_table.entries[i].dcfclk_mhz =
+			clock_table->DcfClocks[i].Freq;
+		bw_params->clk_table.entries[i].fclk_mhz =
+			find_max_fclk_for_voltage(clock_table, volt);
+		bw_params->clk_table.entries[i].memclk_mhz =
+			find_max_memclk_for_voltage(clock_table, volt);
+		bw_params->clk_table.entries[i].socclk_mhz =
+			find_max_socclk_for_voltage(clock_table, volt);
 	}
 
 	bw_params->vram_type = bios_info->memory_type;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index 8e3f1d0b4cc3..38a2aa87f5f5 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -1575,10 +1575,12 @@ static struct _vcs_dpi_voltage_scaling_st construct_low_pstate_lvl(struct clk_li
 	low_pstate_lvl.phyclk_d18_mhz = dcn2_1_soc.clock_limits[high_voltage_lvl].phyclk_d18_mhz;
 	low_pstate_lvl.phyclk_mhz = dcn2_1_soc.clock_limits[high_voltage_lvl].phyclk_mhz;
 
-	for (i = clk_table->num_entries; i > 1; i--)
-		clk_table->entries[i] = clk_table->entries[i-1];
-	clk_table->entries[1] = clk_table->entries[0];
-	clk_table->num_entries++;
+	if (clk_table->num_entries < MAX_NUM_DPM_LVL) {
+		for (i = clk_table->num_entries; i > 1; i--)
+			clk_table->entries[i] = clk_table->entries[i-1];
+		clk_table->entries[1] = clk_table->entries[0];
+		clk_table->num_entries++;
+	}
 
 	return low_pstate_lvl;
 }
@@ -1610,10 +1612,6 @@ static void update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_param
 			}
 		}
 
-		/* clk_table[1] is reserved for min DF PState.  skip here to fill in later. */
-		if (i == 1)
-			k++;
-
 		clock_limits[k].state = k;
 		clock_limits[k].dcfclk_mhz = clk_table->entries[i].dcfclk_mhz;
 		clock_limits[k].fabricclk_mhz = clk_table->entries[i].fclk_mhz;
@@ -1630,14 +1628,25 @@ static void update_bw_bounding_box(struct dc *dc, struct clk_bw_params *bw_param
 
 		k++;
 	}
-	for (i = 0; i < clk_table->num_entries + 1; i++)
-		dcn2_1_soc.clock_limits[i] = clock_limits[i];
+
+	if (clk_table->num_entries >= MAX_NUM_DPM_LVL) {
+		for (i = 0; i < clk_table->num_entries + 1; i++)
+			dcn2_1_soc.clock_limits[i] = clock_limits[i];
+	} else {
+		dcn2_1_soc.clock_limits[0] = clock_limits[0];
+		for (i = 2; i < clk_table->num_entries + 1; i++) {
+			dcn2_1_soc.clock_limits[i] = clock_limits[i - 1];
+			dcn2_1_soc.clock_limits[i].state = i;
+		}
+	}
+
 	if (clk_table->num_entries) {
-		dcn2_1_soc.num_states = clk_table->num_entries + 1;
 		/* fill in min DF PState */
 		dcn2_1_soc.clock_limits[1] = construct_low_pstate_lvl(clk_table, closest_clk_lvl);
+		dcn2_1_soc.num_states = clk_table->num_entries;
 		/* duplicate last level */
-		dcn2_1_soc.clock_limits[dcn2_1_soc.num_states] = dcn2_1_soc.clock_limits[dcn2_1_soc.num_states - 1];
+		dcn2_1_soc.clock_limits[dcn2_1_soc.num_states] =
+			dcn2_1_soc.clock_limits[dcn2_1_soc.num_states - 1];
 		dcn2_1_soc.clock_limits[dcn2_1_soc.num_states].state = dcn2_1_soc.num_states;
 	}
 
-- 
2.30.2



