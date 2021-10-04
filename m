Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF0E420F59
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbhJDNd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236899AbhJDNc0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:32:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 939AF61A08;
        Mon,  4 Oct 2021 13:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353274;
        bh=2JuWJjrGjJKOeFAx2xhPwy4rk5xjUr4qIqgCUTVVo2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNiQX56wEKsRARIBm4n/rprxJ3RW5CQwklRKyjuB6B6r8A0l4kEor/d1POMTAz/fR
         HrnMsojad2YFcLh0TyNmmanyGcsS1eZssRMcF6kPhKgGYjGfY8geLsVZTt5WPOWjc+
         vesRDx4josQB7dYQ9ViKglUCRnxpHN0WAVOI3MkE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Mike Lothian <mike@fireburn.co.uk>,
        Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 031/172] drm/amdgpu: avoid over-handle of fence driver fini in s3 test (v2)
Date:   Mon,  4 Oct 2021 14:51:21 +0200
Message-Id: <20211004125045.972625838@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 067f44c8b4590c3f24d21a037578a478590f2175 ]

In amdgpu_fence_driver_hw_fini, no need to call drm_sched_fini to stop
scheduler in s3 test, otherwise, fence related failure will arrive
after resume. To fix this and for a better clean up, move drm_sched_fini
from fence_hw_fini to fence_sw_fini, as it's part of driver shutdown, and
should never be called in hw_fini.

v2: rename amdgpu_fence_driver_init to amdgpu_fence_driver_sw_init,
to keep sw_init and sw_fini paired.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1668
Fixes: 8d35a2596164c1 ("drm/amdgpu: adjust fence driver enable sequence")
Suggested-by: Christian König <christian.koenig@amd.com>
Tested-by: Mike Lothian <mike@fireburn.co.uk>
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |  5 ++---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c  | 12 +++++++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h   |  4 ++--
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 112add12707d..d3247a5cceb4 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3602,9 +3602,9 @@ int amdgpu_device_init(struct amdgpu_device *adev,
 
 fence_driver_init:
 	/* Fence driver */
-	r = amdgpu_fence_driver_init(adev);
+	r = amdgpu_fence_driver_sw_init(adev);
 	if (r) {
-		dev_err(adev->dev, "amdgpu_fence_driver_init failed\n");
+		dev_err(adev->dev, "amdgpu_fence_driver_sw_init failed\n");
 		amdgpu_vf_error_put(adev, AMDGIM_ERROR_VF_FENCE_INIT_FAIL, 0, 0);
 		goto failed;
 	}
@@ -3944,7 +3944,6 @@ int amdgpu_device_resume(struct drm_device *dev, bool fbcon)
 	}
 	amdgpu_fence_driver_hw_init(adev);
 
-
 	r = amdgpu_device_ip_late_init(adev);
 	if (r)
 		return r;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index 49c5c7331c53..7495911516c2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -498,7 +498,7 @@ int amdgpu_fence_driver_init_ring(struct amdgpu_ring *ring,
 }
 
 /**
- * amdgpu_fence_driver_init - init the fence driver
+ * amdgpu_fence_driver_sw_init - init the fence driver
  * for all possible rings.
  *
  * @adev: amdgpu device pointer
@@ -509,13 +509,13 @@ int amdgpu_fence_driver_init_ring(struct amdgpu_ring *ring,
  * amdgpu_fence_driver_start_ring().
  * Returns 0 for success.
  */
-int amdgpu_fence_driver_init(struct amdgpu_device *adev)
+int amdgpu_fence_driver_sw_init(struct amdgpu_device *adev)
 {
 	return 0;
 }
 
 /**
- * amdgpu_fence_driver_fini - tear down the fence driver
+ * amdgpu_fence_driver_hw_fini - tear down the fence driver
  * for all possible rings.
  *
  * @adev: amdgpu device pointer
@@ -531,8 +531,7 @@ void amdgpu_fence_driver_hw_fini(struct amdgpu_device *adev)
 
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
-		if (!ring->no_scheduler)
-			drm_sched_fini(&ring->sched);
+
 		/* You can't wait for HW to signal if it's gone */
 		if (!drm_dev_is_unplugged(&adev->ddev))
 			r = amdgpu_fence_wait_empty(ring);
@@ -560,6 +559,9 @@ void amdgpu_fence_driver_sw_fini(struct amdgpu_device *adev)
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
 
+		if (!ring->no_scheduler)
+			drm_sched_fini(&ring->sched);
+
 		for (j = 0; j <= ring->fence_drv.num_fences_mask; ++j)
 			dma_fence_put(ring->fence_drv.fences[j]);
 		kfree(ring->fence_drv.fences);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
index 27adffa7658d..9c11ced4312c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
@@ -106,7 +106,6 @@ struct amdgpu_fence_driver {
 	struct dma_fence		**fences;
 };
 
-int amdgpu_fence_driver_init(struct amdgpu_device *adev);
 void amdgpu_fence_driver_force_completion(struct amdgpu_ring *ring);
 
 int amdgpu_fence_driver_init_ring(struct amdgpu_ring *ring,
@@ -115,9 +114,10 @@ int amdgpu_fence_driver_init_ring(struct amdgpu_ring *ring,
 int amdgpu_fence_driver_start_ring(struct amdgpu_ring *ring,
 				   struct amdgpu_irq_src *irq_src,
 				   unsigned irq_type);
+void amdgpu_fence_driver_hw_init(struct amdgpu_device *adev);
 void amdgpu_fence_driver_hw_fini(struct amdgpu_device *adev);
+int amdgpu_fence_driver_sw_init(struct amdgpu_device *adev);
 void amdgpu_fence_driver_sw_fini(struct amdgpu_device *adev);
-void amdgpu_fence_driver_hw_init(struct amdgpu_device *adev);
 int amdgpu_fence_emit(struct amdgpu_ring *ring, struct dma_fence **fence,
 		      unsigned flags);
 int amdgpu_fence_emit_polling(struct amdgpu_ring *ring, uint32_t *s,
-- 
2.33.0



