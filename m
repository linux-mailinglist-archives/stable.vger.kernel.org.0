Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 852A615DC50
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 16:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730929AbgBNPwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:52:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:57640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730370AbgBNPwG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:52:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DCE724649;
        Fri, 14 Feb 2020 15:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695525;
        bh=gNp+W51s5dQ8cfrOzVkhpPb0MYqdMHWlHPW/kPgJOLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gp/wfcsiioN1sFsxlRkdGKg+7rbQ/RPeVl/dyy/amRErsl4P3/Y1qFWLc6oBJNrXs
         29NA2h0B4hDSPmfbNPRq675fxJ/K9hxYkrD8kLcbkRH6yYJ7PGRnKHEOIGRf6uCD5o
         h+o7W4HzDidI6ox88FXLMQ6Qtw1Tb2GRBnWA0EU0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     zhengbin <zhengbin13@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 146/542] drm/amd/powerplay: remove set but not used variable 'threshold', 'state'
Date:   Fri, 14 Feb 2020 10:42:18 -0500
Message-Id: <20200214154854.6746-146-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhengbin <zhengbin13@huawei.com>

[ Upstream commit f5ac1595156a8b63812ed6fa0803ddf7207cced7 ]

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/gpu/drm/amd/powerplay/smumgr/fiji_smumgr.c: In function fiji_populate_single_graphic_level:
drivers/gpu/drm/amd/powerplay/smumgr/fiji_smumgr.c:943:11: warning: variable threshold set but not used [-Wunused-but-set-variable]
drivers/gpu/drm/amd/powerplay/smumgr/fiji_smumgr.c: In function fiji_populate_memory_timing_parameters:
drivers/gpu/drm/amd/powerplay/smumgr/fiji_smumgr.c:1504:8: warning: variable state set but not used [-Wunused-but-set-variable]

They are introduced by commit 2e112b4ae3ba ("drm/amd/pp:
remove fiji_smc/smumgr split."), but never used,
so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/smumgr/fiji_smumgr.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/fiji_smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/fiji_smumgr.c
index da025b1d302da..32ebb383c4568 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/fiji_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/fiji_smumgr.c
@@ -940,7 +940,7 @@ static int fiji_populate_single_graphic_level(struct pp_hwmgr *hwmgr,
 {
 	int result;
 	/* PP_Clocks minClocks; */
-	uint32_t threshold, mvdd;
+	uint32_t mvdd;
 	struct smu7_hwmgr *data = (struct smu7_hwmgr *)(hwmgr->backend);
 	struct phm_ppt_v1_information *table_info =
 			(struct phm_ppt_v1_information *)(hwmgr->pptable);
@@ -973,8 +973,6 @@ static int fiji_populate_single_graphic_level(struct pp_hwmgr *hwmgr,
 	level->VoltageDownHyst = 0;
 	level->PowerThrottle = 0;
 
-	threshold = clock * data->fast_watermark_threshold / 100;
-
 	data->display_timing.min_clock_in_sr = hwmgr->display_config->min_core_set_clock_in_sr;
 
 	if (phm_cap_enabled(hwmgr->platform_descriptor.platformCaps, PHM_PlatformCaps_SclkDeepSleep))
@@ -1501,7 +1499,7 @@ static int fiji_populate_memory_timing_parameters(struct pp_hwmgr *hwmgr,
 	uint32_t dram_timing;
 	uint32_t dram_timing2;
 	uint32_t burstTime;
-	ULONG state, trrds, trrdl;
+	ULONG trrds, trrdl;
 	int result;
 
 	result = atomctrl_set_engine_dram_timings_rv770(hwmgr,
@@ -1513,7 +1511,6 @@ static int fiji_populate_memory_timing_parameters(struct pp_hwmgr *hwmgr,
 	dram_timing2 = cgs_read_register(hwmgr->device, mmMC_ARB_DRAM_TIMING2);
 	burstTime = cgs_read_register(hwmgr->device, mmMC_ARB_BURST_TIME);
 
-	state = PHM_GET_FIELD(burstTime, MC_ARB_BURST_TIME, STATE0);
 	trrds = PHM_GET_FIELD(burstTime, MC_ARB_BURST_TIME, TRRDS0);
 	trrdl = PHM_GET_FIELD(burstTime, MC_ARB_BURST_TIME, TRRDL0);
 
-- 
2.20.1

