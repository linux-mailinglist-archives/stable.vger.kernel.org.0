Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA0B60A1A4
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJXLbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiJXLbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:31:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500DC55C58;
        Mon, 24 Oct 2022 04:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01F1DB8113A;
        Mon, 24 Oct 2022 11:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AD2C433C1;
        Mon, 24 Oct 2022 11:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611105;
        bh=fCOJG6u/PwN900egkfC9xg+Is3FCL/e8k21sKERtIMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3AUODOSzfm2i6+P6zM3a4cMGG0dA9t2/2qFvMjNVJRQlRSiT4u8uq5EEm8NAVKuF
         SCF+/BdbCfJOA5IjKBZRPBVN16l3BvKLB2SGFZw9rkX5eGs1fZjgOYJ5lexDq3wDuc
         ypumWyWW9HD5IhGAUSpNE+KyfgHBMij01PBXwDHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 11/20] drm/amd/pm: disable cstate feature for gpu reset scenario
Date:   Mon, 24 Oct 2022 13:31:13 +0200
Message-Id: <20221024112934.902288047@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112934.415391158@linuxfoundation.org>
References: <20221024112934.415391158@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 3059cd8c5f797ad83d2b194ae66339f5c007ca43 upstream.

Suggested by PMFW team and same as what did for gfxoff feature.
This can address some Mode1Reset failures observed on SMU13.0.0.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |    8 ++++++++
 drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c  |    8 ++++++++
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c |    9 +++++++++
 3 files changed, 25 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2926,6 +2926,14 @@ static int amdgpu_device_ip_suspend_phas
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
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/arcturus_ppt.c
@@ -2242,9 +2242,17 @@ static void arcturus_get_unique_id(struc
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
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1640,6 +1640,15 @@ static bool aldebaran_is_baco_supported(
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
 


