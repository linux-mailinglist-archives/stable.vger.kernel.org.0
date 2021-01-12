Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB04F2F3076
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405176AbhALM6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:58:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:53866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405164AbhALM6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45BC023139;
        Tue, 12 Jan 2021 12:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456267;
        bh=6e72mQQeOkpy6P1S4ZJ1L+Rw9IbGA/l+p3Ag9iSANpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDMycp2NsPEZh4T4WEa2vVqAQdI0HDAwOdkuMrhNtcjvoFVk5YvbahxXkR5lLgkCc
         SDRV5xq9gzwBOXNymEnruKe30lmBo4lalEYp9LizkFNwdMeLtRLS2Cz4yRDkEzLS1W
         WPuUOAP1/xYovgf3OP7xoaPWjOLNIeyrsdBOMAwVWeGxwAVoZGAeYhuNJ7WMLxAC9p
         /baoKrdyhSFSGqgEKT8rbysnXLKT3WRm/SmxtogAf67NTMj+AFQbq0pFMRQMHF+XHZ
         f8oE6l5SMqqhVb8EHnp2qqE4qa5rijV/b4571Ene5hWAx2BXmOrLIMFken2DyV4nlw
         zlDHLuQ4I8iXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Craig Tatlor <ctatlor97@gmail.com>,
        Brian Masney <masneyb@onstation.org>,
        Alexey Minnekhanov <alexeymin@postmarketos.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 15/16] drm/msm: Call msm_init_vram before binding the gpu
Date:   Tue, 12 Jan 2021 07:57:24 -0500
Message-Id: <20210112125725.71014-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125725.71014-1-sashal@kernel.org>
References: <20210112125725.71014-1-sashal@kernel.org>
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
index 3ba3ae9749bec..81de5e1659551 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -483,14 +483,14 @@ static int msm_drm_init(struct device *dev, struct drm_driver *drv)
 
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

