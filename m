Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E213EEF3B0
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 03:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbfKECsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 21:48:15 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:43264 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729863AbfKECsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 21:48:15 -0500
X-IronPort-AV: E=Sophos;i="5.68,269,1569250800"; 
   d="scan'208";a="30832177"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie5.idc.renesas.com with ESMTP; 05 Nov 2019 11:48:13 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id 445524151D53;
        Tue,  5 Nov 2019 11:48:13 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     marek.vasut+renesas@gmail.com, linux-pci@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v3 2/2] PCI: rcar: Fix missing MACCTLR register setting in initialize sequence
Date:   Tue,  5 Nov 2019 11:48:12 +0900
Message-Id: <1572922092-12323-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572922092-12323-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
References: <1572922092-12323-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to the R-Car Gen2/3 manual, "Be sure to write the initial
value (= H'80FF 0000) to MACCTLR before enabling PCIETCTLR.CFINIT".
To avoid unexpected behaviors, this patch fixes it. Note that
the SPCHG bit of MACCTLR register description said "Only writing 1
is valid and writing 0 is invalid" but this "invalid" means
"ignored", not "prohibited". So, any documentation conflict doesn't
exist about writing the MACCTLR register.

Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in resume_noirq()")
Cc: <stable@vger.kernel.org> # v5.2+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/pci/controller/pcie-rcar.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controller/pcie-rcar.c
index 40d8c54..1bfec1f 100644
--- a/drivers/pci/controller/pcie-rcar.c
+++ b/drivers/pci/controller/pcie-rcar.c
@@ -91,8 +91,12 @@
 #define  LINK_SPEED_2_5GTS	(1 << 16)
 #define  LINK_SPEED_5_0GTS	(2 << 16)
 #define MACCTLR			0x011058
+#define  MACCTLR_RESERVED23_16	GENMASK(23, 16)
 #define  SPEED_CHANGE		BIT(24)
 #define  SCRAMBLE_DISABLE	BIT(27)
+#define  LTSMDIS		BIT(31)
+	 /* Be sure to write the initial value (H'80FF 0000) to MACCTLR */
+#define  MACCTLR_INIT_VAL	(LTSMDIS | MACCTLR_RESERVED23_16)
 #define PMSR			0x01105c
 #define MACS2R			0x011078
 #define MACCGSPSETR		0x011084
@@ -613,6 +617,8 @@ static int rcar_pcie_hw_init(struct rcar_pcie *pcie)
 	if (IS_ENABLED(CONFIG_PCI_MSI))
 		rcar_pci_write_reg(pcie, 0x801f0000, PCIEMSITXR);
 
+	rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
+
 	/* Finish initialization - establish a PCI Express link */
 	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
 
@@ -1235,6 +1241,7 @@ static int rcar_pcie_resume_noirq(struct device *dev)
 		return 0;
 
 	/* Re-establish the PCIe link */
+	rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
 	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
 	return rcar_pcie_wait_for_dl(pcie);
 }
-- 
2.7.4

