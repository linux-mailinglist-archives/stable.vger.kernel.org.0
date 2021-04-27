Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081D736CF48
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 01:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbhD0XOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 19:14:50 -0400
Received: from dd20004.kasserver.com ([85.13.150.92]:59908 "EHLO
        dd20004.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236547AbhD0XOs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Apr 2021 19:14:48 -0400
X-Greylist: delayed 455 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Apr 2021 19:14:46 EDT
Received: from timo-desktop.lan.xusig.net (i59F5205F.versanet.de [89.245.32.95])
        by dd20004.kasserver.com (Postfix) with ESMTPSA id 320575458868;
        Wed, 28 Apr 2021 01:06:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=silentcreek.de;
        s=kas202012291009; t=1619564785;
        bh=KTmAKZe1QU9CWTUWzvq+taFcNdmDF1IaeY/2hBlJl/o=;
        h=From:To:Cc:Subject:Date:From;
        b=I1OrQ3FPJ37iyguIGG9SRw1g6510jpBKXWy7ijohO+hM2+CmIeKsGBBVJsKVnlUGV
         4TptB6l1p+/GY374PiHI+9tLhsIX5nXvx+eiWTUJzEicUrcXrGmWNTyIxe/PTyBkGE
         yw6ZHOBpPDm3e0H4eyKevt8jjmGRV4a+ppw5wKVVJf59z+Ja9BH/3Tq8ugSQOn8oDh
         ujpdyCIke0Ll+r3nnstxiYYCdwual47Am4YvVD8vAp/U+gMY5NotH37nqaaj6NARBX
         /NdmuJz1vHCNDBisOF72U+qbaXXe37iJQ+so1Ot2HJundx95dvRMvR+mYWcK+Uhtj0
         0Zb/bBFSzHR9A==
From:   Timo Sigurdsson <public_timo.s@silentcreek.de>
To:     axboe@kernel.dk, mripard@kernel.org, wens@csie.org,
        jernej.skrabec@siol.net, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Cc:     oliver@schinagl.nl, stable@vger.kernel.org,
        Timo Sigurdsson <public_timo.s@silentcreek.de>
Subject: [PATCH] ata: ahci_sunxi: Disable DIPM
Date:   Wed, 28 Apr 2021 01:05:37 +0200
Message-Id: <20210427230537.21423-1-public_timo.s@silentcreek.de>
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
supported. But even if it were, it should be considered broken and best be
disabled in the ahci_sunxi driver.

Fixes: c5754b5220f0 ("ARM: sunxi: Add support for Allwinner SUNXi SoCs sata to ahci_platform")

[1] https://github.com/allwinner-zh/documents/tree/master/

Signed-off-by: Timo Sigurdsson <public_timo.s@silentcreek.de>
Tested-by: Timo Sigurdsson <public_timo.s@silentcreek.de>
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

