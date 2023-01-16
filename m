Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C69866C4CC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbjAPP6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjAPP6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:58:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9036222FB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:58:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 603C5B81052
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:58:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD235C433EF;
        Mon, 16 Jan 2023 15:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884694;
        bh=R32NOMQiJMN4poX7/zD1fmWHmFPIY4pZxMOc4ln9+po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQ338LZ8Ikem8ak++R2eWD7aUx8F4vY98ip1buS81n9xq+uYShA/eb2M5fhprGeue
         F/O4RGOakd+8lqqMNMJjysUOL2IqR/XNqZV95WFasxzXMRirqivUCfXb/4+JKJVH0G
         1HwJ797TbmxUsw2Oeias+vJlHVYa4qtg6F0hLZ28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kenneth Feng <kenneth.feng@amd.com>,
        Yang Wang <kevinyang.wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/183] drm/amd/pm: enable mode1 reset on smu_v13_0_10
Date:   Mon, 16 Jan 2023 16:49:58 +0100
Message-Id: <20230116154806.582224771@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Feng <kenneth.feng@amd.com>

[ Upstream commit 60cfad329ab877cb62975ea78ed442c2496990ba ]

enable mode1 reset and prioritize debug port on smu_v13_0_10
as a more reliable message processing

v2 - move mode1 reset callback to smu_v13_0_0_ppt.c

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 1794f6a9535b ("drm/amd/pm: enable GPO dynamic control support for SMU13.0.0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/soc21.c            |  1 +
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h |  4 ++
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c  | 53 ++++++++++++++++++-
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c        | 18 +++++++
 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h        |  3 ++
 5 files changed, 77 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 8b297ade69a2..f1913d879811 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -322,6 +322,7 @@ soc21_asic_reset_method(struct amdgpu_device *adev)
 	switch (adev->ip_versions[MP1_HWIP][0]) {
 	case IP_VERSION(13, 0, 0):
 	case IP_VERSION(13, 0, 7):
+	case IP_VERSION(13, 0, 10):
 		return AMD_RESET_METHOD_MODE1;
 	case IP_VERSION(13, 0, 4):
 		return AMD_RESET_METHOD_MODE2;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
index f816b1dd110e..44bbf17e4bef 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -568,6 +568,10 @@ struct smu_context
 	u32 param_reg;
 	u32 msg_reg;
 	u32 resp_reg;
+
+	u32 debug_param_reg;
+	u32 debug_msg_reg;
+	u32 debug_resp_reg;
 };
 
 struct i2c_adapter;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index be43de9dd496..73bae7eaefa2 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -70,6 +70,26 @@
 
 #define MP0_MP1_DATA_REGION_SIZE_COMBOPPTABLE	0x4000
 
+#define mmMP1_SMN_C2PMSG_66                                                                            0x0282
+#define mmMP1_SMN_C2PMSG_66_BASE_IDX                                                                   0
+
+#define mmMP1_SMN_C2PMSG_82                                                                            0x0292
+#define mmMP1_SMN_C2PMSG_82_BASE_IDX                                                                   0
+
+#define mmMP1_SMN_C2PMSG_90                                                                            0x029a
+#define mmMP1_SMN_C2PMSG_90_BASE_IDX                                                                   0
+
+#define mmMP1_SMN_C2PMSG_75                                                                            0x028b
+#define mmMP1_SMN_C2PMSG_75_BASE_IDX                                                                   0
+
+#define mmMP1_SMN_C2PMSG_53                                                                            0x0275
+#define mmMP1_SMN_C2PMSG_53_BASE_IDX                                                                   0
+
+#define mmMP1_SMN_C2PMSG_54                                                                            0x0276
+#define mmMP1_SMN_C2PMSG_54_BASE_IDX                                                                   0
+
+#define DEBUGSMC_MSG_Mode1Reset	2
+
 static struct cmn2asic_msg_mapping smu_v13_0_0_message_map[SMU_MSG_MAX_COUNT] = {
 	MSG_MAP(TestMessage,			PPSMC_MSG_TestMessage,                 1),
 	MSG_MAP(GetSmuVersion,			PPSMC_MSG_GetSmuVersion,               1),
@@ -1879,6 +1899,35 @@ static int smu_v13_0_0_set_df_cstate(struct smu_context *smu,
 					       NULL);
 }
 
+static int smu_v13_0_0_mode1_reset(struct smu_context *smu)
+{
+	int ret;
+	struct amdgpu_device *adev = smu->adev;
+
+	if (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 10))
+		ret = smu_cmn_send_debug_smc_msg(smu, DEBUGSMC_MSG_Mode1Reset);
+	else
+		ret = smu_cmn_send_smc_msg(smu, SMU_MSG_Mode1Reset, NULL);
+
+	if (!ret)
+		msleep(SMU13_MODE1_RESET_WAIT_TIME_IN_MS);
+
+	return ret;
+}
+
+static void smu_v13_0_0_set_smu_mailbox_registers(struct smu_context *smu)
+{
+	struct amdgpu_device *adev = smu->adev;
+
+	smu->param_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_82);
+	smu->msg_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_66);
+	smu->resp_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_90);
+
+	smu->debug_param_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_53);
+	smu->debug_msg_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_75);
+	smu->debug_resp_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_54);
+}
+
 static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.get_allowed_feature_mask = smu_v13_0_0_get_allowed_feature_mask,
 	.set_default_dpm_table = smu_v13_0_0_set_default_dpm_table,
@@ -1946,7 +1995,7 @@ static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.baco_enter = smu_v13_0_0_baco_enter,
 	.baco_exit = smu_v13_0_0_baco_exit,
 	.mode1_reset_is_support = smu_v13_0_0_is_mode1_reset_supported,
-	.mode1_reset = smu_v13_0_mode1_reset,
+	.mode1_reset = smu_v13_0_0_mode1_reset,
 	.set_mp1_state = smu_v13_0_0_set_mp1_state,
 	.set_df_cstate = smu_v13_0_0_set_df_cstate,
 };
@@ -1960,5 +2009,5 @@ void smu_v13_0_0_set_ppt_funcs(struct smu_context *smu)
 	smu->table_map = smu_v13_0_0_table_map;
 	smu->pwr_src_map = smu_v13_0_0_pwr_src_map;
 	smu->workload_map = smu_v13_0_0_workload_map;
-	smu_v13_0_set_smu_mailbox_registers(smu);
+	smu_v13_0_0_set_smu_mailbox_registers(smu);
 }
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index e4f8f90ac5aa..768b6e7dbd77 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -233,6 +233,18 @@ static void __smu_cmn_send_msg(struct smu_context *smu,
 	WREG32(smu->msg_reg, msg);
 }
 
+static int __smu_cmn_send_debug_msg(struct smu_context *smu,
+			       u32 msg,
+			       u32 param)
+{
+	struct amdgpu_device *adev = smu->adev;
+
+	WREG32(smu->debug_param_reg, param);
+	WREG32(smu->debug_msg_reg, msg);
+	WREG32(smu->debug_resp_reg, 0);
+
+	return 0;
+}
 /**
  * smu_cmn_send_msg_without_waiting -- send the message; don't wait for status
  * @smu: pointer to an SMU context
@@ -386,6 +398,12 @@ int smu_cmn_send_smc_msg(struct smu_context *smu,
 					       read_arg);
 }
 
+int smu_cmn_send_debug_smc_msg(struct smu_context *smu,
+			 uint32_t msg)
+{
+	return __smu_cmn_send_debug_msg(smu, msg, 0);
+}
+
 int smu_cmn_to_asic_specific_index(struct smu_context *smu,
 				   enum smu_cmn2asic_mapping_type type,
 				   uint32_t index)
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h
index 1526ce09c399..f82cf76dd3a4 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.h
@@ -42,6 +42,9 @@ int smu_cmn_send_smc_msg(struct smu_context *smu,
 			 enum smu_message_type msg,
 			 uint32_t *read_arg);
 
+int smu_cmn_send_debug_smc_msg(struct smu_context *smu,
+			 uint32_t msg);
+
 int smu_cmn_wait_for_response(struct smu_context *smu);
 
 int smu_cmn_to_asic_specific_index(struct smu_context *smu,
-- 
2.35.1



