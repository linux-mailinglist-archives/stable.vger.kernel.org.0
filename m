Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0312D11620F
	for <lists+stable@lfdr.de>; Sun,  8 Dec 2019 14:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfLHNym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Dec 2019 08:54:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60142 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726707AbfLHNym (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Dec 2019 08:54:42 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1C-0007dt-DR; Sun, 08 Dec 2019 13:54:38 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1idx1B-0002MZ-Ae; Sun, 08 Dec 2019 13:54:37 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Helge Deller" <deller@gmx.de>
Date:   Sun, 08 Dec 2019 13:53:11 +0000
Message-ID: <lsq.1575813165.675428564@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 27/72] parisc: Disable HP HSC-PCI Cards to prevent
 kernel crash
In-Reply-To: <lsq.1575813164.154362148@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.79-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 5fa1659105fac63e0f3c199b476025c2e04111ce upstream.

The HP Dino PCI controller chip can be used in two variants: as on-board
controller (e.g. in B160L), or on an Add-On card ("Card-Mode") to bridge
PCI components to systems without a PCI bus, e.g. to a HSC/GSC bus.  One
such Add-On card is the HP HSC-PCI Card which has one or more DEC Tulip
PCI NIC chips connected to the on-card Dino PCI controller.

Dino in Card-Mode has a big disadvantage: All PCI memory accesses need
to go through the DINO_MEM_DATA register, so Linux drivers will not be
able to use the ioremap() function. Without ioremap() many drivers will
not work, one example is the tulip driver which then simply crashes the
kernel if it tries to access the ports on the HP HSC card.

This patch disables the HP HSC card if it finds one, and as such
fixes the kernel crash on a HP D350/2 machine.

Signed-off-by: Helge Deller <deller@gmx.de>
Noticed-by: Phil Scarr <phil.scarr@pm.me>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/parisc/dino.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -160,6 +160,15 @@ struct dino_device
 	(struct dino_device *)__pdata; })
 
 
+/* Check if PCI device is behind a Card-mode Dino. */
+static int pci_dev_is_behind_card_dino(struct pci_dev *dev)
+{
+	struct dino_device *dino_dev;
+
+	dino_dev = DINO_DEV(parisc_walk_tree(dev->bus->bridge));
+	return is_card_dino(&dino_dev->hba.dev->id);
+}
+
 /*
  * Dino Configuration Space Accessor Functions
  */
@@ -442,6 +451,21 @@ static void quirk_cirrus_cardbus(struct
 }
 DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_6832, quirk_cirrus_cardbus );
 
+#ifdef CONFIG_TULIP
+static void pci_fixup_tulip(struct pci_dev *dev)
+{
+	if (!pci_dev_is_behind_card_dino(dev))
+		return;
+	if (!(pci_resource_flags(dev, 1) & IORESOURCE_MEM))
+		return;
+	pr_warn("%s: HP HSC-PCI Cards with card-mode Dino not yet supported.\n",
+		pci_name(dev));
+	/* Disable this card by zeroing the PCI resources */
+	memset(&dev->resource[0], 0, sizeof(dev->resource[0]));
+	memset(&dev->resource[1], 0, sizeof(dev->resource[1]));
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_DEC, PCI_ANY_ID, pci_fixup_tulip);
+#endif /* CONFIG_TULIP */
 
 static void __init
 dino_bios_init(void)

