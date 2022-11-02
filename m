Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35E96157E3
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiKBClD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiKBClC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:41:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 330CB1FCF2
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2C52B82073
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA938C433D6;
        Wed,  2 Nov 2022 02:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667356858;
        bh=n9v04feawbnhZT9lKEgnT9vkdbjyv2tsABZUHgqfayY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vW6/vvFyCym3gFZD37Eh3SnqV7KhYc5pVT2Xdv/wjqlQU5fF4snu2OjiOEa38U7cm
         j+uxfc9AZvLvEFwgMRjrUVyRd9LTrziN6SmyeZ1X/RTFJJyygAV5wAZUmBN7H0p96h
         thUNomsZP3BMSy1YeToLOr1h9ONZ/DQmTUkV71hM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Kuogee Hsieh <quic_khsieh@quicinc.com>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>
Subject: [PATCH 6.0 072/240] drm/msm/dp: fix aux-bus EP lifetime
Date:   Wed,  2 Nov 2022 03:30:47 +0100
Message-Id: <20221102022113.031386155@linuxfoundation.org>
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

commit 2b57f726611e294dc4297dd48eb8c98ef1938e82 upstream.

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
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/502672/
Link: https://lore.kernel.org/r/20220913085320.8577-7-johan+linaro@kernel.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dp/dp_display.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dp/dp_display.c b/drivers/gpu/drm/msm/dp/dp_display.c
index 352cc09f2069..42de690132cf 100644
--- a/drivers/gpu/drm/msm/dp/dp_display.c
+++ b/drivers/gpu/drm/msm/dp/dp_display.c
@@ -1528,6 +1528,11 @@ void msm_dp_debugfs_init(struct msm_dp *dp_display, struct drm_minor *minor)
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
@@ -1552,10 +1557,16 @@ static int dp_display_get_next_bridge(struct msm_dp *dp)
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
2.38.1



