Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D192B1D0DE
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 22:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfENUxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 May 2019 16:53:07 -0400
Received: from mailoutvs31.siol.net ([185.57.226.222]:33481 "EHLO
        mail.siol.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726089AbfENUxH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 May 2019 16:53:07 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 May 2019 16:53:06 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTP id 1FCCB521E15;
        Tue, 14 May 2019 22:43:48 +0200 (CEST)
X-Virus-Scanned: amavisd-new at psrvmta09.zcs-production.pri
Received: from mail.siol.net ([127.0.0.1])
        by localhost (psrvmta09.zcs-production.pri [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id P6TEBCYv139H; Tue, 14 May 2019 22:43:47 +0200 (CEST)
Received: from mail.siol.net (localhost [127.0.0.1])
        by mail.siol.net (Postfix) with ESMTPS id 7A8BB521E08;
        Tue, 14 May 2019 22:43:47 +0200 (CEST)
Received: from localhost.localdomain (cpe-86-58-52-202.static.triera.net [86.58.52.202])
        (Authenticated sender: 031275009)
        by mail.siol.net (Postfix) with ESMTPSA id AEE1E521E34;
        Tue, 14 May 2019 22:43:44 +0200 (CEST)
From:   Jernej Skrabec <jernej.skrabec@siol.net>
To:     maxime.ripard@bootlin.com, wens@csie.org
Cc:     airlied@linux.ie, daniel@ffwll.ch, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, stable@vger.kernel.org
Subject: [PATCH 1/2] drm/sun4i: Fix sun8i HDMI PHY clock initialization
Date:   Tue, 14 May 2019 22:43:36 +0200
Message-Id: <20190514204337.11068-2-jernej.skrabec@siol.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190514204337.11068-1-jernej.skrabec@siol.net>
References: <20190514204337.11068-1-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Current code initializes HDMI PHY clock driver before reset line is
deasserted and clocks enabled. Because of that, initial readout of
clock divider is incorrect (0 instead of 2). This causes any clock
rate with divider 1 (register value 0) to be set incorrectly.

Fix this by moving initialization of HDMI PHY clock driver after reset
line is deasserted and clocks enabled.

Cc: stable@vger.kernel.org # 4.17+
Fixes: 4f86e81748fe ("drm/sun4i: Add support for H3 HDMI PHY variant")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
---
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c b/drivers/gpu/drm/sun=
4i/sun8i_hdmi_phy.c
index 66ea3a902e36..afc6d4a9c20b 100644
--- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
+++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
@@ -672,22 +672,13 @@ int sun8i_hdmi_phy_probe(struct sun8i_dw_hdmi *hdmi=
, struct device_node *node)
 				goto err_put_clk_pll0;
 			}
 		}
-
-		ret =3D sun8i_phy_clk_create(phy, dev,
-					   phy->variant->has_second_pll);
-		if (ret) {
-			dev_err(dev, "Couldn't create the PHY clock\n");
-			goto err_put_clk_pll1;
-		}
-
-		clk_prepare_enable(phy->clk_phy);
 	}
=20
 	phy->rst_phy =3D of_reset_control_get_shared(node, "phy");
 	if (IS_ERR(phy->rst_phy)) {
 		dev_err(dev, "Could not get phy reset control\n");
 		ret =3D PTR_ERR(phy->rst_phy);
-		goto err_disable_clk_phy;
+		goto err_put_clk_pll1;
 	}
=20
 	ret =3D reset_control_deassert(phy->rst_phy);
@@ -708,18 +699,29 @@ int sun8i_hdmi_phy_probe(struct sun8i_dw_hdmi *hdmi=
, struct device_node *node)
 		goto err_disable_clk_bus;
 	}
=20
+	if (phy->variant->has_phy_clk) {
+		ret =3D sun8i_phy_clk_create(phy, dev,
+					   phy->variant->has_second_pll);
+		if (ret) {
+			dev_err(dev, "Couldn't create the PHY clock\n");
+			goto err_disable_clk_mod;
+		}
+
+		clk_prepare_enable(phy->clk_phy);
+	}
+
 	hdmi->phy =3D phy;
=20
 	return 0;
=20
+err_disable_clk_mod:
+	clk_disable_unprepare(phy->clk_mod);
 err_disable_clk_bus:
 	clk_disable_unprepare(phy->clk_bus);
 err_deassert_rst_phy:
 	reset_control_assert(phy->rst_phy);
 err_put_rst_phy:
 	reset_control_put(phy->rst_phy);
-err_disable_clk_phy:
-	clk_disable_unprepare(phy->clk_phy);
 err_put_clk_pll1:
 	clk_put(phy->clk_pll1);
 err_put_clk_pll0:
--=20
2.21.0

