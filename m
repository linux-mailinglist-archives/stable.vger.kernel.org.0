Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE47329000
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239607AbhCAUBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241790AbhCATrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:47:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E89016520C;
        Mon,  1 Mar 2021 17:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619318;
        bh=apxN16I2uQsfNSFy7As2C4UHEGGEx+hOzlFhEJlIMEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qa9R3YXVHM0YjXnwfseTlsUdodJxfFfv+/wXkP4KKJTHuEiz2ngYIsCiy58Bq5ZEF
         Nb1ftOnCNYaNFFtmqJ0DCRHSkxM8N/VMYYGt0aT20K6159jFakBotnwtOpwT5c5o3V
         Xu4qsXC9vx8cMCyN7fTquCVHSRPiFbEUToqtvq0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Anholt <eric@anholt.net>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 411/663] drm/msm: Fix race of GPU init vs timestamp power management.
Date:   Mon,  1 Mar 2021 17:10:59 +0100
Message-Id: <20210301161202.207753722@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Anholt <eric@anholt.net>

[ Upstream commit 7a7cbf2a819740674455ad36155c662367261296 ]

We were using the same force-poweron bit in the two codepaths, so they
could race to have one of them lose GPU power early.

freedreno CI was seeing intermittent errors like:
[drm:_a6xx_gmu_set_oob] *ERROR* Timeout waiting for GMU OOB set GPU_SET: 0x0
and this issue could have contributed to it.

Signed-off-by: Eric Anholt <eric@anholt.net>
Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 25 ++++++++++++++++++++++---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h |  8 ++++++++
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c |  4 ++--
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 491fee410dafe..8d78d95d29fcd 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -266,6 +266,16 @@ int a6xx_gmu_set_oob(struct a6xx_gmu *gmu, enum a6xx_gmu_oob_state state)
 		}
 		name = "GPU_SET";
 		break;
+	case GMU_OOB_PERFCOUNTER_SET:
+		if (gmu->legacy) {
+			request = GMU_OOB_PERFCOUNTER_REQUEST;
+			ack = GMU_OOB_PERFCOUNTER_ACK;
+		} else {
+			request = GMU_OOB_PERFCOUNTER_REQUEST_NEW;
+			ack = GMU_OOB_PERFCOUNTER_ACK_NEW;
+		}
+		name = "PERFCOUNTER";
+		break;
 	case GMU_OOB_BOOT_SLUMBER:
 		request = GMU_OOB_BOOT_SLUMBER_REQUEST;
 		ack = GMU_OOB_BOOT_SLUMBER_ACK;
@@ -303,9 +313,14 @@ int a6xx_gmu_set_oob(struct a6xx_gmu *gmu, enum a6xx_gmu_oob_state state)
 void a6xx_gmu_clear_oob(struct a6xx_gmu *gmu, enum a6xx_gmu_oob_state state)
 {
 	if (!gmu->legacy) {
-		WARN_ON(state != GMU_OOB_GPU_SET);
-		gmu_write(gmu, REG_A6XX_GMU_HOST2GMU_INTR_SET,
-			1 << GMU_OOB_GPU_SET_CLEAR_NEW);
+		if (state == GMU_OOB_GPU_SET) {
+			gmu_write(gmu, REG_A6XX_GMU_HOST2GMU_INTR_SET,
+				1 << GMU_OOB_GPU_SET_CLEAR_NEW);
+		} else {
+			WARN_ON(state != GMU_OOB_PERFCOUNTER_SET);
+			gmu_write(gmu, REG_A6XX_GMU_HOST2GMU_INTR_SET,
+				1 << GMU_OOB_PERFCOUNTER_CLEAR_NEW);
+		}
 		return;
 	}
 
@@ -314,6 +329,10 @@ void a6xx_gmu_clear_oob(struct a6xx_gmu *gmu, enum a6xx_gmu_oob_state state)
 		gmu_write(gmu, REG_A6XX_GMU_HOST2GMU_INTR_SET,
 			1 << GMU_OOB_GPU_SET_CLEAR);
 		break;
+	case GMU_OOB_PERFCOUNTER_SET:
+		gmu_write(gmu, REG_A6XX_GMU_HOST2GMU_INTR_SET,
+			1 << GMU_OOB_PERFCOUNTER_CLEAR);
+		break;
 	case GMU_OOB_BOOT_SLUMBER:
 		gmu_write(gmu, REG_A6XX_GMU_HOST2GMU_INTR_SET,
 			1 << GMU_OOB_BOOT_SLUMBER_CLEAR);
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.h b/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
index c6d2bced8e5de..9fa278de2106a 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
@@ -156,6 +156,7 @@ enum a6xx_gmu_oob_state {
 	GMU_OOB_BOOT_SLUMBER = 0,
 	GMU_OOB_GPU_SET,
 	GMU_OOB_DCVS_SET,
+	GMU_OOB_PERFCOUNTER_SET,
 };
 
 /* These are the interrupt / ack bits for each OOB request that are set
@@ -190,6 +191,13 @@ enum a6xx_gmu_oob_state {
 #define GMU_OOB_GPU_SET_ACK_NEW		31
 #define GMU_OOB_GPU_SET_CLEAR_NEW	31
 
+#define GMU_OOB_PERFCOUNTER_REQUEST	17
+#define GMU_OOB_PERFCOUNTER_ACK		25
+#define GMU_OOB_PERFCOUNTER_CLEAR	25
+
+#define GMU_OOB_PERFCOUNTER_REQUEST_NEW	28
+#define GMU_OOB_PERFCOUNTER_ACK_NEW	30
+#define GMU_OOB_PERFCOUNTER_CLEAR_NEW	30
 
 void a6xx_hfi_init(struct a6xx_gmu *gmu);
 int a6xx_hfi_start(struct a6xx_gmu *gmu, int boot_state);
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 420ca4a0eb5f7..9fda02550d80d 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1068,12 +1068,12 @@ static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
 	struct a6xx_gpu *a6xx_gpu = to_a6xx_gpu(adreno_gpu);
 
 	/* Force the GPU power on so we can read this register */
-	a6xx_gmu_set_oob(&a6xx_gpu->gmu, GMU_OOB_GPU_SET);
+	a6xx_gmu_set_oob(&a6xx_gpu->gmu, GMU_OOB_PERFCOUNTER_SET);
 
 	*value = gpu_read64(gpu, REG_A6XX_RBBM_PERFCTR_CP_0_LO,
 		REG_A6XX_RBBM_PERFCTR_CP_0_HI);
 
-	a6xx_gmu_clear_oob(&a6xx_gpu->gmu, GMU_OOB_GPU_SET);
+	a6xx_gmu_clear_oob(&a6xx_gpu->gmu, GMU_OOB_PERFCOUNTER_SET);
 	return 0;
 }
 
-- 
2.27.0



