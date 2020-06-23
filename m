Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DD3205FA3
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391543AbgFWUe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:34:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391540AbgFWUe1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:34:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BBA7206C3;
        Tue, 23 Jun 2020 20:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944467;
        bh=4tyMlFgs0n6T8h33O2zuVSoue6oR5PGOWFBf8TqmLko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwH3f2ojNPMnQi+PfFmKBdz1OcO+v+LpFd9zI9q+9lo0rhM3u8Ms175arlkpPa2JL
         RXhaeOdM4cf5OL2aRP2ynKEPssZlIohkyBV4D82E6wlB4AKEeU0d4o1mT1ESLip0XH
         4YSN0FEu7yYgkb806e84GqZJUWKBP66vBQoA5ZMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.4 298/314] drm/msm: Check for powered down HW in the devfreq callbacks
Date:   Tue, 23 Jun 2020 21:58:13 +0200
Message-Id: <20200623195353.209141599@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Crouse <jcrouse@codeaurora.org>

commit eadf79286a4badebc95af7061530bdb50a7e6f38 upstream.

Writing to the devfreq sysfs nodes while the GPU is powered down can
result in a system crash (on a5xx) or a nasty GMU error (on a6xx):

 $ /sys/class/devfreq/5000000.gpu# echo 500000000 > min_freq
  [  104.841625] platform 506a000.gmu: [drm:a6xx_gmu_set_oob]
	*ERROR* Timeout waiting for GMU OOB set GPU_DCVS: 0x0

Despite the fact that we carefully try to suspend the devfreq device when
the hardware is powered down there are lots of holes in the governors that
don't check for the suspend state and blindly call into the devfreq
callbacks that end up triggering hardware reads in the GPU driver.

Call pm_runtime_get_if_in_use() in the gpu_busy() and gpu_set_freq()
callbacks to skip the hardware access if it isn't active.

v3: Only check pm_runtime_get_if_in_use() for == 0 per Eric Anholt
v2: Use pm_runtime_get_if_in_use() per Eric Anholt

Cc: stable@vger.kernel.org
Reviewed-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c |    6 ++++++
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c |    8 ++++++++
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c |    7 +++++++
 3 files changed, 21 insertions(+)

--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1359,6 +1359,10 @@ static unsigned long a5xx_gpu_busy(struc
 {
 	u64 busy_cycles, busy_time;
 
+	/* Only read the gpu busy if the hardware is already active */
+	if (pm_runtime_get_if_in_use(&gpu->pdev->dev) == 0)
+		return 0;
+
 	busy_cycles = gpu_read64(gpu, REG_A5XX_RBBM_PERFCTR_RBBM_0_LO,
 			REG_A5XX_RBBM_PERFCTR_RBBM_0_HI);
 
@@ -1367,6 +1371,8 @@ static unsigned long a5xx_gpu_busy(struc
 
 	gpu->devfreq.busy_cycles = busy_cycles;
 
+	pm_runtime_put(&gpu->pdev->dev);
+
 	if (WARN_ON(busy_time > ~0LU))
 		return ~0LU;
 
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -107,6 +107,13 @@ static void __a6xx_gmu_set_freq(struct a
 	struct msm_gpu *gpu = &adreno_gpu->base;
 	int ret;
 
+	/*
+	 * This can get called from devfreq while the hardware is idle. Don't
+	 * bring up the power if it isn't already active
+	 */
+	if (pm_runtime_get_if_in_use(gmu->dev) == 0)
+		return;
+
 	gmu_write(gmu, REG_A6XX_GMU_DCVS_ACK_OPTION, 0);
 
 	gmu_write(gmu, REG_A6XX_GMU_DCVS_PERF_SETTING,
@@ -133,6 +140,7 @@ static void __a6xx_gmu_set_freq(struct a
 	 * for now leave it at max so that the performance is nominal.
 	 */
 	icc_set_bw(gpu->icc_path, 0, MBps_to_icc(7216));
+	pm_runtime_put(gmu->dev);
 }
 
 void a6xx_gmu_set_freq(struct msm_gpu *gpu, unsigned long freq)
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -803,6 +803,11 @@ static unsigned long a6xx_gpu_busy(struc
 	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
 	u64 busy_cycles, busy_time;
 
+
+	/* Only read the gpu busy if the hardware is already active */
+	if (pm_runtime_get_if_in_use(a6xx_gpu->gmu.dev) == 0)
+		return 0;
+
 	busy_cycles = gmu_read64(&a6xx_gpu->gmu,
 			REG_A6XX_GMU_CX_GMU_POWER_COUNTER_XOCLK_0_L,
 			REG_A6XX_GMU_CX_GMU_POWER_COUNTER_XOCLK_0_H);
@@ -812,6 +817,8 @@ static unsigned long a6xx_gpu_busy(struc
 
 	gpu->devfreq.busy_cycles = busy_cycles;
 
+	pm_runtime_put(a6xx_gpu->gmu.dev);
+
 	if (WARN_ON(busy_time > ~0LU))
 		return ~0LU;
 


