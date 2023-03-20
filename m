Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3325D6C185C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjCTPXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbjCTPXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:23:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04B633CDD
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:16:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0066CE12DB
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FD1C4339C;
        Mon, 20 Mar 2023 15:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325399;
        bh=S+v12j4azPgfadyEmIsZ7mUkp4E+LD/c/oGnsJ48BCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qp6qF2xg2Nk5X9LW3/0WX76MZz6kw5ThUojg8YcIJ09jId1jFIwU41hlxz94MtD9s
         Zkyjjra+YxI9+E/SXgpDB7dgNt4wyS3w3QH9f4DWbg9MNMvehShZx/oVbxwDv1PzZ7
         LP5Inh5WSRoEnz7KuY9RVK8zUQcbZqp3QrbnmJD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/198] ravb: avoid PHY being resumed when interface is not up
Date:   Mon, 20 Mar 2023 15:53:38 +0100
Message-Id: <20230320145510.882308038@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 7f5ebf5dae42e710162f1c481ebcf28ab7b741c7 ]

RAVB doesn't need mdiobus suspend/resume, that's why it sets
'mac_managed_pm'. However, setting it needs to be moved from init to
probe, so mdiobus PM functions will really never be called (e.g. when
the interface is not up yet during suspend/resume).

Fixes: 4924c0cdce75 ("net: ravb: Fix PHY state warning splat during system resume")
Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 0f54849a38235..894e2690c6437 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1455,8 +1455,6 @@ static int ravb_phy_init(struct net_device *ndev)
 		phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_100baseT_Half_BIT);
 	}
 
-	/* Indicate that the MAC is responsible for managing PHY PM */
-	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	return 0;
@@ -2379,6 +2377,8 @@ static int ravb_mdio_init(struct ravb_private *priv)
 {
 	struct platform_device *pdev = priv->pdev;
 	struct device *dev = &pdev->dev;
+	struct phy_device *phydev;
+	struct device_node *pn;
 	int error;
 
 	/* Bitbang init */
@@ -2400,6 +2400,14 @@ static int ravb_mdio_init(struct ravb_private *priv)
 	if (error)
 		goto out_free_bus;
 
+	pn = of_parse_phandle(dev->of_node, "phy-handle", 0);
+	phydev = of_phy_find_device(pn);
+	if (phydev) {
+		phydev->mac_managed_pm = true;
+		put_device(&phydev->mdio.dev);
+	}
+	of_node_put(pn);
+
 	return 0;
 
 out_free_bus:
-- 
2.39.2



