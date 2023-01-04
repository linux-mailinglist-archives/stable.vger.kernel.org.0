Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD6A65D562
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:18:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjADOSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235012AbjADOSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:18:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E227C17424
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:18:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CE746172D
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB52C433EF;
        Wed,  4 Jan 2023 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841884;
        bh=1tvsN8sN+RkachWYBMLM0bw/9tIB6Zln876vg6KPMPA=;
        h=Subject:To:Cc:From:Date:From;
        b=otvLV5zLHaJ6XfLjkUF2wAvb1FeGwYzIs7MqjTpKtwQ3prLZjtXPg+Nw4EqQaqG4f
         2+AUxUUWqTToErDK9XD7O8myaV2jwtaoXULSC5q93DU1VtwIGynFH8VlVZiCNo+Lwk
         lI6wbM8N0wnESxQ54ZlJXfpbpJeusgRgNsPDRWEA=
Subject: FAILED: patch "[PATCH] drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the s2idle" failed to apply to 6.1-stable tree
To:     Prike.Liang@amd.com, alexander.deucher@amd.com,
        mario.limonciello@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:18:01 +0100
Message-ID: <1672841881235131@kroah.com>
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

b35a2a12901c ("drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the s2idle suspend")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b35a2a12901cd230309750777e3744fa0526543d Mon Sep 17 00:00:00 2001
From: Prike Liang <Prike.Liang@amd.com>
Date: Thu, 1 Dec 2022 11:17:31 +0800
Subject: [PATCH] drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the s2idle
 suspend

In the SDMA s0ix save process requires to turn off SDMA ring buffer for
avoiding the SDMA in-flight request, otherwise will suffer from SDMA page
fault which causes by page request from in-flight SDMA ring accessing at
SDMA restore phase.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2248
Cc: stable@vger.kernel.org # 6.0,5.15+
Fixes: f8f4e2a51834 ("drm/amdgpu: skipping SDMA hw_init and hw_fini for S0ix.")
Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 1122bd4eae98..4d780e4430e7 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -907,13 +907,13 @@ static void sdma_v4_0_ring_emit_fence(struct amdgpu_ring *ring, u64 addr, u64 se
 
 
 /**
- * sdma_v4_0_gfx_stop - stop the gfx async dma engines
+ * sdma_v4_0_gfx_enable - enable the gfx async dma engines
  *
  * @adev: amdgpu_device pointer
- *
- * Stop the gfx async dma ring buffers (VEGA10).
+ * @enable: enable SDMA RB/IB
+ * control the gfx async dma ring buffers (VEGA10).
  */
-static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
+static void sdma_v4_0_gfx_enable(struct amdgpu_device *adev, bool enable)
 {
 	u32 rb_cntl, ib_cntl;
 	int i;
@@ -922,10 +922,10 @@ static void sdma_v4_0_gfx_stop(struct amdgpu_device *adev)
 
 	for (i = 0; i < adev->sdma.num_instances; i++) {
 		rb_cntl = RREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL);
-		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, 0);
+		rb_cntl = REG_SET_FIELD(rb_cntl, SDMA0_GFX_RB_CNTL, RB_ENABLE, enable ? 1 : 0);
 		WREG32_SDMA(i, mmSDMA0_GFX_RB_CNTL, rb_cntl);
 		ib_cntl = RREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL);
-		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, 0);
+		ib_cntl = REG_SET_FIELD(ib_cntl, SDMA0_GFX_IB_CNTL, IB_ENABLE, enable ? 1 : 0);
 		WREG32_SDMA(i, mmSDMA0_GFX_IB_CNTL, ib_cntl);
 	}
 }
@@ -1044,7 +1044,7 @@ static void sdma_v4_0_enable(struct amdgpu_device *adev, bool enable)
 	int i;
 
 	if (!enable) {
-		sdma_v4_0_gfx_stop(adev);
+		sdma_v4_0_gfx_enable(adev, enable);
 		sdma_v4_0_rlc_stop(adev);
 		if (adev->sdma.has_page_queue)
 			sdma_v4_0_page_stop(adev);
@@ -1960,8 +1960,10 @@ static int sdma_v4_0_suspend(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* SMU saves SDMA state for us */
-	if (adev->in_s0ix)
+	if (adev->in_s0ix) {
+		sdma_v4_0_gfx_enable(adev, false);
 		return 0;
+	}
 
 	return sdma_v4_0_hw_fini(adev);
 }
@@ -1971,8 +1973,12 @@ static int sdma_v4_0_resume(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* SMU restores SDMA state for us */
-	if (adev->in_s0ix)
+	if (adev->in_s0ix) {
+		sdma_v4_0_enable(adev, true);
+		sdma_v4_0_gfx_enable(adev, true);
+		amdgpu_ttm_set_buffer_funcs_status(adev, true);
 		return 0;
+	}
 
 	return sdma_v4_0_hw_init(adev);
 }

