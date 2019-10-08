Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEAF3CF6DF
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 12:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729958AbfJHKSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 06:18:07 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:4760 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730118AbfJHKSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 06:18:07 -0400
X-IronPort-AV: E=Sophos;i="5.67,270,1566831600"; 
   d="scan'208";a="28576496"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 08 Oct 2019 19:18:05 +0900
Received: from localhost.localdomain (unknown [10.166.17.210])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 32BF3400C0B0;
        Tue,  8 Oct 2019 19:18:05 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     horms@verge.net.au, linux-pci@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH] PCI: rcar: Fix writing the MACCTLR register value
Date:   Tue,  8 Oct 2019 19:18:04 +0900
Message-Id: <1570529884-20888-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

According to the R-Car Gen2/3 manual, the bit 0 of MACCTLR register
should be written by 0. To avoid unexpected behaviors from this
incorrect setting, this patch fixes it.

Fixes: b3327f7fae66 ("PCI: rcar: Try increasing PCIe link speed to 5 GT/s at boot")
Cc: <stable@vger.kernel.org> # v4.9+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
---
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

