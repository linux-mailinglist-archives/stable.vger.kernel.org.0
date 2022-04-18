Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBCF504C38
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 07:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236615AbiDRFV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 01:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235427AbiDRFV7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 01:21:59 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B64101FF;
        Sun, 17 Apr 2022 22:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1650259161; x=1681795161;
  h=from:to:cc:subject:date:message-id;
  bh=EK+0u9UC8xwiVIg1UZKWQ0D//oOqEbDa4F6BgDV60IE=;
  b=OUyd7fiBYTiox8tDXnwp2U4gR4u5j5Xxljndp1BnEGJ9IrX7DMBVYE85
   ciSb4432N8eLul+yueacglj2iXZRiHKiJw46aQ0q7B+jxReViA84uPrTR
   wF/kouu6ZJjI6Sz6VntuZ3Rs6SBsj3PsUTmwYCeVJvCkKZXu30b1Ovs9+
   A=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 17 Apr 2022 22:19:21 -0700
X-QCInternal: smtphost
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/AES256-SHA; 17 Apr 2022 22:19:19 -0700
X-QCInternal: smtphost
Received: from mdalam-linux.qualcomm.com ([10.201.2.71])
  by ironmsg02-blr.qualcomm.com with ESMTP; 18 Apr 2022 10:49:06 +0530
Received: by mdalam-linux.qualcomm.com (Postfix, from userid 466583)
        id 3BD3A229F2; Mon, 18 Apr 2022 10:49:04 +0530 (IST)
From:   Md Sadre Alam <quic_mdalam@quicinc.com>
To:     mani@kernel.org, miquel.raynal@bootlin.com, richard@nod.at,
        vigneshr@ti.com, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     konrad.dybcio@somainline.org, quic_srichara@quicinc.com,
        quic_mdalam@quicinc.com, stable@vger.kernel.org
Subject: [PATCH V3] mtd: rawnand: qcom: fix memory corruption that causes panic
Date:   Mon, 18 Apr 2022 10:49:01 +0530
Message-Id: <1650259141-20923-1-git-send-email-quic_mdalam@quicinc.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch fixes a memory corruption that occurred in the
nand_scan() path for Hynix nand device.

On boot, for Hynix nand device will panic at a weird place:
| Unable to handle kernel NULL pointer dereference at virtual
  address 00000070
| [00000070] *pgd=00000000
| Internal error: Oops: 5 [#1] PREEMPT SMP ARM
| Modules linked in:
| CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.0-01473-g13ae1769cfb0
  #38
| Hardware name: Generic DT based system
| PC is at nandc_set_reg+0x8/0x1c
| LR is at qcom_nandc_command+0x20c/0x5d0
| pc : [<c088b74c>]    lr : [<c088d9c8>]    psr: 00000113
| sp : c14adc50  ip : c14ee208  fp : c0cc970c
| r10: 000000a3  r9 : 00000000  r8 : 00000040
| r7 : c16f6a00  r6 : 00000090  r5 : 00000004  r4 :c14ee040
| r3 : 00000000  r2 : 0000000b  r1 : 00000000  r0 :c14ee040
| Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM Segment none
| Control: 10c5387d  Table: 8020406a  DAC: 00000051
| Register r0 information: slab kmalloc-2k start c14ee000 pointer offset
  64 size 2048
| Process swapper/0 (pid: 1, stack limit = 0x(ptrval))
| nandc_set_reg from qcom_nandc_command+0x20c/0x5d0
| qcom_nandc_command from nand_readid_op+0x198/0x1e8
| nand_readid_op from hynix_nand_has_valid_jedecid+0x30/0x78
| hynix_nand_has_valid_jedecid from hynix_nand_init+0xb8/0x454
| hynix_nand_init from nand_scan_with_ids+0xa30/0x14a8
| nand_scan_with_ids from qcom_nandc_probe+0x648/0x7b0
| qcom_nandc_probe from platform_probe+0x58/0xac

The problem is that the nand_scan()'s qcom_nand_attach_chip callback
is updating the nandc->max_cwperpage from 1 to 4.This causes the
sg_init_table of clear_bam_transaction() in the driver's
qcom_nandc_command() to memset much more than what was initially
allocated by alloc_bam_transaction().

This patch will update nandc->max_cwperpage 1 to 4 after nand_scan()
returns, and remove updating nandc->max_cwperpage from
qcom_nand_attach_chip call back.

Cc: stable@vger.kernel.org
Fixes: 6a3cec64f18c ("mtd: rawnand: qcom: convert driver to nand_scan()")
Reported-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Md Sadre Alam <quic_mdalam@quicinc.com>
Signed-off-by: Sricharan R <quic_srichara@quicinc.com>
---
[V3]
 * Updated commit message Fixes, Cc, Reported-by

 drivers/mtd/nand/raw/qcom_nandc.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index 1a77542..048b255 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -2651,10 +2651,23 @@ static int qcom_nand_attach_chip(struct nand_chip *chip)
 	ecc->engine_type = NAND_ECC_ENGINE_TYPE_ON_HOST;
 
 	mtd_set_ooblayout(mtd, &qcom_nand_ooblayout_ops);
+	/* Free the initially allocated BAM transaction for reading the ONFI params */
+	if (nandc->props->is_bam)
+		free_bam_transaction(nandc);
 
 	nandc->max_cwperpage = max_t(unsigned int, nandc->max_cwperpage,
 				     cwperpage);
 
+	/* Now allocate the BAM transaction based on updated max_cwperpage */
+	if (nandc->props->is_bam) {
+		nandc->bam_txn = alloc_bam_transaction(nandc);
+		if (!nandc->bam_txn) {
+			dev_err(nandc->dev,
+				"failed to allocate bam transaction\n");
+			return -ENOMEM;
+		}
+	}
+
 	/*
 	 * DATA_UD_BYTES varies based on whether the read/write command protects
 	 * spare data with ECC too. We protect spare data by default, so we set
@@ -2955,17 +2968,6 @@ static int qcom_nand_host_init_and_register(struct qcom_nand_controller *nandc,
 	if (ret)
 		return ret;
 
-	if (nandc->props->is_bam) {
-		free_bam_transaction(nandc);
-		nandc->bam_txn = alloc_bam_transaction(nandc);
-		if (!nandc->bam_txn) {
-			dev_err(nandc->dev,
-				"failed to allocate bam transaction\n");
-			nand_cleanup(chip);
-			return -ENOMEM;
-		}
-	}
-
 	ret = mtd_device_parse_register(mtd, probes, NULL, NULL, 0);
 	if (ret)
 		nand_cleanup(chip);
-- 
2.7.4

