Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B04537C6F
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbiE3Nb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237250AbiE3NaQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CAD87A3A;
        Mon, 30 May 2022 06:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62467B80AE8;
        Mon, 30 May 2022 13:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C78C385B8;
        Mon, 30 May 2022 13:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917217;
        bh=uGxBakii2rIG+iogD6UuanWdzvcp4zMwBqkxmY5yAyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m9BZltpesy5bDsFmY/Kc1/2xMZDDDGwNvn7ChI0HJJPV9IeQ0iK2gOZhjMv+Y5VrZ
         qfvERYTlGn38ibw9Kai16gR7tTNULRo+4nX7xsjSLOL3DuVO//tzADIAz6ryRs/pDD
         jJ7doSZPaj/R+hGKIegilFgVeXvBMCRVXka5BCxrjHIqrYA5QqTYDMAy+vSlHYNDRM
         ViC9D8xkSh+aSdIvIUV2TIH5+1tXR6CvymtMh8hq9pbaivgQOSEBq8BixwS+JdmB5D
         K29cME7Yym+VNxUL3N6DRCBuEHSb2B1BnsTZ4+1WGkaBqsAtJfv2YXrSYuwmlu8ATU
         HEV3EHNO8xRng==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haohui Mai <ricetons@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, YiPeng.Chai@amd.com,
        tao.zhou1@amd.com, Hawking.Zhang@amd.com, rajib.mahapatra@amd.com,
        Jack.Xiao@amd.com, Lang.Yu@amd.com, evan.quan@amd.com,
        Prike.Liang@amd.com, Bokun.Zhang@amd.com, rohit.khaire@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 059/159] drm/amdgpu/sdma: Fix incorrect calculations of the wptr of the doorbells
Date:   Mon, 30 May 2022 09:22:44 -0400
Message-Id: <20220530132425.1929512-59-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haohui Mai <ricetons@gmail.com>

[ Upstream commit 7dba6e838e741caadcf27ef717b6dcb561e77f89 ]

This patch fixes the issue where the driver miscomputes the 64-bit
values of the wptr of the SDMA doorbell when initializing the
hardware. SDMA engines v4 and later on have full 64-bit registers for
wptr thus they should be set properly.

Older generation hardwares like CIK / SI have only 16 / 20 / 24bits
for the WPTR, where the calls of lower_32_bits() will be removed in a
following patch.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Haohui Mai <ricetons@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c | 4 ++--
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c | 8 ++++----
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c | 8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index d7e8f7232364..ff86c43b63d1 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -772,8 +772,8 @@ static void sdma_v4_0_ring_set_wptr(struct amdgpu_ring *ring)
 
 		DRM_DEBUG("Using doorbell -- "
 				"wptr_offs == 0x%08x "
-				"lower_32_bits(ring->wptr) << 2 == 0x%08x "
-				"upper_32_bits(ring->wptr) << 2 == 0x%08x\n",
+				"lower_32_bits(ring->wptr << 2) == 0x%08x "
+				"upper_32_bits(ring->wptr << 2) == 0x%08x\n",
 				ring->wptr_offs,
 				lower_32_bits(ring->wptr << 2),
 				upper_32_bits(ring->wptr << 2));
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
index a8d49c005f73..627eb1f147c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -394,8 +394,8 @@ static void sdma_v5_0_ring_set_wptr(struct amdgpu_ring *ring)
 	if (ring->use_doorbell) {
 		DRM_DEBUG("Using doorbell -- "
 				"wptr_offs == 0x%08x "
-				"lower_32_bits(ring->wptr) << 2 == 0x%08x "
-				"upper_32_bits(ring->wptr) << 2 == 0x%08x\n",
+				"lower_32_bits(ring->wptr << 2) == 0x%08x "
+				"upper_32_bits(ring->wptr << 2) == 0x%08x\n",
 				ring->wptr_offs,
 				lower_32_bits(ring->wptr << 2),
 				upper_32_bits(ring->wptr << 2));
@@ -774,9 +774,9 @@ static int sdma_v5_0_gfx_resume(struct amdgpu_device *adev)
 
 		if (!amdgpu_sriov_vf(adev)) { /* only bare-metal use register write for wptr */
 			WREG32(sdma_v5_0_get_reg_offset(adev, i, mmSDMA0_GFX_RB_WPTR),
-			       lower_32_bits(ring->wptr) << 2);
+			       lower_32_bits(ring->wptr << 2));
 			WREG32(sdma_v5_0_get_reg_offset(adev, i, mmSDMA0_GFX_RB_WPTR_HI),
-			       upper_32_bits(ring->wptr) << 2);
+			       upper_32_bits(ring->wptr << 2));
 		}
 
 		doorbell = RREG32_SOC15_IP(GC, sdma_v5_0_get_reg_offset(adev, i, mmSDMA0_GFX_DOORBELL));
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
index 824eace69884..a5eb82bfeaa8 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -295,8 +295,8 @@ static void sdma_v5_2_ring_set_wptr(struct amdgpu_ring *ring)
 	if (ring->use_doorbell) {
 		DRM_DEBUG("Using doorbell -- "
 				"wptr_offs == 0x%08x "
-				"lower_32_bits(ring->wptr) << 2 == 0x%08x "
-				"upper_32_bits(ring->wptr) << 2 == 0x%08x\n",
+				"lower_32_bits(ring->wptr << 2) == 0x%08x "
+				"upper_32_bits(ring->wptr << 2) == 0x%08x\n",
 				ring->wptr_offs,
 				lower_32_bits(ring->wptr << 2),
 				upper_32_bits(ring->wptr << 2));
@@ -672,8 +672,8 @@ static int sdma_v5_2_gfx_resume(struct amdgpu_device *adev)
 		WREG32_SOC15_IP(GC, sdma_v5_2_get_reg_offset(adev, i, mmSDMA0_GFX_MINOR_PTR_UPDATE), 1);
 
 		if (!amdgpu_sriov_vf(adev)) { /* only bare-metal use register write for wptr */
-			WREG32(sdma_v5_2_get_reg_offset(adev, i, mmSDMA0_GFX_RB_WPTR), lower_32_bits(ring->wptr) << 2);
-			WREG32(sdma_v5_2_get_reg_offset(adev, i, mmSDMA0_GFX_RB_WPTR_HI), upper_32_bits(ring->wptr) << 2);
+			WREG32(sdma_v5_2_get_reg_offset(adev, i, mmSDMA0_GFX_RB_WPTR), lower_32_bits(ring->wptr << 2));
+			WREG32(sdma_v5_2_get_reg_offset(adev, i, mmSDMA0_GFX_RB_WPTR_HI), upper_32_bits(ring->wptr << 2));
 		}
 
 		doorbell = RREG32_SOC15_IP(GC, sdma_v5_2_get_reg_offset(adev, i, mmSDMA0_GFX_DOORBELL));
-- 
2.35.1

