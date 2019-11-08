Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2BA0F4A84
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388212AbfKHLj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:39:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388183AbfKHLj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 453EC21D6C;
        Fri,  8 Nov 2019 11:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213196;
        bh=ofw07OPqfVsTRQQpssHKxW1SwJBvUUdFDL1NMDfnIdA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBiG0uBxazGFtRFuaUCFSTQ4fSHmZRCZS7LK+gtflVD1BkAARbIt7muvhwjn8YyH5
         fFE4lZvXe32ycyjjCenjcZUHOmzRbFbnUAEEXw0NkXxVWTlORWtNMFnI0qhri5oJiu
         rMslqiWrStRvpvub8bISHClF+JcjSTrQvg9fyt7g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kurt Kanzenbach <kurt@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-mtd@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 082/205] mtd: rawnand: fsl_ifc: fixup SRAM init for newer ctrl versions
Date:   Fri,  8 Nov 2019 06:35:49 -0500
Message-Id: <20191108113752.12502-82-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit ff8648f29fe58c2d94d32a076d2de7b92be4b485 ]

Newer versions of the IFC controller use a different method of initializing the
internal SRAM: Instead of reading from flash, a bit in the NAND configuration
register has to be set in order to trigger the self-initializing process.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/fsl_ifc_nand.c | 33 +++++++++++++++++++++++------
 include/linux/fsl_ifc.h             |  2 ++
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/nand/raw/fsl_ifc_nand.c b/drivers/mtd/nand/raw/fsl_ifc_nand.c
index e4f5792dc5893..7e7729df78278 100644
--- a/drivers/mtd/nand/raw/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/raw/fsl_ifc_nand.c
@@ -30,6 +30,7 @@
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/nand_ecc.h>
 #include <linux/fsl_ifc.h>
+#include <linux/iopoll.h>
 
 #define ERR_BYTE		0xFF /* Value returned for read
 					bytes when read failed	*/
@@ -769,6 +770,27 @@ static int fsl_ifc_sram_init(struct fsl_ifc_mtd *priv)
 	uint32_t csor = 0, csor_8k = 0, csor_ext = 0;
 	uint32_t cs = priv->bank;
 
+	if (ctrl->version < FSL_IFC_VERSION_1_1_0)
+		return 0;
+
+	if (ctrl->version > FSL_IFC_VERSION_1_1_0) {
+		u32 ncfgr, status;
+		int ret;
+
+		/* Trigger auto initialization */
+		ncfgr = ifc_in32(&ifc_runtime->ifc_nand.ncfgr);
+		ifc_out32(ncfgr | IFC_NAND_NCFGR_SRAM_INIT_EN, &ifc_runtime->ifc_nand.ncfgr);
+
+		/* Wait until done */
+		ret = readx_poll_timeout(ifc_in32, &ifc_runtime->ifc_nand.ncfgr,
+					 status, !(status & IFC_NAND_NCFGR_SRAM_INIT_EN),
+					 10, IFC_TIMEOUT_MSECS * 1000);
+		if (ret)
+			dev_err(priv->dev, "Failed to initialize SRAM!\n");
+
+		return ret;
+	}
+
 	/* Save CSOR and CSOR_ext */
 	csor = ifc_in32(&ifc_global->csor_cs[cs].csor);
 	csor_ext = ifc_in32(&ifc_global->csor_cs[cs].csor_ext);
@@ -825,6 +847,7 @@ static int fsl_ifc_chip_init(struct fsl_ifc_mtd *priv)
 	struct nand_chip *chip = &priv->chip;
 	struct mtd_info *mtd = nand_to_mtd(&priv->chip);
 	u32 csor;
+	int ret;
 
 	/* Fill in fsl_ifc_mtd structure */
 	mtd->dev.parent = priv->dev;
@@ -918,13 +941,9 @@ static int fsl_ifc_chip_init(struct fsl_ifc_mtd *priv)
 		chip->ecc.algo = NAND_ECC_HAMMING;
 	}
 
-	if (ctrl->version >= FSL_IFC_VERSION_1_1_0) {
-		int ret;
-
-		ret = fsl_ifc_sram_init(priv);
-		if (ret)
-			return ret;
-	}
+	ret = fsl_ifc_sram_init(priv);
+	if (ret)
+		return ret;
 
 	/*
 	 * As IFC version 2.0.0 has 16KB of internal SRAM as compared to older
diff --git a/include/linux/fsl_ifc.h b/include/linux/fsl_ifc.h
index 3fdfede2f0f3e..5f343b796ad95 100644
--- a/include/linux/fsl_ifc.h
+++ b/include/linux/fsl_ifc.h
@@ -274,6 +274,8 @@
  */
 /* Auto Boot Mode */
 #define IFC_NAND_NCFGR_BOOT		0x80000000
+/* SRAM Initialization */
+#define IFC_NAND_NCFGR_SRAM_INIT_EN	0x20000000
 /* Addressing Mode-ROW0+n/COL0 */
 #define IFC_NAND_NCFGR_ADDR_MODE_RC0	0x00000000
 /* Addressing Mode-ROW0+n/COL0+n */
-- 
2.20.1

