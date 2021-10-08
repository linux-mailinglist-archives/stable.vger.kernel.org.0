Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3B8426974
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241579AbhJHLh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240936AbhJHLf5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:35:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E31EC613A6;
        Fri,  8 Oct 2021 11:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692719;
        bh=2ZHYXxnTOKNAMt5haKytR59bQ5hztoQjFR7mj6iEIbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDSszzfzFSxwNEjAOmKQ2WZwHGx7PQiZqdh1F+nzxN7K6VCms9Pu60kM37c5iw1Uo
         V7/wXOggbr3uaW98ToQBk7WGyTKsaNsS7RdUWs4uM9cdq42sFpDGUupWdlNuqnfUF0
         IfpxiLiOpIlfunFUB60zLNMlfl/sAIiyqK7OKUUM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philip Yang <Philip.Yang@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 14/48] drm/amdkfd: fix svm_migrate_fini warning
Date:   Fri,  8 Oct 2021 13:27:50 +0200
Message-Id: <20211008112720.499928174@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5a872adcfdb9..5ba8a4f35344 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device.c
@@ -922,7 +922,6 @@ out:
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



