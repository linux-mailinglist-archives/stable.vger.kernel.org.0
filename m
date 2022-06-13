Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EC35497CF
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380275AbiFMN6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379893AbiFMNvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:51:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65F92A957;
        Mon, 13 Jun 2022 04:33:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 789C6B80EAF;
        Mon, 13 Jun 2022 11:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7D2C3411C;
        Mon, 13 Jun 2022 11:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120006;
        bh=t+W9R+MxpX7ns1b7fh0uNzd9ES8QDVmHtnI0z7kG8sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aPbPhIfIdmwrS7pgjAr72+1YseualFL9hdEUAlcOCfWKlyrm3fJql0a3bc/jJPs4n
         1SPIxkVA1EOhqYwNQy3RsglmrdZ3qE/wfXCA1NdvVD8yITXAtuwgS+1o/FYCzOZmN7
         qPdXW/TRyHhpJj5nQEgMPPLjk9iCWbv2GqEA++sY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 216/339] net: dsa: mv88e6xxx: use BMSR_ANEGCOMPLETE bit for filling an_complete
Date:   Mon, 13 Jun 2022 12:10:41 +0200
Message-Id: <20220613094933.213448011@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 47e96930d6e6106d5252e85b868d3c7e29296de0 ]

Commit ede359d8843a ("net: dsa: mv88e6xxx: Link in pcs_get_state() if AN
is bypassed") added the ability to link if AN was bypassed, and added
filling of state->an_complete field, but set it to true if AN was
enabled in BMCR, not when AN was reported complete in BMSR.

This was done because for some reason, when I wanted to use BMSR value
to infer an_complete, I was looking at BMSR_ANEGCAPABLE bit (which was
always 1), instead of BMSR_ANEGCOMPLETE bit.

Use BMSR_ANEGCOMPLETE for filling state->an_complete.

Fixes: ede359d8843a ("net: dsa: mv88e6xxx: Link in pcs_get_state() if AN is bypassed")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 7b37d45bc9fb..1a19c5284f2c 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -50,22 +50,17 @@ static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
-					  u16 ctrl, u16 status, u16 lpa,
+					  u16 bmsr, u16 lpa, u16 status,
 					  struct phylink_link_state *state)
 {
 	state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
+	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
 
 	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
 		/* The Spped and Duplex Resolved register is 1 if AN is enabled
 		 * and complete, or if AN is disabled. So with disabled AN we
-		 * still get here on link up. But we want to set an_complete
-		 * only if AN was enabled, thus we look at BMCR_ANENABLE.
-		 * (According to 802.3-2008 section 22.2.4.2.10, we should be
-		 *  able to get this same value from BMSR_ANEGCAPABLE, but tests
-		 *  show that these Marvell PHYs don't conform to this part of
-		 *  the specificaion - BMSR_ANEGCAPABLE is simply always 1.)
+		 * still get here on link up.
 		 */
-		state->an_complete = !!(ctrl & BMCR_ANENABLE);
 		state->duplex = status &
 				MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
 			                         DUPLEX_FULL : DUPLEX_HALF;
@@ -191,12 +186,12 @@ int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state)
 {
-	u16 lpa, status, ctrl;
+	u16 bmsr, lpa, status;
 	int err;
 
-	err = mv88e6352_serdes_read(chip, MII_BMCR, &ctrl);
+	err = mv88e6352_serdes_read(chip, MII_BMSR, &bmsr);
 	if (err) {
-		dev_err(chip->dev, "can't read Serdes PHY control: %d\n", err);
+		dev_err(chip->dev, "can't read Serdes BMSR: %d\n", err);
 		return err;
 	}
 
@@ -212,7 +207,7 @@ int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, ctrl, status, lpa, state);
+	return mv88e6xxx_serdes_pcs_get_state(chip, bmsr, lpa, status, state);
 }
 
 int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
@@ -918,13 +913,13 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 	int port, int lane, struct phylink_link_state *state)
 {
-	u16 lpa, status, ctrl;
+	u16 bmsr, lpa, status;
 	int err;
 
 	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_BMCR, &ctrl);
+				    MV88E6390_SGMII_BMSR, &bmsr);
 	if (err) {
-		dev_err(chip->dev, "can't read Serdes PHY control: %d\n", err);
+		dev_err(chip->dev, "can't read Serdes PHY BMSR: %d\n", err);
 		return err;
 	}
 
@@ -942,7 +937,7 @@ static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, ctrl, status, lpa, state);
+	return mv88e6xxx_serdes_pcs_get_state(chip, bmsr, lpa, status, state);
 }
 
 static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
-- 
2.35.1



