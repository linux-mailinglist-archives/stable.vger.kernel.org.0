Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CE03ED568
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbhHPNLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:11:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:58138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239168AbhHPNJh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:09:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D23F863299;
        Mon, 16 Aug 2021 13:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119330;
        bh=TzxH1DWgvvGPvJ2rNU3zk69sjR4CrZIx2On4MRUj1TE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwX3ZGS0aViH2bAshJjN1IkL46KpwUJAwXsBpIgnS+beLol9dpOldP5AbHflwNKLG
         io30xaN7K3bBzLorB15kIoOeBRPL5aIfdNgxSEfhgD6rL7GPAvze9QItzqIbPMZKnr
         sl9JSiCg3dB3lQ8f4xax5relq/loo4nsGeFKa0WY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.10 82/96] PCI/MSI: Enforce MSI[X] entry updates to be visible
Date:   Mon, 16 Aug 2021 15:02:32 +0200
Message-Id: <20210816125437.715986793@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit b9255a7cb51754e8d2645b65dd31805e282b4f3e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -339,6 +339,9 @@ void __pci_write_msi_msg(struct msi_desc
 
 		if (unmasked)
 			__pci_msix_desc_mask_irq(entry, 0);
+
+		/* Ensure that the writes are visible in the device */
+		readl(base + PCI_MSIX_ENTRY_DATA);
 	} else {
 		int pos = dev->msi_cap;
 		u16 msgctl;
@@ -359,6 +362,8 @@ void __pci_write_msi_msg(struct msi_desc
 			pci_write_config_word(dev, pos + PCI_MSI_DATA_32,
 					      msg->data);
 		}
+		/* Ensure that the writes are visible in the device */
+		pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &msgctl);
 	}
 
 skip:


