Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 397392B6273
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731882AbgKQN2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:28:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731869AbgKQN2c (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:28:32 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E952A20781;
        Tue, 17 Nov 2020 13:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619711;
        bh=3X/amyWukI/RU6rYYv8FQh95lYcw6srlsikoMepcCiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRlC/jfi53DyAODYucvue/a5xHtU607008h9UuO86pfY3fypk0MYDWiVvQAkuIt3P
         0MV52l9Oo4OEmGhMMK3F5b9gwg6bvPYoAipVXdGayX2uagfo7lIYL+WynxghJlJ0tC
         aLhnFHgUUDXEN72Bo8fggCfxQRoeQUbzeDefaJKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaud de Turckheim <quarium@gmail.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 5.4 130/151] gpio: pcie-idio-24: Enable PEX8311 interrupts
Date:   Tue, 17 Nov 2020 14:06:00 +0100
Message-Id: <20201117122127.750362193@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122121.381905960@linuxfoundation.org>
References: <20201117122121.381905960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaud de Turckheim <quarium@gmail.com>

commit 10a2f11d3c9e48363c729419e0f0530dea76e4fe upstream.

This enables the PEX8311 internal PCI wire interrupt and the PEX8311
local interrupt input so the local interrupts are forwarded to the PCI.

Fixes: 585562046628 ("gpio: Add GPIO support for the ACCES PCIe-IDIO-24 family")
Cc: stable@vger.kernel.org
Signed-off-by: Arnaud de Turckheim <quarium@gmail.com>
Reviewed-by: William Breathitt Gray <vilhelm.gray@gmail.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpio/gpio-pcie-idio-24.c |   52 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 51 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-pcie-idio-24.c
+++ b/drivers/gpio/gpio-pcie-idio-24.c
@@ -28,6 +28,47 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
+/*
+ * PLX PEX8311 PCI LCS_INTCSR Interrupt Control/Status
+ *
+ * Bit: Description
+ *   0: Enable Interrupt Sources (Bit 0)
+ *   1: Enable Interrupt Sources (Bit 1)
+ *   2: Generate Internal PCI Bus Internal SERR# Interrupt
+ *   3: Mailbox Interrupt Enable
+ *   4: Power Management Interrupt Enable
+ *   5: Power Management Interrupt
+ *   6: Slave Read Local Data Parity Check Error Enable
+ *   7: Slave Read Local Data Parity Check Error Status
+ *   8: Internal PCI Wire Interrupt Enable
+ *   9: PCI Express Doorbell Interrupt Enable
+ *  10: PCI Abort Interrupt Enable
+ *  11: Local Interrupt Input Enable
+ *  12: Retry Abort Enable
+ *  13: PCI Express Doorbell Interrupt Active
+ *  14: PCI Abort Interrupt Active
+ *  15: Local Interrupt Input Active
+ *  16: Local Interrupt Output Enable
+ *  17: Local Doorbell Interrupt Enable
+ *  18: DMA Channel 0 Interrupt Enable
+ *  19: DMA Channel 1 Interrupt Enable
+ *  20: Local Doorbell Interrupt Active
+ *  21: DMA Channel 0 Interrupt Active
+ *  22: DMA Channel 1 Interrupt Active
+ *  23: Built-In Self-Test (BIST) Interrupt Active
+ *  24: Direct Master was the Bus Master during a Master or Target Abort
+ *  25: DMA Channel 0 was the Bus Master during a Master or Target Abort
+ *  26: DMA Channel 1 was the Bus Master during a Master or Target Abort
+ *  27: Target Abort after internal 256 consecutive Master Retrys
+ *  28: PCI Bus wrote data to LCS_MBOX0
+ *  29: PCI Bus wrote data to LCS_MBOX1
+ *  30: PCI Bus wrote data to LCS_MBOX2
+ *  31: PCI Bus wrote data to LCS_MBOX3
+ */
+#define PLX_PEX8311_PCI_LCS_INTCSR  0x68
+#define INTCSR_INTERNAL_PCI_WIRE    BIT(8)
+#define INTCSR_LOCAL_INPUT          BIT(11)
+
 /**
  * struct idio_24_gpio_reg - GPIO device registers structure
  * @out0_7:	Read: FET Outputs 0-7
@@ -92,6 +133,7 @@ struct idio_24_gpio_reg {
 struct idio_24_gpio {
 	struct gpio_chip chip;
 	raw_spinlock_t lock;
+	__u8 __iomem *plx;
 	struct idio_24_gpio_reg __iomem *reg;
 	unsigned long irq_mask;
 };
@@ -481,6 +523,7 @@ static int idio_24_probe(struct pci_dev
 	struct device *const dev = &pdev->dev;
 	struct idio_24_gpio *idio24gpio;
 	int err;
+	const size_t pci_plx_bar_index = 1;
 	const size_t pci_bar_index = 2;
 	const char *const name = pci_name(pdev);
 
@@ -494,12 +537,13 @@ static int idio_24_probe(struct pci_dev
 		return err;
 	}
 
-	err = pcim_iomap_regions(pdev, BIT(pci_bar_index), name);
+	err = pcim_iomap_regions(pdev, BIT(pci_plx_bar_index) | BIT(pci_bar_index), name);
 	if (err) {
 		dev_err(dev, "Unable to map PCI I/O addresses (%d)\n", err);
 		return err;
 	}
 
+	idio24gpio->plx = pcim_iomap_table(pdev)[pci_plx_bar_index];
 	idio24gpio->reg = pcim_iomap_table(pdev)[pci_bar_index];
 
 	idio24gpio->chip.label = name;
@@ -520,6 +564,12 @@ static int idio_24_probe(struct pci_dev
 
 	/* Software board reset */
 	iowrite8(0, &idio24gpio->reg->soft_reset);
+	/*
+	 * enable PLX PEX8311 internal PCI wire interrupt and local interrupt
+	 * input
+	 */
+	iowrite8((INTCSR_INTERNAL_PCI_WIRE | INTCSR_LOCAL_INPUT) >> 8,
+		 idio24gpio->plx + PLX_PEX8311_PCI_LCS_INTCSR + 1);
 
 	err = devm_gpiochip_add_data(dev, &idio24gpio->chip, idio24gpio);
 	if (err) {


