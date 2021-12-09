Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C40246F688
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 23:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232372AbhLIWNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 17:13:49 -0500
Received: from mail-dm6nam08on2041.outbound.protection.outlook.com ([40.107.102.41]:41537
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232333AbhLIWNs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Dec 2021 17:13:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfVciW0uAmAc28mz5O6S3bHDQe/4DcJfWIZdpJR1W0+KdvdJNbabo6Zx60zlg+ToqJR+8Ms85fp8xnVLw+ymdAGTENypgyAtpa6HBJnOkDBfU/71uJYSiNwzIZrcad/N4GQi8hqwTONRBQ6ZN1bniQdTgElnRUX2nv2QZgMKTbbXpRXCAxhuwJvA5nDxJc+j3DlZ+8q+R0M75OJ5FZdV6cPpRwI1RVhl/CqEAwNFb3Q+oJR/vc4Zun/8k+8ksBVkDnjQ1AdFUboAjamhqINdl4wZ0VE9vao+u98+7uODYkcxljY09yP0TGfzF7d8JUKX8Xc6xZPz5hUeEwGarCYW1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ANMp3rsskGe8hM0vVV3cGWEP9oI3SpAq+y5Ti8g53TQ=;
 b=GryNYudJ/MD+xOZ1uoVqTMgeu9ijdORqYfltN8OQY064PBo99OJRAs9J3W3Vqq94JjybvAsF/5T47VcasOQrQyMSJ5K4/PrCNS+H6Y+b366gZFS4HZ6dK2noZtRu3psRgOHY++fsfr+7ns0Kke/gwE0aKB70DsAwewv0tmGXL7EZLqe9b48+yblcUKwrB2kMPBplEJtK/PJfLhInFC306V5JCBAaNnNid+P48LjET1rS9Gzr59lP9aY7a//dhlpAq8o9Y3Ypfdr7AEpPhXPjd0bglbM81Li3Qq9qpwe50FTpLbboxi70M0rBg7yrr/Ra/FFUKOMkEUN0FGkMYLANmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ANMp3rsskGe8hM0vVV3cGWEP9oI3SpAq+y5Ti8g53TQ=;
 b=1DIgzE/fhu6vv/i7valj8MnbX1fKi8WOfHZGjNjBNrTiTIPFPwsNPWmQu3l5rOOqR54x0Bkoq4Gb3/BxSVi+3nbOBYy91BOZ0oOQzVuQnE4lbp2mGvD7HcO1JJvDd7MNNtcV1lg3FWT0+RhNSn2Q52f+PeZPh1OOp6hBVoWU1Y8=
Received: from DM5PR06CA0053.namprd06.prod.outlook.com (2603:10b6:3:37::15) by
 PH0PR12MB5483.namprd12.prod.outlook.com (2603:10b6:510:ee::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.13; Thu, 9 Dec 2021 22:10:12 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::21) by DM5PR06CA0053.outlook.office365.com
 (2603:10b6:3:37::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend
 Transport; Thu, 9 Dec 2021 22:10:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4755.13 via Frontend Transport; Thu, 9 Dec 2021 22:10:12 +0000
Received: from jz-tester.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 9 Dec
 2021 16:10:10 -0600
From:   James Zhu <James.Zhu@amd.com>
To:     <stable@vger.kernel.org>
CC:     <jzhums@gmail.com>, <alexander.deucher@amd.com>,
        <kolAflash@kolahilft.de>, Lang Yu <Lang.Yu@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH 1/6] drm/amd/amdkfd: adjust dummy functions' placement
Date:   Thu, 9 Dec 2021 17:09:51 -0500
Message-ID: <20211209220956.3466442-2-James.Zhu@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209220956.3466442-1-James.Zhu@amd.com>
References: <20211209220956.3466442-1-James.Zhu@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d900ba1-5b16-48af-731b-08d9bb60abdd
X-MS-TrafficTypeDiagnostic: PH0PR12MB5483:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5483252D22FEF5801D163F96E4709@PH0PR12MB5483.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QoVn4rCim8KDUjIz0UmylMyKLur+4HT32EOsh5r/8Nk7S9pmKqXf8RkX/TzK4uJTGeJ5TkFkvRuxg1LssF8HSp+m14clL3Gc1dBnUcvnBzbF81y32EiiEhtaQandKXyAZVkXYd/gpxKauc9Drtvt86drjgM7dwy19hbzFu4f2UM9iTBbt1pEVFVoT6GM5tFj4Pvugbpyqqy7LFqHT1hLbyLIE4balEiNJzHEfCVhQdwXbaz4tqSiPuBRfZd1iy52jIOFuEDhKAukrDf5WfQ+LqHEYRxs+nfs8Nsinv+kUZG0dxCXG1SSmhtCbXVbyk+XLw4VU+7u9OXqc7UswDbUJNqI+BNX11LUqZx2CEUNUSnCoDK8+HZO0QDNWYpFRuDKnZbASWlc/kHZ87N+zo7LWtjDh6YLhy0Iti5VEPzVejzHkOHe3m64hPRjpAQdwkhqsRIasfbT647QFyl/bEYRPpblWeUYHY3hh4Ek0h0rXR9dFfdSZCCGYn7IPLzpfYLtcY9uDaz0kkrp3xhmlb95777OfjNSj+AYc9YHWhJcXHmfXLLCFQ3l11Gw6IHTjh5DFMju9GZzqkCbAdDKdtcmZVTmGfGPvhOhAcjP/Og7aML+Y1JksaBx6Q6qj9Sokn3IHFPQOxJodo2a0iTCLuZ+GcbTKrFa+hmkEhsI6sheVO0X3sDUecUBFgiuNNmG7uThen633a8W9U2hdq6867/crRNbm+Oooh+6IMSStak8vSJUFkYWqwKfDQT8F70uidvB4LvSPVz8y83HjhuMoDyuW64IPutGfEjFsDYcRjI/J6M=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(336012)(186003)(16526019)(426003)(1076003)(8936002)(83380400001)(6666004)(7696005)(82310400004)(356005)(316002)(8676002)(2906002)(6916009)(81166007)(54906003)(40460700001)(26005)(5660300002)(70586007)(70206006)(47076005)(508600001)(2616005)(36756003)(86362001)(36860700001)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 22:10:12.3213
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d900ba1-5b16-48af-731b-08d9bb60abdd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5483
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
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c |  87 -------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h | 138 ++++++++++++++++++---
 2 files changed, 119 insertions(+), 106 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index 0544460653b9..b23b31dc570e 100644
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
@@ -695,86 +691,3 @@ bool amdgpu_amdkfd_have_atomics_support(struct kgd_dev *kgd)
 
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
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.h
index ea391ca7f2f1..a81d9cacf9b8 100644
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
@@ -132,8 +127,6 @@ void amdgpu_amdkfd_interrupt(struct amdgpu_device *adev,
 void amdgpu_amdkfd_device_probe(struct amdgpu_device *adev);
 void amdgpu_amdkfd_device_init(struct amdgpu_device *adev);
 void amdgpu_amdkfd_device_fini(struct amdgpu_device *adev);
-
-int amdgpu_amdkfd_evict_userptr(struct kgd_mem *mem, struct mm_struct *mm);
 int amdgpu_amdkfd_submit_ib(struct kgd_dev *kgd, enum kgd_engine_type engine,
 				uint32_t vmid, uint64_t gpu_addr,
 				uint32_t *ib_cmd, uint32_t ib_len);
@@ -153,6 +146,38 @@ void amdgpu_amdkfd_gpu_reset(struct kgd_dev *kgd);
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
@@ -215,8 +240,6 @@ int amdgpu_amdkfd_gpuvm_acquire_process_vm(struct kgd_dev *kgd,
 					struct file *filp, u32 pasid,
 					void **vm, void **process_info,
 					struct dma_fence **ef);
-void amdgpu_amdkfd_gpuvm_destroy_cb(struct amdgpu_device *adev,
-				struct amdgpu_vm *vm);
 void amdgpu_amdkfd_gpuvm_destroy_process_vm(struct kgd_dev *kgd, void *vm);
 void amdgpu_amdkfd_gpuvm_release_process_vm(struct kgd_dev *kgd, void *vm);
 uint64_t amdgpu_amdkfd_gpuvm_get_process_page_dir(void *vm);
@@ -236,23 +259,43 @@ int amdgpu_amdkfd_gpuvm_map_gtt_bo_to_kernel(struct kgd_dev *kgd,
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
@@ -266,11 +309,68 @@ int kgd2kfd_resume(struct kfd_dev *kfd, bool run_pm);
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
 
+static inline void kgd2kfd_exit(void)
+{
+}
+
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
-- 
2.25.1

