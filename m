Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE5C4B4927
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239043AbiBNKJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:09:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345098AbiBNKIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:08:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B3775C15;
        Mon, 14 Feb 2022 01:50:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2398EB80DC4;
        Mon, 14 Feb 2022 09:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D69C340E9;
        Mon, 14 Feb 2022 09:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832207;
        bh=NztMsR2kgqmVFtrKAa0G1xzND/aCA27veuaAtsBHcvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NY7414+8jYzcEJdws9uiupL8Y21hoQTTvCRsL++R4gMAKVSaMD8qd1o6N82wofwFs
         WGACdifhUg7XWJ82tL8vCm+BUZNFz6Ko/raoCOa3W7YQm+bp1IiG7rSNQB7ZwbcY5U
         jkkoGwkSiVHIg5j4LJQ20mG0Lx6i8al5X1Uw/7lE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/172] net: dsa: felix: dont use devres for mdiobus
Date:   Mon, 14 Feb 2022 10:26:12 +0100
Message-Id: <20220214092510.367795301@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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

[ Upstream commit 209bdb7ec6a28c7cdf580a0a98afbc9fc3b98932 ]

As explained in commits:
74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")

mdiobus_free() will panic when called from devm_mdiobus_free() <-
devres_release_all() <- __device_release_driver(), and that mdiobus was
not previously unregistered.

The Felix VSC9959 switch is a PCI device, so the initial set of
constraints that I thought would cause this (I2C or SPI buses which call
->remove on ->shutdown) do not apply. But there is one more which
applies here.

If the DSA master itself is on a bus that calls ->remove from ->shutdown
(like dpaa2-eth, which is on the fsl-mc bus), there is a device link
between the switch and the DSA master, and device_links_unbind_consumers()
will unbind the felix switch driver on shutdown.

So the same treatment must be applied to all DSA switch drivers, which
is: either use devres for both the mdiobus allocation and registration,
or don't use devres at all.

The felix driver has the code structure in place for orderly mdiobus
removal, so just replace devm_mdiobus_alloc_size() with the non-devres
variant, and add manual free where necessary, to ensure that we don't
let devres free a still-registered bus.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 11b42fd812e4a..e53ad283e2596 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1066,7 +1066,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		return PTR_ERR(hw);
 	}
 
-	bus = devm_mdiobus_alloc_size(dev, sizeof(*mdio_priv));
+	bus = mdiobus_alloc_size(sizeof(*mdio_priv));
 	if (!bus)
 		return -ENOMEM;
 
@@ -1086,6 +1086,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	rc = mdiobus_register(bus);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
+		mdiobus_free(bus);
 		return rc;
 	}
 
@@ -1135,6 +1136,7 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 		lynx_pcs_destroy(pcs);
 	}
 	mdiobus_unregister(felix->imdio);
+	mdiobus_free(felix->imdio);
 }
 
 static void vsc9959_sched_speed_set(struct ocelot *ocelot, int port,
-- 
2.34.1



