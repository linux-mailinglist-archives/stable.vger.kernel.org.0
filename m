Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1847548AA9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348531AbiFMK5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350380AbiFMKyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:54:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41DF1EEEC;
        Mon, 13 Jun 2022 03:31:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74B6A60FAD;
        Mon, 13 Jun 2022 10:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87780C34114;
        Mon, 13 Jun 2022 10:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116275;
        bh=Ecj1LCmySlw3UXUM/IrotAjv0vdchoIgerpHEdcPD6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VfD/ADgVXbBlxESI5j5EdvXU9U74ddANckM2uCjnd+LF6VwcMk/CJfOywURFoLy4K
         ukUPTNVCJCxsqxBg/9uw8IOjAQOCxJLpeeeIXmIbA5UI7R+/BqQbLj9JP1eHJll9Yb
         dUkl0BY4xR3xZjR7dIsZYXDYGPK2cvvdJtVR2XTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/411] net: phy: micrel: Allow probing without .driver_data
Date:   Mon, 13 Jun 2022 12:05:29 +0200
Message-Id: <20220613094930.193456909@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit f2ef6f7539c68c6bd6c32323d8845ee102b7c450 ]

Currently, if the .probe element is present in the phy_driver structure
and the .driver_data is not, a NULL pointer dereference happens.

Allow passing .probe without .driver_data by inserting NULL checks
for priv->type.

Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220513114613.762810-1-festevam@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 18cc5e4280e8..721153dcfd15 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -282,7 +282,7 @@ static int kszphy_config_reset(struct phy_device *phydev)
 		}
 	}
 
-	if (priv->led_mode >= 0)
+	if (priv->type && priv->led_mode >= 0)
 		kszphy_setup_led(phydev, priv->type->led_mode_reg, priv->led_mode);
 
 	return 0;
@@ -298,10 +298,10 @@ static int kszphy_config_init(struct phy_device *phydev)
 
 	type = priv->type;
 
-	if (type->has_broadcast_disable)
+	if (type && type->has_broadcast_disable)
 		kszphy_broadcast_disable(phydev);
 
-	if (type->has_nand_tree_disable)
+	if (type && type->has_nand_tree_disable)
 		kszphy_nand_tree_disable(phydev);
 
 	return kszphy_config_reset(phydev);
@@ -939,7 +939,7 @@ static int kszphy_probe(struct phy_device *phydev)
 
 	priv->type = type;
 
-	if (type->led_mode_reg) {
+	if (type && type->led_mode_reg) {
 		ret = of_property_read_u32(np, "micrel,led-mode",
 				&priv->led_mode);
 		if (ret)
@@ -960,7 +960,8 @@ static int kszphy_probe(struct phy_device *phydev)
 		unsigned long rate = clk_get_rate(clk);
 		bool rmii_ref_clk_sel_25_mhz;
 
-		priv->rmii_ref_clk_sel = type->has_rmii_ref_clk_sel;
+		if (type)
+			priv->rmii_ref_clk_sel = type->has_rmii_ref_clk_sel;
 		rmii_ref_clk_sel_25_mhz = of_property_read_bool(np,
 				"micrel,rmii-reference-clock-select-25-mhz");
 
-- 
2.35.1



