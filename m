Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588944626A9
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235679AbhK2Wzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236125AbhK2WzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:55:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6145FC12BCFB;
        Mon, 29 Nov 2021 10:35:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 775CDCE13BF;
        Mon, 29 Nov 2021 18:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E026C53FAD;
        Mon, 29 Nov 2021 18:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210924;
        bh=XpNRRGGXZGQWM8lt3DtGKt7WLlzhPla5x05oD+1Fkvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EdT9zrNmEjHVnANL6iusiljgULt8WCdTuUoePIUAYKUu2H5CMpFSd5pXsw7xxDwfm
         RrDgrEQ1yozY8LVzl166Gnxq6VzyWosTxCOxyD2CFKbSGYTBPRNb4CaNjd4UZWsia9
         Zxi7rRudSwSauehZQmDnt2nVfTbwSsQkljt26INE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 042/179] drm/amdgpu/pm: fix powerplay OD interface
Date:   Mon, 29 Nov 2021 19:17:16 +0100
Message-Id: <20211129181720.349253664@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit d5c7255dc7ff6e1239d794b9c53029d83ced04ca upstream.

The overclocking interface currently appends data to a
string.  Revert back to using sprintf().

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1774
Fixes: 6db0c87a0a8ee1 ("amdgpu/pm: Replace hwmgr smu usage of sprintf with sysfs_emit")
Acked-by: Evan Quan <evan.quan@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c  |   20 ++----
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c   |   24 +++----
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c   |    6 -
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c |   28 ++++----
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c |   10 +--
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c |   58 ++++++++----------
 6 files changed, 67 insertions(+), 79 deletions(-)

--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
@@ -1024,8 +1024,6 @@ static int smu10_print_clock_levels(stru
 	uint32_t min_freq, max_freq = 0;
 	uint32_t ret = 0;
 
-	phm_get_sysfs_buf(&buf, &size);
-
 	switch (type) {
 	case PP_SCLK:
 		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetGfxclkFrequency, &now);
@@ -1038,13 +1036,13 @@ static int smu10_print_clock_levels(stru
 		else
 			i = 1;
 
-		size += sysfs_emit_at(buf, size, "0: %uMhz %s\n",
+		size += sprintf(buf + size, "0: %uMhz %s\n",
 					data->gfx_min_freq_limit/100,
 					i == 0 ? "*" : "");
-		size += sysfs_emit_at(buf, size, "1: %uMhz %s\n",
+		size += sprintf(buf + size, "1: %uMhz %s\n",
 					i == 1 ? now : SMU10_UMD_PSTATE_GFXCLK,
 					i == 1 ? "*" : "");
-		size += sysfs_emit_at(buf, size, "2: %uMhz %s\n",
+		size += sprintf(buf + size, "2: %uMhz %s\n",
 					data->gfx_max_freq_limit/100,
 					i == 2 ? "*" : "");
 		break;
@@ -1052,7 +1050,7 @@ static int smu10_print_clock_levels(stru
 		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetFclkFrequency, &now);
 
 		for (i = 0; i < mclk_table->count; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 					i,
 					mclk_table->entries[i].clk / 100,
 					((mclk_table->entries[i].clk / 100)
@@ -1067,10 +1065,10 @@ static int smu10_print_clock_levels(stru
 			if (ret)
 				return ret;
 
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_SCLK");
-			size += sysfs_emit_at(buf, size, "0: %10uMhz\n",
+			size += sprintf(buf + size, "%s:\n", "OD_SCLK");
+			size += sprintf(buf + size, "0: %10uMhz\n",
 			(data->gfx_actual_soft_min_freq > 0) ? data->gfx_actual_soft_min_freq : min_freq);
-			size += sysfs_emit_at(buf, size, "1: %10uMhz\n",
+			size += sprintf(buf + size, "1: %10uMhz\n",
 			(data->gfx_actual_soft_max_freq > 0) ? data->gfx_actual_soft_max_freq : max_freq);
 		}
 		break;
@@ -1083,8 +1081,8 @@ static int smu10_print_clock_levels(stru
 			if (ret)
 				return ret;
 
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_RANGE");
-			size += sysfs_emit_at(buf, size, "SCLK: %7uMHz %10uMHz\n",
+			size += sprintf(buf + size, "%s:\n", "OD_RANGE");
+			size += sprintf(buf + size, "SCLK: %7uMHz %10uMHz\n",
 				min_freq, max_freq);
 		}
 		break;
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -4914,8 +4914,6 @@ static int smu7_print_clock_levels(struc
 	int size = 0;
 	uint32_t i, now, clock, pcie_speed;
 
-	phm_get_sysfs_buf(&buf, &size);
-
 	switch (type) {
 	case PP_SCLK:
 		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_API_GetSclkFrequency, &clock);
@@ -4928,7 +4926,7 @@ static int smu7_print_clock_levels(struc
 		now = i;
 
 		for (i = 0; i < sclk_table->count; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 					i, sclk_table->dpm_levels[i].value / 100,
 					(i == now) ? "*" : "");
 		break;
@@ -4943,7 +4941,7 @@ static int smu7_print_clock_levels(struc
 		now = i;
 
 		for (i = 0; i < mclk_table->count; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 					i, mclk_table->dpm_levels[i].value / 100,
 					(i == now) ? "*" : "");
 		break;
@@ -4957,7 +4955,7 @@ static int smu7_print_clock_levels(struc
 		now = i;
 
 		for (i = 0; i < pcie_table->count; i++)
-			size += sysfs_emit_at(buf, size, "%d: %s %s\n", i,
+			size += sprintf(buf + size, "%d: %s %s\n", i,
 					(pcie_table->dpm_levels[i].value == 0) ? "2.5GT/s, x8" :
 					(pcie_table->dpm_levels[i].value == 1) ? "5.0GT/s, x16" :
 					(pcie_table->dpm_levels[i].value == 2) ? "8.0GT/s, x16" : "",
@@ -4965,32 +4963,32 @@ static int smu7_print_clock_levels(struc
 		break;
 	case OD_SCLK:
 		if (hwmgr->od_enabled) {
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_SCLK");
+			size += sprintf(buf + size, "%s:\n", "OD_SCLK");
 			for (i = 0; i < odn_sclk_table->num_of_pl; i++)
-				size += sysfs_emit_at(buf, size, "%d: %10uMHz %10umV\n",
+				size += sprintf(buf + size, "%d: %10uMHz %10umV\n",
 					i, odn_sclk_table->entries[i].clock/100,
 					odn_sclk_table->entries[i].vddc);
 		}
 		break;
 	case OD_MCLK:
 		if (hwmgr->od_enabled) {
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_MCLK");
+			size += sprintf(buf + size, "%s:\n", "OD_MCLK");
 			for (i = 0; i < odn_mclk_table->num_of_pl; i++)
-				size += sysfs_emit_at(buf, size, "%d: %10uMHz %10umV\n",
+				size += sprintf(buf + size, "%d: %10uMHz %10umV\n",
 					i, odn_mclk_table->entries[i].clock/100,
 					odn_mclk_table->entries[i].vddc);
 		}
 		break;
 	case OD_RANGE:
 		if (hwmgr->od_enabled) {
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_RANGE");
-			size += sysfs_emit_at(buf, size, "SCLK: %7uMHz %10uMHz\n",
+			size += sprintf(buf + size, "%s:\n", "OD_RANGE");
+			size += sprintf(buf + size, "SCLK: %7uMHz %10uMHz\n",
 				data->golden_dpm_table.sclk_table.dpm_levels[0].value/100,
 				hwmgr->platform_descriptor.overdriveLimit.engineClock/100);
-			size += sysfs_emit_at(buf, size, "MCLK: %7uMHz %10uMHz\n",
+			size += sprintf(buf + size, "MCLK: %7uMHz %10uMHz\n",
 				data->golden_dpm_table.mclk_table.dpm_levels[0].value/100,
 				hwmgr->platform_descriptor.overdriveLimit.memoryClock/100);
-			size += sysfs_emit_at(buf, size, "VDDC: %7umV %11umV\n",
+			size += sprintf(buf + size, "VDDC: %7umV %11umV\n",
 				data->odn_dpm_table.min_vddc,
 				data->odn_dpm_table.max_vddc);
 		}
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu8_hwmgr.c
@@ -1550,8 +1550,6 @@ static int smu8_print_clock_levels(struc
 	uint32_t i, now;
 	int size = 0;
 
-	phm_get_sysfs_buf(&buf, &size);
-
 	switch (type) {
 	case PP_SCLK:
 		now = PHM_GET_FIELD(cgs_read_ind_register(hwmgr->device,
@@ -1561,7 +1559,7 @@ static int smu8_print_clock_levels(struc
 				CURR_SCLK_INDEX);
 
 		for (i = 0; i < sclk_table->count; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 					i, sclk_table->entries[i].clk / 100,
 					(i == now) ? "*" : "");
 		break;
@@ -1573,7 +1571,7 @@ static int smu8_print_clock_levels(struc
 				CURR_MCLK_INDEX);
 
 		for (i = SMU8_NUM_NBPMEMORYCLOCK; i > 0; i--)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 					SMU8_NUM_NBPMEMORYCLOCK-i, data->sys_info.nbp_memory_clock[i-1] / 100,
 					(SMU8_NUM_NBPMEMORYCLOCK-i == now) ? "*" : "");
 		break;
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -4639,8 +4639,6 @@ static int vega10_print_clock_levels(str
 
 	int i, now, size = 0, count = 0;
 
-	phm_get_sysfs_buf(&buf, &size);
-
 	switch (type) {
 	case PP_SCLK:
 		if (data->registry_data.sclk_dpm_key_disabled)
@@ -4654,7 +4652,7 @@ static int vega10_print_clock_levels(str
 		else
 			count = sclk_table->count;
 		for (i = 0; i < count; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 					i, sclk_table->dpm_levels[i].value / 100,
 					(i == now) ? "*" : "");
 		break;
@@ -4665,7 +4663,7 @@ static int vega10_print_clock_levels(str
 		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetCurrentUclkIndex, &now);
 
 		for (i = 0; i < mclk_table->count; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 					i, mclk_table->dpm_levels[i].value / 100,
 					(i == now) ? "*" : "");
 		break;
@@ -4676,7 +4674,7 @@ static int vega10_print_clock_levels(str
 		smum_send_msg_to_smc(hwmgr, PPSMC_MSG_GetCurrentSocclkIndex, &now);
 
 		for (i = 0; i < soc_table->count; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 					i, soc_table->dpm_levels[i].value / 100,
 					(i == now) ? "*" : "");
 		break;
@@ -4688,7 +4686,7 @@ static int vega10_print_clock_levels(str
 				PPSMC_MSG_GetClockFreqMHz, CLK_DCEFCLK, &now);
 
 		for (i = 0; i < dcef_table->count; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 					i, dcef_table->dpm_levels[i].value / 100,
 					(dcef_table->dpm_levels[i].value / 100 == now) ?
 					"*" : "");
@@ -4702,7 +4700,7 @@ static int vega10_print_clock_levels(str
 			gen_speed = pptable->PcieGenSpeed[i];
 			lane_width = pptable->PcieLaneCount[i];
 
-			size += sysfs_emit_at(buf, size, "%d: %s %s %s\n", i,
+			size += sprintf(buf + size, "%d: %s %s %s\n", i,
 					(gen_speed == 0) ? "2.5GT/s," :
 					(gen_speed == 1) ? "5.0GT/s," :
 					(gen_speed == 2) ? "8.0GT/s," :
@@ -4721,34 +4719,34 @@ static int vega10_print_clock_levels(str
 
 	case OD_SCLK:
 		if (hwmgr->od_enabled) {
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_SCLK");
+			size += sprintf(buf + size, "%s:\n", "OD_SCLK");
 			podn_vdd_dep = &data->odn_dpm_table.vdd_dep_on_sclk;
 			for (i = 0; i < podn_vdd_dep->count; i++)
-				size += sysfs_emit_at(buf, size, "%d: %10uMhz %10umV\n",
+				size += sprintf(buf + size, "%d: %10uMhz %10umV\n",
 					i, podn_vdd_dep->entries[i].clk / 100,
 						podn_vdd_dep->entries[i].vddc);
 		}
 		break;
 	case OD_MCLK:
 		if (hwmgr->od_enabled) {
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_MCLK");
+			size += sprintf(buf + size, "%s:\n", "OD_MCLK");
 			podn_vdd_dep = &data->odn_dpm_table.vdd_dep_on_mclk;
 			for (i = 0; i < podn_vdd_dep->count; i++)
-				size += sysfs_emit_at(buf, size, "%d: %10uMhz %10umV\n",
+				size += sprintf(buf + size, "%d: %10uMhz %10umV\n",
 					i, podn_vdd_dep->entries[i].clk/100,
 						podn_vdd_dep->entries[i].vddc);
 		}
 		break;
 	case OD_RANGE:
 		if (hwmgr->od_enabled) {
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_RANGE");
-			size += sysfs_emit_at(buf, size, "SCLK: %7uMHz %10uMHz\n",
+			size += sprintf(buf + size, "%s:\n", "OD_RANGE");
+			size += sprintf(buf + size, "SCLK: %7uMHz %10uMHz\n",
 				data->golden_dpm_table.gfx_table.dpm_levels[0].value/100,
 				hwmgr->platform_descriptor.overdriveLimit.engineClock/100);
-			size += sysfs_emit_at(buf, size, "MCLK: %7uMHz %10uMHz\n",
+			size += sprintf(buf + size, "MCLK: %7uMHz %10uMHz\n",
 				data->golden_dpm_table.mem_table.dpm_levels[0].value/100,
 				hwmgr->platform_descriptor.overdriveLimit.memoryClock/100);
-			size += sysfs_emit_at(buf, size, "VDDC: %7umV %11umV\n",
+			size += sprintf(buf + size, "VDDC: %7umV %11umV\n",
 				data->odn_dpm_table.min_vddc,
 				data->odn_dpm_table.max_vddc);
 		}
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_hwmgr.c
@@ -2246,8 +2246,6 @@ static int vega12_print_clock_levels(str
 	int i, now, size = 0;
 	struct pp_clock_levels_with_latency clocks;
 
-	phm_get_sysfs_buf(&buf, &size);
-
 	switch (type) {
 	case PP_SCLK:
 		PP_ASSERT_WITH_CODE(
@@ -2260,7 +2258,7 @@ static int vega12_print_clock_levels(str
 				"Attempt to get gfx clk levels Failed!",
 				return -1);
 		for (i = 0; i < clocks.num_levels; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 				i, clocks.data[i].clocks_in_khz / 1000,
 				(clocks.data[i].clocks_in_khz / 1000 == now / 100) ? "*" : "");
 		break;
@@ -2276,7 +2274,7 @@ static int vega12_print_clock_levels(str
 				"Attempt to get memory clk levels Failed!",
 				return -1);
 		for (i = 0; i < clocks.num_levels; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 				i, clocks.data[i].clocks_in_khz / 1000,
 				(clocks.data[i].clocks_in_khz / 1000 == now / 100) ? "*" : "");
 		break;
@@ -2294,7 +2292,7 @@ static int vega12_print_clock_levels(str
 				"Attempt to get soc clk levels Failed!",
 				return -1);
 		for (i = 0; i < clocks.num_levels; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 				i, clocks.data[i].clocks_in_khz / 1000,
 				(clocks.data[i].clocks_in_khz / 1000 == now) ? "*" : "");
 		break;
@@ -2312,7 +2310,7 @@ static int vega12_print_clock_levels(str
 				"Attempt to get dcef clk levels Failed!",
 				return -1);
 		for (i = 0; i < clocks.num_levels; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 				i, clocks.data[i].clocks_in_khz / 1000,
 				(clocks.data[i].clocks_in_khz / 1000 == now) ? "*" : "");
 		break;
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c
@@ -3366,8 +3366,6 @@ static int vega20_print_clock_levels(str
 	int ret = 0;
 	uint32_t gen_speed, lane_width, current_gen_speed, current_lane_width;
 
-	phm_get_sysfs_buf(&buf, &size);
-
 	switch (type) {
 	case PP_SCLK:
 		ret = vega20_get_current_clk_freq(hwmgr, PPCLK_GFXCLK, &now);
@@ -3376,13 +3374,13 @@ static int vega20_print_clock_levels(str
 				return ret);
 
 		if (vega20_get_sclks(hwmgr, &clocks)) {
-			size += sysfs_emit_at(buf, size, "0: %uMhz * (DPM disabled)\n",
+			size += sprintf(buf + size, "0: %uMhz * (DPM disabled)\n",
 				now / 100);
 			break;
 		}
 
 		for (i = 0; i < clocks.num_levels; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 				i, clocks.data[i].clocks_in_khz / 1000,
 				(clocks.data[i].clocks_in_khz == now * 10) ? "*" : "");
 		break;
@@ -3394,13 +3392,13 @@ static int vega20_print_clock_levels(str
 				return ret);
 
 		if (vega20_get_memclocks(hwmgr, &clocks)) {
-			size += sysfs_emit_at(buf, size, "0: %uMhz * (DPM disabled)\n",
+			size += sprintf(buf + size, "0: %uMhz * (DPM disabled)\n",
 				now / 100);
 			break;
 		}
 
 		for (i = 0; i < clocks.num_levels; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 				i, clocks.data[i].clocks_in_khz / 1000,
 				(clocks.data[i].clocks_in_khz == now * 10) ? "*" : "");
 		break;
@@ -3412,13 +3410,13 @@ static int vega20_print_clock_levels(str
 				return ret);
 
 		if (vega20_get_socclocks(hwmgr, &clocks)) {
-			size += sysfs_emit_at(buf, size, "0: %uMhz * (DPM disabled)\n",
+			size += sprintf(buf + size, "0: %uMhz * (DPM disabled)\n",
 				now / 100);
 			break;
 		}
 
 		for (i = 0; i < clocks.num_levels; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 				i, clocks.data[i].clocks_in_khz / 1000,
 				(clocks.data[i].clocks_in_khz == now * 10) ? "*" : "");
 		break;
@@ -3430,7 +3428,7 @@ static int vega20_print_clock_levels(str
 				return ret);
 
 		for (i = 0; i < fclk_dpm_table->count; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 				i, fclk_dpm_table->dpm_levels[i].value,
 				fclk_dpm_table->dpm_levels[i].value == (now / 100) ? "*" : "");
 		break;
@@ -3442,13 +3440,13 @@ static int vega20_print_clock_levels(str
 				return ret);
 
 		if (vega20_get_dcefclocks(hwmgr, &clocks)) {
-			size += sysfs_emit_at(buf, size, "0: %uMhz * (DPM disabled)\n",
+			size += sprintf(buf + size, "0: %uMhz * (DPM disabled)\n",
 				now / 100);
 			break;
 		}
 
 		for (i = 0; i < clocks.num_levels; i++)
-			size += sysfs_emit_at(buf, size, "%d: %uMhz %s\n",
+			size += sprintf(buf + size, "%d: %uMhz %s\n",
 				i, clocks.data[i].clocks_in_khz / 1000,
 				(clocks.data[i].clocks_in_khz == now * 10) ? "*" : "");
 		break;
@@ -3462,7 +3460,7 @@ static int vega20_print_clock_levels(str
 			gen_speed = pptable->PcieGenSpeed[i];
 			lane_width = pptable->PcieLaneCount[i];
 
-			size += sysfs_emit_at(buf, size, "%d: %s %s %dMhz %s\n", i,
+			size += sprintf(buf + size, "%d: %s %s %dMhz %s\n", i,
 					(gen_speed == 0) ? "2.5GT/s," :
 					(gen_speed == 1) ? "5.0GT/s," :
 					(gen_speed == 2) ? "8.0GT/s," :
@@ -3483,18 +3481,18 @@ static int vega20_print_clock_levels(str
 	case OD_SCLK:
 		if (od8_settings[OD8_SETTING_GFXCLK_FMIN].feature_id &&
 		    od8_settings[OD8_SETTING_GFXCLK_FMAX].feature_id) {
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_SCLK");
-			size += sysfs_emit_at(buf, size, "0: %10uMhz\n",
+			size += sprintf(buf + size, "%s:\n", "OD_SCLK");
+			size += sprintf(buf + size, "0: %10uMhz\n",
 				od_table->GfxclkFmin);
-			size += sysfs_emit_at(buf, size, "1: %10uMhz\n",
+			size += sprintf(buf + size, "1: %10uMhz\n",
 				od_table->GfxclkFmax);
 		}
 		break;
 
 	case OD_MCLK:
 		if (od8_settings[OD8_SETTING_UCLK_FMAX].feature_id) {
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_MCLK");
-			size += sysfs_emit_at(buf, size, "1: %10uMhz\n",
+			size += sprintf(buf + size, "%s:\n", "OD_MCLK");
+			size += sprintf(buf + size, "1: %10uMhz\n",
 				od_table->UclkFmax);
 		}
 
@@ -3507,14 +3505,14 @@ static int vega20_print_clock_levels(str
 		    od8_settings[OD8_SETTING_GFXCLK_VOLTAGE1].feature_id &&
 		    od8_settings[OD8_SETTING_GFXCLK_VOLTAGE2].feature_id &&
 		    od8_settings[OD8_SETTING_GFXCLK_VOLTAGE3].feature_id) {
-			size += sysfs_emit_at(buf, size, "%s:\n", "OD_VDDC_CURVE");
-			size += sysfs_emit_at(buf, size, "0: %10uMhz %10dmV\n",
+			size += sprintf(buf + size, "%s:\n", "OD_VDDC_CURVE");
+			size += sprintf(buf + size, "0: %10uMhz %10dmV\n",
 				od_table->GfxclkFreq1,
 				od_table->GfxclkVolt1 / VOLTAGE_SCALE);
-			size += sysfs_emit_at(buf, size, "1: %10uMhz %10dmV\n",
+			size += sprintf(buf + size, "1: %10uMhz %10dmV\n",
 				od_table->GfxclkFreq2,
 				od_table->GfxclkVolt2 / VOLTAGE_SCALE);
-			size += sysfs_emit_at(buf, size, "2: %10uMhz %10dmV\n",
+			size += sprintf(buf + size, "2: %10uMhz %10dmV\n",
 				od_table->GfxclkFreq3,
 				od_table->GfxclkVolt3 / VOLTAGE_SCALE);
 		}
@@ -3522,17 +3520,17 @@ static int vega20_print_clock_levels(str
 		break;
 
 	case OD_RANGE:
-		size += sysfs_emit_at(buf, size, "%s:\n", "OD_RANGE");
+		size += sprintf(buf + size, "%s:\n", "OD_RANGE");
 
 		if (od8_settings[OD8_SETTING_GFXCLK_FMIN].feature_id &&
 		    od8_settings[OD8_SETTING_GFXCLK_FMAX].feature_id) {
-			size += sysfs_emit_at(buf, size, "SCLK: %7uMhz %10uMhz\n",
+			size += sprintf(buf + size, "SCLK: %7uMhz %10uMhz\n",
 				od8_settings[OD8_SETTING_GFXCLK_FMIN].min_value,
 				od8_settings[OD8_SETTING_GFXCLK_FMAX].max_value);
 		}
 
 		if (od8_settings[OD8_SETTING_UCLK_FMAX].feature_id) {
-			size += sysfs_emit_at(buf, size, "MCLK: %7uMhz %10uMhz\n",
+			size += sprintf(buf + size, "MCLK: %7uMhz %10uMhz\n",
 				od8_settings[OD8_SETTING_UCLK_FMAX].min_value,
 				od8_settings[OD8_SETTING_UCLK_FMAX].max_value);
 		}
@@ -3543,22 +3541,22 @@ static int vega20_print_clock_levels(str
 		    od8_settings[OD8_SETTING_GFXCLK_VOLTAGE1].feature_id &&
 		    od8_settings[OD8_SETTING_GFXCLK_VOLTAGE2].feature_id &&
 		    od8_settings[OD8_SETTING_GFXCLK_VOLTAGE3].feature_id) {
-			size += sysfs_emit_at(buf, size, "VDDC_CURVE_SCLK[0]: %7uMhz %10uMhz\n",
+			size += sprintf(buf + size, "VDDC_CURVE_SCLK[0]: %7uMhz %10uMhz\n",
 				od8_settings[OD8_SETTING_GFXCLK_FREQ1].min_value,
 				od8_settings[OD8_SETTING_GFXCLK_FREQ1].max_value);
-			size += sysfs_emit_at(buf, size, "VDDC_CURVE_VOLT[0]: %7dmV %11dmV\n",
+			size += sprintf(buf + size, "VDDC_CURVE_VOLT[0]: %7dmV %11dmV\n",
 				od8_settings[OD8_SETTING_GFXCLK_VOLTAGE1].min_value,
 				od8_settings[OD8_SETTING_GFXCLK_VOLTAGE1].max_value);
-			size += sysfs_emit_at(buf, size, "VDDC_CURVE_SCLK[1]: %7uMhz %10uMhz\n",
+			size += sprintf(buf + size, "VDDC_CURVE_SCLK[1]: %7uMhz %10uMhz\n",
 				od8_settings[OD8_SETTING_GFXCLK_FREQ2].min_value,
 				od8_settings[OD8_SETTING_GFXCLK_FREQ2].max_value);
-			size += sysfs_emit_at(buf, size, "VDDC_CURVE_VOLT[1]: %7dmV %11dmV\n",
+			size += sprintf(buf + size, "VDDC_CURVE_VOLT[1]: %7dmV %11dmV\n",
 				od8_settings[OD8_SETTING_GFXCLK_VOLTAGE2].min_value,
 				od8_settings[OD8_SETTING_GFXCLK_VOLTAGE2].max_value);
-			size += sysfs_emit_at(buf, size, "VDDC_CURVE_SCLK[2]: %7uMhz %10uMhz\n",
+			size += sprintf(buf + size, "VDDC_CURVE_SCLK[2]: %7uMhz %10uMhz\n",
 				od8_settings[OD8_SETTING_GFXCLK_FREQ3].min_value,
 				od8_settings[OD8_SETTING_GFXCLK_FREQ3].max_value);
-			size += sysfs_emit_at(buf, size, "VDDC_CURVE_VOLT[2]: %7dmV %11dmV\n",
+			size += sprintf(buf + size, "VDDC_CURVE_VOLT[2]: %7dmV %11dmV\n",
 				od8_settings[OD8_SETTING_GFXCLK_VOLTAGE3].min_value,
 				od8_settings[OD8_SETTING_GFXCLK_VOLTAGE3].max_value);
 		}


