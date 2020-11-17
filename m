Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687B32B655C
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbgKQNZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:25:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731052AbgKQNZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:25:03 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6626F24686;
        Tue, 17 Nov 2020 13:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619502;
        bh=dmDJI0QQe4VlDG5EGtS5+/ssCqnCyrFhWR8O/fPYlM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+IDj117zPxdbAMrV9uRC8viGwiGIVbqdAF+RtIPks5tSxz8oqENX1Wvh7neVsFXk
         EXypFoevjlusbIEFqZUs5gSPBeCuAuGMfE2KdzUKP/CdZn+LBe0ZbVAuRdES+NHms4
         PRqJiGLVmHOFeJ3vwFfOx3Eh0seiwlP9IeEm1Ofw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/151] drm/amd/pm: perform SMC reset on suspend/hibernation
Date:   Tue, 17 Nov 2020 14:04:50 +0100
Message-Id: <20201117122124.347436776@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
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
index 35e6cbe805eb4..7cde55854b65c 100644
--- a/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/powerplay/hwmgr/smu7_hwmgr.c
@@ -1533,6 +1533,10 @@ int smu7_disable_dpm_tasks(struct pp_hwmgr *hwmgr)
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
index 7bf9a14bfa0be..f6490a1284384 100644
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
index c5288831aa15c..05a55e850b5e0 100644
--- a/drivers/gpu/drm/amd/powerplay/inc/smumgr.h
+++ b/drivers/gpu/drm/amd/powerplay/inc/smumgr.h
@@ -114,4 +114,6 @@ extern int smum_update_dpm_settings(struct pp_hwmgr *hwmgr, void *profile_settin
 
 extern int smum_smc_table_manager(struct pp_hwmgr *hwmgr, uint8_t *table, uint16_t table_id, bool rw);
 
+extern int smum_stop_smc(struct pp_hwmgr *hwmgr);
+
 #endif
diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
index 09a3d8ae44491..0f4f27a89020d 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/ci_smumgr.c
@@ -2936,6 +2936,29 @@ static int ci_update_smc_table(struct pp_hwmgr *hwmgr, uint32_t type)
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
@@ -2960,4 +2983,5 @@ const struct pp_smumgr_func ci_smu_funcs = {
 	.is_dpm_running = ci_is_dpm_running,
 	.update_dpm_settings = ci_update_dpm_settings,
 	.update_smc_table = ci_update_smc_table,
+	.stop_smc = ci_stop_smc,
 };
diff --git a/drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c b/drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c
index 4240aeec9000e..83d06f8e99ec2 100644
--- a/drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c
+++ b/drivers/gpu/drm/amd/powerplay/smumgr/smumgr.c
@@ -217,3 +217,11 @@ int smum_smc_table_manager(struct pp_hwmgr *hwmgr, uint8_t *table, uint16_t tabl
 
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



