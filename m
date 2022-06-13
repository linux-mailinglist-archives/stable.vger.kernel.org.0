Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5AE54965B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239611AbiFMNAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357875AbiFMM71 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:59:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C59C140EE;
        Mon, 13 Jun 2022 04:17:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F1C960F0F;
        Mon, 13 Jun 2022 11:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A248EC3411F;
        Mon, 13 Jun 2022 11:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119073;
        bh=7iYH8eZA6jlwZ2yEjqyVc4ibsuQiRv2sCP6f1vHEVhQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yV9MjYzCvC+h7mhTfU+HFl5+k+kPx5/PGJUA5R1NemAF4AfH5fJdwa26bY5ZWxnL+
         Pq9eD9yX4c607ks8TOyPOlyMnbdRDclWrwgaEH5OkH3lyePVNRDWadiZRLSXSjsaiq
         06KjQ98gUCc86nkBKjmPRn0fCwfQtkT1UaWV4QpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/247] drm/bridge: sn65dsi83: Fix an error handling path in sn65dsi83_probe()
Date:   Mon, 13 Jun 2022 12:10:32 +0200
Message-Id: <20220613094926.903009630@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/gpu/drm/bridge/ti-sn65dsi83.c | 34 ++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi83.c b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
index a32f70bc68ea..bf469e8ac563 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -608,10 +608,14 @@ static int sn65dsi83_parse_dt(struct sn65dsi83 *ctx, enum sn65dsi83_model model)
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
@@ -638,16 +642,22 @@ static int sn65dsi83_parse_dt(struct sn65dsi83 *ctx, enum sn65dsi83_model model)
 
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
 
 static int sn65dsi83_probe(struct i2c_client *client,
@@ -680,8 +690,10 @@ static int sn65dsi83_probe(struct i2c_client *client,
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
@@ -691,6 +703,10 @@ static int sn65dsi83_probe(struct i2c_client *client,
 	drm_bridge_add(&ctx->bridge);
 
 	return 0;
+
+err_put_node:
+	of_node_put(ctx->host_node);
+	return ret;
 }
 
 static int sn65dsi83_remove(struct i2c_client *client)
-- 
2.35.1



