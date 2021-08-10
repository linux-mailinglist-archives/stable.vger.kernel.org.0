Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E6E3E565C
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbhHJJI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238659AbhHJJIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 05:08:12 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7A8C061799;
        Tue, 10 Aug 2021 02:07:50 -0700 (PDT)
Date:   Tue, 10 Aug 2021 09:07:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628586468;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oNVHi/Mj3IoGqjXax8q9v2Mo/4dcGgd2i9RorAjZbE4=;
        b=QPQGnqDFHUiT18K6fFa1U8WQ1AOvPXOgN6dAWK1HFjQzkrmSTIuYre8dc3DNVsB4TNauwp
        bfKtCDvP2A49oIY8BXQkqU41BXqDNMw18UZMNbD6LnrDBpYJ0cq1V/jAfWs0ZCaLom2/3p
        WmjiVAm0B27NPAMdwp0BP+HaPCxRp9JtpGmY6VO0oHRnR6mLaADZg9APnXLRBwMC4x1cQN
        8OCsASIEIkBmVhilGs5UcSw+e2hNYI+a/IWwuNT0mdYWJgvcmG+vf0LaQW1GN797ZuGyT8
        W9D6/QDWStgyrx/hl6c4TtdmVBQCxY3HHZYSdC8bMIAcGqAYvlAN87oB1Wya2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628586468;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oNVHi/Mj3IoGqjXax8q9v2Mo/4dcGgd2i9RorAjZbE4=;
        b=/K0+iqCQsBM1QWRjNb4N4L0wM6pCarLHjyzR8skT8kIRX236kQOWOk9OGQVMtZutTAl1+L
        rBzLqzzkwsDlLKCQ==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] PCI/MSI: Enable and mask MSI-X early
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210729222542.344136412@linutronix.de>
References: <20210729222542.344136412@linutronix.de>
MIME-Version: 1.0
Message-ID: <162858646777.395.4058447464180026703.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     438553958ba19296663c6d6583d208dfb6792830
Gitweb:        https://git.kernel.org/tip/438553958ba19296663c6d6583d208dfb6792830
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 29 Jul 2021 23:51:40 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 10 Aug 2021 10:59:20 +02:00

PCI/MSI: Enable and mask MSI-X early

The ordering of MSI-X enable in hardware is dysfunctional:

 1) MSI-X is disabled in the control register
 2) Various setup functions
 3) pci_msi_setup_msi_irqs() is invoked which ends up accessing
    the MSI-X table entries
 4) MSI-X is enabled and masked in the control register with the
    comment that enabling is required for some hardware to access
    the MSI-X table

Step #4 obviously contradicts #3. The history of this is an issue with the
NIU hardware. When #4 was introduced the table access actually happened in
msix_program_entries() which was invoked after enabling and masking MSI-X.

This was changed in commit d71d6432e105 ("PCI/MSI: Kill redundant call of
irq_set_msi_desc() for MSI-X interrupts") which removed the table write
from msix_program_entries().

Interestingly enough nobody noticed and either NIU still works or it did
not get any testing with a kernel 3.19 or later.

Nevertheless this is inconsistent and there is no reason why MSI-X can't be
enabled and masked in the control register early on, i.e. move step #4
above to step #1. This preserves the NIU workaround and has no side effects
on other hardware.

Fixes: d71d6432e105 ("PCI/MSI: Kill redundant call of irq_set_msi_desc() for MSI-X interrupts")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Ashok Raj <ashok.raj@intel.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.344136412@linutronix.de

---
 drivers/pci/msi.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 9232255..5d39ed8 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -772,18 +772,25 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	u16 control;
 	void __iomem *base;
 
-	/* Ensure MSI-X is disabled while it is set up */
-	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
+	/*
+	 * Some devices require MSI-X to be enabled before the MSI-X
+	 * registers can be accessed.  Mask all the vectors to prevent
+	 * interrupts coming in before they're fully set up.
+	 */
+	pci_msix_clear_and_set_ctrl(dev, 0, PCI_MSIX_FLAGS_MASKALL |
+				    PCI_MSIX_FLAGS_ENABLE);
 
 	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
 	/* Request & Map MSI-X table region */
 	base = msix_map_region(dev, msix_table_size(control));
-	if (!base)
-		return -ENOMEM;
+	if (!base) {
+		ret = -ENOMEM;
+		goto out_disable;
+	}
 
 	ret = msix_setup_entries(dev, base, entries, nvec, affd);
 	if (ret)
-		return ret;
+		goto out_disable;
 
 	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
@@ -794,14 +801,6 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	if (ret)
 		goto out_free;
 
-	/*
-	 * Some devices require MSI-X to be enabled before we can touch the
-	 * MSI-X registers.  We need to mask all the vectors to prevent
-	 * interrupts coming in before they're fully set up.
-	 */
-	pci_msix_clear_and_set_ctrl(dev, 0,
-				PCI_MSIX_FLAGS_MASKALL | PCI_MSIX_FLAGS_ENABLE);
-
 	msix_program_entries(dev, entries);
 
 	ret = populate_msi_sysfs(dev);
@@ -836,6 +835,9 @@ out_avail:
 out_free:
 	free_msi_irqs(dev);
 
+out_disable:
+	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
+
 	return ret;
 }
 
