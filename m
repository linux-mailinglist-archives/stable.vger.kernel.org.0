Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CC263DE7B
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiK3ShX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiK3ShV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:37:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344A893A69
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:37:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C51DB61D6F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F01C433C1;
        Wed, 30 Nov 2022 18:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833438;
        bh=ySM7WMAUi+iHkTm/tXD90O6rNr2qYnNWawf/pNYiTtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KfaPgVBQeT9jrP2xHuhXqjIfnMX8j3wkALhtODopVp3q5avgcmqdoNjIluHKw5jVh
         9O1n40Y4/iI2gBEjj10KMRqqph5hwNkKH+a+MRALnTY71lYEHHZ08NQHvXhbe/yuL+
         c3C/TpxHODGbmssl3CjxtvPXXtCtmVP4aZVdMPZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 078/206] net: dsa: sja1105: disallow C45 transactions on the BASE-TX MDIO bus
Date:   Wed, 30 Nov 2022 19:22:10 +0100
Message-Id: <20221130180534.982500311@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 24deec6b9e4a051635f75777844ffc184644fec9 ]

You'd think people know that the internal 100BASE-TX PHY on the SJA1110
responds only to clause 22 MDIO transactions, but they don't :)

When a clause 45 transaction is attempted, sja1105_base_tx_mdio_read()
and sja1105_base_tx_mdio_write() don't expect "reg" to contain bit 30
set (MII_ADDR_C45) and pack this value into the SPI transaction buffer.

But the field in the SPI buffer has a width smaller than 30 bits, so we
see this confusing message from the packing() API rather than a proper
rejection of C45 transactions:

Call trace:
 dump_stack+0x1c/0x38
 sja1105_pack+0xbc/0xc0 [sja1105]
 sja1105_xfer+0x114/0x2b0 [sja1105]
 sja1105_xfer_u32+0x44/0xf4 [sja1105]
 sja1105_base_tx_mdio_read+0x44/0x7c [sja1105]
 mdiobus_read+0x44/0x80
 get_phy_c45_ids+0x70/0x234
 get_phy_device+0x68/0x15c
 fwnode_mdiobus_register_phy+0x74/0x240
 of_mdiobus_register+0x13c/0x380
 sja1105_mdiobus_register+0x368/0x490 [sja1105]
 sja1105_setup+0x94/0x119c [sja1105]
Cannot store 401d2405 inside bits 24-4 (would truncate)

Fixes: 5a8f09748ee7 ("net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_mdio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 215dd17ca790..4059fcc8c832 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -256,6 +256,9 @@ static int sja1105_base_tx_mdio_read(struct mii_bus *bus, int phy, int reg)
 	u32 tmp;
 	int rc;
 
+	if (reg & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
 	rc = sja1105_xfer_u32(priv, SPI_READ, regs->mdio_100base_tx + reg,
 			      &tmp, NULL);
 	if (rc < 0)
@@ -272,6 +275,9 @@ static int sja1105_base_tx_mdio_write(struct mii_bus *bus, int phy, int reg,
 	const struct sja1105_regs *regs = priv->info->regs;
 	u32 tmp = val;
 
+	if (reg & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
 	return sja1105_xfer_u32(priv, SPI_WRITE, regs->mdio_100base_tx + reg,
 				&tmp, NULL);
 }
-- 
2.35.1



