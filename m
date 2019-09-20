Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE78B9331
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392934AbfITOiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:38:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35700 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387992AbfITOY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:24:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqD-0004wl-3q; Fri, 20 Sep 2019 15:24:57 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqC-0007qF-LQ; Fri, 20 Sep 2019 15:24:56 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "=?UTF-8?q?Stefan=20M=C3=A4tje?=" <stefan.maetje@esd.eu>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.779577266@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 021/132] PCI: Work around Pericom PCIe-to-PCI bridge
 Retrain Link erratum
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Mätje <stefan.maetje@esd.eu>

commit 4ec73791a64bab25cabf16a6067ee478692e506d upstream.

Due to an erratum in some Pericom PCIe-to-PCI bridges in reverse mode
(conventional PCI on primary side, PCIe on downstream side), the Retrain
Link bit needs to be cleared manually to allow the link training to
complete successfully.

If it is not cleared manually, the link training is continuously restarted
and no devices below the PCI-to-PCIe bridge can be accessed.  That means
drivers for devices below the bridge will be loaded but won't work and may
even crash because the driver is only reading 0xffff.

See the Pericom Errata Sheet PI7C9X111SLB_errata_rev1.2_102711.pdf for
details.  Devices known as affected so far are: PI7C9X110, PI7C9X111SL,
PI7C9X130.

Add a new flag, clear_retrain_link, in struct pci_dev.  Quirks for affected
devices set this bit.

Note that pcie_retrain_link() lives in aspm.c because that's currently the
only place we use it, but this erratum is not specific to ASPM, and we may
retrain links for other reasons in the future.

Signed-off-by: Stefan Mätje <stefan.maetje@esd.eu>
[bhelgaas: apply regardless of CONFIG_PCIEASPM]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
[bwh: Backported to 3.16:
 - Use dev_info() instead of pci_info()
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/pcie/aspm.c |  9 +++++++++
 drivers/pci/quirks.c    | 17 +++++++++++++++++
 include/linux/pci.h     |  2 ++
 3 files changed, 28 insertions(+)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -184,6 +184,15 @@ static bool pcie_retrain_link(struct pci
 	pcie_capability_read_word(parent, PCI_EXP_LNKCTL, &reg16);
 	reg16 |= PCI_EXP_LNKCTL_RL;
 	pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
+	if (parent->clear_retrain_link) {
+		/*
+		 * Due to an erratum in some devices the Retrain Link bit
+		 * needs to be cleared again manually to allow the link
+		 * training to succeed.
+		 */
+		reg16 &= ~PCI_EXP_LNKCTL_RL;
+		pcie_capability_write_word(parent, PCI_EXP_LNKCTL, reg16);
+	}
 
 	/* Wait for link training end. Break out after waiting for timeout */
 	start_jiffies = jiffies;
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2047,6 +2047,23 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x10f4, quirk_disable_aspm_l0s);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x1508, quirk_disable_aspm_l0s);
 
+/*
+ * Some Pericom PCIe-to-PCI bridges in reverse mode need the PCIe Retrain
+ * Link bit cleared after starting the link retrain process to allow this
+ * process to finish.
+ *
+ * Affected devices: PI7C9X110, PI7C9X111SL, PI7C9X130.  See also the
+ * Pericom Errata Sheet PI7C9X111SLB_errata_rev1.2_102711.pdf.
+ */
+static void quirk_enable_clear_retrain_link(struct pci_dev *dev)
+{
+	dev->clear_retrain_link = 1;
+	dev_info(&dev->dev, "Enable PCIe Retrain Link quirk\n");
+}
+DECLARE_PCI_FIXUP_HEADER(0x12d8, 0xe110, quirk_enable_clear_retrain_link);
+DECLARE_PCI_FIXUP_HEADER(0x12d8, 0xe111, quirk_enable_clear_retrain_link);
+DECLARE_PCI_FIXUP_HEADER(0x12d8, 0xe130, quirk_enable_clear_retrain_link);
+
 static void fixup_rev1_53c810(struct pci_dev *dev)
 {
 	/* rev 1 ncr53c810 chips don't set the class at all which means
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -308,6 +308,8 @@ struct pci_dev {
 						   powered on/off by the
 						   corresponding bridge */
 	unsigned int	ignore_hotplug:1;	/* Ignore hotplug events */
+	unsigned int	clear_retrain_link:1;	/* Need to clear Retrain Link
+						   bit manually */
 	unsigned int	d3_delay;	/* D3->D0 transition time in ms */
 	unsigned int	d3cold_delay;	/* D3cold->D0 transition time in ms */
 

