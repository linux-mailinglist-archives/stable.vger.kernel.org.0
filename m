Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633B728387A
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 16:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgJEOp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 10:45:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbgJEOpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 10:45:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E318207F7;
        Mon,  5 Oct 2020 14:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601909111;
        bh=B8xqfhZ/PIlTzUggovIe+j94Ce85wxzAlqwfT6+Sfdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FuWkiJDnBP8ay8MfWzg8YScGKleaPa3HK144ZXSDDzp3idK+3g6kP7vAsgVe2X2aD
         R5gEC8/jIyr+nrCYkaLIS+qRM0Y9aOKXeob5GnWdvMWx8UhUYCNGX4w4b1UjRWhDJG
         TqOHAJ2iX6VmZFbdehkV9v36aWQSODIFb/l27VBw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudheesh Mavila <sudheesh.mavila@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 08/12] drm/amd/pm: Removed fixed clock in auto mode DPM
Date:   Mon,  5 Oct 2020 10:44:56 -0400
Message-Id: <20201005144501.2527477-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201005144501.2527477-1-sashal@kernel.org>
References: <20201005144501.2527477-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

