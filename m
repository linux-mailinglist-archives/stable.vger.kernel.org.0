Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7095E3E564B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238671AbhHJJIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238631AbhHJJIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 05:08:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94443C06179A;
        Tue, 10 Aug 2021 02:07:47 -0700 (PDT)
Date:   Tue, 10 Aug 2021 09:07:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628586465;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xX/NCSmxyElbptOS0w+J2K87NhD3Lkt6/NLFu/5B8ck=;
        b=C9Kh3QaUEbLVOJ4v/XvpZlo6N/c0sW499U611mbkXrmbgQcyn/i4BIvimZJwrOFM9GGSgf
        ARt8lBSPZJcx5zadiA64i5et/EodMgCMyA4XWrCLNYLIeGmRz/T0I5I8zSaMD+Hlgpe6Y1
        sG8T6gKXHuz/Plv6+VS/fVAB72I6m2de1a9678IUuA8vNsJ5kYIvXkDeRvbVXZL+7iLsvR
        BBlwHTy0nUHQjCiORB3kJf+oOdQHIt4kkX//FbAwCM164Rd62mCAFgDqTYa7KPV5H24uUA
        +lUbNmPpS7x/0fgLkllC3PJROLaqq+gHl+2JatXwDVO6U0qM1K/mUQNlJfeg1w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628586465;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xX/NCSmxyElbptOS0w+J2K87NhD3Lkt6/NLFu/5B8ck=;
        b=FCufemM+CVU8oaxrYj2kibkf6iux+LaDrszUIgCFwoIYcLqZDf9srMgu25ccYmbDcvVras
        n3A4nSjR+dSIQWAA==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] PCI/MSI: Correct misleading comments
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210729222542.621609423@linutronix.de>
References: <20210729222542.621609423@linutronix.de>
MIME-Version: 1.0
Message-ID: <162858646494.395.8026075064137990012.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     689e6b5351573c38ccf92a0dd8b3e2c2241e4aff
Gitweb:        https://git.kernel.org/tip/689e6b5351573c38ccf92a0dd8b3e2c2241e4aff
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 29 Jul 2021 23:51:45 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 10 Aug 2021 10:59:20 +02:00

PCI/MSI: Correct misleading comments

The comments about preserving the cached state in pci_msi[x]_shutdown() are
misleading as the MSI descriptors are freed right after those functions
return. So there is nothing to restore. Preparatory change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.621609423@linutronix.de

---
 drivers/pci/msi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index e27ac6b..b3f5807 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -961,7 +961,6 @@ static void pci_msi_shutdown(struct pci_dev *dev)
 
 	/* Return the device with MSI unmasked as initial states */
 	mask = msi_mask(desc->msi_attrib.multi_cap);
-	/* Keep cached state to be restored */
 	__pci_msi_desc_mask_irq(desc, mask, 0);
 
 	/* Restore dev->irq to its default pin-assertion IRQ */
@@ -1047,10 +1046,8 @@ static void pci_msix_shutdown(struct pci_dev *dev)
 	}
 
 	/* Return the device with MSI-X masked as initial states */
-	for_each_pci_msi_entry(entry, dev) {
-		/* Keep cached states to be restored */
+	for_each_pci_msi_entry(entry, dev)
 		__pci_msix_desc_mask_irq(entry, 1);
-	}
 
 	pci_msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_ENABLE, 0);
 	pci_intx_for_msi(dev, 1);
