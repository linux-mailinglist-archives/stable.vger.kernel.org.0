Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3F861304F
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiJaGb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiJaGb4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:31:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AFCE7646
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:31:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 950FBB81135
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1750C433C1;
        Mon, 31 Oct 2022 06:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667197912;
        bh=oB6TqUDRBgpqve86Snh+T+OHij8UkEdPXBF0Phhu1MM=;
        h=Subject:To:Cc:From:Date:From;
        b=zLz0/96R6dGBOKBGpr+RrTCy0I+H1VJI9bGat9GEITJ+bUS1HN/2RFDefRqxWHPyp
         zCIp6FBw1RwUeXDtk/SfyLr8khUT2BDEdRTl92dzeyfUzzt8x+6OhH13SXJW+/4JKk
         G5kq2Xirp+Cclx1BNex1MONzJy5YTTzfWclN1Djc=
Subject: FAILED: patch "[PATCH] drm/msm/dsi: fix memory corruption with too many bridges" failed to apply to 4.14-stable tree
To:     johan+linaro@kernel.org, dmitry.baryshkov@linaro.org,
        quic_abhinavk@quicinc.com, quic_khsieh@quicinc.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:32:48 +0100
Message-ID: <16671979686979@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

2e786eb2f9ce ("drm/msm/dsi: fix memory corruption with too many bridges")
52749d601a60 ("drm/msm/dsi: Fix potential NULL pointer dereference in msm_dsi_modeset_init")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2e786eb2f9cebb07e317226b60054df510b60c65 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Tue, 13 Sep 2022 10:53:13 +0200
Subject: [PATCH] drm/msm/dsi: fix memory corruption with too many bridges

Add the missing sanity check on the bridge counter to avoid corrupting
data beyond the fixed-sized bridge array in case there are ever more
than eight bridges.

Fixes: a689554ba6ed ("drm/msm: Initial add DSI connector support")
Cc: stable@vger.kernel.org	# 4.1
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/502668/
Link: https://lore.kernel.org/r/20220913085320.8577-4-johan+linaro@kernel.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>

diff --git a/drivers/gpu/drm/msm/dsi/dsi.c b/drivers/gpu/drm/msm/dsi/dsi.c
index 39bbabb5daf6..8a95c744972a 100644
--- a/drivers/gpu/drm/msm/dsi/dsi.c
+++ b/drivers/gpu/drm/msm/dsi/dsi.c
@@ -218,6 +218,12 @@ int msm_dsi_modeset_init(struct msm_dsi *msm_dsi, struct drm_device *dev,
 		return -EINVAL;
 
 	priv = dev->dev_private;
+
+	if (priv->num_bridges == ARRAY_SIZE(priv->bridges)) {
+		DRM_DEV_ERROR(dev->dev, "too many bridges\n");
+		return -ENOSPC;
+	}
+
 	msm_dsi->dev = dev;
 
 	ret = msm_dsi_host_modeset_init(msm_dsi->host, dev);

