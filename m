Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D616BB283
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbjCOMgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbjCOMgd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:36:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74F596F00
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:35:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53DDFB81DFD
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:35:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E8CC433EF;
        Wed, 15 Mar 2023 12:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883732;
        bh=UhvvUWMiqqsXJLfW8imOhJv8zopj12Lnh6JBXYSB7sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTtQsXoav3qp4ogdeYTE1mAn5Z4Ha2zxQCSOR2x05Y5JkKzlPdDO5Uqzpk+eVUpMh
         EQcdLwQezFuOpMWJ6WvHaLqQ/7yIwVBiDCm6Jzt/rpnB0BwW8soXq95cUKAPXNmwzT
         QrAPqPsV6Snc193k9q5kPjo7LQk3PrtiTc9c+HeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 109/143] net: dsa: mt7530: permit port 5 to work without port 6 on MT7621 SoC
Date:   Wed, 15 Mar 2023 13:13:15 +0100
Message-Id: <20230315115743.805025016@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit c8b8a3c601f2cfad25ab5ce5b04df700048aef6e ]

The MT7530 switch from the MT7621 SoC has 2 ports which can be set up as
internal: port 5 and 6. Arınç reports that the GMAC1 attached to port 5
receives corrupted frames, unless port 6 (attached to GMAC0) has been
brought up by the driver. This is true regardless of whether port 5 is
used as a user port or as a CPU port (carrying DSA tags).

Offline debugging (blind for me) which began in the linked thread showed
experimentally that the configuration done by the driver for port 6
contains a step which is needed by port 5 as well - the write to
CORE_GSWPLL_GRP2 (note that I've no idea as to what it does, apart from
the comment "Set core clock into 500Mhz"). Prints put by Arınç show that
the reset value of CORE_GSWPLL_GRP2 is RG_GSWPLL_POSDIV_500M(1) |
RG_GSWPLL_FBKDIV_500M(40) (0x128), both on the MCM MT7530 from the
MT7621 SoC, as well as on the standalone MT7530 from MT7623NI Bananapi
BPI-R2. Apparently, port 5 on the standalone MT7530 can work under both
values of the register, while on the MT7621 SoC it cannot.

The call path that triggers the register write is:

mt753x_phylink_mac_config() for port 6
-> mt753x_pad_setup()
   -> mt7530_pad_clk_setup()

so this fully explains the behavior noticed by Arınç, that bringing port
6 up is necessary.

The simplest fix for the problem is to extract the register writes which
are needed for both port 5 and 6 into a common mt7530_pll_setup()
function, which is called at mt7530_setup() time, immediately after
switch reset. We can argue that this mirrors the code layout introduced
in mt7531_setup() by commit 42bc4fafe359 ("net: mt7531: only do PLL once
after the reset"), in that the PLL setup has the exact same positioning,
and further work to consolidate the separate setup() functions is not
hindered.

Testing confirms that:

- the slight reordering of writes to MT7530_P6ECR and to
  CORE_GSWPLL_GRP1 / CORE_GSWPLL_GRP2 introduced by this change does not
  appear to cause problems for the operation of port 6 on MT7621 and on
  MT7623 (where port 5 also always worked)

- packets sent through port 5 are not corrupted anymore, regardless of
  whether port 6 is enabled by phylink or not (or even present in the
  device tree)

My algorithm for determining the Fixes: tag is as follows. Testing shows
that some logic from mt7530_pad_clk_setup() is needed even for port 5.
Prior to commit ca366d6c889b ("net: dsa: mt7530: Convert to PHYLINK
API"), a call did exist for all phy_is_pseudo_fixed_link() ports - so
port 5 included. That commit replaced it with a temporary "Port 5 is not
supported!" comment, and the following commit 38f790a80560 ("net: dsa:
mt7530: Add support for port 5") replaced that comment with a
configuration procedure in mt7530_setup_port5() which was insufficient
for port 5 to work. I'm laying the blame on the patch that claimed
support for port 5, although one would have also needed the change from
commit c3b8e07909db ("net: dsa: mt7530: setup core clock even in TRGMII
mode") for the write to be performed completely independently from port
6's configuration.

Thanks go to Arınç for describing the problem, for debugging and for
testing.

Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Link: https://lore.kernel.org/netdev/f297c2c4-6e7c-57ac-2394-f6025d309b9d@arinc9.com/
Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230307155411.868573-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index a884f6f6a8c2c..1e0b8bcd59e6c 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -393,6 +393,24 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
 		mt7530_write(priv, MT7530_ATA1 + (i * 4), reg[i]);
 }
 
+/* Set up switch core clock for MT7530 */
+static void mt7530_pll_setup(struct mt7530_priv *priv)
+{
+	/* Disable PLL */
+	core_write(priv, CORE_GSWPLL_GRP1, 0);
+
+	/* Set core clock into 500Mhz */
+	core_write(priv, CORE_GSWPLL_GRP2,
+		   RG_GSWPLL_POSDIV_500M(1) |
+		   RG_GSWPLL_FBKDIV_500M(25));
+
+	/* Enable PLL */
+	core_write(priv, CORE_GSWPLL_GRP1,
+		   RG_GSWPLL_EN_PRE |
+		   RG_GSWPLL_POSDIV_200M(2) |
+		   RG_GSWPLL_FBKDIV_200M(32));
+}
+
 /* Setup TX circuit including relevant PAD and driving */
 static int
 mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
@@ -453,21 +471,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
 		   REG_GSWCK_EN | REG_TRGMIICK_EN);
 
-	/* Setup core clock for MT7530 */
-	/* Disable PLL */
-	core_write(priv, CORE_GSWPLL_GRP1, 0);
-
-	/* Set core clock into 500Mhz */
-	core_write(priv, CORE_GSWPLL_GRP2,
-		   RG_GSWPLL_POSDIV_500M(1) |
-		   RG_GSWPLL_FBKDIV_500M(25));
-
-	/* Enable PLL */
-	core_write(priv, CORE_GSWPLL_GRP1,
-		   RG_GSWPLL_EN_PRE |
-		   RG_GSWPLL_POSDIV_200M(2) |
-		   RG_GSWPLL_FBKDIV_200M(32));
-
 	/* Setup the MT7530 TRGMII Tx Clock */
 	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
 	core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
@@ -2201,6 +2204,8 @@ mt7530_setup(struct dsa_switch *ds)
 		     SYS_CTRL_PHY_RST | SYS_CTRL_SW_RST |
 		     SYS_CTRL_REG_RST);
 
+	mt7530_pll_setup(priv);
+
 	/* Enable Port 6 only; P5 as GMAC5 which currently is not supported */
 	val = mt7530_read(priv, MT7530_MHWTRAP);
 	val &= ~MHWTRAP_P6_DIS & ~MHWTRAP_PHY_ACCESS;
-- 
2.39.2



