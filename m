Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7504F27A8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232674AbiDEIHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbiDEIC0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:02:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2627527DF;
        Tue,  5 Apr 2022 01:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64929B81B16;
        Tue,  5 Apr 2022 08:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26F0C3410F;
        Tue,  5 Apr 2022 08:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145626;
        bh=WdPlJDC9x81Zim69NDL6sdEbOngFjzL0RXWjGHu9Y60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mckI7AnAQ8bC8TKybIHzSmMVKv1VkfmzBecasBY51GD/lXdq8MSF0B5lS+9cTsteH
         csolK2YZv6n8VZCJ+HSe6pmUGvK7nbi6nT0v8VGobOp6CYP9+wKH7/f2IgOCUxzcpg
         LF6PZ71C8LHwfjWvArlhpMJp2EjhR6N1JsWdXtzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0422/1126] drm/bridge: sn65dsi83: Fix an error handling path in sn65dsi83_probe()
Date:   Tue,  5 Apr 2022 09:19:29 +0200
Message-Id: <20220405070420.011603627@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6edf615618b8259f16eeb1df98f0ba0d2312c22e ]

sn65dsi83_parse_dt() takes a reference on 'ctx->host_node' that must be
released in the error handling path of this function and of the probe.
This is only done in the remove function up to now.

Fixes: ceb515ba29ba ("drm/bridge: ti-sn65dsi83: Add TI SN65DSI83 and SN65DSI84 driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/4bc21aed4b60d3d5ac4b28d8b07a6fdd8da6a536.1640768126.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c | 32 +++++++++++++++++++--------
 1 file changed, 23 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi83.c b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
index 945f08de45f1..314a84ffcea3 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -560,10 +560,14 @@ static int sn65dsi83_parse_dt(struct sn65dsi83 *ctx, enum sn65dsi83_model model)
 	ctx->host_node = of_graph_get_remote_port_parent(endpoint);
 	of_node_put(endpoint);
 
-	if (ctx->dsi_lanes < 0 || ctx->dsi_lanes > 4)
-		return -EINVAL;
-	if (!ctx->host_node)
-		return -ENODEV;
+	if (ctx->dsi_lanes < 0 || ctx->dsi_lanes > 4) {
+		ret = -EINVAL;
+		goto err_put_node;
+	}
+	if (!ctx->host_node) {
+		ret = -ENODEV;
+		goto err_put_node;
+	}
 
 	ctx->lvds_dual_link = false;
 	ctx->lvds_dual_link_even_odd_swap = false;
@@ -590,16 +594,22 @@ static int sn65dsi83_parse_dt(struct sn65dsi83 *ctx, enum sn65dsi83_model model)
 
 	ret = drm_of_find_panel_or_bridge(dev->of_node, 2, 0, &panel, &panel_bridge);
 	if (ret < 0)
-		return ret;
+		goto err_put_node;
 	if (panel) {
 		panel_bridge = devm_drm_panel_bridge_add(dev, panel);
-		if (IS_ERR(panel_bridge))
-			return PTR_ERR(panel_bridge);
+		if (IS_ERR(panel_bridge)) {
+			ret = PTR_ERR(panel_bridge);
+			goto err_put_node;
+		}
 	}
 
 	ctx->panel_bridge = panel_bridge;
 
 	return 0;
+
+err_put_node:
+	of_node_put(ctx->host_node);
+	return ret;
 }
 
 static int sn65dsi83_host_attach(struct sn65dsi83 *ctx)
@@ -673,8 +683,10 @@ static int sn65dsi83_probe(struct i2c_client *client,
 		return ret;
 
 	ctx->regmap = devm_regmap_init_i2c(client, &sn65dsi83_regmap_config);
-	if (IS_ERR(ctx->regmap))
-		return PTR_ERR(ctx->regmap);
+	if (IS_ERR(ctx->regmap)) {
+		ret = PTR_ERR(ctx->regmap);
+		goto err_put_node;
+	}
 
 	dev_set_drvdata(dev, ctx);
 	i2c_set_clientdata(client, ctx);
@@ -691,6 +703,8 @@ static int sn65dsi83_probe(struct i2c_client *client,
 
 err_remove_bridge:
 	drm_bridge_remove(&ctx->bridge);
+err_put_node:
+	of_node_put(ctx->host_node);
 	return ret;
 }
 
-- 
2.34.1



