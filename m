Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0FDC3B62DB
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234169AbhF1OuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236212AbhF1Oq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:46:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 741D461D19;
        Mon, 28 Jun 2021 14:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890878;
        bh=Xg3ckCh4MrK9PKspTRjU2MM4Mq3C/p5v9MLKyXw03lI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlxYnJbO1eA7MUKq6/S0BL1e91HVVR6ybIX+aWIlsQlX/2gHubP4ol3fk5UI1IA3A
         mQXCX2ZdgZhIGB4N6yNTAcbatiemxkL+PCyIYMXJ36ydJ2gZf6fTT54aDsBxJPPWxl
         alp7jjpPtldkS/dFTKnKRUQsmML2wBJlK+3AHvS2FgXu2zrGhoTjnTS2/VFLeaNUvC
         BHjhyaplotBVFwdIvfbGV3ukAA3gv9IrF9N9wYuISG6tmUtt18KaaFqd1gwo9TEY4l
         hHSYHau1lqFIpCSShi9qSk1dWM2ECvky8nxrscbFJuLglCqyjIz4gdkZsilgYm8Fyq
         ymJVoNbLHwM+w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikel Rychliski <mikel@mikelr.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/109] PCI: Add AMD RS690 quirk to enable 64-bit DMA
Date:   Mon, 28 Jun 2021 10:33:00 -0400
Message-Id: <20210628143305.32978-105-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143305.32978-1-sashal@kernel.org>
References: <20210628143305.32978-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.196-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.196-rc1
X-KernelTest-Deadline: 2021-06-30T14:32+00:00
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
index 0c67a5a94de3..76959a7d88c8 100644
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

