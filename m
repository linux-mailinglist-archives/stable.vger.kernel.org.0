Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4D44CF78F
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbiCGJqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234934AbiCGJmH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:42:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCEEDED7;
        Mon,  7 Mar 2022 01:41:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C6CF61354;
        Mon,  7 Mar 2022 09:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108EDC340FF;
        Mon,  7 Mar 2022 09:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646071;
        bh=kRf2+Neh77iSMJt5sEjQ41gXstfFY7Iu39R7lcfHym4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRSO8yPNB8e5XTqrtWExOIShYPSl/8PN1tOuo/kqrqIiLymL5p6pIsIWeSw5ZiT0q
         eGiu2eyaTGbDFexQiclnwfG0t5cUcXFnhgTuu2nYS+mBoS0Qa4Zz0nj8SPy+5o6lui
         zbUjrHyHz7c/f6RVvNQJEPqSvntW/W7T5bEC1VVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 123/262] net: dsa: seville: register the mdiobus under devres
Date:   Mon,  7 Mar 2022 10:17:47 +0100
Message-Id: <20220307091705.932468911@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit bd488afc3b39e045ba71aab472233f2a78726e7b ]

As explained in commits:
74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")

mdiobus_free() will panic when called from devm_mdiobus_free() <-
devres_release_all() <- __device_release_driver(), and that mdiobus was
not previously unregistered.

The Seville VSC9959 switch is a platform device, so the initial set of
constraints that I thought would cause this (I2C or SPI buses which call
->remove on ->shutdown) do not apply. But there is one more which
applies here.

If the DSA master itself is on a bus that calls ->remove from ->shutdown
(like dpaa2-eth, which is on the fsl-mc bus), there is a device link
between the switch and the DSA master, and device_links_unbind_consumers()
will unbind the seville switch driver on shutdown.

So the same treatment must be applied to all DSA switch drivers, which
is: either use devres for both the mdiobus allocation and registration,
or don't use devres at all.

The seville driver has a code structure that could accommodate both the
mdiobus_unregister and mdiobus_free calls, but it has an external
dependency upon mscc_miim_setup() from mdio-mscc-miim.c, which calls
devm_mdiobus_alloc_size() on its behalf. So rather than restructuring
that, and exporting yet one more symbol mscc_miim_teardown(), let's work
with devres and replace of_mdiobus_register with the devres variant.
When we use all-devres, we can ensure that devres doesn't free a
still-registered bus (it either runs both callbacks, or none).

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index ca8c003b99bc5..05e4e75c01076 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1111,7 +1111,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
 
 	/* Needed in order to initialize the bus mutex lock */
-	rc = of_mdiobus_register(bus, NULL);
+	rc = devm_of_mdiobus_register(dev, bus, NULL);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
 		return rc;
@@ -1163,7 +1163,8 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 		mdio_device_free(pcs->mdio);
 		lynx_pcs_destroy(pcs);
 	}
-	mdiobus_unregister(felix->imdio);
+
+	/* mdiobus_unregister and mdiobus_free handled by devres */
 }
 
 static const struct felix_info seville_info_vsc9953 = {
-- 
2.34.1



