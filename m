Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD99370735
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 14:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhEAMdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 May 2021 08:33:42 -0400
Received: from dd20004.kasserver.com ([85.13.150.92]:43710 "EHLO
        dd20004.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbhEAMdm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 May 2021 08:33:42 -0400
Received: from timo-desktop.lan.xusig.net (i59F4D773.versanet.de [89.244.215.115])
        by dd20004.kasserver.com (Postfix) with ESMTPSA id AFAD55445A41;
        Sat,  1 May 2021 14:32:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silentcreek.de;
        s=kas202012291009; t=1619872368;
        bh=IKxcCZX8rJ+tqAGbzlech+IDSyJAK5ljTScE45csiAo=;
        h=From:To:Cc:Subject:Date:From;
        b=Nr3MYZdEq2LxVnUjdb7O8S2WU0U9mEiRwYZBhQ3h8l63SBZ8cM0z/90Ay1MV7H/ZF
         mOObXtMNOPMyKG5qg1Y4NwhDZrUs2kK2VstfVzIgxbyGW+R4YVIi1pEwF8gOf6RLUl
         whXbkycZJr2dpwp6sJSI6e+j+fT9e5imaPzkK5QnA7ZcBhrQQ7ukFR0ZPoAdr+5Sh3
         C6wytYw0JW4x6IJFmPj+3BTTF+cXGRQQ2D359LCvfZfkFAIrr8haZjOIE4xfE0kqje
         2ymckCcklQSEKDY3qEmOIpOy5PLpdOsWz0qgRRgcyHbgzal2ngv5obPlejZLVQ0aif
         YPnGc6sPmNGoQ==
From:   Timo Sigurdsson <public_timo.s@silentcreek.de>
To:     timo@silentcreek.de
Cc:     stable@vger.kernel.org
Subject: [PATCH v2] ata: ahci_sunxi: Disable DIPM
Date:   Sat,  1 May 2021 14:32:39 +0200
Message-Id: <20210501123239.7754-1-public_timo.s@silentcreek.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DIPM is unsupported or broken on sunxi. Trying to enable the power
management policy med_power_with_dipm on an Allwinner A20 SoC based board
leads to immediate I/O errors and the attached SATA disk disappears from
the /dev filesystem. A reset (power cycle) is required to make the SATA
controller or disk work again. The A10 and A20 SoC data sheets and manuals
don't mention DIPM at all [1], so it's fair to assume that it's simply not
supported. But even if it was, it should be considered broken and best be
disabled in the ahci_sunxi driver.

[1] https://github.com/allwinner-zh/documents/tree/master/

Fixes: c5754b5220f0 ("ARM: sunxi: Add support for Allwinner SUNXi SoCs sata to ahci_platform")
Cc: stable@vger.kernel.org
Signed-off-by: Timo Sigurdsson <public_timo.s@silentcreek.de>
Tested-by: Timo Sigurdsson <public_timo.s@silentcreek.de>
---
Changes since v1:

- Formal changes to the commit message (Fixes and Cc lines) as suggested
  by Greg Kroah-Hartman and Sergei Shtylyov. No changes to the patch
  itself.
---
 drivers/ata/ahci_sunxi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_sunxi.c b/drivers/ata/ahci_sunxi.c
index cb69b737cb49..56b695136977 100644
--- a/drivers/ata/ahci_sunxi.c
+++ b/drivers/ata/ahci_sunxi.c
@@ -200,7 +200,7 @@ static void ahci_sunxi_start_engine(struct ata_port *ap)
 }
 
 static const struct ata_port_info ahci_sunxi_port_info = {
-	.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
+	.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NCQ | ATA_FLAG_NO_DIPM,
 	.pio_mask	= ATA_PIO4,
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &ahci_platform_ops,
-- 
2.26.2

