Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43C645380DF
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240081AbiE3OKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238874AbiE3OEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:04:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F23CE5E1;
        Mon, 30 May 2022 06:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E39D6B80DB3;
        Mon, 30 May 2022 13:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A60C3411A;
        Mon, 30 May 2022 13:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918042;
        bh=oU8GNFgXSJWl0iMx94vn/omYjclzz4RaQjc+ksz0cus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2/eAVO/ZlmAmBZYrCrcUKQq+aq4OQSyBRQt7erktoAOfBfDvJm6oVpGD6WUbKEpj
         3Gv8hlBZru1jfkh/m2OFCkZOAB+YdHbZ2PQAxNpJfBn69Cvn58U7goss86/elJYv2K
         /SCIIWKkREnWfYZb0D6w2xZAjKFhOSr2okENsEMAMYyiMJtlMMXm/86LEODJnMVcM6
         ELEwUNW4d2Jui+KZYxASxVak+l0L0hAqIOsfs0eJbfQ+kZDtziI/HqtOmn/DJ0SIEN
         Ux0OF0XHl4d5b4CD0KYcAa7T2r6c6NrrVIsHzaLIKlvp8MJvH1PkZxsb6Uwm084i/R
         FZVh4J6itn7+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haohui Mai <ricetons@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, tao.zhou1@amd.com,
        YiPeng.Chai@amd.com, Hawking.Zhang@amd.com,
        rajib.mahapatra@amd.com, Jack.Xiao@amd.com, Lang.Yu@amd.com,
        Prike.Liang@amd.com, Bokun.Zhang@amd.com, rohit.khaire@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 040/109] drm/amdgpu/sdma: Fix incorrect calculations of the wptr of the doorbells
Date:   Mon, 30 May 2022 09:37:16 -0400
Message-Id: <20220530133825.1933431-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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

