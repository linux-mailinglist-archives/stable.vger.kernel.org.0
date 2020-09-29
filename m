Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7B627C555
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgI2LeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729570AbgI2Ld0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:33:26 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89F6923B6E;
        Tue, 29 Sep 2020 11:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378784;
        bh=M812ncXiMobqs0Wk1lrPAxM6jHeAbMA0fdxvXm26QBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUQALZR6Hgjw5up9+6n75ruKp3+TSGNgafWjcWrW9NpFcYylqN/cFcjOr4dQc51Db
         4pvEniVsqexR0UpyMvAj/KDPHUmXZ94UVQLN1I4LVmaRKxBzkudxiGlehZ6FR+LXAp
         icNzrw6ehCNm5ZLjULX9bHrYkkcErg3uwphq8jv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stuart Hayes <stuart.w.hayes@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 136/245] PCI: pciehp: Fix MSI interrupt race
Date:   Tue, 29 Sep 2020 12:59:47 +0200
Message-Id: <20200929105953.606272899@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stuart Hayes <stuart.w.hayes@gmail.com>

[ Upstream commit 8edf5332c39340b9583cf9cba659eb7ec71f75b5 ]

Without this commit, a PCIe hotplug port can stop generating interrupts on
hotplug events, so device adds and removals will not be seen:

The pciehp interrupt handler pciehp_isr() reads the Slot Status register
and then writes back to it to clear the bits that caused the interrupt.  If
a different interrupt event bit gets set between the read and the write,
pciehp_isr() returns without having cleared all of the interrupt event
bits.  If this happens when the MSI isn't masked (which by default it isn't
in handle_edge_irq(), and which it will never be when MSI per-vector
masking is not supported), we won't get any more hotplug interrupts from
that device.

That is expected behavior, according to the PCIe Base Spec r5.0, section
6.7.3.4, "Software Notification of Hot-Plug Events".

Because the Presence Detect Changed and Data Link Layer State Changed event
bits can both get set at nearly the same time when a device is added or
removed, this is more likely to happen than it might seem.  The issue was
found (and can be reproduced rather easily) by connecting and disconnecting
an NVMe storage device on at least one system model where the NVMe devices
were being connected to an AMD PCIe port (PCI device 0x1022/0x1483).

Fix the issue by modifying pciehp_isr() to loop back and re-read the Slot
Status register immediately after writing to it, until it sees that all of
the event status bits have been cleared.

[lukas: drop loop count limitation, write "events" instead of "status",
don't loop back in INTx and poll modes, tweak code comment & commit msg]
Link: https://lore.kernel.org/r/78b4ced5072bfe6e369d20e8b47c279b8c7af12e.1582121613.git.lukas@wunner.de
Tested-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 07940d1d83b70..005817e40ad39 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -530,7 +530,7 @@ static irqreturn_t pciehp_isr(int irq, void *dev_id)
 	struct controller *ctrl = (struct controller *)dev_id;
 	struct pci_dev *pdev = ctrl_dev(ctrl);
 	struct device *parent = pdev->dev.parent;
-	u16 status, events;
+	u16 status, events = 0;
 
 	/*
 	 * Interrupts only occur in D3hot or shallower (PCIe r4.0, sec 6.7.3.4).
@@ -553,6 +553,7 @@ static irqreturn_t pciehp_isr(int irq, void *dev_id)
 		}
 	}
 
+read_status:
 	pcie_capability_read_word(pdev, PCI_EXP_SLTSTA, &status);
 	if (status == (u16) ~0) {
 		ctrl_info(ctrl, "%s: no response from device\n", __func__);
@@ -565,24 +566,37 @@ static irqreturn_t pciehp_isr(int irq, void *dev_id)
 	 * Slot Status contains plain status bits as well as event
 	 * notification bits; right now we only want the event bits.
 	 */
-	events = status & (PCI_EXP_SLTSTA_ABP | PCI_EXP_SLTSTA_PFD |
-			   PCI_EXP_SLTSTA_PDC | PCI_EXP_SLTSTA_CC |
-			   PCI_EXP_SLTSTA_DLLSC);
+	status &= PCI_EXP_SLTSTA_ABP | PCI_EXP_SLTSTA_PFD |
+		  PCI_EXP_SLTSTA_PDC | PCI_EXP_SLTSTA_CC |
+		  PCI_EXP_SLTSTA_DLLSC;
 
 	/*
 	 * If we've already reported a power fault, don't report it again
 	 * until we've done something to handle it.
 	 */
 	if (ctrl->power_fault_detected)
-		events &= ~PCI_EXP_SLTSTA_PFD;
+		status &= ~PCI_EXP_SLTSTA_PFD;
 
+	events |= status;
 	if (!events) {
 		if (parent)
 			pm_runtime_put(parent);
 		return IRQ_NONE;
 	}
 
-	pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, events);
+	if (status) {
+		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA, events);
+
+		/*
+		 * In MSI mode, all event bits must be zero before the port
+		 * will send a new interrupt (PCIe Base Spec r5.0 sec 6.7.3.4).
+		 * So re-read the Slot Status register in case a bit was set
+		 * between read and write.
+		 */
+		if (pci_dev_msi_enabled(pdev) && !pciehp_poll_mode)
+			goto read_status;
+	}
+
 	ctrl_dbg(ctrl, "pending interrupts %#06x from Slot Status\n", events);
 	if (parent)
 		pm_runtime_put(parent);
-- 
2.25.1



