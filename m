Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3FA66C4CE
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbjAPP62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbjAPP6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:58:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4860515543
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:58:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A071B8105C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61017C433EF;
        Mon, 16 Jan 2023 15:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884696;
        bh=k9/yn1qX9AeyRCE+EJ+zJyIjAOBaC5vdQe2eUwZA/Zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ov9wopbL7ehfeRryTkKLsd5E49zZDKxfXPpdzylfRYxNGuaZx9Jy1XyCnrN1iBteO
         cRotl+5/l7mx7+Twc4bD4YJ+og8DIGbFgMRZ9EMykSkCeHjQvNFatGERSXgDm26NFJ
         O5AEZhBvshUPKOr0YXO8Lb8rpMHRezc3QMjBEiNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Candice Li <candice.li@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/183] drm/amd/pm: Enable bad memory page/channel recording support for smu v13_0_0
Date:   Mon, 16 Jan 2023 16:49:59 +0100
Message-Id: <20230116154806.618497173@linuxfoundation.org>
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

From: Candice Li <candice.li@amd.com>

[ Upstream commit 48aa62f07467c8fcd4b4ec7851e13c83e89a1558 ]

Send message to SMU to update bad memory page and bad channel info.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 1794f6a9535b ("drm/amd/pm: enable GPO dynamic control support for SMU13.0.0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../pm/swsmu/inc/pmfw_if/smu_v13_0_0_ppsmc.h  |  8 +++-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_types.h  |  4 +-
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c  | 39 +++++++++++++++++++
 3 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu_v13_0_0_ppsmc.h b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu_v13_0_0_ppsmc.h
index 9ebb8f39732a..8b8266890a10 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu_v13_0_0_ppsmc.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu_v13_0_0_ppsmc.h
@@ -131,7 +131,13 @@
 #define PPSMC_MSG_EnableAudioStutterWA           0x44
 #define PPSMC_MSG_PowerUpUmsch                   0x45
 #define PPSMC_MSG_PowerDownUmsch                 0x46
-#define PPSMC_Message_Count                      0x47
+#define PPSMC_MSG_SetDcsArch                     0x47
+#define PPSMC_MSG_TriggerVFFLR                   0x48
+#define PPSMC_MSG_SetNumBadMemoryPagesRetired    0x49
+#define PPSMC_MSG_SetBadMemoryPagesRetiredFlagsPerChannel 0x4A
+#define PPSMC_MSG_SetPriorityDeltaGain           0x4B
+#define PPSMC_MSG_AllowIHHostInterrupt           0x4C
+#define PPSMC_Message_Count                      0x4D
 
 //Debug Dump Message
 #define DEBUGSMC_MSG_TestMessage                    0x1
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_types.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_types.h
index 58098b82df66..a4e3425b1027 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_types.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_types.h
@@ -239,7 +239,9 @@
 	__SMU_DUMMY_MAP(DriverMode2Reset), \
 	__SMU_DUMMY_MAP(GetGfxOffStatus),		 \
 	__SMU_DUMMY_MAP(GetGfxOffEntryCount),		 \
-	__SMU_DUMMY_MAP(LogGfxOffResidency),
+	__SMU_DUMMY_MAP(LogGfxOffResidency),			\
+	__SMU_DUMMY_MAP(SetNumBadMemoryPagesRetired),		\
+	__SMU_DUMMY_MAP(SetBadMemoryPagesRetiredFlagsPerChannel),
 
 #undef __SMU_DUMMY_MAP
 #define __SMU_DUMMY_MAP(type)	SMU_MSG_##type
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 73bae7eaefa2..884d4176b412 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -141,6 +141,9 @@ static struct cmn2asic_msg_mapping smu_v13_0_0_message_map[SMU_MSG_MAX_COUNT] =
 	MSG_MAP(PrepareMp1ForUnload,		PPSMC_MSG_PrepareMp1ForUnload,         0),
 	MSG_MAP(DFCstateControl,		PPSMC_MSG_SetExternalClientDfCstateAllow, 0),
 	MSG_MAP(ArmD3,				PPSMC_MSG_ArmD3,                       0),
+	MSG_MAP(SetNumBadMemoryPagesRetired,	PPSMC_MSG_SetNumBadMemoryPagesRetired,   0),
+	MSG_MAP(SetBadMemoryPagesRetiredFlagsPerChannel,
+			    PPSMC_MSG_SetBadMemoryPagesRetiredFlagsPerChannel,   0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_0_clk_map[SMU_CLK_COUNT] = {
@@ -1928,6 +1931,40 @@ static void smu_v13_0_0_set_smu_mailbox_registers(struct smu_context *smu)
 	smu->debug_resp_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_54);
 }
 
+static int smu_v13_0_0_smu_send_bad_mem_page_num(struct smu_context *smu,
+		uint32_t size)
+{
+	int ret = 0;
+
+	/* message SMU to update the bad page number on SMUBUS */
+	ret = smu_cmn_send_smc_msg_with_param(smu,
+					  SMU_MSG_SetNumBadMemoryPagesRetired,
+					  size, NULL);
+	if (ret)
+		dev_err(smu->adev->dev,
+			  "[%s] failed to message SMU to update bad memory pages number\n",
+			  __func__);
+
+	return ret;
+}
+
+static int smu_v13_0_0_send_bad_mem_channel_flag(struct smu_context *smu,
+		uint32_t size)
+{
+	int ret = 0;
+
+	/* message SMU to update the bad channel info on SMUBUS */
+	ret = smu_cmn_send_smc_msg_with_param(smu,
+				  SMU_MSG_SetBadMemoryPagesRetiredFlagsPerChannel,
+				  size, NULL);
+	if (ret)
+		dev_err(smu->adev->dev,
+			  "[%s] failed to message SMU to update bad memory pages channel info\n",
+			  __func__);
+
+	return ret;
+}
+
 static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.get_allowed_feature_mask = smu_v13_0_0_get_allowed_feature_mask,
 	.set_default_dpm_table = smu_v13_0_0_set_default_dpm_table,
@@ -1998,6 +2035,8 @@ static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.mode1_reset = smu_v13_0_0_mode1_reset,
 	.set_mp1_state = smu_v13_0_0_set_mp1_state,
 	.set_df_cstate = smu_v13_0_0_set_df_cstate,
+	.send_hbm_bad_pages_num = smu_v13_0_0_smu_send_bad_mem_page_num,
+	.send_hbm_bad_channel_flag = smu_v13_0_0_send_bad_mem_channel_flag,
 };
 
 void smu_v13_0_0_set_ppt_funcs(struct smu_context *smu)
-- 
2.35.1



