Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5865354095B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349706AbiFGSHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350151AbiFGSAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:00:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F55A2DD6B;
        Tue,  7 Jun 2022 10:42:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBA56615B4;
        Tue,  7 Jun 2022 17:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E196DC385A5;
        Tue,  7 Jun 2022 17:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623764;
        bh=oU8GNFgXSJWl0iMx94vn/omYjclzz4RaQjc+ksz0cus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0NVgXo2G4n80zsyYZ4kbvPy2MIEX2ftL8KIgQ2sviCuk7B1HLO5ZJodpkxz0w8kgz
         g+PlgCiz/hEdlh3lcCQ+23InRFSz4ulTVz7ZPXJ9QDt04LrvCl2b/Frccofbw1Yyml
         CmJJrbLqcflIt3q5/fPKfvCRhHUizb/uTOx4HBMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Haohui Mai <ricetons@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/667] drm/amdgpu/sdma: Fix incorrect calculations of the wptr of the doorbells
Date:   Tue,  7 Jun 2022 18:55:46 +0200
Message-Id: <20220607164937.251774912@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index e37948c15769..9014f71d52dd 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -770,8 +770,8 @@ static void sdma_v4_0_ring_set_wptr(struct amdgpu_ring *ring)
 
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
index 50bf3b71bc93..0f75864365d6 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -400,8 +400,8 @@ static void sdma_v5_0_ring_set_wptr(struct amdgpu_ring *ring)
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
@@ -782,9 +782,9 @@ static int sdma_v5_0_gfx_resume(struct amdgpu_device *adev)
 
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
index e32efcfb0c8b..f643b977b5f4 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -287,8 +287,8 @@ static void sdma_v5_2_ring_set_wptr(struct amdgpu_ring *ring)
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
@@ -660,8 +660,8 @@ static int sdma_v5_2_gfx_resume(struct amdgpu_device *adev)
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



