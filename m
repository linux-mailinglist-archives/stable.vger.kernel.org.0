Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC70299BED
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410390AbgJZXyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:54:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410384AbgJZXyR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:54:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C629221FC;
        Mon, 26 Oct 2020 23:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756456;
        bh=mhHlSIJfVFrMVT2i0n5BU00tB/vn/oPPP/QuTcSHyKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2+xjUFEjUc7f4Xdas3HNPKTQw3Ba84Laqb+LV4lYjXIKF0EU/kSlQAM66Cf6wyG/
         VAUdRd9pBzcCwNowzekpoCyUr5OuWHHgkinxAiynCC6pkxEd5beQPXfuP+42sx93jM
         WQZtjDpfGrGheiEH6A3Q9HZh17h19KzNcOVBkIcg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        George Cherian <george.cherian@marvell.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 106/132] asm-generic/io.h: Fix !CONFIG_GENERIC_IOMAP pci_iounmap() implementation
Date:   Mon, 26 Oct 2020 19:51:38 -0400
Message-Id: <20201026235205.1023962-106-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>

[ Upstream commit f5810e5c329238b8553ebd98b914bdbefd8e6737 ]

For arches that do not select CONFIG_GENERIC_IOMAP, the current
pci_iounmap() function does nothing causing obvious memory leaks
for mapped regions that are backed by MMIO physical space.

In order to detect if a mapped pointer is IO vs MMIO, a check must made
available to the pci_iounmap() function so that it can actually detect
whether the pointer has to be unmapped.

In configurations where CONFIG_HAS_IOPORT_MAP && !CONFIG_GENERIC_IOMAP,
a mapped port is detected using an ioport_map() stub defined in
asm-generic/io.h.

Use the same logic to implement a stub (ie __pci_ioport_unmap()) that
detects if the passed in pointer in pci_iounmap() is IO vs MMIO to
iounmap conditionally and call it in pci_iounmap() fixing the issue.

Leave __pci_ioport_unmap() as a NOP for all other config options.

Tested-by: George Cherian <george.cherian@marvell.com>
Link: https://lore.kernel.org/lkml/20200905024811.74701-1-yangyingliang@huawei.com
Link: https://lore.kernel.org/lkml/20200824132046.3114383-1-george.cherian@marvell.com
Link: https://lore.kernel.org/r/a9daf8d8444d0ebd00bc6d64e336ec49dbb50784.1600254147.git.lorenzo.pieralisi@arm.com
Reported-by: George Cherian <george.cherian@marvell.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: George Cherian <george.cherian@marvell.com>
Cc: Will Deacon <will@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/io.h | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
index 30a3aab312e6c..89057394e1862 100644
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@ -911,18 +911,6 @@ static inline void iowrite64_rep(volatile void __iomem *addr,
 #include <linux/vmalloc.h>
 #define __io_virt(x) ((void __force *)(x))
 
-#ifndef CONFIG_GENERIC_IOMAP
-struct pci_dev;
-extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
-
-#ifndef pci_iounmap
-#define pci_iounmap pci_iounmap
-static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
-{
-}
-#endif
-#endif /* CONFIG_GENERIC_IOMAP */
-
 /*
  * Change virtual addresses to physical addresses and vv.
  * These are pretty trivial
@@ -1016,6 +1004,16 @@ static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
 	port &= IO_SPACE_LIMIT;
 	return (port > MMIO_UPPER_LIMIT) ? NULL : PCI_IOBASE + port;
 }
+#define __pci_ioport_unmap __pci_ioport_unmap
+static inline void __pci_ioport_unmap(void __iomem *p)
+{
+	uintptr_t start = (uintptr_t) PCI_IOBASE;
+	uintptr_t addr = (uintptr_t) p;
+
+	if (addr >= start && addr < start + IO_SPACE_LIMIT)
+		return;
+	iounmap(p);
+}
 #endif
 
 #ifndef ioport_unmap
@@ -1030,6 +1028,23 @@ extern void ioport_unmap(void __iomem *p);
 #endif /* CONFIG_GENERIC_IOMAP */
 #endif /* CONFIG_HAS_IOPORT_MAP */
 
+#ifndef CONFIG_GENERIC_IOMAP
+struct pci_dev;
+extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
+
+#ifndef __pci_ioport_unmap
+static inline void __pci_ioport_unmap(void __iomem *p) {}
+#endif
+
+#ifndef pci_iounmap
+#define pci_iounmap pci_iounmap
+static inline void pci_iounmap(struct pci_dev *dev, void __iomem *p)
+{
+	__pci_ioport_unmap(p);
+}
+#endif
+#endif /* CONFIG_GENERIC_IOMAP */
+
 /*
  * Convert a virtual cached pointer to an uncached pointer
  */
-- 
2.25.1

