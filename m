Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB3E2F30AA
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730148AbhALNJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:09:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404959AbhALM6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90AB52312D;
        Tue, 12 Jan 2021 12:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456242;
        bh=7bugfp03IjuaYTQSOapwGQoSc8e3lJ0dGIuhuZmt97Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRIbhdZEn+UFNcazJr71PCbRVYzuzsKJr6vXsXDdFXrVv6C+k7niIv0Soxd/uVOrJ
         axR3NarlBpaiTdxlERTH5lyQjDHw352InvNgnz6SoEi8xk8i1wt+m6a+AfbCP3gHYS
         qkoMkiaKH0Kn71aiPUHdyDebXu3IOIb/0l9qFIPuCykiwsfMHJ7vs0H9qnRzUUtYFQ
         GNM8gQAtz9/EiJjRMxw5CPMriiCVEGnS1SXWmIef6OUXpSdQCvX+WYs42DDLvDUU6X
         EOOWD1BSHeKcOtq3Z4UfILZaHQUawugU2KKNsI3f2hgcLx8ocWVeOJN2SIrmqUxJ4f
         SgDuLd1LEPHfw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Craig Tatlor <ctatlor97@gmail.com>,
        Brian Masney <masneyb@onstation.org>,
        Alexey Minnekhanov <alexeymin@postmarketos.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 27/28] drm/msm: Call msm_init_vram before binding the gpu
Date:   Tue, 12 Jan 2021 07:56:43 -0500
Message-Id: <20210112125645.70739-27-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Craig Tatlor <ctatlor97@gmail.com>

[ Upstream commit d863f0c7b536288e2bd40cbc01c10465dd226b11 ]

vram.size is needed when binding a gpu without an iommu and is defined
in msm_init_vram(), so run that before binding it.

Signed-off-by: Craig Tatlor <ctatlor97@gmail.com>
Reviewed-by: Brian Masney <masneyb@onstation.org>
Tested-by: Alexey Minnekhanov <alexeymin@postmarketos.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 108632a1f2438..8d9d86c76a4e9 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -432,14 +432,14 @@ static int msm_drm_init(struct device *dev, struct drm_driver *drv)
 
 	drm_mode_config_init(ddev);
 
-	/* Bind all our sub-components: */
-	ret = component_bind_all(dev, ddev);
+	ret = msm_init_vram(ddev);
 	if (ret)
 		goto err_destroy_mdss;
 
-	ret = msm_init_vram(ddev);
+	/* Bind all our sub-components: */
+	ret = component_bind_all(dev, ddev);
 	if (ret)
-		goto err_msm_uninit;
+		goto err_destroy_mdss;
 
 	if (!dev->dma_parms) {
 		dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
-- 
2.27.0

