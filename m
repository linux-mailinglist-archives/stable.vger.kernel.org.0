Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CF06CC2DF
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbjC1OtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233378AbjC1OtB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:49:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4968D31F
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:48:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 828D0B80976
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1DBC433EF;
        Tue, 28 Mar 2023 14:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014911;
        bh=fJsDNMMCpbyJ+GccD9UoIcYN+uG9hbyU0KW9FygHH/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7L57CUJsHxXPJe1W4UD1FXEselOq/iijjkGCoFUFZjVxhUPtWzYLL9pb/qQ68TVP
         4fLnJFoW9NEnpsIXMYAXh3geN7lLEg6WLdyCF6eJs3wS+KKi+1okEWE3eLBiaopkNb
         GBBRcbCVGYjrckI4nFyct2dmvL8YOdqRDEZxjeAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 096/240] net: dsa: mt7530: move enabling disabling core clock to mt7530_pll_setup()
Date:   Tue, 28 Mar 2023 16:40:59 +0200
Message-Id: <20230328142623.770549359@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit 8f058a6ef99f0b88a177b58cc46a44ff5112e40a ]

Split the code that enables and disables TRGMII clocks and core clock.
Move enabling and disabling core clock to mt7530_pll_setup() as it's
supposed to be run there.

Add 20 ms delay before enabling the core clock as seen on the U-Boot
MediaTek ethernet driver.

Change the comment for enabling and disabling TRGMII clocks as the code
seems to affect both TXC and RXC.

Tested rgmii and trgmii modes of port 6 and rgmii mode of port 5 on MCM
MT7530 on MT7621AT Unielec U7621-06 and standalone MT7530 on MT7623NI
Bananapi BPI-R2.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Link: https://source.denx.de/u-boot/u-boot/-/blob/29a48bf9ccba45a5e560bb564bbe76e42629325f/drivers/net/mtk_eth.c#L589
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/20230320190520.124513-1-arinc.unal@arinc9.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 178e5a3441e68..cd0ea03c071f0 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -396,6 +396,9 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 /* Set up switch core clock for MT7530 */
 static void mt7530_pll_setup(struct mt7530_priv *priv)
 {
+	/* Disable core clock */
+	core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
+
 	/* Disable PLL */
 	core_write(priv, CORE_GSWPLL_GRP1, 0);
 
@@ -409,6 +412,11 @@ static void mt7530_pll_setup(struct mt7530_priv *priv)
 		   RG_GSWPLL_EN_PRE |
 		   RG_GSWPLL_POSDIV_200M(2) |
 		   RG_GSWPLL_FBKDIV_200M(32));
+
+	udelay(20);
+
+	/* Enable core clock */
+	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
 }
 
 /* Setup TX circuit including relevant PAD and driving */
@@ -466,9 +474,8 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 			mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
 				     TD_DM_DRVP(8) | TD_DM_DRVN(8));
 
-		/* Disable MT7530 core and TRGMII Tx clocks */
-		core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
-			   REG_GSWCK_EN | REG_TRGMIICK_EN);
+		/* Disable the MT7530 TRGMII clocks */
+		core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
 
 		/* Setup the MT7530 TRGMII Tx Clock */
 		core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
@@ -485,9 +492,8 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 			   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
 			   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
 
-		/* Enable MT7530 core and TRGMII Tx clocks */
-		core_set(priv, CORE_TRGMII_GSW_CLK_CG,
-			 REG_GSWCK_EN | REG_TRGMIICK_EN);
+		/* Enable the MT7530 TRGMII clocks */
+		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
 	} else {
 		for (i = 0 ; i < NUM_TRGMII_CTRL; i++)
 			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
-- 
2.39.2



