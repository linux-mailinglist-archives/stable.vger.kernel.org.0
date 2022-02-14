Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AB24B4ACA
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347729AbiBNKdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:33:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347752AbiBNKct (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:32:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D446C4F;
        Mon, 14 Feb 2022 02:00:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9649C6077B;
        Mon, 14 Feb 2022 10:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F4AC340E9;
        Mon, 14 Feb 2022 10:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832819;
        bh=foWXnFOf9ZPLRGsRL/WHDIoeJtrQr8lElaKtUhB1ngY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Opr7wuF2/ROp6skzi9pUxXQWtfLDv/Ho9K051bPXwItAklunLBwliRBYir/oJe9yd
         S+VcCJ1njQ8WowBMjofSAxYV8gZOQDMDlwzORnpr9tczvB6KFLJ8+5h5CyNhIt0RGf
         ojdLcoPZ+WO3Sk+Rq590jT30ob60EOuyxyyUI1JU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rafael Richter <Rafael.Richter@gin.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 134/203] net: dsa: mv88e6xxx: dont use devres for mdiobus
Date:   Mon, 14 Feb 2022 10:26:18 +0100
Message-Id: <20220214092514.785303891@linuxfoundation.org>
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

[ Upstream commit f53a2ce893b2c7884ef94471f170839170a4eba0 ]

As explained in commits:
74b6d7d13307 ("net: dsa: realtek: register the MDIO bus under devres")
5135e96a3dd2 ("net: dsa: don't allocate the slave_mii_bus using devres")

mdiobus_free() will panic when called from devm_mdiobus_free() <-
devres_release_all() <- __device_release_driver(), and that mdiobus was
not previously unregistered.

The mv88e6xxx is an MDIO device, so the initial set of constraints that
I thought would cause this (I2C or SPI buses which call ->remove on
->shutdown) do not apply. But there is one more which applies here.

If the DSA master itself is on a bus that calls ->remove from ->shutdown
(like dpaa2-eth, which is on the fsl-mc bus), there is a device link
between the switch and the DSA master, and device_links_unbind_consumers()
will unbind the Marvell switch driver on shutdown.

systemd-shutdown[1]: Powering off.
mv88e6085 0x0000000008b96000:00 sw_gl0: Link is Down
fsl-mc dpbp.9: Removing from iommu group 7
fsl-mc dpbp.8: Removing from iommu group 7
------------[ cut here ]------------
kernel BUG at drivers/net/phy/mdio_bus.c:677!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 1 Comm: systemd-shutdow Not tainted 5.16.5-00040-gdc05f73788e5 #15
pc : mdiobus_free+0x44/0x50
lr : devm_mdiobus_free+0x10/0x20
Call trace:
 mdiobus_free+0x44/0x50
 devm_mdiobus_free+0x10/0x20
 devres_release_all+0xa0/0x100
 __device_release_driver+0x190/0x220
 device_release_driver_internal+0xac/0xb0
 device_links_unbind_consumers+0xd4/0x100
 __device_release_driver+0x4c/0x220
 device_release_driver_internal+0xac/0xb0
 device_links_unbind_consumers+0xd4/0x100
 __device_release_driver+0x94/0x220
 device_release_driver+0x28/0x40
 bus_remove_device+0x118/0x124
 device_del+0x174/0x420
 fsl_mc_device_remove+0x24/0x40
 __fsl_mc_device_remove+0xc/0x20
 device_for_each_child+0x58/0xa0
 dprc_remove+0x90/0xb0
 fsl_mc_driver_remove+0x20/0x5c
 __device_release_driver+0x21c/0x220
 device_release_driver+0x28/0x40
 bus_remove_device+0x118/0x124
 device_del+0x174/0x420
 fsl_mc_bus_remove+0x80/0x100
 fsl_mc_bus_shutdown+0xc/0x1c
 platform_shutdown+0x20/0x30
 device_shutdown+0x154/0x330
 kernel_power_off+0x34/0x6c
 __do_sys_reboot+0x15c/0x250
 __arm64_sys_reboot+0x20/0x30
 invoke_syscall.constprop.0+0x4c/0xe0
 do_el0_svc+0x4c/0x150
 el0_svc+0x24/0xb0
 el0t_64_sync_handler+0xa8/0xb0
 el0t_64_sync+0x178/0x17c

So the same treatment must be applied to all DSA switch drivers, which
is: either use devres for both the mdiobus allocation and registration,
or don't use devres at all.

The Marvell driver already has a good structure for mdiobus removal, so
just plug in mdiobus_free and get rid of devres.

Fixes: ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
Reported-by: Rafael Richter <Rafael.Richter@gin.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Daniel Klauer <daniel.klauer@gin.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index cd8462d1e27c0..fcd648d0f6372 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3415,7 +3415,7 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 			return err;
 	}
 
-	bus = devm_mdiobus_alloc_size(chip->dev, sizeof(*mdio_bus));
+	bus = mdiobus_alloc_size(sizeof(*mdio_bus));
 	if (!bus)
 		return -ENOMEM;
 
@@ -3440,14 +3440,14 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 	if (!external) {
 		err = mv88e6xxx_g2_irq_mdio_setup(chip, bus);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	err = of_mdiobus_register(bus, np);
 	if (err) {
 		dev_err(chip->dev, "Cannot register MDIO bus (%d)\n", err);
 		mv88e6xxx_g2_irq_mdio_free(chip, bus);
-		return err;
+		goto out;
 	}
 
 	if (external)
@@ -3456,6 +3456,10 @@ static int mv88e6xxx_mdio_register(struct mv88e6xxx_chip *chip,
 		list_add(&mdio_bus->list, &chip->mdios);
 
 	return 0;
+
+out:
+	mdiobus_free(bus);
+	return err;
 }
 
 static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
@@ -3471,6 +3475,7 @@ static void mv88e6xxx_mdios_unregister(struct mv88e6xxx_chip *chip)
 			mv88e6xxx_g2_irq_mdio_free(chip, bus);
 
 		mdiobus_unregister(bus);
+		mdiobus_free(bus);
 	}
 }
 
-- 
2.34.1



