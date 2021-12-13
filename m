Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0EB472613
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235956AbhLMJs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:48:58 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:37964 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236410AbhLMJrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5CFE4CE0E82;
        Mon, 13 Dec 2021 09:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B30C341C8;
        Mon, 13 Dec 2021 09:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388821;
        bh=EtcMIeZK+l/l3M2HK/mmy61mumClyeeRZRu3Ly8NCoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMuIDpJ65MwIO4lj/ahUoY5wz7r62J++olwYgdVhwvgvnD34lA+ExptdoNO1afuSd
         piPo+NWhbDTWTGO43FC3uMN/Ne9Yy3/kU1v301/qydKB4GrSCeIPvbn0qL7kQExqFy
         dJOqiwu/507CWROxc0PV1fjCrH7Nv7KP4QVYS2YA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Yu <Lang.Yu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        James Zhu <James.Zhu@amd.com>
Subject: [PATCH 5.10 021/132] drm/amd/amdkfd: adjust dummy functions placement
Date:   Mon, 13 Dec 2021 10:29:22 +0100
Message-Id: <20211213092939.820482765@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Yu <Lang.Yu@amd.com>

commit cd63989e0e6aa2eb66b461f2bae769e2550e47ac upstream.

Move all the dummy functions in amdgpu_amdkfd.c to
amdgpu_amdkfd.h as inline functions.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Suggested-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |   87 ------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h |  138 +++++++++++++++++++++++++----
 2 files changed, 119 insertions(+), 106 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -47,12 +47,8 @@ int amdgpu_amdkfd_init(void)
 	amdgpu_amdkfd_total_mem_size = si.totalram - si.totalhigh;
 	amdgpu_amdkfd_total_mem_size *= si.mem_unit;
 
-#ifdef CONFIG_HSA_AMD
 	ret = kgd2kfd_init();
 	amdgpu_amdkfd_gpuvm_init_mem_limits();
-#else
-	ret = -ENOENT;
-#endif
 	kfd_initialized = !ret;
 
 	return ret;
@@ -695,86 +691,3 @@ bool amdgpu_amdkfd_have_atomics_support(
 
 	return adev->have_atomics_support;
 }
-
-#ifndef CONFIG_HSA_AMD
-bool amdkfd_fence_check_mm(struct dma_fence *f, struct mm_struct *mm)
-{
-	return false;
-}
-
-void amdgpu_amdkfd_unreserve_memory_limit(struct amdgpu_bo *bo)
-{
-}
-
-int amdgpu_amdkfd_remove_fence_on_pt_pd_bos(struct amdgpu_bo *bo)
-{
-	return 0;
-}
-
-void amdgpu_amdkfd_gpuvm_destroy_cb(struct amdgpu_device *adev,
-					struct amdgpu_vm *vm)
-{
-}
-
-struct amdgpu_amdkfd_fence *to_amdgpu_amdkfd_fence(struct dma_fence *f)
-{
-	return NULL;
-}
-
-int amdgpu_amdkfd_evict_userptr(struct kgd_mem *mem, struct mm_struct *mm)
-{
-	return 0;
-}
-
-struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev,
-			      unsigned int asic_type, bool vf)
-{
-	return NULL;
-}
-
-bool kgd2kfd_device_init(struct kfd_dev *kfd,
-			 struct drm_device *ddev,
-			 const struct kgd2kfd_shared_resources *gpu_resources)
-{
-	return false;
-}
-
-void kgd2kfd_device_exit(struct kfd_dev *kfd)
-{
-}
-
-void kgd2kfd_exit(void)
-{
-}
-
-void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm)
-{
-}
-
-int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm)
-{
-	return 0;
-}
-
-int kgd2kfd_pre_reset(struct kfd_dev *kfd)
-{
-	return 0;
-}
-
-int kgd2kfd_post_reset(struct kfd_dev *kfd)
-{
-	return 0;
-}
-
-void kgd2kfd_interrupt(struct kfd_dev *kfd, const void *ih_ring_entry)
-{
-}
-
-void kgd2kfd_set_sram_ecc_flag(struct kfd_dev *kfd)
-{
-}
-
-void kgd2kfd_smi_event_throttle(struct kfd_dev *kfd, uint32_t throttle_bitmask)
-{
-}
-#endif
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
@@ -94,11 +94,6 @@ enum kgd_engine_type {
 	KGD_ENGINE_MAX
 };
 
-struct amdgpu_amdkfd_fence *amdgpu_amdkfd_fence_create(u64 context,
-						       struct mm_struct *mm);
-bool amdkfd_fence_check_mm(struct dma_fence *f, struct mm_struct *mm);
-struct amdgpu_amdkfd_fence *to_amdgpu_amdkfd_fence(struct dma_fence *f);
-int amdgpu_amdkfd_remove_fence_on_pt_pd_bos(struct amdgpu_bo *bo);
 
 struct amdkfd_process_info {
 	/* List head of all VMs that belong to a KFD process */
@@ -132,8 +127,6 @@ void amdgpu_amdkfd_interrupt(struct amdg
 void amdgpu_amdkfd_device_probe(struct amdgpu_device *adev);
 void amdgpu_amdkfd_device_init(struct amdgpu_device *adev);
 void amdgpu_amdkfd_device_fini(struct amdgpu_device *adev);
-
-int amdgpu_amdkfd_evict_userptr(struct kgd_mem *mem, struct mm_struct *mm);
 int amdgpu_amdkfd_submit_ib(struct kgd_dev *kgd, enum kgd_engine_type engine,
 				uint32_t vmid, uint64_t gpu_addr,
 				uint32_t *ib_cmd, uint32_t ib_len);
@@ -153,6 +146,38 @@ void amdgpu_amdkfd_gpu_reset(struct kgd_
 int amdgpu_queue_mask_bit_to_set_resource_bit(struct amdgpu_device *adev,
 					int queue_bit);
 
+struct amdgpu_amdkfd_fence *amdgpu_amdkfd_fence_create(u64 context,
+								struct mm_struct *mm);
+#if IS_ENABLED(CONFIG_HSA_AMD)
+bool amdkfd_fence_check_mm(struct dma_fence *f, struct mm_struct *mm);
+struct amdgpu_amdkfd_fence *to_amdgpu_amdkfd_fence(struct dma_fence *f);
+int amdgpu_amdkfd_remove_fence_on_pt_pd_bos(struct amdgpu_bo *bo);
+int amdgpu_amdkfd_evict_userptr(struct kgd_mem *mem, struct mm_struct *mm);
+#else
+static inline
+bool amdkfd_fence_check_mm(struct dma_fence *f, struct mm_struct *mm)
+{
+	return false;
+}
+
+static inline
+struct amdgpu_amdkfd_fence *to_amdgpu_amdkfd_fence(struct dma_fence *f)
+{
+	return NULL;
+}
+
+static inline
+int amdgpu_amdkfd_remove_fence_on_pt_pd_bos(struct amdgpu_bo *bo)
+{
+	return 0;
+}
+
+static inline
+int amdgpu_amdkfd_evict_userptr(struct kgd_mem *mem, struct mm_struct *mm)
+{
+	return 0;
+}
+#endif
 /* Shared API */
 int amdgpu_amdkfd_alloc_gtt_mem(struct kgd_dev *kgd, size_t size,
 				void **mem_obj, uint64_t *gpu_addr,
@@ -215,8 +240,6 @@ int amdgpu_amdkfd_gpuvm_acquire_process_
 					struct file *filp, u32 pasid,
 					void **vm, void **process_info,
 					struct dma_fence **ef);
-void amdgpu_amdkfd_gpuvm_destroy_cb(struct amdgpu_device *adev,
-				struct amdgpu_vm *vm);
 void amdgpu_amdkfd_gpuvm_destroy_process_vm(struct kgd_dev *kgd, void *vm);
 void amdgpu_amdkfd_gpuvm_release_process_vm(struct kgd_dev *kgd, void *vm);
 uint64_t amdgpu_amdkfd_gpuvm_get_process_page_dir(void *vm);
@@ -236,23 +259,43 @@ int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_ke
 		struct kgd_mem *mem, void **kptr, uint64_t *size);
 int amdgpu_amdkfd_gpuvm_restore_process_bos(void *process_info,
 					    struct dma_fence **ef);
-
 int amdgpu_amdkfd_gpuvm_get_vm_fault_info(struct kgd_dev *kgd,
 					      struct kfd_vm_fault_info *info);
-
 int amdgpu_amdkfd_gpuvm_import_dmabuf(struct kgd_dev *kgd,
 				      struct dma_buf *dmabuf,
 				      uint64_t va, void *vm,
 				      struct kgd_mem **mem, uint64_t *size,
 				      uint64_t *mmap_offset);
-
-void amdgpu_amdkfd_gpuvm_init_mem_limits(void);
-void amdgpu_amdkfd_unreserve_memory_limit(struct amdgpu_bo *bo);
-
 int amdgpu_amdkfd_get_tile_config(struct kgd_dev *kgd,
 				struct tile_config *config);
+#if IS_ENABLED(CONFIG_HSA_AMD)
+void amdgpu_amdkfd_gpuvm_init_mem_limits(void);
+void amdgpu_amdkfd_gpuvm_destroy_cb(struct amdgpu_device *adev,
+				struct amdgpu_vm *vm);
+void amdgpu_amdkfd_unreserve_memory_limit(struct amdgpu_bo *bo);
+#else
+static inline
+void amdgpu_amdkfd_gpuvm_init_mem_limits(void)
+{
+}
 
+static inline
+void amdgpu_amdkfd_gpuvm_destroy_cb(struct amdgpu_device *adev,
+					struct amdgpu_vm *vm)
+{
+}
+
+static inline
+void amdgpu_amdkfd_unreserve_memory_limit(struct amdgpu_bo *bo)
+{
+}
+#endif
 /* KGD2KFD callbacks */
+int kgd2kfd_quiesce_mm(struct mm_struct *mm);
+int kgd2kfd_resume_mm(struct mm_struct *mm);
+int kgd2kfd_schedule_evict_and_restore_process(struct mm_struct *mm,
+						struct dma_fence *fence);
+#if IS_ENABLED(CONFIG_HSA_AMD)
 int kgd2kfd_init(void);
 void kgd2kfd_exit(void);
 struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev,
@@ -266,11 +309,68 @@ int kgd2kfd_resume(struct kfd_dev *kfd,
 int kgd2kfd_pre_reset(struct kfd_dev *kfd);
 int kgd2kfd_post_reset(struct kfd_dev *kfd);
 void kgd2kfd_interrupt(struct kfd_dev *kfd, const void *ih_ring_entry);
-int kgd2kfd_quiesce_mm(struct mm_struct *mm);
-int kgd2kfd_resume_mm(struct mm_struct *mm);
-int kgd2kfd_schedule_evict_and_restore_process(struct mm_struct *mm,
-					       struct dma_fence *fence);
 void kgd2kfd_set_sram_ecc_flag(struct kfd_dev *kfd);
 void kgd2kfd_smi_event_throttle(struct kfd_dev *kfd, uint32_t throttle_bitmask);
+#else
+static inline int kgd2kfd_init(void)
+{
+	return -ENOENT;
+}
+
+static inline void kgd2kfd_exit(void)
+{
+}
 
+static inline
+struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev,
+					unsigned int asic_type, bool vf)
+{
+	return NULL;
+}
+
+static inline
+bool kgd2kfd_device_init(struct kfd_dev *kfd, struct drm_device *ddev,
+				const struct kgd2kfd_shared_resources *gpu_resources)
+{
+	return false;
+}
+
+static inline void kgd2kfd_device_exit(struct kfd_dev *kfd)
+{
+}
+
+static inline void kgd2kfd_suspend(struct kfd_dev *kfd, bool run_pm)
+{
+}
+
+static inline int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm)
+{
+	return 0;
+}
+
+static inline int kgd2kfd_pre_reset(struct kfd_dev *kfd)
+{
+	return 0;
+}
+
+static inline int kgd2kfd_post_reset(struct kfd_dev *kfd)
+{
+	return 0;
+}
+
+static inline
+void kgd2kfd_interrupt(struct kfd_dev *kfd, const void *ih_ring_entry)
+{
+}
+
+static inline
+void kgd2kfd_set_sram_ecc_flag(struct kfd_dev *kfd)
+{
+}
+
+static inline
+void kgd2kfd_smi_event_throttle(struct kfd_dev *kfd, uint32_t throttle_bitmask)
+{
+}
+#endif
 #endif /* AMDGPU_AMDKFD_H_INCLUDED */


