Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336C32EEED
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbfE3DvI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:51:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732033AbfE3DTs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:48 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32CDF248D3;
        Thu, 30 May 2019 03:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186388;
        bh=rPBCzzUJlptEP951D4yPK4MGsRf7+UEXKPZT7CVSj7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fxrq9Kzx4m8meooccA4mQomjD4B2kc+xRrKEb9NlkZqpLIdck5sGqvVXyRzBxx5DA
         448djDsaIZvytFdPyhhcpwwwkOAJkyB5O+WqdCdxDZJeEbtaGtXwl05vvepX7hRMKk
         7zAvQmqw0tHHcfXwgeBqoEdn5cLNm3GUOZwUueB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Chunming Zhou <david1.zhou@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 122/193] drm/amdgpu: fix old fence check in amdgpu_fence_emit
Date:   Wed, 29 May 2019 20:06:16 -0700
Message-Id: <20190530030505.578069191@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
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
index 333bad7490678..415e9a384799e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -135,8 +135,9 @@ int amdgpu_fence_emit(struct amdgpu_ring *ring, struct dma_fence **f)
 {
 	struct amdgpu_device *adev = ring->adev;
 	struct amdgpu_fence *fence;
-	struct dma_fence *old, **ptr;
+	struct dma_fence __rcu **ptr;
 	uint32_t seq;
+	int r;
 
 	fence = kmem_cache_alloc(amdgpu_fence_slab, GFP_KERNEL);
 	if (fence == NULL)
@@ -152,15 +153,24 @@ int amdgpu_fence_emit(struct amdgpu_ring *ring, struct dma_fence **f)
 			       seq, AMDGPU_FENCE_FLAG_INT);
 
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



