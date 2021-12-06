Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9F946A944
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350221AbhLFVQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350139AbhLFVQY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:16:24 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFCCC061746;
        Mon,  6 Dec 2021 13:12:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 47AFECE1412;
        Mon,  6 Dec 2021 21:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 710B4C341CB;
        Mon,  6 Dec 2021 21:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825171;
        bh=unlC7HLWyW/ytc26HnASg751ADcMZewyNkZGzmL/MyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L37/lwYedVW/ynwwG11le97opYLGpF4COF4fla8TU3622239Lk+XIGz41yH3Vvr/Q
         tfJLJf/ajRyM86oDVVGQe/6wHGQyYiUOF1E7qwqK5zxoGmUJjn9UjnvwLnqhWIcEd4
         A8pk6xmlRpBo2G8Aec+veXEoTLQ5U0hamLu1dEkEvKwTgJ40dKq2CEY7jQ6S/Ry763
         8ZXXvdMKOLDkpYprb4VhjlgvDXPpi8jUpqTJy08EODO1DfgnCeGPcICh8AwndGzkA7
         R89fjRQ127aCgsov37bEXTldGN08L2bPuq9iDV4zdFBdocfXkWh6o+YzLqcAKcwlIi
         qKCxTmiet+rJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akhil P Oommen <akhilpo@codeaurora.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, robdclark@gmail.com,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        jordan@cosmicpenguin.net, jonathan@marek.ca,
        dmitry.baryshkov@linaro.org, saiprakash.ranjan@codeaurora.org,
        dianders@chromium.org, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 02/24] drm/msm/a6xx: Fix uinitialized use of gpu_scid
Date:   Mon,  6 Dec 2021 16:12:07 -0500
Message-Id: <20211206211230.1660072-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

