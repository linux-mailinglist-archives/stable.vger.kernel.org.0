Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088033ED6AA
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbhHPNWy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238936AbhHPNUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CBBD63292;
        Mon, 16 Aug 2021 13:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119762;
        bh=0qeMRMTj109+MfWCOVSBV2M0B1pQmue50PE2amcYyYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bF4SaXNzzOHMS0mQ5PVMo5XkjvZypSt2Rb9DopIm6FWQHJrTCF5BkAWMnRqLg/BlK
         vyCS2eDub6KjU73pSK+kkarHjVKK1yvTJ+w9eerRvieYKHn77AJW4S52U2aEnC+hfu
         uWI01zUlbTPz0gy4B41Mjy5C9+6pWWrDYa30R0ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.13 131/151] PCI/MSI: Enforce MSI[X] entry updates to be visible
Date:   Mon, 16 Aug 2021 15:02:41 +0200
Message-Id: <20210816125448.372561119@linuxfoundation.org>
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
@@ -311,6 +311,9 @@ void __pci_write_msi_msg(struct msi_desc
 
 		if (unmasked)
 			__pci_msix_desc_mask_irq(entry, 0);
+
+		/* Ensure that the writes are visible in the device */
+		readl(base + PCI_MSIX_ENTRY_DATA);
 	} else {
 		int pos = dev->msi_cap;
 		u16 msgctl;
@@ -331,6 +334,8 @@ void __pci_write_msi_msg(struct msi_desc
 			pci_write_config_word(dev, pos + PCI_MSI_DATA_32,
 					      msg->data);
 		}
+		/* Ensure that the writes are visible in the device */
+		pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &msgctl);
 	}
 
 skip:


