Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 473E236AE1D
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhDZHlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232834AbhDZHhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:37:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1B43613DC;
        Mon, 26 Apr 2021 07:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422554;
        bh=6o24duZ6hXoAbegvgGj0veBvO8I3e5q3d3Bt1Mer7BA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IZgRas12PWdlroUyVXNe1k6ZaHzfyTbVtJjVrZgQDBQzB54NO+srZCXQlQakcBP6Z
         4oxsfeHs0eUguAPW1RXLqrnW1lX5eAODn5F0PR1KibJnf8HVVKIFm1N0ru6sxhCagW
         yi5oDg9EChzX9g+SYYZpW663UuiowlJ3Fs8Bm27Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Jordan Crouse <jordan@cosmicpenguin.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/57] drm/msm: Fix a5xx/a6xx timestamps
Date:   Mon, 26 Apr 2021 09:29:08 +0200
Message-Id: <20210426072820.950223400@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072820.568997499@linuxfoundation.org>
References: <20210426072820.568997499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 776bbe9775e9..ba513018534e 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1194,8 +1194,8 @@ static int a5xx_pm_suspend(struct msm_gpu *gpu)
 
 static int a5xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
 {
-	*value = gpu_read64(gpu, REG_A5XX_RBBM_PERFCTR_CP_0_LO,
-		REG_A5XX_RBBM_PERFCTR_CP_0_HI);
+	*value = gpu_read64(gpu, REG_A5XX_RBBM_ALWAYSON_COUNTER_LO,
+		REG_A5XX_RBBM_ALWAYSON_COUNTER_HI);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index c629f742a1d1..c280fdc44939 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -713,8 +713,8 @@ static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
 	/* Force the GPU power on so we can read this register */
 	a6xx_gmu_set_oob(&a6xx_gpu->gmu, GMU_OOB_GPU_SET);
 
-	*value = gpu_read64(gpu, REG_A6XX_RBBM_PERFCTR_CP_0_LO,
-		REG_A6XX_RBBM_PERFCTR_CP_0_HI);
+	*value = gpu_read64(gpu, REG_A6XX_CP_ALWAYS_ON_COUNTER_LO,
+		REG_A6XX_CP_ALWAYS_ON_COUNTER_HI);
 
 	a6xx_gmu_clear_oob(&a6xx_gpu->gmu, GMU_OOB_GPU_SET);
 	return 0;
-- 
2.30.2



