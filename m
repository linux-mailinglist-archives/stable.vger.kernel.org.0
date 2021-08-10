Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A383E5657
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 11:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238648AbhHJJIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 05:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238669AbhHJJIN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 05:08:13 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F209C06179E;
        Tue, 10 Aug 2021 02:07:51 -0700 (PDT)
Date:   Tue, 10 Aug 2021 09:07:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628586467;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9B2iJKY5UsIzUVkXaV2I1KSfhPQiX5qoXudaB1Q/Ek=;
        b=aG+Jnsgw4RNSqdcJ98bm6dzIXkoK8+2Qz0jXnidXQRhFCh9cqdUUkUQNIR4mWslyJSOthG
        YxZIv7cDHwX4CHWBju7awyzBvBY2Ks9510oRH1ETGmRpJqA1HPKHS++Cs+KPX7N86w/9cB
        knDD6K1Dn/Oq7EEqSuaEsMvqS5+5YG5iME2nrtNQxWvit/3CWM0yhos/rMVBsZ+hIhhyjQ
        0kpyKamMNK10FREGMV5aUmdGt6ega0EckR06tto5JtYKZx8qrcaEdzTwPBT2COSXium8JU
        mo3kk6Z/unljnrqJNsmLn1jVwUJO3kHjMkJIDaSDjIM1rGA2D8bLZBzLfDPi2w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628586467;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v9B2iJKY5UsIzUVkXaV2I1KSfhPQiX5qoXudaB1Q/Ek=;
        b=CYpbpnjMEj/PPUKKau3ZAvnZSSE/vmx0ljffk2GBFWniiH3xOPTAK2nYTV+ZsjMmwVeY4W
        GbWTDPOFAv83i1Bw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/core] PCI/MSI: Enforce that MSI-X table entry is masked for update
Cc:     Kevin Tian <kevin.tian@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210729222542.462096385@linutronix.de>
References: <20210729222542.462096385@linutronix.de>
MIME-Version: 1.0
Message-ID: <162858646659.395.16228332078065850367.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/core branch of tip:

Commit-ID:     da181dc974ad667579baece33c2c8d2d1e4558d5
Gitweb:        https://git.kernel.org/tip/da181dc974ad667579baece33c2c8d2d1e4558d5
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 29 Jul 2021 23:51:42 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 10 Aug 2021 10:59:20 +02:00

PCI/MSI: Enforce that MSI-X table entry is masked for update

The specification (PCIe r5.0, sec 6.1.4.5) states:

    For MSI-X, a function is permitted to cache Address and Data values
    from unmasked MSI-X Table entries. However, anytime software unmasks a
    currently masked MSI-X Table entry either by clearing its Mask bit or
    by clearing the Function Mask bit, the function must update any Address
    or Data values that it cached from that entry. If software changes the
    Address or Data value of an entry while the entry is unmasked, the
    result is undefined.

The Linux kernel's MSI-X support never enforced that the entry is masked
before the entry is modified hence the Fixes tag refers to a commit in:
      git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git

Enforce the entry to be masked across the update.

There is no point in enforcing this to be handled at all possible call
sites as this is just pointless code duplication and the common update
function is the obvious place to enforce this.

Fixes: f036d4ea5fa7 ("[PATCH] ia32 Message Signalled Interrupt support")
Reported-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.462096385@linutronix.de

---
 drivers/pci/msi.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 57c9ec9..7ee1ac4 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -289,13 +289,28 @@ void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 		/* Don't touch the hardware now */
 	} else if (entry->msi_attrib.is_msix) {
 		void __iomem *base = pci_msix_desc_addr(entry);
+		bool unmasked = !(entry->masked & PCI_MSIX_ENTRY_CTRL_MASKBIT);
 
 		if (!base)
 			goto skip;
 
+		/*
+		 * The specification mandates that the entry is masked
+		 * when the message is modified:
+		 *
+		 * "If software changes the Address or Data value of an
+		 * entry while the entry is unmasked, the result is
+		 * undefined."
+		 */
+		if (unmasked)
+			__pci_msix_desc_mask_irq(entry, PCI_MSIX_ENTRY_CTRL_MASKBIT);
+
 		writel(msg->address_lo, base + PCI_MSIX_ENTRY_LOWER_ADDR);
 		writel(msg->address_hi, base + PCI_MSIX_ENTRY_UPPER_ADDR);
 		writel(msg->data, base + PCI_MSIX_ENTRY_DATA);
+
+		if (unmasked)
+			__pci_msix_desc_mask_irq(entry, 0);
 	} else {
 		int pos = dev->msi_cap;
 		u16 msgctl;
