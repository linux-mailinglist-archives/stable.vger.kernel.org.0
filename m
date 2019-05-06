Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 743D714F50
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:09:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfEFOfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:35:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726861AbfEFOfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:35:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F2E420B7C;
        Mon,  6 May 2019 14:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153311;
        bh=c+RirpKRmLCnZH63iU9x2IOb/hAAViXjJzoHg5qZteY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlrMpal9DPgHra3yfujVCv0NbQFO7c6HaKp6yaTj0IVPzrn0Hh3fZROwbPzjDgH0U
         fWwqtClCqmaoXA51KRpaCx3GBAr9TYozQxq/tjrQv71ir8yVkTt4NA1Ts9dq0SVymk
         aHZYK20yDyff/Wm9Vat3Vw2x6a0+7qtvB9yHLNp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Vecera <ivecera@redhat.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 041/122] ixgbe: fix mdio bus registration
Date:   Mon,  6 May 2019 16:31:39 +0200
Message-Id: <20190506143058.606057843@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7ec52b9df7d7472240fa96223185894b1897aeb0 ]

The ixgbe ignores errors returned from mdiobus_register() and leaves
adapter->mii_bus non-NULL and MDIO bus state as MDIOBUS_ALLOCATED.
This triggers a BUG from mdiobus_unregister() during ixgbe_remove() call.

Fixes: 8fa10ef01260 ("ixgbe: register a mdiobus")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
index cc4907f9ff02..2fb97967961c 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_phy.c
@@ -905,13 +905,12 @@ s32 ixgbe_mii_bus_init(struct ixgbe_hw *hw)
 	struct pci_dev *pdev = adapter->pdev;
 	struct device *dev = &adapter->netdev->dev;
 	struct mii_bus *bus;
+	int err = -ENODEV;
 
-	adapter->mii_bus = devm_mdiobus_alloc(dev);
-	if (!adapter->mii_bus)
+	bus = devm_mdiobus_alloc(dev);
+	if (!bus)
 		return -ENOMEM;
 
-	bus = adapter->mii_bus;
-
 	switch (hw->device_id) {
 	/* C3000 SoCs */
 	case IXGBE_DEV_ID_X550EM_A_KR:
@@ -949,12 +948,15 @@ s32 ixgbe_mii_bus_init(struct ixgbe_hw *hw)
 	 */
 	hw->phy.mdio.mode_support = MDIO_SUPPORTS_C45 | MDIO_SUPPORTS_C22;
 
-	return mdiobus_register(bus);
+	err = mdiobus_register(bus);
+	if (!err) {
+		adapter->mii_bus = bus;
+		return 0;
+	}
 
 ixgbe_no_mii_bus:
 	devm_mdiobus_free(dev, bus);
-	adapter->mii_bus = NULL;
-	return -ENODEV;
+	return err;
 }
 
 /**
-- 
2.20.1



