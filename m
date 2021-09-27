Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC0A419CA1
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbhI0Rae (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:30:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237608AbhI0R2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:28:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D27F61390;
        Mon, 27 Sep 2021 17:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763025;
        bh=s32NfFJRix6MICF7kmXyPErqs7c4U1JDiIXhV8BfKrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOcVVMZbSP8l5yAF+StaWAfR5Ngss+U0+E8UN2MJzycD6fsiAeaZ891OeCGX4fp8D
         wg7KdG1a4WzDVMPzecvWJH0FZQediRoVRjwVtveGExGQ819X0OZIj9Yca27y+egrni
         XCEMH1HbUnzosuLkt5k+3KVTyNES7NFsS/jGtkVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Kuehling <Felix.Kuehling@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 140/162] drm/amdkfd: make needs_pcie_atomics FW-version dependent
Date:   Mon, 27 Sep 2021 19:03:06 +0200
Message-Id: <20210927170238.272739515@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Felix Kuehling <Felix.Kuehling@amd.com>

[ Upstream commit fb932dfeb87411a8a01c995576198bfc302df339 ]

On some GPUs the PCIe atomic requirement for KFD depends on the MEC
firmware version. Add a firmware version check for this. The minimum
firmware version that works without atomics can be updated in the
device_info structure for each GPU type.

Move PCIe atomic detection from kgd2kfd_probe into kgd2kfd_device_init
because the MEC firmware is not loaded yet at the probe stage.

Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Reviewed-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c | 44 ++++++++++++++++---------
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h   |  1 +
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 9e52948d4992..5a872adcfdb9 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -447,6 +447,7 @@ static const struct kfd_device_info navi10_device_info = {
 	.needs_iommu_device = false,
 	.supports_cwsr = true,
 	.needs_pci_atomics = true,
+	.no_atomic_fw_version = 145,
 	.num_sdma_engines = 2,
 	.num_xgmi_sdma_engines = 0,
 	.num_sdma_queues_per_engine = 8,
@@ -465,6 +466,7 @@ static const struct kfd_device_info navi12_device_info = {
 	.needs_iommu_device = false,
 	.supports_cwsr = true,
 	.needs_pci_atomics = true,
+	.no_atomic_fw_version = 145,
 	.num_sdma_engines = 2,
 	.num_xgmi_sdma_engines = 0,
 	.num_sdma_queues_per_engine = 8,
@@ -483,6 +485,7 @@ static const struct kfd_device_info navi14_device_info = {
 	.needs_iommu_device = false,
 	.supports_cwsr = true,
 	.needs_pci_atomics = true,
+	.no_atomic_fw_version = 145,
 	.num_sdma_engines = 2,
 	.num_xgmi_sdma_engines = 0,
 	.num_sdma_queues_per_engine = 8,
@@ -501,6 +504,7 @@ static const struct kfd_device_info sienna_cichlid_device_info = {
 	.needs_iommu_device = false,
 	.supports_cwsr = true,
 	.needs_pci_atomics = true,
+	.no_atomic_fw_version = 92,
 	.num_sdma_engines = 4,
 	.num_xgmi_sdma_engines = 0,
 	.num_sdma_queues_per_engine = 8,
@@ -519,6 +523,7 @@ static const struct kfd_device_info navy_flounder_device_info = {
 	.needs_iommu_device = false,
 	.supports_cwsr = true,
 	.needs_pci_atomics = true,
+	.no_atomic_fw_version = 92,
 	.num_sdma_engines = 2,
 	.num_xgmi_sdma_engines = 0,
 	.num_sdma_queues_per_engine = 8,
@@ -536,7 +541,8 @@ static const struct kfd_device_info vangogh_device_info = {
 	.mqd_size_aligned = MQD_SIZE_ALIGNED,
 	.needs_iommu_device = false,
 	.supports_cwsr = true,
-	.needs_pci_atomics = false,
+	.needs_pci_atomics = true,
+	.no_atomic_fw_version = 92,
 	.num_sdma_engines = 1,
 	.num_xgmi_sdma_engines = 0,
 	.num_sdma_queues_per_engine = 2,
@@ -555,6 +561,7 @@ static const struct kfd_device_info dimgrey_cavefish_device_info = {
 	.needs_iommu_device = false,
 	.supports_cwsr = true,
 	.needs_pci_atomics = true,
+	.no_atomic_fw_version = 92,
 	.num_sdma_engines = 2,
 	.num_xgmi_sdma_engines = 0,
 	.num_sdma_queues_per_engine = 8,
@@ -573,6 +580,7 @@ static const struct kfd_device_info beige_goby_device_info = {
 	.needs_iommu_device = false,
 	.supports_cwsr = true,
 	.needs_pci_atomics = true,
+	.no_atomic_fw_version = 92,
 	.num_sdma_engines = 1,
 	.num_xgmi_sdma_engines = 0,
 	.num_sdma_queues_per_engine = 8,
@@ -590,7 +598,8 @@ static const struct kfd_device_info yellow_carp_device_info = {
 	.mqd_size_aligned = MQD_SIZE_ALIGNED,
 	.needs_iommu_device = false,
 	.supports_cwsr = true,
-	.needs_pci_atomics = false,
+	.needs_pci_atomics = true,
+	.no_atomic_fw_version = 92,
 	.num_sdma_engines = 1,
 	.num_xgmi_sdma_engines = 0,
 	.num_sdma_queues_per_engine = 2,
@@ -659,20 +668,6 @@ struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd,
 	if (!kfd)
 		return NULL;
 
-	/* Allow BIF to recode atomics to PCIe 3.0 AtomicOps.
-	 * 32 and 64-bit requests are possible and must be
-	 * supported.
-	 */
-	kfd->pci_atomic_requested = amdgpu_amdkfd_have_atomics_support(kgd);
-	if (device_info->needs_pci_atomics &&
-	    !kfd->pci_atomic_requested) {
-		dev_info(kfd_device,
-			 "skipped device %x:%x, PCI rejects atomics\n",
-			 pdev->vendor, pdev->device);
-		kfree(kfd);
-		return NULL;
-	}
-
 	kfd->kgd = kgd;
 	kfd->device_info = device_info;
 	kfd->pdev = pdev;
@@ -772,6 +767,23 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 	kfd->vm_info.vmid_num_kfd = kfd->vm_info.last_vmid_kfd
 			- kfd->vm_info.first_vmid_kfd + 1;
 
+	/* Allow BIF to recode atomics to PCIe 3.0 AtomicOps.
+	 * 32 and 64-bit requests are possible and must be
+	 * supported.
+	 */
+	kfd->pci_atomic_requested = amdgpu_amdkfd_have_atomics_support(kfd->kgd);
+	if (!kfd->pci_atomic_requested &&
+	    kfd->device_info->needs_pci_atomics &&
+	    (!kfd->device_info->no_atomic_fw_version ||
+	     kfd->mec_fw_version < kfd->device_info->no_atomic_fw_version)) {
+		dev_info(kfd_device,
+			 "skipped device %x:%x, PCI rejects atomics %d<%d\n",
+			 kfd->pdev->vendor, kfd->pdev->device,
+			 kfd->mec_fw_version,
+			 kfd->device_info->no_atomic_fw_version);
+		return false;
+	}
+
 	/* Verify module parameters regarding mapped process number*/
 	if ((hws_max_conc_proc < 0)
 			|| (hws_max_conc_proc > kfd->vm_info.vmid_num_kfd)) {
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 3426743ed228..b38a84a27438 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -206,6 +206,7 @@ struct kfd_device_info {
 	bool supports_cwsr;
 	bool needs_iommu_device;
 	bool needs_pci_atomics;
+	uint32_t no_atomic_fw_version;
 	unsigned int num_sdma_engines;
 	unsigned int num_xgmi_sdma_engines;
 	unsigned int num_sdma_queues_per_engine;
-- 
2.33.0



