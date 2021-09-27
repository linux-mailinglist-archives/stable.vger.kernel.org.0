Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C8F419AE3
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbhI0ROe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:47186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236053AbhI0RLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:11:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75D0561266;
        Mon, 27 Sep 2021 17:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762492;
        bh=HFK8bfC2HyzUFNsiaC28IPlMVY97cmqKE7MMHRKXDG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2npe9bcTsUEIg8ILOrYHKMt4uq8bbtztMAWgmo0lH4Ya0Qqx5jalAchEKv4XKbR/e
         PCCB9+TnFgwVrHjdsV87U5aPxXN5KHelhXxaBgak8AyCJow7v7teUOaSs5IRV5sjoz
         tg/9nsj2VeNxlKJcw5v/6ktLpLqKeWcTe5Ck0M9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/103] net: dsa: dont allocate the slave_mii_bus using devres
Date:   Mon, 27 Sep 2021 19:02:15 +0200
Message-Id: <20210927170227.240608117@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 5135e96a3dd2f4555ae6981c3155a62bcf3227f6 ]

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

In this case, DSA falls into category (a), it tries to be helpful and
registers an MDIO bus on behalf of the switch, which might be on such a
bus. I've no idea why it does it under devres.

It does this on probe:

	if (!ds->slave_mii_bus && ds->ops->phy_read)
		alloc and register mdio bus

and this on remove:

	if (ds->slave_mii_bus && ds->ops->phy_read)
		unregister mdio bus

I _could_ imagine using devres because the condition used on remove is
different than the condition used on probe. So strictly speaking, DSA
cannot determine whether the ds->slave_mii_bus it sees on remove is the
ds->slave_mii_bus that _it_ has allocated on probe. Using devres would
have solved that problem. But nonetheless, the existing code already
proceeds to unregister the MDIO bus, even though it might be
unregistering an MDIO bus it has never registered. So I can only guess
that no driver that implements ds->ops->phy_read also allocates and
registers ds->slave_mii_bus itself.

So in that case, if unregistering is fine, freeing must be fine too.

Stop using devres and free the MDIO bus manually. This will make devres
stop attempting to free a still registered MDIO bus on ->shutdown.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Reported-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa2.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3ada338d7e08..71c8ef7d4087 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -459,7 +459,7 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	devlink_params_publish(ds->devlink);
 
 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
-		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
+		ds->slave_mii_bus = mdiobus_alloc();
 		if (!ds->slave_mii_bus) {
 			err = -ENOMEM;
 			goto teardown;
@@ -469,13 +469,16 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 		err = mdiobus_register(ds->slave_mii_bus);
 		if (err < 0)
-			goto teardown;
+			goto free_slave_mii_bus;
 	}
 
 	ds->setup = true;
 
 	return 0;
 
+free_slave_mii_bus:
+	if (ds->slave_mii_bus && ds->ops->phy_read)
+		mdiobus_free(ds->slave_mii_bus);
 teardown:
 	if (ds->ops->teardown)
 		ds->ops->teardown(ds);
@@ -500,8 +503,11 @@ static void dsa_switch_teardown(struct dsa_switch *ds)
 	if (!ds->setup)
 		return;
 
-	if (ds->slave_mii_bus && ds->ops->phy_read)
+	if (ds->slave_mii_bus && ds->ops->phy_read) {
 		mdiobus_unregister(ds->slave_mii_bus);
+		mdiobus_free(ds->slave_mii_bus);
+		ds->slave_mii_bus = NULL;
+	}
 
 	dsa_switch_unregister_notifier(ds);
 
-- 
2.33.0



