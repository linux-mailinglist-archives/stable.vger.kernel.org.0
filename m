Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06EA371AD9
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 18:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhECQlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232230AbhECQjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:39:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92839613C0;
        Mon,  3 May 2021 16:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620059848;
        bh=zisYVwtsztPK++A8xWpmSiF6PmP6FZtwWVHSHAkye+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kj2bTcVYKOWIVL2kNzaDHZyTm1qILbbOVEaNIPUJfMyG3RmfQrDhqqDNw9JZlP1dN
         ck4P2Vsi7e1IpB49Qdrsxbm82vMnKF7ssYLGoDEoZQKEogUsXIiPN/DRcBApaAp3e7
         nTIU2pXim9SmZIz7SpK7TDglzIqo9eMfVeBvzAXtobQ1JJiEksmei3NixY/Xwcf2EQ
         onsgZlyEnsqPKHCoXFgq2205VThshaO1R5nhiBJ6lflIeq1ho9zUWJM7aZVURWQBI5
         S5RVKlNX7hasT+nSC4Kq4ieHAQgAy6l8r5/Pv3nxN3MjcQaefILG7HFgjhpAVKaTqF
         GORTWGNdekBSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emily Deng <Emily.Deng@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 018/115] drm/amdgpu: Fix some unload driver issues
Date:   Mon,  3 May 2021 12:35:22 -0400
Message-Id: <20210503163700.2852194-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503163700.2852194-1-sashal@kernel.org>
References: <20210503163700.2852194-1-sashal@kernel.org>
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
index eacfca776249..ccf30782e491 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3579,6 +3579,7 @@ void amdgpu_device_fini(struct amdgpu_device *adev)
 {
 	dev_info(adev->dev, "amdgpu: finishing device.\n");
 	flush_delayed_work(&adev->delayed_init_work);
+	ttm_bo_lock_delayed_workqueue(&adev->mman.bdev);
 	adev->shutdown = true;
 
 	kfree(adev->pci_state);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index d56f4023ebb3..7e8e46c39dbd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -533,6 +533,8 @@ void amdgpu_fence_driver_fini(struct amdgpu_device *adev)
 
 		if (!ring || !ring->fence_drv.initialized)
 			continue;
+		if (!ring->no_scheduler)
+			drm_sched_fini(&ring->sched);
 		r = amdgpu_fence_wait_empty(ring);
 		if (r) {
 			/* no need to trigger GPU reset as we are unloading */
@@ -541,8 +543,7 @@ void amdgpu_fence_driver_fini(struct amdgpu_device *adev)
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

