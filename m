Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D8369DDAB
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 11:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbjBUKQv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 05:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbjBUKQu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 05:16:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE43233E3;
        Tue, 21 Feb 2023 02:16:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C3CACE09B5;
        Tue, 21 Feb 2023 10:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57961C433EF;
        Tue, 21 Feb 2023 10:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676974605;
        bh=rsIBiufyPVeN/iiBVMiUsYKGl4amMszJEzKK1e3KNPE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UxVTeCgQv7nr7fYeRtAYvutvyfzn2nEPwWXUgm5gZhaSUjA5fv+/yLOaoWghcY3gw
         Jo0MgAIQgCMPKgLsPh6eCP5d1g8ZZyXEYFZvoPLom5oeoEtXstfg54huEzCDIU2IMK
         SO8XmIZukdkDZDbt7ZGjA6IfildbkNuJPq9fydFZ3N1YTxYd6F7i8v+0E/xSuEPQl4
         7VgVHwizHTh6QBb5IM4bnoM6kKdvXlubmLzUhY+xGJzD6+TqtWDaGOr1+e7tZ2ImzN
         SmafOtsH99Wa2sH/tDjbJ37zsyJbgJauoNmdk1TIPU6kUc8oegUBXWLvgKYeDDGufB
         /NkwxzCndLo2Q==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pUPhX-0003oF-WE; Tue, 21 Feb 2023 11:16:48 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Sean Paul <sean@poorly.run>, David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Bjorn Andersson <andersson@kernel.org>,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <quic_bjorande@quicinc.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/4] drm/msm/adreno: fix runtime PM imbalance at unbind
Date:   Tue, 21 Feb 2023 11:14:27 +0100
Message-Id: <20230221101430.14546-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230221101430.14546-1-johan+linaro@kernel.org>
References: <20230221101430.14546-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A recent commit moved enabling of runtime PM from adreno_gpu_init() to
adreno_load_gpu() (called on first open()), which means that unbind()
may now be called with runtime PM disabled in case the device was never
opened in between.

Make sure to only forcibly suspend and disable runtime PM at unbind() in
case runtime PM has been enabled to prevent a disable count imbalance.

This specifically avoids leaving runtime PM disabled when the device
is later opened after a successful bind:

	msm_dpu ae01000.display-controller: [drm:adreno_load_gpu [msm]] *ERROR* Couldn't power up the GPU: -13

Fixes: 4b18299b3365 ("drm/msm/adreno: Defer enabling runpm until hw_init()")
Reported-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Link: https://lore.kernel.org/lkml/20230203181245.3523937-1-quic_bjorande@quicinc.com
Cc: stable@vger.kernel.org	# 6.0
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 36f062c7582f..c5c4c93b3689 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -558,7 +558,8 @@ static void adreno_unbind(struct device *dev, struct device *master,
 	struct msm_drm_private *priv = dev_get_drvdata(master);
 	struct msm_gpu *gpu = dev_to_gpu(dev);
 
-	WARN_ON_ONCE(adreno_system_suspend(dev));
+	if (pm_runtime_enabled(dev))
+		WARN_ON_ONCE(adreno_system_suspend(dev));
 	gpu->funcs->destroy(gpu);
 
 	priv->gpu_pdev = NULL;
-- 
2.39.2

