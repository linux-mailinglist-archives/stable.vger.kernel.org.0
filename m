Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA25AD0634
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 06:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbfJIEDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 00:03:15 -0400
Received: from relmlor2.renesas.com ([210.160.252.172]:10359 "EHLO
        relmlie6.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726490AbfJIEDO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 00:03:14 -0400
X-IronPort-AV: E=Sophos;i="5.67,273,1566831600"; 
   d="scan'208";a="28424477"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie6.idc.renesas.com with ESMTP; 09 Oct 2019 13:03:11 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id CF2584006181;
        Wed,  9 Oct 2019 13:03:11 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     horms@verge.net.au, linux-pci@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH v2] PCI: rcar: Fix writing the MACCTLR register value
Date:   Wed,  9 Oct 2019 13:03:11 +0900
Message-Id: <1570593791-6958-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to the R-Car Gen2/3 manual, the bit 0 of MACCTLR register
should be written to 0 because the register is set to 1 on reset.
To avoid unexpected behaviors from this incorrect setting, this
patch fixes it.

Fixes: b3327f7fae66 ("PCI: rcar: Try increasing PCIe link speed to 5 GT/s at boot")
Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
---
 Changes from v1:
 - Fix commit log.
 - Add Sergei-san's Reviewed-by.
 https://patchwork.kernel.org/patch/11179279/

 drivers/pci/controller/pcie-rcar.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controller/pcie-rcar.c
index f6a669a..9eb9b25 100644
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
@@ -427,7 +428,8 @@ static void rcar_pcie_force_speedup(struct rcar_pcie *pcie)
 		rcar_pci_write_reg(pcie, macsr, MACSR);
 
 	/* Start link speed change */
-	rcar_rmw32(pcie, MACCTLR, SPEED_CHANGE, SPEED_CHANGE);
+	rcar_rmw32(pcie, MACCTLR, SPEED_CHANGE | MACCTLR_RESERVED,
+		   SPEED_CHANGE);
 
 	while (timeout--) {
 		macsr = rcar_pci_read_reg(pcie, MACSR);
-- 
2.7.4

