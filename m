Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9945B5D6F
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 17:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbiILPl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Sep 2022 11:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiILPl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Sep 2022 11:41:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215121D0F3;
        Mon, 12 Sep 2022 08:41:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7DC161254;
        Mon, 12 Sep 2022 15:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67BFC43470;
        Mon, 12 Sep 2022 15:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662997286;
        bh=66wIq+GWMs/sYpVYKkxofHK3eZwUltuTpqY+ZipnyME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnGLSV34wqjHLEQpsMdzfRyZKTEOCXvu1ggzoaemcCsCDtDnbwmVtzKa3LE6ILPn3
         xU2o/sbFW6+LyH9KhqNGmeSYIar7AQiNZUys9aB7h5cls0nry8iml/4qR8F68dSb+w
         TncIKVLwEKp/MoASdHUcECMG7CLWx8UZS6x3r1QSLgvja3kWIVCVv1q2iUr0bve7ur
         o0PhZewBA5Lqhq8GbMOvGGAUQW9Tn8GvuFDwe/moW7G943uiRCZbOjg85XaYglJcjQ
         toFVte3yOqQa9BZ7XN2rdYmA7HcG/0vSbVnQQ+hwZ6liliQMwf3OB5FeYZwWKeCiPt
         hct6wH8gZKIqQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1oXlYp-0003Mw-Hc; Mon, 12 Sep 2022 17:41:23 +0200
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
Subject: [PATCH 5/7] drm/msm/dp: fix bridge lifetime
Date:   Mon, 12 Sep 2022 17:40:44 +0200
Message-Id: <20220912154046.12900-6-johan+linaro@kernel.org>
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

Device-managed resources allocated post component bind must be tied to
the lifetime of the aggregate DRM device or they will not necessarily be
released when binding of the aggregate device is deferred.

This can lead resource leaks or failure to bind the aggregate device
when binding is later retried and a second attempt to allocate the
resources is made.

For the DP bridges, previously allocated bridges will leak on probe
deferral.

Fix this by amending the DP parser interface and tying the lifetime of
the bridge device to the DRM device rather than DP platform device.

Fixes: c3bf8e21b38a ("drm/msm/dp: Add eDP support via aux_bus")
Cc: stable@vger.kernel.org      # 5.19
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 2 +-
 drivers/gpu/drm/msm/dp/dp_parser.c  | 6 +++---
 drivers/gpu/drm/msm/dp/dp_parser.h  | 5 +++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index e1aa6355bbf6..393af1ea9ed8 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1576,7 +1576,7 @@ static int dp_display_get_next_bridge(struct msm_dp *dp)
 	 * For DisplayPort interfaces external bridges are optional, so
 	 * silently ignore an error if one is not present (-ENODEV).
 	 */
-	rc = dp_parser_find_next_bridge(dp_priv->parser);
+	rc = devm_dp_parser_find_next_bridge(dp->drm_dev->dev, dp_priv->parser);
 	if (!dp->is_edp && rc == -ENODEV)
 		return 0;
 
diff --git a/drivers/gpu/drm/msm/dp/dp_parser.c b/drivers/gpu/drm/msm/dp/dp_parser.c
index dd732215d55b..dcbe893d66d7 100644
--- a/drivers/gpu/drm/msm/dp/dp_parser.c
+++ b/drivers/gpu/drm/msm/dp/dp_parser.c
@@ -240,12 +240,12 @@ static int dp_parser_clock(struct dp_parser *parser)
 	return 0;
 }
 
-int dp_parser_find_next_bridge(struct dp_parser *parser)
+int devm_dp_parser_find_next_bridge(struct device *dev, struct dp_parser *parser)
 {
-	struct device *dev = &parser->pdev->dev;
+	struct platform_device *pdev = parser->pdev;
 	struct drm_bridge *bridge;
 
-	bridge = devm_drm_of_get_bridge(dev, dev->of_node, 1, 0);
+	bridge = devm_drm_of_get_bridge(dev, pdev->dev.of_node, 1, 0);
 	if (IS_ERR(bridge))
 		return PTR_ERR(bridge);
 
diff --git a/drivers/gpu/drm/msm/dp/dp_parser.h b/drivers/gpu/drm/msm/dp/dp_parser.h
index 866c1a82bf1a..d30ab773db46 100644
--- a/drivers/gpu/drm/msm/dp/dp_parser.h
+++ b/drivers/gpu/drm/msm/dp/dp_parser.h
@@ -138,8 +138,9 @@ struct dp_parser {
 struct dp_parser *dp_parser_get(struct platform_device *pdev);
 
 /**
- * dp_parser_find_next_bridge() - find an additional bridge to DP
+ * devm_dp_parser_find_next_bridge() - find an additional bridge to DP
  *
+ * @dev: device to tie bridge lifetime to
  * @parser: dp_parser data from client
  *
  * This function is used to find any additional bridge attached to
@@ -147,6 +148,6 @@ struct dp_parser *dp_parser_get(struct platform_device *pdev);
  *
  * Return: 0 if able to get the bridge, otherwise negative errno for failure.
  */
-int dp_parser_find_next_bridge(struct dp_parser *parser);
+int devm_dp_parser_find_next_bridge(struct device *dev, struct dp_parser *parser);
 
 #endif
-- 
2.35.1

