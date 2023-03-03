Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBB36A9C1E
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 17:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjCCQsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 11:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbjCCQsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 11:48:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9883137F3D;
        Fri,  3 Mar 2023 08:48:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5F6C618A2;
        Fri,  3 Mar 2023 16:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF4CC4339C;
        Fri,  3 Mar 2023 16:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677862103;
        bh=H2ufo+jNyr5bRVWLvkxfPbacY4z2Injj/fm+rrg+q14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVy/3GIpBO3Iy36roKAswL82BbJWNaLt1UlD7Yvvie2LBfCPgaaXGuafDVRySiLwj
         LBVGz3yh3COUi9l4uGh+PZcPszDVN+Fvy/myLohH4ykB/WT59V8qqw2HPhbrpgdvOq
         VCF5DOeRcvpzlA+NnEqHW+6GTTyEenrfIuc6ZfGZubhYxNydzwWenpKodg/jx/EW1K
         WGLskVgFYsqSyaiMbDxLH3yQftu6RYDu9+0esyEkGVjTucWB5NzDms00Uucjn37o3W
         Vgd5jVOSjBRS4G1GPwlQgaOZ+a/ZQuVk6SZAB7M2gzTErBhlT3HVyKFNhifdC15Bfh
         3SI7GUkpeFSxQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pY8aV-0003Qe-Gm; Fri, 03 Mar 2023 17:48:55 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Sean Paul <sean@poorly.run>, David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Bjorn Andersson <andersson@kernel.org>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 2/4] drm/msm/adreno: fix runtime PM imbalance at gpu load
Date:   Fri,  3 Mar 2023 17:48:05 +0100
Message-Id: <20230303164807.13124-3-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303164807.13124-1-johan+linaro@kernel.org>
References: <20230303164807.13124-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent commit moved enabling of runtime PM to GPU load time (first
open()) but failed to update the error paths so that runtime PM is
disabled if initialisation of the GPU fails. This would trigger a
warning about the unbalanced disable count on the next open() attempt.

Note that pm_runtime_put_noidle() is sufficient to balance the usage
count when pm_runtime_put_sync() fails (and is chosen over
pm_runtime_resume_and_get() for consistency reasons).

Fixes: 4b18299b3365 ("drm/msm/adreno: Defer enabling runpm until hw_init()")
Cc: stable@vger.kernel.org      # 6.0
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index c5c4c93b3689..f9a0b11c2e43 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -443,20 +443,21 @@ struct msm_gpu *adreno_load_gpu(struct drm_device *dev)
 
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0) {
-		pm_runtime_put_sync(&pdev->dev);
+		pm_runtime_put_noidle(&pdev->dev);
 		DRM_DEV_ERROR(dev->dev, "Couldn't power up the GPU: %d\n", ret);
-		return NULL;
+		goto err_disable_rpm;
 	}
 
 	mutex_lock(&gpu->lock);
 	ret = msm_gpu_hw_init(gpu);
 	mutex_unlock(&gpu->lock);
-	pm_runtime_put_autosuspend(&pdev->dev);
 	if (ret) {
 		DRM_DEV_ERROR(dev->dev, "gpu hw init failed: %d\n", ret);
-		return NULL;
+		goto err_put_rpm;
 	}
 
+	pm_runtime_put_autosuspend(&pdev->dev);
+
 #ifdef CONFIG_DEBUG_FS
 	if (gpu->funcs->debugfs_init) {
 		gpu->funcs->debugfs_init(gpu, dev->primary);
@@ -465,6 +466,13 @@ struct msm_gpu *adreno_load_gpu(struct drm_device *dev)
 #endif
 
 	return gpu;
+
+err_put_rpm:
+	pm_runtime_put_sync(&pdev->dev);
+err_disable_rpm:
+	pm_runtime_disable(&pdev->dev);
+
+	return NULL;
 }
 
 static int find_chipid(struct device *dev, struct adreno_rev *rev)
-- 
2.39.2

