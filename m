Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6618FA599
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728219AbfKMBwR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:52:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbfKMBwR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 854452245D;
        Wed, 13 Nov 2019 01:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609936;
        bh=GnLDcU3GQlLVz86X48Q6AD2uliaNpA6HTGkKvjNyt+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gB9HJpqDdkNOgBy9jkUEw3G8Uoic4x+ZlNqZeANFoioZBIcevSajfY53pkB9pqHlE
         G4y7P+l8oZGIlTvZ75klbgKlyNL42lyycOmeJiAgFu3Giy8JeQNk/3K0PwF1UVw+Mo
         fyz74bCE1NQ4P0SHyThVlA8qzaC/A6mAbXROuXpc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jordan Crouse <jcrouse@codeaurora.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Rob Clark <robdclark@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 079/209] msm/gpu/a6xx: Force of_dma_configure to setup DMA for GMU
Date:   Tue, 12 Nov 2019 20:48:15 -0500
Message-Id: <20191113015025.9685-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Crouse <jcrouse@codeaurora.org>

[ Upstream commit 32aa27e15c28d3898ed6f9b3c98f95f34a81eab2 ]

The point of the 'force_dma' parameter for of_dma_configure
is to force the device to be set up even if DMA capability is
not described by the firmware which is exactly the use case
 we have for GMU - we need SMMU to get set up but we have no
other dma capabilities since memory is managed by the GPU
driver. Currently we pass false so of_dma_configure() fails
and subsequently GMU and GPU probe does as well.

Fixes: 4b565ca5a2c ("drm/msm: Add A6XX device support")
Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
Tested-by: Sibi Sankar <sibis@codeaurora.org>
Signed-off-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 9acb9dfaf57e6..9cde79a7335c8 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1140,7 +1140,7 @@ int a6xx_gmu_probe(struct a6xx_gpu *a6xx_gpu, struct device_node *node)
 
 	gmu->dev = &pdev->dev;
 
-	of_dma_configure(gmu->dev, node, false);
+	of_dma_configure(gmu->dev, node, true);
 
 	/* Fow now, don't do anything fancy until we get our feet under us */
 	gmu->idle_level = GMU_IDLE_STATE_ACTIVE;
-- 
2.20.1

