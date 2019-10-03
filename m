Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C24ECAC94
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388095AbfJCQMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388092AbfJCQMl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:12:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A9E220700;
        Thu,  3 Oct 2019 16:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119160;
        bh=N9uKcJosbxuA8yjplpPHJhd3laP5PA0VuKho5o6Ctss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CEwDWT1zAEpfyRSliCPYjtHM77S3txNLeHAnolLPa/F4jeHyGdsZcTCRVCa6oVFXG
         qvyLb0RjEUGyCOy/5M4+8e+vkUXnynT+IFwasPHHEgPY6oL6EpBZzfWjXcIZDxP32W
         IN2BWXGXq7gXu7goQtTI2tJUq9XdgWeJvxnDLPQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>,
        Phil Scarr <phil.scarr@pm.me>
Subject: [PATCH 4.14 148/185] parisc: Disable HP HSC-PCI Cards to prevent kernel crash
Date:   Thu,  3 Oct 2019 17:53:46 +0200
Message-Id: <20191003154512.411333182@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/parisc/dino.c |   24 ++++++++++++++++++++++++
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


