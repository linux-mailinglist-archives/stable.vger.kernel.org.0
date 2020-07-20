Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D2D2269E9
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732008AbgGTP6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:58:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731599AbgGTP6P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:58:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 601E72065E;
        Mon, 20 Jul 2020 15:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260694;
        bh=U96DsrVJZj0nKlPKw5oqQP2nOz9oZwby6gkSTE66v/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDlHroCfFuNEvnvXjRJzhp07y7E/lLmNPWneQBRiJ/6H4SvugjBj7bCquV4pGofh4
         PGx8IVzTxwDTXy/ibuHo6+ZMnxhrX0uvrrfGW0DK4KSvyFgLVWrpn+IRNbpmiL/grA
         /KluO/OVbddCUjK1C8qKLM7p4mekCk47ButaMc9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 060/215] net: ethernet: mvneta: Add back interface mode validation
Date:   Mon, 20 Jul 2020 17:35:42 +0200
Message-Id: <20200720152823.064205838@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 41c2b6b4f0f807803bb49f65835d136941a70f85 ]

When writing the serdes configuration register was moved to
mvneta_config_interface() the whole code block was removed from
mvneta_port_power_up() in the assumption that its only purpose was to
write the serdes configuration register. As mentioned by Russell King
its purpose was also to check for valid interface modes early so that
later in the driver we do not have to care for unexpected interface
modes.
Add back the test to let the driver bail out early on unhandled
interface modes.

Fixes: b4748553f53f ("net: ethernet: mvneta: Fix Serdes configuration for SoCs without comphy")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvneta.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index d443cd19e8951..ccb2abd18d6c7 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -4496,10 +4496,18 @@ static void mvneta_conf_mbus_windows(struct mvneta_port *pp,
 }
 
 /* Power up the port */
-static void mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
+static int mvneta_port_power_up(struct mvneta_port *pp, int phy_mode)
 {
 	/* MAC Cause register should be cleared */
 	mvreg_write(pp, MVNETA_UNIT_INTR_CAUSE, 0);
+
+	if (phy_mode != PHY_INTERFACE_MODE_QSGMII &&
+	    phy_mode != PHY_INTERFACE_MODE_SGMII &&
+	    !phy_interface_mode_is_8023z(phy_mode) &&
+	    !phy_interface_mode_is_rgmii(phy_mode))
+		return -EINVAL;
+
+	return 0;
 }
 
 /* Device initialization routine */
@@ -4683,7 +4691,11 @@ static int mvneta_probe(struct platform_device *pdev)
 	if (err < 0)
 		goto err_netdev;
 
-	mvneta_port_power_up(pp, phy_mode);
+	err = mvneta_port_power_up(pp, pp->phy_interface);
+	if (err < 0) {
+		dev_err(&pdev->dev, "can't power up port\n");
+		return err;
+	}
 
 	/* Armada3700 network controller does not support per-cpu
 	 * operation, so only single NAPI should be initialized.
@@ -4836,7 +4848,11 @@ static int mvneta_resume(struct device *device)
 		}
 	}
 	mvneta_defaults_set(pp);
-	mvneta_port_power_up(pp, pp->phy_interface);
+	err = mvneta_port_power_up(pp, pp->phy_interface);
+	if (err < 0) {
+		dev_err(device, "can't power up port\n");
+		return err;
+	}
 
 	netif_device_attach(dev);
 
-- 
2.25.1



