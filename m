Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD4B5B5D8B
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 17:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiILPlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 11:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiILPla (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 11:41:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6350C2DABE;
        Mon, 12 Sep 2022 08:41:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD1E8B80DC6;
        Mon, 12 Sep 2022 15:41:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF884C43140;
        Mon, 12 Sep 2022 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662997286;
        bh=9CE7orcQkUcjA2k8uttjXrckagCUwwToGrdo8aBWuGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWQzktamSYNI5dM48LjRFqP8L5Np9Evcoq5crLoCkgyRtUoFHbo7nT6bEZ9ItPidp
         lze49PbVlrBUVj3HdnyJ98d2wt70bcEMD20lOFwzLruTE/ZRJfmb1rCB6PvP4b6Wre
         g5zYx1CwzE5d7ozHzsdQQfjDDiVzEO8yilhgOm68s+SLADm9E6cKZ5TeNDjy2rZ+yV
         sG9I9nna3xrBYzGYuDtD6p42DUPWYmzEqTZqbDdSQ2V9RCkox21933VTFFNVrErHpP
         l0TVofnMFhmVKRBKMvyYnWL68Y1BW8O30uVi9hYDAI/oPipp3Vpg2xR97HaYgVPkDz
         OuBIUgHmU/Vug==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1oXlYp-0003Mo-5V; Mon, 12 Sep 2022 17:41:23 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Douglas Anderson <dianders@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@gmail.com>
Cc:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Sean Paul <sean@poorly.run>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 1/7] drm/msm: fix use-after-free on probe deferral
Date:   Mon, 12 Sep 2022 17:40:40 +0200
Message-Id: <20220912154046.12900-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220912154046.12900-1-johan+linaro@kernel.org>
References: <20220912154046.12900-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bridge counter was never reset when tearing down the DRM device so
that stale pointers to deallocated structures would be accessed on the
next tear down (e.g. after a second late bind deferral).

Given enough bridges and a few probe deferrals this could currently also
lead to data beyond the bridge array being corrupted.

Fixes: d28ea556267c ("drm/msm: properly add and remove internal bridges")
Cc: stable@vger.kernel.org      # 5.19
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/gpu/drm/msm/msm_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 391d86b54ded..d254fe2507ec 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -241,6 +241,7 @@ static int msm_drm_uninit(struct device *dev)
 
 	for (i = 0; i < priv->num_bridges; i++)
 		drm_bridge_remove(priv->bridges[i]);
+	priv->num_bridges = 0;
 
 	pm_runtime_get_sync(dev);
 	msm_irq_uninstall(ddev);
-- 
2.35.1

