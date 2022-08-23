Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F19359D37A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242212AbiHWISo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243050AbiHWIQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:16:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA2E67CBE;
        Tue, 23 Aug 2022 01:11:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92D1FB81C25;
        Tue, 23 Aug 2022 08:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58C1C433D6;
        Tue, 23 Aug 2022 08:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242259;
        bh=QJpX0XKokoMZBk/Tl7oumqJUQg482sDWrAlMoLsvadk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzXqpkOYmk4pxehX7V/Nv4ITuuHGGdVJRvWZ55COPlVaYc7uy6D+WDmMIdVcWzrKJ
         +BQZL/ue9VSawd+JQ8c+SYR1bTHfFfcnz8MR4nL13bksdOx14Dx0q8W+/px9LKReFy
         Ar9vB0ZLpZuOVv/NdDD1Cn3XrAVt/zG54JYjwpxA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.19 084/365] net: phy: c45 baset1: do not skip aneg configuration if clock role is not specified
Date:   Tue, 23 Aug 2022 09:59:45 +0200
Message-Id: <20220823080121.697047439@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 3702e4041cfda50bc697363d29511ce8f6b24795 upstream.

In case master/slave clock role is not specified (which is default), the
aneg registers will not be written.

The visible impact of this is missing pause advertisement.

So, rework genphy_c45_baset1_an_config_aneg() to be able to write
advertisement registers even if clock role is unknown.

Fixes: 3da8ffd8545f ("net: phy: Add 10BASE-T1L support in phy-c45")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220805073159.908643-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/phy-c45.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -190,44 +190,42 @@ EXPORT_SYMBOL_GPL(genphy_c45_pma_setup_f
  */
 static int genphy_c45_baset1_an_config_aneg(struct phy_device *phydev)
 {
+	u16 adv_l_mask, adv_l = 0;
+	u16 adv_m_mask, adv_m = 0;
 	int changed = 0;
-	u16 adv_l = 0;
-	u16 adv_m = 0;
 	int ret;
 
+	adv_l_mask = MDIO_AN_T1_ADV_L_FORCE_MS | MDIO_AN_T1_ADV_L_PAUSE_CAP |
+		MDIO_AN_T1_ADV_L_PAUSE_ASYM;
+	adv_m_mask = MDIO_AN_T1_ADV_M_MST | MDIO_AN_T1_ADV_M_B10L;
+
 	switch (phydev->master_slave_set) {
 	case MASTER_SLAVE_CFG_MASTER_FORCE:
+		adv_m |= MDIO_AN_T1_ADV_M_MST;
+		fallthrough;
 	case MASTER_SLAVE_CFG_SLAVE_FORCE:
 		adv_l |= MDIO_AN_T1_ADV_L_FORCE_MS;
 		break;
 	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
+		adv_m |= MDIO_AN_T1_ADV_M_MST;
+		fallthrough;
 	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
 		break;
 	case MASTER_SLAVE_CFG_UNKNOWN:
 	case MASTER_SLAVE_CFG_UNSUPPORTED:
-		return 0;
+		/* if master/slave role is not specified, do not overwrite it */
+		adv_l_mask &= ~MDIO_AN_T1_ADV_L_FORCE_MS;
+		adv_m_mask &= ~MDIO_AN_T1_ADV_M_MST;
+		break;
 	default:
 		phydev_warn(phydev, "Unsupported Master/Slave mode\n");
 		return -EOPNOTSUPP;
 	}
 
-	switch (phydev->master_slave_set) {
-	case MASTER_SLAVE_CFG_MASTER_FORCE:
-	case MASTER_SLAVE_CFG_MASTER_PREFERRED:
-		adv_m |= MDIO_AN_T1_ADV_M_MST;
-		break;
-	case MASTER_SLAVE_CFG_SLAVE_FORCE:
-	case MASTER_SLAVE_CFG_SLAVE_PREFERRED:
-		break;
-	default:
-		break;
-	}
-
 	adv_l |= linkmode_adv_to_mii_t1_adv_l_t(phydev->advertising);
 
 	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_L,
-				     (MDIO_AN_T1_ADV_L_FORCE_MS | MDIO_AN_T1_ADV_L_PAUSE_CAP
-				     | MDIO_AN_T1_ADV_L_PAUSE_ASYM), adv_l);
+				     adv_l_mask, adv_l);
 	if (ret < 0)
 		return ret;
 	if (ret > 0)
@@ -236,7 +234,7 @@ static int genphy_c45_baset1_an_config_a
 	adv_m |= linkmode_adv_to_mii_t1_adv_m_t(phydev->advertising);
 
 	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_AN, MDIO_AN_T1_ADV_M,
-				     MDIO_AN_T1_ADV_M_MST | MDIO_AN_T1_ADV_M_B10L, adv_m);
+				     adv_m_mask, adv_m);
 	if (ret < 0)
 		return ret;
 	if (ret > 0)


