Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CE864A181
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbiLLNlL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiLLNkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:40:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE5D13F59
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:40:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5AADDCE0F19
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:40:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2E51C433D2;
        Mon, 12 Dec 2022 13:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852401;
        bh=CxZRlOpPWk/FuOIos9ofLQSbKk3f/xsxSiATelOfaV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jcdmuWyrCwu63xbTn7fQJ3GDTCrgt+VY/bGiTpGLSEYxoobA6HMXSGjjJgURZrDcp
         gzMdrzxIABMpYgDSueYfNkhFsaRGf6wnYTSckts+wCwlNtnPxSphay9VPdkOdWqiXL
         +3u2noJc+h6DCZHcltl/yh9ovElCklmekvvjZVZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Prike Liang <Prike.Liang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.0 073/157] drm/amdgpu/sdma_v4_0: turn off SDMA ring buffer in the s2idle suspend
Date:   Mon, 12 Dec 2022 14:17:01 +0100
Message-Id: <20221212130937.602739717@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

commit bc21fe9a5844c5bc8f7ec319b11d2671a94eb867 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -980,13 +980,13 @@ static void sdma_v4_0_ring_emit_fence(st
 
 
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
 	struct amdgpu_ring *sdma[AMDGPU_MAX_SDMA_INSTANCES];
 	u32 rb_cntl, ib_cntl;
@@ -1001,10 +1001,10 @@ static void sdma_v4_0_gfx_stop(struct am
 		}
 
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
@@ -1131,7 +1131,7 @@ static void sdma_v4_0_enable(struct amdg
 	int i;
 
 	if (!enable) {
-		sdma_v4_0_gfx_stop(adev);
+		sdma_v4_0_gfx_enable(adev, enable);
 		sdma_v4_0_rlc_stop(adev);
 		if (adev->sdma.has_page_queue)
 			sdma_v4_0_page_stop(adev);
@@ -2043,8 +2043,10 @@ static int sdma_v4_0_suspend(void *handl
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* SMU saves SDMA state for us */
-	if (adev->in_s0ix)
+	if (adev->in_s0ix) {
+		sdma_v4_0_gfx_enable(adev, false);
 		return 0;
+	}
 
 	return sdma_v4_0_hw_fini(adev);
 }
@@ -2054,8 +2056,12 @@ static int sdma_v4_0_resume(void *handle
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


