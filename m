Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF349A6F79
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731197AbfICQbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731171AbfICQbs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:31:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08BE2238D0;
        Tue,  3 Sep 2019 16:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528306;
        bh=9O9BraUo5IvLn0Sw1l0/oYmpxdePNV92iG5PqiT23Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9+bs4uxxSXQJvz9Q8IcdM0XVY6v0dWmnJeaPP0bnq+glYcBd02/JBh2e9ohRTjUZ
         lbPIiRZX20pr+9bMHzwOdVR4k+NTxDOJidDrDJrfWmSiMmqOVAaqS1HIwqkGab877H
         Q8Mt4Czl7y95dpnMestrznHnsohgSms6FqYNyqUs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>, Rob Herring <robh@kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 147/167] drm/panel: Add support for Armadeus ST0700 Adapt
Date:   Tue,  3 Sep 2019 12:24:59 -0400
Message-Id: <20190903162519.7136-147-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sébastien Szymanski <sebastien.szymanski@armadeus.com>

[ Upstream commit c479450f61c7f1f248c9a54aedacd2a6ca521ff8 ]

This patch adds support for the Armadeus ST0700 Adapt. It comes with a
Santek ST0700I5Y-RBSLW 7.0" WVGA (800x480) TFT and an adapter board so
that it can be connected on the TFT header of Armadeus Dev boards.

Cc: stable@vger.kernel.org # v4.19
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190507152713.27494-1-sebastien.szymanski@armadeus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/panel/armadeus,st0700-adapt.txt   |  9 ++++++
 drivers/gpu/drm/panel/panel-simple.c          | 29 +++++++++++++++++++
 2 files changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/display/panel/armadeus,st0700-adapt.txt

diff --git a/Documentation/devicetree/bindings/display/panel/armadeus,st0700-adapt.txt b/Documentation/devicetree/bindings/display/panel/armadeus,st0700-adapt.txt
new file mode 100644
index 0000000000000..a30d63db3c8f7
--- /dev/null
+++ b/Documentation/devicetree/bindings/display/panel/armadeus,st0700-adapt.txt
@@ -0,0 +1,9 @@
+Armadeus ST0700 Adapt. A Santek ST0700I5Y-RBSLW 7.0" WVGA (800x480) TFT with
+an adapter board.
+
+Required properties:
+- compatible: "armadeus,st0700-adapt"
+- power-supply: see panel-common.txt
+
+Optional properties:
+- backlight: see panel-common.txt
diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index b1d41c4921dd5..5fd94e2060297 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -436,6 +436,32 @@ static const struct panel_desc ampire_am800480r3tmqwa1h = {
 	.bus_format = MEDIA_BUS_FMT_RGB666_1X18,
 };
 
+static const struct display_timing santek_st0700i5y_rbslw_f_timing = {
+	.pixelclock = { 26400000, 33300000, 46800000 },
+	.hactive = { 800, 800, 800 },
+	.hfront_porch = { 16, 210, 354 },
+	.hback_porch = { 45, 36, 6 },
+	.hsync_len = { 1, 10, 40 },
+	.vactive = { 480, 480, 480 },
+	.vfront_porch = { 7, 22, 147 },
+	.vback_porch = { 22, 13, 3 },
+	.vsync_len = { 1, 10, 20 },
+	.flags = DISPLAY_FLAGS_HSYNC_LOW | DISPLAY_FLAGS_VSYNC_LOW |
+		DISPLAY_FLAGS_DE_HIGH | DISPLAY_FLAGS_PIXDATA_POSEDGE
+};
+
+static const struct panel_desc armadeus_st0700_adapt = {
+	.timings = &santek_st0700i5y_rbslw_f_timing,
+	.num_timings = 1,
+	.bpc = 6,
+	.size = {
+		.width = 154,
+		.height = 86,
+	},
+	.bus_format = MEDIA_BUS_FMT_RGB666_1X18,
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_POSEDGE,
+};
+
 static const struct drm_display_mode auo_b101aw03_mode = {
 	.clock = 51450,
 	.hdisplay = 1024,
@@ -2330,6 +2356,9 @@ static const struct of_device_id platform_of_match[] = {
 	}, {
 		.compatible = "ampire,am800480r3tmqwa1h",
 		.data = &ampire_am800480r3tmqwa1h,
+	}, {
+		.compatible = "armadeus,st0700-adapt",
+		.data = &armadeus_st0700_adapt,
 	}, {
 		.compatible = "auo,b101aw03",
 		.data = &auo_b101aw03,
-- 
2.20.1

