Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E751237842D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbhEJKu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:50:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232270AbhEJKrp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:47:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 237CE619B2;
        Mon, 10 May 2021 10:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643057;
        bh=Lw6vE4UcBrY7WNNZ9dvZ6+mazSAp9vuX80l+b5VsBCo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hIOoqqQhzFFC4JdE08I7lHIlcNd2Oo9JOdIeM0C1Ub7OyxcQ0zJY9ZYjNcbiKQSm6
         lzn5nIyIP/QWQGnt2p/iSx8htXKIEMe8Lm0jDpFkuK+q+5qWDt5Bx8gFDybDsH0RXW
         ufR9p9Z7wF2WODcBKLbjyACoEVwlYUwBcQ2ge3HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Emily Deng <Emily.Deng@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/299] drm/amdgpu: Fix some unload driver issues
Date:   Mon, 10 May 2021 12:18:42 +0200
Message-Id: <20210510102009.105715197@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



