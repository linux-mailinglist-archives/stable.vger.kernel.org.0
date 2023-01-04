Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D35165D566
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbjADOSh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234470AbjADOSg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:18:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F9717424
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:18:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C59661718
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B6EC433D2;
        Wed,  4 Jan 2023 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841914;
        bh=wW2t/vrJV3H0HfDabxPHaWcMSSLALzW7jWN47SI+wsc=;
        h=Subject:To:Cc:From:Date:From;
        b=CQr8fwsOEEWHQ6mqlzgStUQvnLP/htHqVxfyf+nClafNt9FDbHjUZt1QAzJZWUiDS
         U/a6LmOBZWfaJz8t55kGM5z7JffhIUr8C0I3vJbVHTfnH1n4Slr7abP9gzWNitvqUZ
         MprkP+SWBXzVx8B07kIg9vOZvaDwUld6tN/ZaJec=
Subject: FAILED: patch "[PATCH] drm/amdgpu/psp: don't free PSP buffers on suspend" failed to apply to 6.0-stable tree
To:     alexander.deucher@amd.com, christian.koenig@amd.com,
        gpiccoli@igalia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:18:23 +0100
Message-ID: <167284190364118@kroah.com>
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


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

96e1a88fafe6 ("drm/amdgpu/psp: don't free PSP buffers on suspend")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 96e1a88fafe6a9afd371fadc0c7de41b883aaec9 Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexander.deucher@amd.com>
Date: Wed, 16 Nov 2022 11:26:53 -0500
Subject: [PATCH] drm/amdgpu/psp: don't free PSP buffers on suspend
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We can reuse the same buffers on resume.

v2: squash in S4 fix from Shikai

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2213
Reviewed-by: Christian König <christian.koenig@amd.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index 98dbf4e5aae9..1a3aa0eae591 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -198,6 +198,7 @@ void psp_ta_free_shared_buf(struct ta_mem_context *mem_ctx)
 {
 	amdgpu_bo_free_kernel(&mem_ctx->shared_bo, &mem_ctx->shared_mc_addr,
 			      &mem_ctx->shared_buf);
+	mem_ctx->shared_bo = NULL;
 }
 
 static void psp_free_shared_bufs(struct psp_context *psp)
@@ -208,6 +209,7 @@ static void psp_free_shared_bufs(struct psp_context *psp)
 	/* free TMR memory buffer */
 	pptr = amdgpu_sriov_vf(psp->adev) ? &tmr_buf : NULL;
 	amdgpu_bo_free_kernel(&psp->tmr_bo, &psp->tmr_mc_addr, pptr);
+	psp->tmr_bo = NULL;
 
 	/* free xgmi shared memory */
 	psp_ta_free_shared_buf(&psp->xgmi_context.context.mem_context);
@@ -769,7 +771,7 @@ static int psp_load_toc(struct psp_context *psp,
 /* Set up Trusted Memory Region */
 static int psp_tmr_init(struct psp_context *psp)
 {
-	int ret;
+	int ret = 0;
 	int tmr_size;
 	void *tmr_buf;
 	void **pptr;
@@ -796,10 +798,12 @@ static int psp_tmr_init(struct psp_context *psp)
 		}
 	}
 
-	pptr = amdgpu_sriov_vf(psp->adev) ? &tmr_buf : NULL;
-	ret = amdgpu_bo_create_kernel(psp->adev, tmr_size, PSP_TMR_ALIGNMENT,
-				      AMDGPU_GEM_DOMAIN_VRAM,
-				      &psp->tmr_bo, &psp->tmr_mc_addr, pptr);
+	if (!psp->tmr_bo) {
+		pptr = amdgpu_sriov_vf(psp->adev) ? &tmr_buf : NULL;
+		ret = amdgpu_bo_create_kernel(psp->adev, tmr_size, PSP_TMR_ALIGNMENT,
+					      AMDGPU_GEM_DOMAIN_VRAM,
+					      &psp->tmr_bo, &psp->tmr_mc_addr, pptr);
+	}
 
 	return ret;
 }
@@ -2727,8 +2731,6 @@ static int psp_suspend(void *handle)
 	}
 
 out:
-	psp_free_shared_bufs(psp);
-
 	return ret;
 }
 

