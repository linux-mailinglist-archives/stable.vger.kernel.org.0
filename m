Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654C326B404
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgIOXPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:15:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:49832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727146AbgIOOjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6E323CD3;
        Tue, 15 Sep 2020 14:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180195;
        bh=aOHR2M8CJp2NVrFtoeWaY6SChz2+vCkNgOvV05WKhFE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x5ckX19R2gmSfbrQmqxtKGP9Io0fXJWhuwJNwdpaOjGzYe79pKLdeSv95YfviXnmk
         yWXTd1MT0yC8WsYMaVd6fhKwnsqa+/yQlU9N6VvoF7Kz4nHuXp2AXUluk/gulMzqwp
         h6sr1TGpF3YCwXK7OZTdDqWo7rsD+gnKN6TT5kzA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.8 145/177] drm/msm: Disable the RPTR shadow
Date:   Tue, 15 Sep 2020 16:13:36 +0200
Message-Id: <20200915140700.610106790@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Crouse <jcrouse@codeaurora.org>

commit f6828e0c4045f03f9cf2df6c2a768102641183f4 upstream.

Disable the RPTR shadow across all targets. It will be selectively
re-enabled later for targets that need it.

Cc: stable@vger.kernel.org
Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/msm/adreno/a2xx_gpu.c   |    5 +++++
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c   |   10 ++++++++++
 drivers/gpu/drm/msm/adreno/a4xx_gpu.c   |   10 ++++++++++
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c   |   11 +++++++++--
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c   |    7 +++++++
 drivers/gpu/drm/msm/adreno/adreno_gpu.c |   27 ++-------------------------
 6 files changed, 43 insertions(+), 27 deletions(-)

--- a/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a2xx_gpu.c
@@ -164,6 +164,11 @@ static int a2xx_hw_init(struct msm_gpu *
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
--- a/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a3xx_gpu.c
@@ -211,6 +211,16 @@ static int a3xx_hw_init(struct msm_gpu *
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
 
--- a/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a4xx_gpu.c
@@ -267,6 +267,16 @@ static int a4xx_hw_init(struct msm_gpu *
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
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -702,8 +702,6 @@ static int a5xx_hw_init(struct msm_gpu *
 	if (ret)
 		return ret;
 
-	a5xx_preempt_hw_init(gpu);
-
 	if (!adreno_is_a510(adreno_gpu))
 		a5xx_gpmu_ucode_init(gpu);
 
@@ -711,6 +709,15 @@ static int a5xx_hw_init(struct msm_gpu *
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
 
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -557,6 +557,13 @@ static int a6xx_hw_init(struct msm_gpu *
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
 
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -400,26 +400,6 @@ int adreno_hw_init(struct msm_gpu *gpu)
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
 
@@ -427,11 +407,8 @@ int adreno_hw_init(struct msm_gpu *gpu)
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


