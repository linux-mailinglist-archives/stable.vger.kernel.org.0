Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CD66358D0
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbiKWKDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237273AbiKWKCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:02:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D79B97ABE
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:54:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DE4C619EB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:54:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27097C433D6;
        Wed, 23 Nov 2022 09:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197249;
        bh=Ni/UkbBWuJjbNyQmPRsGbosgP97TdjJxTAK+unTr9nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D4jC37iW3MFztun/TtgRZPeeff2RzkpS3DliTYaJpI7WbvvbKW2hjS9wqudFQTMsn
         u8NG6aHoBXHHumf4r93PEkxvYqxFBTppDtcO/dMl/Fm/OHdBTr/u2e2kiQ829QM8RM
         gu1oifuVWKz+holyC74nP43ia4qCQ1t9NVqtUvqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Evan Quan <evan.quan@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Feifei Xu <Feifei.Xu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 210/314] drm/amd/pm: enable runpm support over BACO for SMU13.0.7
Date:   Wed, 23 Nov 2022 09:50:55 +0100
Message-Id: <20221123084635.051959554@linuxfoundation.org>
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

commit df7c013efc1a0da8861099802b2d6ab2aacaeb1b upstream.

Enable SMU13.0.7 runpm support.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c  | 30 +++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index c4102cfb734c..d74debc584f8 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -122,6 +122,7 @@ static struct cmn2asic_msg_mapping smu_v13_0_7_message_map[SMU_MSG_MAX_COUNT] =
 	MSG_MAP(PrepareMp1ForUnload,		PPSMC_MSG_PrepareMp1ForUnload,         0),
 	MSG_MAP(SetMGpuFanBoostLimitRpm,	PPSMC_MSG_SetMGpuFanBoostLimitRpm,     0),
 	MSG_MAP(DFCstateControl,		PPSMC_MSG_SetExternalClientDfCstateAllow, 0),
+	MSG_MAP(ArmD3,				PPSMC_MSG_ArmD3,                       0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_7_clk_map[SMU_CLK_COUNT] = {
@@ -1578,6 +1579,31 @@ static int smu_v13_0_7_set_mp1_state(struct smu_context *smu,
 	return ret;
 }
 
+static int smu_v13_0_7_baco_enter(struct smu_context *smu)
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
+static int smu_v13_0_7_baco_exit(struct smu_context *smu)
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
 static bool smu_v13_0_7_is_mode1_reset_supported(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
@@ -1655,8 +1681,8 @@ static const struct pptable_funcs smu_v13_0_7_ppt_funcs = {
 	.baco_is_support = smu_v13_0_baco_is_support,
 	.baco_get_state = smu_v13_0_baco_get_state,
 	.baco_set_state = smu_v13_0_baco_set_state,
-	.baco_enter = smu_v13_0_baco_enter,
-	.baco_exit = smu_v13_0_baco_exit,
+	.baco_enter = smu_v13_0_7_baco_enter,
+	.baco_exit = smu_v13_0_7_baco_exit,
 	.mode1_reset_is_support = smu_v13_0_7_is_mode1_reset_supported,
 	.mode1_reset = smu_v13_0_mode1_reset,
 	.set_mp1_state = smu_v13_0_7_set_mp1_state,
-- 
2.38.1



