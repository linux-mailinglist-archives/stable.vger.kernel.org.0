Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC2F4356D7
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhJUAWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:22:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231222AbhJUAWv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:22:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E1FD611CC;
        Thu, 21 Oct 2021 00:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775636;
        bh=tQn2x1b7CEDjXT4xT5M21SEZ9mXIyPc8lUGX3/VUoxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=omgS/aXzCWchH2SWGwtwEV1dpO8qtQEbLtdPo7IjknEmwEN7dixS2+DVIXY4Xe3Tp
         YVuWc6fyFWBL5IEGnoiOippy/n5dkkKuC/d4NXJbz1Drln9GHD2eLSyalR73t0Cz75
         8WrQS87GpBd7B/JfDusiYf96Ftofh2dBYb3/Exmh+ZEydgCO1uMtw+CMi5ZfsI985X
         fcsGqfZd00GDFoAayMfQ2zkE1sZIj1Q2omnZYntcrCCiMmVQ+Zqao1TEwHe8q0pO7O
         bOJjEupVsujIAncDr+K4XX0REzUsRP7BrJXLdT1ljnnbOPSWxnx1e+ichVwmyjn1t8
         1tTU0PU1w3FXA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        jonathan@marek.ca, jordan@cosmicpenguin.net, eric@anholt.net,
        akhilpo@codeaurora.org, bjorn.andersson@linaro.org,
        saiprakash.ranjan@codeaurora.org, smasetty@codeaurora.org,
        dianders@chromium.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 02/26] drm/msm/a6xx: Serialize GMU communication
Date:   Wed, 20 Oct 2021 20:19:59 -0400
Message-Id: <20211021002023.1128949-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 183b9f9c1b31..64586eb8cda5 100644
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
@@ -1107,6 +1107,19 @@ static int a6xx_hw_init(struct msm_gpu *gpu)
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

