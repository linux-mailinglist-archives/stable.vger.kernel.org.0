Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8B032AF99
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238284AbhCCA1N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:27:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:48328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350688AbhCBMX0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 07:23:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1D6864FAA;
        Tue,  2 Mar 2021 11:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614686334;
        bh=+U3Zim65fOcMU3OVVUakiIMGS5oAYNl6TOG6V4kguTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BDr8hyTlOPp7wgW7PRQ+YP/yXbFPdThmjCXs29MQLXYPUr2/7EL4W/3EWkfDsZ7Hs
         NTYTRCqfO7ocPzBzvKdJWP53xFKnCnKDC3OxCFcBGeObU9kM3hZPYkyy/L3/J45cye
         BZf/A37xTqPUmz5pe3DK7qzykkacHI98AJbgEgcVAd04SrkdaIpS5lQdeYnuo5Xwpj
         A5Byi48Xh0LsGb/yqIjqKQFAha1s/Gb9u02TPaCHgLXs/OWrZH2AfFZ2I0FCnfXxck
         HBIm6HdBWzhbe8SOAE6umWs55/5zO+qoi1aWRTBmoS6arZl5PehdH292NXTue6IoF1
         QXuqWbYco8tsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 15/21] drm/msm/a5xx: Remove overwriting A5XX_PC_DBG_ECO_CNTL register
Date:   Tue,  2 Mar 2021 06:58:29 -0500
Message-Id: <20210302115835.63269-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210302115835.63269-1-sashal@kernel.org>
References: <20210302115835.63269-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

[ Upstream commit 8f03c30cb814213e36032084a01f49a9e604a3e3 ]

The PC_DBG_ECO_CNTL register on the Adreno A5xx family gets
programmed to some different values on a per-model basis.
At least, this is what we intend to do here;

Unfortunately, though, this register is being overwritten with a
static magic number, right after applying the GPU-specific
configuration (including the GPU-specific quirks) and that is
effectively nullifying the efforts.

Let's remove the redundant and wrong write to the PC_DBG_ECO_CNTL
register in order to retain the wanted configuration for the
target GPU.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index d29a58bd2f7a..776bbe9775e9 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -681,8 +681,6 @@ static int a5xx_hw_init(struct msm_gpu *gpu)
 	if (adreno_gpu->info->quirks & ADRENO_QUIRK_TWO_PASS_USE_WFI)
 		gpu_rmw(gpu, REG_A5XX_PC_DBG_ECO_CNTL, 0, (1 << 8));
 
-	gpu_write(gpu, REG_A5XX_PC_DBG_ECO_CNTL, 0xc0200100);
-
 	/* Enable USE_RETENTION_FLOPS */
 	gpu_write(gpu, REG_A5XX_CP_CHICKEN_DBG, 0x02000000);
 
-- 
2.30.1

