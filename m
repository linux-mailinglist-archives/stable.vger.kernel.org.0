Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF553CA82E
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhGOS66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:58:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241997AbhGOS6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:58:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C86A613E0;
        Thu, 15 Jul 2021 18:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375303;
        bh=SJnchJOCWq86jSivAcKUt8nRUW+Uh1jnOWnGDw2p6Uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MgVQcZlDA5QBa/VIuP/C2GCNMArMQm4gJJiQ6IDA+CRVyojRMtU9dwZHtIk/qF7ck
         518lBszxCC7++ab/4i97IBHHIlSP6Gue6CqtARPUsB/OHWfJVnAkBjgmMCw6iSJV58
         pPJepWXdN8hf9YEZLLOWYW1CIMTTs123XOn2Zrs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 031/242] e100: handle eeprom as little endian
Date:   Thu, 15 Jul 2021 20:36:33 +0200
Message-Id: <20210715182557.391036071@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

[ Upstream commit d4ef55288aa2e1b76033717242728ac98ddc4721 ]

Sparse tool was warning on some implicit conversions from
little endian data read from the EEPROM on the e100 cards.

Fix these by being explicit about the conversions using
le16_to_cpu().

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e100.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index f8d78af76d7d..1b0958bd24f6 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1395,7 +1395,7 @@ static int e100_phy_check_without_mii(struct nic *nic)
 	u8 phy_type;
 	int without_mii;
 
-	phy_type = (nic->eeprom[eeprom_phy_iface] >> 8) & 0x0f;
+	phy_type = (le16_to_cpu(nic->eeprom[eeprom_phy_iface]) >> 8) & 0x0f;
 
 	switch (phy_type) {
 	case NoSuchPhy: /* Non-MII PHY; UNTESTED! */
@@ -1515,7 +1515,7 @@ static int e100_phy_init(struct nic *nic)
 		mdio_write(netdev, nic->mii.phy_id, MII_BMCR, bmcr);
 	} else if ((nic->mac >= mac_82550_D102) || ((nic->flags & ich) &&
 	   (mdio_read(netdev, nic->mii.phy_id, MII_TPISTATUS) & 0x8000) &&
-		(nic->eeprom[eeprom_cnfg_mdix] & eeprom_mdix_enabled))) {
+	   (le16_to_cpu(nic->eeprom[eeprom_cnfg_mdix]) & eeprom_mdix_enabled))) {
 		/* enable/disable MDI/MDI-X auto-switching. */
 		mdio_write(netdev, nic->mii.phy_id, MII_NCONFIG,
 				nic->mii.force_media ? 0 : NCONFIG_AUTO_SWITCH);
@@ -2269,9 +2269,9 @@ static int e100_asf(struct nic *nic)
 {
 	/* ASF can be enabled from eeprom */
 	return (nic->pdev->device >= 0x1050) && (nic->pdev->device <= 0x1057) &&
-	   (nic->eeprom[eeprom_config_asf] & eeprom_asf) &&
-	   !(nic->eeprom[eeprom_config_asf] & eeprom_gcl) &&
-	   ((nic->eeprom[eeprom_smbus_addr] & 0xFF) != 0xFE);
+	   (le16_to_cpu(nic->eeprom[eeprom_config_asf]) & eeprom_asf) &&
+	   !(le16_to_cpu(nic->eeprom[eeprom_config_asf]) & eeprom_gcl) &&
+	   ((le16_to_cpu(nic->eeprom[eeprom_smbus_addr]) & 0xFF) != 0xFE);
 }
 
 static int e100_up(struct nic *nic)
@@ -2926,7 +2926,7 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* Wol magic packet can be enabled from eeprom */
 	if ((nic->mac >= mac_82558_D101_A4) &&
-	   (nic->eeprom[eeprom_id] & eeprom_id_wol)) {
+	   (le16_to_cpu(nic->eeprom[eeprom_id]) & eeprom_id_wol)) {
 		nic->flags |= wol_magic;
 		device_set_wakeup_enable(&pdev->dev, true);
 	}
-- 
2.30.2



