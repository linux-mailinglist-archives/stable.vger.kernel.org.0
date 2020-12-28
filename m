Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C812E3D53
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440387AbgL1OOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:14:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440380AbgL1OOS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEE2B207AB;
        Mon, 28 Dec 2020 14:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164843;
        bh=6i/clCzBH3uarIZ3RgFanfUSn3WBwtaGc4nPJE7PGtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=os7bSPjEhY4+bGiCBP+HEMlmZRoZnovn2J7SQsKl/NmeWrZk+t8nvCEFRuFNcE9ru
         8nbnTKL78StzaZT74ETzq34zy2HcPonIVt91SmY65s1paiPMx7s3ytFnKN/Bjv1ECW
         k4gdwl6AXHpNpVwbJqLzTifxF8gKJgBCwrcm+a/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/717] drm/msm: a5xx: Make preemption reset case reentrant
Date:   Mon, 28 Dec 2020 13:45:17 +0100
Message-Id: <20201228125036.318013218@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 7cc29fcdfcc8784e97c5151c848e193800ec79ac ]

nr_rings is reset to 1, but when this function is called for a second
(and third!) time nr_rings > 1 is false, thus the else case is entered
to set up a buffer for the RPTR shadow and consequently written to
RB_RPTR_ADDR, hanging platforms without WHERE_AM_I firmware support.

Restructure the condition in such a way that shadow buffer setup only
ever happens when has_whereami is true; otherwise preemption is only
finalized when the number of ring buffers has not been reset to 1 yet.

Fixes: 8907afb476ac ("drm/msm: Allow a5xx to mark the RPTR shadow as privileged")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index 8aa08976aad17..69ed2c6094665 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -755,12 +755,8 @@ static int a5xx_hw_init(struct msm_gpu *gpu)
 	gpu_write(gpu, REG_A5XX_CP_RB_CNTL,
 		MSM_GPU_RB_CNTL_DEFAULT | AXXX_CP_RB_CNTL_NO_UPDATE);
 
-	/* Disable preemption if WHERE_AM_I isn't available */
-	if (!a5xx_gpu->has_whereami && gpu->nr_rings > 1) {
-		a5xx_preempt_fini(gpu);
-		gpu->nr_rings = 1;
-	} else {
-		/* Create a privileged buffer for the RPTR shadow */
+	/* Create a privileged buffer for the RPTR shadow */
+	if (a5xx_gpu->has_whereami) {
 		if (!a5xx_gpu->shadow_bo) {
 			a5xx_gpu->shadow = msm_gem_kernel_new(gpu->dev,
 				sizeof(u32) * gpu->nr_rings,
@@ -774,6 +770,10 @@ static int a5xx_hw_init(struct msm_gpu *gpu)
 
 		gpu_write64(gpu, REG_A5XX_CP_RB_RPTR_ADDR,
 			REG_A5XX_CP_RB_RPTR_ADDR_HI, shadowptr(a5xx_gpu, gpu->rb[0]));
+	} else if (gpu->nr_rings > 1) {
+		/* Disable preemption if WHERE_AM_I isn't available */
+		a5xx_preempt_fini(gpu);
+		gpu->nr_rings = 1;
 	}
 
 	a5xx_preempt_hw_init(gpu);
-- 
2.27.0



