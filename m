Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE3143F954B
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 09:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244477AbhH0HoM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 03:44:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244476AbhH0HoM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Aug 2021 03:44:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F158B60F92;
        Fri, 27 Aug 2021 07:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630050203;
        bh=g4HV8KLvciKDFRaIaNDH/63+UHIK163HGtHFxtoK8SU=;
        h=Subject:To:From:Date:From;
        b=2MN84OUUjvQ60g7hT62yFJ13roKDC/GgHR4U8WGNNg5nJwkmejeXmdzgsU0lJyIlm
         +ix7mmeO+pfbfD+LDDJfNLa3dX3OC82rSz96fPDcqIDVMelqUnX4JO/f87jsjBBmRb
         T4GJ9pPt0xFiYVS8cHDx7C8J66Q3evvbzi0AbAss=
Subject: patch "staging: mt7621-pci: fix hang when nothing is connected to pcie ports" added to staging-next
To:     sergio.paracuellos@gmail.com, dqfext@gmail.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 27 Aug 2021 09:39:56 +0200
Message-ID: <163004999636211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: mt7621-pci: fix hang when nothing is connected to pcie ports

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 7d761b084b3c785e1fbbe707fbdf7baba905c6ad Mon Sep 17 00:00:00 2001
From: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date: Mon, 23 Aug 2021 19:08:03 +0200
Subject: staging: mt7621-pci: fix hang when nothing is connected to pcie ports

When nothing is connected to pcie ports, each port is set to reset state.
When this occurs, next access result in a hang on boot as follows:

mt7621-pci 1e140000.pcie: pcie0 no card, disable it (RST & CLK)
mt7621-pci 1e140000.pcie: pcie1 no card, disable it (RST & CLK)
mt7621-pci 1e140000.pcie: pcie2 no card, disable it (RST & CLK)
[ HANGS HERE ]

Fix this just detecting 'nothing is connected state' to avoid next accesses
to pcie port related configuration registers.

Fixes: b99cc3a2b6b6 ("staging: mt7621-pci: avoid custom 'map_irq' function")
Cc: stable <stable@vger.kernel.org>
Reported-by: DENG Qingfang <dqfext@gmail.com>
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20210823170803.2108-1-sergio.paracuellos@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/mt7621-pci/pci-mt7621.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/mt7621-pci/pci-mt7621.c b/drivers/staging/mt7621-pci/pci-mt7621.c
index f9bdf4e33134..6acfc94a16e7 100644
--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -56,6 +56,7 @@
 #define PCIE_BAR_ENABLE			BIT(0)
 #define PCIE_PORT_INT_EN(x)		BIT(20 + (x))
 #define PCIE_PORT_LINKUP		BIT(0)
+#define PCIE_PORT_CNT			3
 
 #define PERST_DELAY_MS			100
 
@@ -388,10 +389,11 @@ static void mt7621_pcie_reset_ep_deassert(struct mt7621_pcie *pcie)
 	msleep(PERST_DELAY_MS);
 }
 
-static void mt7621_pcie_init_ports(struct mt7621_pcie *pcie)
+static int mt7621_pcie_init_ports(struct mt7621_pcie *pcie)
 {
 	struct device *dev = pcie->dev;
 	struct mt7621_pcie_port *port, *tmp;
+	u8 num_disabled = 0;
 	int err;
 
 	mt7621_pcie_reset_assert(pcie);
@@ -423,6 +425,7 @@ static void mt7621_pcie_init_ports(struct mt7621_pcie *pcie)
 				slot);
 			mt7621_control_assert(port);
 			port->enabled = false;
+			num_disabled++;
 
 			if (slot == 0) {
 				tmp = port;
@@ -433,6 +436,8 @@ static void mt7621_pcie_init_ports(struct mt7621_pcie *pcie)
 				phy_power_off(tmp->phy);
 		}
 	}
+
+	return (num_disabled != PCIE_PORT_CNT) ? 0 : -ENODEV;
 }
 
 static void mt7621_pcie_enable_port(struct mt7621_pcie_port *port)
@@ -540,7 +545,11 @@ static int mt7621_pci_probe(struct platform_device *pdev)
 		return err;
 	}
 
-	mt7621_pcie_init_ports(pcie);
+	err = mt7621_pcie_init_ports(pcie);
+	if (err) {
+		dev_err(dev, "Nothing connected in virtual bridges\n");
+		return 0;
+	}
 
 	err = mt7621_pcie_enable_ports(bridge);
 	if (err) {
-- 
2.32.0


