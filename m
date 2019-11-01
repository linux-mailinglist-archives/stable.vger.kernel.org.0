Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF53AEBDF7
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 07:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfKAGbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 02:31:32 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:38780 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725798AbfKAGbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Nov 2019 02:31:32 -0400
X-IronPort-AV: E=Sophos;i="5.68,254,1569250800"; 
   d="scan'208";a="30388548"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 01 Nov 2019 15:31:30 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id C03A340104DD;
        Fri,  1 Nov 2019 15:31:30 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     marek.vasut+renesas@gmail.com, linux-pci@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v2 1/2] Revert "PCI: rcar: Fix missing MACCTLR register setting in rcar_pcie_hw_init()"
Date:   Fri,  1 Nov 2019 15:31:29 +0900
Message-Id: <1572589890-8903-2-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572589890-8903-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
References: <1572589890-8903-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 175cc093888ee74a17c4dd5f99ba9a6bc86de5be.

The commit description/code don't follow the manual accurately,
it's difficult to understand. So, this patch reverts the commit.

Fixes: 175cc093888e ("PCI: rcar: Fix missing MACCTLR register setting in rcar_pcie_hw_init()"
Cc: <stable@vger.kernel.org>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
 drivers/pci/controller/pcie-rcar.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controller/pcie-rcar.c
index 0dadccb..40d8c54 100644
--- a/drivers/pci/controller/pcie-rcar.c
+++ b/drivers/pci/controller/pcie-rcar.c
@@ -91,7 +91,6 @@
 #define  LINK_SPEED_2_5GTS	(1 << 16)
 #define  LINK_SPEED_5_0GTS	(2 << 16)
 #define MACCTLR			0x011058
-#define  MACCTLR_RESERVED	BIT(0)
 #define  SPEED_CHANGE		BIT(24)
 #define  SCRAMBLE_DISABLE	BIT(27)
 #define PMSR			0x01105c
@@ -614,8 +613,6 @@ static int rcar_pcie_hw_init(struct rcar_pcie *pcie)
 	if (IS_ENABLED(CONFIG_PCI_MSI))
 		rcar_pci_write_reg(pcie, 0x801f0000, PCIEMSITXR);
 
-	rcar_rmw32(pcie, MACCTLR, MACCTLR_RESERVED, 0);
-
 	/* Finish initialization - establish a PCI Express link */
 	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
 
@@ -1238,7 +1235,6 @@ static int rcar_pcie_resume_noirq(struct device *dev)
 		return 0;
 
 	/* Re-establish the PCIe link */
-	rcar_rmw32(pcie, MACCTLR, MACCTLR_RESERVED, 0);
 	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
 	return rcar_pcie_wait_for_dl(pcie);
 }
-- 
2.7.4

