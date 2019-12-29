Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC2A812C453
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfL2R2l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:28:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728631AbfL2R2i (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:28:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E28C207FF;
        Sun, 29 Dec 2019 17:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640518;
        bh=YsgsMgpCNoPlVFfGGXF3ihX+a0nBK/I3m6tOfWc9AD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8Da4b76irEaR+m+SLOF8f+ut97k5b0xOKv2IvalEsl3RCJTVEELWNmikqTZtB+S1
         5N4ZKi9wR6XrBFLI3ni/G4Gq1yOowzFMelkmJqs4tsE+iecd5XBzC7VLHZlvRsh8So
         EaPjd+vEFs9G5eeM3YlSIKk4Z1Rxhqcz/C8Yt9Cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/219] drm/panel: Add missing drm_panel_init() in panel drivers
Date:   Sun, 29 Dec 2019 18:17:10 +0100
Message-Id: <20191229162512.889829162@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 65abbda8ed7ca48c8807d6b04a77431b438fa659 ]

Panels must be initialised with drm_panel_init(). Add the missing
function call in the panel-raspberrypi-touchscreen.c and
panel-sitronix-st7789v.c drivers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190823193245.23876-2-laurent.pinchart@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c | 1 +
 drivers/gpu/drm/panel/panel-sitronix-st7789v.c        | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
index 9a2cb8aeab3a..aab6a70ece7f 100644
--- a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
+++ b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
@@ -427,6 +427,7 @@ static int rpi_touchscreen_probe(struct i2c_client *i2c,
 		return PTR_ERR(ts->dsi);
 	}
 
+	drm_panel_init(&ts->base);
 	ts->base.dev = dev;
 	ts->base.funcs = &rpi_touchscreen_funcs;
 
diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
index 74284e5afc5d..89fa17877b33 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
@@ -380,6 +380,7 @@ static int st7789v_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, ctx);
 	ctx->spi = spi;
 
+	drm_panel_init(&ctx->panel);
 	ctx->panel.dev = &spi->dev;
 	ctx->panel.funcs = &st7789v_drm_funcs;
 
-- 
2.20.1



