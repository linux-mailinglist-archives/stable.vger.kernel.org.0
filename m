Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD81013E4
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfKSF2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:28:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728874AbfKSF2Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:28:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04A17222DC;
        Tue, 19 Nov 2019 05:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141295;
        bh=61Zi68SLTQlqqIhEFxVkIGJTkP0MJg3PyoENUJb2L+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRgi+yPzjJ6ebRIg5waorpnE1H+oPYYrmHkO5VBgUG14pMl+eBMfMVQHL4lFpci+E
         1QW3Zr0Ft3JdffZH5jM0S197lul1pXjDev1mhymBEzA/SUKgjGyY+6iMAxgJJ7B9XU
         rewUpAIbYoYzDCMlKmMmlItTuYNaoJtBOTKsYmKs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 113/422] mtd: rawnand: fsl_ifc: check result of SRAM initialization
Date:   Tue, 19 Nov 2019 06:15:10 +0100
Message-Id: <20191119051406.435013026@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

[ Upstream commit 434655af6a187129d8114640443b27d2cecfb979 ]

The SRAM initialization might fail. If that happens further NAND operations
won't be successful. Therefore, the chip init routine should fail if the SRAM
initialization didn't work.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/fsl_ifc_nand.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/fsl_ifc_nand.c b/drivers/mtd/nand/raw/fsl_ifc_nand.c
index 24f59d0066afd..e4f5792dc5893 100644
--- a/drivers/mtd/nand/raw/fsl_ifc_nand.c
+++ b/drivers/mtd/nand/raw/fsl_ifc_nand.c
@@ -761,7 +761,7 @@ static const struct nand_controller_ops fsl_ifc_controller_ops = {
 	.attach_chip = fsl_ifc_attach_chip,
 };
 
-static void fsl_ifc_sram_init(struct fsl_ifc_mtd *priv)
+static int fsl_ifc_sram_init(struct fsl_ifc_mtd *priv)
 {
 	struct fsl_ifc_ctrl *ctrl = priv->ctrl;
 	struct fsl_ifc_runtime __iomem *ifc_runtime = ctrl->rregs;
@@ -805,12 +805,16 @@ static void fsl_ifc_sram_init(struct fsl_ifc_mtd *priv)
 	wait_event_timeout(ctrl->nand_wait, ctrl->nand_stat,
 			   msecs_to_jiffies(IFC_TIMEOUT_MSECS));
 
-	if (ctrl->nand_stat != IFC_NAND_EVTER_STAT_OPC)
+	if (ctrl->nand_stat != IFC_NAND_EVTER_STAT_OPC) {
 		pr_err("fsl-ifc: Failed to Initialise SRAM\n");
+		return -ETIMEDOUT;
+	}
 
 	/* Restore CSOR and CSOR_ext */
 	ifc_out32(csor, &ifc_global->csor_cs[cs].csor);
 	ifc_out32(csor_ext, &ifc_global->csor_cs[cs].csor_ext);
+
+	return 0;
 }
 
 static int fsl_ifc_chip_init(struct fsl_ifc_mtd *priv)
@@ -914,8 +918,13 @@ static int fsl_ifc_chip_init(struct fsl_ifc_mtd *priv)
 		chip->ecc.algo = NAND_ECC_HAMMING;
 	}
 
-	if (ctrl->version >= FSL_IFC_VERSION_1_1_0)
-		fsl_ifc_sram_init(priv);
+	if (ctrl->version >= FSL_IFC_VERSION_1_1_0) {
+		int ret;
+
+		ret = fsl_ifc_sram_init(priv);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * As IFC version 2.0.0 has 16KB of internal SRAM as compared to older
-- 
2.20.1



