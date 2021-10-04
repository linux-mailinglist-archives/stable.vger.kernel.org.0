Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E5D420F57
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237079AbhJDNd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237426AbhJDNcO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:32:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 343316321F;
        Mon,  4 Oct 2021 13:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353271;
        bh=Xy3oE2Xq3WAjsrr4EQP0eQ6UUM3UMVsrmCQJxRcWtsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kTzT8KsksU2I+dRPUiycVgdxnZpNh1lMiKztevfum6p75LHEI4Fd8k/Ajv/Uq/V/E
         mIUD3ywxe7TvUGE/iZxkx/kG9YpW1tSZQnCUAtwvak6vBsA3Pz2jxNzrTvUTvjPTz3
         jSHpdw6T1fJEFmM1YmsriFuT6ZGVNUYPB/dJfoyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Likun Gao <Likun.Gao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 030/172] drm/amdgpu: adjust fence driver enable sequence
Date:   Mon,  4 Oct 2021 14:51:20 +0200
Message-Id: <20211004125045.941117273@linuxfoundation.org>
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

From: Likun Gao <Likun.Gao@amd.com>

[ Upstream commit 8d35a2596164c1c9d34d4656fd42b445cd1e247f ]

Fence driver was enabled per ring when sw init on per IP block before.
Change to enable all the fence driver at the same time after
amdgpu_device_ip_init finished.
Rename some function related to fence to make it reasonable for read.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 10 +++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c  | 44 +++-------------------
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h   |  7 ++--
 3 files changed, 14 insertions(+), 47 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 7b42636fc7dc..112add12707d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3631,6 +3631,8 @@ fence_driver_init:
 		goto release_ras_con;
 	}
 
+	amdgpu_fence_driver_hw_init(adev);
+
 	dev_info(adev->dev,
 		"SE %d, SH per SE %d, CU per SH %d, active_cu_number %d\n",
 			adev->gfx.config.max_shader_engines,
@@ -3798,7 +3800,7 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 		else
 			drm_atomic_helper_shutdown(adev_to_drm(adev));
 	}
-	amdgpu_fence_driver_fini_hw(adev);
+	amdgpu_fence_driver_hw_fini(adev);
 
 	if (adev->pm_sysfs_en)
 		amdgpu_pm_sysfs_fini(adev);
@@ -3820,7 +3822,7 @@ void amdgpu_device_fini_hw(struct amdgpu_device *adev)
 void amdgpu_device_fini_sw(struct amdgpu_device *adev)
 {
 	amdgpu_device_ip_fini(adev);
-	amdgpu_fence_driver_fini_sw(adev);
+	amdgpu_fence_driver_sw_fini(adev);
 	release_firmware(adev->firmware.gpu_info_fw);
 	adev->firmware.gpu_info_fw = NULL;
 	adev->accel_working = false;
@@ -3895,7 +3897,7 @@ int amdgpu_device_suspend(struct drm_device *dev, bool fbcon)
 	/* evict vram memory */
 	amdgpu_bo_evict_vram(adev);
 
-	amdgpu_fence_driver_suspend(adev);
+	amdgpu_fence_driver_hw_fini(adev);
 
 	amdgpu_device_ip_suspend_phase2(adev);
 	/* evict remaining vram memory
@@ -3940,7 +3942,7 @@ int amdgpu_device_resume(struct drm_device *dev, bool fbcon)
 		dev_err(adev->dev, "amdgpu_device_ip_resume failed (%d).\n", r);
 		return r;
 	}
-	amdgpu_fence_driver_resume(adev);
+	amdgpu_fence_driver_hw_init(adev);
 
 
 	r = amdgpu_device_ip_late_init(adev);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
index 72d9b92b1754..49c5c7331c53 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_fence.c
@@ -417,9 +417,6 @@ int amdgpu_fence_driver_start_ring(struct amdgpu_ring *ring,
 	}
 	amdgpu_fence_write(ring, atomic_read(&ring->fence_drv.last_seq));
 
-	if (irq_src)
-		amdgpu_irq_get(adev, irq_src, irq_type);
-
 	ring->fence_drv.irq_src = irq_src;
 	ring->fence_drv.irq_type = irq_type;
 	ring->fence_drv.initialized = true;
@@ -525,7 +522,7 @@ int amdgpu_fence_driver_init(struct amdgpu_device *adev)
  *
  * Tear down the fence driver for all possible rings (all asics).
  */
-void amdgpu_fence_driver_fini_hw(struct amdgpu_device *adev)
+void amdgpu_fence_driver_hw_fini(struct amdgpu_device *adev)
 {
 	int i, r;
 
@@ -553,7 +550,7 @@ void amdgpu_fence_driver_fini_hw(struct amdgpu_device *adev)
 	}
 }
 
-void amdgpu_fence_driver_fini_sw(struct amdgpu_device *adev)
+void amdgpu_fence_driver_sw_fini(struct amdgpu_device *adev)
 {
 	unsigned int i, j;
 
@@ -572,49 +569,18 @@ void amdgpu_fence_driver_fini_sw(struct amdgpu_device *adev)
 }
 
 /**
- * amdgpu_fence_driver_suspend - suspend the fence driver
- * for all possible rings.
- *
- * @adev: amdgpu device pointer
- *
- * Suspend the fence driver for all possible rings (all asics).
- */
-void amdgpu_fence_driver_suspend(struct amdgpu_device *adev)
-{
-	int i, r;
-
-	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {
-		struct amdgpu_ring *ring = adev->rings[i];
-		if (!ring || !ring->fence_drv.initialized)
-			continue;
-
-		/* wait for gpu to finish processing current batch */
-		r = amdgpu_fence_wait_empty(ring);
-		if (r) {
-			/* delay GPU reset to resume */
-			amdgpu_fence_driver_force_completion(ring);
-		}
-
-		/* disable the interrupt */
-		if (ring->fence_drv.irq_src)
-			amdgpu_irq_put(adev, ring->fence_drv.irq_src,
-				       ring->fence_drv.irq_type);
-	}
-}
-
-/**
- * amdgpu_fence_driver_resume - resume the fence driver
+ * amdgpu_fence_driver_hw_init - enable the fence driver
  * for all possible rings.
  *
  * @adev: amdgpu device pointer
  *
- * Resume the fence driver for all possible rings (all asics).
+ * Enable the fence driver for all possible rings (all asics).
  * Not all asics have all rings, so each asic will only
  * start the fence driver on the rings it has using
  * amdgpu_fence_driver_start_ring().
  * Returns 0 for success.
  */
-void amdgpu_fence_driver_resume(struct amdgpu_device *adev)
+void amdgpu_fence_driver_hw_init(struct amdgpu_device *adev)
 {
 	int i;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
index e7d3d0dbdd96..27adffa7658d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.h
@@ -107,8 +107,6 @@ struct amdgpu_fence_driver {
 };
 
 int amdgpu_fence_driver_init(struct amdgpu_device *adev);
-void amdgpu_fence_driver_fini_hw(struct amdgpu_device *adev);
-void amdgpu_fence_driver_fini_sw(struct amdgpu_device *adev);
 void amdgpu_fence_driver_force_completion(struct amdgpu_ring *ring);
 
 int amdgpu_fence_driver_init_ring(struct amdgpu_ring *ring,
@@ -117,8 +115,9 @@ int amdgpu_fence_driver_init_ring(struct amdgpu_ring *ring,
 int amdgpu_fence_driver_start_ring(struct amdgpu_ring *ring,
 				   struct amdgpu_irq_src *irq_src,
 				   unsigned irq_type);
-void amdgpu_fence_driver_suspend(struct amdgpu_device *adev);
-void amdgpu_fence_driver_resume(struct amdgpu_device *adev);
+void amdgpu_fence_driver_hw_fini(struct amdgpu_device *adev);
+void amdgpu_fence_driver_sw_fini(struct amdgpu_device *adev);
+void amdgpu_fence_driver_hw_init(struct amdgpu_device *adev);
 int amdgpu_fence_emit(struct amdgpu_ring *ring, struct dma_fence **fence,
 		      unsigned flags);
 int amdgpu_fence_emit_polling(struct amdgpu_ring *ring, uint32_t *s,
-- 
2.33.0



