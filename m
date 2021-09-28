Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564E241A769
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238975AbhI1F5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:57:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238970AbhI1F5N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 284FB611BD;
        Tue, 28 Sep 2021 05:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808534;
        bh=Bs6gr4YUdAh+y8PTvt9L460J2iLXolfu9zohbMbR750=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXV4YVYsPFpbDoTSjCXDVV4JRAzEvE3VC7fLcX1xxDUPsEoGEXpni76emM91JlLkY
         MYaH/mhhfvoPWEAQyqPg5tMxrkqxMtM7mcVhJJjGraJRRGJe7GmQPhsKuDOe9jXrOQ
         iwCAy2ICxiIjL0AQvGLYblxBuSbaLCWK4Ri9S8ynaYm7/Zf3/xqUMlpAYmMiqU/HW1
         eQSdR4KkFD5DM9KXCpkFXZAU2nBGUtpX+bhpn/RQZFD1DEAMYnP4wScBafb+ZfLYUZ
         QTQeXnLLb1NcGA3DSPwoWO2WbEKcqpj7EdFYMs45JOkaOaT1sXIK1vNXBLMMeArMhV
         YtE8DyPDVjwJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 15/40] drm/amdkfd: fix svm_migrate_fini warning
Date:   Tue, 28 Sep 2021 01:54:59 -0400
Message-Id: <20210928055524.172051-15-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210928055524.172051-1-sashal@kernel.org>
References: <20210928055524.172051-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philip Yang <Philip.Yang@amd.com>

[ Upstream commit 197ae17722e989942b36e33e044787877f158574 ]

Device manager releases device-specific resources when a driver
disconnects from a device, devm_memunmap_pages and
devm_release_mem_region calls in svm_migrate_fini are redundant.

It causes below warning trace after patch "drm/amdgpu: Split
amdgpu_device_fini into early and late", so remove function
svm_migrate_fini.

BUG: https://gitlab.freedesktop.org/drm/amd/-/issues/1718

WARNING: CPU: 1 PID: 3646 at drivers/base/devres.c:795
devm_release_action+0x51/0x60
Call Trace:
    ? memunmap_pages+0x360/0x360
    svm_migrate_fini+0x2d/0x60 [amdgpu]
    kgd2kfd_device_exit+0x23/0xa0 [amdgpu]
    amdgpu_amdkfd_device_fini_sw+0x1d/0x30 [amdgpu]
    amdgpu_device_fini_sw+0x45/0x290 [amdgpu]
    amdgpu_driver_release_kms+0x12/0x30 [amdgpu]
    drm_dev_release+0x20/0x40 [drm]
    release_nodes+0x196/0x1e0
    device_release_driver_internal+0x104/0x1d0
    driver_detach+0x47/0x90
    bus_remove_driver+0x7a/0xd0
    pci_unregister_driver+0x3d/0x90
    amdgpu_exit+0x11/0x20 [amdgpu]

Signed-off-by: Philip Yang <Philip.Yang@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_device.c  |  1 -
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c | 13 ++++---------
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.h |  5 -----
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device.c b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
index 9e52948d4992..0e5ebb384164 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -910,7 +910,6 @@ bool kgd2kfd_device_init(struct kfd_dev *kfd,
 void kgd2kfd_device_exit(struct kfd_dev *kfd)
 {
 	if (kfd->init_complete) {
-		svm_migrate_fini((struct amdgpu_device *)kfd->kgd);
 		device_queue_manager_uninit(kfd->dqm);
 		kfd_interrupt_exit(kfd);
 		kfd_topology_remove_device(kfd);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index 165e0ebb619d..4a16e3c257b9 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -891,6 +891,10 @@ int svm_migrate_init(struct amdgpu_device *adev)
 	pgmap->ops = &svm_migrate_pgmap_ops;
 	pgmap->owner = SVM_ADEV_PGMAP_OWNER(adev);
 	pgmap->flags = MIGRATE_VMA_SELECT_DEVICE_PRIVATE;
+
+	/* Device manager releases device-specific resources, memory region and
+	 * pgmap when driver disconnects from device.
+	 */
 	r = devm_memremap_pages(adev->dev, pgmap);
 	if (IS_ERR(r)) {
 		pr_err("failed to register HMM device memory\n");
@@ -911,12 +915,3 @@ int svm_migrate_init(struct amdgpu_device *adev)
 
 	return 0;
 }
-
-void svm_migrate_fini(struct amdgpu_device *adev)
-{
-	struct dev_pagemap *pgmap = &adev->kfd.dev->pgmap;
-
-	devm_memunmap_pages(adev->dev, pgmap);
-	devm_release_mem_region(adev->dev, pgmap->range.start,
-				pgmap->range.end - pgmap->range.start + 1);
-}
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
index 0de76b5d4973..2f5b3394c9ed 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.h
@@ -47,7 +47,6 @@ unsigned long
 svm_migrate_addr_to_pfn(struct amdgpu_device *adev, unsigned long addr);
 
 int svm_migrate_init(struct amdgpu_device *adev);
-void svm_migrate_fini(struct amdgpu_device *adev);
 
 #else
 
@@ -55,10 +54,6 @@ static inline int svm_migrate_init(struct amdgpu_device *adev)
 {
 	return 0;
 }
-static inline void svm_migrate_fini(struct amdgpu_device *adev)
-{
-	/* empty */
-}
 
 #endif /* IS_ENABLED(CONFIG_HSA_AMD_SVM) */
 
-- 
2.33.0

