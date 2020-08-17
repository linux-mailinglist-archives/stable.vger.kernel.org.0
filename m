Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6DE9247183
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391009AbgHQS3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388156AbgHQQBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:01:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 628B320829;
        Mon, 17 Aug 2020 16:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680098;
        bh=POih9G7UqkC5Ul1MYzi3N3eD1nRn5F7/aPLt0IzppNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zogNlOEbEwmvDCwc6UTB3H1KB8GPlROBQapTJvzIhxnRS2FuBqnfjwFOP30OLXerW
         VO7VbIXEjqT1ASSBNUCR0DmzMzeKumWDATeDXET2nQTtr59uGuF9Pigi40RJg/xHVA
         2HLUyHxdgGszG8maune5oQenFPFqp0YJ5iWjFeG0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Xiao <Jack.Xiao@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 051/270] drm/amdgpu: avoid dereferencing a NULL pointer
Date:   Mon, 17 Aug 2020 17:14:12 +0200
Message-Id: <20200817143758.319695268@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
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
index 23085b352cf2d..c212d5fc665c6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -404,7 +404,9 @@ int amdgpu_fence_driver_start_ring(struct amdgpu_ring *ring,
 		ring->fence_drv.gpu_addr = adev->uvd.inst[ring->me].gpu_addr + index;
 	}
 	amdgpu_fence_write(ring, atomic_read(&ring->fence_drv.last_seq));
-	amdgpu_irq_get(adev, irq_src, irq_type);
+
+	if (irq_src)
+		amdgpu_irq_get(adev, irq_src, irq_type);
 
 	ring->fence_drv.irq_src = irq_src;
 	ring->fence_drv.irq_type = irq_type;
@@ -539,8 +541,9 @@ void amdgpu_fence_driver_fini(struct amdgpu_device *adev)
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
@@ -576,8 +579,9 @@ void amdgpu_fence_driver_suspend(struct amdgpu_device *adev)
 		}
 
 		/* disable the interrupt */
-		amdgpu_irq_put(adev, ring->fence_drv.irq_src,
-			       ring->fence_drv.irq_type);
+		if (ring->fence_drv.irq_src)
+			amdgpu_irq_put(adev, ring->fence_drv.irq_src,
+				       ring->fence_drv.irq_type);
 	}
 }
 
@@ -603,8 +607,9 @@ void amdgpu_fence_driver_resume(struct amdgpu_device *adev)
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



