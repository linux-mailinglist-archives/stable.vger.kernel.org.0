Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A41465D65E
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239590AbjADOoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239679AbjADOop (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:44:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F6837525
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:44:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B72B26175D
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E78C433F1;
        Wed,  4 Jan 2023 14:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672843484;
        bh=zrfqwfEXWfH+hsgCNVDwpb1q4F1RzXprOqn3YrKfQmw=;
        h=Subject:To:Cc:From:Date:From;
        b=DXFq4x88T0FB563bzUeQfRad0G2kKXk+oh23lFDxO0AX/vH9C3ov+FkMx64DF5haK
         fRY33eatQH6PAPLZ0p74MEb7/RGk95rezzE3pDdXuJbUzYt4Jn5Syuj0JnPnSZPa8G
         wyaVsZI2P4jbVpPHNBNToO2oQ8zLp4UppBRzV47Q=
Subject: FAILED: patch "[PATCH] drm/amd/pm: disable cstate feature for gpu reset scenario" failed to apply to 6.1-stable tree
To:     evan.quan@amd.com, Hawking.Zhang@amd.com,
        alexander.deucher@amd.com, lijo.lazar@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:44:30 +0100
Message-ID: <167284347084128@kroah.com>
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

b31d6ada8346 ("drm/amd/pm: disable cstate feature for gpu reset scenario")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b31d6ada8346574ce04656e5ce9676ec763f5144 Mon Sep 17 00:00:00 2001
From: Evan Quan <evan.quan@amd.com>
Date: Thu, 29 Sep 2022 10:50:44 +0800
Subject: [PATCH] drm/amd/pm: disable cstate feature for gpu reset scenario

Suggested by PMFW team and same as what did for gfxoff feature.
This can address some Mode1Reset failures observed on SMU13.0.0.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index bb73fb420ffc..e0445e8cc342 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2928,6 +2928,14 @@ static int amdgpu_device_ip_suspend_phase1(struct amdgpu_device *adev)
 	amdgpu_device_set_pg_state(adev, AMD_PG_STATE_UNGATE);
 	amdgpu_device_set_cg_state(adev, AMD_CG_STATE_UNGATE);
 
+	/*
+	 * Per PMFW team's suggestion, driver needs to handle gfxoff
+	 * and df cstate features disablement for gpu reset(e.g. Mode1Reset)
+	 * scenario. Add the missing df cstate disablement here.
+	 */
+	if (amdgpu_dpm_set_df_cstate(adev, DF_CSTATE_DISALLOW))
+		dev_warn(adev->dev, "Failed to disallow df cstate");
+
 	for (i = adev->num_ip_blocks - 1; i >= 0; i--) {
 		if (!adev->ip_blocks[i].status.valid)
 			continue;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
index 445005571f76..9cd005131f56 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -2242,9 +2242,17 @@ static void arcturus_get_unique_id(struct smu_context *smu)
 static int arcturus_set_df_cstate(struct smu_context *smu,
 				  enum pp_df_cstate state)
 {
+	struct amdgpu_device *adev = smu->adev;
 	uint32_t smu_version;
 	int ret;
 
+	/*
+	 * Arcturus does not need the cstate disablement
+	 * prerequisite for gpu reset.
+	 */
+	if (amdgpu_in_reset(adev) || adev->in_suspend)
+		return 0;
+
 	ret = smu_cmn_get_smc_version(smu, NULL, &smu_version);
 	if (ret) {
 		dev_err(smu->adev->dev, "Failed to get smu version!\n");
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index 619aee51b123..d30ec3005ea1 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1640,6 +1640,15 @@ static bool aldebaran_is_baco_supported(struct smu_context *smu)
 static int aldebaran_set_df_cstate(struct smu_context *smu,
 				   enum pp_df_cstate state)
 {
+	struct amdgpu_device *adev = smu->adev;
+
+	/*
+	 * Aldebaran does not need the cstate disablement
+	 * prerequisite for gpu reset.
+	 */
+	if (amdgpu_in_reset(adev) || adev->in_suspend)
+		return 0;
+
 	return smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_DFCstateControl, state, NULL);
 }
 

