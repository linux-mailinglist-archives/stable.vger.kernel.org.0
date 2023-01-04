Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BB665D779
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbjADPqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239805AbjADPp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:45:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD75D3750D
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:45:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66F8F61775
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72560C433EF;
        Wed,  4 Jan 2023 15:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672847118;
        bh=Ej1/j28zpNVI7iPLGlIFIhIB2fVOuMDQhV1jRWABRaY=;
        h=Subject:To:Cc:From:Date:From;
        b=NeQL1uBUcGSl9/hefbe2XbHk6Aejbluctcoz1Ck+60mI4FtsZRJHw8FiAo2MyhbAk
         LUxWlWZQnmaMulAeJcDUj6LwhKdYdHy50qsvs4wEVTEh/VGxrzw/igurAe3ZzwxcQQ
         +LMMe/PPhRuy9kJeX5Y++44h4/95RqTCU66kMiqM=
Subject: FAILED: patch "[PATCH] drm/amd/pm: enable GPO dynamic control support for SMU13.0.0" failed to apply to 6.1-stable tree
To:     evan.quan@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:45:15 +0100
Message-ID: <16728471152838@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1794f6a9535b ("drm/amd/pm: enable GPO dynamic control support for SMU13.0.0")
48aa62f07467 ("drm/amd/pm: Enable bad memory page/channel recording support for smu v13_0_0")
8ae5a38c8cb3 ("drm/amd/pm: enable runpm support over BACO for SMU13.0.0")
60cfad329ab8 ("drm/amd/pm: enable mode1 reset on smu_v13_0_10")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1794f6a9535bb5234c2b747d1bc6dad03249245a Mon Sep 17 00:00:00 2001
From: Evan Quan <evan.quan@amd.com>
Date: Fri, 2 Dec 2022 13:56:35 +0800
Subject: [PATCH] drm/amd/pm: enable GPO dynamic control support for SMU13.0.0

To better support UMD pstate profilings, the GPO feature needs
to be switched on/off accordingly.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x

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
index 865d6358918d..ea29ac6a80e6 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -272,6 +272,9 @@ int smu_v13_0_init_pptable_microcode(struct smu_context *smu);
 
 int smu_v13_0_run_btc(struct smu_context *smu);
 
+int smu_v13_0_gpo_control(struct smu_context *smu,
+			  bool enablement);
+
 int smu_v13_0_deep_sleep_control(struct smu_context *smu,
 				 bool enablement);
 
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index f5e90e0a99df..e3a80ac987df 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -2180,6 +2180,21 @@ int smu_v13_0_run_btc(struct smu_context *smu)
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
index 21d89c3302f1..cc66828c7a84 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -144,6 +144,7 @@ static struct cmn2asic_msg_mapping smu_v13_0_0_message_map[SMU_MSG_MAX_COUNT] =
 	MSG_MAP(SetNumBadMemoryPagesRetired,	PPSMC_MSG_SetNumBadMemoryPagesRetired,   0),
 	MSG_MAP(SetBadMemoryPagesRetiredFlagsPerChannel,
 			    PPSMC_MSG_SetBadMemoryPagesRetiredFlagsPerChannel,   0),
+	MSG_MAP(AllowGpo,			PPSMC_MSG_SetGpoAllow,           0),
 };
 
 static struct cmn2asic_mapping smu_v13_0_0_clk_map[SMU_CLK_COUNT] = {
@@ -1949,6 +1950,7 @@ static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.set_df_cstate = smu_v13_0_0_set_df_cstate,
 	.send_hbm_bad_pages_num = smu_v13_0_0_smu_send_bad_mem_page_num,
 	.send_hbm_bad_channel_flag = smu_v13_0_0_send_bad_mem_channel_flag,
+	.gpo_control = smu_v13_0_gpo_control,
 };
 
 void smu_v13_0_0_set_ppt_funcs(struct smu_context *smu)

