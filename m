Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0782F475ED0
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbhLORY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:24:56 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44790 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238399AbhLORYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:24:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 840AA61A08;
        Wed, 15 Dec 2021 17:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A750C36AE0;
        Wed, 15 Dec 2021 17:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589049;
        bh=unlC7HLWyW/ytc26HnASg751ADcMZewyNkZGzmL/MyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eD8TrZwbbi2+BDVqbjLl/8ofdWTg0R+C/1UPpvvYzeWu+RHG042BLvQXZWTgRng5M
         2gRmS1uNJl7pWNXsv3l4l9zZhvkWodP1mVu3nrQ3oSDfFgGzYnUOq1Nwfq5Wi0rs27
         t7Tueg39ur1cruMWmSSwYyy/J36Vj5Zo2Yay3nKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Akhil P Oommen <akhilpo@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 20/42] drm/msm/a6xx: Fix uinitialized use of gpu_scid
Date:   Wed, 15 Dec 2021 18:21:01 +0100
Message-Id: <20211215172027.358720980@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akhil P Oommen <akhilpo@codeaurora.org>

[ Upstream commit 9ba873e66ed317a1ff645d5e52c2e72597ff3d18 ]

Avoid a possible uninitialized use of gpu_scid variable to fix the
below smatch warning:
	drivers/gpu/drm/msm/adreno/a6xx_gpu.c:1480 a6xx_llc_activate()
	error: uninitialized symbol 'gpu_scid'.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Akhil P Oommen <akhilpo@codeaurora.org>
Link: https://lore.kernel.org/r/20211118154903.3.Ie4ac321feb10168af569d9c2b4cf6828bed8122c@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 267a880811d65..723074aae5b63 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1424,17 +1424,24 @@ static void a6xx_llc_activate(struct a6xx_gpu *a6xx_gpu)
 {
 	struct adreno_gpu *adreno_gpu = &a6xx_gpu->base;
 	struct msm_gpu *gpu = &adreno_gpu->base;
-	u32 gpu_scid, cntl1_regval = 0;
+	u32 cntl1_regval = 0;
 
 	if (IS_ERR(a6xx_gpu->llc_mmio))
 		return;
 
 	if (!llcc_slice_activate(a6xx_gpu->llc_slice)) {
-		gpu_scid = llcc_get_slice_id(a6xx_gpu->llc_slice);
+		u32 gpu_scid = llcc_get_slice_id(a6xx_gpu->llc_slice);
 
 		gpu_scid &= 0x1f;
 		cntl1_regval = (gpu_scid << 0) | (gpu_scid << 5) | (gpu_scid << 10) |
 			       (gpu_scid << 15) | (gpu_scid << 20);
+
+		/* On A660, the SCID programming for UCHE traffic is done in
+		 * A6XX_GBIF_SCACHE_CNTL0[14:10]
+		 */
+		if (adreno_is_a660_family(adreno_gpu))
+			gpu_rmw(gpu, REG_A6XX_GBIF_SCACHE_CNTL0, (0x1f << 10) |
+				(1 << 8), (gpu_scid << 10) | (1 << 8));
 	}
 
 	/*
@@ -1471,13 +1478,6 @@ static void a6xx_llc_activate(struct a6xx_gpu *a6xx_gpu)
 	}
 
 	gpu_rmw(gpu, REG_A6XX_GBIF_SCACHE_CNTL1, GENMASK(24, 0), cntl1_regval);
-
-	/* On A660, the SCID programming for UCHE traffic is done in
-	 * A6XX_GBIF_SCACHE_CNTL0[14:10]
-	 */
-	if (adreno_is_a660_family(adreno_gpu))
-		gpu_rmw(gpu, REG_A6XX_GBIF_SCACHE_CNTL0, (0x1f << 10) |
-			(1 << 8), (gpu_scid << 10) | (1 << 8));
 }
 
 static void a6xx_llc_slices_destroy(struct a6xx_gpu *a6xx_gpu)
-- 
2.33.0



