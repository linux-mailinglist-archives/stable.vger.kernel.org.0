Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B9FE6764
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731117AbfJ0VUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730775AbfJ0VUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:20:34 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDFA920717;
        Sun, 27 Oct 2019 21:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211234;
        bh=ugzrjbYkU1KrYuTzjbMkb4Wxg59tEBr0j7Zeg6FgpKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GJGOwsZ6XG57kNrxr2vWRvgCk/OBvePGwikAqZWJfS+izO9Usa71mwxo98QfAJAiW
         oVVOTC95J4DRfIy/PV+gPAvW4g5MDAJAXOzJZENmvKrKJVX3xui1aVlvzq+u/9XyEa
         0wGVERxWqBkf6iGHSliI56Ya8ePsu09I+DFICIww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 042/197] net: ag71xx: fix mdio subnode support
Date:   Sun, 27 Oct 2019 21:59:20 +0100
Message-Id: <20191027203353.984467267@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 569aad4fcd82cba64eb10ede235d330a00f0aa09 ]

This patch is syncing driver with actual devicetree documentation:
Documentation/devicetree/bindings/net/qca,ar71xx.txt
|Optional subnodes:
|- mdio : specifies the mdio bus, used as a container for phy nodes
|  according to phy.txt in the same directory

The driver was working with fixed phy without any noticeable issues. This bug
was uncovered by introducing dsa ar9331-switch driver.
Since no one reported this bug until now, I assume no body is using it
and this patch should not brake existing system.

Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/ag71xx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 6703960c7cf50..d1101eea15c2a 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -526,7 +526,7 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
 	struct device *dev = &ag->pdev->dev;
 	struct net_device *ndev = ag->ndev;
 	static struct mii_bus *mii_bus;
-	struct device_node *np;
+	struct device_node *np, *mnp;
 	int err;
 
 	np = dev->of_node;
@@ -571,7 +571,9 @@ static int ag71xx_mdio_probe(struct ag71xx *ag)
 		msleep(200);
 	}
 
-	err = of_mdiobus_register(mii_bus, np);
+	mnp = of_get_child_by_name(np, "mdio");
+	err = of_mdiobus_register(mii_bus, mnp);
+	of_node_put(mnp);
 	if (err)
 		goto mdio_err_put_clk;
 
-- 
2.20.1



