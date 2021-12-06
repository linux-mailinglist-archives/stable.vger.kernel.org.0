Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A19469EC3
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354377AbhLFPoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385561AbhLFPis (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:38:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19C0C08EB48;
        Mon,  6 Dec 2021 07:24:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BA9861344;
        Mon,  6 Dec 2021 15:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9F6C34901;
        Mon,  6 Dec 2021 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804280;
        bh=reN+dNueUHkFjlhNO9CMyFtMhrkiLSL/IAujyZSoScM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J20IIVCxJbSM3czQJ+hZ9GGGISl+TlgNXxqRJMPqPYnJdpwT3viH6OAmN0/0bS2+p
         qgZ76+19qDDgmH/7KgakoKr1CFcOdfmPmANLpHw2wydp7GWyH9FfyvLtdPwSIhHJU7
         3GnhRh2ccHij738au3dIh7Xh30lXurmDRtE554Bs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 090/207] net: dsa: mv88e6xxx: Link in pcs_get_state() if AN is bypassed
Date:   Mon,  6 Dec 2021 15:55:44 +0100
Message-Id: <20211206145613.347282418@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

commit ede359d8843a2779d232ed30bc36089d4b5962e4 upstream.

Function mv88e6xxx_serdes_pcs_get_state() currently does not report link
up if AN is enabled, Link bit is set, but Speed and Duplex Resolved bit
is not set, which testing shows is the case for when auto-negotiation
was bypassed (we have AN enabled but link partner does not).

An example of such link partner is Marvell 88X3310 PHY, when put into
the mode where host interface changes between 10gbase-r, 5gbase-r,
2500base-x and sgmii according to copper speed. The 88X3310 does not
enable AN in 2500base-x, and so SerDes on mv88e6xxx currently does not
link with it.

Fix this.

Fixes: a5a6858b793f ("net: dsa: mv88e6xxx: extend phylink to Serdes PHYs")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/serdes.c |   48 ++++++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 6 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -50,11 +50,22 @@ static int mv88e6390_serdes_write(struct
 }
 
 static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
-					  u16 status, u16 lpa,
+					  u16 ctrl, u16 status, u16 lpa,
 					  struct phylink_link_state *state)
 {
+	state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
+
 	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
-		state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
+		/* The Spped and Duplex Resolved register is 1 if AN is enabled
+		 * and complete, or if AN is disabled. So with disabled AN we
+		 * still get here on link up. But we want to set an_complete
+		 * only if AN was enabled, thus we look at BMCR_ANENABLE.
+		 * (According to 802.3-2008 section 22.2.4.2.10, we should be
+		 *  able to get this same value from BMSR_ANEGCAPABLE, but tests
+		 *  show that these Marvell PHYs don't conform to this part of
+		 *  the specificaion - BMSR_ANEGCAPABLE is simply always 1.)
+		 */
+		state->an_complete = !!(ctrl & BMCR_ANENABLE);
 		state->duplex = status &
 				MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
 			                         DUPLEX_FULL : DUPLEX_HALF;
@@ -81,6 +92,18 @@ static int mv88e6xxx_serdes_pcs_get_stat
 			dev_err(chip->dev, "invalid PHY speed\n");
 			return -EINVAL;
 		}
+	} else if (state->link &&
+		   state->interface != PHY_INTERFACE_MODE_SGMII) {
+		/* If Speed and Duplex Resolved register is 0 and link is up, it
+		 * means that AN was enabled, but link partner had it disabled
+		 * and the PHY invoked the Auto-Negotiation Bypass feature and
+		 * linked anyway.
+		 */
+		state->duplex = DUPLEX_FULL;
+		if (state->interface == PHY_INTERFACE_MODE_2500BASEX)
+			state->speed = SPEED_2500;
+		else
+			state->speed = SPEED_1000;
 	} else {
 		state->link = false;
 	}
@@ -168,9 +191,15 @@ int mv88e6352_serdes_pcs_config(struct m
 int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state)
 {
-	u16 lpa, status;
+	u16 lpa, status, ctrl;
 	int err;
 
+	err = mv88e6352_serdes_read(chip, MII_BMCR, &ctrl);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes PHY control: %d\n", err);
+		return err;
+	}
+
 	err = mv88e6352_serdes_read(chip, 0x11, &status);
 	if (err) {
 		dev_err(chip->dev, "can't read Serdes PHY status: %d\n", err);
@@ -183,7 +212,7 @@ int mv88e6352_serdes_pcs_get_state(struc
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, status, lpa, state);
+	return mv88e6xxx_serdes_pcs_get_state(chip, ctrl, status, lpa, state);
 }
 
 int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
@@ -883,10 +912,17 @@ int mv88e6390_serdes_pcs_config(struct m
 static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 	int port, int lane, struct phylink_link_state *state)
 {
-	u16 lpa, status;
+	u16 lpa, status, ctrl;
 	int err;
 
 	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
+				    MV88E6390_SGMII_BMCR, &ctrl);
+	if (err) {
+		dev_err(chip->dev, "can't read Serdes PHY control: %d\n", err);
+		return err;
+	}
+
+	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
 				    MV88E6390_SGMII_PHY_STATUS, &status);
 	if (err) {
 		dev_err(chip->dev, "can't read Serdes PHY status: %d\n", err);
@@ -900,7 +936,7 @@ static int mv88e6390_serdes_pcs_get_stat
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, status, lpa, state);
+	return mv88e6xxx_serdes_pcs_get_state(chip, ctrl, status, lpa, state);
 }
 
 static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,


