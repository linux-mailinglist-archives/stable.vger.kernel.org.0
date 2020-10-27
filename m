Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE36E29B52A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793876AbgJ0PIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793872AbgJ0PIq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:08:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA18721527;
        Tue, 27 Oct 2020 15:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811325;
        bh=KO7gXtKZkEDx5G4zxXYHWLFDfcDAn1birS6e85+7YN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YiDSoYybG2xnQDZKfxmfxFlxk8mSzizLSdhHI0gv/s139JLXdfY1Gu4IICrYqlj4u
         EdD20UNQ60ghfhjuKprlCOeE+k6hidE9smd56BsUfPu0QZkkjhOYyEg0RdVPXHNp44
         gCQ9uQO8+93WKI2HCTt2JNEMBnNdKAsmV3n/jP1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jake Oshins <jakeo@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 446/633] PCI: hv: Fix hibernation in case interrupts are not re-created
Date:   Tue, 27 Oct 2020 14:53:09 +0100
Message-Id: <20201027135543.638916432@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 915cff7f38c5e4d47f187f8049245afc2cb3e503 ]

pci_restore_msi_state() directly writes the MSI/MSI-X related registers
via MMIO. On a physical machine, this works perfectly; for a Linux VM
running on a hypervisor, which typically enables IOMMU interrupt remapping,
the hypervisor usually should trap and emulate the MMIO accesses in order
to re-create the necessary interrupt remapping table entries in the IOMMU,
otherwise the interrupts can not work in the VM after hibernation.

Hyper-V is different from other hypervisors in that it does not trap and
emulate the MMIO accesses, and instead it uses a para-virtualized method,
which requires the VM to call hv_compose_msi_msg() to notify the hypervisor
of the info that would be passed to the hypervisor in the case of the
trap-and-emulate method. This is not an issue to a lot of PCI device
drivers, which destroy and re-create the interrupts across hibernation, so
hv_compose_msi_msg() is called automatically. However, some PCI device
drivers (e.g. the in-tree GPU driver nouveau and the out-of-tree Nvidia
proprietary GPU driver) do not destroy and re-create MSI/MSI-X interrupts
across hibernation, so hv_pci_resume() has to call hv_compose_msi_msg(),
otherwise the PCI device drivers can no longer receive interrupts after
the VM resumes from hibernation.

Hyper-V is also different in that chip->irq_unmask() may fail in a
Linux VM running on Hyper-V (on a physical machine, chip->irq_unmask()
can not fail because unmasking an MSI/MSI-X register just means an MMIO
write): during hibernation, when a CPU is offlined, the kernel tries
to move the interrupt to the remaining CPUs that haven't been offlined
yet. In this case, hv_irq_unmask() -> hv_do_hypercall() always fails
because the vmbus channel has been closed: here the early "return" in
hv_irq_unmask() means the pci_msi_unmask_irq() is not called, i.e. the
desc->masked remains "true", so later after hibernation, the MSI interrupt
always remains masked, which is incorrect. Refer to cpu_disable_common()
-> fixup_irqs() -> irq_migrate_all_off_this_cpu() -> migrate_one_irq():

static bool migrate_one_irq(struct irq_desc *desc)
{
...
        if (maskchip && chip->irq_mask)
                chip->irq_mask(d);
...
        err = irq_do_set_affinity(d, affinity, false);
...
        if (maskchip && chip->irq_unmask)
                chip->irq_unmask(d);

Fix the issue by calling pci_msi_unmask_irq() unconditionally in
hv_irq_unmask(). Also suppress the error message for hibernation because
the hypercall failure during hibernation does not matter (at this time
all the devices have been frozen). Note: the correct affinity info is
still updated into the irqdata data structure in migrate_one_irq() ->
irq_do_set_affinity() -> hv_set_affinity(), so later when the VM
resumes, hv_pci_restore_msi_state() is able to correctly restore
the interrupt with the correct affinity.

Link: https://lore.kernel.org/r/20201002085158.9168-1-decui@microsoft.com
Fixes: ac82fc832708 ("PCI: hv: Add hibernation support")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Jake Oshins <jakeo@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-hyperv.c | 50 +++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index bf40ff09c99d6..95c04b0ffeb16 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1275,11 +1275,25 @@ static void hv_irq_unmask(struct irq_data *data)
 exit_unlock:
 	spin_unlock_irqrestore(&hbus->retarget_msi_interrupt_lock, flags);
 
-	if (res) {
+	/*
+	 * During hibernation, when a CPU is offlined, the kernel tries
+	 * to move the interrupt to the remaining CPUs that haven't
+	 * been offlined yet. In this case, the below hv_do_hypercall()
+	 * always fails since the vmbus channel has been closed:
+	 * refer to cpu_disable_common() -> fixup_irqs() ->
+	 * irq_migrate_all_off_this_cpu() -> migrate_one_irq().
+	 *
+	 * Suppress the error message for hibernation because the failure
+	 * during hibernation does not matter (at this time all the devices
+	 * have been frozen). Note: the correct affinity info is still updated
+	 * into the irqdata data structure in migrate_one_irq() ->
+	 * irq_do_set_affinity() -> hv_set_affinity(), so later when the VM
+	 * resumes, hv_pci_restore_msi_state() is able to correctly restore
+	 * the interrupt with the correct affinity.
+	 */
+	if (res && hbus->state != hv_pcibus_removing)
 		dev_err(&hbus->hdev->device,
 			"%s() failed: %#llx", __func__, res);
-		return;
-	}
 
 	pci_msi_unmask_irq(data);
 }
@@ -3368,6 +3382,34 @@ static int hv_pci_suspend(struct hv_device *hdev)
 	return 0;
 }
 
+static int hv_pci_restore_msi_msg(struct pci_dev *pdev, void *arg)
+{
+	struct msi_desc *entry;
+	struct irq_data *irq_data;
+
+	for_each_pci_msi_entry(entry, pdev) {
+		irq_data = irq_get_irq_data(entry->irq);
+		if (WARN_ON_ONCE(!irq_data))
+			return -EINVAL;
+
+		hv_compose_msi_msg(irq_data, &entry->msg);
+	}
+
+	return 0;
+}
+
+/*
+ * Upon resume, pci_restore_msi_state() -> ... ->  __pci_write_msi_msg()
+ * directly writes the MSI/MSI-X registers via MMIO, but since Hyper-V
+ * doesn't trap and emulate the MMIO accesses, here hv_compose_msi_msg()
+ * must be used to ask Hyper-V to re-create the IOMMU Interrupt Remapping
+ * Table entries.
+ */
+static void hv_pci_restore_msi_state(struct hv_pcibus_device *hbus)
+{
+	pci_walk_bus(hbus->pci_bus, hv_pci_restore_msi_msg, NULL);
+}
+
 static int hv_pci_resume(struct hv_device *hdev)
 {
 	struct hv_pcibus_device *hbus = hv_get_drvdata(hdev);
@@ -3401,6 +3443,8 @@ static int hv_pci_resume(struct hv_device *hdev)
 
 	prepopulate_bars(hbus);
 
+	hv_pci_restore_msi_state(hbus);
+
 	hbus->state = hv_pcibus_installed;
 	return 0;
 out:
-- 
2.25.1



