Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E38F73D61EA
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:14:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbhGZPdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233422AbhGZPcU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:32:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18F7160F9C;
        Mon, 26 Jul 2021 16:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315946;
        bh=Ii8LnCa5sN0LO9PTwHbCS+/OIokhAugVaiwqj/o/Utc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puDtQORjxR7Ap1mrnKY2tZug2RrrTrNc2jOaOR81EDMmwJxXoP8TMD281bbyH+fel
         LXpebXX6vXvOFZiFUWo/rsXMI/YS1PT+2uyDbX15gTOTo1SjqqmleTPEaqh80dqncD
         6o2GbLcZRH8Az8CVeVkBmOWRpx+xhhR4OftWwG9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sayanta Pattanayak <sayanta.pattanayak@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 128/223] r8169: Avoid duplicate sysfs entry creation error
Date:   Mon, 26 Jul 2021 17:38:40 +0200
Message-Id: <20210726153850.442834988@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sayanta Pattanayak <sayanta.pattanayak@arm.com>

[ Upstream commit e9a72f874d5b95cef0765bafc56005a50f72c5fe ]

When registering the MDIO bus for a r8169 device, we use the PCI
bus/device specifier as a (seemingly) unique device identifier.
However the very same BDF number can be used on another PCI segment,
which makes the driver fail probing:

[ 27.544136] r8169 0002:07:00.0: enabling device (0000 -> 0003)
[ 27.559734] sysfs: cannot create duplicate filename '/class/mdio_bus/r8169-700'
....
[ 27.684858] libphy: mii_bus r8169-700 failed to register
[ 27.695602] r8169: probe of 0002:07:00.0 failed with error -22

Add the segment number to the device name to make it more unique.

This fixes operation on ARM N1SDP boards, with two boards connected
together to form an SMP system, and all on-board devices showing up
twice, just on different PCI segments. A similar issue would occur on
large systems with many PCI slots and multiple RTL8169 NICs.

Fixes: f1e911d5d0dfd ("r8169: add basic phylib support")
Signed-off-by: Sayanta Pattanayak <sayanta.pattanayak@arm.com>
[Andre: expand commit message, use pci_domain_nr()]
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a0d4e052a79e..b8eb1b2a8de3 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5085,7 +5085,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->priv = tp;
 	new_bus->parent = &pdev->dev;
 	new_bus->irq[0] = PHY_MAC_INTERRUPT;
-	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x", pci_dev_id(pdev));
+	snprintf(new_bus->id, MII_BUS_ID_SIZE, "r8169-%x-%x",
+		 pci_domain_nr(pdev->bus), pci_dev_id(pdev));
 
 	new_bus->read = r8169_mdio_read_reg;
 	new_bus->write = r8169_mdio_write_reg;
-- 
2.30.2



