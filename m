Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF8C406B8A
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhIJMc2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:32:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233266AbhIJMc1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:32:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00DF1611C0;
        Fri, 10 Sep 2021 12:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277076;
        bh=6XbSVskJsOtrKyfNt70nuqspIS65v2VYg+YO2VhC85g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtuauysLyn+2OQ8PojNgqa2/Hh0f98nIc9jNl/NAwZDcBXnaMJcDciS3UpYX7rrpI
         Tyz+g3p2H9lxll1oJsusPxC7+1LHuTspncrOEUYqPrjkkGs4RZkTDjl8nNd1AIg6If
         NmDh47DbiTLVEA4WBOTwf6Vy4lnRk9ic525zv5ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Subject: [PATCH 5.14 18/23] staging: mt7621-pci: fix hang when nothing is connected to pcie ports
Date:   Fri, 10 Sep 2021 14:30:08 +0200
Message-Id: <20210910122916.591587436@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

commit 7d761b084b3c785e1fbbe707fbdf7baba905c6ad upstream.

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
 drivers/staging/mt7621-pci/pci-mt7621.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/staging/mt7621-pci/pci-mt7621.c
+++ b/drivers/staging/mt7621-pci/pci-mt7621.c
@@ -56,6 +56,7 @@
 #define PCIE_BAR_ENABLE			BIT(0)
 #define PCIE_PORT_INT_EN(x)		BIT(20 + (x))
 #define PCIE_PORT_LINKUP		BIT(0)
+#define PCIE_PORT_CNT			3
 
 #define PERST_DELAY_MS			100
 
@@ -388,10 +389,11 @@ static void mt7621_pcie_reset_ep_deasser
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
@@ -423,6 +425,7 @@ static void mt7621_pcie_init_ports(struc
 				slot);
 			mt7621_control_assert(port);
 			port->enabled = false;
+			num_disabled++;
 
 			if (slot == 0) {
 				tmp = port;
@@ -433,6 +436,8 @@ static void mt7621_pcie_init_ports(struc
 				phy_power_off(tmp->phy);
 		}
 	}
+
+	return (num_disabled != PCIE_PORT_CNT) ? 0 : -ENODEV;
 }
 
 static void mt7621_pcie_enable_port(struct mt7621_pcie_port *port)
@@ -540,7 +545,11 @@ static int mt7621_pci_probe(struct platf
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


