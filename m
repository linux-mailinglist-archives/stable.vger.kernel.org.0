Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E603CE10D
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347506AbhGSPTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:19:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347401AbhGSPQK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:16:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C008761003;
        Mon, 19 Jul 2021 15:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710209;
        bh=Xlz2lRLQs6zeNSzbDmNovmY/D64BjgH/LZXwUJ/H8g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EqbbRonUoNmqDd6Qe48RPG/DboWUokV8VvUeYl5yyLpwoTa5g7dtlUhdcoV//2TJh
         uJ8jaLPKhYIl+Tw4uFrh8IrCONEggPrE1klKafIIlTDd9GmEshXBJb0RB68XQABuTn
         nmpfQuBWJscftDiD25P5BNLpXJ7RNODQ9Ykk/dMs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sinan Kaya <okaya@kernel.org>,
        Ethan Zhao <haifeng.zhao@intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Lukas Wunner <lukas@wunner.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/243] PCI: pciehp: Ignore Link Down/Up caused by DPC
Date:   Mon, 19 Jul 2021 16:52:31 +0200
Message-Id: <20210719144944.848368374@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit a97396c6eb13f65bea894dbe7739b2e883d40a3e ]

Downstream Port Containment (PCIe r5.0, sec. 6.2.10) disables the link upon
an error and attempts to re-enable it when instructed by the DPC driver.

A slot which is both DPC- and hotplug-capable is currently powered off by
pciehp once DPC is triggered (due to the link change) and powered back up
on successful recovery.  That's undesirable, the slot should remain powered
so the hotplugged device remains bound to its driver.  DPC notifies the
driver of the error and of successful recovery in pcie_do_recovery() and
the driver may then restore the device to working state.

Moreover, Sinan points out that turning off slot power by pciehp may foil
recovery by DPC:  Power off/on is a cold reset concurrently to DPC's warm
reset.  Sathyanarayanan reports extended delays or failure in link
retraining by DPC if pciehp brings down the slot.

Fix by detecting whether a Link Down event is caused by DPC and awaiting
recovery if so.  On successful recovery, ignore both the Link Down and the
subsequent Link Up event.

Afterwards, check whether the link is down to detect surprise-removal or
another DPC event immediately after DPC recovery.  Ensure that the
corresponding DLLSC event is not ignored by synthesizing it and invoking
irq_wake_thread() to trigger a re-run of pciehp_ist().

The IRQ threads of the hotplug and DPC drivers, pciehp_ist() and
dpc_handler(), race against each other.  If pciehp is faster than DPC, it
will wait until DPC recovery completes.

Recovery consists of two steps:  The first step (waiting for link
disablement) is recognizable by pciehp through a set DPC Trigger Status
bit.  The second step (waiting for link retraining) is recognizable through
a newly introduced PCI_DPC_RECOVERING flag.

If DPC is faster than pciehp, neither of the two flags will be set and
pciehp may glean the recovery status from the new PCI_DPC_RECOVERED flag.
The flag is zero if DPC didn't occur at all, hence DLLSC events are not
ignored by default.

pciehp waits up to 4 seconds before assuming that DPC recovery failed and
bringing down the slot.  This timeout is not taken from the spec (it
doesn't mandate one) but based on a report from Yicong Yang that DPC may
take a bit more than 3 seconds on HiSilicon's Kunpeng platform.

The timeout is necessary because the DPC Trigger Status bit may never
clear:  On Root Ports which support RP Extensions for DPC, the DPC driver
polls the DPC RP Busy bit for up to 1 second before giving up on DPC
recovery.  Without the timeout, pciehp would then wait indefinitely for DPC
to complete.

This commit draws inspiration from previous attempts to synchronize DPC
with pciehp:

By Sinan Kaya, August 2018:
https://lore.kernel.org/linux-pci/20180818065126.77912-1-okaya@kernel.org/

By Ethan Zhao, October 2020:
https://lore.kernel.org/linux-pci/20201007113158.48933-1-haifeng.zhao@intel.com/

By Kuppuswamy Sathyanarayanan, March 2021:
https://lore.kernel.org/linux-pci/59cb30f5e5ac6d65427ceaadf1012b2ba8dbf66c.1615606143.git.sathyanarayanan.kuppuswamy@linux.intel.com/

Link: https://lore.kernel.org/r/0be565d97438fe2a6d57354b3aa4e8626952a00b.1619857124.git.lukas@wunner.de
Reported-by: Sinan Kaya <okaya@kernel.org>
Reported-by: Ethan Zhao <haifeng.zhao@intel.com>
Reported-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Tested-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Tested-by: Yicong Yang <yangyicong@hisilicon.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ashok Raj <ashok.raj@intel.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pciehp_hpc.c | 36 ++++++++++++++++
 drivers/pci/pci.h                |  4 ++
 drivers/pci/pcie/dpc.c           | 74 +++++++++++++++++++++++++++++---
 3 files changed, 109 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index fb3840e222ad..9d06939736c0 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -563,6 +563,32 @@ void pciehp_power_off_slot(struct controller *ctrl)
 		 PCI_EXP_SLTCTL_PWR_OFF);
 }
 
+static void pciehp_ignore_dpc_link_change(struct controller *ctrl,
+					  struct pci_dev *pdev, int irq)
+{
+	/*
+	 * Ignore link changes which occurred while waiting for DPC recovery.
+	 * Could be several if DPC triggered multiple times consecutively.
+	 */
+	synchronize_hardirq(irq);
+	atomic_and(~PCI_EXP_SLTSTA_DLLSC, &ctrl->pending_events);
+	if (pciehp_poll_mode)
+		pcie_capability_write_word(pdev, PCI_EXP_SLTSTA,
+					   PCI_EXP_SLTSTA_DLLSC);
+	ctrl_info(ctrl, "Slot(%s): Link Down/Up ignored (recovered by DPC)\n",
+		  slot_name(ctrl));
+
+	/*
+	 * If the link is unexpectedly down after successful recovery,
+	 * the corresponding link change may have been ignored above.
+	 * Synthesize it to ensure that it is acted on.
+	 */
+	down_read(&ctrl->reset_lock);
+	if (!pciehp_check_link_active(ctrl))
+		pciehp_request(ctrl, PCI_EXP_SLTSTA_DLLSC);
+	up_read(&ctrl->reset_lock);
+}
+
 static irqreturn_t pciehp_isr(int irq, void *dev_id)
 {
 	struct controller *ctrl = (struct controller *)dev_id;
@@ -706,6 +732,16 @@ static irqreturn_t pciehp_ist(int irq, void *dev_id)
 				      PCI_EXP_SLTCTL_ATTN_IND_ON);
 	}
 
+	/*
+	 * Ignore Link Down/Up events caused by Downstream Port Containment
+	 * if recovery from the error succeeded.
+	 */
+	if ((events & PCI_EXP_SLTSTA_DLLSC) && pci_dpc_recovered(pdev) &&
+	    ctrl->state == ON_STATE) {
+		events &= ~PCI_EXP_SLTSTA_DLLSC;
+		pciehp_ignore_dpc_link_change(ctrl, pdev, irq);
+	}
+
 	/*
 	 * Disable requests have higher priority than Presence Detect Changed
 	 * or Data Link Layer State Changed events.
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 09ebc134d0d7..a96dc6f53076 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -409,6 +409,8 @@ static inline bool pci_dev_is_disconnected(const struct pci_dev *dev)
 
 /* pci_dev priv_flags */
 #define PCI_DEV_ADDED 0
+#define PCI_DPC_RECOVERED 1
+#define PCI_DPC_RECOVERING 2
 
 static inline void pci_dev_assign_added(struct pci_dev *dev, bool added)
 {
@@ -454,10 +456,12 @@ void pci_restore_dpc_state(struct pci_dev *dev);
 void pci_dpc_init(struct pci_dev *pdev);
 void dpc_process_error(struct pci_dev *pdev);
 pci_ers_result_t dpc_reset_link(struct pci_dev *pdev);
+bool pci_dpc_recovered(struct pci_dev *pdev);
 #else
 static inline void pci_save_dpc_state(struct pci_dev *dev) {}
 static inline void pci_restore_dpc_state(struct pci_dev *dev) {}
 static inline void pci_dpc_init(struct pci_dev *pdev) {}
+static inline bool pci_dpc_recovered(struct pci_dev *pdev) { return false; }
 #endif
 
 #ifdef CONFIG_PCI_ATS
diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index e05aba86a317..c556e7beafe3 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -71,6 +71,58 @@ void pci_restore_dpc_state(struct pci_dev *dev)
 	pci_write_config_word(dev, dev->dpc_cap + PCI_EXP_DPC_CTL, *cap);
 }
 
+static DECLARE_WAIT_QUEUE_HEAD(dpc_completed_waitqueue);
+
+#ifdef CONFIG_HOTPLUG_PCI_PCIE
+static bool dpc_completed(struct pci_dev *pdev)
+{
+	u16 status;
+
+	pci_read_config_word(pdev, pdev->dpc_cap + PCI_EXP_DPC_STATUS, &status);
+	if ((status != 0xffff) && (status & PCI_EXP_DPC_STATUS_TRIGGER))
+		return false;
+
+	if (test_bit(PCI_DPC_RECOVERING, &pdev->priv_flags))
+		return false;
+
+	return true;
+}
+
+/**
+ * pci_dpc_recovered - whether DPC triggered and has recovered successfully
+ * @pdev: PCI device
+ *
+ * Return true if DPC was triggered for @pdev and has recovered successfully.
+ * Wait for recovery if it hasn't completed yet.  Called from the PCIe hotplug
+ * driver to recognize and ignore Link Down/Up events caused by DPC.
+ */
+bool pci_dpc_recovered(struct pci_dev *pdev)
+{
+	struct pci_host_bridge *host;
+
+	if (!pdev->dpc_cap)
+		return false;
+
+	/*
+	 * Synchronization between hotplug and DPC is not supported
+	 * if DPC is owned by firmware and EDR is not enabled.
+	 */
+	host = pci_find_host_bridge(pdev->bus);
+	if (!host->native_dpc && !IS_ENABLED(CONFIG_PCIE_EDR))
+		return false;
+
+	/*
+	 * Need a timeout in case DPC never completes due to failure of
+	 * dpc_wait_rp_inactive().  The spec doesn't mandate a time limit,
+	 * but reports indicate that DPC completes within 4 seconds.
+	 */
+	wait_event_timeout(dpc_completed_waitqueue, dpc_completed(pdev),
+			   msecs_to_jiffies(4000));
+
+	return test_and_clear_bit(PCI_DPC_RECOVERED, &pdev->priv_flags);
+}
+#endif /* CONFIG_HOTPLUG_PCI_PCIE */
+
 static int dpc_wait_rp_inactive(struct pci_dev *pdev)
 {
 	unsigned long timeout = jiffies + HZ;
@@ -91,8 +143,11 @@ static int dpc_wait_rp_inactive(struct pci_dev *pdev)
 
 pci_ers_result_t dpc_reset_link(struct pci_dev *pdev)
 {
+	pci_ers_result_t ret;
 	u16 cap;
 
+	set_bit(PCI_DPC_RECOVERING, &pdev->priv_flags);
+
 	/*
 	 * DPC disables the Link automatically in hardware, so it has
 	 * already been reset by the time we get here.
@@ -106,18 +161,27 @@ pci_ers_result_t dpc_reset_link(struct pci_dev *pdev)
 	if (!pcie_wait_for_link(pdev, false))
 		pci_info(pdev, "Data Link Layer Link Active not cleared in 1000 msec\n");
 
-	if (pdev->dpc_rp_extensions && dpc_wait_rp_inactive(pdev))
-		return PCI_ERS_RESULT_DISCONNECT;
+	if (pdev->dpc_rp_extensions && dpc_wait_rp_inactive(pdev)) {
+		clear_bit(PCI_DPC_RECOVERED, &pdev->priv_flags);
+		ret = PCI_ERS_RESULT_DISCONNECT;
+		goto out;
+	}
 
 	pci_write_config_word(pdev, cap + PCI_EXP_DPC_STATUS,
 			      PCI_EXP_DPC_STATUS_TRIGGER);
 
 	if (!pcie_wait_for_link(pdev, true)) {
 		pci_info(pdev, "Data Link Layer Link Active not set in 1000 msec\n");
-		return PCI_ERS_RESULT_DISCONNECT;
+		clear_bit(PCI_DPC_RECOVERED, &pdev->priv_flags);
+		ret = PCI_ERS_RESULT_DISCONNECT;
+	} else {
+		set_bit(PCI_DPC_RECOVERED, &pdev->priv_flags);
+		ret = PCI_ERS_RESULT_RECOVERED;
 	}
-
-	return PCI_ERS_RESULT_RECOVERED;
+out:
+	clear_bit(PCI_DPC_RECOVERING, &pdev->priv_flags);
+	wake_up_all(&dpc_completed_waitqueue);
+	return ret;
 }
 
 static void dpc_process_rp_pio_error(struct pci_dev *pdev)
-- 
2.30.2



