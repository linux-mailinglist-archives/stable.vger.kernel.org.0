Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157B83F666C
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238439AbhHXRXg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240353AbhHXRVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04D3F61B00;
        Tue, 24 Aug 2021 17:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824607;
        bh=3zgeALVfD043P0LQIiEV+WjHRdUpDz1JhWsF+3lnyE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XvzY6t96qMFoRS8jjfJoZdk5em57wlsRVRGJzI62RO9mB3hSs//tmLpUsQ682uRDC
         Ea5gjC991RInl5jfRH0dFBn1Ty5KjmRMh6wRafhO5Dean6h86e1WRX6SzrgMtswqK5
         LFI883TABdiRn7rj73JgDIEWaMVg2X1n5VIWWg0drOrTI6G2E1NNIERbnOLnW53w2s
         608rGfGWpAYp/RUuacdR4TYkv8AAneSQ0U7PcrcE8AFK96yxmmJdRdWxa46hpI33eh
         EU0M8r4A/IV3hsW/93bFDqOjqp/YxtITkHayrNRkCHcc6UAixagSaPNMDgv4ue6y9O
         vaVqmtwcWnd/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 37/84] PCI/MSI: Enforce that MSI-X table entry is masked for update
Date:   Tue, 24 Aug 2021 13:02:03 -0400
Message-Id: <20210824170250.710392-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/pci/msi.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index d13b8b608891..5a28f7e81f0c 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -303,10 +303,25 @@ void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 		/* Don't touch the hardware now */
 	} else if (entry->msi_attrib.is_msix) {
 		void __iomem *base = pci_msix_desc_addr(entry);
+		bool unmasked = !(entry->masked & PCI_MSIX_ENTRY_CTRL_MASKBIT);
+
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
 
 		writel(msg->address_lo, base + PCI_MSIX_ENTRY_LOWER_ADDR);
 		writel(msg->address_hi, base + PCI_MSIX_ENTRY_UPPER_ADDR);
 		writel(msg->data, base + PCI_MSIX_ENTRY_DATA);
+
+		if (unmasked)
+			__pci_msix_desc_mask_irq(entry, 0);
 	} else {
 		int pos = dev->msi_cap;
 		u16 msgctl;
-- 
2.30.2

