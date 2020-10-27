Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955FC29B70D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798556AbgJ0P24 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:60326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1796774AbgJ0PTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:19:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A8B020728;
        Tue, 27 Oct 2020 15:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811991;
        bh=jvgays3a90RPfEgOKFLjXhqJ2FEh1p8PbKohW/LEUP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g10NekuIBwOZ8lMv/IxmbplxizdPk+E8yKdOZxkc+J0qB8NkJGP+6t33RaAzqwij3
         NYv5vHKM8EE6TuXfoQ0aWqRDRDV+HFtAmcQgnC8GLvcvCT+JmvpwBLhBl60adeW3jp
         vExsq//6VYAXCePZmTKYaQP/SwrZoadaB4h5qSlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Kumlien <ian.kumlien@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 055/757] ixgbe: fix probing of multi-port devices with one MDIO
Date:   Tue, 27 Oct 2020 14:45:05 +0100
Message-Id: <20201027135453.128835689@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit bd7f14df9492e7d3772812a215fca66e6737e598 ]

Ian reports that after upgrade from v5.8.14 to v5.9 only one
of his 4 ixgbe netdevs appear in the system.

Quoting the comment on ixgbe_x550em_a_has_mii():
 * Returns true if hw points to lowest numbered PCI B:D.F x550_em_a device in
 * the SoC.  There are up to 4 MACs sharing a single MDIO bus on the x550em_a,
 * but we only want to register one MDIO bus.

This matches the symptoms, since the return value from
ixgbe_mii_bus_init() is no longer ignored we need to handle
the higher ports of x550em without an error.

Fixes: 09ef193fef7e ("net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()")
Reported-by: Ian Kumlien <ian.kumlien@gmail.com>
Tested-by: Ian Kumlien <ian.kumlien@gmail.com>
Acked-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Link: https://lore.kernel.org/r/20201016232006.3352947-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -901,15 +901,13 @@ static bool ixgbe_x550em_a_has_mii(struc
  **/
 s32 ixgbe_mii_bus_init(struct ixgbe_hw *hw)
 {
+	s32 (*write)(struct mii_bus *bus, int addr, int regnum, u16 val);
+	s32 (*read)(struct mii_bus *bus, int addr, int regnum);
 	struct ixgbe_adapter *adapter = hw->back;
 	struct pci_dev *pdev = adapter->pdev;
 	struct device *dev = &adapter->netdev->dev;
 	struct mii_bus *bus;
 
-	bus = devm_mdiobus_alloc(dev);
-	if (!bus)
-		return -ENOMEM;
-
 	switch (hw->device_id) {
 	/* C3000 SoCs */
 	case IXGBE_DEV_ID_X550EM_A_KR:
@@ -922,16 +920,23 @@ s32 ixgbe_mii_bus_init(struct ixgbe_hw *
 	case IXGBE_DEV_ID_X550EM_A_1G_T:
 	case IXGBE_DEV_ID_X550EM_A_1G_T_L:
 		if (!ixgbe_x550em_a_has_mii(hw))
-			return -ENODEV;
-		bus->read = &ixgbe_x550em_a_mii_bus_read;
-		bus->write = &ixgbe_x550em_a_mii_bus_write;
+			return 0;
+		read = &ixgbe_x550em_a_mii_bus_read;
+		write = &ixgbe_x550em_a_mii_bus_write;
 		break;
 	default:
-		bus->read = &ixgbe_mii_bus_read;
-		bus->write = &ixgbe_mii_bus_write;
+		read = &ixgbe_mii_bus_read;
+		write = &ixgbe_mii_bus_write;
 		break;
 	}
 
+	bus = devm_mdiobus_alloc(dev);
+	if (!bus)
+		return -ENOMEM;
+
+	bus->read = read;
+	bus->write = write;
+
 	/* Use the position of the device in the PCI hierarchy as the id */
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-mdio-%s", ixgbe_driver_name,
 		 pci_name(pdev));


