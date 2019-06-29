Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773265A803
	for <lists+stable@lfdr.de>; Sat, 29 Jun 2019 03:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfF2BYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 21:24:31 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:41532 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfF2BYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 21:24:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1561771469; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=JORYQDkjxc8DqLmFxNTlEoAuKTGQtHsRV1UcYYJiQrw=;
        b=RKq2QYwOg8PlXAJDDnK13ML+2JqEHBTmSAc4rE41tPTYzXicW022n1KrbJcmRiodgfd12h
        A71Gr3yaojtVsF3tnVfCYc4m7Im6MSW5C1Ec2G0iz4t74KkpobmjFy9kr/BsWWCCjoM4H0
        HjbTNnSR+5gg8bnx7jquJhr06jfgqiM=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>, od@zcrc.me,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>,
        Arnd Bergmann <arnd@arndb.de>, Hulk Robot <hulkci@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>, stable@vger.kernel.org
Subject: [PATCH] mtd: rawnand: ingenic: Fix ingenic_ecc dependency
Date:   Sat, 29 Jun 2019 03:22:48 +0200
Message-Id: <20190629012248.12447-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If MTD_NAND_JZ4780 is y and MTD_NAND_JZ4780_BCH is m,
which select CONFIG_MTD_NAND_INGENIC_ECC to m, building fails:

drivers/mtd/nand/raw/ingenic/ingenic_nand.o: In function `ingenic_nand_remove':
ingenic_nand.c:(.text+0x177): undefined reference to `ingenic_ecc_release'
drivers/mtd/nand/raw/ingenic/ingenic_nand.o: In function `ingenic_nand_ecc_correct':
ingenic_nand.c:(.text+0x2ee): undefined reference to `ingenic_ecc_correct'

To fix that, the ingenic_nand and ingenic_ecc modules have been fused
into one single module.
- The ingenic_ecc.c code is now compiled in only if
  $(CONFIG_MTD_NAND_INGENIC_ECC) is set. This is now a boolean instead
  of tristate.
- To avoid changing the module name, the ingenic_nand.c file is moved to
  ingenic_nand_drv.c. Then the module name is still ingenic_nand.
- Since ingenic_ecc.c is no more a module, the module-specific macros
  have been dropped, and the functions are no more exported for use by
  the ingenic_nand driver.

Fixes: 15de8c6efd0e ("mtd: rawnand: ingenic: Separate top-level and SoC specific code")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: YueHaibing <yuehaibing@huawei.com>
Cc: stable@vger.kernel.org
---
 drivers/mtd/nand/raw/ingenic/Kconfig                     | 2 +-
 drivers/mtd/nand/raw/ingenic/Makefile                    | 4 +++-
 drivers/mtd/nand/raw/ingenic/ingenic_ecc.c               | 9 ---------
 .../raw/ingenic/{ingenic_nand.c => ingenic_nand_drv.c}   | 0
 4 files changed, 4 insertions(+), 11 deletions(-)
 rename drivers/mtd/nand/raw/ingenic/{ingenic_nand.c => ingenic_nand_drv.c} (100%)

diff --git a/drivers/mtd/nand/raw/ingenic/Kconfig b/drivers/mtd/nand/raw/ingenic/Kconfig
index 19a96ce515c1..66b7cffdb0c2 100644
--- a/drivers/mtd/nand/raw/ingenic/Kconfig
+++ b/drivers/mtd/nand/raw/ingenic/Kconfig
@@ -16,7 +16,7 @@ config MTD_NAND_JZ4780
 if MTD_NAND_JZ4780
 
 config MTD_NAND_INGENIC_ECC
-	tristate
+	bool
 
 config MTD_NAND_JZ4740_ECC
 	tristate "Hardware BCH support for JZ4740 SoC"
diff --git a/drivers/mtd/nand/raw/ingenic/Makefile b/drivers/mtd/nand/raw/ingenic/Makefile
index 1ac4f455baea..b63d36889263 100644
--- a/drivers/mtd/nand/raw/ingenic/Makefile
+++ b/drivers/mtd/nand/raw/ingenic/Makefile
@@ -2,7 +2,9 @@
 obj-$(CONFIG_MTD_NAND_JZ4740) += jz4740_nand.o
 obj-$(CONFIG_MTD_NAND_JZ4780) += ingenic_nand.o
 
-obj-$(CONFIG_MTD_NAND_INGENIC_ECC) += ingenic_ecc.o
+ingenic_nand-y += ingenic_nand_drv.o
+ingenic_nand-$(CONFIG_MTD_NAND_INGENIC_ECC) += ingenic_ecc.o
+
 obj-$(CONFIG_MTD_NAND_JZ4740_ECC) += jz4740_ecc.o
 obj-$(CONFIG_MTD_NAND_JZ4725B_BCH) += jz4725b_bch.o
 obj-$(CONFIG_MTD_NAND_JZ4780_BCH) += jz4780_bch.o
diff --git a/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c b/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
index d3e085c5685a..c954189606f6 100644
--- a/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
+++ b/drivers/mtd/nand/raw/ingenic/ingenic_ecc.c
@@ -30,7 +30,6 @@ int ingenic_ecc_calculate(struct ingenic_ecc *ecc,
 {
 	return ecc->ops->calculate(ecc, params, buf, ecc_code);
 }
-EXPORT_SYMBOL(ingenic_ecc_calculate);
 
 /**
  * ingenic_ecc_correct() - detect and correct bit errors
@@ -51,7 +50,6 @@ int ingenic_ecc_correct(struct ingenic_ecc *ecc,
 {
 	return ecc->ops->correct(ecc, params, buf, ecc_code);
 }
-EXPORT_SYMBOL(ingenic_ecc_correct);
 
 /**
  * ingenic_ecc_get() - get the ECC controller device
@@ -111,7 +109,6 @@ struct ingenic_ecc *of_ingenic_ecc_get(struct device_node *of_node)
 	}
 	return ecc;
 }
-EXPORT_SYMBOL(of_ingenic_ecc_get);
 
 /**
  * ingenic_ecc_release() - release the ECC controller device
@@ -122,7 +119,6 @@ void ingenic_ecc_release(struct ingenic_ecc *ecc)
 	clk_disable_unprepare(ecc->clk);
 	put_device(ecc->dev);
 }
-EXPORT_SYMBOL(ingenic_ecc_release);
 
 int ingenic_ecc_probe(struct platform_device *pdev)
 {
@@ -159,8 +155,3 @@ int ingenic_ecc_probe(struct platform_device *pdev)
 	return 0;
 }
 EXPORT_SYMBOL(ingenic_ecc_probe);
-
-MODULE_AUTHOR("Alex Smith <alex@alex-smith.me.uk>");
-MODULE_AUTHOR("Harvey Hunt <harveyhuntnexus@gmail.com>");
-MODULE_DESCRIPTION("Ingenic ECC common driver");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/mtd/nand/raw/ingenic/ingenic_nand.c b/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
similarity index 100%
rename from drivers/mtd/nand/raw/ingenic/ingenic_nand.c
rename to drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
-- 
2.21.0.593.g511ec345e18

