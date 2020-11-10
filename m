Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAD72ACD8D
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732965AbgKJDzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:55:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:56182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731803AbgKJDzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:55:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30A1C20721;
        Tue, 10 Nov 2020 03:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980502;
        bh=dmDJI0QQe4VlDG5EGtS5+/ssCqnCyrFhWR8O/fPYlM4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bzi732aL7rK1eY40NNlv7D9AwtE5otSO6zUD1MaPqJNX+NJ4CFVj/Ep6/3eP3pwiG
         Da+s8XCGknppsgAUJqtDg9a/xR4G822vQJylY+JHU6qH+BK6qc27eXoDPDX6TXi2zr
         2Z2Zh+TxZbl7i8uvUIoLAiBa4C7+tIPbyaL90t3s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evan Quan <evan.quan@amd.com>,
        Sandeep Raghuraman <sandy.8925@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 15/42] drm/amd/pm: perform SMC reset on suspend/hibernation
Date:   Mon,  9 Nov 2020 22:54:13 -0500
Message-Id: <20201110035440.424258-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

