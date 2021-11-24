Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0AA45C278
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245313AbhKXN3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:29:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:48368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344962AbhKXN0h (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:26:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8455D61501;
        Wed, 24 Nov 2021 12:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758201;
        bh=wo7PaFGWPDRSDPvwVc1okJxngLoA5D51+yPFQnqM2OU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+GJ9LmGSpH0ogIkBqFB9iV0516a8XvYWBoXbNsKZ64PNR1b2N255XJZ34GX8tNk1
         4kldM5Uax/VJlNa+VvEi9lKdryUms7u1TzC8sd1GjA2WbkRgTKzFyXGdliE3EIXa8c
         wLrKV98GmW3ohW9+Cis6AqiUNHPHfYvMSMVVvVg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jordan Vrtanoski <jordan.vrtanoski@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Stefan Chulski <stefanc@marvell.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 091/100] Revert "net: mvpp2: disable force link UP during port init procedure"
Date:   Wed, 24 Nov 2021 12:58:47 +0100
Message-Id: <20211124115657.793360445@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit f595e44b161a3c751943c256b6de80dc57d5fcf8 which is
commit 87508224485323ce2d4e7fb929ec80f51adcc238 upstream.

It causes reported problems so should be removed.

Link: https://lore.kernel.org/r/YZv1SBrYTXmorcLJ@shell.armlinux.org.uk
Reported-by: Jordan Vrtanoski <jordan.vrtanoski@gmail.com>
Reported-by: Russell King <linux@armlinux.org.uk>
Cc: Stefan Chulski <stefanc@marvell.com>
Cc: Marcin Wojtas <mw@semihalf.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4545,7 +4545,7 @@ static int mvpp2_port_init(struct mvpp2_
 	struct mvpp2 *priv = port->priv;
 	struct mvpp2_txq_pcpu *txq_pcpu;
 	unsigned int thread;
-	int queue, err, val;
+	int queue, err;
 
 	/* Checks for hardware constraints */
 	if (port->first_rxq + port->nrxqs >
@@ -4559,18 +4559,6 @@ static int mvpp2_port_init(struct mvpp2_
 	mvpp2_egress_disable(port);
 	mvpp2_port_disable(port);
 
-	if (mvpp2_is_xlg(port->phy_interface)) {
-		val = readl(port->base + MVPP22_XLG_CTRL0_REG);
-		val &= ~MVPP22_XLG_CTRL0_FORCE_LINK_PASS;
-		val |= MVPP22_XLG_CTRL0_FORCE_LINK_DOWN;
-		writel(val, port->base + MVPP22_XLG_CTRL0_REG);
-	} else {
-		val = readl(port->base + MVPP2_GMAC_AUTONEG_CONFIG);
-		val &= ~MVPP2_GMAC_FORCE_LINK_PASS;
-		val |= MVPP2_GMAC_FORCE_LINK_DOWN;
-		writel(val, port->base + MVPP2_GMAC_AUTONEG_CONFIG);
-	}
-
 	port->tx_time_coal = MVPP2_TXDONE_COAL_USEC;
 
 	port->txqs = devm_kcalloc(dev, port->ntxqs, sizeof(*port->txqs),


