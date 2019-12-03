Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF6B111FB7
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbfLCWhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:37:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727812AbfLCWhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:37:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 667B42080A;
        Tue,  3 Dec 2019 22:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412669;
        bh=7A3hz86hho8zPVVfeppDdzaz96Fco5arCwp2AtimF0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBdsSBhW7k5lgkUbWSx5hnSmW7dtBzhItAT9AL7GFpFsEtaF8nsMmlOBqeoiTy1yP
         xMEABvjwHX2/DvsmaW3Ys1v+UqRu6TsIZU8OnMItRKSVqbjNnaF1FUy/Kqw8+ByEBY
         +Dx7F9xX8h3Om2hx8lUdt7ck4MKh5ePr1eRS08no=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 19/46] net: dsa: sja1105: fix sja1105_parse_rgmii_delays()
Date:   Tue,  3 Dec 2019 23:35:39 +0100
Message-Id: <20191203212735.282097523@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 9bca3a0a923fc3f0fb9e41391be1d0f291e86858 ]

This function was using configuration of port 0 in devicetree for all ports.
In case CPU port was not 0, the delay settings was ignored. This resulted not
working communication between CPU and the switch.

Fixes: f5b8631c293b ("net: dsa: sja1105: Error out if RGMII delays are requested in DT")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/sja1105/sja1105_main.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -594,15 +594,15 @@ static int sja1105_parse_rgmii_delays(st
 	int i;
 
 	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
-		if (ports->role == XMII_MAC)
+		if (ports[i].role == XMII_MAC)
 			continue;
 
-		if (ports->phy_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
-		    ports->phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
+		if (ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_RXID ||
+		    ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
 			priv->rgmii_rx_delay[i] = true;
 
-		if (ports->phy_mode == PHY_INTERFACE_MODE_RGMII_TXID ||
-		    ports->phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
+		if (ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_TXID ||
+		    ports[i].phy_mode == PHY_INTERFACE_MODE_RGMII_ID)
 			priv->rgmii_tx_delay[i] = true;
 
 		if ((priv->rgmii_rx_delay[i] || priv->rgmii_tx_delay[i]) &&


