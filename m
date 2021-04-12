Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF9C35CCB5
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244729AbhDLQbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:57688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244727AbhDLQ2P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:28:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2926C613A2;
        Mon, 12 Apr 2021 16:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244723;
        bh=w6NUU2zwGaJSfyi1+pqBF72a5+HR4v5RTHUFzX3Sbu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=psDmY3f5RGnvmer1W4LfH2aDx4wej2rSkr1x1TCbn6lmUCV7ieLckvX3qwM/IdXyu
         kCa+JeMvj7mP3nkgCC9+d7lt/6q5VSEcDLQD2wpoMph4SDhGLwXhZgMhxQJkN74Wiz
         FqS5bG0jL3ZVM/EknYw0ShkxDJkt8xYJ7HBdYTFHT1cU449hOPxZ1fhTswVHDHlwFh
         2NMApPHPHZE3sINhMv52yGkW+P+861kzQek7CLVHrkSvIN61zpjlUQbWwHuyI9+3Uu
         8WiZTBLNC0u7+DheKWBZunvIAfxyGp8pMarBXlbdMB0zmambYzHY1crwjAb2B2H16Z
         vXDZDjAyOWHlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Clark <robdclark@chromium.org>,
        Jordan Crouse <jordan@cosmicpenguin.net>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 16/39] drm/msm: Fix a5xx/a6xx timestamps
Date:   Mon, 12 Apr 2021 12:24:38 -0400
Message-Id: <20210412162502.314854-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162502.314854-1-sashal@kernel.org>
References: <20210412162502.314854-1-sashal@kernel.org>
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
index f84049119f1c..e3579e5ffa14 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1131,8 +1131,8 @@ static int a5xx_pm_suspend(struct msm_gpu *gpu)
 
 static int a5xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
 {
-	*value = gpu_read64(gpu, REG_A5XX_RBBM_PERFCTR_CP_0_LO,
-		REG_A5XX_RBBM_PERFCTR_CP_0_HI);
+	*value = gpu_read64(gpu, REG_A5XX_RBBM_ALWAYSON_COUNTER_LO,
+		REG_A5XX_RBBM_ALWAYSON_COUNTER_HI);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index ab75f0309d4b..df2656e57991 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -773,8 +773,8 @@ static int a6xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
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

