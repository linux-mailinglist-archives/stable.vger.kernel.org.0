Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6EBC796F9
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404103AbfG2Tyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:54:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404094AbfG2Tyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:54:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 627A0204EC;
        Mon, 29 Jul 2019 19:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430082;
        bh=3K7M/8egWQFv845UWWMbiOsoAy/k7SPRgJ5lUK/hYHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=URVp9SRq0y/aPvesXXsRd6EuGXfWJuhQdwsPQY5XnJyWsvl+mG+2l+VnJJotnlbG/
         h9jQVgwsKybhgm3NreilD1HFn1bs/8DZLQBtCxEJ2i07yg2Z0SBdRrPpLGqb0k1MTq
         UNX1aukPFY0gTMIVEj+Gbb4KRvW+yj1KHozclvvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh@kernel.org>,
        =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5.2 190/215] drm/panel: Add support for Armadeus ST0700 Adapt
Date:   Mon, 29 Jul 2019 21:23:06 +0200
Message-Id: <20190729190812.945504045@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sébastien Szymanski <sebastien.szymanski@armadeus.com>

commit c479450f61c7f1f248c9a54aedacd2a6ca521ff8 upstream.

This patch adds support for the Armadeus ST0700 Adapt. It comes with a
Santek ST0700I5Y-RBSLW 7.0" WVGA (800x480) TFT and an adapter board so
that it can be connected on the TFT header of Armadeus Dev boards.

Cc: stable@vger.kernel.org # v4.19
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20190507152713.27494-1-sebastien.szymanski@armadeus.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/devicetree/bindings/display/panel/armadeus,st0700-adapt.txt |    9 +++
 drivers/gpu/drm/panel/panel-simple.c                                      |   29 ++++++++++
 2 files changed, 38 insertions(+)

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
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -446,6 +446,32 @@ static const struct panel_desc ampire_am
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
@@ -2571,6 +2597,9 @@ static const struct of_device_id platfor
 		.compatible = "arm,rtsm-display",
 		.data = &arm_rtsm,
 	}, {
+		.compatible = "armadeus,st0700-adapt",
+		.data = &armadeus_st0700_adapt,
+	}, {
 		.compatible = "auo,b101aw03",
 		.data = &auo_b101aw03,
 	}, {


