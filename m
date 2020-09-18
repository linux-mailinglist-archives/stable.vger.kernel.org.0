Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5576B26F35B
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgIRDGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIRCEH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C44121734;
        Fri, 18 Sep 2020 02:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394647;
        bh=Hcyl6z3B1/m/mJGIPwQu7w5hswHWOPYrcDWuFQMM60k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RY4fdy3gLerpKO+sVX16hMNUXELWhutGcDpKiJnYmyhvgxirDjtzjM/GQIburxZW6
         KoaMN1RtOqRbxCXATHUve6WTCg1IhvyJgaUgrQiRoo909ERzhkpjxOu8xKfFyE0/vr
         IZjfAZffs93F+oT4D1OKgOYPT0JFXTHZSecM0TXQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 144/330] drm/omap: dss: Cleanup DSS ports on initialisation failure
Date:   Thu, 17 Sep 2020 21:58:04 -0400
Message-Id: <20200918020110.2063155-144-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 2a0a3ae17d36fa86dcf7c8e8d7b7f056ebd6c064 ]

When the DSS initialises its output DPI and SDI ports, failures don't
clean up previous successfully initialised ports. This can lead to
resource leak or memory corruption. Fix it.

Reported-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Tested-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200226112514.12455-22-laurent.pinchart@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/dss/dss.c | 43 +++++++++++++++++++------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/dss/dss.c b/drivers/gpu/drm/omapdrm/dss/dss.c
index 4bdd63b571002..ac93dae2a9c84 100644
--- a/drivers/gpu/drm/omapdrm/dss/dss.c
+++ b/drivers/gpu/drm/omapdrm/dss/dss.c
@@ -1151,46 +1151,38 @@ static const struct dss_features dra7xx_dss_feats = {
 	.has_lcd_clk_src	=	true,
 };
 
-static int dss_init_ports(struct dss_device *dss)
+static void __dss_uninit_ports(struct dss_device *dss, unsigned int num_ports)
 {
 	struct platform_device *pdev = dss->pdev;
 	struct device_node *parent = pdev->dev.of_node;
 	struct device_node *port;
 	unsigned int i;
-	int r;
 
-	for (i = 0; i < dss->feat->num_ports; i++) {
+	for (i = 0; i < num_ports; i++) {
 		port = of_graph_get_port_by_id(parent, i);
 		if (!port)
 			continue;
 
 		switch (dss->feat->ports[i]) {
 		case OMAP_DISPLAY_TYPE_DPI:
-			r = dpi_init_port(dss, pdev, port, dss->feat->model);
-			if (r)
-				return r;
+			dpi_uninit_port(port);
 			break;
-
 		case OMAP_DISPLAY_TYPE_SDI:
-			r = sdi_init_port(dss, pdev, port);
-			if (r)
-				return r;
+			sdi_uninit_port(port);
 			break;
-
 		default:
 			break;
 		}
 	}
-
-	return 0;
 }
 
-static void dss_uninit_ports(struct dss_device *dss)
+static int dss_init_ports(struct dss_device *dss)
 {
 	struct platform_device *pdev = dss->pdev;
 	struct device_node *parent = pdev->dev.of_node;
 	struct device_node *port;
-	int i;
+	unsigned int i;
+	int r;
 
 	for (i = 0; i < dss->feat->num_ports; i++) {
 		port = of_graph_get_port_by_id(parent, i);
@@ -1199,15 +1191,32 @@ static void dss_uninit_ports(struct dss_device *dss)
 
 		switch (dss->feat->ports[i]) {
 		case OMAP_DISPLAY_TYPE_DPI:
-			dpi_uninit_port(port);
+			r = dpi_init_port(dss, pdev, port, dss->feat->model);
+			if (r)
+				goto error;
 			break;
+
 		case OMAP_DISPLAY_TYPE_SDI:
-			sdi_uninit_port(port);
+			r = sdi_init_port(dss, pdev, port);
+			if (r)
+				goto error;
 			break;
+
 		default:
 			break;
 		}
 	}
+
+	return 0;
+
+error:
+	__dss_uninit_ports(dss, i);
+	return r;
+}
+
+static void dss_uninit_ports(struct dss_device *dss)
+{
+	__dss_uninit_ports(dss, dss->feat->num_ports);
 }
 
 static int dss_video_pll_probe(struct dss_device *dss)
-- 
2.25.1

