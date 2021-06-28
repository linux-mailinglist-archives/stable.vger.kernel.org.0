Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35133B6021
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbhF1OWP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233238AbhF1OVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:21:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8ED6961C87;
        Mon, 28 Jun 2021 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889958;
        bh=mhDHTAAZ4nKLxUl2wPcuv746/b/8WFTJ+qLnCbvApbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lO31unIY6rBkYR4bK5k5tiMaB3mG1t0RBCar8WkN7nDLyVzjmRPnCcjRwQI+y1KOx
         f42gQtdzsLkww+rH2Q/ECMHw+mkAuhWGAvzccrX8TpjO1X5AeDdNa2RcFO1FB6qPBz
         W9J9iPKum+5pj7AHJ9FbjvDaDTuVLUZdADkSvAGduQ52G5L8kbVNKQFfGbCDOXTzRG
         dGzm/MBQswXkVf3GeGaZUp2JXC2alrnHqY6XkkzyF2SwxXLlg2dP40unZcGhNbde5Q
         Wh/0pJtTCs83coSKM2Oth3qVa7TEHiJ3tC5XrrvSNlCXpq4p1lNTW5bNJD8DT9sLHf
         hQHN18VgsT3wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikel Rychliski <mikel@mikelr.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 057/110] PCI: Add AMD RS690 quirk to enable 64-bit DMA
Date:   Mon, 28 Jun 2021 10:17:35 -0400
Message-Id: <20210628141828.31757-58-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikel Rychliski <mikel@mikelr.com>

[ Upstream commit cacf994a91d3a55c0c2f853d6429cd7b86113915 ]

Although the AMD RS690 chipset has 64-bit DMA support, BIOS implementations
sometimes fail to configure the memory limit registers correctly.

The Acer F690GVM mainboard uses this chipset and a Marvell 88E8056 NIC. The
sky2 driver programs the NIC to use 64-bit DMA, which will not work:

  sky2 0000:02:00.0: error interrupt status=0x8
  sky2 0000:02:00.0 eth0: tx timeout
  sky2 0000:02:00.0 eth0: transmit ring 0 .. 22 report=0 done=0

Other drivers required by this mainboard either don't support 64-bit DMA,
or have it disabled using driver specific quirks. For example, the ahci
driver has quirks to enable or disable 64-bit DMA depending on the BIOS
version (see ahci_sb600_enable_64bit() in ahci.c). This ahci quirk matches
against the SB600 SATA controller, but the real issue is almost certainly
with the RS690 PCI host that it was commonly attached to.

To avoid this issue in all drivers with 64-bit DMA support, fix the
configuration of the PCI host. If the kernel is aware of physical memory
above 4GB, but the BIOS never configured the PCI host with this
information, update the registers with our values.

[bhelgaas: drop PCI_DEVICE_ID_ATI_RS690 definition]
Link: https://lore.kernel.org/r/20210611214823.4898-1-mikel@mikelr.com
Signed-off-by: Mikel Rychliski <mikel@mikelr.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/fixup.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 0a0e168be1cb..9b0e771302ce 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -779,4 +779,48 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1571, pci_amd_enable_64bit_bar);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x15b1, pci_amd_enable_64bit_bar);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1601, pci_amd_enable_64bit_bar);
 
+#define RS690_LOWER_TOP_OF_DRAM2	0x30
+#define RS690_LOWER_TOP_OF_DRAM2_VALID	0x1
+#define RS690_UPPER_TOP_OF_DRAM2	0x31
+#define RS690_HTIU_NB_INDEX		0xA8
+#define RS690_HTIU_NB_INDEX_WR_ENABLE	0x100
+#define RS690_HTIU_NB_DATA		0xAC
+
+/*
+ * Some BIOS implementations support RAM above 4GB, but do not configure the
+ * PCI host to respond to bus master accesses for these addresses. These
+ * implementations set the TOP_OF_DRAM_SLOT1 register correctly, so PCI DMA
+ * works as expected for addresses below 4GB.
+ *
+ * Reference: "AMD RS690 ASIC Family Register Reference Guide" (pg. 2-57)
+ * https://www.amd.com/system/files/TechDocs/43372_rs690_rrg_3.00o.pdf
+ */
+static void rs690_fix_64bit_dma(struct pci_dev *pdev)
+{
+	u32 val = 0;
+	phys_addr_t top_of_dram = __pa(high_memory - 1) + 1;
+
+	if (top_of_dram <= (1ULL << 32))
+		return;
+
+	pci_write_config_dword(pdev, RS690_HTIU_NB_INDEX,
+				RS690_LOWER_TOP_OF_DRAM2);
+	pci_read_config_dword(pdev, RS690_HTIU_NB_DATA, &val);
+
+	if (val)
+		return;
+
+	pci_info(pdev, "Adjusting top of DRAM to %pa for 64-bit DMA support\n", &top_of_dram);
+
+	pci_write_config_dword(pdev, RS690_HTIU_NB_INDEX,
+		RS690_UPPER_TOP_OF_DRAM2 | RS690_HTIU_NB_INDEX_WR_ENABLE);
+	pci_write_config_dword(pdev, RS690_HTIU_NB_DATA, top_of_dram >> 32);
+
+	pci_write_config_dword(pdev, RS690_HTIU_NB_INDEX,
+		RS690_LOWER_TOP_OF_DRAM2 | RS690_HTIU_NB_INDEX_WR_ENABLE);
+	pci_write_config_dword(pdev, RS690_HTIU_NB_DATA,
+		top_of_dram | RS690_LOWER_TOP_OF_DRAM2_VALID);
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7910, rs690_fix_64bit_dma);
+
 #endif
-- 
2.30.2

