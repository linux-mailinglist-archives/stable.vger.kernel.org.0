Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CDB498E1A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347365AbiAXTjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:39:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60258 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353129AbiAXTcx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:32:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 180136151B;
        Mon, 24 Jan 2022 19:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF9AC340E5;
        Mon, 24 Jan 2022 19:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052772;
        bh=1k00qKxoOl45JtrC5qwUDU82EQxxTUOYt/FuVoHXc9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EBO4XBby+WP+3fQ0cw/97mF13/PPVW50vbxJYKXi4Tgx8gtxOAnZAkBBAkIRD/ZMd
         VNU01rKMo4JIwHb3MCNsM3iSZcmXgLZirlM7HKPCdZ1aJuVz9bVK+UlBY4OFp+3MBP
         tIRcgCyrIpy1T4+uZgYFQ3GEWHmklvvdQcA/s8pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 136/320] PCI/MSI: Fix pci_irq_vector()/pci_irq_get_affinity()
Date:   Mon, 24 Jan 2022 19:42:00 +0100
Message-Id: <20220124183958.285126187@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 29bbc35e29d9b6347780dcacde2deb4b39344167 ]

pci_irq_vector() and pci_irq_get_affinity() use the list position to find the
MSI-X descriptor at a given index. That's correct for the normal case where
the entry number is the same as the list position.

But it's wrong for cases where MSI-X was allocated with an entries array
describing sparse entry numbers into the hardware message descriptor
table. That's inconsistent at best.

Make it always check the entry number because that's what the zero base
index really means. This change won't break existing users which use a
sparse entries array for allocation because these users retrieve the Linux
interrupt number from the entries array after allocation and none of them
uses pci_irq_vector() or pci_irq_get_affinity().

Fixes: aff171641d18 ("PCI: Provide sensible IRQ vector alloc/free routines")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lore.kernel.org/r/20211206210223.929792157@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/msi.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 7dc10c2b4785d..715c85d4e688d 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1294,19 +1294,24 @@ EXPORT_SYMBOL(pci_free_irq_vectors);
 
 /**
  * pci_irq_vector - return Linux IRQ number of a device vector
- * @dev: PCI device to operate on
- * @nr: device-relative interrupt vector index (0-based).
+ * @dev:	PCI device to operate on
+ * @nr:		Interrupt vector index (0-based)
+ *
+ * @nr has the following meanings depending on the interrupt mode:
+ *   MSI-X:	The index in the MSI-X vector table
+ *   MSI:	The index of the enabled MSI vectors
+ *   INTx:	Must be 0
+ *
+ * Return: The Linux interrupt number or -EINVAl if @nr is out of range.
  */
 int pci_irq_vector(struct pci_dev *dev, unsigned int nr)
 {
 	if (dev->msix_enabled) {
 		struct msi_desc *entry;
-		int i = 0;
 
 		for_each_pci_msi_entry(entry, dev) {
-			if (i == nr)
+			if (entry->msi_attrib.entry_nr == nr)
 				return entry->irq;
-			i++;
 		}
 		WARN_ON_ONCE(1);
 		return -EINVAL;
@@ -1330,17 +1335,22 @@ EXPORT_SYMBOL(pci_irq_vector);
  * pci_irq_get_affinity - return the affinity of a particular MSI vector
  * @dev:	PCI device to operate on
  * @nr:		device-relative interrupt vector index (0-based).
+ *
+ * @nr has the following meanings depending on the interrupt mode:
+ *   MSI-X:	The index in the MSI-X vector table
+ *   MSI:	The index of the enabled MSI vectors
+ *   INTx:	Must be 0
+ *
+ * Return: A cpumask pointer or NULL if @nr is out of range
  */
 const struct cpumask *pci_irq_get_affinity(struct pci_dev *dev, int nr)
 {
 	if (dev->msix_enabled) {
 		struct msi_desc *entry;
-		int i = 0;
 
 		for_each_pci_msi_entry(entry, dev) {
-			if (i == nr)
+			if (entry->msi_attrib.entry_nr == nr)
 				return &entry->affinity->mask;
-			i++;
 		}
 		WARN_ON_ONCE(1);
 		return NULL;
-- 
2.34.1



