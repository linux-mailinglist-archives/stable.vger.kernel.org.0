Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A49F240F6D
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgHJTWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729700AbgHJTNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:13:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 924A522D03;
        Mon, 10 Aug 2020 19:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086788;
        bh=oQ0uPvUk3cWTbfw3EQOsapSTZSuYYtxomEmeBV3SuSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AdQFZJlinSY9L7XO5uW8cXvn09gu9UWozP/lVCfD5cJVI+cXCZT98yk7zS8OOWo3F
         Qz4D25KmOJGb8ADQYVgRRseAZjV6r5Hpr2u0ESN5+Zm/R17/PJOtIErTgHSHple/mu
         dhegINubM5ebnsH5w3BRixPC5oJ832/LXq6nCRg4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Xiao <Jack.Xiao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 06/31] drm/amdgpu: avoid dereferencing a NULL pointer
Date:   Mon, 10 Aug 2020 15:12:34 -0400
Message-Id: <20200810191259.3794858-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191259.3794858-1-sashal@kernel.org>
References: <20200810191259.3794858-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Xiao <Jack.Xiao@amd.com>

[ Upstream commit 55611b507fd6453d26030c0c0619fdf0c262766d ]

Check if irq_src is NULL to avoid dereferencing a NULL pointer,
for MES ring is uneccessary to recieve an interrupt notification.

Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index 869ff624b108c..e5e51e4d4f3d8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -396,7 +396,9 @@ int amdgpu_fence_driver_start_ring(struct amdgpu_ring *ring,
 		ring->fence_drv.gpu_addr = adev->uvd.inst[ring->me].gpu_addr + index;
 	}
 	amdgpu_fence_write(ring, atomic_read(&ring->fence_drv.last_seq));
-	amdgpu_irq_get(adev, irq_src, irq_type);
+
+	if (irq_src)
+		amdgpu_irq_get(adev, irq_src, irq_type);
 
 	ring->fence_drv.irq_src = irq_src;
 	ring->fence_drv.irq_type = irq_type;
@@ -508,8 +510,9 @@ void amdgpu_fence_driver_fini(struct amdgpu_device *adev)
 			/* no need to trigger GPU reset as we are unloading */
 			amdgpu_fence_driver_force_completion(ring);
 		}
-		amdgpu_irq_put(adev, ring->fence_drv.irq_src,
-			       ring->fence_drv.irq_type);
+		if (ring->fence_drv.irq_src)
+			amdgpu_irq_put(adev, ring->fence_drv.irq_src,
+				       ring->fence_drv.irq_type);
 		drm_sched_fini(&ring->sched);
 		del_timer_sync(&ring->fence_drv.fallback_timer);
 		for (j = 0; j <= ring->fence_drv.num_fences_mask; ++j)
@@ -545,8 +548,9 @@ void amdgpu_fence_driver_suspend(struct amdgpu_device *adev)
 		}
 
 		/* disable the interrupt */
-		amdgpu_irq_put(adev, ring->fence_drv.irq_src,
-			       ring->fence_drv.irq_type);
+		if (ring->fence_drv.irq_src)
+			amdgpu_irq_put(adev, ring->fence_drv.irq_src,
+				       ring->fence_drv.irq_type);
 	}
 }
 
@@ -572,8 +576,9 @@ void amdgpu_fence_driver_resume(struct amdgpu_device *adev)
 			continue;
 
 		/* enable the interrupt */
-		amdgpu_irq_get(adev, ring->fence_drv.irq_src,
-			       ring->fence_drv.irq_type);
+		if (ring->fence_drv.irq_src)
+			amdgpu_irq_get(adev, ring->fence_drv.irq_src,
+				       ring->fence_drv.irq_type);
 	}
 }
 
-- 
2.25.1

