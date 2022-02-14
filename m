Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62EEE4B4839
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245572AbiBNJwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344257AbiBNJvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:51:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8F769484;
        Mon, 14 Feb 2022 01:42:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85D3D61190;
        Mon, 14 Feb 2022 09:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E952C340E9;
        Mon, 14 Feb 2022 09:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831761;
        bh=7xkJakGSNhfRZ3mu004MFMQyYo6ZCPySJbHzwKQxZY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BR/i0E0ghxETsAJ+BjEOmVUsodKbdqGjzul0WKUbsPM0cggjK4paGROG6FF/0g008
         uE1JJvS0d9w7Tpev7RJSw5Whp4zqfdt++MRUpO0m+XDavJtlgoEDIBl8gc2gXnJ30Z
         s8qZ4S6kNbQkXxLgtOhUTL+cWtacZZ89d2BkK4EE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/116] net: dsa: ar9331: register the mdiobus under devres
Date:   Mon, 14 Feb 2022 10:26:09 +0100
Message-Id: <20220214092501.170736461@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
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

[ Upstream commit 50facd86e9fbc4b93fe02e5fe05776047f45dbfb ]

As explained in commits:
74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")

mdiobus_free() will panic when called from devm_mdiobus_free() <-
devres_release_all() <- __device_release_driver(), and that mdiobus was
not previously unregistered.

The ar9331 is an MDIO device, so the initial set of constraints that I
thought would cause this (I2C or SPI buses which call ->remove on
->shutdown) do not apply. But there is one more which applies here.

If the DSA master itself is on a bus that calls ->remove from ->shutdown
(like dpaa2-eth, which is on the fsl-mc bus), there is a device link
between the switch and the DSA master, and device_links_unbind_consumers()
will unbind the ar9331 switch driver on shutdown.

So the same treatment must be applied to all DSA switch drivers, which
is: either use devres for both the mdiobus allocation and registration,
or don't use devres at all.

The ar9331 driver doesn't have a complex code structure for mdiobus
removal, so just replace of_mdiobus_register with the devres variant in
order to be all-devres and ensure that we don't free a still-registered
bus.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/ar9331.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index 661745932a539..c33bdcf7efc58 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -289,7 +289,7 @@ static int ar9331_sw_mbus_init(struct ar9331_sw_priv *priv)
 	if (!mnp)
 		return -ENODEV;
 
-	ret = of_mdiobus_register(mbus, mnp);
+	ret = devm_of_mdiobus_register(dev, mbus, mnp);
 	of_node_put(mnp);
 	if (ret)
 		return ret;
@@ -856,7 +856,6 @@ static void ar9331_sw_remove(struct mdio_device *mdiodev)
 	struct ar9331_sw_priv *priv = dev_get_drvdata(&mdiodev->dev);
 
 	irq_domain_remove(priv->irqdomain);
-	mdiobus_unregister(priv->mbus);
 	dsa_unregister_switch(&priv->ds);
 
 	reset_control_assert(priv->sw_reset);
-- 
2.34.1



