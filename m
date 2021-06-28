Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A393B62CE
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbhF1Otd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235658AbhF1Op3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:45:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11869619BE;
        Mon, 28 Jun 2021 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890845;
        bh=WjgCILrYVZQRlJSH1hia5ASauC1FUe3v2EK4Eld3wz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAH0ui145yhLR7M1rQsr87GLOwTBMR8+2WoVmwq6HSU5Ez9vWf+bb7adhwexhLRUN
         ebQNsWEjNZoJUPGhyZ+vcSO3Hxxguvu2uEq7ZHYk27+TSZYjf5BgQKKDH69q7O9KXu
         7h/MM7z+5k7o7iAhJ9rMxCs7yIj/1cIfhr9s7oOqIx+v0GgT8KDwAxEXCUcsFDonTz
         PaecM6jk4BDAMNrN/0p14/RavU/AdPRCNk9Pl4gsmUGxtCYZ0qAPQ1Z2YMGjtQOxRX
         Jb+HftEVTMhe+CctZeVBngZ7VaXL0szkSAC19HDd3qdOopR0H+htdKoE43nmOsy8Ze
         8BEmoBQvS8TkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chiqijun <chiqijun@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 067/109] PCI: Work around Huawei Intelligent NIC VF FLR erratum
Date:   Mon, 28 Jun 2021 10:32:23 -0400
Message-Id: <20210628143305.32978-68-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chiqijun <chiqijun@huawei.com>

commit ce00322c2365e1f7b0312f2f493539c833465d97 upstream.

pcie_flr() starts a Function Level Reset (FLR), waits 100ms (the maximum
time allowed for FLR completion by PCIe r5.0, sec 6.6.2), and waits for the
FLR to complete.  It assumes the FLR is complete when a config read returns
valid data.

When we do an FLR on several Huawei Intelligent NIC VFs at the same time,
firmware on the NIC processes them serially.  The VF may respond to config
reads before the firmware has completed its reset processing.  If we bind a
driver to the VF (e.g., by assigning the VF to a virtual machine) in the
interval between the successful config read and completion of the firmware
reset processing, the NIC VF driver may fail to load.

Prevent this driver failure by waiting for the NIC firmware to complete its
reset processing.  Not all NIC firmware supports this feature.

[bhelgaas: commit log]
Link: https://support.huawei.com/enterprise/en/doc/EDOC1100063073/87950645/vm-oss-occasionally-fail-to-load-the-in200-driver-when-the-vf-performs-flr
Link: https://lore.kernel.org/r/20210414132301.1793-1-chiqijun@huawei.com
Signed-off-by: Chiqijun <chiqijun@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Alex Williamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c | 65 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index c5141b0542d1..576b5bb6b95f 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3897,6 +3897,69 @@ static int delay_250ms_after_flr(struct pci_dev *dev, int probe)
 	return 0;
 }
 
+#define PCI_DEVICE_ID_HINIC_VF      0x375E
+#define HINIC_VF_FLR_TYPE           0x1000
+#define HINIC_VF_FLR_CAP_BIT        (1UL << 30)
+#define HINIC_VF_OP                 0xE80
+#define HINIC_VF_FLR_PROC_BIT       (1UL << 18)
+#define HINIC_OPERATION_TIMEOUT     15000	/* 15 seconds */
+
+/* Device-specific reset method for Huawei Intelligent NIC virtual functions */
+static int reset_hinic_vf_dev(struct pci_dev *pdev, int probe)
+{
+	unsigned long timeout;
+	void __iomem *bar;
+	u32 val;
+
+	if (probe)
+		return 0;
+
+	bar = pci_iomap(pdev, 0, 0);
+	if (!bar)
+		return -ENOTTY;
+
+	/* Get and check firmware capabilities */
+	val = ioread32be(bar + HINIC_VF_FLR_TYPE);
+	if (!(val & HINIC_VF_FLR_CAP_BIT)) {
+		pci_iounmap(pdev, bar);
+		return -ENOTTY;
+	}
+
+	/* Set HINIC_VF_FLR_PROC_BIT for the start of FLR */
+	val = ioread32be(bar + HINIC_VF_OP);
+	val = val | HINIC_VF_FLR_PROC_BIT;
+	iowrite32be(val, bar + HINIC_VF_OP);
+
+	pcie_flr(pdev);
+
+	/*
+	 * The device must recapture its Bus and Device Numbers after FLR
+	 * in order generate Completions.  Issue a config write to let the
+	 * device capture this information.
+	 */
+	pci_write_config_word(pdev, PCI_VENDOR_ID, 0);
+
+	/* Firmware clears HINIC_VF_FLR_PROC_BIT when reset is complete */
+	timeout = jiffies + msecs_to_jiffies(HINIC_OPERATION_TIMEOUT);
+	do {
+		val = ioread32be(bar + HINIC_VF_OP);
+		if (!(val & HINIC_VF_FLR_PROC_BIT))
+			goto reset_complete;
+		msleep(20);
+	} while (time_before(jiffies, timeout));
+
+	val = ioread32be(bar + HINIC_VF_OP);
+	if (!(val & HINIC_VF_FLR_PROC_BIT))
+		goto reset_complete;
+
+	pci_warn(pdev, "Reset dev timeout, FLR ack reg: %#010x\n", val);
+
+reset_complete:
+	pci_iounmap(pdev, bar);
+
+	return 0;
+}
+
 static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 	{ PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82599_SFP_VF,
 		 reset_intel_82599_sfp_virtfn },
@@ -3908,6 +3971,8 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
 	{ PCI_VENDOR_ID_INTEL, 0x0953, delay_250ms_after_flr },
 	{ PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
 		reset_chelsio_generic_dev },
+	{ PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HINIC_VF,
+		reset_hinic_vf_dev },
 	{ 0 }
 };
 
-- 
2.30.2

