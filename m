Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 556703ED019
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 10:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhHPIRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 04:17:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234386AbhHPIRQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 04:17:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE0B461AFB;
        Mon, 16 Aug 2021 08:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629101805;
        bh=7+k89YJAe81G1RkJqUKEz+SvjSTfm0XvGMhe++KVKgo=;
        h=Subject:To:Cc:From:Date:From;
        b=cTqp65MqShjOjVGg2hEnzqqEPMsJBtznuZOwKV5jaScklYi6CNj5nLKmNC8JglNdz
         W+gdiv7lY+6EPyrfHVo3Xwz5SvLT+dYS+03Bh9gNBrwS6JjZO5AFQctx50FtDFwf6O
         4WggpboDeD/PAKX4Mw/ZPvJiRQk+Fb2+ijKSLqNo=
Subject: FAILED: patch "[PATCH] PCI/MSI: Enforce that MSI-X table entry is masked for update" failed to apply to 4.19-stable tree
To:     tglx@linutronix.de, bhelgaas@google.com, kevin.tian@intel.com,
        maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Aug 2021 10:16:31 +0200
Message-ID: <1629101791218167@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From da181dc974ad667579baece33c2c8d2d1e4558d5 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 29 Jul 2021 23:51:42 +0200
Subject: [PATCH] PCI/MSI: Enforce that MSI-X table entry is masked for update

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

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 57c9ec9b976b..7ee1ac47caa7 100644
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

