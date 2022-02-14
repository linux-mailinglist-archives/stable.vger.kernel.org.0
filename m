Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7174B4B6D
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244780AbiBNKeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:34:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348033AbiBNKeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF69C70;
        Mon, 14 Feb 2022 02:01:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E01FB80DC8;
        Mon, 14 Feb 2022 10:01:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CE0C340E9;
        Mon, 14 Feb 2022 10:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832861;
        bh=epHAIHSC308vQjf9ucV1BKLAMyF0ypOMeVSfxBdQHjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Al/19jMDMcK87XpCu1sw312BsG5/t2fLqa5XsdvKSE0mxhPnDmiAgkCaW80nLNk5I
         XziDkJ/x4TqMEg5l05b8M2OiRFy5JbraH5++BCylS5yPpo1UwTSF0nWaP0xibn2ucE
         KKVg1/2MbaAm3mstAUzfV1rIPgSajw/2wBdO/R/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 141/203] net: dsa: lantiq_gswip: dont use devres for mdiobus
Date:   Mon, 14 Feb 2022 10:26:25 +0100
Message-Id: <20220214092515.028009280@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 0d120dfb5d67edc5bcd1804e167dba2b30809afd ]

As explained in commits:
74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")

mdiobus_free() will panic when called from devm_mdiobus_free() <-
devres_release_all() <- __device_release_driver(), and that mdiobus was
not previously unregistered.

The GSWIP switch is a platform device, so the initial set of constraints
that I thought would cause this (I2C or SPI buses which call ->remove on
->shutdown) do not apply. But there is one more which applies here.

If the DSA master itself is on a bus that calls ->remove from ->shutdown
(like dpaa2-eth, which is on the fsl-mc bus), there is a device link
between the switch and the DSA master, and device_links_unbind_consumers()
will unbind the GSWIP switch driver on shutdown.

So the same treatment must be applied to all DSA switch drivers, which
is: either use devres for both the mdiobus allocation and registration,
or don't use devres at all.

The gswip driver has the code structure in place for orderly mdiobus
removal, so just replace devm_mdiobus_alloc() with the non-devres
variant, and add manual free where necessary, to ensure that we don't
let devres free a still-registered bus.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lantiq_gswip.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 7056d98d8177b..0909b05d02133 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -498,8 +498,9 @@ static int gswip_mdio_rd(struct mii_bus *bus, int addr, int reg)
 static int gswip_mdio(struct gswip_priv *priv, struct device_node *mdio_np)
 {
 	struct dsa_switch *ds = priv->ds;
+	int err;
 
-	ds->slave_mii_bus = devm_mdiobus_alloc(priv->dev);
+	ds->slave_mii_bus = mdiobus_alloc();
 	if (!ds->slave_mii_bus)
 		return -ENOMEM;
 
@@ -512,7 +513,11 @@ static int gswip_mdio(struct gswip_priv *priv, struct device_node *mdio_np)
 	ds->slave_mii_bus->parent = priv->dev;
 	ds->slave_mii_bus->phy_mask = ~ds->phys_mii_mask;
 
-	return of_mdiobus_register(ds->slave_mii_bus, mdio_np);
+	err = of_mdiobus_register(ds->slave_mii_bus, mdio_np);
+	if (err)
+		mdiobus_free(ds->slave_mii_bus);
+
+	return err;
 }
 
 static int gswip_pce_table_entry_read(struct gswip_priv *priv,
@@ -2186,8 +2191,10 @@ static int gswip_probe(struct platform_device *pdev)
 	gswip_mdio_mask(priv, GSWIP_MDIO_GLOB_ENABLE, 0, GSWIP_MDIO_GLOB);
 	dsa_unregister_switch(priv->ds);
 mdio_bus:
-	if (mdio_np)
+	if (mdio_np) {
 		mdiobus_unregister(priv->ds->slave_mii_bus);
+		mdiobus_free(priv->ds->slave_mii_bus);
+	}
 put_mdio_node:
 	of_node_put(mdio_np);
 	for (i = 0; i < priv->num_gphy_fw; i++)
@@ -2210,6 +2217,7 @@ static int gswip_remove(struct platform_device *pdev)
 
 	if (priv->ds->slave_mii_bus) {
 		mdiobus_unregister(priv->ds->slave_mii_bus);
+		mdiobus_free(priv->ds->slave_mii_bus);
 		of_node_put(priv->ds->slave_mii_bus->dev.of_node);
 	}
 
-- 
2.34.1



