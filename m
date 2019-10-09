Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFDFD0D5E
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 13:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730546AbfJILEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 07:04:49 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:6182 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729942AbfJILEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 07:04:49 -0400
X-IronPort-AV: E=Sophos;i="5.67,273,1566831600"; 
   d="scan'208";a="28464361"
Received: from unknown (HELO relmlir6.idc.renesas.com) ([10.200.68.152])
  by relmlie6.idc.renesas.com with ESMTP; 09 Oct 2019 20:04:47 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir6.idc.renesas.com (Postfix) with ESMTP id F361441E3681;
        Wed,  9 Oct 2019 20:04:46 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     horms@verge.net.au, linux-pci@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v3] PCI: rcar: Fix missing MACCTLR register setting in rcar_pcie_hw_init()
Date:   Wed,  9 Oct 2019 20:04:46 +0900
Message-Id: <1570619086-30088-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to the R-Car Gen2/3 manual, the bit 0 of MACCTLR register
should be written to 0 before enabling PCIETCTLR.CFINIT because
the bit 0 is set to 1 on reset. To avoid unexpected behaviors from
this incorrect setting, this patch fixes it.

Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
Cc: <stable@vger.kernel.org> # v3.16+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Changes from v2:
 - Change the subject.
 - Fix commit log again.
 - Add the register setting into the initialization, instead of speedup.
 - Change commit hash/target version on Fixes and Cc stable tags.
 - Add Geert-san's Reviewed-by.
 https://patchwork.kernel.org/patch/11180429/

 Changes from v1:
 - Fix commit log.
 - Add Sergei-san's Reviewed-by.
 https://patchwork.kernel.org/patch/11179279/

 drivers/pci/controller/pcie-rcar.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controller/pcie-rcar.c
index f6a669a..8d0798c 100644
--- a/drivers/pci/controller/pcie-rcar.c
+++ b/drivers/pci/controller/pcie-rcar.c
@@ -93,6 +93,7 @@
 #define  LINK_SPEED_2_5GTS	(1 << 16)
 #define  LINK_SPEED_5_0GTS	(2 << 16)
 #define MACCTLR			0x011058
+#define  MACCTLR_RESERVED	BIT(0)
 #define  SPEED_CHANGE		BIT(24)
 #define  SCRAMBLE_DISABLE	BIT(27)
 #define PMSR			0x01105c
@@ -615,6 +616,8 @@ static int rcar_pcie_hw_init(struct rcar_pcie *pcie)
 	if (IS_ENABLED(CONFIG_PCI_MSI))
 		rcar_pci_write_reg(pcie, 0x801f0000, PCIEMSITXR);
 
+	rcar_rmw32(pcie, MACCTLR, MACCTLR_RESERVED, 0);
+
 	/* Finish initialization - establish a PCI Express link */
 	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
 
-- 
2.7.4

