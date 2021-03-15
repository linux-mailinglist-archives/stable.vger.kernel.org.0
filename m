Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B3433B8B1
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhCOOEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:04:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233103AbhCOOAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CCCB64F2E;
        Mon, 15 Mar 2021 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816809;
        bh=6O5awPON+ge0i8ZbQh2v/7heA9fjMbMOYT6/2TkgcR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjtRP7K0oDjvzbc+g/6Wxf+NzzBNXsss8oyyDLb01+NXDLLv2gLpFWTyYNPNYO79q
         1JTIROOjaN0bRwbmVQpINEjTdbjJTq0uI3psubYtLba+XHrqZDfiiOwaQ7HcU4BR3x
         78jMSgxX3BlTlttU5JNjhUyiYsAd3qHzoyNCrky8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/290] enetc: Fix unused var build warning for CONFIG_OF
Date:   Mon, 15 Mar 2021 14:53:39 +0100
Message-Id: <20210315135546.168919059@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4560b2a3ecdd5d587c4c6eea4339899f173a559a ]

When CONFIG_OF is disabled, there is a harmless warning about
an unused variable:

enetc_pf.c: In function 'enetc_phylink_create':
enetc_pf.c:981:17: error: unused variable 'dev' [-Werror=unused-variable]

Slightly rearrange the code to pass around the of_node as a
function argument, which avoids the problem without hurting
readability.

Fixes: 71b77a7a27a3 ("enetc: Migrate to PHYLINK and PCS_LYNX")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://lore.kernel.org/r/20201204120800.17193-1-claudiu.manoil@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 21 +++++++++----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index b35096455293..f29058dddb36 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -859,13 +859,12 @@ static bool enetc_port_has_pcs(struct enetc_pf *pf)
 		pf->if_mode == PHY_INTERFACE_MODE_USXGMII);
 }
 
-static int enetc_mdiobus_create(struct enetc_pf *pf)
+static int enetc_mdiobus_create(struct enetc_pf *pf, struct device_node *node)
 {
-	struct device *dev = &pf->si->pdev->dev;
 	struct device_node *mdio_np;
 	int err;
 
-	mdio_np = of_get_child_by_name(dev->of_node, "mdio");
+	mdio_np = of_get_child_by_name(node, "mdio");
 	if (mdio_np) {
 		err = enetc_mdio_probe(pf, mdio_np);
 
@@ -1009,18 +1008,17 @@ static const struct phylink_mac_ops enetc_mac_phylink_ops = {
 	.mac_link_down = enetc_pl_mac_link_down,
 };
 
-static int enetc_phylink_create(struct enetc_ndev_priv *priv)
+static int enetc_phylink_create(struct enetc_ndev_priv *priv,
+				struct device_node *node)
 {
 	struct enetc_pf *pf = enetc_si_priv(priv->si);
-	struct device *dev = &pf->si->pdev->dev;
 	struct phylink *phylink;
 	int err;
 
 	pf->phylink_config.dev = &priv->ndev->dev;
 	pf->phylink_config.type = PHYLINK_NETDEV;
 
-	phylink = phylink_create(&pf->phylink_config,
-				 of_fwnode_handle(dev->of_node),
+	phylink = phylink_create(&pf->phylink_config, of_fwnode_handle(node),
 				 pf->if_mode, &enetc_mac_phylink_ops);
 	if (IS_ERR(phylink)) {
 		err = PTR_ERR(phylink);
@@ -1086,13 +1084,14 @@ static int enetc_init_port_rss_memory(struct enetc_si *si)
 static int enetc_pf_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *ent)
 {
+	struct device_node *node = pdev->dev.of_node;
 	struct enetc_ndev_priv *priv;
 	struct net_device *ndev;
 	struct enetc_si *si;
 	struct enetc_pf *pf;
 	int err;
 
-	if (pdev->dev.of_node && !of_device_is_available(pdev->dev.of_node)) {
+	if (node && !of_device_is_available(node)) {
 		dev_info(&pdev->dev, "device is disabled, skipping\n");
 		return -ENODEV;
 	}
@@ -1161,12 +1160,12 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
-	if (!of_get_phy_mode(pdev->dev.of_node, &pf->if_mode)) {
-		err = enetc_mdiobus_create(pf);
+	if (!of_get_phy_mode(node, &pf->if_mode)) {
+		err = enetc_mdiobus_create(pf, node);
 		if (err)
 			goto err_mdiobus_create;
 
-		err = enetc_phylink_create(priv);
+		err = enetc_phylink_create(priv, node);
 		if (err)
 			goto err_phylink_create;
 	}
-- 
2.30.1



