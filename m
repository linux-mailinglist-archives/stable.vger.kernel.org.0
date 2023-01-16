Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF9F66C4CD
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbjAPP60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbjAPP6V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:58:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC2C1CF6F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:58:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEB7D61041
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:58:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46B2C433EF;
        Mon, 16 Jan 2023 15:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884699;
        bh=mx1Jof/9lH7akl7NSyXKOo6UnZ3bu6yAB3sekxKboPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BIjdweLvBURu9+CTlFpfZYo/gIegk2hyW1WBmL/NL7BPc54sykRDAiI8l0mfOiFPM
         QabHOXMP4XHdIxqrl76zXJFiWpzFGcXPcChJax0FSImxqPMVjuOGwEeNWZ2IexAEYD
         i9yumquPVGCjq7hbRnlqMWQf5ErGlyobomtsyERM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/183] drm/amd/pm: enable GPO dynamic control support for SMU13.0.0
Date:   Mon, 16 Jan 2023 16:50:00 +0100
Message-Id: <20230116154806.667719978@linuxfoundation.org>
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

From: Evan Quan <evan.quan@amd.com>

[ Upstream commit 1794f6a9535bb5234c2b747d1bc6dad03249245a ]

To better support UMD pstate profilings, the GPO feature needs
to be switched on/off accordingly.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_types.h      |  3 ++-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h      |  3 +++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c    | 15 +++++++++++++++
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c  |  2 ++
 4 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_types.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_types.h
index a4e3425b1027..4180c71d930f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_types.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_types.h
@@ -241,7 +241,8 @@
 	__SMU_DUMMY_MAP(GetGfxOffEntryCount),		 \
 	__SMU_DUMMY_MAP(LogGfxOffResidency),			\
 	__SMU_DUMMY_MAP(SetNumBadMemoryPagesRetired),		\
-	__SMU_DUMMY_MAP(SetBadMemoryPagesRetiredFlagsPerChannel),
+	__SMU_DUMMY_MAP(SetBadMemoryPagesRetiredFlagsPerChannel), \
+	__SMU_DUMMY_MAP(AllowGpo),
 
 #undef __SMU_DUMMY_MAP
 #define __SMU_DUMMY_MAP(type)	SMU_MSG_##type
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index a9122b3b1532..e8c6febb8b64 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -273,6 +273,9 @@ int smu_v13_0_init_pptable_microcode(struct smu_context *smu);
 
 int smu_v13_0_run_btc(struct smu_context *smu);
 
+int smu_v13_0_gpo_control(struct smu_context *smu,
+			  bool enablement);
+
 int smu_v13_0_deep_sleep_control(struct smu_context *smu,
 				 bool enablement);
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index cfb7f4475c82..9f9f64c5cdd8 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -2148,6 +2148,21 @@ int smu_v13_0_run_btc(struct smu_context *smu)
 	return res;
 }
 
+int smu_v13_0_gpo_control(struct smu_context *smu,
+			  bool enablement)
+{
+	int res;
+
+	res = smu_cmn_send_smc_msg_with_param(smu,
+					      SMU_MSG_AllowGpo,
+					      enablement ? 1 : 0,
+					      NULL);
+	if (res)
+		dev_err(smu->adev->dev, "SetGpoAllow %d failed!\n", enablement);
+
+	return res;
+}
+
 int smu_v13_0_deep_sleep_control(struct smu_context *smu,
 				 bool enablement)
 {
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index 884d4176b412..4c20d17e7416 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -144,6 +144,7 @@ static struct cmn2asic_msg_mapping smu_v13_0_0_message_map[SMU_MSG_MAX_COUNT] =
 	MSG_MAP(SetNumBadMemoryPagesRetired,	PPSMC_MSG_SetNumBadMemoryPagesRetired,   0),
 	MSG_MAP(SetBadMemoryPagesRetiredFlagsPerChannel,
 			    PPSMC_MSG_SetBadMemoryPagesRetiredFlagsPerChannel,   0),
+	MSG_MAP(AllowGpo,			PPSMC_MSG_SetGpoAllow,           0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_0_clk_map[SMU_CLK_COUNT] = {
@@ -2037,6 +2038,7 @@ static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.set_df_cstate = smu_v13_0_0_set_df_cstate,
 	.send_hbm_bad_pages_num = smu_v13_0_0_smu_send_bad_mem_page_num,
 	.send_hbm_bad_channel_flag = smu_v13_0_0_send_bad_mem_channel_flag,
+	.gpo_control = smu_v13_0_gpo_control,
 };
 
 void smu_v13_0_0_set_ppt_funcs(struct smu_context *smu)
-- 
2.35.1



