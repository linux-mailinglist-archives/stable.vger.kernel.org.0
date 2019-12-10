Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED091192C2
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfLJVEK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:04:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:48890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbfLJVEK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:04:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E906B22B48;
        Tue, 10 Dec 2019 21:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576011849;
        bh=LHlXup6UK4obdIwh8GDiEqMZRzr9DxRSOQoyLqXkURQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WB8SeYI1kRl/WUmM+IkN+7PsRraMOkci8qcPpyPuPlZ6VPEUS9z084+n3URgRz78W
         JizKiA+DL/IcNyd5xk5XRV6fnFblNKlb4cNqm4wLXoYXaPlockcwW8dP9Lb37m3xI+
         8N8rn4dwkkJs+0WZJVEeWlV1MD+fFSoL1D8fRg6M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 005/350] drm/panel: Add missing drm_panel_init() in panel drivers
Date:   Tue, 10 Dec 2019 15:58:17 -0500
Message-Id: <20191210210402.8367-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210402.8367-1-sashal@kernel.org>
References: <20191210210402.8367-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b5b14aa059ea7..2aa89eaecf6ff 100644
--- a/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
+++ b/drivers/gpu/drm/panel/panel-raspberrypi-touchscreen.c
@@ -426,6 +426,7 @@ static int rpi_touchscreen_probe(struct i2c_client *i2c,
 		return PTR_ERR(ts->dsi);
 	}
 
+	drm_panel_init(&ts->base);
 	ts->base.dev = dev;
 	ts->base.funcs = &rpi_touchscreen_funcs;
 
diff --git a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
index 5e3e92ea9ea69..3b2612ae931e8 100644
--- a/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
+++ b/drivers/gpu/drm/panel/panel-sitronix-st7789v.c
@@ -381,6 +381,7 @@ static int st7789v_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, ctx);
 	ctx->spi = spi;
 
+	drm_panel_init(&ctx->panel);
 	ctx->panel.dev = &spi->dev;
 	ctx->panel.funcs = &st7789v_drm_funcs;
 
-- 
2.20.1

