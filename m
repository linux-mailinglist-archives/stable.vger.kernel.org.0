Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A1F549496
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380470AbiFMN67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380156AbiFMNxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:53:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB5A71DA9;
        Mon, 13 Jun 2022 04:33:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 598486101F;
        Mon, 13 Jun 2022 11:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DD6C34114;
        Mon, 13 Jun 2022 11:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120036;
        bh=JL83QN5fpzJ+aXaHAbiWlbtZe14KTbAOKOfCTad7rS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YVmlq53tiYADGJj4xZFF70n7lhMRNN0DgKbjzmm/GEXYTo6GfhqMpNcC+awAn/VUe
         hugjwrDfbt2L+i7fcrhMyz3SNRx00+9FaV4HP3yZYAr03bACKqeIpBxMmBPRP6pnu2
         qDsPPzNuYR8Me80RbqUPDAif9uj7R0ck6tiuU/zY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 217/339] net: dsa: realtek: rtl8365mb: fix GMII caps for ports with internal PHY
Date:   Mon, 13 Jun 2022 12:10:42 +0200
Message-Id: <20220613094933.242922777@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Alvin Šipraga <alsi@bang-olufsen.dk>

[ Upstream commit 487994ff75880569d32504d7e70da8b3328e0693 ]

Since commit a18e6521a7d9 ("net: phylink: handle NA interface mode in
phylink_fwnode_phy_connect()"), phylib defaults to GMII when no phy-mode
or phy-connection-type property is specified in a DSA port node of the
device tree. The same commit caused a regression in rtl8365mb whereby
phylink would fail to connect, because the driver did not advertise
support for GMII for ports with internal PHY.

It should be noted that the aforementioned regression is not because the
blamed commit was incorrect: on the contrary, the blamed commit is
correcting the previous behaviour whereby unspecified phy-mode would
cause the internal interface mode to be PHY_INTERFACE_MODE_NA. The
rtl8365mb driver only worked by accident before because it _did_
advertise support for PHY_INTERFACE_MODE_NA, despite NA being reserved
for internal use by phylink. With one mistake fixed, the other was
exposed.

Commit a5dba0f207e5 ("net: dsa: rtl8365mb: add GMII as user port mode")
then introduced implicit support for GMII mode on ports with internal
PHY to allow a PHY connection for device trees where the phy-mode is not
explicitly set to "internal". At this point everything was working OK
again.

Subsequently, commit 6ff6064605e9 ("net: dsa: realtek: convert to
phylink_generic_validate()") broke this behaviour again by discarding
the usage of rtl8365mb_phy_mode_supported() - where this GMII support
was indicated - while switching to the new .phylink_get_caps API.

With the new API, rtl8365mb_phy_mode_supported() is no longer needed.
Remove it altogether and add back the GMII capability - this time to
rtl8365mb_phylink_get_caps() - so that the above default behaviour works
for ports with internal PHY again.

Fixes: 6ff6064605e9 ("net: dsa: realtek: convert to phylink_generic_validate()")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20220607184624.417641-1-alvin@pqrs.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 38 +++++++----------------------
 1 file changed, 9 insertions(+), 29 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 3d70e8a77ecf..907c743370e3 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -955,35 +955,21 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 	return 0;
 }
 
-static bool rtl8365mb_phy_mode_supported(struct dsa_switch *ds, int port,
-					 phy_interface_t interface)
-{
-	int ext_int;
-
-	ext_int = rtl8365mb_extint_port_map[port];
-
-	if (ext_int < 0 &&
-	    (interface == PHY_INTERFACE_MODE_NA ||
-	     interface == PHY_INTERFACE_MODE_INTERNAL ||
-	     interface == PHY_INTERFACE_MODE_GMII))
-		/* Internal PHY */
-		return true;
-	else if ((ext_int >= 1) &&
-		 phy_interface_mode_is_rgmii(interface))
-		/* Extension MAC */
-		return true;
-
-	return false;
-}
-
 static void rtl8365mb_phylink_get_caps(struct dsa_switch *ds, int port,
 				       struct phylink_config *config)
 {
-	if (dsa_is_user_port(ds, port))
+	if (dsa_is_user_port(ds, port)) {
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 			  config->supported_interfaces);
-	else if (dsa_is_cpu_port(ds, port))
+
+		/* GMII is the default interface mode for phylib, so
+		 * we have to support it for ports with integrated PHY.
+		 */
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
+	} else if (dsa_is_cpu_port(ds, port)) {
 		phy_interface_set_rgmii(config->supported_interfaces);
+	}
 
 	config->mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
 				   MAC_10 | MAC_100 | MAC_1000FD;
@@ -996,12 +982,6 @@ static void rtl8365mb_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct realtek_priv *priv = ds->priv;
 	int ret;
 
-	if (!rtl8365mb_phy_mode_supported(ds, port, state->interface)) {
-		dev_err(priv->dev, "phy mode %s is unsupported on port %d\n",
-			phy_modes(state->interface), port);
-		return;
-	}
-
 	if (mode != MLO_AN_PHY && mode != MLO_AN_FIXED) {
 		dev_err(priv->dev,
 			"port %d supports only conventional PHY or fixed-link\n",
-- 
2.35.1



