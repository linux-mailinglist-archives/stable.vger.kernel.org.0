Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D831A6C1765
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbjCTPNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:13:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232328AbjCTPNH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:13:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A812FCE1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:08:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E7256157F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA97C433EF;
        Mon, 20 Mar 2023 15:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324884;
        bh=zwQswfezPBDdljE1iNWJ1DMxzTD4Peh23xWa/CnoyF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wifVnrZIWHZykECQfHRRTf6/iQX+nj9A5RJ3dXSRKpFdB/JMzqkylHIqw/cAyv7OF
         j4iNDvn7on5dBvDYeh/prbUY7DgCWpVdYEA5dGhD9Ekzk7MYn0eeLIetfclY7BLTVy
         ATdyXkRF4/Et0i6woc8VGwTFA3oCI/wodaaRsJB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Heiner Kallweit <hkallweit1@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 044/115] sh_eth: avoid PHY being resumed when interface is not up
Date:   Mon, 20 Mar 2023 15:54:16 +0100
Message-Id: <20230320145451.278586718@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit c6be7136afb224a01d4cde2983ddebac8da98693 ]

SH_ETH doesn't need mdiobus suspend/resume, that's why it sets
'mac_managed_pm'. However, setting it needs to be moved from init to
probe, so mdiobus PM functions will really never be called (e.g. when
the interface is not up yet during suspend/resume).

Fixes: 6a1dbfefdae4 ("net: sh_eth: Fix PHY state warning splat during system resume")
Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 4e190f5e32c3d..b6e426d8014d1 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2033,8 +2033,6 @@ static int sh_eth_phy_init(struct net_device *ndev)
 		}
 	}
 
-	/* Indicate that the MAC is responsible for managing PHY PM */
-	phydev->mac_managed_pm = true;
 	phy_attached_info(phydev);
 
 	return 0;
@@ -3074,6 +3072,8 @@ static int sh_mdio_init(struct sh_eth_private *mdp,
 	struct bb_info *bitbang;
 	struct platform_device *pdev = mdp->pdev;
 	struct device *dev = &mdp->pdev->dev;
+	struct phy_device *phydev;
+	struct device_node *pn;
 
 	/* create bit control struct for PHY */
 	bitbang = devm_kzalloc(dev, sizeof(struct bb_info), GFP_KERNEL);
@@ -3108,6 +3108,14 @@ static int sh_mdio_init(struct sh_eth_private *mdp,
 	if (ret)
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



