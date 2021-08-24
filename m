Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13C83F666B
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234026AbhHXRXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:58940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240359AbhHXRVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:21:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 113A861B03;
        Tue, 24 Aug 2021 17:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824608;
        bh=zSVIcRHHMPm+VGx1kjlJy8P6Y7g4A3XzmTpZVpA4NJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqn8PP1FCXiYIdePxpYtfkPeBkBqFzuaiAxBgVQt/mugXziiWyvmiXq5LC83UgxAi
         eMEnhd9zxrTfuNloJJTvu8Kc8t97C23CJWj5nN6cgmJlS/MSQqvRAO2/Bdo+O8+aru
         yC/0adRUFrK+NIoK0dYvQL9m79vr7ihtCggrp5oFIROEJupfvFtoJyP3Oxa6PWQ8jQ
         PbfPMGhCrApDy7CiCj8nXLoBJzrhpWDHOPujs0Lwx0yoeFY9kIeXODagM5U91mlslW
         Rq+DK3Lb40KBqgea0CnTGzmYB0V3mfLWzo9BDBKIhVgm3eCpQRqcL2TpZ1T55596dP
         OtwpjZu7q7Hcw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 38/84] PCI/MSI: Enforce MSI[X] entry updates to be visible
Date:   Tue, 24 Aug 2021 13:02:04 -0400
Message-Id: <20210824170250.710392-39-sashal@kernel.org>
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
 drivers/pci/msi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 5a28f7e81f0c..bc80b0f0ea1b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -322,6 +322,9 @@ void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 
 		if (unmasked)
 			__pci_msix_desc_mask_irq(entry, 0);
+
+		/* Ensure that the writes are visible in the device */
+		readl(base + PCI_MSIX_ENTRY_DATA);
 	} else {
 		int pos = dev->msi_cap;
 		u16 msgctl;
@@ -342,6 +345,8 @@ void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
 			pci_write_config_word(dev, pos + PCI_MSI_DATA_32,
 					      msg->data);
 		}
+		/* Ensure that the writes are visible in the device */
+		pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &msgctl);
 	}
 	entry->msg = *msg;
 }
-- 
2.30.2

