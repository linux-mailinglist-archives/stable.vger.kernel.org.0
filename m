Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B7A4B4ADF
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348149AbiBNKd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:33:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347920AbiBNKdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:33:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A174B2BD9;
        Mon, 14 Feb 2022 02:00:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E3F060C32;
        Mon, 14 Feb 2022 10:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EA0C340F0;
        Mon, 14 Feb 2022 10:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832828;
        bh=TBnyqoTQPosQtBqxYCNdVgHbcUIa0+jxn7HOS9c/KvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zOpCWNoyowSb3Ji3fjFbd6GQxu28xQ8S5ah7huglGhF0gbdqcOybk9sXwTF8pC0Ad
         kGuneG199TOqG129RR3zIBN4SEe5AwxLlaZBUr6bW1wWUCeJL98vB56znfZVSg7DWO
         YhbvJmoyNa70EueGNpZAMdM0sqNepwaZdd+hCR1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 136/203] net: dsa: bcm_sf2: dont use devres for mdiobus
Date:   Mon, 14 Feb 2022 10:26:20 +0100
Message-Id: <20220214092514.857178364@linuxfoundation.org>
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

[ Upstream commit 08f1a20822349004bb9cc1b153ecb516e9f2889d ]

As explained in commits:
74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")

mdiobus_free() will panic when called from devm_mdiobus_free() <-
devres_release_all() <- __device_release_driver(), and that mdiobus was
not previously unregistered.

The Starfighter 2 is a platform device, so the initial set of
constraints that I thought would cause this (I2C or SPI buses which call
->remove on ->shutdown) do not apply. But there is one more which
applies here.

If the DSA master itself is on a bus that calls ->remove from ->shutdown
(like dpaa2-eth, which is on the fsl-mc bus), there is a device link
between the switch and the DSA master, and device_links_unbind_consumers()
will unbind the bcm_sf2 switch driver on shutdown.

So the same treatment must be applied to all DSA switch drivers, which
is: either use devres for both the mdiobus allocation and registration,
or don't use devres at all.

The bcm_sf2 driver has the code structure in place for orderly mdiobus
removal, so just replace devm_mdiobus_alloc() with the non-devres
variant, and add manual free where necessary, to ensure that we don't
let devres free a still-registered bus.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 13aa43b5cffd9..1502d200682f8 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -584,7 +584,7 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 	get_device(&priv->master_mii_bus->dev);
 	priv->master_mii_dn = dn;
 
-	priv->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
+	priv->slave_mii_bus = mdiobus_alloc();
 	if (!priv->slave_mii_bus) {
 		of_node_put(dn);
 		return -ENOMEM;
@@ -644,8 +644,10 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 	}
 
 	err = mdiobus_register(priv->slave_mii_bus);
-	if (err && dn)
+	if (err && dn) {
+		mdiobus_free(priv->slave_mii_bus);
 		of_node_put(dn);
+	}
 
 	return err;
 }
@@ -653,6 +655,7 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 static void bcm_sf2_mdio_unregister(struct bcm_sf2_priv *priv)
 {
 	mdiobus_unregister(priv->slave_mii_bus);
+	mdiobus_free(priv->slave_mii_bus);
 	of_node_put(priv->master_mii_dn);
 }
 
-- 
2.34.1



