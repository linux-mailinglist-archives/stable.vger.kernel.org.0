Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BEC594798
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244291AbiHOXRh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245147AbiHOXOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:14:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C397B78B;
        Mon, 15 Aug 2022 13:01:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C490861299;
        Mon, 15 Aug 2022 20:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FBDC433D6;
        Mon, 15 Aug 2022 20:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593713;
        bh=HP39KPqdqksGKJfeQWjmY9CTR5tnvz9szc3sM6Ae8eE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zeBOSdbp9iogl9cD7QA4o0cXm7JRvIDmRkBLZZG2NsNItKW1CeE34ZFO8mvmPzHi0
         UrvXGnWe/FcCPUUvpp4cFH7SwyA8ySpD6n0ePy/kBK66hqEgD16jB8Cz5upPOahxu6
         LIGgsEkCunWqKjQRhgyreDqoDMqfa/zy9NX4LLaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Jonas Karlman <jonas@kwiboo.se>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0314/1157] drm/bridge: tc358767: Make sure Refclk clock are enabled
Date:   Mon, 15 Aug 2022 19:54:30 +0200
Message-Id: <20220815180452.214114121@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

[ Upstream commit 0b4c48f3e315d172e4cc06e10f2c8ba180788baf ]

The Refclk may be supplied by SoC clock output instead of crystal
oscillator, make sure the clock are enabled before any other action
is performed with the bridge chip, otherwise it may either fail to
operate at all, or miss reset GPIO toggle.

Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Fixes: 7caff0fc4296e ("drm/bridge: tc358767: Add DPI to eDP bridge driver")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Marek Vasut <marex@denx.de>
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220520121543.11550-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 32 ++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 466b8fc9836a..16affb42086a 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -2004,6 +2004,13 @@ static int tc_probe_bridge_endpoint(struct tc_data *tc)
 	return -EINVAL;
 }
 
+static void tc_clk_disable(void *data)
+{
+	struct clk *refclk = data;
+
+	clk_disable_unprepare(refclk);
+}
+
 static int tc_probe(struct i2c_client *client, const struct i2c_device_id *id)
 {
 	struct device *dev = &client->dev;
@@ -2020,6 +2027,24 @@ static int tc_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (ret)
 		return ret;
 
+	tc->refclk = devm_clk_get(dev, "ref");
+	if (IS_ERR(tc->refclk)) {
+		ret = PTR_ERR(tc->refclk);
+		dev_err(dev, "Failed to get refclk: %d\n", ret);
+		return ret;
+	}
+
+	ret = clk_prepare_enable(tc->refclk);
+	if (ret)
+		return ret;
+
+	ret = devm_add_action_or_reset(dev, tc_clk_disable, tc->refclk);
+	if (ret)
+		return ret;
+
+	/* tRSTW = 100 cycles , at 13 MHz that is ~7.69 us */
+	usleep_range(10, 15);
+
 	/* Shut down GPIO is optional */
 	tc->sd_gpio = devm_gpiod_get_optional(dev, "shutdown", GPIOD_OUT_HIGH);
 	if (IS_ERR(tc->sd_gpio))
@@ -2040,13 +2065,6 @@ static int tc_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		usleep_range(5000, 10000);
 	}
 
-	tc->refclk = devm_clk_get(dev, "ref");
-	if (IS_ERR(tc->refclk)) {
-		ret = PTR_ERR(tc->refclk);
-		dev_err(dev, "Failed to get refclk: %d\n", ret);
-		return ret;
-	}
-
 	tc->regmap = devm_regmap_init_i2c(client, &tc_regmap_config);
 	if (IS_ERR(tc->regmap)) {
 		ret = PTR_ERR(tc->regmap);
-- 
2.35.1



