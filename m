Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA926BB195
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbjCOM2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbjCOM2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:28:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5679DE0D
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:27:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A60D7B81DF6
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250E6C433EF;
        Wed, 15 Mar 2023 12:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883237;
        bh=Xf5Cg1gXPVY1iv+BGNb5LoOnu9hrfA8faKaGqG94wUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkSbvbWVMOBC4he+09IFSsdDMwWtb+v+dP6ja7UbBfrVRqVqKKe4eI8u3zNkGBzAI
         3WSazLk8rwLutCxBRCXoQs3RJAMNVhx29ftiS/Drf6kVO8n+2G1fUx/M2FOHwy4TgW
         pdrLvHHal20fdJHonlwAUnCv1rW1cM9ydGQUtWPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lukas Wunner <lukas@wunner.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Ferry Toth <fntoth@gmail.com>
Subject: [PATCH 5.15 067/145] net: phy: smsc: Cache interrupt mask
Date:   Wed, 15 Mar 2023 13:12:13 +0100
Message-Id: <20230315115741.248020394@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 7e8b617eb93f9fcaedac02cd19edcad31c767386 ]

Cache the interrupt mask to avoid re-reading it from the PHY upon every
interrupt.

This will simplify a subsequent commit which detects hot-removal in the
interrupt handler and bails out.

Analyzing and debugging PHY transactions also becomes simpler if such
redundant reads are avoided.

Last not least, interrupt overhead and latency is slightly improved.

Tested-by: Oleksij Rempel <o.rempel@pengutronix.de> # LAN9514/9512/9500
Tested-by: Ferry Toth <fntoth@gmail.com> # LAN9514
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 58aac3a2ef41 ("net: phy: smsc: fix link up detection in forced irq mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 636b0907a5987..63dca3bb56110 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -44,6 +44,7 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 };
 
 struct smsc_phy_priv {
+	u16 intmask;
 	bool energy_enable;
 	struct clk *refclk;
 };
@@ -58,7 +59,6 @@ static int smsc_phy_ack_interrupt(struct phy_device *phydev)
 static int smsc_phy_config_intr(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
-	u16 intmask = 0;
 	int rc;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
@@ -66,12 +66,15 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 		if (rc)
 			return rc;
 
-		intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
+		priv->intmask = MII_LAN83C185_ISF_INT4 | MII_LAN83C185_ISF_INT6;
 		if (priv->energy_enable)
-			intmask |= MII_LAN83C185_ISF_INT7;
-		rc = phy_write(phydev, MII_LAN83C185_IM, intmask);
+			priv->intmask |= MII_LAN83C185_ISF_INT7;
+
+		rc = phy_write(phydev, MII_LAN83C185_IM, priv->intmask);
 	} else {
-		rc = phy_write(phydev, MII_LAN83C185_IM, intmask);
+		priv->intmask = 0;
+
+		rc = phy_write(phydev, MII_LAN83C185_IM, 0);
 		if (rc)
 			return rc;
 
@@ -83,13 +86,8 @@ static int smsc_phy_config_intr(struct phy_device *phydev)
 
 static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 {
-	int irq_status, irq_enabled;
-
-	irq_enabled = phy_read(phydev, MII_LAN83C185_IM);
-	if (irq_enabled < 0) {
-		phy_error(phydev);
-		return IRQ_NONE;
-	}
+	struct smsc_phy_priv *priv = phydev->priv;
+	int irq_status;
 
 	irq_status = phy_read(phydev, MII_LAN83C185_ISF);
 	if (irq_status < 0) {
@@ -97,7 +95,7 @@ static irqreturn_t smsc_phy_handle_interrupt(struct phy_device *phydev)
 		return IRQ_NONE;
 	}
 
-	if (!(irq_status & irq_enabled))
+	if (!(irq_status & priv->intmask))
 		return IRQ_NONE;
 
 	phy_trigger_machine(phydev);
-- 
2.39.2



