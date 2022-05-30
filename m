Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05CB4537D91
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237414AbiE3Ngo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237461AbiE3NfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:35:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A456592D36;
        Mon, 30 May 2022 06:28:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9CAD060EDF;
        Mon, 30 May 2022 13:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C628C385B8;
        Mon, 30 May 2022 13:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917284;
        bh=yZVqEBLc3U5iliDZjfXNJejculO0HrUD/c4t8ogteQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lOD89Zsf6fZXIEHXmImKRNmEvYnVjo3pcpSPsvRLFr0hpJnzYg/1ZpAlEpmbh7E6D
         I7ISWXVIAXaLwJj2OdQmZ+R0O2dhs8cH8aET5e99BVm3juyixw5MXuW8birmKdBHIY
         liHwASTXJtl2nr8Pn3b83iBrdgWhHbpA6PBpK7R3epEuDs5ZjMTJelgInFehkcZy5T
         VCnZjCU3BW7eAZttAI4mAldjapZ8IZqwMgoPybaIPuccRNoJtuLKOcQaaaIrrVXMTB
         q6EiwEpbCxuahW47Vn5khWzZSP8rAuusXAZhTmYs2rn0BdE9Sd9GOk0wK60Pbls9FA
         qdzERa2vxQIdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        john.clements@amd.com, candice.li@amd.com, Likun.Gao@amd.com,
        Lang.Yu@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.18 082/159] drm/amdgpu/psp: move PSP memory alloc from hw_init to sw_init
Date:   Mon, 30 May 2022 09:23:07 -0400
Message-Id: <20220530132425.1929512-82-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
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
index a6acec1a6155..21aa556a6bef 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -357,7 +357,39 @@ static int psp_sw_init(void *handle)
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
@@ -391,6 +423,13 @@ static int psp_sw_fini(void *handle)
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
 
@@ -2430,51 +2469,18 @@ static int psp_load_fw(struct amdgpu_device *adev)
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
@@ -2592,13 +2598,6 @@ static int psp_hw_fini(void *handle)
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

