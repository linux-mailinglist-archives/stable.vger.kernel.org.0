Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91132328CE6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhCATB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:01:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240790AbhCASxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:53:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E63E652FF;
        Mon,  1 Mar 2021 17:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620500;
        bh=+fWMW4hbZLQyi3W48S8xyXMDuZELvjioGHJ/K7T+Gto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rr6bV4JxUoCppEUljrnKUiawYzu85ripJ6gauPyKJb51tIly1wRrO3QwqqW75wMFZ
         SZ5tCvzxx7B3RnfW0bgCkGZigOOcHMWzksjlrCMgLuAwDa9gxcXG77UajS1DWJP0kO
         BpNr2wnP1n5jApl3hrEPWjUeE09xTkQYeHBh+vg0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Gerhold <stephan@gerhold.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 176/775] drm/panel: s6e63m0: Support max-brightness
Date:   Mon,  1 Mar 2021 17:05:44 +0100
Message-Id: <20210301161210.327472163@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 1f20bf5921de420071fdb1d55cda7550ae137bcd ]

The "max-brightness" is a standard backlight property that
we need to support for the Samsung GT-I8190 Golden because
the display will go black if we crank up the brightness
too high.

As the platform needs this ability to give picture this is
a regression fix along with the addition of the property
to the GT-I8190 device tree.

Cc: Stephan Gerhold <stephan@gerhold.net>
Fixes: 9c3f0a0dd6a1 ("drm/panel: s6e63m0: Implement 28 backlight levels")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20201214222210.238081-1-linus.walleij@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-samsung-s6e63m0.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-samsung-s6e63m0.c b/drivers/gpu/drm/panel/panel-samsung-s6e63m0.c
index bf6d704d4d272..603c5dfe87682 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6e63m0.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6e63m0.c
@@ -692,12 +692,12 @@ static const struct backlight_ops s6e63m0_backlight_ops = {
 	.update_status	= s6e63m0_set_brightness,
 };
 
-static int s6e63m0_backlight_register(struct s6e63m0 *ctx)
+static int s6e63m0_backlight_register(struct s6e63m0 *ctx, u32 max_brightness)
 {
 	struct backlight_properties props = {
 		.type		= BACKLIGHT_RAW,
-		.brightness	= MAX_BRIGHTNESS,
-		.max_brightness = MAX_BRIGHTNESS
+		.brightness	= max_brightness,
+		.max_brightness = max_brightness,
 	};
 	struct device *dev = ctx->dev;
 	int ret = 0;
@@ -719,6 +719,7 @@ int s6e63m0_probe(struct device *dev,
 		  bool dsi_mode)
 {
 	struct s6e63m0 *ctx;
+	u32 max_brightness;
 	int ret;
 
 	ctx = devm_kzalloc(dev, sizeof(struct s6e63m0), GFP_KERNEL);
@@ -734,6 +735,14 @@ int s6e63m0_probe(struct device *dev,
 	ctx->enabled = false;
 	ctx->prepared = false;
 
+	ret = device_property_read_u32(dev, "max-brightness", &max_brightness);
+	if (ret)
+		max_brightness = MAX_BRIGHTNESS;
+	if (max_brightness > MAX_BRIGHTNESS) {
+		dev_err(dev, "illegal max brightness specified\n");
+		max_brightness = MAX_BRIGHTNESS;
+	}
+
 	ctx->supplies[0].supply = "vdd3";
 	ctx->supplies[1].supply = "vci";
 	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(ctx->supplies),
@@ -753,7 +762,7 @@ int s6e63m0_probe(struct device *dev,
 		       dsi_mode ? DRM_MODE_CONNECTOR_DSI :
 		       DRM_MODE_CONNECTOR_DPI);
 
-	ret = s6e63m0_backlight_register(ctx);
+	ret = s6e63m0_backlight_register(ctx, max_brightness);
 	if (ret < 0)
 		return ret;
 
-- 
2.27.0



