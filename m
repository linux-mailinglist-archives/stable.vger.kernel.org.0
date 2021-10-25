Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FD443A323
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237458AbhJYT4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239253AbhJYTy1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:54:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25B5861163;
        Mon, 25 Oct 2021 19:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191108;
        bh=YlLOo1SdaAI0dcuyRRFV25nzTqTvN0RIqfp2YK18ffQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRf/NklGVLwCsvAH0vzoyAGxYd0hcxBw2EKajZd0pWCXrj0bncOx6IE3LFuuV+orP
         A1XSBpkce+2yJMkbhKKgEmYPWtO7oQ23WQaGCeDHAAL8MYqPDNsMc14AaiWcwtUo/x
         nVY2Is7O3q9/fDzJhqGSZJR7uwkCDAwB9Hky75ZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 126/169] drm/msm/a6xx: Serialize GMU communication
Date:   Mon, 25 Oct 2021 21:15:07 +0200
Message-Id: <20211025191033.728874755@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit f6f59072e821901d96c791864a07d57d8ec8d312 ]

I've seen some crashes in our crash reporting that *look* like multiple
threads stomping on each other while communicating with GMU.  So wrap
all those paths in a lock.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c |  6 ++++
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h |  3 ++
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 40 +++++++++++++++++++++++----
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index b349692219b7..c95985792076 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -296,6 +296,8 @@ int a6xx_gmu_set_oob(struct a6xx_gmu *gmu, enum a6xx_gmu_oob_state state)
 	u32 val;
 	int request, ack;
 
+	WARN_ON_ONCE(!mutex_is_locked(&gmu->lock));
+
 	if (state >= ARRAY_SIZE(a6xx_gmu_oob_bits))
 		return -EINVAL;
 
@@ -337,6 +339,8 @@ void a6xx_gmu_clear_oob(struct a6xx_gmu *gmu, enum a6xx_gmu_oob_state state)
 {
 	int bit;
 
+	WARN_ON_ONCE(!mutex_is_locked(&gmu->lock));
+
 	if (state >= ARRAY_SIZE(a6xx_gmu_oob_bits))
 		return;
 
@@ -1478,6 +1482,8 @@ int a6xx_gmu_init(struct a6xx_gpu *a6xx_gpu, struct device_node *node)
 	if (!pdev)
 		return -ENODEV;
 
+	mutex_init(&gmu->lock);
+
 	gmu->dev = &pdev->dev;
 
 	of_dma_configure(gmu->dev, node, true);
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.h b/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
index 71dfa60070cc..19c1a0ddee7a 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
@@ -44,6 +44,9 @@ struct a6xx_gmu_bo {
 struct a6xx_gmu {
 	struct device *dev;
 
+	/* For serializing communication with the GMU: */
+	struct mutex lock;
+
 	struct msm_gem_address_space *aspace;
 
 	void * __iomem mmio;
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 1b3519b821a3..91c5c6709b6c 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -859,7 +859,7 @@ static int a6xx_zap_shader_init(struct msm_gpu *gpu)
 	  A6XX_RBBM_INT_0_MASK_UCHE_OOB_ACCESS | \
 	  A6XX_RBBM_INT_0_MASK_UCHE_TRAP_INTR)
 
-static int a6xx_hw_init(struct msm_gpu *gpu)
+static int hw_init(struct msm_gpu *gpu)
 {
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
 	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
@@ -1107,6 +1107,19 @@ out:
 	return ret;
 }
 
+static int a6xx_hw_init(struct msm_gpu *gpu)
+{
+	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
+	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
+	int ret;
+
+	mutex_lock(&a6xx_gpu->gmu.lock);
+	ret = hw_init(gpu);
+	mutex_unlock(&a6xx_gpu->gmu.lock);
+
+	return ret;
+}
+
 static void a6xx_dump(struct msm_gpu *gpu)
 {
 	DRM_DEV_INFO(&gpu->pdev->dev, "status:   %08x\n",
@@ -1481,7 +1494,9 @@ static int a6xx_pm_resume(struct msm_gpu *gpu)
 
 	trace_msm_gpu_resume(0);
 
+	mutex_lock(&a6xx_gpu->gmu.lock);
 	ret = a6xx_gmu_resume(a6xx_gpu);
+	mutex_unlock(&a6xx_gpu->gmu.lock);
 	if (ret)
 		return ret;
 
@@ -1504,7 +1519,9 @@ static int a6xx_pm_suspend(struct msm_gpu *gpu)
 
 	devfreq_suspend_device(gpu->devfreq.devfreq);
 
+	mutex_lock(&a6xx_gpu->gmu.lock);
 	ret = a6xx_gmu_stop(a6xx_gpu);
+	mutex_unlock(&a6xx_gpu->gmu.lock);
 	if (ret)
 		return ret;
 
@@ -1519,18 +1536,19 @@ static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
 {
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
 	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
-	static DEFINE_MUTEX(perfcounter_oob);
 
-	mutex_lock(&perfcounter_oob);
+	mutex_lock(&a6xx_gpu->gmu.lock);
 
 	/* Force the GPU power on so we can read this register */
 	a6xx_gmu_set_oob(&a6xx_gpu->gmu, GMU_OOB_PERFCOUNTER_SET);
 
 	*value = gpu_read64(gpu, REG_A6XX_CP_ALWAYS_ON_COUNTER_LO,
-		REG_A6XX_CP_ALWAYS_ON_COUNTER_HI);
+			    REG_A6XX_CP_ALWAYS_ON_COUNTER_HI);
 
 	a6xx_gmu_clear_oob(&a6xx_gpu->gmu, GMU_OOB_PERFCOUNTER_SET);
-	mutex_unlock(&perfcounter_oob);
+
+	mutex_unlock(&a6xx_gpu->gmu.lock);
+
 	return 0;
 }
 
@@ -1594,6 +1612,16 @@ static unsigned long a6xx_gpu_busy(struct msm_gpu *gpu)
 	return (unsigned long)busy_time;
 }
 
+void a6xx_gpu_set_freq(struct msm_gpu *gpu, struct dev_pm_opp *opp)
+{
+	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
+	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
+
+	mutex_lock(&a6xx_gpu->gmu.lock);
+	a6xx_gmu_set_freq(gpu, opp);
+	mutex_unlock(&a6xx_gpu->gmu.lock);
+}
+
 static struct msm_gem_address_space *
 a6xx_create_address_space(struct msm_gpu *gpu, struct platform_device *pdev)
 {
@@ -1740,7 +1768,7 @@ static const struct adreno_gpu_funcs funcs = {
 #endif
 		.gpu_busy = a6xx_gpu_busy,
 		.gpu_get_freq = a6xx_gmu_get_freq,
-		.gpu_set_freq = a6xx_gmu_set_freq,
+		.gpu_set_freq = a6xx_gpu_set_freq,
 #if defined(CONFIG_DRM_MSM_GPU_STATE)
 		.gpu_state_get = a6xx_gpu_state_get,
 		.gpu_state_put = a6xx_gpu_state_put,
-- 
2.33.0



