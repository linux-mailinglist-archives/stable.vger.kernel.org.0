Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49B435CB3A
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243543AbhDLQX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:23:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243470AbhDLQXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3691611AD;
        Mon, 12 Apr 2021 16:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244606;
        bh=hlkyVzL2RHmtnkXH13UHYU9pzLCvo9kPx9lFfTkFKTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpRMdT9gvHdm7q4HM7xO9HLMG3xbpzy9agh8bPYmJDXrWxD1L6aOLEkK0UyokJqIR
         iJf0w/yzUB0SUPJ3enPrz0RblRBenjOVkC3L9L5DTxhj+isZ6MjEZ2iyYlITWGxE3a
         CyfLpHoiXKAMZO9x4wyGVtfgD7zpFsajAq/UvAo7jOPYSPG6PQUXMa2xyqCh5tlext
         +JCUNycs3JevxpEFfqjwAKss/ydEUaxRHGWuBuLy657UX7UhumGdjHqaWBEi3u5okY
         e5vUIZJZ0Fm5tQVM/WF4GrpSKd9fZ/FaUD4pksUhCOpE54S4m2hjZvGXQxtajKkYe/
         wmAIkc5AWk4fw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Jordan Crouse <jordan@cosmicpenguin.net>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 24/51] drm/msm: Fix a5xx/a6xx timestamps
Date:   Mon, 12 Apr 2021 12:22:29 -0400
Message-Id: <20210412162256.313524-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
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
index 81506d2539b0..15898b9b9ce9 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1239,8 +1239,8 @@ static int a5xx_pm_suspend(struct msm_gpu *gpu)
 
 static int a5xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
 {
-	*value = gpu_read64(gpu, REG_A5XX_RBBM_PERFCTR_CP_0_LO,
-		REG_A5XX_RBBM_PERFCTR_CP_0_HI);
+	*value = gpu_read64(gpu, REG_A5XX_RBBM_ALWAYSON_COUNTER_LO,
+		REG_A5XX_RBBM_ALWAYSON_COUNTER_HI);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index e7a8442b59af..7368dfb40d5f 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1227,8 +1227,8 @@ static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
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

