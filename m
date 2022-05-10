Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77EA45219C7
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244733AbiEJNvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244914AbiEJNrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA7A20132F;
        Tue, 10 May 2022 06:32:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAD55B81D24;
        Tue, 10 May 2022 13:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B89C385A6;
        Tue, 10 May 2022 13:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189557;
        bh=nsYj24W1bTk5Ofb8/SeUcbT+QYBRqpKP3d3ebJkFHl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0lNAii9YAqqD9tbZdm/wKI4C2tn4z1g6cqblk/XV8O/NXjZ8SV0+AxBEKzVKstar
         pP9qmKVbjDovqCnd8HFNiuGS/YCrT5T3VpKBx3qvEkgXTAMiaYwCPzfLp55tjVPIni
         bdaw5JxEBkG0UahDdF1f0gUABPX/9ySYdoK3p+hI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 082/135] drm/amdgpu: unify BO evicting method in amdgpu_ttm
Date:   Tue, 10 May 2022 15:07:44 +0200
Message-Id: <20220510130742.763825220@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@amd.com>

commit 58144d283712c9e80e528e001af6ac5aeee71af2 upstream.

Unify BO evicting functionality for possible memory
types in amdgpu_ttm.c.

Signed-off-by: Nirmoy Das <nirmoy.das@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    8 ++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c  |   30 ++++++++++++++++++++++------
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c  |   23 ---------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h  |    1 
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c     |   30 ++++++++++++++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h     |    1 
 6 files changed, 58 insertions(+), 35 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1176,7 +1176,7 @@ static int amdgpu_debugfs_evict_vram(voi
 		return r;
 	}
 
-	*val = amdgpu_bo_evict_vram(adev);
+	*val = amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM);
 
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
@@ -1189,17 +1189,15 @@ static int amdgpu_debugfs_evict_gtt(void
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)data;
 	struct drm_device *dev = adev_to_drm(adev);
-	struct ttm_resource_manager *man;
 	int r;
 
 	r = pm_runtime_get_sync(dev->dev);
 	if (r < 0) {
-		pm_runtime_put_autosuspend(adev_to_drm(adev)->dev);
+		pm_runtime_put_autosuspend(dev->dev);
 		return r;
 	}
 
-	man = ttm_manager_type(&adev->mman.bdev, TTM_PL_TT);
-	*val = ttm_resource_manager_evict_all(&adev->mman.bdev, man);
+	*val = amdgpu_ttm_evict_resources(adev, TTM_PL_TT);
 
 	pm_runtime_mark_last_busy(dev->dev);
 	pm_runtime_put_autosuspend(dev->dev);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3928,6 +3928,25 @@ void amdgpu_device_fini_sw(struct amdgpu
 
 }
 
+/**
+ * amdgpu_device_evict_resources - evict device resources
+ * @adev: amdgpu device object
+ *
+ * Evicts all ttm device resources(vram BOs, gart table) from the lru list
+ * of the vram memory type. Mainly used for evicting device resources
+ * at suspend time.
+ *
+ */
+static void amdgpu_device_evict_resources(struct amdgpu_device *adev)
+{
+	/* No need to evict vram on APUs for suspend to ram */
+	if (adev->in_s3 && (adev->flags & AMD_IS_APU))
+		return;
+
+	if (amdgpu_ttm_evict_resources(adev, TTM_PL_VRAM))
+		DRM_WARN("evicting device resources failed\n");
+
+}
 
 /*
  * Suspend & resume.
@@ -3968,17 +3987,16 @@ int amdgpu_device_suspend(struct drm_dev
 	if (!adev->in_s0ix)
 		amdgpu_amdkfd_suspend(adev, adev->in_runpm);
 
-	/* evict vram memory */
-	amdgpu_bo_evict_vram(adev);
+	/* First evict vram memory */
+	amdgpu_device_evict_resources(adev);
 
 	amdgpu_fence_driver_hw_fini(adev);
 
 	amdgpu_device_ip_suspend_phase2(adev);
-	/* evict remaining vram memory
-	 * This second call to evict vram is to evict the gart page table
-	 * using the CPU.
+	/* This second call to evict device resources is to evict
+	 * the gart page table using the CPU.
 	 */
-	amdgpu_bo_evict_vram(adev);
+	amdgpu_device_evict_resources(adev);
 
 	return 0;
 }
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1038,29 +1038,6 @@ void amdgpu_bo_unpin(struct amdgpu_bo *b
 	}
 }
 
-/**
- * amdgpu_bo_evict_vram - evict VRAM buffers
- * @adev: amdgpu device object
- *
- * Evicts all VRAM buffers on the lru list of the memory type.
- * Mainly used for evicting vram at suspend time.
- *
- * Returns:
- * 0 for success or a negative error code on failure.
- */
-int amdgpu_bo_evict_vram(struct amdgpu_device *adev)
-{
-	struct ttm_resource_manager *man;
-
-	if (adev->in_s3 && (adev->flags & AMD_IS_APU)) {
-		/* No need to evict vram on APUs for suspend to ram */
-		return 0;
-	}
-
-	man = ttm_manager_type(&adev->mman.bdev, TTM_PL_VRAM);
-	return ttm_resource_manager_evict_all(&adev->mman.bdev, man);
-}
-
 static const char *amdgpu_vram_names[] = {
 	"UNKNOWN",
 	"GDDR1",
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
@@ -304,7 +304,6 @@ int amdgpu_bo_pin(struct amdgpu_bo *bo,
 int amdgpu_bo_pin_restricted(struct amdgpu_bo *bo, u32 domain,
 			     u64 min_offset, u64 max_offset);
 void amdgpu_bo_unpin(struct amdgpu_bo *bo);
-int amdgpu_bo_evict_vram(struct amdgpu_device *adev);
 int amdgpu_bo_init(struct amdgpu_device *adev);
 void amdgpu_bo_fini(struct amdgpu_device *adev);
 int amdgpu_bo_set_tiling_flags(struct amdgpu_bo *bo, u64 tiling_flags);
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -2036,6 +2036,36 @@ error_free:
 	return r;
 }
 
+/**
+ * amdgpu_ttm_evict_resources - evict memory buffers
+ * @adev: amdgpu device object
+ * @mem_type: evicted BO's memory type
+ *
+ * Evicts all @mem_type buffers on the lru list of the memory type.
+ *
+ * Returns:
+ * 0 for success or a negative error code on failure.
+ */
+int amdgpu_ttm_evict_resources(struct amdgpu_device *adev, int mem_type)
+{
+	struct ttm_resource_manager *man;
+
+	switch (mem_type) {
+	case TTM_PL_VRAM:
+	case TTM_PL_TT:
+	case AMDGPU_PL_GWS:
+	case AMDGPU_PL_GDS:
+	case AMDGPU_PL_OA:
+		man = ttm_manager_type(&adev->mman.bdev, mem_type);
+		break;
+	default:
+		DRM_ERROR("Trying to evict invalid memory type\n");
+		return -EINVAL;
+	}
+
+	return ttm_resource_manager_evict_all(&adev->mman.bdev, man);
+}
+
 #if defined(CONFIG_DEBUG_FS)
 
 static int amdgpu_mm_vram_table_show(struct seq_file *m, void *unused)
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.h
@@ -190,6 +190,7 @@ bool amdgpu_ttm_tt_is_readonly(struct tt
 uint64_t amdgpu_ttm_tt_pde_flags(struct ttm_tt *ttm, struct ttm_resource *mem);
 uint64_t amdgpu_ttm_tt_pte_flags(struct amdgpu_device *adev, struct ttm_tt *ttm,
 				 struct ttm_resource *mem);
+int amdgpu_ttm_evict_resources(struct amdgpu_device *adev, int mem_type);
 
 void amdgpu_ttm_debugfs_init(struct amdgpu_device *adev);
 


