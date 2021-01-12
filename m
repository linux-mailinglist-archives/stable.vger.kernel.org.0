Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FAD2F30ED
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732838AbhALNNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:13:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:53820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404186AbhALM5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DFAE23357;
        Tue, 12 Jan 2021 12:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456200;
        bh=j95pEarjfZy0tnTagImw8sNicWtXpt4JszqSf45d5DE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDs0GvFeIDH81f6qKJb7s+zZLxe2l3/MWAV0BdKlSGMg+UVpspZdn6ZXJctN1Qi06
         tYJaZVQePGKjzOl0cosYla9ASSTG8355c8vPAwVtFgF+uzrejj+OQqrkXa/RwaCWxo
         hnMP+AtyaiIpjinAXQA8fmGaOyvOsZBIXHR3pTzobUZvv9ZbLbwSdzjVSn00fhtoRP
         oEkyQuUnHk8zTyV8lNjGfDxjGXK2E9kVJz3cRZKzLu4q4Vc2CoE06/pcmDiYHuhW9G
         hKXeOlgpSRJUhC9LfnIHwq4nGeSNmIoO095OFPinmkzNOn9j5mjikKlRSESMhukLr/
         4VTEXbebZEdyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Craig Tatlor <ctatlor97@gmail.com>,
        Brian Masney <masneyb@onstation.org>,
        Alexey Minnekhanov <alexeymin@postmarketos.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 49/51] drm/msm: Call msm_init_vram before binding the gpu
Date:   Tue, 12 Jan 2021 07:55:31 -0500
Message-Id: <20210112125534.70280-49-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
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
index 49685571dc0ee..d556c353e5aea 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -444,14 +444,14 @@ static int msm_drm_init(struct device *dev, struct drm_driver *drv)
 
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
 
 	dma_set_max_seg_size(dev, UINT_MAX);
 
-- 
2.27.0

