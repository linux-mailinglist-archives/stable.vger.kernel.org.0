Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACC326B5A3
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgIOXsn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727086AbgIOOcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:32:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AB5822BEA;
        Tue, 15 Sep 2020 14:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179841;
        bh=z3VuaGv082dQfs8ogrfrrT40VnM19ZaA0lgMHalf3BE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ka537YzWeYFFrN563G19OZS/E6rM1V4l5Q0M1tu+P07fE7q+VRlqChnAsuY+mqKTc
         ZQ3zSjGeZ+RxBdU1FAqf/P5HvIyPjZ+bHWzlSruT2GFlePJ/vaW6Q+1OccJRGdXhFj
         J24oHMaV8WVvtIcenMBy7pf7Y+Wz1sqe7qFc9/VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 132/132] drm/msm: Disable the RPTR shadow
Date:   Tue, 15 Sep 2020 16:13:54 +0200
Message-Id: <20200915140650.714378261@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140644.037604909@linuxfoundation.org>
References: <20200915140644.037604909@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Crouse <jcrouse@codeaurora.org>

[ Upstream commit f6828e0c4045f03f9cf2df6c2a768102641183f4 ]

Disable the RPTR shadow across all targets. It will be selectively
re-enabled later for targets that need it.

Cc: stable@vger.kernel.org
Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c   |  5 +++++
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c   | 10 +++++++++
 drivers/gpu/drm/msm/adreno/a4xx_gpu.c   | 10 +++++++++
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c   | 11 ++++++++--
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c   |  7 +++++++
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 27 ++-----------------------
 6 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
index 1f83bc18d5008..80f3b1da9fc26 100644
--- a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
@@ -164,6 +164,11 @@ static int a2xx_hw_init(struct msm_gpu *gpu)
 	if (ret)
 		return ret;
 
+	gpu_write(gpu, REG_AXXX_CP_RB_CNTL,
+		MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE);
+
+	gpu_write(gpu, REG_AXXX_CP_RB_BASE, lower_32_bits(gpu->rb[0]->iova));
+
 	/* NOTE: PM4/micro-engine firmware registers look to be the same
 	 * for a2xx and a3xx.. we could possibly push that part down to
 	 * adreno_gpu base class.  Or push both PM4 and PFP but
diff --git a/drivers/gpu/drm/msm/adreno/a3xx_gpu.c b/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
index 5f7e98028eaf4..eeba2deeca1e8 100644
--- a/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
@@ -215,6 +215,16 @@ static int a3xx_hw_init(struct msm_gpu *gpu)
 	if (ret)
 		return ret;
 
+	/*
+	 * Use the default ringbuffer size and block size but disable the RPTR
+	 * shadow
+	 */
+	gpu_write(gpu, REG_AXXX_CP_RB_CNTL,
+		MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE);
+
+	/* Set the ringbuffer address */
+	gpu_write(gpu, REG_AXXX_CP_RB_BASE, lower_32_bits(gpu->rb[0]->iova));
+
 	/* setup access protection: */
 	gpu_write(gpu, REG_A3XX_CP_PROTECT_CTRL, 0x00000007);
 
diff --git a/drivers/gpu/drm/msm/adreno/a4xx_gpu.c b/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
index ab2b752566d81..05cfa81d4c540 100644
--- a/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
@@ -265,6 +265,16 @@ static int a4xx_hw_init(struct msm_gpu *gpu)
 	if (ret)
 		return ret;
 
+	/*
+	 * Use the default ringbuffer size and block size but disable the RPTR
+	 * shadow
+	 */
+	gpu_write(gpu, REG_A4XX_CP_RB_CNTL,
+		MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE);
+
+	/* Set the ringbuffer address */
+	gpu_write(gpu, REG_A4XX_CP_RB_BASE, lower_32_bits(gpu->rb[0]->iova));
+
 	/* Load PM4: */
 	ptr = (uint32_t *)(adreno_gpu->fw[ADRENO_FW_PM4]->data);
 	len = adreno_gpu->fw[ADRENO_FW_PM4]->size / 4;
diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 4a484b06319ff..24b55103bfe00 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -677,14 +677,21 @@ static int a5xx_hw_init(struct msm_gpu *gpu)
 	if (ret)
 		return ret;
 
-	a5xx_preempt_hw_init(gpu);
-
 	a5xx_gpmu_ucode_init(gpu);
 
 	ret = a5xx_ucode_init(gpu);
 	if (ret)
 		return ret;
 
+	/* Set the ringbuffer address */
+	gpu_write64(gpu, REG_A5XX_CP_RB_BASE, REG_A5XX_CP_RB_BASE_HI,
+		gpu->rb[0]->iova);
+
+	gpu_write(gpu, REG_A5XX_CP_RB_CNTL,
+		MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE);
+
+	a5xx_preempt_hw_init(gpu);
+
 	/* Disable the interrupts through the initial bringup stage */
 	gpu_write(gpu, REG_A5XX_RBBM_INT_0_MASK, A5XX_INT_MASK);
 
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index ea073cd9d248e..dae32c6ac2120 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -550,6 +550,13 @@ static int a6xx_hw_init(struct msm_gpu *gpu)
 	if (ret)
 		goto out;
 
+	/* Set the ringbuffer address */
+	gpu_write64(gpu, REG_A6XX_CP_RB_BASE, REG_A6XX_CP_RB_BASE_HI,
+		gpu->rb[0]->iova);
+
+	gpu_write(gpu, REG_A6XX_CP_RB_CNTL,
+		MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE);
+
 	/* Always come up on rb 0 */
 	a6xx_gpu->cur_ring = gpu->rb[0];
 
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 053da39da1cc0..3802ad38c519c 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -354,26 +354,6 @@ int adreno_hw_init(struct msm_gpu *gpu)
 		ring->memptrs->rptr = 0;
 	}
 
-	/*
-	 * Setup REG_CP_RB_CNTL.  The same value is used across targets (with
-	 * the excpetion of A430 that disables the RPTR shadow) - the cacluation
-	 * for the ringbuffer size and block size is moved to msm_gpu.h for the
-	 * pre-processor to deal with and the A430 variant is ORed in here
-	 */
-	adreno_gpu_write(adreno_gpu, REG_ADRENO_CP_RB_CNTL,
-		MSM_GPU_RB_CNTL_DEFAULT |
-		(adreno_is_a430(adreno_gpu) ? AXXX_CP_RB_CNTL_NO_UPDATE : 0));
-
-	/* Setup ringbuffer address - use ringbuffer[0] for GPU init */
-	adreno_gpu_write64(adreno_gpu, REG_ADRENO_CP_RB_BASE,
-		REG_ADRENO_CP_RB_BASE_HI, gpu->rb[0]->iova);
-
-	if (!adreno_is_a430(adreno_gpu)) {
-		adreno_gpu_write64(adreno_gpu, REG_ADRENO_CP_RB_RPTR_ADDR,
-			REG_ADRENO_CP_RB_RPTR_ADDR_HI,
-			rbmemptr(gpu->rb[0], rptr));
-	}
-
 	return 0;
 }
 
@@ -381,11 +361,8 @@ int adreno_hw_init(struct msm_gpu *gpu)
 static uint32_t get_rptr(struct adreno_gpu *adreno_gpu,
 		struct msm_ringbuffer *ring)
 {
-	if (adreno_is_a430(adreno_gpu))
-		return ring->memptrs->rptr = adreno_gpu_read(
-			adreno_gpu, REG_ADRENO_CP_RB_RPTR);
-	else
-		return ring->memptrs->rptr;
+	return ring->memptrs->rptr = adreno_gpu_read(
+		adreno_gpu, REG_ADRENO_CP_RB_RPTR);
 }
 
 struct msm_ringbuffer *adreno_active_ring(struct msm_gpu *gpu)
-- 
2.25.1



