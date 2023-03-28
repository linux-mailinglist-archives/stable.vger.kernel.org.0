Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AC06CC313
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjC1OvL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbjC1Our (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:50:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F210D525
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13C3E617F1
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3861C433D2;
        Tue, 28 Mar 2023 14:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015021;
        bh=yr3FB4cYBFikAWAHRX6wt5vVzS20zesZ5Z0cRfud/2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pWvKdlFVhAXbScL7xL+1fEFaRHqbzTyZXpPzD1hX1wD3P40VMauIQXbzdtZjsuAy7
         SUvUS3IidLB9UsUD4/pvYMRYeUu7Ayeq2sIUrdBQArqEzBmBCCl9FZbJeqAP9+KrlD
         i7M7lVfEd68RwYUEFQkQ99Ec27Fm8ee65JZURB6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 097/240] net: dsa: mt7530: move lowering TRGMII driving to mt7530_setup()
Date:   Tue, 28 Mar 2023 16:41:00 +0200
Message-Id: <20230328142623.814630650@linuxfoundation.org>
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

[ Upstream commit fdcc8ccd823740c18e803b886cec461bc0e64201 ]

Move lowering the TRGMII Tx clock driving to mt7530_setup(), after setting
the core clock, as seen on the U-Boot MediaTek ethernet driver.

Move the code which looks like it lowers the TRGMII Rx clock driving to
after the TRGMII Tx clock driving is lowered. This is run after lowering
the Tx clock driving on the U-Boot MediaTek ethernet driver as well.

This way, the switch should consume less power regardless of port 6 being
used.

Update the comment explaining mt7530_pad_clk_setup().

Tested rgmii and trgmii modes of port 6 and rgmii mode of port 5 on MCM
MT7530 on MT7621AT Unielec U7621-06 and standalone MT7530 on MT7623NI
Bananapi BPI-R2.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Link: https://source.denx.de/u-boot/u-boot/-/blob/29a48bf9ccba45a5e560bb564bbe76e42629325f/drivers/net/mtk_eth.c#L682
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/r/20230320190520.124513-2-arinc.unal@arinc9.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index cd0ea03c071f0..b0d6ca18ec2f3 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -419,12 +419,12 @@ static void mt7530_pll_setup(struct mt7530_priv *priv)
 	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
 }
 
-/* Setup TX circuit including relevant PAD and driving */
+/* Setup port 6 interface mode and TRGMII TX circuit */
 static int
 mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 {
 	struct mt7530_priv *priv = ds->priv;
-	u32 ncpo1, ssc_delta, trgint, i, xtal;
+	u32 ncpo1, ssc_delta, trgint, xtal;
 
 	xtal = mt7530_read(priv, MT7530_MHWTRAP) & HWTRAP_XTAL_MASK;
 
@@ -469,11 +469,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		   P6_INTF_MODE(trgint));
 
 	if (trgint) {
-		/* Lower Tx Driving for TRGMII path */
-		for (i = 0 ; i < NUM_TRGMII_CTRL ; i++)
-			mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
-				     TD_DM_DRVP(8) | TD_DM_DRVN(8));
-
 		/* Disable the MT7530 TRGMII clocks */
 		core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
 
@@ -494,10 +489,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 
 		/* Enable the MT7530 TRGMII clocks */
 		core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_TRGMIICK_EN);
-	} else {
-		for (i = 0 ; i < NUM_TRGMII_CTRL; i++)
-			mt7530_rmw(priv, MT7530_TRGMII_RD(i),
-				   RD_TAP_MASK, RD_TAP(16));
 	}
 
 	return 0;
@@ -2212,6 +2203,15 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
+	/* Lower Tx driving for TRGMII path */
+	for (i = 0; i < NUM_TRGMII_CTRL; i++)
+		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
+			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
+
+	for (i = 0; i < NUM_TRGMII_CTRL; i++)
+		mt7530_rmw(priv, MT7530_TRGMII_RD(i),
+			   RD_TAP_MASK, RD_TAP(16));
+
 	/* Enable port 6 */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
-- 
2.39.2



