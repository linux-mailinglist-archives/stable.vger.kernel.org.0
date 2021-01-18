Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536252FA9B0
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 20:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390541AbhARTIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 14:08:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:33364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390533AbhARLjS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:39:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED0E1221EC;
        Mon, 18 Jan 2021 11:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610969943;
        bh=7bugfp03IjuaYTQSOapwGQoSc8e3lJ0dGIuhuZmt97Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbYVwsb1c3r56eiMjKJtk5Q7NtDjgTm4OWxOLZlJfDnlcBzNzP5RWuXFmqLQksvHG
         FuoSqMgorS7+uNrk/J+xnUsfg+eD7ssX158hKS9eZeqJnQlzJuA2zkxu8at0cge9zB
         C2wkx6FmBQwcMODecAW6NQOKmB4YEf1Suk5Xg0a8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Craig Tatlor <ctatlor97@gmail.com>,
        Brian Masney <masneyb@onstation.org>,
        Alexey Minnekhanov <alexeymin@postmarketos.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 47/76] drm/msm: Call msm_init_vram before binding the gpu
Date:   Mon, 18 Jan 2021 12:34:47 +0100
Message-Id: <20210118113343.236095780@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113340.984217512@linuxfoundation.org>
References: <20210118113340.984217512@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



