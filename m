Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A746358DB
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiKWKDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237321AbiKWKCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:02:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B0774CD3
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:54:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C587C619EB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FA0C433C1;
        Wed, 23 Nov 2022 09:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197253;
        bh=8vxs2esCDra+Z5MC0ms9XSKHHJLKZjYIdX5Bv0ktD/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DmfCT4Zha2Dl2reJiMBAimQisS+OP4SUM1eiQX43Cmtk/FNkhfZcW8mHY2HX5gZPs
         D6ESiVAc/+mFASjpl7pes1npkSyfPNIIDyoW+h82PGCQ3AFjkbdEIzxdqmjad0IYGC
         VC3snxpX17ulMmz8CsPblb4Pfkc9mlrlgpewgqUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Feifei Xu <Feifei.Xu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 211/314] drm/amd/pm: enable runpm support over BACO for SMU13.0.0
Date:   Wed, 23 Nov 2022 09:50:56 +0100
Message-Id: <20221123084635.092211523@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

commit 8652da45d09abe1b3174dbb80dc5176b8c3fa08e upstream.

Enable SMU13.0.0 runpm support.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h        |    8 +++++
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v11_0.h         |   10 ------
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h         |   11 +-----
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c       |    2 -
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c       |    9 +++++
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |   30 +++++++++++++++++--
 6 files changed, 50 insertions(+), 20 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h
@@ -1372,6 +1372,14 @@ enum smu_cmn2asic_mapping_type {
 	CMN2ASIC_MAPPING_WORKLOAD,
 };
 
+enum smu_baco_seq {
+	BACO_SEQ_BACO = 0,
+	BACO_SEQ_MSR,
+	BACO_SEQ_BAMACO,
+	BACO_SEQ_ULPS,
+	BACO_SEQ_COUNT,
+};
+
 #define MSG_MAP(msg, index, valid_in_vf) \
 	[SMU_MSG_##msg] = {1, (index), (valid_in_vf)}
 
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v11_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v11_0.h
@@ -147,14 +147,6 @@ struct smu_11_5_power_context {
 	uint32_t	max_fast_ppt_limit;
 };
 
-enum smu_v11_0_baco_seq {
-	BACO_SEQ_BACO = 0,
-	BACO_SEQ_MSR,
-	BACO_SEQ_BAMACO,
-	BACO_SEQ_ULPS,
-	BACO_SEQ_COUNT,
-};
-
 #if defined(SWSMU_CODE_LAYER_L2) || defined(SWSMU_CODE_LAYER_L3)
 
 int smu_v11_0_init_microcode(struct smu_context *smu);
@@ -257,7 +249,7 @@ int smu_v11_0_baco_enter(struct smu_cont
 int smu_v11_0_baco_exit(struct smu_context *smu);
 
 int smu_v11_0_baco_set_armd3_sequence(struct smu_context *smu,
-				      enum smu_v11_0_baco_seq baco_seq);
+				      enum smu_baco_seq baco_seq);
 
 int smu_v11_0_mode1_reset(struct smu_context *smu);
 
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -123,14 +123,6 @@ struct smu_13_0_power_context {
 	enum smu_13_0_power_state power_state;
 };
 
-enum smu_v13_0_baco_seq {
-	BACO_SEQ_BACO = 0,
-	BACO_SEQ_MSR,
-	BACO_SEQ_BAMACO,
-	BACO_SEQ_ULPS,
-	BACO_SEQ_COUNT,
-};
-
 #if defined(SWSMU_CODE_LAYER_L2) || defined(SWSMU_CODE_LAYER_L3)
 
 int smu_v13_0_init_microcode(struct smu_context *smu);
@@ -217,6 +209,9 @@ int smu_v13_0_set_azalia_d3_pme(struct s
 int smu_v13_0_get_max_sustainable_clocks_by_dc(struct smu_context *smu,
 					       struct pp_smu_nv_clock_table *max_clocks);
 
+int smu_v13_0_baco_set_armd3_sequence(struct smu_context *smu,
+				      enum smu_baco_seq baco_seq);
+
 bool smu_v13_0_baco_is_support(struct smu_context *smu);
 
 enum smu_baco_state smu_v13_0_baco_get_state(struct smu_context *smu);
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -1576,7 +1576,7 @@ int smu_v11_0_set_azalia_d3_pme(struct s
 }
 
 int smu_v11_0_baco_set_armd3_sequence(struct smu_context *smu,
-				      enum smu_v11_0_baco_seq baco_seq)
+				      enum smu_baco_seq baco_seq)
 {
 	return smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_ArmD3, baco_seq, NULL);
 }
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -2219,6 +2219,15 @@ int smu_v13_0_gfx_ulv_control(struct smu
 	return ret;
 }
 
+int smu_v13_0_baco_set_armd3_sequence(struct smu_context *smu,
+				      enum smu_baco_seq baco_seq)
+{
+	return smu_cmn_send_smc_msg_with_param(smu,
+					       SMU_MSG_ArmD3,
+					       baco_seq,
+					       NULL);
+}
+
 bool smu_v13_0_baco_is_support(struct smu_context *smu)
 {
 	struct smu_baco_context *smu_baco = &smu->smu_baco;
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -120,6 +120,7 @@ static struct cmn2asic_msg_mapping smu_v
 	MSG_MAP(Mode1Reset,			PPSMC_MSG_Mode1Reset,                  0),
 	MSG_MAP(PrepareMp1ForUnload,		PPSMC_MSG_PrepareMp1ForUnload,         0),
 	MSG_MAP(DFCstateControl,		PPSMC_MSG_SetExternalClientDfCstateAllow, 0),
+	MSG_MAP(ArmD3,				PPSMC_MSG_ArmD3,                       0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_0_clk_map[SMU_CLK_COUNT] = {
@@ -1566,6 +1567,31 @@ static int smu_v13_0_0_set_power_profile
 					       NULL);
 }
 
+static int smu_v13_0_0_baco_enter(struct smu_context *smu)
+{
+	struct smu_baco_context *smu_baco = &smu->smu_baco;
+	struct amdgpu_device *adev = smu->adev;
+
+	if (adev->in_runpm && smu_cmn_is_audio_func_enabled(adev))
+		return smu_v13_0_baco_set_armd3_sequence(smu,
+				smu_baco->maco_support ? BACO_SEQ_BAMACO : BACO_SEQ_BACO);
+	else
+		return smu_v13_0_baco_enter(smu);
+}
+
+static int smu_v13_0_0_baco_exit(struct smu_context *smu)
+{
+	struct amdgpu_device *adev = smu->adev;
+
+	if (adev->in_runpm && smu_cmn_is_audio_func_enabled(adev)) {
+		/* Wait for PMFW handling for the Dstate change */
+		usleep_range(10000, 11000);
+		return smu_v13_0_baco_set_armd3_sequence(smu, BACO_SEQ_ULPS);
+	} else {
+		return smu_v13_0_baco_exit(smu);
+	}
+}
+
 static bool smu_v13_0_0_is_mode1_reset_supported(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
@@ -1827,8 +1853,8 @@ static const struct pptable_funcs smu_v1
 	.baco_is_support = smu_v13_0_baco_is_support,
 	.baco_get_state = smu_v13_0_baco_get_state,
 	.baco_set_state = smu_v13_0_baco_set_state,
-	.baco_enter = smu_v13_0_baco_enter,
-	.baco_exit = smu_v13_0_baco_exit,
+	.baco_enter = smu_v13_0_0_baco_enter,
+	.baco_exit = smu_v13_0_0_baco_exit,
 	.mode1_reset_is_support = smu_v13_0_0_is_mode1_reset_supported,
 	.mode1_reset = smu_v13_0_mode1_reset,
 	.set_mp1_state = smu_v13_0_0_set_mp1_state,


