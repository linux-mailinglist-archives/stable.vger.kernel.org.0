Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCF43C3803
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232897AbhGJXxo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:53:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233149AbhGJXxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2DF0D61361;
        Sat, 10 Jul 2021 23:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961023;
        bh=qjAee10GKoNtEd3QJvJ5ofikK7mIpHulu3nelTdmX4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ar1L4cnDHzEyC6rccrXu5CMb5+lNwGfRjKMa4pQzi3ooKyVu8h6yhAwOHqdugvztH
         hNW7WO3YljmmhD3w8CqY4KsRIfJRj3jwxCbyOhPk7/TPHeLSvZYKt2DxMKRLedtMqJ
         Fi0xe/pwuw7MpHqhEv567maGV++zIaUaS1otUdfmbZLCfOqLYDoErN2LSIFawOG9Fn
         l8nAH7Y/1gXD/ts/v9zG7YWb86nUS2/ehfJr6z//gEAshJv2l4RB2uevqfT4JSpD5J
         jjIR8r39RSeIcq5mRo2wKy/2PhR55Su/nLMXBDO9Ca99gP1A0OYfDA0a990tziFI5N
         cFHxAw8Xf/H1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        kernel test robot <lkp@intel.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/37] PCI: ftpci100: Rename macro name collision
Date:   Sat, 10 Jul 2021 19:49:43 -0400
Message-Id: <20210710235016.3221124-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 5be967d5016ac5ffb9c4d0df51b48441ee4d5ed1 ]

PCI_IOSIZE is defined in mach-loongson64/spaces.h, so change the name
of the PCI_* macros in pci-ftpci100.c to use FTPCI_* so that they are
more localized and won't conflict with other drivers or arches.

../drivers/pci/controller/pci-ftpci100.c:37: warning: "PCI_IOSIZE" redefined
   37 | #define PCI_IOSIZE 0x00
      |
In file included from ../arch/mips/include/asm/addrspace.h:13,
...              from ../drivers/pci/controller/pci-ftpci100.c:15:
arch/mips/include/asm/mach-loongson64/spaces.h:11: note: this is the location of the previous definition
   11 | #define PCI_IOSIZE SZ_16M

Suggested-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20210517234117.3660-1-rdunlap@infradead.org
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Krzysztof Wilczyński <kw@linux.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-ftpci100.c | 30 +++++++++++++--------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/controller/pci-ftpci100.c b/drivers/pci/controller/pci-ftpci100.c
index da3cd216da00..aefef1986201 100644
--- a/drivers/pci/controller/pci-ftpci100.c
+++ b/drivers/pci/controller/pci-ftpci100.c
@@ -34,12 +34,12 @@
  * Special configuration registers directly in the first few words
  * in I/O space.
  */
-#define PCI_IOSIZE	0x00
-#define PCI_PROT	0x04 /* AHB protection */
-#define PCI_CTRL	0x08 /* PCI control signal */
-#define PCI_SOFTRST	0x10 /* Soft reset counter and response error enable */
-#define PCI_CONFIG	0x28 /* PCI configuration command register */
-#define PCI_DATA	0x2C
+#define FTPCI_IOSIZE	0x00
+#define FTPCI_PROT	0x04 /* AHB protection */
+#define FTPCI_CTRL	0x08 /* PCI control signal */
+#define FTPCI_SOFTRST	0x10 /* Soft reset counter and response error enable */
+#define FTPCI_CONFIG	0x28 /* PCI configuration command register */
+#define FTPCI_DATA	0x2C
 
 #define FARADAY_PCI_STATUS_CMD		0x04 /* Status and command */
 #define FARADAY_PCI_PMC			0x40 /* Power management control */
@@ -195,9 +195,9 @@ static int faraday_raw_pci_read_config(struct faraday_pci *p, int bus_number,
 			PCI_CONF_FUNCTION(PCI_FUNC(fn)) |
 			PCI_CONF_WHERE(config) |
 			PCI_CONF_ENABLE,
-			p->base + PCI_CONFIG);
+			p->base + FTPCI_CONFIG);
 
-	*value = readl(p->base + PCI_DATA);
+	*value = readl(p->base + FTPCI_DATA);
 
 	if (size == 1)
 		*value = (*value >> (8 * (config & 3))) & 0xFF;
@@ -230,17 +230,17 @@ static int faraday_raw_pci_write_config(struct faraday_pci *p, int bus_number,
 			PCI_CONF_FUNCTION(PCI_FUNC(fn)) |
 			PCI_CONF_WHERE(config) |
 			PCI_CONF_ENABLE,
-			p->base + PCI_CONFIG);
+			p->base + FTPCI_CONFIG);
 
 	switch (size) {
 	case 4:
-		writel(value, p->base + PCI_DATA);
+		writel(value, p->base + FTPCI_DATA);
 		break;
 	case 2:
-		writew(value, p->base + PCI_DATA + (config & 3));
+		writew(value, p->base + FTPCI_DATA + (config & 3));
 		break;
 	case 1:
-		writeb(value, p->base + PCI_DATA + (config & 3));
+		writeb(value, p->base + FTPCI_DATA + (config & 3));
 		break;
 	default:
 		ret = PCIBIOS_BAD_REGISTER_NUMBER;
@@ -469,7 +469,7 @@ static int faraday_pci_probe(struct platform_device *pdev)
 		if (!faraday_res_to_memcfg(io->start - win->offset,
 					   resource_size(io), &val)) {
 			/* setup I/O space size */
-			writel(val, p->base + PCI_IOSIZE);
+			writel(val, p->base + FTPCI_IOSIZE);
 		} else {
 			dev_err(dev, "illegal IO mem size\n");
 			return -EINVAL;
@@ -477,11 +477,11 @@ static int faraday_pci_probe(struct platform_device *pdev)
 	}
 
 	/* Setup hostbridge */
-	val = readl(p->base + PCI_CTRL);
+	val = readl(p->base + FTPCI_CTRL);
 	val |= PCI_COMMAND_IO;
 	val |= PCI_COMMAND_MEMORY;
 	val |= PCI_COMMAND_MASTER;
-	writel(val, p->base + PCI_CTRL);
+	writel(val, p->base + FTPCI_CTRL);
 	/* Mask and clear all interrupts */
 	faraday_raw_pci_write_config(p, 0, 0, FARADAY_PCI_CTRL2 + 2, 2, 0xF000);
 	if (variant->cascaded_irq) {
-- 
2.30.2

