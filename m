Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82F935CBF5
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243941AbhDLQ0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:57616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243951AbhDLQYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C53E61354;
        Mon, 12 Apr 2021 16:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244667;
        bh=QtCHTSR+ZAyQMyUzkaxUYRpKoNCc5fua7BthqIaxfLM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhlcVCCcFS/VOXh8/3eQ4axmhDxjI3TZhG0Bl1YwIhE1E2AoCOrqPdSA2Z39iAwYq
         wBM1I/ldoo/1qMsWjbaxJGEHRyotJJeU/DP2Q1H4VPv3Z9X8mGHxUDloljBvb1eb/R
         kAPTnNZbsGSdElRgB3ViO0er/p1dYLo40gN6rWwjmYJ7XDAkJCLQeNqXYt547XMQSy
         Mun2dTqcuId5BhOEfShhuYu2e+IrRWRcYRm9KwKnai3r9qudi8HRWn5Qdcl9GhMsCV
         bb880RvjhRndybWiFlglNeJM1OZT191yHxEtZujyyBCddv1f/E9kWKfDR1yZz3cNUM
         B4efAlJEBcL7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Jordan Crouse <jordan@cosmicpenguin.net>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 20/46] drm/msm: Fix a5xx/a6xx timestamps
Date:   Mon, 12 Apr 2021 12:23:35 -0400
Message-Id: <20210412162401.314035-20-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 9fbd3088351b92e8c2cef6e37a39decb12a8d5bb ]

They were reading a counter that was configured to ALWAYS_COUNT (ie.
cycles that the GPU is doing something) rather than ALWAYS_ON.  This
isn't the thing that userspace is looking for.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Acked-by: Jordan Crouse <jordan@cosmicpenguin.net>
Message-Id: <20210325012358.1759770-2-robdclark@gmail.com>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 4 ++--
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 5e11cdb207d8..0ca7e53db112 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1240,8 +1240,8 @@ static int a5xx_pm_suspend(struct msm_gpu *gpu)
 
 static int a5xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
 {
-	*value = gpu_read64(gpu, REG_A5XX_RBBM_PERFCTR_CP_0_LO,
-		REG_A5XX_RBBM_PERFCTR_CP_0_HI);
+	*value = gpu_read64(gpu, REG_A5XX_RBBM_ALWAYSON_COUNTER_LO,
+		REG_A5XX_RBBM_ALWAYSON_COUNTER_HI);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 83b50f6d6bb7..722c2fe3bfd5 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1073,8 +1073,8 @@ static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
 	/* Force the GPU power on so we can read this register */
 	a6xx_gmu_set_oob(&a6xx_gpu->gmu, GMU_OOB_PERFCOUNTER_SET);
 
-	*value = gpu_read64(gpu, REG_A6XX_RBBM_PERFCTR_CP_0_LO,
-		REG_A6XX_RBBM_PERFCTR_CP_0_HI);
+	*value = gpu_read64(gpu, REG_A6XX_CP_ALWAYS_ON_COUNTER_LO,
+		REG_A6XX_CP_ALWAYS_ON_COUNTER_HI);
 
 	a6xx_gmu_clear_oob(&a6xx_gpu->gmu, GMU_OOB_PERFCOUNTER_SET);
 	mutex_unlock(&perfcounter_oob);
-- 
2.30.2

