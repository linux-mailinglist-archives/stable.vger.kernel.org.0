Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F0D28B7F3
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbgJLNrz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389704AbgJLNpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1D92222EC;
        Mon, 12 Oct 2020 13:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510322;
        bh=B8xqfhZ/PIlTzUggovIe+j94Ce85wxzAlqwfT6+Sfdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Foyn0y2Ew058yu46GuR0+zBm5z1ZRmyd2KYI80hk3psETQ6XQrc5oyEX1xhYXMLNS
         KEat9TY5n3sB94a2ygx1xxU3T+TCUedTjt+6IpsuAOaQkFcT7yXTJq/Z5xCm3Xsq3F
         89VlgtqB+4z5iKgIyS9BuaDu/VjQ/u2U5BVU4J2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Sudheesh Mavila <sudheesh.mavila@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 048/124] drm/amd/pm: Removed fixed clock in auto mode DPM
Date:   Mon, 12 Oct 2020 15:30:52 +0200
Message-Id: <20201012133149.179881039@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudheesh Mavila <sudheesh.mavila@amd.com>

[ Upstream commit 97cf32996c46d9935cc133d910a75fb687dd6144 ]

SMU10_UMD_PSTATE_PEAK_FCLK value should not be used to set the DPM.

Suggested-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
index 9ee8cf8267c88..43f7adff6cb74 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu10_hwmgr.c
@@ -563,6 +563,8 @@ static int smu10_dpm_force_dpm_level(struct pp_hwmgr *hwmgr,
 	struct smu10_hwmgr *data = hwmgr->backend;
 	uint32_t min_sclk = hwmgr->display_config->min_core_set_clock;
 	uint32_t min_mclk = hwmgr->display_config->min_mem_set_clock/100;
+	uint32_t index_fclk = data->clock_vol_info.vdd_dep_on_fclk->count - 1;
+	uint32_t index_socclk = data->clock_vol_info.vdd_dep_on_socclk->count - 1;
 
 	if (hwmgr->smu_version < 0x1E3700) {
 		pr_info("smu firmware version too old, can not set dpm level\n");
@@ -676,13 +678,13 @@ static int smu10_dpm_force_dpm_level(struct pp_hwmgr *hwmgr,
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetHardMinFclkByFreq,
 						hwmgr->display_config->num_display > 3 ?
-						SMU10_UMD_PSTATE_PEAK_FCLK :
+						data->clock_vol_info.vdd_dep_on_fclk->entries[0].clk :
 						min_mclk,
 						NULL);
 
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetHardMinSocclkByFreq,
-						SMU10_UMD_PSTATE_MIN_SOCCLK,
+						data->clock_vol_info.vdd_dep_on_socclk->entries[0].clk,
 						NULL);
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetHardMinVcn,
@@ -695,11 +697,11 @@ static int smu10_dpm_force_dpm_level(struct pp_hwmgr *hwmgr,
 						NULL);
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetSoftMaxFclkByFreq,
-						SMU10_UMD_PSTATE_PEAK_FCLK,
+						data->clock_vol_info.vdd_dep_on_fclk->entries[index_fclk].clk,
 						NULL);
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetSoftMaxSocclkByFreq,
-						SMU10_UMD_PSTATE_PEAK_SOCCLK,
+						data->clock_vol_info.vdd_dep_on_socclk->entries[index_socclk].clk,
 						NULL);
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetSoftMaxVcn,
-- 
2.25.1



