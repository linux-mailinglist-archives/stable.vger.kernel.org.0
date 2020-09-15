Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D24426B41D
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgIOXRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:17:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727233AbgIOOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:39:28 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2D8A23D1F;
        Tue, 15 Sep 2020 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180190;
        bh=UPQXZeCNkXHFtjD2PxRqbIz0d0bL7pyAIvK0EYxJTDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x7/GnugWZHAgoVSLFu7S6W1f4cHEoOTpqCIQ14eBucSSD9b+w59EbogLywNqnt8SM
         UtNjMaOElGEMrW7qDF7cbFP2+AtL7JUw22PCRteFahKxuaqTszH8COjs+fpsrJmWWd
         gA5rSEcAzSUn1OaoxSVXYQIhGBuRLUEP8OF5PsBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.8 143/177] drm/msm: Split the a5xx preemption record
Date:   Tue, 15 Sep 2020 16:13:34 +0200
Message-Id: <20200915140700.512752244@linuxfoundation.org>
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

commit 34221545d2069dc947131f42392fd4cebabe1b39 upstream.

The main a5xx preemption record can be marked as privileged to
protect it from user access but the counters storage needs to be
remain unprivileged. Split the buffers and mark the critical memory
as privileged.

Cc: stable@vger.kernel.org
Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.h     |    1 +
 drivers/gpu/drm/msm/adreno/a5xx_preempt.c |   25 ++++++++++++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.h
@@ -31,6 +31,7 @@ struct a5xx_gpu {
 	struct msm_ringbuffer *next_ring;
 
 	struct drm_gem_object *preempt_bo[MSM_GPU_MAX_RINGS];
+	struct drm_gem_object *preempt_counters_bo[MSM_GPU_MAX_RINGS];
 	struct a5xx_preempt_record *preempt[MSM_GPU_MAX_RINGS];
 	uint64_t preempt_iova[MSM_GPU_MAX_RINGS];
 
--- a/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_preempt.c
@@ -226,19 +226,31 @@ static int preempt_init_ring(struct a5xx
 	struct adreno_gpu *adreno_gpu = &a5xx_gpu->base;
 	struct msm_gpu *gpu = &adreno_gpu->base;
 	struct a5xx_preempt_record *ptr;
-	struct drm_gem_object *bo = NULL;
-	u64 iova = 0;
+	void *counters;
+	struct drm_gem_object *bo = NULL, *counters_bo = NULL;
+	u64 iova = 0, counters_iova = 0;
 
 	ptr = msm_gem_kernel_new(gpu->dev,
 		A5XX_PREEMPT_RECORD_SIZE + A5XX_PREEMPT_COUNTER_SIZE,
-		MSM_BO_UNCACHED, gpu->aspace, &bo, &iova);
+		MSM_BO_UNCACHED | MSM_BO_MAP_PRIV, gpu->aspace, &bo, &iova);
 
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
 
+	/* The buffer to store counters needs to be unprivileged */
+	counters = msm_gem_kernel_new(gpu->dev,
+		A5XX_PREEMPT_COUNTER_SIZE,
+		MSM_BO_UNCACHED, gpu->aspace, &counters_bo, &counters_iova);
+	if (IS_ERR(counters)) {
+		msm_gem_kernel_put(bo, gpu->aspace, true);
+		return PTR_ERR(counters);
+	}
+
 	msm_gem_object_set_name(bo, "preempt");
+	msm_gem_object_set_name(counters_bo, "preempt_counters");
 
 	a5xx_gpu->preempt_bo[ring->id] = bo;
+	a5xx_gpu->preempt_counters_bo[ring->id] = counters_bo;
 	a5xx_gpu->preempt_iova[ring->id] = iova;
 	a5xx_gpu->preempt[ring->id] = ptr;
 
@@ -249,7 +261,7 @@ static int preempt_init_ring(struct a5xx
 	ptr->data = 0;
 	ptr->cntl = MSM_GPU_RB_CNTL_DEFAULT;
 	ptr->rptr_addr = rbmemptr(ring, rptr);
-	ptr->counter = iova + A5XX_PREEMPT_RECORD_SIZE;
+	ptr->counter = counters_iova;
 
 	return 0;
 }
@@ -260,8 +272,11 @@ void a5xx_preempt_fini(struct msm_gpu *g
 	struct a5xx_gpu *a5xx_gpu = to_a5xx_gpu(adreno_gpu);
 	int i;
 
-	for (i = 0; i < gpu->nr_rings; i++)
+	for (i = 0; i < gpu->nr_rings; i++) {
 		msm_gem_kernel_put(a5xx_gpu->preempt_bo[i], gpu->aspace, true);
+		msm_gem_kernel_put(a5xx_gpu->preempt_counters_bo[i],
+			gpu->aspace, true);
+	}
 }
 
 void a5xx_preempt_init(struct msm_gpu *gpu)


