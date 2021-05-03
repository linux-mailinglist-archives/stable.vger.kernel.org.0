Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09DC371B7B
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhECQqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233050AbhECQo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:44:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2838613ED;
        Mon,  3 May 2021 16:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059929;
        bh=Lw6vE4UcBrY7WNNZ9dvZ6+mazSAp9vuX80l+b5VsBCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pZXPSpSFbjCDrsdM3gPgyI3eHcs7IOmg7W1m4vlmlU5WBmeF0HxlV3eIaEg6Pg1ed
         VLXs6128vJ1Xy2yxJNPEcQ+caRKA45a0ItA5HhMJlhsw3CvLChYk+htMgmkfrbIR0K
         FSa332T2V6wNWlPrOtRJg5V7bDOkG8GDPWkgXj9e48U9n8OMXn9dy7M/foUkk7zuKw
         ymjCTRc8QAYoUVt2WYO3RA0UrGpO1JCTKaHGeUuWX57zfC06q3m74+ns2I+FSedspl
         hF46kWrtjqYX1KJ//FxOzFxGhMUXE/4QS/BfMD0ABuU33kkyMIbFezyrzXf33GEICF
         lRtJqtTTNE42A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emily Deng <Emily.Deng@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 013/100] drm/amdgpu: Fix some unload driver issues
Date:   Mon,  3 May 2021 12:37:02 -0400
Message-Id: <20210503163829.2852775-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163829.2852775-1-sashal@kernel.org>
References: <20210503163829.2852775-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Emily Deng <Emily.Deng@amd.com>

[ Upstream commit bb0cd09be45ea457f25fdcbcb3d6cf2230f26c46 ]

When unloading driver after killing some applications, it will hit sdma
flush tlb job timeout which is called by ttm_bo_delay_delete. So
to avoid the job submit after fence driver fini, call ttm_bo_lock_delayed_workqueue
before fence driver fini. And also put drm_sched_fini before waiting fence.

Signed-off-by: Emily Deng <Emily.Deng@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c  | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 76d10f1c579b..7f2689d4b86d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3551,6 +3551,7 @@ void amdgpu_device_fini(struct amdgpu_device *adev)
 {
 	dev_info(adev->dev, "amdgpu: finishing device.\n");
 	flush_delayed_work(&adev->delayed_init_work);
+	ttm_bo_lock_delayed_workqueue(&adev->mman.bdev);
 	adev->shutdown = true;
 
 	kfree(adev->pci_state);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index fe2d495d08ab..d07c458c0bed 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -532,6 +532,8 @@ void amdgpu_fence_driver_fini(struct amdgpu_device *adev)
 
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
+		if (!ring->no_scheduler)
+			drm_sched_fini(&ring->sched);
 		r = amdgpu_fence_wait_empty(ring);
 		if (r) {
 			/* no need to trigger GPU reset as we are unloading */
@@ -540,8 +542,7 @@ void amdgpu_fence_driver_fini(struct amdgpu_device *adev)
 		if (ring->fence_drv.irq_src)
 			amdgpu_irq_put(adev, ring->fence_drv.irq_src,
 				       ring->fence_drv.irq_type);
-		if (!ring->no_scheduler)
-			drm_sched_fini(&ring->sched);
+
 		del_timer_sync(&ring->fence_drv.fallback_timer);
 		for (j = 0; j <= ring->fence_drv.num_fences_mask; ++j)
 			dma_fence_put(ring->fence_drv.fences[j]);
-- 
2.30.2

