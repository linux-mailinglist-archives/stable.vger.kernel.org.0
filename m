Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3666026EB0A
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgIRCCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgIRCCe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:02:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 580AD208DB;
        Fri, 18 Sep 2020 02:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394553;
        bh=xwGeazSpi1ZDfxGvFOWivR66MmVOUgjZdfhRepIv7cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sWY/CqGH0914EBPr/pvJeM1f71kW8A8pE2BeMWQAhdDb+FajyloanAQs1S+22g0wE
         Mq6X0EqaI0cgoH4tdCxYzhK4g+SaV857pOPJ4Ol5/8cYaHhHl655Jhs52iXBY88dHd
         +hsND3in9VY4Lfx+eC35qfG2gM0PcwjFzjj6iCRs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Monk Liu <Monk.Liu@amd.com>, Hawking Zhang <Hawking.Zhang@amd.com>,
        Xiaojie Yuan <xiaojie.yuan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 069/330] drm/amdgpu: fix calltrace during kmd unload(v3)
Date:   Thu, 17 Sep 2020 21:56:49 -0400
Message-Id: <20200918020110.2063155-69-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Monk Liu <Monk.Liu@amd.com>

[ Upstream commit 82a829dc8c2bb03cc9b7e5beb1c5479aa3ba7831 ]

issue:
kernel would report a warning from a double unpin
during the driver unloading on the CSB bo

why:
we unpin it during hw_fini, and there will be another
unpin in sw_fini on CSB bo.

fix:
actually we don't need to pin/unpin it during
hw_init/fini since it is created with kernel pinned,
we only need to fullfill the CSB again during hw_init
to prevent CSB/VRAM lost after S3

v2:
get_csb in init_rlc so hw_init() will make CSIB content
back even after reset or s3

v3:
use bo_create_kernel instead of bo_create_reserved for CSB
otherwise the bo_free_kernel() on CSB is not aligned and
would lead to its internal reserve pending there forever

take care of gfx7/8 as well

Signed-off-by: Monk Liu <Monk.Liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Xiaojie Yuan <xiaojie.yuan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.c | 10 +----
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c  | 58 +------------------------
 drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c   |  2 +
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c   | 40 +----------------
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c   | 40 +----------------
 5 files changed, 6 insertions(+), 144 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.c
index c8793e6cc3c5d..6373bfb47d55d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_rlc.c
@@ -124,13 +124,12 @@ int amdgpu_gfx_rlc_init_sr(struct amdgpu_device *adev, u32 dws)
  */
 int amdgpu_gfx_rlc_init_csb(struct amdgpu_device *adev)
 {
-	volatile u32 *dst_ptr;
 	u32 dws;
 	int r;
 
 	/* allocate clear state block */
 	adev->gfx.rlc.clear_state_size = dws = adev->gfx.rlc.funcs->get_csb_size(adev);
-	r = amdgpu_bo_create_reserved(adev, dws * 4, PAGE_SIZE,
+	r = amdgpu_bo_create_kernel(adev, dws * 4, PAGE_SIZE,
 				      AMDGPU_GEM_DOMAIN_VRAM,
 				      &adev->gfx.rlc.clear_state_obj,
 				      &adev->gfx.rlc.clear_state_gpu_addr,
@@ -141,13 +140,6 @@ int amdgpu_gfx_rlc_init_csb(struct amdgpu_device *adev)
 		return r;
 	}
 
-	/* set up the cs buffer */
-	dst_ptr = adev->gfx.rlc.cs_ptr;
-	adev->gfx.rlc.funcs->get_csb_buffer(adev, dst_ptr);
-	amdgpu_bo_kunmap(adev->gfx.rlc.clear_state_obj);
-	amdgpu_bo_unpin(adev->gfx.rlc.clear_state_obj);
-	amdgpu_bo_unreserve(adev->gfx.rlc.clear_state_obj);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 19876c90be0e1..d17edc850427a 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -993,39 +993,6 @@ static int gfx_v10_0_rlc_init(struct amdgpu_device *adev)
 	return 0;
 }
 
-static int gfx_v10_0_csb_vram_pin(struct amdgpu_device *adev)
-{
-	int r;
-
-	r = amdgpu_bo_reserve(adev->gfx.rlc.clear_state_obj, false);
-	if (unlikely(r != 0))
-		return r;
-
-	r = amdgpu_bo_pin(adev->gfx.rlc.clear_state_obj,
-			AMDGPU_GEM_DOMAIN_VRAM);
-	if (!r)
-		adev->gfx.rlc.clear_state_gpu_addr =
-			amdgpu_bo_gpu_offset(adev->gfx.rlc.clear_state_obj);
-
-	amdgpu_bo_unreserve(adev->gfx.rlc.clear_state_obj);
-
-	return r;
-}
-
-static void gfx_v10_0_csb_vram_unpin(struct amdgpu_device *adev)
-{
-	int r;
-
-	if (!adev->gfx.rlc.clear_state_obj)
-		return;
-
-	r = amdgpu_bo_reserve(adev->gfx.rlc.clear_state_obj, true);
-	if (likely(r == 0)) {
-		amdgpu_bo_unpin(adev->gfx.rlc.clear_state_obj);
-		amdgpu_bo_unreserve(adev->gfx.rlc.clear_state_obj);
-	}
-}
-
 static void gfx_v10_0_mec_fini(struct amdgpu_device *adev)
 {
 	amdgpu_bo_free_kernel(&adev->gfx.mec.hpd_eop_obj, NULL, NULL);
@@ -1787,25 +1754,7 @@ static void gfx_v10_0_enable_gui_idle_interrupt(struct amdgpu_device *adev,
 
 static int gfx_v10_0_init_csb(struct amdgpu_device *adev)
 {
-	int r;
-
-	if (adev->in_gpu_reset) {
-		r = amdgpu_bo_reserve(adev->gfx.rlc.clear_state_obj, false);
-		if (r)
-			return r;
-
-		r = amdgpu_bo_kmap(adev->gfx.rlc.clear_state_obj,
-				   (void **)&adev->gfx.rlc.cs_ptr);
-		if (!r) {
-			adev->gfx.rlc.funcs->get_csb_buffer(adev,
-					adev->gfx.rlc.cs_ptr);
-			amdgpu_bo_kunmap(adev->gfx.rlc.clear_state_obj);
-		}
-
-		amdgpu_bo_unreserve(adev->gfx.rlc.clear_state_obj);
-		if (r)
-			return r;
-	}
+	adev->gfx.rlc.funcs->get_csb_buffer(adev, adev->gfx.rlc.cs_ptr);
 
 	/* csib */
 	WREG32_SOC15(GC, 0, mmRLC_CSIB_ADDR_HI,
@@ -3774,10 +3723,6 @@ static int gfx_v10_0_hw_init(void *handle)
 	int r;
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
-	r = gfx_v10_0_csb_vram_pin(adev);
-	if (r)
-		return r;
-
 	if (!amdgpu_emu_mode)
 		gfx_v10_0_init_golden_registers(adev);
 
@@ -3865,7 +3810,6 @@ static int gfx_v10_0_hw_fini(void *handle)
 	}
 	gfx_v10_0_cp_enable(adev, false);
 	gfx_v10_0_enable_gui_idle_interrupt(adev, false);
-	gfx_v10_0_csb_vram_unpin(adev);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
index 791ba398f007e..d92e92e5d50b7 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v7_0.c
@@ -4554,6 +4554,8 @@ static int gfx_v7_0_hw_init(void *handle)
 
 	gfx_v7_0_constants_init(adev);
 
+	/* init CSB */
+	adev->gfx.rlc.funcs->get_csb_buffer(adev, adev->gfx.rlc.cs_ptr);
 	/* init rlc */
 	r = adev->gfx.rlc.funcs->resume(adev);
 	if (r)
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index cc88ba76a8d4a..467ed7fca884d 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -1321,39 +1321,6 @@ static int gfx_v8_0_rlc_init(struct amdgpu_device *adev)
 	return 0;
 }
 
-static int gfx_v8_0_csb_vram_pin(struct amdgpu_device *adev)
-{
-	int r;
-
-	r = amdgpu_bo_reserve(adev->gfx.rlc.clear_state_obj, false);
-	if (unlikely(r != 0))
-		return r;
-
-	r = amdgpu_bo_pin(adev->gfx.rlc.clear_state_obj,
-			AMDGPU_GEM_DOMAIN_VRAM);
-	if (!r)
-		adev->gfx.rlc.clear_state_gpu_addr =
-			amdgpu_bo_gpu_offset(adev->gfx.rlc.clear_state_obj);
-
-	amdgpu_bo_unreserve(adev->gfx.rlc.clear_state_obj);
-
-	return r;
-}
-
-static void gfx_v8_0_csb_vram_unpin(struct amdgpu_device *adev)
-{
-	int r;
-
-	if (!adev->gfx.rlc.clear_state_obj)
-		return;
-
-	r = amdgpu_bo_reserve(adev->gfx.rlc.clear_state_obj, true);
-	if (likely(r == 0)) {
-		amdgpu_bo_unpin(adev->gfx.rlc.clear_state_obj);
-		amdgpu_bo_unreserve(adev->gfx.rlc.clear_state_obj);
-	}
-}
-
 static void gfx_v8_0_mec_fini(struct amdgpu_device *adev)
 {
 	amdgpu_bo_free_kernel(&adev->gfx.mec.hpd_eop_obj, NULL, NULL);
@@ -3917,6 +3884,7 @@ static void gfx_v8_0_enable_gui_idle_interrupt(struct amdgpu_device *adev,
 
 static void gfx_v8_0_init_csb(struct amdgpu_device *adev)
 {
+	adev->gfx.rlc.funcs->get_csb_buffer(adev, adev->gfx.rlc.cs_ptr);
 	/* csib */
 	WREG32(mmRLC_CSIB_ADDR_HI,
 			adev->gfx.rlc.clear_state_gpu_addr >> 32);
@@ -4837,10 +4805,6 @@ static int gfx_v8_0_hw_init(void *handle)
 	gfx_v8_0_init_golden_registers(adev);
 	gfx_v8_0_constants_init(adev);
 
-	r = gfx_v8_0_csb_vram_pin(adev);
-	if (r)
-		return r;
-
 	r = adev->gfx.rlc.funcs->resume(adev);
 	if (r)
 		return r;
@@ -4958,8 +4922,6 @@ static int gfx_v8_0_hw_fini(void *handle)
 		pr_err("rlc is busy, skip halt rlc\n");
 	amdgpu_gfx_rlc_exit_safe_mode(adev);
 
-	gfx_v8_0_csb_vram_unpin(adev);
-
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 6004fdacc8663..90dcc7afc9c43 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1675,39 +1675,6 @@ static int gfx_v9_0_rlc_init(struct amdgpu_device *adev)
 	return 0;
 }
 
-static int gfx_v9_0_csb_vram_pin(struct amdgpu_device *adev)
-{
-	int r;
-
-	r = amdgpu_bo_reserve(adev->gfx.rlc.clear_state_obj, false);
-	if (unlikely(r != 0))
-		return r;
-
-	r = amdgpu_bo_pin(adev->gfx.rlc.clear_state_obj,
-			AMDGPU_GEM_DOMAIN_VRAM);
-	if (!r)
-		adev->gfx.rlc.clear_state_gpu_addr =
-			amdgpu_bo_gpu_offset(adev->gfx.rlc.clear_state_obj);
-
-	amdgpu_bo_unreserve(adev->gfx.rlc.clear_state_obj);
-
-	return r;
-}
-
-static void gfx_v9_0_csb_vram_unpin(struct amdgpu_device *adev)
-{
-	int r;
-
-	if (!adev->gfx.rlc.clear_state_obj)
-		return;
-
-	r = amdgpu_bo_reserve(adev->gfx.rlc.clear_state_obj, true);
-	if (likely(r == 0)) {
-		amdgpu_bo_unpin(adev->gfx.rlc.clear_state_obj);
-		amdgpu_bo_unreserve(adev->gfx.rlc.clear_state_obj);
-	}
-}
-
 static void gfx_v9_0_mec_fini(struct amdgpu_device *adev)
 {
 	amdgpu_bo_free_kernel(&adev->gfx.mec.hpd_eop_obj, NULL, NULL);
@@ -2596,6 +2563,7 @@ static void gfx_v9_0_enable_gui_idle_interrupt(struct amdgpu_device *adev,
 
 static void gfx_v9_0_init_csb(struct amdgpu_device *adev)
 {
+	adev->gfx.rlc.funcs->get_csb_buffer(adev, adev->gfx.rlc.cs_ptr);
 	/* csib */
 	WREG32_RLC(SOC15_REG_OFFSET(GC, 0, mmRLC_CSIB_ADDR_HI),
 			adev->gfx.rlc.clear_state_gpu_addr >> 32);
@@ -3888,10 +3856,6 @@ static int gfx_v9_0_hw_init(void *handle)
 
 	gfx_v9_0_constants_init(adev);
 
-	r = gfx_v9_0_csb_vram_pin(adev);
-	if (r)
-		return r;
-
 	r = adev->gfx.rlc.funcs->resume(adev);
 	if (r)
 		return r;
@@ -3977,8 +3941,6 @@ static int gfx_v9_0_hw_fini(void *handle)
 	gfx_v9_0_cp_enable(adev, false);
 	adev->gfx.rlc.funcs->stop(adev);
 
-	gfx_v9_0_csb_vram_unpin(adev);
-
 	return 0;
 }
 
-- 
2.25.1

