Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7CFF3903D
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730037AbfFGPuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732119AbfFGPuK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:50:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25A4420840;
        Fri,  7 Jun 2019 15:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922609;
        bh=j49jvOBp4+Atxs7E5AnQIQU7c00poykEF7SSl93LRDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=usIWJFgRZT4Nrxcx1G41hW1VO6KRl9b8DlyqgpdsBh/yNGTxEW/W3nGnkEmCHJJX+
         jouH2z5+Nx+rJJMCrWgysg7KyEUy1Yv0f8RsZoaaGaufklY/K7Gyd0mB+M5MdeWf8B
         0EUIvPcRFVqlssFiAV6VBN4yoxhLFT/xFcPwf0rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jernej Skrabec <jernej.skrabec@siol.net>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH 5.1 75/85] drm/sun4i: Fix sun8i HDMI PHY clock initialization
Date:   Fri,  7 Jun 2019 17:40:00 +0200
Message-Id: <20190607153857.370585718@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153849.101321647@linuxfoundation.org>
References: <20190607153849.101321647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jernej Skrabec <jernej.skrabec@siol.net>

commit 8a943c6021ba8b95a36c842327e468df1fddd4a7 upstream.

Current code initializes HDMI PHY clock driver before reset line is
deasserted and clocks enabled. Because of that, initial readout of
clock divider is incorrect (0 instead of 2). This causes any clock
rate with divider 1 (register value 0) to be set incorrectly.

Fix this by moving initialization of HDMI PHY clock driver after reset
line is deasserted and clocks enabled.

Cc: stable@vger.kernel.org # 4.17+
Fixes: 4f86e81748fe ("drm/sun4i: Add support for H3 HDMI PHY variant")
Signed-off-by: Jernej Skrabec <jernej.skrabec@siol.net>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190514204337.11068-2-jernej.skrabec@siol.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
+++ b/drivers/gpu/drm/sun4i/sun8i_hdmi_phy.c
@@ -672,22 +672,13 @@ int sun8i_hdmi_phy_probe(struct sun8i_dw
 				goto err_put_clk_pll0;
 			}
 		}
-
-		ret = sun8i_phy_clk_create(phy, dev,
-					   phy->variant->has_second_pll);
-		if (ret) {
-			dev_err(dev, "Couldn't create the PHY clock\n");
-			goto err_put_clk_pll1;
-		}
-
-		clk_prepare_enable(phy->clk_phy);
 	}
 
 	phy->rst_phy = of_reset_control_get_shared(node, "phy");
 	if (IS_ERR(phy->rst_phy)) {
 		dev_err(dev, "Could not get phy reset control\n");
 		ret = PTR_ERR(phy->rst_phy);
-		goto err_disable_clk_phy;
+		goto err_put_clk_pll1;
 	}
 
 	ret = reset_control_deassert(phy->rst_phy);
@@ -708,18 +699,29 @@ int sun8i_hdmi_phy_probe(struct sun8i_dw
 		goto err_disable_clk_bus;
 	}
 
+	if (phy->variant->has_phy_clk) {
+		ret = sun8i_phy_clk_create(phy, dev,
+					   phy->variant->has_second_pll);
+		if (ret) {
+			dev_err(dev, "Couldn't create the PHY clock\n");
+			goto err_disable_clk_mod;
+		}
+
+		clk_prepare_enable(phy->clk_phy);
+	}
+
 	hdmi->phy = phy;
 
 	return 0;
 
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


