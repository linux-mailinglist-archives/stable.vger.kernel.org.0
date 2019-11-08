Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A63F5568
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731278AbfKHTCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:02:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390459AbfKHTCN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:02:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBB3F214DB;
        Fri,  8 Nov 2019 19:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239732;
        bh=Qy1e6bHbGD5GJr0rNieFEhlpz/5r6eNcWem9U+clMBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jO48OFK28ShDmS0GfjR84H3Obvw0kUsyNr1u2g6p71MyKSL+JjF5WvwP/R17WA6C2
         +5F6DPX2AdObOS0NmFYg4P4m5mM9iyyEON+fifN14huM/p3EzTrp978CiwqNQkcCcL
         vwf9ymdiS7g46TWL9IKGUaM1PhMlFfVvJUsdXzak=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 43/79] net: dsa: bcm_sf2: Fix IMP setup for port different than 8
Date:   Fri,  8 Nov 2019 19:50:23 +0100
Message-Id: <20191108174811.037430942@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 5fc0f21246e50afdf318b5a3a941f7f4f57b8947 ]

Since it became possible for the DSA core to use a CPU port different
than 8, our bcm_sf2_imp_setup() function was broken because it assumes
that registers are applicable to port 8. In particular, the port's MAC
is going to stay disabled, so make sure we clear the RX_DIS and TX_DIS
bits if we are not configured for port 8.

Fixes: 9f91484f6fcc ("net: dsa: make "label" property optional for dsa2")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/bcm_sf2.c |   36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -41,22 +41,11 @@ static void bcm_sf2_imp_setup(struct dsa
 	unsigned int i;
 	u32 reg, offset;
 
-	if (priv->type == BCM7445_DEVICE_ID)
-		offset = CORE_STS_OVERRIDE_IMP;
-	else
-		offset = CORE_STS_OVERRIDE_IMP2;
-
 	/* Enable the port memories */
 	reg = core_readl(priv, CORE_MEM_PSM_VDD_CTRL);
 	reg &= ~P_TXQ_PSM_VDD(port);
 	core_writel(priv, reg, CORE_MEM_PSM_VDD_CTRL);
 
-	/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */
-	reg = core_readl(priv, CORE_IMP_CTL);
-	reg |= (RX_BCST_EN | RX_MCST_EN | RX_UCST_EN);
-	reg &= ~(RX_DIS | TX_DIS);
-	core_writel(priv, reg, CORE_IMP_CTL);
-
 	/* Enable forwarding */
 	core_writel(priv, SW_FWDG_EN, CORE_SWMODE);
 
@@ -75,10 +64,27 @@ static void bcm_sf2_imp_setup(struct dsa
 
 	b53_brcm_hdr_setup(ds, port);
 
-	/* Force link status for IMP port */
-	reg = core_readl(priv, offset);
-	reg |= (MII_SW_OR | LINK_STS);
-	core_writel(priv, reg, offset);
+	if (port == 8) {
+		if (priv->type == BCM7445_DEVICE_ID)
+			offset = CORE_STS_OVERRIDE_IMP;
+		else
+			offset = CORE_STS_OVERRIDE_IMP2;
+
+		/* Force link status for IMP port */
+		reg = core_readl(priv, offset);
+		reg |= (MII_SW_OR | LINK_STS);
+		core_writel(priv, reg, offset);
+
+		/* Enable Broadcast, Multicast, Unicast forwarding to IMP port */
+		reg = core_readl(priv, CORE_IMP_CTL);
+		reg |= (RX_BCST_EN | RX_MCST_EN | RX_UCST_EN);
+		reg &= ~(RX_DIS | TX_DIS);
+		core_writel(priv, reg, CORE_IMP_CTL);
+	} else {
+		reg = core_readl(priv, CORE_G_PCTL_PORT(port));
+		reg &= ~(RX_DIS | TX_DIS);
+		core_writel(priv, reg, CORE_G_PCTL_PORT(port));
+	}
 }
 
 static void bcm_sf2_gphy_enable_set(struct dsa_switch *ds, bool enable)


