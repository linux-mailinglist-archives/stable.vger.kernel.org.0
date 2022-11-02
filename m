Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7E36157E5
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiKBClM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiKBClM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:41:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3466F20993
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:41:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6BF4616DB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71376C433D6;
        Wed,  2 Nov 2022 02:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356870;
        bh=WBmEIrdnw6PO+mDDbNpMUaeTjs2zaWtdWZVaJG6oYj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHYtMg7VyD73ldfr1Q/A66xdqD59pZJ3umTnfUaVjFNqv1yII2KUDCJQLzJEPjrhP
         eSiMwpaQ3yoEqCfAMg/iNEdP3mo5m3kF7WBrvZlslwW7DZNSya0jFks/PhKCOUnZ1g
         tuamPnhtt4xVWd1X4SnChtSeNxtM2sZbtEf4EOwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.0 074/240] drm/msm/dp: fix bridge lifetime
Date:   Wed,  2 Nov 2022 03:30:49 +0100
Message-Id: <20221102022113.076874642@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 16194958f888d63839042d1190f7001e5ddec47b upstream.

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
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/502667/
Link: https://lore.kernel.org/r/20220913085320.8577-8-johan+linaro@kernel.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 2 +-
 drivers/gpu/drm/msm/dp/dp_parser.c  | 6 +++---
 drivers/gpu/drm/msm/dp/dp_parser.h  | 5 +++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 42de690132cf..a49f6dbbe888 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1579,7 +1579,7 @@ static int dp_display_get_next_bridge(struct msm_dp *dp)
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
2.38.1



