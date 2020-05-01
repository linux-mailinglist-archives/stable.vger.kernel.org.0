Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655FD1C1D29
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 20:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbgEASZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 14:25:57 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:42903 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729914AbgEASZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 14:25:56 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1588357555; h=Message-Id: Date: Subject: Cc: To: From:
 Sender; bh=oAbv7Whc5wnDq0DJoREo5UCU2XgDlITRPhApd/IgUDo=; b=M4x5ivlUQ7eXljBQSmjhrhZW+SvHzNF41hADUQhUkJfknR3hkWouWuqFeylxSelaHhIsr0i1
 ENKwXXpEbTNV1wBdGSWkFNjgXZAozttf5P6Lb1saor8KW4ErM6L3yC68Dw6SNga78zpGf/qn
 G9fbcBtXOtF/9a4gu7gT2rUisMw=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5eac69b1.7f2769a90688-smtp-out-n04;
 Fri, 01 May 2020 18:25:53 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D488FC44791; Fri,  1 May 2020 18:25:51 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from jordan-laptop.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: jcrouse)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 28E29C433D2;
        Fri,  1 May 2020 18:25:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 28E29C433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=jcrouse@codeaurora.org
From:   Jordan Crouse <jcrouse@codeaurora.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     Eric Anholt <eric@anholt.net>, stable@vger.kernel.org,
        Akhil P Oommen <akhilpo@codeaurora.org>,
        AngeloGioacchino Del Regno <kholk11@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Daniel Vetter <daniel@ffwll.ch>,
        David Airlie <airlied@linux.ie>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Rob Clark <robdclark@gmail.com>, Sean Paul <sean@poorly.run>,
        Sharat Masetty <smasetty@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/msm: Check for powered down HW in the devfreq callbacks
Date:   Fri,  1 May 2020 12:25:33 -0600
Message-Id: <20200501182533.19753-1-jcrouse@codeaurora.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Writing to the devfreq sysfs nodes while the GPU is powered down can
result in a system crash (on a5xx) or a nasty GMU error (on a6xx):

 $ /sys/class/devfreq/5000000.gpu# echo 500000000 > min_freq
  [  104.841625] platform 506a000.gmu: [drm:a6xx_gmu_set_oob]
	*ERROR* Timeout waiting for GMU OOB set GPU_DCVS: 0x0

Despite the fact that we carefully try to suspend the devfreq device when
the hardware is powered down there are lots of holes in the governors that
don't check for the suspend state and blindly call into the devfreq
callbacks that end up triggering hardware reads in the GPU driver.

Check the power state in the gpu_busy() and gpu_set_freq() callbacks for
a5xx and a6xx to make sure that the hardware is active before trying to
access it.

Cc: stable@vger.kernel.org
Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
---

 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 4 ++++
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 4 ++++
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 724024a2243a..9d8c7fe6377e 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1404,6 +1404,10 @@ static unsigned long a5xx_gpu_busy(struct msm_gpu *gpu)
 {
 	u64 busy_cycles, busy_time;
 
+	/* devfreq can get here while we are idle so do a quick check first */
+	if (!pm_runtime_active(&gpu->pdev->dev))
+		return ~0LU;
+
 	busy_cycles = gpu_read64(gpu, REG_A5XX_RBBM_PERFCTR_RBBM_0_LO,
 			REG_A5XX_RBBM_PERFCTR_RBBM_0_HI);
 
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index c4e71abbdd53..84618f2ff073 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -108,6 +108,10 @@ static void __a6xx_gmu_set_freq(struct a6xx_gmu *gmu, int index)
 	struct msm_gpu *gpu = &adreno_gpu->base;
 	int ret;
 
+	/* This can be called via devfreq even when the power is off */
+	if (!pm_runtime_active(gmu->dev))
+		return;
+
 	gmu_write(gmu, REG_A6XX_GMU_DCVS_ACK_OPTION, 0);
 
 	gmu_write(gmu, REG_A6XX_GMU_DCVS_PERF_SETTING,
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 68af24150de5..443efc952f13 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -810,6 +810,10 @@ static unsigned long a6xx_gpu_busy(struct msm_gpu *gpu)
 	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
 	u64 busy_cycles, busy_time;
 
+	/* devfreq can get here while we are idle so do a quick check first */
+	if (!pm_runtime_active(a6xx_gpu->gmu.dev))
+		return ~0LU;
+
 	busy_cycles = gmu_read64(&a6xx_gpu->gmu,
 			REG_A6XX_GMU_CX_GMU_POWER_COUNTER_XOCLK_0_L,
 			REG_A6XX_GMU_CX_GMU_POWER_COUNTER_XOCLK_0_H);
-- 
2.17.1
