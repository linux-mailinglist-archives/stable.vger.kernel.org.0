Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1AF344289
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhCVMna (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:43:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231214AbhCVMk3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:40:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62707619B5;
        Mon, 22 Mar 2021 12:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416741;
        bh=ooNAaCIzc/y87wVxj2ySWUESTteO8GdRRD6fcFWGHd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eDRx/W9xePyVlGaJiVT0MPwo5RvnVJChncIq0jNGvERpy9jZoMeA5DHp4UTbj/VQY
         GngiH4/7fNgczBKkYiDejbxNRjkAaaL+M/1q4TDZZ7XiPc8+W9w7JKYU0TZ9xpKoYE
         bN3yfsB5PmAk85t6h0lseaVMyOBy5q8sCmYG3rEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/157] drm/amd/pm: fulfill the Polaris implementation for get_clock_by_type_with_latency()
Date:   Mon, 22 Mar 2021 13:27:39 +0100
Message-Id: <20210322121937.010230816@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 690cdc2635849db8b782dbbcabfb1c7519c84fa1 ]

Fulfill Polaris get_clock_by_type_with_latency().

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c   | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index 35629140fc7a..c5223a9e0d89 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -4771,6 +4771,72 @@ static int smu7_get_clock_by_type(struct pp_hwmgr *hwmgr, enum amd_pp_clock_type
 	return 0;
 }
 
+static int smu7_get_sclks_with_latency(struct pp_hwmgr *hwmgr,
+				       struct pp_clock_levels_with_latency *clocks)
+{
+	struct phm_ppt_v1_information *table_info =
+			(struct phm_ppt_v1_information *)hwmgr->pptable;
+	struct phm_ppt_v1_clock_voltage_dependency_table *dep_sclk_table =
+			table_info->vdd_dep_on_sclk;
+	int i;
+
+	clocks->num_levels = 0;
+	for (i = 0; i < dep_sclk_table->count; i++) {
+		if (dep_sclk_table->entries[i].clk) {
+			clocks->data[clocks->num_levels].clocks_in_khz =
+				dep_sclk_table->entries[i].clk * 10;
+			clocks->num_levels++;
+		}
+	}
+
+	return 0;
+}
+
+static int smu7_get_mclks_with_latency(struct pp_hwmgr *hwmgr,
+				       struct pp_clock_levels_with_latency *clocks)
+{
+	struct phm_ppt_v1_information *table_info =
+			(struct phm_ppt_v1_information *)hwmgr->pptable;
+	struct phm_ppt_v1_clock_voltage_dependency_table *dep_mclk_table =
+			table_info->vdd_dep_on_mclk;
+	int i;
+
+	clocks->num_levels = 0;
+	for (i = 0; i < dep_mclk_table->count; i++) {
+		if (dep_mclk_table->entries[i].clk) {
+			clocks->data[clocks->num_levels].clocks_in_khz =
+					dep_mclk_table->entries[i].clk * 10;
+			clocks->data[clocks->num_levels].latency_in_us =
+					smu7_get_mem_latency(hwmgr, dep_mclk_table->entries[i].clk);
+			clocks->num_levels++;
+		}
+	}
+
+	return 0;
+}
+
+static int smu7_get_clock_by_type_with_latency(struct pp_hwmgr *hwmgr,
+					       enum amd_pp_clock_type type,
+					       struct pp_clock_levels_with_latency *clocks)
+{
+	if (!(hwmgr->chip_id >= CHIP_POLARIS10 &&
+	      hwmgr->chip_id <= CHIP_VEGAM))
+		return -EINVAL;
+
+	switch (type) {
+	case amd_pp_sys_clock:
+		smu7_get_sclks_with_latency(hwmgr, clocks);
+		break;
+	case amd_pp_mem_clock:
+		smu7_get_mclks_with_latency(hwmgr, clocks);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int smu7_notify_cac_buffer_info(struct pp_hwmgr *hwmgr,
 					uint32_t virtual_addr_low,
 					uint32_t virtual_addr_hi,
@@ -5188,6 +5254,7 @@ static const struct pp_hwmgr_func smu7_hwmgr_funcs = {
 	.get_mclk_od = smu7_get_mclk_od,
 	.set_mclk_od = smu7_set_mclk_od,
 	.get_clock_by_type = smu7_get_clock_by_type,
+	.get_clock_by_type_with_latency = smu7_get_clock_by_type_with_latency,
 	.read_sensor = smu7_read_sensor,
 	.dynamic_state_management_disable = smu7_disable_dpm_tasks,
 	.avfs_control = smu7_avfs_control,
-- 
2.30.1



