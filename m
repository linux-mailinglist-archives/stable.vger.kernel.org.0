Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93112B6170
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730743AbgKQNSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:18:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730734AbgKQNSy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:18:54 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31A6D2225B;
        Tue, 17 Nov 2020 13:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619131;
        bh=ymSK9agiH04LuUS7bKGzlYGYWqJyM6s2xTmSjorwK1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfuPS1Uq/YM8k4TIrRe6tSUJYAxRusAzn0M6NLjTUW0DtZPbCIcPKjKjM/vkmL52D
         h6W/6cQ1RIedsihwABKfe3BeWkYpDRalr1jUT+vjQS8ClcAY8r8m1krZSfRWXu04XU
         dnhMu5llkqIajAKG/bYNV0bEgWFusjZaf6EBGI5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 037/101] drm/amd/pm: perform SMC reset on suspend/hibernation
Date:   Tue, 17 Nov 2020 14:05:04 +0100
Message-Id: <20201117122114.897781933@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
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
index 058898b321b8a..d8e624d64ae38 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -1531,6 +1531,10 @@ int smu7_disable_dpm_tasks(struct pp_hwmgr *hwmgr)
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
index 6ee864455a12a..f59e1e737735f 100644
--- a/drivers/gpu/drm/amd/powerplay/inc/hwmgr.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/hwmgr.h
@@ -216,6 +216,7 @@ struct pp_smumgr_func {
 	bool (*is_hw_avfs_present)(struct pp_hwmgr  *hwmgr);
 	int (*update_dpm_settings)(struct pp_hwmgr *hwmgr, void *profile_setting);
 	int (*smc_table_manager)(struct pp_hwmgr *hwmgr, uint8_t *table, uint16_t table_id, bool rw); /*rw: true for read, false for write */
+	int (*stop_smc)(struct pp_hwmgr *hwmgr);
 };
 
 struct pp_hwmgr_func {
diff --git a/drivers/gpu/drm/amd/powerplay/inc/smumgr.h b/drivers/gpu/drm/amd/powerplay/inc/smumgr.h
index 82550a8a3a3fc..ef4f2392e2e7d 100644
--- a/drivers/gpu/drm/amd/powerplay/inc/smumgr.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/smumgr.h
@@ -113,4 +113,6 @@ extern int smum_update_dpm_settings(struct pp_hwmgr *hwmgr, void *profile_settin
 
 extern int smum_smc_table_manager(struct pp_hwmgr *hwmgr, uint8_t *table, uint16_t table_id, bool rw);
 
+extern int smum_stop_smc(struct pp_hwmgr *hwmgr);
+
 #endif
diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
index db87cb8930d24..0d4dd607e85c8 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
@@ -2934,6 +2934,29 @@ static int ci_update_smc_table(struct pp_hwmgr *hwmgr, uint32_t type)
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
 	.smu_init = ci_smu_init,
 	.smu_fini = ci_smu_fini,
@@ -2957,4 +2980,5 @@ const struct pp_smumgr_func ci_smu_funcs = {
 	.is_dpm_running = ci_is_dpm_running,
 	.update_dpm_settings = ci_update_dpm_settings,
 	.update_smc_table = ci_update_smc_table,
+	.stop_smc = ci_stop_smc,
 };
diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c
index a6edd5df33b0f..20ecf994d47f3 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c
@@ -213,3 +213,11 @@ int smum_smc_table_manager(struct pp_hwmgr *hwmgr, uint8_t *table, uint16_t tabl
 
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



