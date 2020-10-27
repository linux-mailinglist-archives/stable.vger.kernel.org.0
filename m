Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF2929B80F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1799348AbgJ0PbC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1799339AbgJ0PbA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:31:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5411020728;
        Tue, 27 Oct 2020 15:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812660;
        bh=HDFgHp5dM5AS29zdTJvc4u7p1YF4QJptFKHhbIvReiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YqyBbTtOvrorzXnQPB0bH63n4HjlxBD/EunAVREQxqM7kb3ah7Dzb/jy5tiDK8mao
         VaHw4FeyVlVGx8AFMNTk3V09A6WIgwYOE/8Z6ohGTP4jEgH1gMpKQd74tywi0RsfRK
         bUHybgrwYNesDvTKPsst2/GvLU95pezHzlP2G3AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Jordan Crouse <jcrouse@codeaurora.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 287/757] drm/msm: Fix the a650 hw_apriv check
Date:   Tue, 27 Oct 2020 14:48:57 +0100
Message-Id: <20201027135504.032177121@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordan Crouse <jcrouse@codeaurora.org>

[ Upstream commit e9ba8d550dd1e28870a0bdc7c11af026c2a94702 ]

Commit 604234f33658 ("drm/msm: Enable expanded apriv support for a650")
was checking the result of adreno_is_a650() before the gpu revision
got probed in adreno_gpu_init() so it was always coming across as
false. Snoop into the revision ID ahead of time to correctly set the
hw_apriv flag so that it can be used by msm_gpu to properly setup
global buffers.

Fixes: 604234f33658 ("drm/msm: Enable expanded apriv support for a650")
Reported-by: Jonathan Marek <jonathan@marek.ca>
Signed-off-by: Jordan Crouse <jcrouse@codeaurora.org>
Tested-by: Jonathan Marek <jonathan@marek.ca>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 66a95e22b7b3d..456d729c81c39 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -1048,6 +1048,8 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 {
 	struct msm_drm_private *priv = dev->dev_private;
 	struct platform_device *pdev = priv->gpu_pdev;
+	struct adreno_platform_config *config = pdev->dev.platform_data;
+	const struct adreno_info *info;
 	struct device_node *node;
 	struct a6xx_gpu *a6xx_gpu;
 	struct adreno_gpu *adreno_gpu;
@@ -1064,7 +1066,14 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 	adreno_gpu->registers = NULL;
 	adreno_gpu->reg_offsets = a6xx_register_offsets;
 
-	if (adreno_is_a650(adreno_gpu))
+	/*
+	 * We need to know the platform type before calling into adreno_gpu_init
+	 * so that the hw_apriv flag can be correctly set. Snoop into the info
+	 * and grab the revision number
+	 */
+	info = adreno_info(config->rev);
+
+	if (info && info->revn == 650)
 		adreno_gpu->base.hw_apriv = true;
 
 	ret = adreno_gpu_init(dev, pdev, adreno_gpu, &funcs, 1);
-- 
2.25.1



