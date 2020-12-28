Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C44E2E4195
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438503AbgL1OHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:41714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438500AbgL1OHm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DEEA0207AB;
        Mon, 28 Dec 2020 14:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164447;
        bh=7opQaitdR4brImVKHUSpTRlLuXB5fVZ9l5R41JGYhsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IRn3QLxCGDO3yV0UCnAMo0/1+v3qcO6pcpEO0ivQNoruAzy0MUSeb5Z8g0HVjqm+e
         rNnrhPxKYcxat0u89dSaaiPxt8c0BN8KDxwAgTrGK0vxS3ACz3SA43WUQ8D1LBBrA3
         Pv5Ed1Pb9uyBJdCiyYbNuhAOCgJVe/jU/P2N7gO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, alberto.vignani@fastwebnet.it,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/717] PCI: Disable MSI for Pericom PCIe-USB adapter
Date:   Mon, 28 Dec 2020 13:42:54 +0100
Message-Id: <20201228125029.399764732@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f83c37941e881224885f2e694e0626bea358e96b ]

Pericom PCIe-USB adapter advertises MSI, but documentation says "The MSI
Function is not implemented on this device" in chapters 7.3.27,
7.3.29-7.3.31, and Alberto found that MSI in fact does not work.

Disable MSI for these devices.

Datasheet: https://www.diodes.com/assets/Datasheets/PI7C9X440SL.pdf
Fixes: 306c54d0edb6 ("usb: hcd: Try MSI interrupts on PCI devices")
Link: https://lore.kernel.org/linux-usb/20201030134826.GP4077@smile.fi.intel.com/
Link: https://lore.kernel.org/r/20201106100526.17726-1-andriy.shevchenko@linux.intel.com
Reported-by: alberto.vignani@fastwebnet.it
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index f70692ac79c56..fb1dc11e7cc52 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5567,17 +5567,26 @@ static void pci_fixup_no_d0_pme(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ASMEDIA, 0x2142, pci_fixup_no_d0_pme);
 
 /*
- * Device [12d8:0x400e] and [12d8:0x400f]
+ * Device 12d8:0x400e [OHCI] and 12d8:0x400f [EHCI]
+ *
  * These devices advertise PME# support in all power states but don't
  * reliably assert it.
+ *
+ * These devices also advertise MSI, but documentation (PI7C9X440SL.pdf)
+ * says "The MSI Function is not implemented on this device" in chapters
+ * 7.3.27, 7.3.29-7.3.31.
  */
-static void pci_fixup_no_pme(struct pci_dev *dev)
+static void pci_fixup_no_msi_no_pme(struct pci_dev *dev)
 {
+#ifdef CONFIG_PCI_MSI
+	pci_info(dev, "MSI is not implemented on this device, disabling it\n");
+	dev->no_msi = 1;
+#endif
 	pci_info(dev, "PME# is unreliable, disabling it\n");
 	dev->pme_support = 0;
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PERICOM, 0x400e, pci_fixup_no_pme);
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PERICOM, 0x400f, pci_fixup_no_pme);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PERICOM, 0x400e, pci_fixup_no_msi_no_pme);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_PERICOM, 0x400f, pci_fixup_no_msi_no_pme);
 
 static void apex_pci_fixup_class(struct pci_dev *pdev)
 {
-- 
2.27.0



