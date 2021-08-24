Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B72983F6808
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbhHXRkA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:40:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:43330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242191AbhHXRhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:37:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3683B61462;
        Tue, 24 Aug 2021 17:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824871;
        bh=GBobLIMBiKvLw8XxGzKNygZ9ooAnlOciv6+QpUDMUSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X3VfNBJ6ppORmCA2NylOTLMmJcx1uR3U+DBnFnw0srdhm1imo85EscEvZkh0SL9TR
         f2gYnbZcsbmai0pA4d5laMzPFBujXN+BOKmTMyYRsnD23stualsfQbqrkOmzXiLtui
         f/S62ty/NgJ6qjbala9qC7h9IQ52xgPZO7DLot7buM00XpbEZrtkgJphQbOtGeZ0Jx
         N2wf8A+rJdzX9ZmhB3xA+QQbQuQVj0wJH6YvQDk8rSJJisjPP8FDRBQe7JKhxvADge
         uACm4NlM1xwmFGaZzvAa66PIphOE8RQxPjS4ztVsMzdA3UqUIYMkHJB0iEBjBuEcf5
         gyYNXOhU+ErAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Ashok Raj <ashok.raj@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.4 06/31] PCI/MSI: Enable and mask MSI-X early
Date:   Tue, 24 Aug 2021 13:07:18 -0400
Message-Id: <20210824170743.710957-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.282-rc1
X-KernelTest-Deadline: 2021-08-26T17:07+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/pci/msi.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 5d5e61d6c548..58bef2f6126b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -737,18 +737,25 @@ static int msix_capability_init(struct pci_dev *dev,
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
 
 	ret = msix_setup_entries(dev, base, entries, nvec);
 	if (ret)
-		return ret;
+		goto out_disable;
 
 	ret = pci_msi_setup_msi_irqs(dev, nvec, PCI_CAP_ID_MSIX);
 	if (ret)
@@ -759,14 +766,6 @@ static int msix_capability_init(struct pci_dev *dev,
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
@@ -801,6 +800,9 @@ out_avail:
 out_free:
 	free_msi_irqs(dev);
 
+out_disable:
+	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
+
 	return ret;
 }
 
-- 
2.30.2

