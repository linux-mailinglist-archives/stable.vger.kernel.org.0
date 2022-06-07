Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00290541C08
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382726AbiFGV4B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383739AbiFGVxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:53:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C874D22C48B;
        Tue,  7 Jun 2022 12:12:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5237EB823AF;
        Tue,  7 Jun 2022 19:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B03C34115;
        Tue,  7 Jun 2022 19:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629122;
        bh=RAbyR8lcKwGS93uCxn7jnkMM8Vy8tx5E20kAtNoDV8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOazPLTjwkRmd3MLv8FD+0wW9aul2xTJLLCc5rSRCE+iQoYsIB76JybJKrGox++Sg
         kE/lwv2ZJQ6pqyWw4M9PITxNu4dVtmLyp6Eiws1waDx0lev6VlyFoy8Hv16sIqUfZs
         ejPYsa9YJVkGKM08A/PeYFDXmO25TVLChiaD7bkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chia-I Wu <olvaffe@gmail.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 576/879] drm/msm: simplify gpu_busy callback
Date:   Tue,  7 Jun 2022 19:01:34 +0200
Message-Id: <20220607165019.573642522@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit 15c411980bacddf294452fd1cf7308b14f3f8c63 ]

Move tracking and busy time calculation to msm_devfreq_get_dev_status.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Cc: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/20220416003314.59211-2-olvaffe@gmail.com
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 19 ++++++----------
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 15 +++++--------
 drivers/gpu/drm/msm/msm_gpu.h         |  9 +++-----
 drivers/gpu/drm/msm/msm_gpu_devfreq.c | 32 ++++++++++++++++++++++-----
 4 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 407f50a15faa..217615e0e850 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1662,28 +1662,23 @@ static struct msm_ringbuffer *a5xx_active_ring(struct msm_gpu *gpu)
 	return a5xx_gpu->cur_ring;
 }
 
-static unsigned long a5xx_gpu_busy(struct msm_gpu *gpu)
+static u64 a5xx_gpu_busy(struct msm_gpu *gpu, unsigned long *out_sample_rate)
 {
-	u64 busy_cycles, busy_time;
+	u64 busy_cycles;
 
 	/* Only read the gpu busy if the hardware is already active */
-	if (pm_runtime_get_if_in_use(&gpu->pdev->dev) == 0)
+	if (pm_runtime_get_if_in_use(&gpu->pdev->dev) == 0) {
+		*out_sample_rate = 1;
 		return 0;
+	}
 
 	busy_cycles = gpu_read64(gpu, REG_A5XX_RBBM_PERFCTR_RBBM_0_LO,
 			REG_A5XX_RBBM_PERFCTR_RBBM_0_HI);
-
-	busy_time = busy_cycles - gpu->devfreq.busy_cycles;
-	do_div(busy_time, clk_get_rate(gpu->core_clk) / 1000000);
-
-	gpu->devfreq.busy_cycles = busy_cycles;
+	*out_sample_rate = clk_get_rate(gpu->core_clk);
 
 	pm_runtime_put(&gpu->pdev->dev);
 
-	if (WARN_ON(busy_time > ~0LU))
-		return ~0LU;
-
-	return (unsigned long)busy_time;
+	return busy_cycles;
 }
 
 static uint32_t a5xx_get_rptr(struct msm_gpu *gpu, struct msm_ringbuffer *ring)
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index a8f6d73197b1..40fb92becc78 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1649,12 +1649,14 @@ static void a6xx_destroy(struct msm_gpu *gpu)
 	kfree(a6xx_gpu);
 }
 
-static unsigned long a6xx_gpu_busy(struct msm_gpu *gpu)
+static u64 a6xx_gpu_busy(struct msm_gpu *gpu, unsigned long *out_sample_rate)
 {
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
 	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
-	u64 busy_cycles, busy_time;
+	u64 busy_cycles;
 
+	/* 19.2MHz */
+	*out_sample_rate = 19200000;
 
 	/* Only read the gpu busy if the hardware is already active */
 	if (pm_runtime_get_if_in_use(a6xx_gpu->gmu.dev) == 0)
@@ -1664,17 +1666,10 @@ static unsigned long a6xx_gpu_busy(struct msm_gpu *gpu)
 			REG_A6XX_GMU_CX_GMU_POWER_COUNTER_XOCLK_0_L,
 			REG_A6XX_GMU_CX_GMU_POWER_COUNTER_XOCLK_0_H);
 
-	busy_time = (busy_cycles - gpu->devfreq.busy_cycles) * 10;
-	do_div(busy_time, 192);
-
-	gpu->devfreq.busy_cycles = busy_cycles;
 
 	pm_runtime_put(a6xx_gpu->gmu.dev);
 
-	if (WARN_ON(busy_time > ~0LU))
-		return ~0LU;
-
-	return (unsigned long)busy_time;
+	return busy_cycles;
 }
 
 static void a6xx_gpu_set_freq(struct msm_gpu *gpu, struct dev_pm_opp *opp)
diff --git a/drivers/gpu/drm/msm/msm_gpu.h b/drivers/gpu/drm/msm/msm_gpu.h
index 02419f2ca2bc..389c6dab751b 100644
--- a/drivers/gpu/drm/msm/msm_gpu.h
+++ b/drivers/gpu/drm/msm/msm_gpu.h
@@ -62,7 +62,7 @@ struct msm_gpu_funcs {
 	/* for generation specific debugfs: */
 	void (*debugfs_init)(struct msm_gpu *gpu, struct drm_minor *minor);
 #endif
-	unsigned long (*gpu_busy)(struct msm_gpu *gpu);
+	u64 (*gpu_busy)(struct msm_gpu *gpu, unsigned long *out_sample_rate);
 	struct msm_gpu_state *(*gpu_state_get)(struct msm_gpu *gpu);
 	int (*gpu_state_put)(struct msm_gpu_state *state);
 	unsigned long (*gpu_get_freq)(struct msm_gpu *gpu);
@@ -106,11 +106,8 @@ struct msm_gpu_devfreq {
 	struct dev_pm_qos_request boost_freq;
 
 	/**
-	 * busy_cycles:
-	 *
-	 * Used by implementation of gpu->gpu_busy() to track the last
-	 * busy counter value, for calculating elapsed busy cycles since
-	 * last sampling period.
+	 * busy_cycles: Last busy counter value, for calculating elapsed busy
+	 * cycles since last sampling period.
 	 */
 	u64 busy_cycles;
 
diff --git a/drivers/gpu/drm/msm/msm_gpu_devfreq.c b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
index 12641616acd3..d2b4c646a0ae 100644
--- a/drivers/gpu/drm/msm/msm_gpu_devfreq.c
+++ b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
@@ -49,18 +49,38 @@ static unsigned long get_freq(struct msm_gpu *gpu)
 	return clk_get_rate(gpu->core_clk);
 }
 
-static int msm_devfreq_get_dev_status(struct device *dev,
+static void get_raw_dev_status(struct msm_gpu *gpu,
 		struct devfreq_dev_status *status)
 {
-	struct msm_gpu *gpu = dev_to_gpu(dev);
+	struct msm_gpu_devfreq *df = &gpu->devfreq;
+	u64 busy_cycles, busy_time;
+	unsigned long sample_rate;
 	ktime_t time;
 
 	status->current_frequency = get_freq(gpu);
-	status->busy_time = gpu->funcs->gpu_busy(gpu);
-
+	busy_cycles = gpu->funcs->gpu_busy(gpu, &sample_rate);
 	time = ktime_get();
-	status->total_time = ktime_us_delta(time, gpu->devfreq.time);
-	gpu->devfreq.time = time;
+
+	busy_time = busy_cycles - df->busy_cycles;
+	status->total_time = ktime_us_delta(time, df->time);
+
+	df->busy_cycles = busy_cycles;
+	df->time = time;
+
+	busy_time *= USEC_PER_SEC;
+	do_div(busy_time, sample_rate);
+	if (WARN_ON(busy_time > ~0LU))
+		busy_time = ~0LU;
+
+	status->busy_time = busy_time;
+}
+
+static int msm_devfreq_get_dev_status(struct device *dev,
+		struct devfreq_dev_status *status)
+{
+	struct msm_gpu *gpu = dev_to_gpu(dev);
+
+	get_raw_dev_status(gpu, status);
 
 	return 0;
 }
-- 
2.35.1



