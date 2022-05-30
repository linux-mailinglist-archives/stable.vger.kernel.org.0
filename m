Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB09537ECF
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236802AbiE3Nwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238619AbiE3Nua (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:50:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A43AEE26;
        Mon, 30 May 2022 06:35:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E465B80DAE;
        Mon, 30 May 2022 13:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154A2C3411A;
        Mon, 30 May 2022 13:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917699;
        bh=6Z3XCzEXjQtAZfG+nCO+8RY/1jNooV9Q2m+ygrcTIRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJhOZ+uPLV4KsZqx9yj7FpbA6Ll/Huv8RvLkU1yb3ua37gnFB+/Oq/i49w0jeXasa
         swcSgTCjnBBilty90ECKP0TEvOH+UQuBW0OmdUCkpOKxszlgU+mVP6Vlf2SNGHlzNC
         DWzE3quRlYIYDJnylxHp1Oc0aSxb4bV/eRWrZstn8UCV5/uI1hfgY+ScYuEzskX/kZ
         YifIPcshREpFebRVc/6ZeP9fkEghBtjqGK67Fmh5YBZosDBFUdS9wsJCap1ELH2+6A
         P6Kfg5Uk/qckSW0Sh95+7ltsViqYhx50JIPjcreXx/3GhuCZ8QgVh1bn3Tv2nyh2hE
         5Bed1PCExU4jw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        john.clements@amd.com, candice.li@amd.com, Likun.Gao@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 068/135] drm/amdgpu/psp: move PSP memory alloc from hw_init to sw_init
Date:   Mon, 30 May 2022 09:30:26 -0400
Message-Id: <20220530133133.1931716-68-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit b95b5391684b39695887afb4a13cccee7820f5d6 ]

Memory allocations should be done in sw_init.  hw_init should
just be hardware programming needed to initialize the IP block.
This is how most other IP blocks work.  Move the GPU memory
allocations from psp hw_init to psp sw_init and move the memory
free to sw_fini.  This also fixes a potential GPU memory leak
if psp hw_init fails.

Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c | 95 ++++++++++++-------------
 1 file changed, 47 insertions(+), 48 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
index dee17a0e1187..786518f7e37b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -331,7 +331,39 @@ static int psp_sw_init(void *handle)
 		}
 	}
 
+	ret = amdgpu_bo_create_kernel(adev, PSP_1_MEG, PSP_1_MEG,
+				      amdgpu_sriov_vf(adev) ?
+				      AMDGPU_GEM_DOMAIN_VRAM : AMDGPU_GEM_DOMAIN_GTT,
+				      &psp->fw_pri_bo,
+				      &psp->fw_pri_mc_addr,
+				      &psp->fw_pri_buf);
+	if (ret)
+		return ret;
+
+	ret = amdgpu_bo_create_kernel(adev, PSP_FENCE_BUFFER_SIZE, PAGE_SIZE,
+				      AMDGPU_GEM_DOMAIN_VRAM,
+				      &psp->fence_buf_bo,
+				      &psp->fence_buf_mc_addr,
+				      &psp->fence_buf);
+	if (ret)
+		goto failed1;
+
+	ret = amdgpu_bo_create_kernel(adev, PSP_CMD_BUFFER_SIZE, PAGE_SIZE,
+				      AMDGPU_GEM_DOMAIN_VRAM,
+				      &psp->cmd_buf_bo, &psp->cmd_buf_mc_addr,
+				      (void **)&psp->cmd_buf_mem);
+	if (ret)
+		goto failed2;
+
 	return 0;
+
+failed2:
+	amdgpu_bo_free_kernel(&psp->fw_pri_bo,
+			      &psp->fw_pri_mc_addr, &psp->fw_pri_buf);
+failed1:
+	amdgpu_bo_free_kernel(&psp->fence_buf_bo,
+			      &psp->fence_buf_mc_addr, &psp->fence_buf);
+	return ret;
 }
 
 static int psp_sw_fini(void *handle)
@@ -361,6 +393,13 @@ static int psp_sw_fini(void *handle)
 	kfree(cmd);
 	cmd = NULL;
 
+	amdgpu_bo_free_kernel(&psp->fw_pri_bo,
+			      &psp->fw_pri_mc_addr, &psp->fw_pri_buf);
+	amdgpu_bo_free_kernel(&psp->fence_buf_bo,
+			      &psp->fence_buf_mc_addr, &psp->fence_buf);
+	amdgpu_bo_free_kernel(&psp->cmd_buf_bo, &psp->cmd_buf_mc_addr,
+			      (void **)&psp->cmd_buf_mem);
+
 	return 0;
 }
 
@@ -2391,51 +2430,18 @@ static int psp_load_fw(struct amdgpu_device *adev)
 	struct psp_context *psp = &adev->psp;
 
 	if (amdgpu_sriov_vf(adev) && amdgpu_in_reset(adev)) {
-		psp_ring_stop(psp, PSP_RING_TYPE__KM); /* should not destroy ring, only stop */
-		goto skip_memalloc;
-	}
-
-	if (amdgpu_sriov_vf(adev)) {
-		ret = amdgpu_bo_create_kernel(adev, PSP_1_MEG, PSP_1_MEG,
-						AMDGPU_GEM_DOMAIN_VRAM,
-						&psp->fw_pri_bo,
-						&psp->fw_pri_mc_addr,
-						&psp->fw_pri_buf);
+		/* should not destroy ring, only stop */
+		psp_ring_stop(psp, PSP_RING_TYPE__KM);
 	} else {
-		ret = amdgpu_bo_create_kernel(adev, PSP_1_MEG, PSP_1_MEG,
-						AMDGPU_GEM_DOMAIN_GTT,
-						&psp->fw_pri_bo,
-						&psp->fw_pri_mc_addr,
-						&psp->fw_pri_buf);
-	}
-
-	if (ret)
-		goto failed;
-
-	ret = amdgpu_bo_create_kernel(adev, PSP_FENCE_BUFFER_SIZE, PAGE_SIZE,
-					AMDGPU_GEM_DOMAIN_VRAM,
-					&psp->fence_buf_bo,
-					&psp->fence_buf_mc_addr,
-					&psp->fence_buf);
-	if (ret)
-		goto failed;
-
-	ret = amdgpu_bo_create_kernel(adev, PSP_CMD_BUFFER_SIZE, PAGE_SIZE,
-				      AMDGPU_GEM_DOMAIN_VRAM,
-				      &psp->cmd_buf_bo, &psp->cmd_buf_mc_addr,
-				      (void **)&psp->cmd_buf_mem);
-	if (ret)
-		goto failed;
+		memset(psp->fence_buf, 0, PSP_FENCE_BUFFER_SIZE);
 
-	memset(psp->fence_buf, 0, PSP_FENCE_BUFFER_SIZE);
-
-	ret = psp_ring_init(psp, PSP_RING_TYPE__KM);
-	if (ret) {
-		DRM_ERROR("PSP ring init failed!\n");
-		goto failed;
+		ret = psp_ring_init(psp, PSP_RING_TYPE__KM);
+		if (ret) {
+			DRM_ERROR("PSP ring init failed!\n");
+			goto failed;
+		}
 	}
 
-skip_memalloc:
 	ret = psp_hw_start(psp);
 	if (ret)
 		goto failed;
@@ -2553,13 +2559,6 @@ static int psp_hw_fini(void *handle)
 	psp_tmr_terminate(psp);
 	psp_ring_destroy(psp, PSP_RING_TYPE__KM);
 
-	amdgpu_bo_free_kernel(&psp->fw_pri_bo,
-			      &psp->fw_pri_mc_addr, &psp->fw_pri_buf);
-	amdgpu_bo_free_kernel(&psp->fence_buf_bo,
-			      &psp->fence_buf_mc_addr, &psp->fence_buf);
-	amdgpu_bo_free_kernel(&psp->cmd_buf_bo, &psp->cmd_buf_mc_addr,
-			      (void **)&psp->cmd_buf_mem);
-
 	return 0;
 }
 
-- 
2.35.1

