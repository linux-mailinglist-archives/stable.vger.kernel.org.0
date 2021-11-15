Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037A7451DD7
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344293AbhKPAeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:34:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343894AbhKOTWY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B4F7635FA;
        Mon, 15 Nov 2021 18:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002098;
        bh=2CmOslhHWbfIYafn8fx8ai24Gq2du5lBCEi7K6y08ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXk5gvmdy2x0yxCl3emH1y7vUmcr28BsB//S4KJumkTQ0KSPl01opQpcn7tWhk1zo
         FqYFT3qg/4w1PJtqzbVf5nY83YCUTaMurgws+4BPXzI2Al5zpuJkgWB4n61rr06qp2
         U87Ho4sn+5U8ZjPGjgFVVVF5ECblRWC+LwtZ8qZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 437/917] drm/msm: Fix potential Oops in a6xx_gmu_rpmh_init()
Date:   Mon, 15 Nov 2021 17:58:52 +0100
Message-Id: <20211115165443.605928758@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 3d91e50ff58364f6572ad268b508175d27800e51 ]

There are two problems here:
1) The "seqptr" is used uninitalized when we free it at the end.
2) The a6xx_gmu_get_mmio() function returns error pointers.  It never
   returns true.

Fixes: 64245fc55172 ("drm/msm/a6xx: use AOP-initialized PDC for a650")
Fixes: f8fc924e088e ("drm/msm/a6xx: Fix PDC register overlap")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20211004134530.GB11689@kili
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 8b73f70766a47..4347a104755a9 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -516,11 +516,11 @@ static void a6xx_gmu_rpmh_init(struct a6xx_gmu *gmu)
 	struct adreno_gpu *adreno_gpu = &a6xx_gpu->base;
 	struct platform_device *pdev = to_platform_device(gmu->dev);
 	void __iomem *pdcptr = a6xx_gmu_get_mmio(pdev, "gmu_pdc");
-	void __iomem *seqptr;
+	void __iomem *seqptr = NULL;
 	uint32_t pdc_address_offset;
 	bool pdc_in_aop = false;
 
-	if (!pdcptr)
+	if (IS_ERR(pdcptr))
 		goto err;
 
 	if (adreno_is_a650(adreno_gpu) || adreno_is_a660_family(adreno_gpu))
@@ -532,7 +532,7 @@ static void a6xx_gmu_rpmh_init(struct a6xx_gmu *gmu)
 
 	if (!pdc_in_aop) {
 		seqptr = a6xx_gmu_get_mmio(pdev, "gmu_pdc_seq");
-		if (!seqptr)
+		if (IS_ERR(seqptr))
 			goto err;
 	}
 
-- 
2.33.0



