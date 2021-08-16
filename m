Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7143ED4E6
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237897AbhHPNGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:06:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237376AbhHPNFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:05:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 738FD63299;
        Mon, 16 Aug 2021 13:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119110;
        bh=A/L6lReSe9Kr57cUKqMlFI4NgjsekDBMVhpBlvJZrak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VNSUGXL0Vfvygxidiq0xj7+LD41xwgEWm80CU68W8lt/TwCzTQnaD/od3U25xJDop
         H4tW8Se107ZBy23Cu7BzEc4Z2V6x2EhFsKpr5oUNQjSA8EskSuo2xwMzChXbs0dpYZ
         mq2U9t+OQ8b3i/BFCzT/GX/zIKymTB/yaDgttaw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 49/62] PCI/MSI: Enable and mask MSI-X early
Date:   Mon, 16 Aug 2021 15:02:21 +0200
Message-Id: <20210816125429.897761686@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 438553958ba19296663c6d6583d208dfb6792830 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -778,18 +778,25 @@ static int msix_capability_init(struct p
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
@@ -800,14 +807,6 @@ static int msix_capability_init(struct p
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
@@ -842,6 +841,9 @@ out_avail:
 out_free:
 	free_msi_irqs(dev);
 
+out_disable:
+	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
+
 	return ret;
 }
 


