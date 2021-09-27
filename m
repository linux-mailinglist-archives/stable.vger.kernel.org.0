Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E125419BF7
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236072AbhI0RYc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:24:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237175AbhI0RWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:22:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0353660F46;
        Mon, 27 Sep 2021 17:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762844;
        bh=HiR7uajrARarixycHTx6stbc43l2Q8NQ8R/iJV3Ij2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bh/MdoJSZz2qU0rs/2Ke7ev4gUyJ9SlS/wjLDf0yZ7Kqq8BUHLH3Wk+4x0zqX9tYA
         fNSn+QpE/hRHK7yIumZMQam4VIulW+9fbHKVwlse049mdZAVJWlS31T3ZjVj2bAWBZ
         y04g6mq/qCzecwLTNkfyoXCNZj5X6paN1clQXwfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 073/162] net: dsa: realtek: register the MDIO bus under devres
Date:   Mon, 27 Sep 2021 19:01:59 +0200
Message-Id: <20210927170235.980557546@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 74b6d7d13307b016f4b5bba8198297824c0ee6df ]

The Linux device model permits both the ->shutdown and ->remove driver
methods to get called during a shutdown procedure. Example: a DSA switch
which sits on an SPI bus, and the SPI bus driver calls this on its
->shutdown method:

spi_unregister_controller
-> device_for_each_child(&ctlr->dev, NULL, __unregister);
   -> spi_unregister_device(to_spi_device(dev));
      -> device_del(&spi->dev);

So this is a simple pattern which can theoretically appear on any bus,
although the only other buses on which I've been able to find it are
I2C:

i2c_del_adapter
-> device_for_each_child(&adap->dev, NULL, __unregister_client);
   -> i2c_unregister_device(client);
      -> device_unregister(&client->dev);

The implication of this pattern is that devices on these buses can be
unregistered after having been shut down. The drivers for these devices
might choose to return early either from ->remove or ->shutdown if the
other callback has already run once, and they might choose that the
->shutdown method should only perform a subset of the teardown done by
->remove (to avoid unnecessary delays when rebooting).

So in other words, the device driver may choose on ->remove to not
do anything (therefore to not unregister an MDIO bus it has registered
on ->probe), because this ->remove is actually triggered by the
device_shutdown path, and its ->shutdown method has already run and done
the minimally required cleanup.

This used to be fine until the blamed commit, but now, the following
BUG_ON triggers:

void mdiobus_free(struct mii_bus *bus)
{
	/* For compatibility with error handling in drivers. */
	if (bus->state == MDIOBUS_ALLOCATED) {
		kfree(bus);
		return;
	}

	BUG_ON(bus->state != MDIOBUS_UNREGISTERED);
	bus->state = MDIOBUS_RELEASED;

	put_device(&bus->dev);
}

In other words, there is an attempt to free an MDIO bus which was not
unregistered. The attempt to free it comes from the devres release
callbacks of the SPI device, which are executed after the device is
unregistered.

I'm not saying that the fact that MDIO buses allocated using devres
would automatically get unregistered wasn't strange. I'm just saying
that the commit didn't care about auditing existing call paths in the
kernel, and now, the following code sequences are potentially buggy:

(a) devm_mdiobus_alloc followed by plain mdiobus_register, for a device
    located on a bus that unregisters its children on shutdown. After
    the blamed patch, either both the alloc and the register should use
    devres, or none should.

(b) devm_mdiobus_alloc followed by plain mdiobus_register, and then no
    mdiobus_unregister at all in the remove path. After the blamed
    patch, nobody unregisters the MDIO bus anymore, so this is even more
    buggy than the previous case which needs a specific bus
    configuration to be seen, this one is an unconditional bug.

In this case, the Realtek drivers fall under category (b). To solve it,
we can register the MDIO bus under devres too, which restores the
previous behavior.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reported-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek-smi-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/realtek-smi-core.c b/drivers/net/dsa/realtek-smi-core.c
index 8e49d4f85d48..6bf46d76c028 100644
--- a/drivers/net/dsa/realtek-smi-core.c
+++ b/drivers/net/dsa/realtek-smi-core.c
@@ -368,7 +368,7 @@ int realtek_smi_setup_mdio(struct realtek_smi *smi)
 	smi->slave_mii_bus->parent = smi->dev;
 	smi->ds->slave_mii_bus = smi->slave_mii_bus;
 
-	ret = of_mdiobus_register(smi->slave_mii_bus, mdio_np);
+	ret = devm_of_mdiobus_register(smi->dev, smi->slave_mii_bus, mdio_np);
 	if (ret) {
 		dev_err(smi->dev, "unable to register MDIO bus %s\n",
 			smi->slave_mii_bus->id);
-- 
2.33.0



