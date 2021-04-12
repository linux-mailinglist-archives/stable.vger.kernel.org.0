Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0003135C0B5
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241322AbhDLJPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240466AbhDLJKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EE7261286;
        Mon, 12 Apr 2021 09:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218341;
        bh=Uml8lBs8mbcuKsNkLY6GOCN37CVSsJZ9u0Cfl7oZalI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAd5GkfLViI6HsKGOIzv48pcGDHqHvPz1Ed1zf7pEqMshbwEfPloP3tiLcarmUTul
         HC38nRx2Blx0blkgblhDr+YPBZFShuNzwpQqPPYR4qH9wta47VqISwR8A8OCVhA+T7
         ISvwl2kQNFSOUrPWoaRiTowQ4Mfo2QJV3aF+IR3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akhil P Oommen <akhilpo@codeaurora.org>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Jordan Crouse <jordan@cosmicpenguin.net>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 160/210] drm/msm: a6xx: fix version check for the A650 SQE microcode
Date:   Mon, 12 Apr 2021 10:41:05 +0200
Message-Id: <20210412084021.346978935@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 6ddbfa1f5adbd5dea14ff66778ca58257f09f17d ]

I suppose the microcode version check for a650 is incorrect. It checks
for the version 1.95, while the firmware released have major version of 0:
0.91 (vulnerable), 0.99 (fixing the issue).

Lower version requirements to accept firmware 0.99.

Fixes: 8490f02a3ca4 ("drm/msm: a6xx: Make sure the SQE microcode is safe")
Cc: Akhil P Oommen <akhilpo@codeaurora.org>
Cc: Jordan Crouse <jcrouse@codeaurora.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Acked-by: Jordan Crouse <jordan@cosmicpenguin.net>
Message-Id: <20210331140223.3771449-1-dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index e7a8442b59af..a676811ef69d 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -566,17 +566,17 @@ static bool a6xx_ucode_check_version(struct a6xx_gpu *a6xx_gpu,
 	}  else {
 		/*
 		 * a650 tier targets don't need whereami but still need to be
-		 * equal to or newer than 1.95 for other security fixes
+		 * equal to or newer than 0.95 for other security fixes
 		 */
 		if (adreno_is_a650(adreno_gpu)) {
-			if ((buf[0] & 0xfff) >= 0x195) {
+			if ((buf[0] & 0xfff) >= 0x095) {
 				ret = true;
 				goto out;
 			}
 
 			DRM_DEV_ERROR(&gpu->pdev->dev,
 				"a650 SQE ucode is too old. Have version %x need at least %x\n",
-				buf[0] & 0xfff, 0x195);
+				buf[0] & 0xfff, 0x095);
 		}
 
 		/*
-- 
2.30.2



