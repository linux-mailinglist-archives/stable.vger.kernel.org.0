Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 950F21A50CE
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgDKMVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728953AbgDKMVP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:21:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4200D2084D;
        Sat, 11 Apr 2020 12:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607675;
        bh=6aGlnK1MW0SGlCS6W+zlqMW7TuFhIRSPsZs1IRDKQZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NByUT8KGONb66AD3dobGF4j6BfY5Zz7VMonp5CjN8OzCmyNaKVzZXH3iNYcIhnHQo
         vf+3ZImDuyDwR3mF8RE6/9tJ2pI4w07E/uYnBOiy/yJGWbk94SYyRIsYT37FAxTCBE
         BrYXgOjRURY3dOVIujNNiXLBZSQ5MnjsziGaqJJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.6 03/38] net: dsa: bcm_sf2: Do not register slave MDIO bus with OF
Date:   Sat, 11 Apr 2020 14:09:40 +0200
Message-Id: <20200411115459.604978365@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115459.324496182@linuxfoundation.org>
References: <20200411115459.324496182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 536fab5bf5826404534a6c271f622ad2930d9119 ]

We were registering our slave MDIO bus with OF and doing so with
assigning the newly created slave_mii_bus of_node to the master MDIO bus
controller node. This is a bad thing to do for a number of reasons:

- we are completely lying about the slave MII bus is arranged and yet we
  still want to control which MDIO devices it probes. It was attempted
  before to play tricks with the bus_mask to perform that:
  https://www.spinics.net/lists/netdev/msg429420.html but the approach
  was rightfully rejected

- the device_node reference counting is messed up and we are effectively
  doing a double probe on the devices we already probed using the
  master, this messes up all resources reference counts (such as clocks)

The proper fix for this as indicated by David in his reply to the
thread above is to use a platform data style registration so as to
control exactly which devices we probe:
https://www.spinics.net/lists/netdev/msg430083.html

By using mdiobus_register(), our slave_mii_bus->phy_mask value is used
as intended, and all the PHY addresses that must be redirected towards
our slave MDIO bus is happening while other addresses get redirected
towards the master MDIO bus.

Fixes: 461cd1b03e32 ("net: dsa: bcm_sf2: Register our slave MDIO bus")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/bcm_sf2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -472,7 +472,7 @@ static int bcm_sf2_mdio_register(struct
 	priv->slave_mii_bus->parent = ds->dev->parent;
 	priv->slave_mii_bus->phy_mask = ~priv->indir_phy_mask;
 
-	err = of_mdiobus_register(priv->slave_mii_bus, dn);
+	err = mdiobus_register(priv->slave_mii_bus);
 	if (err && dn)
 		of_node_put(dn);
 


