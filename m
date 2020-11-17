Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A935D2B635D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732529AbgKQNf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732114AbgKQNf6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:35:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A7DE2078E;
        Tue, 17 Nov 2020 13:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605620157;
        bh=hGKZTD5lCSdew9ASQ+UFlYeos/nqhAcPPN4x2s2bu2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TTv1hXWFupM/DA2x8liPJSQLEHaUWRGiSvB6WI3GbuLKrIWFn0GNmuOvymBL5Fox
         ffr0RSGY4Jpr4sMKgl2vm3vgf1D8O/QO+klANjrTSRY4iLDeJTmnUP/m082OIVbjti
         g/0vl2oCWorXRedIoy9sP07pptz1VIZz9Bm7rf7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 095/255] drm/amd/pm: perform SMC reset on suspend/hibernation
Date:   Tue, 17 Nov 2020 14:03:55 +0100
Message-Id: <20201117122143.581233324@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 277b080f98803cb73a83fb234f0be83a10e63958 ]

So that the succeeding resume can be performed based on
a clean state.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Tested-by: Sandeep Raghuraman <sandy.8925@gmail.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c  |  4 ++++
 drivers/gpu/drm/amd/powerplay/inc/hwmgr.h     |  1 +
 drivers/gpu/drm/amd/powerplay/inc/smumgr.h    |  2 ++
 .../gpu/drm/amd/powerplay/smumgr/ci_smumgr.c  | 24 +++++++++++++++++++
 drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c |  8 +++++++
 5 files changed, 39 insertions(+)

diff --git a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
index fc63d9e32e1f8..c8ee931075e52 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -1541,6 +1541,10 @@ static int smu7_disable_dpm_tasks(struct pp_hwmgr *hwmgr)
 	PP_ASSERT_WITH_CODE((tmp_result == 0),
 			"Failed to reset to default!", result = tmp_result);
 
+	tmp_result = smum_stop_smc(hwmgr);
+	PP_ASSERT_WITH_CODE((tmp_result == 0),
+			"Failed to stop smc!", result = tmp_result);
+
 	tmp_result = smu7_force_switch_to_arbf0(hwmgr);
 	PP_ASSERT_WITH_CODE((tmp_result == 0),
 			"Failed to force to switch arbf0!", result = tmp_result);
diff --git a/drivers/gpu/drm/amd/powerplay/inc/hwmgr.h b/drivers/gpu/drm/amd/powerplay/inc/hwmgr.h
index 15ed6cbdf3660..91cdc53472f01 100644
--- a/drivers/gpu/drm/amd/powerplay/inc/hwmgr.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/hwmgr.h
@@ -229,6 +229,7 @@ struct pp_smumgr_func {
 	bool (*is_hw_avfs_present)(struct pp_hwmgr  *hwmgr);
 	int (*update_dpm_settings)(struct pp_hwmgr *hwmgr, void *profile_setting);
 	int (*smc_table_manager)(struct pp_hwmgr *hwmgr, uint8_t *table, uint16_t table_id, bool rw); /*rw: true for read, false for write */
+	int (*stop_smc)(struct pp_hwmgr *hwmgr);
 };
 
 struct pp_hwmgr_func {
diff --git a/drivers/gpu/drm/amd/powerplay/inc/smumgr.h b/drivers/gpu/drm/amd/powerplay/inc/smumgr.h
index ad100b533d049..5f46f1a4f38ef 100644
--- a/drivers/gpu/drm/amd/powerplay/inc/smumgr.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/smumgr.h
@@ -113,4 +113,6 @@ extern int smum_update_dpm_settings(struct pp_hwmgr *hwmgr, void *profile_settin
 
 extern int smum_smc_table_manager(struct pp_hwmgr *hwmgr, uint8_t *table, uint16_t table_id, bool rw);
 
+extern int smum_stop_smc(struct pp_hwmgr *hwmgr);
+
 #endif
diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
index e4d1f3d66ef48..09128122b4932 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
@@ -2939,6 +2939,29 @@ static int ci_update_smc_table(struct pp_hwmgr *hwmgr, uint32_t type)
 	return 0;
 }
 
+static void ci_reset_smc(struct pp_hwmgr *hwmgr)
+{
+	PHM_WRITE_INDIRECT_FIELD(hwmgr->device, CGS_IND_REG__SMC,
+				  SMC_SYSCON_RESET_CNTL,
+				  rst_reg, 1);
+}
+
+
+static void ci_stop_smc_clock(struct pp_hwmgr *hwmgr)
+{
+	PHM_WRITE_INDIRECT_FIELD(hwmgr->device, CGS_IND_REG__SMC,
+				  SMC_SYSCON_CLOCK_CNTL_0,
+				  ck_disable, 1);
+}
+
+static int ci_stop_smc(struct pp_hwmgr *hwmgr)
+{
+	ci_reset_smc(hwmgr);
+	ci_stop_smc_clock(hwmgr);
+
+	return 0;
+}
+
 const struct pp_smumgr_func ci_smu_funcs = {
 	.name = "ci_smu",
 	.smu_init = ci_smu_init,
@@ -2964,4 +2987,5 @@ const struct pp_smumgr_func ci_smu_funcs = {
 	.is_dpm_running = ci_is_dpm_running,
 	.update_dpm_settings = ci_update_dpm_settings,
 	.update_smc_table = ci_update_smc_table,
+	.stop_smc = ci_stop_smc,
 };
diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c
index b6fb480668416..b6921db3c1305 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c
@@ -245,3 +245,11 @@ int smum_smc_table_manager(struct pp_hwmgr *hwmgr, uint8_t *table, uint16_t tabl
 
 	return -EINVAL;
 }
+
+int smum_stop_smc(struct pp_hwmgr *hwmgr)
+{
+	if (hwmgr->smumgr_funcs->stop_smc)
+		return hwmgr->smumgr_funcs->stop_smc(hwmgr);
+
+	return 0;
+}
-- 
2.27.0



