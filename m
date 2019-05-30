Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 587E42F5B8
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbfE3DLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:11:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727641AbfE3DLJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:09 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B567E244B0;
        Thu, 30 May 2019 03:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185868;
        bh=uehieXudrxU2deCpWjUOTsxJYwDki7icIgGbHkm1yKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+Wck8IvwJJfxzFrYHROqUhyqEHq+sl2zn+8Ort7s2iDrI7PKVQyQPm6GBgU2g7uW
         Ti2kwW508ePGV4QFTOs2ZttBg/twL1n5+hh1bJWeFhh434cKYiXyIFh6a7sAJFjnpn
         gBDPmoDnJa61lACrZA1YcN3zIy/kcLq48rj2P0FY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chunming Zhou <david1.zhou@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 209/405] drm/amdgpu: fix old fence check in amdgpu_fence_emit
Date:   Wed, 29 May 2019 20:03:27 -0700
Message-Id: <20190530030551.699232758@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3d2aca8c8620346abdba96c6300d2c0b90a1d0cc ]

We don't hold a reference to the old fence, so it can go away
any time we are waiting for it to signal.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Chunming Zhou <david1.zhou@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c | 24 ++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index ee47c11e92ce7..4dee2326b29c3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -136,8 +136,9 @@ int amdgpu_fence_emit(struct amdgpu_ring *ring, struct dma_fence **f,
 {
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_fence *fence;
-	struct dma_fence *old, **ptr;
+	struct dma_fence __rcu **ptr;
 	uint32_t seq;
+	int r;
 
 	fence = kmem_cache_alloc(amdgpu_fence_slab, GFP_KERNEL);
 	if (fence == NULL)
@@ -153,15 +154,24 @@ int amdgpu_fence_emit(struct amdgpu_ring *ring, struct dma_fence **f,
 			       seq, flags | AMDGPU_FENCE_FLAG_INT);
 
 	ptr = &ring->fence_drv.fences[seq & ring->fence_drv.num_fences_mask];
+	if (unlikely(rcu_dereference_protected(*ptr, 1))) {
+		struct dma_fence *old;
+
+		rcu_read_lock();
+		old = dma_fence_get_rcu_safe(ptr);
+		rcu_read_unlock();
+
+		if (old) {
+			r = dma_fence_wait(old, false);
+			dma_fence_put(old);
+			if (r)
+				return r;
+		}
+	}
+
 	/* This function can't be called concurrently anyway, otherwise
 	 * emitting the fence would mess up the hardware ring buffer.
 	 */
-	old = rcu_dereference_protected(*ptr, 1);
-	if (old && !dma_fence_is_signaled(old)) {
-		DRM_INFO("rcu slot is busy\n");
-		dma_fence_wait(old, false);
-	}
-
 	rcu_assign_pointer(*ptr, dma_fence_get(&fence->base));
 
 	*f = &fence->base;
-- 
2.20.1



