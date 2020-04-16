Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C441ACAC0
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395281AbgDPPjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897691AbgDPNic (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:38:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEFC5221EB;
        Thu, 16 Apr 2020 13:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044311;
        bh=l4gKo6MhDDCSkseuLFU9PhEztEAvyYUgelDYwzGowQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HoKx1evZf7kjk5aBX0A4Nl8+FgCw7dXnW3/AaHiWqHrjtwGZvJ2AkdaFmZS1Fdk1L
         CDCEZO9NRJTHK5h7Uq38uWtK8af6aXZT/fMSFbfpQbnOp/xeXo20lZH4tUqnDQqkqz
         YrfftO9woNTHehTm+y02kBrIVn6PS4BCo4ckl7ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kar Hin Ong <kar.hin.ong@ni.com>,
        Sean V Kelley <sean.v.kelley@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.5 115/257] PCI: Add boot interrupt quirk mechanism for Xeon chipsets
Date:   Thu, 16 Apr 2020 15:22:46 +0200
Message-Id: <20200416131340.632520952@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean V Kelley <sean.v.kelley@linux.intel.com>

commit b88bf6c3b6ff77948c153cac4e564642b0b90632 upstream.

The following was observed by Kar Hin Ong with RT patchset:

  Backtrace:
  irq 19: nobody cared (try booting with the "irqpoll" option)
  CPU: 0 PID: 3329 Comm: irq/34-nipalk Tainted:4.14.87-rt49 #1
  Hardware name: National Instruments NI PXIe-8880/NI PXIe-8880,
           BIOS 2.1.5f1 01/09/2020
  Call Trace:
  <IRQ>
    ? dump_stack+0x46/0x5e
    ? __report_bad_irq+0x2e/0xb0
    ? note_interrupt+0x242/0x290
    ? nNIKAL100_memoryRead16+0x8/0x10 [nikal]
    ? handle_irq_event_percpu+0x55/0x70
    ? handle_irq_event+0x4f/0x80
    ? handle_fasteoi_irq+0x81/0x180
    ? handle_irq+0x1c/0x30
    ? do_IRQ+0x41/0xd0
    ? common_interrupt+0x84/0x84
  </IRQ>
  ...
  handlers:
  [<ffffffffb3297200>] irq_default_primary_handler threaded
  [<ffffffffb3669180>] usb_hcd_irq
  Disabling IRQ #19

The problem being that this device is triggering boot interrupts
due to threaded interrupt handling and masking of the IO-APIC. These
boot interrupts are then forwarded on to the legacy PCH's PIRQ lines
where there is no handler present for the device.

Whenever a PCI device fires interrupt (INTx) to Pin 20 of IOAPIC 2
(GSI 44), the kernel receives two interrupts:

   1. Interrupt from Pin 20 of IOAPIC 2  -> Expected
   2. Interrupt from Pin 19 of IOAPIC 1  -> UNEXPECTED

Quirks for disabling boot interrupts (preferred) or rerouting the
handler exist but do not address these Xeon chipsets' mechanism:
https://lore.kernel.org/lkml/12131949181903-git-send-email-sassmann@suse.de/

Add a new mechanism via PCI CFG for those chipsets supporting CIPINTRC
register's dis_intx_rout2ich bit.

Link: https://lore.kernel.org/r/20200220192930.64820-2-sean.v.kelley@linux.intel.com
Reported-by: Kar Hin Ong <kar.hin.ong@ni.com>
Tested-by: Kar Hin Ong <kar.hin.ong@ni.com>
Signed-off-by: Sean V Kelley <sean.v.kelley@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 73 insertions(+), 7 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1970,26 +1970,92 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_I
 /*
  * IO-APIC1 on 6300ESB generates boot interrupts, see Intel order no
  * 300641-004US, section 5.7.3.
+ *
+ * Core IO on Xeon E5 1600/2600/4600, see Intel order no 326509-003.
+ * Core IO on Xeon E5 v2, see Intel order no 329188-003.
+ * Core IO on Xeon E7 v2, see Intel order no 329595-002.
+ * Core IO on Xeon E5 v3, see Intel order no 330784-003.
+ * Core IO on Xeon E7 v3, see Intel order no 332315-001US.
+ * Core IO on Xeon E5 v4, see Intel order no 333810-002US.
+ * Core IO on Xeon E7 v4, see Intel order no 332315-001US.
+ * Core IO on Xeon D-1500, see Intel order no 332051-001.
+ * Core IO on Xeon Scalable, see Intel order no 610950.
  */
-#define INTEL_6300_IOAPIC_ABAR		0x40
+#define INTEL_6300_IOAPIC_ABAR		0x40	/* Bus 0, Dev 29, Func 5 */
 #define INTEL_6300_DISABLE_BOOT_IRQ	(1<<14)
 
+#define INTEL_CIPINTRC_CFG_OFFSET	0x14C	/* Bus 0, Dev 5, Func 0 */
+#define INTEL_CIPINTRC_DIS_INTX_ICH	(1<<25)
+
 static void quirk_disable_intel_boot_interrupt(struct pci_dev *dev)
 {
 	u16 pci_config_word;
+	u32 pci_config_dword;
 
 	if (noioapicquirk)
 		return;
 
-	pci_read_config_word(dev, INTEL_6300_IOAPIC_ABAR, &pci_config_word);
-	pci_config_word |= INTEL_6300_DISABLE_BOOT_IRQ;
-	pci_write_config_word(dev, INTEL_6300_IOAPIC_ABAR, pci_config_word);
-
+	switch (dev->device) {
+	case PCI_DEVICE_ID_INTEL_ESB_10:
+		pci_read_config_word(dev, INTEL_6300_IOAPIC_ABAR,
+				     &pci_config_word);
+		pci_config_word |= INTEL_6300_DISABLE_BOOT_IRQ;
+		pci_write_config_word(dev, INTEL_6300_IOAPIC_ABAR,
+				      pci_config_word);
+		break;
+	case 0x3c28:	/* Xeon E5 1600/2600/4600	*/
+	case 0x0e28:	/* Xeon E5/E7 V2		*/
+	case 0x2f28:	/* Xeon E5/E7 V3,V4		*/
+	case 0x6f28:	/* Xeon D-1500			*/
+	case 0x2034:	/* Xeon Scalable Family		*/
+		pci_read_config_dword(dev, INTEL_CIPINTRC_CFG_OFFSET,
+				      &pci_config_dword);
+		pci_config_dword |= INTEL_CIPINTRC_DIS_INTX_ICH;
+		pci_write_config_dword(dev, INTEL_CIPINTRC_CFG_OFFSET,
+				       pci_config_dword);
+		break;
+	default:
+		return;
+	}
 	pci_info(dev, "disabled boot interrupts on device [%04x:%04x]\n",
 		 dev->vendor, dev->device);
 }
-DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ESB_10,	quirk_disable_intel_boot_interrupt);
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,   PCI_DEVICE_ID_INTEL_ESB_10,	quirk_disable_intel_boot_interrupt);
+/*
+ * Device 29 Func 5 Device IDs of IO-APIC
+ * containing ABAR—APIC1 Alternate Base Address Register
+ */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ESB_10,
+		quirk_disable_intel_boot_interrupt);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_ESB_10,
+		quirk_disable_intel_boot_interrupt);
+
+/*
+ * Device 5 Func 0 Device IDs of Core IO modules/hubs
+ * containing Coherent Interface Protocol Interrupt Control
+ *
+ * Device IDs obtained from volume 2 datasheets of commented
+ * families above.
+ */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x3c28,
+		quirk_disable_intel_boot_interrupt);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x0e28,
+		quirk_disable_intel_boot_interrupt);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x2f28,
+		quirk_disable_intel_boot_interrupt);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x6f28,
+		quirk_disable_intel_boot_interrupt);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL,	0x2034,
+		quirk_disable_intel_boot_interrupt);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	0x3c28,
+		quirk_disable_intel_boot_interrupt);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	0x0e28,
+		quirk_disable_intel_boot_interrupt);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	0x2f28,
+		quirk_disable_intel_boot_interrupt);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	0x6f28,
+		quirk_disable_intel_boot_interrupt);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_INTEL,	0x2034,
+		quirk_disable_intel_boot_interrupt);
 
 /* Disable boot interrupts on HT-1000 */
 #define BC_HT1000_FEATURE_REG		0x64


