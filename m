Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BF24FCB30
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347564AbiDLBD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343854AbiDLA5I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:57:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2EC24F3E;
        Mon, 11 Apr 2022 17:49:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BF4E617E9;
        Tue, 12 Apr 2022 00:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2E6C385A3;
        Tue, 12 Apr 2022 00:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724578;
        bh=+c2FCMYkIhAQb6pTpNufiCaP0nYl95lV9Tb0t+9Od+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7232wlT1VSoRdzGHiBYwkEB8NOn4Dj77tj65t4ntHoUVXoPKf75cPv9CZPgmNLKV
         Y3lX4PQjPXJgMA5aWYQCMx4fRjkWDz8zYEHUAT7dcaN/7PX78f4By0bEJJ0XKW16VN
         VT745PeVJEhY82tytHjWPXsbRaPcaEmpkL8FBZOEYvgEgoSvVuDbs20Ra8wZHt7koU
         uNv2gcoPNkCMjxI26+VRbx+G7gh35Hjm7LWDiln0D5ajl7sPlK9osEYDbqnsXJWkQl
         O2ek5L/jvMgvJmkeW9nEFGCIZTa2LTJSEucNEE5mEq66ANsmBxzcaNY04uYVycqEcZ
         bw7Fmm8Zhd8LQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tianci Yin <tianci.yin@amd.com>, James Zhu <James.Zhu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        leo.liu@amd.com, andrey.grodzovsky@amd.com,
        bas@basnieuwenhuizen.nl, ruijing.dong@amd.com,
        veerabadhran.gopalakrishnan@amd.com, PengJu.Zhou@amd.com,
        Bokun.Zhang@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 08/30] drm/amdgpu/vcn: improve vcn dpg stop procedure
Date:   Mon, 11 Apr 2022 20:48:42 -0400
Message-Id: <20220412004906.350678-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004906.350678-1-sashal@kernel.org>
References: <20220412004906.350678-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tianci Yin <tianci.yin@amd.com>

[ Upstream commit 6ea239adc2a712eb318f04f5c29b018ba65ea38a ]

Prior to disabling dpg, VCN need unpausing dpg mode, or VCN will hang in
S3 resuming.

Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Tianci Yin <tianci.yin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 2099f6ebd833..bdb8e596bda6 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1429,8 +1429,11 @@ static int vcn_v3_0_start_sriov(struct amdgpu_device *adev)
 
 static int vcn_v3_0_stop_dpg_mode(struct amdgpu_device *adev, int inst_idx)
 {
+	struct dpg_pause_state state = {.fw_based = VCN_DPG_STATE__UNPAUSE};
 	uint32_t tmp;
 
+	vcn_v3_0_pause_dpg_mode(adev, 0, &state);
+
 	/* Wait for power status to be 1 */
 	SOC15_WAIT_ON_RREG(VCN, inst_idx, mmUVD_POWER_STATUS, 1,
 		UVD_POWER_STATUS__UVD_POWER_STATUS_MASK);
-- 
2.35.1

