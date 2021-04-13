Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2169035D7E8
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 08:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344978AbhDMGW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 02:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344968AbhDMGW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 02:22:26 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924DEC061574;
        Mon, 12 Apr 2021 23:22:06 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id r13so4141385pjf.2;
        Mon, 12 Apr 2021 23:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bGHITnvDuBI7eLocJtn/WGLI4BFbWAeRXxC3+WaID6U=;
        b=kT4XHXdY1RxVydXAGYu6m7tQgIlTecURHKxAGrdXCxrXzSd6KhwbgO5lAF/d6V+PH2
         BCwD8VrLgsYtcnzk86gi4xvMu1gQFeqj7Ur/MHYtFg9TefgRkLiZDQbFMMQJt1NIVFX9
         eHObDnuRJQO4rP1IUPPkdUpq0CWdnbRxp7L9cgj8driC6jOf+jmvWgxUfcg613Lk333t
         XZw75VLasjw+bLfiVVafg3LIaYBgiL9AQ0aUbYTJgFA5YOFALHlUZn4ablq2/9VDMH1Z
         +1GBlyCpMn940sYAZclR7FqyyqH+W9z2N4sG0zus/8ayxV8EkuwZlMqRfx2+BgNNJOZI
         0F5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bGHITnvDuBI7eLocJtn/WGLI4BFbWAeRXxC3+WaID6U=;
        b=kLsfd5+Wb4UE1G0FuXHiWoiGs5LhJQZDifC1krJmTihisVKqRpv75F/op47cJufOzO
         KlG9zaTTQWxQbHRG101JXp6RY0fprfSWXRg72AWfcc2S8mdOMK9hThGdmMuZ1sxtgBS4
         KlBDiXnnFBlQeYY9mqxu27IkOTvTDxRIBvxCLs6PW9SzBDZ2SSEmnSzgSu00wxKy0bJe
         dwFjxcefY1gnxqI7c/bjgvSuhwFyOU+JSk59OJxka8/D4WqG82l0BjRVUmaJ1Ip8/u4i
         NdlCCYeF89CxjwJyuOQZWyhIOtqAsNv4XQ8VIUJOQCyLHCzZT/SX8Kepbv7xbkk2+wKH
         IJOw==
X-Gm-Message-State: AOAM530IP3205liIYTtnJHmvgmLonxAu4+avwETvCldHN4oLSM5uMBu8
        uReY6O1x8Pt0GZSO+IQc5s4xUcLeoRRN9vzd
X-Google-Smtp-Source: ABdhPJxv4z5B8EQmt2roPq6uGVtTkl9rhAhRV8RdvYIQl4LE2HPMKmP/5Dgj39V+fX5ftm1cpnMLbw==
X-Received: by 2002:a17:902:b943:b029:e8:c0d4:eecf with SMTP id h3-20020a170902b943b02900e8c0d4eecfmr30715868pls.53.1618294926163;
        Mon, 12 Apr 2021 23:22:06 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id e190sm11453326pfe.3.2021.04.12.23.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 23:22:05 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tobias Wolf <dev-NTEO@vplace.de>, stable@vger.kernel.org
Subject: [PATCH 1/8] MIPS: pci-rt2880: fix slot 0 configuration
Date:   Mon, 12 Apr 2021 23:21:39 -0700
Message-Id: <20210413062146.389690-2-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210413062146.389690-1-ilya.lipnitskiy@gmail.com>
References: <20210413062146.389690-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

pci_fixup_irqs() used to call pcibios_map_irq on every PCI device, which
for RT2880 included bus 0 slot 0. After pci_fixup_irqs() got removed,
only slots/funcs with devices attached would be called. While arguably
the right thing, that left no chance for this driver to ever initialize
slot 0, effectively bricking PCI and USB on RT2880 devices such as the
Belkin F5D8235-4 v1.

Slot 0 configuration needs to happen after PCI bus enumeration, but
before any device at slot 0x11 (func 0 or 1) is talked to. That was
determined empirically by testing on a Belkin F5D8235-4 v1 device. A
minimal BAR 0 config write followed by read, then setting slot 0
PCI_COMMAND to MASTER | IO | MEMORY is all that seems to be required for
proper functionality.

Tested by ensuring that full- and high-speed USB devices get enumerated
on the Belkin F5D8235-4 v1 (with an out of tree DTS file from OpenWrt).

Fixes: 04c81c7293df ("MIPS: PCI: Replace pci_fixup_irqs() call with host bridge IRQ mapping hooks")
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Tobias Wolf <dev-NTEO@vplace.de>
Cc: <stable@vger.kernel.org> # v4.14+
---
 arch/mips/pci/pci-rt2880.c | 50 +++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 17 deletions(-)

diff --git a/arch/mips/pci/pci-rt2880.c b/arch/mips/pci/pci-rt2880.c
index e1f12e398136..19f7860fb28b 100644
--- a/arch/mips/pci/pci-rt2880.c
+++ b/arch/mips/pci/pci-rt2880.c
@@ -66,9 +66,13 @@ static int rt2880_pci_config_read(struct pci_bus *bus, unsigned int devfn,
 	unsigned long flags;
 	u32 address;
 	u32 data;
+	int busn = 0;
 
-	address = rt2880_pci_get_cfgaddr(bus->number, PCI_SLOT(devfn),
-					 PCI_FUNC(devfn), where);
+	if (bus)
+		busn = bus->number;
+
+	address = rt2880_pci_get_cfgaddr(busn, PCI_SLOT(devfn), PCI_FUNC(devfn),
+					 where);
 
 	spin_lock_irqsave(&rt2880_pci_lock, flags);
 	rt2880_pci_reg_write(address, RT2880_PCI_REG_CONFIG_ADDR);
@@ -96,9 +100,13 @@ static int rt2880_pci_config_write(struct pci_bus *bus, unsigned int devfn,
 	unsigned long flags;
 	u32 address;
 	u32 data;
+	int busn = 0;
+
+	if (bus)
+		busn = bus->number;
 
-	address = rt2880_pci_get_cfgaddr(bus->number, PCI_SLOT(devfn),
-					 PCI_FUNC(devfn), where);
+	address = rt2880_pci_get_cfgaddr(busn, PCI_SLOT(devfn), PCI_FUNC(devfn),
+					 where);
 
 	spin_lock_irqsave(&rt2880_pci_lock, flags);
 	rt2880_pci_reg_write(address, RT2880_PCI_REG_CONFIG_ADDR);
@@ -180,7 +188,6 @@ static inline void rt2880_pci_write_u32(unsigned long reg, u32 val)
 
 int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
-	u16 cmd;
 	int irq = -1;
 
 	if (dev->bus->number != 0)
@@ -188,8 +195,6 @@ int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 
 	switch (PCI_SLOT(dev->devfn)) {
 	case 0x00:
-		rt2880_pci_write_u32(PCI_BASE_ADDRESS_0, 0x08000000);
-		(void) rt2880_pci_read_u32(PCI_BASE_ADDRESS_0);
 		break;
 	case 0x11:
 		irq = RT288X_CPU_IRQ_PCI;
@@ -201,16 +206,6 @@ int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 		break;
 	}
 
-	pci_write_config_byte((struct pci_dev *) dev,
-		PCI_CACHE_LINE_SIZE, 0x14);
-	pci_write_config_byte((struct pci_dev *) dev, PCI_LATENCY_TIMER, 0xFF);
-	pci_read_config_word((struct pci_dev *) dev, PCI_COMMAND, &cmd);
-	cmd |= PCI_COMMAND_MASTER | PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
-		PCI_COMMAND_INVALIDATE | PCI_COMMAND_FAST_BACK |
-		PCI_COMMAND_SERR | PCI_COMMAND_WAIT | PCI_COMMAND_PARITY;
-	pci_write_config_word((struct pci_dev *) dev, PCI_COMMAND, cmd);
-	pci_write_config_byte((struct pci_dev *) dev, PCI_INTERRUPT_LINE,
-			      dev->irq);
 	return irq;
 }
 
@@ -251,6 +246,27 @@ static int rt288x_pci_probe(struct platform_device *pdev)
 
 int pcibios_plat_dev_init(struct pci_dev *dev)
 {
+	static bool slot0_init;
+
+	/*
+	 * Nobody seems to initialize slot 0, but this platform requires it, so
+	 * do it once when some other slot is being enabled. The PCI subsystem
+	 * should configure other slots properly, so no need to do anything
+	 * special for those.
+	 */
+	if (!slot0_init) {
+		u32 cmd;
+
+		slot0_init = true;
+
+		rt2880_pci_write_u32(PCI_BASE_ADDRESS_0, 0x08000000);
+		(void) rt2880_pci_read_u32(PCI_BASE_ADDRESS_0);
+
+		rt2880_pci_config_read(NULL, 0, PCI_COMMAND, 2, &cmd);
+		cmd |= PCI_COMMAND_MASTER | PCI_COMMAND_IO | PCI_COMMAND_MEMORY;
+		rt2880_pci_config_write(NULL, 0, PCI_COMMAND, 2, cmd);
+	}
+
 	return 0;
 }
 
-- 
2.31.1

