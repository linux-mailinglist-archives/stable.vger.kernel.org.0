Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2C23ED6A2
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239121AbhHPNWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:44512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236446AbhHPNU0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D4CD632DF;
        Mon, 16 Aug 2021 13:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119750;
        bh=08Z0j4YwUq7WKBbHPu89XF/1RdcVco30sj2j34qTxm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=brhghrkQ7NfgxpAiqtkhVEFcnjKP/+/jE6PPPvVZWiKMKxEVtUY9R7iriZh3HDP1r
         SDgGs2xwzU3Q53F1jKNtf+65C2wUnCQRNkkpZ4kznNuOKz6zfAhqJ08bJAFDR/92lj
         toGhs1GXGzpCLj+UjFHozf2tpSG1THdO2ALvqwAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.13 130/151] PCI/MSI: Enforce that MSI-X table entry is masked for update
Date:   Mon, 16 Aug 2021 15:02:40 +0200
Message-Id: <20210816125448.342829446@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit da181dc974ad667579baece33c2c8d2d1e4558d5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -289,13 +289,28 @@ void __pci_write_msi_msg(struct msi_desc
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


