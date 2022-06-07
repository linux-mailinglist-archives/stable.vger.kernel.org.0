Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E497054094B
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349550AbiFGSHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350791AbiFGSBZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:01:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B607114CA08;
        Tue,  7 Jun 2022 10:43:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C64B6146F;
        Tue,  7 Jun 2022 17:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E415C34115;
        Tue,  7 Jun 2022 17:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623799;
        bh=ncQfeGgnY0UBuqSIYCk3dqzB61DjWK0qKxJ9nLxTJKI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yoep+6P5VqOOK9/QTOmKyjHXuauvSHso3n7VmVjZ8+DXb3MTUTiBl1gFMwuJlvYKM
         pNJTK56Uq2BYN64Q3c1PcDkjdXiC9nlg8yT2cDqHoQ0B8D52zC9GdUR868GDSMRSiC
         JRZc3JObfkl1tDMYUUkPBvmqixiTHUnQ71rranOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/667] drm/amdgpu/psp: move PSP memory alloc from hw_init to sw_init
Date:   Tue,  7 Jun 2022 18:56:02 +0200
Message-Id: <20220607164937.730982751@linuxfoundation.org>
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
index 86e2090bbd6e..57e9932d8a04 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_psp.c
@@ -314,7 +314,39 @@ static int psp_sw_init(void *handle)
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
@@ -344,6 +376,13 @@ static int psp_sw_fini(void *handle)
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
 
@@ -2580,51 +2619,18 @@ static int psp_load_fw(struct amdgpu_device *adev)
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
@@ -2730,13 +2736,6 @@ static int psp_hw_fini(void *handle)
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



