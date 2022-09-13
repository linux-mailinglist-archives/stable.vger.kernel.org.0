Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA5685B6A00
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 10:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbiIMI62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 04:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231488AbiIMI6Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 04:58:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 094565A2C7;
        Tue, 13 Sep 2022 01:58:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F300B80E40;
        Tue, 13 Sep 2022 08:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18A0C43148;
        Tue, 13 Sep 2022 08:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663059499;
        bh=ZcIqc1knQDBLZsYiRURyGWfkmlLHu5K+oQ6ruURZbro=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTS3FNdE+EXltnMNa9h3t5HHxPDAV3FkjYxZXZzxxwatDqjnDieL8UI0YWbk3+iRb
         BYy/ihxt8Axd+nQdQEB01mz3/qyk45lVZObDGOXWKYcwU+RlPwzG9oEWcWwa/CwNaP
         VabYvOC67nBvjxScVUlui7LW43A71MqP2oFx6GcjJNtedJ+8fyXxPgDtxp3trnLsj0
         BS//ga8N7p+JuouJuIItXfONiqKN1QPnvwrIbM6xViGfA/7mkq4NiQtlmJjA8DM77T
         DGSMD2iNG+tKarvowIoAkyZ6TfXzN1jeaD0S4evUL+kPlMaYQXK3IKbPa1qv4d83Zb
         6lY2Bo2+YYUGQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1oY1kI-0002HE-TH; Tue, 13 Sep 2022 10:58:18 +0200
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Douglas Anderson <dianders@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@gmail.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc:     Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, Sean Paul <sean@poorly.run>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Steev Klimaszewski <steev@kali.org>,
        dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
        freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v2 07/10] drm/msm/dp: fix bridge lifetime
Date:   Tue, 13 Sep 2022 10:53:17 +0200
Message-Id: <20220913085320.8577-8-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220913085320.8577-1-johan+linaro@kernel.org>
References: <20220913085320.8577-1-johan+linaro@kernel.org>
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
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 2 +-
 drivers/gpu/drm/msm/dp/dp_parser.c  | 6 +++---
 drivers/gpu/drm/msm/dp/dp_parser.h  | 5 +++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 4b0a2d4bb61e..808a516e84c5 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1586,7 +1586,7 @@ static int dp_display_get_next_bridge(struct msm_dp *dp)
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

