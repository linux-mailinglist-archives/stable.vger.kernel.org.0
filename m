Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA12A5B69FE
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 10:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiIMI61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 04:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbiIMI6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 04:58:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAF94AD5A;
        Tue, 13 Sep 2022 01:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49CDA6135A;
        Tue, 13 Sep 2022 08:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5E1C43140;
        Tue, 13 Sep 2022 08:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663059499;
        bh=r1eIu70bO7F9bGV6RWNcBBZbjBFCSkRWrK4jhR8b81E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nQy9QDTqYcg6AwZbRN6/VcgbPD6oXsVS/16HS3Pg3SRXuLbK7F+9nUItA3tDZwXgQ
         FU8D5+2TR6NMsVE24B7YQoTwGuzPB3gAEByBOZhPnceiCbd6zZZa0Zb9Q/HcKTlzaj
         8W0qzThQOD4v6mItJlXt/vSYfpKf6VOqAQJ6ml4X3Xw5pyHQzn+LtpdxEKUL33sFAH
         cE41Prc+9ORsjtV/AegXPCW0UWu4v1asUWj6Njb3t/hsobpqd8bEwpZ4IFHzd8uvf1
         UprUgETBsjLXNnVVjXA5F32p+SHS8WPCIOZrsjhLFddDc7/uJd39huyF19xTpqsOvI
         ScfbMgS6oweaQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1oY1kI-0002HC-Qj; Tue, 13 Sep 2022 10:58:18 +0200
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
Subject: [PATCH v2 06/10] drm/msm/dp: fix aux-bus EP lifetime
Date:   Tue, 13 Sep 2022 10:53:16 +0200
Message-Id: <20220913085320.8577-7-johan+linaro@kernel.org>
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

For the DP aux-bus, an attempt to populate the bus a second time will
simply fail ("DP AUX EP device already populated").

Fix this by tying the lifetime of the EP device to the DRM device rather
than DP controller platform device.

Fixes: c3bf8e21b38a ("drm/msm/dp: Add eDP support via aux_bus")
Cc: stable@vger.kernel.org      # 5.19
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index ba557328710a..4b0a2d4bb61e 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1535,6 +1535,11 @@ void msm_dp_debugfs_init(struct msm_dp *dp_display, struct drm_minor *minor)
 	}
 }
 
+static void of_dp_aux_depopulate_bus_void(void *data)
+{
+	of_dp_aux_depopulate_bus(data);
+}
+
 static int dp_display_get_next_bridge(struct msm_dp *dp)
 {
 	int rc;
@@ -1559,10 +1564,16 @@ static int dp_display_get_next_bridge(struct msm_dp *dp)
 		 * panel driver is probed asynchronously but is the best we
 		 * can do without a bigger driver reorganization.
 		 */
-		rc = devm_of_dp_aux_populate_ep_devices(dp_priv->aux);
+		rc = of_dp_aux_populate_bus(dp_priv->aux, NULL);
 		of_node_put(aux_bus);
 		if (rc)
 			goto error;
+
+		rc = devm_add_action_or_reset(dp->drm_dev->dev,
+						of_dp_aux_depopulate_bus_void,
+						dp_priv->aux);
+		if (rc)
+			goto error;
 	} else if (dp->is_edp) {
 		DRM_ERROR("eDP aux_bus not found\n");
 		return -ENODEV;
-- 
2.35.1

