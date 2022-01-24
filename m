Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF6E49A339
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2366183AbiAXXw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845261AbiAXXLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:11:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636FCC0A02B2;
        Mon, 24 Jan 2022 13:18:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C5BDB8123A;
        Mon, 24 Jan 2022 21:18:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA99C340E4;
        Mon, 24 Jan 2022 21:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059131;
        bh=5bUKsrqF9mbHtV4XlYG05/ugAg6Jo+Sb90uYqTfChFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nop0maVa6lVucsRkAhc4uy2PU9je0gp9SaGJ3jPPcUZ41rZWiFUeScC18O+RUsKLq
         H2HNZOCSgOtuSoc2U8VMCVb5OygtO88SbrIHq79CQUb2u5+lawc0SdbJMtpdPorfWg
         HZGq0gR8Ep+ChLIsUIi+aG8l7sLSZauY280bnnHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0481/1039] PCI/MSI: Fix pci_irq_vector()/pci_irq_get_affinity()
Date:   Mon, 24 Jan 2022 19:37:50 +0100
Message-Id: <20220124184141.435262990@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index d84cf30bb2790..8465221be6d21 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1194,19 +1194,24 @@ EXPORT_SYMBOL(pci_free_irq_vectors);
 
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
@@ -1230,17 +1235,22 @@ EXPORT_SYMBOL(pci_irq_vector);
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



