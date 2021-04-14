Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B10E235EB46
	for <lists+stable@lfdr.de>; Wed, 14 Apr 2021 05:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhDNDNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 23:13:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhDNDNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 23:13:37 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2F9C061756;
        Tue, 13 Apr 2021 20:12:50 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u7so7509678plr.6;
        Tue, 13 Apr 2021 20:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uQGkHbExQKECAJaJryg6v9FWioWhZzgp18Ncbwe9/nk=;
        b=DSdYpVxIQFFaGAWRAPF7d09a5+OXsr5y91RTFTyPn9d/MVKoD3Q2re2NstpocIvFSM
         L1wR5KAsBwZ5H8uXwV6nLruz+gJrBWiuhfVv3qD+rIFm7A1o9Lkv2XLMtXD25qu92qkH
         UykLiqoEcY1rqO8jNaW1ZSjeX8p2pnm9LBlrwEsrkpQgeAmWhACb4BfYfFqLg0s/1K+E
         SrFdrUIUgapKAliNC6rCHn8eoA0ND2g78snUYHeyMZ+mhAmOXwg39kv/6r7MKfCp1Ub7
         ut6A8OHsskkkeP1xWOe25LXbCNGYfu+MU7x5yXks8hTh97qHOpx2o3MbvpSALiFTKyyV
         ZJ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uQGkHbExQKECAJaJryg6v9FWioWhZzgp18Ncbwe9/nk=;
        b=MO4EDZdXiL4dhFQ/skbIMTQ4cgNiax4inzr/j8XUUjoBRUcxjmqPzlB5Ae5V4BBgGU
         T+6lwew1G2kUiEO+7f/qmBuXMnpjWPWCS6jFgXsYVK2rlL5ZFnnqdYL+yEGudkv8vPWo
         1JnvgbBpqJEM73zBjenFKdl39WVpTBXAUecRTlCqyyUPGytlUGNR5jQTAStcSO7RVGnK
         X57y9Ch4WGz/lUl9FKGhb4apL2B71nouGNgqdlX9eXBQ4JKXEZG9ebOvWgG3IM3jk/eA
         5Xe6Knd2Dt6DHHzhEL17hs1FbWmOoddFB7mPaxu4knupwlGcfDbKdh6/VVcXQuHiMOi2
         0Prw==
X-Gm-Message-State: AOAM532OE4HSYLAAIDzkeNygD7CMEfajJ2JDOC/3UlIQY8JMuGw5nmjl
        psCa9WlNvrGOydo0scpNrLY=
X-Google-Smtp-Source: ABdhPJxuc0zmXzYGZ6XM6G0V+EkCOBbodJPKOHSQfMN/zwBGYbYaqhaDNYmCBnlLS4F/jS1JV090kA==
X-Received: by 2002:a17:90b:3507:: with SMTP id ls7mr1057754pjb.172.1618369970530;
        Tue, 13 Apr 2021 20:12:50 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id d17sm13971605pfo.117.2021.04.13.20.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 20:12:50 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Tobias Wolf <dev-NTEO@vplace.de>, stable@vger.kernel.org
Subject: [PATCH v2 1/8] MIPS: pci-rt2880: fix slot 0 configuration
Date:   Tue, 13 Apr 2021 20:12:33 -0700
Message-Id: <20210414031240.313852-2-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210414031240.313852-1-ilya.lipnitskiy@gmail.com>
References: <20210414031240.313852-1-ilya.lipnitskiy@gmail.com>
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
 arch/mips/pci/pci-rt2880.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/mips/pci/pci-rt2880.c b/arch/mips/pci/pci-rt2880.c
index e1f12e398136..f1538d2be89e 100644
--- a/arch/mips/pci/pci-rt2880.c
+++ b/arch/mips/pci/pci-rt2880.c
@@ -180,7 +180,6 @@ static inline void rt2880_pci_write_u32(unsigned long reg, u32 val)
 
 int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
-	u16 cmd;
 	int irq = -1;
 
 	if (dev->bus->number != 0)
@@ -188,8 +187,6 @@ int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 
 	switch (PCI_SLOT(dev->devfn)) {
 	case 0x00:
-		rt2880_pci_write_u32(PCI_BASE_ADDRESS_0, 0x08000000);
-		(void) rt2880_pci_read_u32(PCI_BASE_ADDRESS_0);
 		break;
 	case 0x11:
 		irq = RT288X_CPU_IRQ_PCI;
@@ -201,16 +198,6 @@ int pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
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
 
@@ -251,6 +238,30 @@ static int rt288x_pci_probe(struct platform_device *pdev)
 
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
+	if (!slot0_init && dev->bus->number == 0) {
+		u16 cmd;
+		u32 bar0;
+
+		slot0_init = true;
+
+		pci_bus_write_config_dword(dev->bus, 0, PCI_BASE_ADDRESS_0,
+					   0x08000000);
+		pci_bus_read_config_dword(dev->bus, 0, PCI_BASE_ADDRESS_0,
+					  &bar0);
+
+		pci_bus_read_config_word(dev->bus, 0, PCI_COMMAND, &cmd);
+		cmd |= PCI_COMMAND_MASTER | PCI_COMMAND_IO | PCI_COMMAND_MEMORY;
+		pci_bus_write_config_word(dev->bus, 0, PCI_COMMAND, cmd);
+	}
+
 	return 0;
 }
 
-- 
2.31.1

