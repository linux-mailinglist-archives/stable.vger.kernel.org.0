Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB805A69E4
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 19:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiH3RYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 13:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiH3RXa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 13:23:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA5E12F125;
        Tue, 30 Aug 2022 10:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B3BBB81D0C;
        Tue, 30 Aug 2022 17:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35193C433B5;
        Tue, 30 Aug 2022 17:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661880089;
        bh=5MbtQP/uBiDAzlP/MQTmHh2C6T6vAfc4ERxjYaKaQWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t578XEnAzSdcg6KGrqD89E6tNZsoFOPOqPVjepen0DzVhEGDxbaIJRjyBj1r8BTGo
         dbg9+r5zTFgckZlXJUhwLW0LV5i/ww0gvNkAjIniVB9uHhieyR4M3B8nvMFsdcUTaf
         HV4D2sBfoD5GTv6O3wUBcy2nFbOZ/M6Y/LoaTJpGwWxhhd8fPPBgfNr4zfV/iV9Gtm
         AgkwUEmCqwjZDjTOE0RbIltVElH786feyMOG3BpSM7AXCjs6/QvrdvpgHLoFpAgqH+
         tbN2V6N43Sltl8oBlH+vQjI2UgcStYSgcM1vDe1KYkf8GSvxPKdrJhPn5wiUIP3CiE
         NCy9TFBQPH6TA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tim Huang <tim.huang@amd.com>, Yifan Zhang <yifan1.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Hawking.Zhang@amd.com, ray.huang@amd.com, Jack.Xiao@amd.com,
        Joseph.Greathouse@amd.com, Likun.Gao@amd.com, evan.quan@amd.com,
        dan.carpenter@oracle.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 32/33] drm/amdgpu: add sdma instance check for gfx11 CGCG
Date:   Tue, 30 Aug 2022 13:18:23 -0400
Message-Id: <20220830171825.580603-32-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830171825.580603-1-sashal@kernel.org>
References: <20220830171825.580603-1-sashal@kernel.org>
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

From: Tim Huang <tim.huang@amd.com>

[ Upstream commit 00047c3d967d7ef8adf8bac3c3579294a3bc0bb1 ]

For some ASICs, like GFX IP v11.0.1, only have one SDMA instance,
so not need to configure SDMA1_RLC_CGCG_CTRL for this case.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index a4a6751b1e449..30998ac47707c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5090,9 +5090,12 @@ static void gfx_v11_0_update_coarse_grain_clock_gating(struct amdgpu_device *ade
 		data = REG_SET_FIELD(data, SDMA0_RLC_CGCG_CTRL, CGCG_INT_ENABLE, 1);
 		WREG32_SOC15(GC, 0, regSDMA0_RLC_CGCG_CTRL, data);
 
-		data = RREG32_SOC15(GC, 0, regSDMA1_RLC_CGCG_CTRL);
-		data = REG_SET_FIELD(data, SDMA1_RLC_CGCG_CTRL, CGCG_INT_ENABLE, 1);
-		WREG32_SOC15(GC, 0, regSDMA1_RLC_CGCG_CTRL, data);
+		/* Some ASICs only have one SDMA instance, not need to configure SDMA1 */
+		if (adev->sdma.num_instances > 1) {
+			data = RREG32_SOC15(GC, 0, regSDMA1_RLC_CGCG_CTRL);
+			data = REG_SET_FIELD(data, SDMA1_RLC_CGCG_CTRL, CGCG_INT_ENABLE, 1);
+			WREG32_SOC15(GC, 0, regSDMA1_RLC_CGCG_CTRL, data);
+		}
 	} else {
 		/* Program RLC_CGCG_CGLS_CTRL */
 		def = data = RREG32_SOC15(GC, 0, regRLC_CGCG_CGLS_CTRL);
@@ -5121,9 +5124,12 @@ static void gfx_v11_0_update_coarse_grain_clock_gating(struct amdgpu_device *ade
 		data &= ~SDMA0_RLC_CGCG_CTRL__CGCG_INT_ENABLE_MASK;
 		WREG32_SOC15(GC, 0, regSDMA0_RLC_CGCG_CTRL, data);
 
-		data = RREG32_SOC15(GC, 0, regSDMA1_RLC_CGCG_CTRL);
-		data &= ~SDMA1_RLC_CGCG_CTRL__CGCG_INT_ENABLE_MASK;
-		WREG32_SOC15(GC, 0, regSDMA1_RLC_CGCG_CTRL, data);
+		/* Some ASICs only have one SDMA instance, not need to configure SDMA1 */
+		if (adev->sdma.num_instances > 1) {
+			data = RREG32_SOC15(GC, 0, regSDMA1_RLC_CGCG_CTRL);
+			data &= ~SDMA1_RLC_CGCG_CTRL__CGCG_INT_ENABLE_MASK;
+			WREG32_SOC15(GC, 0, regSDMA1_RLC_CGCG_CTRL, data);
+		}
 	}
 }
 
-- 
2.35.1

