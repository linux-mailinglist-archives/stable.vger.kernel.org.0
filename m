Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F83246AE2
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbgHQPoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387671AbgHQPnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:43:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 895C320760;
        Mon, 17 Aug 2020 15:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597679025;
        bh=VozttY44Z8540eAyC0imebTNATk727qxGI9C22lCA50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4EkWFN+NRLElsJ6g8lpOP/v1K611DOZI5qWD6vcug4dF8GwqWokOHtV5JP/f0G+k
         XW40kF+Mo54iyew0LxusFFyoI7p5lWmahj4fdR0dk5Fs783Gh4NgGu/yBWcfSKk/aL
         PF5EZYX+if9snnlZrJU+b0g5jW92MNC5h6ytiZ/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Xiao <Jack.Xiao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 071/393] drm/amdgpu: avoid dereferencing a NULL pointer
Date:   Mon, 17 Aug 2020 17:12:01 +0200
Message-Id: <20200817143823.053511581@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143819.579311991@linuxfoundation.org>
References: <20200817143819.579311991@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7531527067dfb..892c1e9a1eb04 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -408,7 +408,9 @@ int amdgpu_fence_driver_start_ring(struct amdgpu_ring *ring,
 		ring->fence_drv.gpu_addr = adev->uvd.inst[ring->me].gpu_addr + index;
 	}
 	amdgpu_fence_write(ring, atomic_read(&ring->fence_drv.last_seq));
-	amdgpu_irq_get(adev, irq_src, irq_type);
+
+	if (irq_src)
+		amdgpu_irq_get(adev, irq_src, irq_type);
 
 	ring->fence_drv.irq_src = irq_src;
 	ring->fence_drv.irq_type = irq_type;
@@ -529,8 +531,9 @@ void amdgpu_fence_driver_fini(struct amdgpu_device *adev)
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
@@ -566,8 +569,9 @@ void amdgpu_fence_driver_suspend(struct amdgpu_device *adev)
 		}
 
 		/* disable the interrupt */
-		amdgpu_irq_put(adev, ring->fence_drv.irq_src,
-			       ring->fence_drv.irq_type);
+		if (ring->fence_drv.irq_src)
+			amdgpu_irq_put(adev, ring->fence_drv.irq_src,
+				       ring->fence_drv.irq_type);
 	}
 }
 
@@ -593,8 +597,9 @@ void amdgpu_fence_driver_resume(struct amdgpu_device *adev)
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



