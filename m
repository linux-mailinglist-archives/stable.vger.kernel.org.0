Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5682E422A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437141AbgL1PSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:18:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437072AbgL1ODH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:03:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B8672063A;
        Mon, 28 Dec 2020 14:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164171;
        bh=nRf3/WRu2GDMLK5H8uNZSOI5Rwq1q3jFSCWjRTjDcZg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dCfBEcSqjuiVLWYmkQGwe5cJZCma9+V8soePNnFsA5P5Jud9+6s3g7wmKjsIoe/Pb
         nbSFNvxFC0hezoxBFa07u64Uk/kBmj/6MGQ69Be1WoyEQXdByVwljWJIaj1XaUjBE6
         Qe3wph1S/PvBtB0+emEfzp4MvO/+vM9fKxD3Klew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/717] drm/msm/a5xx: Clear shadow on suspend
Date:   Mon, 28 Dec 2020 13:41:25 +0100
Message-Id: <20201228125025.146827964@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 5771de5d5b3bfaf279e5c262a113d4b6fbe54355 ]

Similar to the previous patch, clear shadow on suspend to avoid timeouts
waiting for ringbuffer space.

Fixes: 8907afb476ac ("drm/msm: Allow a5xx to mark the RPTR shadow as privileged")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
index d6804a8023555..8aa08976aad17 100644
--- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
@@ -1207,7 +1207,9 @@ static int a5xx_pm_resume(struct msm_gpu *gpu)
 static int a5xx_pm_suspend(struct msm_gpu *gpu)
 {
 	struct adreno_gpu *adreno_gpu = to_adreno_gpu(gpu);
+	struct a5xx_gpu *a5xx_gpu = to_a5xx_gpu(adreno_gpu);
 	u32 mask = 0xf;
+	int i, ret;
 
 	/* A510 has 3 XIN ports in VBIF */
 	if (adreno_is_a510(adreno_gpu))
@@ -1227,7 +1229,15 @@ static int a5xx_pm_suspend(struct msm_gpu *gpu)
 	gpu_write(gpu, REG_A5XX_RBBM_BLOCK_SW_RESET_CMD, 0x003C0000);
 	gpu_write(gpu, REG_A5XX_RBBM_BLOCK_SW_RESET_CMD, 0x00000000);
 
-	return msm_gpu_pm_suspend(gpu);
+	ret = msm_gpu_pm_suspend(gpu);
+	if (ret)
+		return ret;
+
+	if (a5xx_gpu->has_whereami)
+		for (i = 0; i < gpu->nr_rings; i++)
+			a5xx_gpu->shadow[i] = 0;
+
+	return 0;
 }
 
 static int a5xx_get_timestamp(struct msm_gpu *gpu, uint64_t *value)
-- 
2.27.0



