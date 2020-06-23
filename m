Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C75206338
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389495AbgFWUT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:19:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389802AbgFWUT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE7A22073E;
        Tue, 23 Jun 2020 20:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943567;
        bh=DJgswhjFLTFWVvJcmkwzjg9gcQuv0t0BJtnkWFGLVdg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chZNn2mXP4/QzR++axRrlVyU5l/IerRak20m0IQrQuh807zMDboCCAmAwDL2CMsCW
         xi+9jwC6KWb+TaW3rrFNRy9217yfu676nmuu0ZX5De3Sl4grpHNbnAmsuc8ggDDuvS
         emIpDsjFVhRT5oBJh+vISvWxLR56zCSblu2X4/m4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>
Subject: [PATCH 5.7 443/477] drm/msm: Check for powered down HW in the devfreq callbacks
Date:   Tue, 23 Jun 2020 21:57:20 +0200
Message-Id: <20200623195428.471669391@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
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
@@ -1404,6 +1404,10 @@ static unsigned long a5xx_gpu_busy(struc
 {
 	u64 busy_cycles, busy_time;
 
+	/* Only read the gpu busy if the hardware is already active */
+	if (pm_runtime_get_if_in_use(&gpu->pdev->dev) == 0)
+		return 0;
+
 	busy_cycles = gpu_read64(gpu, REG_A5XX_RBBM_PERFCTR_RBBM_0_LO,
 			REG_A5XX_RBBM_PERFCTR_RBBM_0_HI);
 
@@ -1412,6 +1416,8 @@ static unsigned long a5xx_gpu_busy(struc
 
 	gpu->devfreq.busy_cycles = busy_cycles;
 
+	pm_runtime_put(&gpu->pdev->dev);
+
 	if (WARN_ON(busy_time > ~0LU))
 		return ~0LU;
 
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -108,6 +108,13 @@ static void __a6xx_gmu_set_freq(struct a
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
@@ -134,6 +141,7 @@ static void __a6xx_gmu_set_freq(struct a
 	 * for now leave it at max so that the performance is nominal.
 	 */
 	icc_set_bw(gpu->icc_path, 0, MBps_to_icc(7216));
+	pm_runtime_put(gmu->dev);
 }
 
 void a6xx_gmu_set_freq(struct msm_gpu *gpu, unsigned long freq)
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -810,6 +810,11 @@ static unsigned long a6xx_gpu_busy(struc
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
@@ -819,6 +824,8 @@ static unsigned long a6xx_gpu_busy(struc
 
 	gpu->devfreq.busy_cycles = busy_cycles;
 
+	pm_runtime_put(a6xx_gpu->gmu.dev);
+
 	if (WARN_ON(busy_time > ~0LU))
 		return ~0LU;
 


