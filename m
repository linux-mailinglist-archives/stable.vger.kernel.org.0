Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3EA129B34D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766315AbgJ0OsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766310AbgJ0OsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:48:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC7622202;
        Tue, 27 Oct 2020 14:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810086;
        bh=9dcQ/SNJ6w9DkWK0RzLAEDHXqPj/HVNxqAhfxs+OniU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCRIE0eiPcFrnskL9bm4/VQMVw0jz6qOJwEy+pf5cmiVkZL/vRfMxt/1O/BIWMfGL
         wL6AZd4ADwO+XCvZd9afCAsTsmnwKODeMErgdPXqPLRMaQKV6EcyVbzlpYM7/3zkr4
         OOJ6yNNhzyljrAQDWySBxBtLRjLQ8xECjwfvLsKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Richard Leitner <richard.leitner@skidata.com>,
        Marek Vasut <marex@denx.de>,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        "David S. Miller" <davem@davemloft.net>,
        NXP Linux Team <linux-imx@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 008/633] net: fec: Fix PHY init after phy_reset_after_clk_enable()
Date:   Tue, 27 Oct 2020 14:45:51 +0100
Message-Id: <20201027135523.079614702@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 0da1ccbbefb662915228bc17e1c7d4ad28b3ddab ]

The phy_reset_after_clk_enable() does a PHY reset, which means the PHY
loses its register settings. The fec_enet_mii_probe() starts the PHY
and does the necessary calls to configure the PHY via PHY framework,
and loads the correct register settings into the PHY. Therefore,
fec_enet_mii_probe() should be called only after the PHY has been
reset, not before as it is now.

Fixes: 1b0a83ac04e3 ("net: fec: add phy_reset_after_clk_enable() support")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Richard Leitner <richard.leitner@skidata.com>
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/fec_main.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3006,17 +3006,17 @@ fec_enet_open(struct net_device *ndev)
 	/* Init MAC prior to mii bus probe */
 	fec_restart(ndev);
 
-	/* Probe and connect to PHY when open the interface */
-	ret = fec_enet_mii_probe(ndev);
-	if (ret)
-		goto err_enet_mii_probe;
-
 	/* Call phy_reset_after_clk_enable() again if it failed during
 	 * phy_reset_after_clk_enable() before because the PHY wasn't probed.
 	 */
 	if (reset_again)
 		fec_enet_phy_reset_after_clk_enable(ndev);
 
+	/* Probe and connect to PHY when open the interface */
+	ret = fec_enet_mii_probe(ndev);
+	if (ret)
+		goto err_enet_mii_probe;
+
 	if (fep->quirks & FEC_QUIRK_ERR006687)
 		imx6q_cpuidle_fec_irqs_used();
 


