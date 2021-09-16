Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D4440E741
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343555AbhIPRbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348963AbhIPR1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:27:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CE7161A57;
        Thu, 16 Sep 2021 16:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810727;
        bh=N+oKi7eeVnuYEUVTGN5wXiWpy68Vo34sA0FAwHUYF8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/NqSpzQVGTotCtwJt1w0SkKmc2FAI9OTa3AdrO1qMbtkbaOT9mhp+fK25yG6s1Ot
         SRaHIr+EA65slnuGYrIk4nPFxjoW9wu+38jJc1duVlQPBoaZ/7U6q/UTbg/BR4A2L4
         d9HNAVKBBIyxfIwYG9tP3z3yAefIPQ8JKsU02ihE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akhil P Oommen <akhilpo@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 246/432] drm/msm/a6xx: Fix llcc configuration for a660 gpu
Date:   Thu, 16 Sep 2021 17:59:55 +0200
Message-Id: <20210916155819.171116974@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akhil P Oommen <akhilpo@codeaurora.org>

[ Upstream commit a6f24383f6c0a8d64d1f6afa10733ae4e8f236e0 ]

Add the missing scache_cntl0 register programing which is required for
a660 gpu.

Signed-off-by: Akhil P Oommen <akhilpo@codeaurora.org>
Link: https://lore.kernel.org/r/20210730011945.v4.1.I110b87677ef16d97397fb7c81c07a16e1f5d211e@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 46 ++++++++++++++++-----------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 9c5e4618aa0a..183b9f9c1b31 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1383,13 +1383,13 @@ static void a6xx_llc_activate(struct a6xx_gpu *a6xx_gpu)
 {
 	struct adreno_gpu *adreno_gpu = &a6xx_gpu->base;
 	struct msm_gpu *gpu = &adreno_gpu->base;
-	u32 cntl1_regval = 0;
+	u32 gpu_scid, cntl1_regval = 0;
 
 	if (IS_ERR(a6xx_gpu->llc_mmio))
 		return;
 
 	if (!llcc_slice_activate(a6xx_gpu->llc_slice)) {
-		u32 gpu_scid = llcc_get_slice_id(a6xx_gpu->llc_slice);
+		gpu_scid = llcc_get_slice_id(a6xx_gpu->llc_slice);
 
 		gpu_scid &= 0x1f;
 		cntl1_regval = (gpu_scid << 0) | (gpu_scid << 5) | (gpu_scid << 10) |
@@ -1409,26 +1409,34 @@ static void a6xx_llc_activate(struct a6xx_gpu *a6xx_gpu)
 		}
 	}
 
-	if (cntl1_regval) {
+	if (!cntl1_regval)
+		return;
+
+	/*
+	 * Program the slice IDs for the various GPU blocks and GPU MMU
+	 * pagetables
+	 */
+	if (!a6xx_gpu->have_mmu500) {
+		a6xx_llc_write(a6xx_gpu,
+			REG_A6XX_CX_MISC_SYSTEM_CACHE_CNTL_1, cntl1_regval);
+
 		/*
-		 * Program the slice IDs for the various GPU blocks and GPU MMU
-		 * pagetables
+		 * Program cacheability overrides to not allocate cache
+		 * lines on a write miss
 		 */
-		if (a6xx_gpu->have_mmu500)
-			gpu_rmw(gpu, REG_A6XX_GBIF_SCACHE_CNTL1, GENMASK(24, 0),
-				cntl1_regval);
-		else {
-			a6xx_llc_write(a6xx_gpu,
-				REG_A6XX_CX_MISC_SYSTEM_CACHE_CNTL_1, cntl1_regval);
-
-			/*
-			 * Program cacheability overrides to not allocate cache
-			 * lines on a write miss
-			 */
-			a6xx_llc_rmw(a6xx_gpu,
-				REG_A6XX_CX_MISC_SYSTEM_CACHE_CNTL_0, 0xF, 0x03);
-		}
+		a6xx_llc_rmw(a6xx_gpu,
+			REG_A6XX_CX_MISC_SYSTEM_CACHE_CNTL_0, 0xF, 0x03);
+		return;
 	}
+
+	gpu_rmw(gpu, REG_A6XX_GBIF_SCACHE_CNTL1, GENMASK(24, 0), cntl1_regval);
+
+	/* On A660, the SCID programming for UCHE traffic is done in
+	 * A6XX_GBIF_SCACHE_CNTL0[14:10]
+	 */
+	if (adreno_is_a660(adreno_gpu))
+		gpu_rmw(gpu, REG_A6XX_GBIF_SCACHE_CNTL0, (0x1f << 10) |
+			(1 << 8), (gpu_scid << 10) | (1 << 8));
 }
 
 static void a6xx_llc_slices_destroy(struct a6xx_gpu *a6xx_gpu)
-- 
2.30.2



