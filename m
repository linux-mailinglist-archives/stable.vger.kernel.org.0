Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB063F6722
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240058AbhHXRbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239384AbhHXR3E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:29:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 242BB61B73;
        Tue, 24 Aug 2021 17:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824725;
        bh=y0Dfh2Zj3ErMH/ub13MaVkbAVyc/nx6aNQZNSPEfjI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=beMTCxKb0I1/3l+sKUwQnx/HfJOqgOPnfmpk49JqPKi0NagisO9mVlATlkXxlTHhV
         NoZyYg4vSoG46taG9ZAOf7swYFqx1k1gX92GM/k4/dnR+P7Pyn5XISjJMuwNlmYOoy
         lXNztkMxZPqVAm2whjr51NgGW2dhfRy0O7uDhs4pk7fFNm7vDvVbpw77zDhStP+fzs
         pjagS4bd/0yonhj005Jq3e9Sy69kHcEWrR/ai55oBl+3ahLe/j9ir6GkPnOFNYKPgR
         Uolu6zia9rHudUEYTUZWfbzArmcURqJ2TriMJrTtDkgMQ4gKq3NMIx+Aaw5Yus1/9d
         pxeuDqlMuvCgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 28/64] PCI/MSI: Enforce MSI[X] entry updates to be visible
Date:   Tue, 24 Aug 2021 13:04:21 -0400
Message-Id: <20210824170457.710623-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
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
index 82c061269677..147369773280 100644
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

