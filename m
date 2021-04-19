Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DE136434B
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbhDSNQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:16:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239873AbhDSNOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:14:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC2FA613CE;
        Mon, 19 Apr 2021 13:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837990;
        bh=mVTZ/DVql5tiNk6QWlIhCIbgFMKMkNE/J1DwN+CRZAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LwuXlf1Lx1UB60kLBIMnmM0fLAJaJhSzpXDgtFRr73ECBa9sSndaD9NO6imG06P+c
         cj96cQ8n/PwkYyo9yagr3I1cQZ5NggyY6/4kMOvs9X/SsVWJahcAbx1/NpnBuuk5Yh
         PY9x6Ev7+md15znzJaCP2TPdSDBEsJrAtcwJvXTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 106/122] ARM: footbridge: fix PCI interrupt mapping
Date:   Mon, 19 Apr 2021 15:06:26 +0200
Message-Id: <20210419130533.755180339@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

[ Upstream commit 30e3b4f256b4e366a61658c294f6a21b8626dda7 ]

Since commit 30fdfb929e82 ("PCI: Add a call to pci_assign_irq() in
pci_device_probe()"), the PCI code will call the IRQ mapping function
whenever a PCI driver is probed. If these are marked as __init, this
causes an oops if a PCI driver is loaded or bound after the kernel has
initialised.

Fixes: 30fdfb929e82 ("PCI: Add a call to pci_assign_irq() in pci_device_probe()")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-footbridge/cats-pci.c      | 4 ++--
 arch/arm/mach-footbridge/ebsa285-pci.c   | 4 ++--
 arch/arm/mach-footbridge/netwinder-pci.c | 2 +-
 arch/arm/mach-footbridge/personal-pci.c  | 5 ++---
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-footbridge/cats-pci.c b/arch/arm/mach-footbridge/cats-pci.c
index 0b2fd7e2e9b4..90b1e9be430e 100644
--- a/arch/arm/mach-footbridge/cats-pci.c
+++ b/arch/arm/mach-footbridge/cats-pci.c
@@ -15,14 +15,14 @@
 #include <asm/mach-types.h>
 
 /* cats host-specific stuff */
-static int irqmap_cats[] __initdata = { IRQ_PCI, IRQ_IN0, IRQ_IN1, IRQ_IN3 };
+static int irqmap_cats[] = { IRQ_PCI, IRQ_IN0, IRQ_IN1, IRQ_IN3 };
 
 static u8 cats_no_swizzle(struct pci_dev *dev, u8 *pin)
 {
 	return 0;
 }
 
-static int __init cats_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+static int cats_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	if (dev->irq >= 255)
 		return -1;	/* not a valid interrupt. */
diff --git a/arch/arm/mach-footbridge/ebsa285-pci.c b/arch/arm/mach-footbridge/ebsa285-pci.c
index 6f28aaa9ca79..c3f280d08fa7 100644
--- a/arch/arm/mach-footbridge/ebsa285-pci.c
+++ b/arch/arm/mach-footbridge/ebsa285-pci.c
@@ -14,9 +14,9 @@
 #include <asm/mach/pci.h>
 #include <asm/mach-types.h>
 
-static int irqmap_ebsa285[] __initdata = { IRQ_IN3, IRQ_IN1, IRQ_IN0, IRQ_PCI };
+static int irqmap_ebsa285[] = { IRQ_IN3, IRQ_IN1, IRQ_IN0, IRQ_PCI };
 
-static int __init ebsa285_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+static int ebsa285_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	if (dev->vendor == PCI_VENDOR_ID_CONTAQ &&
 	    dev->device == PCI_DEVICE_ID_CONTAQ_82C693)
diff --git a/arch/arm/mach-footbridge/netwinder-pci.c b/arch/arm/mach-footbridge/netwinder-pci.c
index 9473aa0305e5..e8304392074b 100644
--- a/arch/arm/mach-footbridge/netwinder-pci.c
+++ b/arch/arm/mach-footbridge/netwinder-pci.c
@@ -18,7 +18,7 @@
  * We now use the slot ID instead of the device identifiers to select
  * which interrupt is routed where.
  */
-static int __init netwinder_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
+static int netwinder_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	switch (slot) {
 	case 0:  /* host bridge */
diff --git a/arch/arm/mach-footbridge/personal-pci.c b/arch/arm/mach-footbridge/personal-pci.c
index 4391e433a4b2..9d19aa98a663 100644
--- a/arch/arm/mach-footbridge/personal-pci.c
+++ b/arch/arm/mach-footbridge/personal-pci.c
@@ -14,13 +14,12 @@
 #include <asm/mach/pci.h>
 #include <asm/mach-types.h>
 
-static int irqmap_personal_server[] __initdata = {
+static int irqmap_personal_server[] = {
 	IRQ_IN0, IRQ_IN1, IRQ_IN2, IRQ_IN3, 0, 0, 0,
 	IRQ_DOORBELLHOST, IRQ_DMA1, IRQ_DMA2, IRQ_PCI
 };
 
-static int __init personal_server_map_irq(const struct pci_dev *dev, u8 slot,
-	u8 pin)
+static int personal_server_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	unsigned char line;
 
-- 
2.30.2



