Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271B1593F5C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346057AbiHOUwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346310AbiHOUui (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:50:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04939BA9D9;
        Mon, 15 Aug 2022 12:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15C2A6069E;
        Mon, 15 Aug 2022 19:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D338EC433D6;
        Mon, 15 Aug 2022 19:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590576;
        bh=Ro6xxxF1fVuz0fJmCgBArPo/LziyaAhePT/yijdPk/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBZ7vpvh90d75KTn+VlbKfR/17GmH0Ug/6KY0pE1UfNkQWUFLYAphAXHy2W8tgn8W
         UkLLEgHjUKNmRCzbKLRgJWy2jqGl2FDAKGzgCyEOlCdPvRufa7w6tAhefBlaS0082e
         QKWYD+H1xiqpoCWCS51scnP7K5KC/fpRuGQrOD3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Jonas Karlman <jonas@kwiboo.se>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0304/1095] drm/bridge: tc358767: Move (e)DP bridge endpoint parsing into dedicated function
Date:   Mon, 15 Aug 2022 19:55:03 +0200
Message-Id: <20220815180442.353613337@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 8478095a8c4bcea3c83b0767d6c9127434160761 ]

The TC358767/TC358867/TC9595 are all capable of operating in multiple
modes, DPI-to-(e)DP, DSI-to-(e)DP, DSI-to-DPI. Only the first mode is
currently supported. In order to support the rest of the modes without
making the tc_probe() overly long, split the bridge endpoint parsing
into dedicated function, where the necessary logic to detect the bridge
mode based on which endpoints are connected, can be implemented.

Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Tested-by: Lucas Stach <l.stach@pengutronix.de> # In both DPI to eDP and DSI to DPI mode.
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220329085015.39159-7-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index c23e0abc65e8..835a146a0196 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1549,19 +1549,12 @@ static irqreturn_t tc_irq_handler(int irq, void *arg)
 	return IRQ_HANDLED;
 }
 
-static int tc_probe(struct i2c_client *client, const struct i2c_device_id *id)
+static int tc_probe_edp_bridge_endpoint(struct tc_data *tc)
 {
-	struct device *dev = &client->dev;
+	struct device *dev = tc->dev;
 	struct drm_panel *panel;
-	struct tc_data *tc;
 	int ret;
 
-	tc = devm_kzalloc(dev, sizeof(*tc), GFP_KERNEL);
-	if (!tc)
-		return -ENOMEM;
-
-	tc->dev = dev;
-
 	/* port@2 is the output port */
 	ret = drm_of_find_panel_or_bridge(dev->of_node, 2, 0, &panel, NULL);
 	if (ret && ret != -ENODEV)
@@ -1580,6 +1573,25 @@ static int tc_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		tc->bridge.type = DRM_MODE_CONNECTOR_DisplayPort;
 	}
 
+	return ret;
+}
+
+static int tc_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	struct device *dev = &client->dev;
+	struct tc_data *tc;
+	int ret;
+
+	tc = devm_kzalloc(dev, sizeof(*tc), GFP_KERNEL);
+	if (!tc)
+		return -ENOMEM;
+
+	tc->dev = dev;
+
+	ret = tc_probe_edp_bridge_endpoint(tc);
+	if (ret)
+		return ret;
+
 	/* Shut down GPIO is optional */
 	tc->sd_gpio = devm_gpiod_get_optional(dev, "shutdown", GPIOD_OUT_HIGH);
 	if (IS_ERR(tc->sd_gpio))
-- 
2.35.1



