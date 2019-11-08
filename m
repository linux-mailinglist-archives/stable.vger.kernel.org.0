Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF34F575B
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391336AbfKHTUe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:20:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:57248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389421AbfKHTAH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:00:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95DAD2248D;
        Fri,  8 Nov 2019 18:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239505;
        bh=iKwre2xSx1YiH/5+fhpFyPARnJ3tWS/KJ2o5COKmVjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfSToNTVmntnmdevLRSNRd7SqQUiYnzpDMIXrztZShZ+SQZwJimUIOv8TiSLjzp2R
         0y5LREF4IPzp6+9N6/Jpgz2q//e/+M3KJiBXGoq4HF6UdTIBEBAt0Fn9Y1qN1HEI88
         zFRqz6aHB64tl1YB2thM+tPZFxHZBuPG+aSUizbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 27/62] net: dsa: bcm_sf2: Fix IMP setup for port different than 8
Date:   Fri,  8 Nov 2019 19:50:15 +0100
Message-Id: <20191108174741.364762939@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174719.228826381@linuxfoundation.org>
References: <20191108174719.228826381@linuxfoundation.org>
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
@@ -106,22 +106,11 @@ static void bcm_sf2_imp_setup(struct dsa
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
 
@@ -140,10 +129,27 @@ static void bcm_sf2_imp_setup(struct dsa
 
 	bcm_sf2_brcm_hdr_setup(priv, port);
 
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
 
 static void bcm_sf2_eee_enable_set(struct dsa_switch *ds, int port, bool enable)


