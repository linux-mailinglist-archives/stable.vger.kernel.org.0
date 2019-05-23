Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA57528756
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388770AbfEWTSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:18:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388250AbfEWTSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:18:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 740CA20863;
        Thu, 23 May 2019 19:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639096;
        bh=r0YV2d7Kb4ORO5KhwBeQugIwHS3gDCFSoFs1q5XHlPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=olEzaOoLSuCh6mPUtwZTFyMr7uwpu/k5V0iuLxUAwq0bJB6OqNAv2+wlv+L9ddnMc
         6whIiGYxycGvGqBh/frWiH0h77l/3v+HeVioe5T8YA30E4iThJW1AdsspZ6wCoHfsI
         krdnqbXApBynhzZV2E0tMw4CsLmBp1c5VhY6GJac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 4.19 076/114] PCI: Work around Pericom PCIe-to-PCI bridge Retrain Link erratum
Date:   Thu, 23 May 2019 21:06:15 +0200
Message-Id: <20190523181738.630668446@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181731.372074275@linuxfoundation.org>
References: <20190523181731.372074275@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
CC: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pcie/aspm.c |    9 +++++++++
 drivers/pci/quirks.c    |   17 +++++++++++++++++
 include/linux/pci.h     |    2 ++
 3 files changed, 28 insertions(+)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -207,6 +207,15 @@ static bool pcie_retrain_link(struct pci
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
@@ -2220,6 +2220,23 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_IN
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
+	pci_info(dev, "Enable PCIe Retrain Link quirk\n");
+}
+DECLARE_PCI_FIXUP_HEADER(0x12d8, 0xe110, quirk_enable_clear_retrain_link);
+DECLARE_PCI_FIXUP_HEADER(0x12d8, 0xe111, quirk_enable_clear_retrain_link);
+DECLARE_PCI_FIXUP_HEADER(0x12d8, 0xe130, quirk_enable_clear_retrain_link);
+
 static void fixup_rev1_53c810(struct pci_dev *dev)
 {
 	u32 class = dev->class;
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -346,6 +346,8 @@ struct pci_dev {
 	unsigned int	hotplug_user_indicators:1; /* SlotCtl indicators
 						      controlled exclusively by
 						      user sysfs */
+	unsigned int	clear_retrain_link:1;	/* Need to clear Retrain Link
+						   bit manually */
 	unsigned int	d3_delay;	/* D3->D0 transition time in ms */
 	unsigned int	d3cold_delay;	/* D3cold->D0 transition time in ms */
 


