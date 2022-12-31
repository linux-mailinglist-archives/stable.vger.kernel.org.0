Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68A4765A696
	for <lists+stable@lfdr.de>; Sat, 31 Dec 2022 21:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbiLaUFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Dec 2022 15:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbiLaUFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Dec 2022 15:05:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D71E7667;
        Sat, 31 Dec 2022 12:05:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30223B80915;
        Sat, 31 Dec 2022 20:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675A6C433D2;
        Sat, 31 Dec 2022 20:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672517101;
        bh=OqxE89YORzskro0l0o+XkZkf9CnCLfMdkMxsA/QsFo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nen7VuXbvszKA+NQsV3qC+MyqW2c1Hr3D8EqnoPlXRyuq0S9HVjacuZw2rLKHqnlJ
         8YSwE/R6RC8k4kUFm2MkWQrGaIFoopm858YwWyT/DlQ19ndYTs9G+yVcWygKh6HI+F
         9zrCn2aj460hGGRxjGfcAtGqxkgA4W5OqfIkGst6uYrkmM5dXUf3moTJ9uidvjBomF
         q4KbyIpx9L7xzLonAPThGgEMBT43Arb4ruaOy3Wj2uSooiTykoHhMKK+x/yfc4O3Ui
         zWeLZqrzKHOiDSJYQId7mMl2HGp3RowjPYHT47Pq3hpntjJIVu5a0hnpa4cFIm+tQW
         D7AQALQ2ky4Ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
        sumit.semwal@linaro.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH AUTOSEL 6.1 7/7] drm/amdkfd: Fix double release compute pasid
Date:   Sat, 31 Dec 2022 15:04:39 -0500
Message-Id: <20221231200439.1748686-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221231200439.1748686-1-sashal@kernel.org>
References: <20221231200439.1748686-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 1a799c4c190ea9f0e81028e3eb3037ed0ab17ff5 ]

If kfd_process_device_init_vm returns failure after vm is converted to
compute vm and vm->pasid set to compute pasid, KFD will not take
pdd->drm_file reference. As a result, drm close file handler maybe
called to release the compute pasid before KFD process destroy worker to
release the same pasid and set vm->pasid to zero, this generates below
WARNING backtrace and NULL pointer access.

Add helper amdgpu_amdkfd_gpuvm_set_vm_pasid and call it at the last step
of kfd_process_device_init_vm, to ensure vm pasid is the original pasid
if acquiring vm failed or is the compute pasid with pdd->drm_file
reference taken to avoid double release same pasid.

 amdgpu: Failed to create process VM object
 ida_free called for id=32770 which is not allocated.
 WARNING: CPU: 57 PID: 72542 at ../lib/idr.c:522 ida_free+0x96/0x140
 RIP: 0010:ida_free+0x96/0x140
 Call Trace:
  amdgpu_pasid_free_delayed+0xe1/0x2a0 [amdgpu]
  amdgpu_driver_postclose_kms+0x2d8/0x340 [amdgpu]
  drm_file_free.part.13+0x216/0x270 [drm]
  drm_close_helper.isra.14+0x60/0x70 [drm]
  drm_release+0x6e/0xf0 [drm]
  __fput+0xcc/0x280
  ____fput+0xe/0x20
  task_work_run+0x96/0xc0
  do_exit+0x3d0/0xc10

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 RIP: 0010:ida_free+0x76/0x140
 Call Trace:
  amdgpu_pasid_free_delayed+0xe1/0x2a0 [amdgpu]
  amdgpu_driver_postclose_kms+0x2d8/0x340 [amdgpu]
  drm_file_free.part.13+0x216/0x270 [drm]
  drm_close_helper.isra.14+0x60/0x70 [drm]
  drm_release+0x6e/0xf0 [drm]
  __fput+0xcc/0x280
  ____fput+0xe/0x20
  task_work_run+0x96/0xc0
  do_exit+0x3d0/0xc10

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h    |  4 +-
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c  | 39 +++++++++++++------
 drivers/gpu/drm/amd/amdkfd/kfd_process.c      | 12 ++++--
 3 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index 647220a8762d..30f145dc8724 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -265,8 +265,10 @@ int amdgpu_amdkfd_get_pcie_bandwidth_mbytes(struct amdgpu_device *adev, bool is_
 	(&((struct amdgpu_fpriv *)					\
 		((struct drm_file *)(drm_priv))->driver_priv)->vm)
 
+int amdgpu_amdkfd_gpuvm_set_vm_pasid(struct amdgpu_device *adev,
+				     struct file *filp, u32 pasid);
 int amdgpu_amdkfd_gpuvm_acquire_process_vm(struct amdgpu_device *adev,
-					struct file *filp, u32 pasid,
+					struct file *filp,
 					void **process_info,
 					struct dma_fence **ef);
 void amdgpu_amdkfd_gpuvm_release_process_vm(struct amdgpu_device *adev,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
index 1f76e27f1a35..18a7cbbd00ff 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1473,10 +1473,9 @@ static void amdgpu_amdkfd_gpuvm_unpin_bo(struct amdgpu_bo *bo)
 	amdgpu_bo_unreserve(bo);
 }
 
-int amdgpu_amdkfd_gpuvm_acquire_process_vm(struct amdgpu_device *adev,
-					   struct file *filp, u32 pasid,
-					   void **process_info,
-					   struct dma_fence **ef)
+int amdgpu_amdkfd_gpuvm_set_vm_pasid(struct amdgpu_device *adev,
+				     struct file *filp, u32 pasid)
+
 {
 	struct amdgpu_fpriv *drv_priv;
 	struct amdgpu_vm *avm;
@@ -1487,10 +1486,6 @@ int amdgpu_amdkfd_gpuvm_acquire_process_vm(struct amdgpu_device *adev,
 		return ret;
 	avm = &drv_priv->vm;
 
-	/* Already a compute VM? */
-	if (avm->process_info)
-		return -EINVAL;
-
 	/* Free the original amdgpu allocated pasid,
 	 * will be replaced with kfd allocated pasid.
 	 */
@@ -1499,14 +1494,36 @@ int amdgpu_amdkfd_gpuvm_acquire_process_vm(struct amdgpu_device *adev,
 		amdgpu_vm_set_pasid(adev, avm, 0);
 	}
 
-	/* Convert VM into a compute VM */
-	ret = amdgpu_vm_make_compute(adev, avm);
+	ret = amdgpu_vm_set_pasid(adev, avm, pasid);
 	if (ret)
 		return ret;
 
-	ret = amdgpu_vm_set_pasid(adev, avm, pasid);
+	return 0;
+}
+
+int amdgpu_amdkfd_gpuvm_acquire_process_vm(struct amdgpu_device *adev,
+					   struct file *filp,
+					   void **process_info,
+					   struct dma_fence **ef)
+{
+	struct amdgpu_fpriv *drv_priv;
+	struct amdgpu_vm *avm;
+	int ret;
+
+	ret = amdgpu_file_to_fpriv(filp, &drv_priv);
 	if (ret)
 		return ret;
+	avm = &drv_priv->vm;
+
+	/* Already a compute VM? */
+	if (avm->process_info)
+		return -EINVAL;
+
+	/* Convert VM into a compute VM */
+	ret = amdgpu_vm_make_compute(adev, avm);
+	if (ret)
+		return ret;
+
 	/* Initialize KFD part of the VM and process info */
 	ret = init_kfd_vm(avm, process_info, ef);
 	if (ret)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 9821fa9268d3..dd351105c1bc 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -1576,9 +1576,9 @@ int kfd_process_device_init_vm(struct kfd_process_device *pdd,
 	p = pdd->process;
 	dev = pdd->dev;
 
-	ret = amdgpu_amdkfd_gpuvm_acquire_process_vm(
-		dev->adev, drm_file, p->pasid,
-		&p->kgd_process_info, &p->ef);
+	ret = amdgpu_amdkfd_gpuvm_acquire_process_vm(dev->adev, drm_file,
+						     &p->kgd_process_info,
+						     &p->ef);
 	if (ret) {
 		pr_err("Failed to create process VM object\n");
 		return ret;
@@ -1593,10 +1593,16 @@ int kfd_process_device_init_vm(struct kfd_process_device *pdd,
 	if (ret)
 		goto err_init_cwsr;
 
+	ret = amdgpu_amdkfd_gpuvm_set_vm_pasid(dev->adev, drm_file, p->pasid);
+	if (ret)
+		goto err_set_pasid;
+
 	pdd->drm_file = drm_file;
 
 	return 0;
 
+err_set_pasid:
+	kfd_process_device_destroy_cwsr_dgpu(pdd);
 err_init_cwsr:
 	kfd_process_device_destroy_ib_mem(pdd);
 err_reserve_ib_mem:
-- 
2.35.1

