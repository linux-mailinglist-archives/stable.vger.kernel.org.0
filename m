Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959145A4923
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiH2LUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbiH2LTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:19:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E134647C2;
        Mon, 29 Aug 2022 04:13:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA176B80FA7;
        Mon, 29 Aug 2022 11:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C63C433D7;
        Mon, 29 Aug 2022 11:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771557;
        bh=dYGJFV5EgdP70WN5QswLCao+TYDUvdlFgfKFcjfE1/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvCNLybzY9424i3iA1gL/8Inu5HpZVfpaGhAPGeHv6zrJWrHnIIful3Y9jf2CZGjM
         Byz60xyEpUsaSAnYsdD3szXtVYb5BkQ5bhKqerXLw6wLCN5QygWbf577+9L2YdbIBl
         xpLM1o7K/roFAxHp+zg/YILZ1krcUl1hIqcbCD84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Craig McQueen <craig@mcqueen.id.au>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 043/158] net: dsa: microchip: keep compatibility with device tree blobs with no phy-mode
Date:   Mon, 29 Aug 2022 12:58:13 +0200
Message-Id: <20220829105810.577903823@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 5fbb08eb7f945c7e8896ea39f03143ce66dfa4c7 ]

DSA has multiple ways of specifying a MAC connection to an internal PHY.
One requires a DT description like this:

	port@0 {
		reg = <0>;
		phy-handle = <&internal_phy>;
		phy-mode = "internal";
	};

(which is IMO the recommended approach, as it is the clearest
description)

but it is also possible to leave the specification as just:

	port@0 {
		reg = <0>;
	}

and if the driver implements ds->ops->phy_read and ds->ops->phy_write,
the DSA framework "knows" it should create a ds->slave_mii_bus, and it
should connect to a non-OF-based internal PHY on this MDIO bus, at an
MDIO address equal to the port address.

There is also an intermediary way of describing things:

	port@0 {
		reg = <0>;
		phy-handle = <&internal_phy>;
	};

In case 2, DSA calls phylink_connect_phy() and in case 3, it calls
phylink_of_phy_connect(). In both cases, phylink_create() has been
called with a phy_interface_t of PHY_INTERFACE_MODE_NA, and in both
cases, PHY_INTERFACE_MODE_NA is translated into phy->interface.

It is important to note that phy_device_create() initializes
dev->interface = PHY_INTERFACE_MODE_GMII, and so, when we use
phylink_create(PHY_INTERFACE_MODE_NA), no one will override this, and we
will end up with a PHY_INTERFACE_MODE_GMII interface inherited from the
PHY.

All this means that in order to maintain compatibility with device tree
blobs where the phy-mode property is missing, we need to allow the
"gmii" phy-mode and treat it as "internal".

Fixes: 2c709e0bdad4 ("net: dsa: microchip: ksz8795: add phylink support")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216320
Reported-by: Craig McQueen <craig@mcqueen.id.au>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Tested-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Link: https://lore.kernel.org/r/20220818143250.2797111-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 0f02c62b02685..c9389880ad1fa 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -453,9 +453,15 @@ void ksz_phylink_get_caps(struct dsa_switch *ds, int port,
 	if (dev->info->supports_rgmii[port])
 		phy_interface_set_rgmii(config->supported_interfaces);
 
-	if (dev->info->internal_phy[port])
+	if (dev->info->internal_phy[port]) {
 		__set_bit(PHY_INTERFACE_MODE_INTERNAL,
 			  config->supported_interfaces);
+		/* Compatibility for phylib's default interface type when the
+		 * phy-mode property is absent
+		 */
+		__set_bit(PHY_INTERFACE_MODE_GMII,
+			  config->supported_interfaces);
+	}
 
 	if (dev->dev_ops->get_caps)
 		dev->dev_ops->get_caps(dev, port, config);
-- 
2.35.1



