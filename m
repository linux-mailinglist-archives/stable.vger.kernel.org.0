Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2D13ED01A
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 10:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbhHPIR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 04:17:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:43850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234386AbhHPIR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 04:17:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5A7061AFD;
        Mon, 16 Aug 2021 08:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629101816;
        bh=UJiWLkm6uAtavPtv5l5nVwBRjYuv4WEwZ1reEdSw7Tk=;
        h=Subject:To:Cc:From:Date:From;
        b=r7ysVv1HTmf2aeOd+zWRK661qPLwZFMVphqoZyxADlgRlfWMkOxeZFbfH2qVafckB
         6pffjc5U66mkqgCXWU18YnT4bYbjS48fr0toH7s93hEnxUujGcMGBj39jpQHp3uRss
         tsFKq280CWl4rHKnrnsHzJsnDmxe3UF4FUQOxXPE=
Subject: FAILED: patch "[PATCH] PCI/MSI: Enforce MSI[X] entry updates to be visible" failed to apply to 4.4-stable tree
To:     tglx@linutronix.de, bhelgaas@google.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Aug 2021 10:16:54 +0200
Message-ID: <1629101814187179@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b9255a7cb51754e8d2645b65dd31805e282b4f3e Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 29 Jul 2021 23:51:43 +0200
Subject: [PATCH] PCI/MSI: Enforce MSI[X] entry updates to be visible

Nothing enforces the posted writes to be visible when the function
returns. Flush them even if the flush might be redundant when the entry is
masked already as the unmask will flush as well. This is either setup or a
rare affinity change event so the extra flush is not the end of the world.

While this is more a theoretical issue especially the logic in the X86
specific msi_set_affinity() function relies on the assumption that the
update has reached the hardware when the function returns.

Again, as this never has been enforced the Fixes tag refers to a commit in:
   git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git

Fixes: f036d4ea5fa7 ("[PATCH] ia32 Message Signalled Interrupt support")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.515188147@linutronix.de

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 7ee1ac47caa7..434c7041b176 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -311,6 +311,9 @@ void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 
 		if (unmasked)
 			__pci_msix_desc_mask_irq(entry, 0);
+
+		/* Ensure that the writes are visible in the device */
+		readl(base + PCI_MSIX_ENTRY_DATA);
 	} else {
 		int pos = dev->msi_cap;
 		u16 msgctl;
@@ -331,6 +334,8 @@ void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 			pci_write_config_word(dev, pos + PCI_MSI_DATA_32,
 					      msg->data);
 		}
+		/* Ensure that the writes are visible in the device */
+		pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &msgctl);
 	}
 
 skip:

