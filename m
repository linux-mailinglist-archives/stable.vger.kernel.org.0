Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1811F7424
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 08:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgFLGuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 02:50:01 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:29074 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726300AbgFLGuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jun 2020 02:50:01 -0400
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 11 Jun 2020 23:50:00 -0700
Received: from sivaprak-linux.qualcomm.com ([10.201.3.202])
  by ironmsg05-sd.qualcomm.com with ESMTP; 11 Jun 2020 23:49:57 -0700
Received: by sivaprak-linux.qualcomm.com (Postfix, from userid 459349)
        id 7EED821876; Fri, 12 Jun 2020 12:19:55 +0530 (IST)
From:   Sivaprakash Murugesan <sivaprak@codeaurora.org>
To:     miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        peter.ujfalusi@ti.com, sivaprak@codeaurora.org,
        boris.brezillon@collabora.com, architt@codeaurora.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH V3 1/2] mtd: rawnand: qcom: avoid write to unavailable register
Date:   Fri, 12 Jun 2020 12:19:48 +0530
Message-Id: <1591944589-14357-2-git-send-email-sivaprak@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1591944589-14357-1-git-send-email-sivaprak@codeaurora.org>
References: <1591944589-14357-1-git-send-email-sivaprak@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SFLASHC_BURST_CFG is only available on older ipq nand platforms, this
register has been removed when the NAND controller is moved as part of qpic
controller.

avoid register writes to this register on devices which are based on qpic
NAND controllers.

Fixes: a0637834 (mtd: nand: qcom: support for IPQ4019 QPIC NANDcontroller)
Fixes: dce84760 (mtd: nand: qcom: Support for IPQ8074 QPIC NAND controller)
Cc: stable@vger.kernel.org
Signed-off-by: Sivaprakash Murugesan <sivaprak@codeaurora.org>
---
[V3]
 * Addressed Miquel comments, added flag based on nand controller hw
   to avoid the register writes to specific ipq platforms
 drivers/mtd/nand/raw/qcom_nandc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index f1daf33..e0c55bb 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -459,11 +459,13 @@ struct qcom_nand_host {
  * among different NAND controllers.
  * @ecc_modes - ecc mode for NAND
  * @is_bam - whether NAND controller is using BAM
+ * @is_qpic - whether NAND CTRL is part of qpic IP
  * @dev_cmd_reg_start - NAND_DEV_CMD_* registers starting offset
  */
 struct qcom_nandc_props {
 	u32 ecc_modes;
 	bool is_bam;
+	bool is_qpic;
 	u32 dev_cmd_reg_start;
 };
 
@@ -2774,7 +2776,8 @@ static int qcom_nandc_setup(struct qcom_nand_controller *nandc)
 	u32 nand_ctrl;
 
 	/* kill onenand */
-	nandc_write(nandc, SFLASHC_BURST_CFG, 0);
+	if (!nandc->props->is_qpic)
+		nandc_write(nandc, SFLASHC_BURST_CFG, 0);
 	nandc_write(nandc, dev_cmd_reg_addr(nandc, NAND_DEV_CMD_VLD),
 		    NAND_DEV_CMD_VLD_VAL);
 
@@ -3029,18 +3032,21 @@ static int qcom_nandc_remove(struct platform_device *pdev)
 static const struct qcom_nandc_props ipq806x_nandc_props = {
 	.ecc_modes = (ECC_RS_4BIT | ECC_BCH_8BIT),
 	.is_bam = false,
+	.is_qpic = false,
 	.dev_cmd_reg_start = 0x0,
 };
 
 static const struct qcom_nandc_props ipq4019_nandc_props = {
 	.ecc_modes = (ECC_BCH_4BIT | ECC_BCH_8BIT),
 	.is_bam = true,
+	.is_qpic = true,
 	.dev_cmd_reg_start = 0x0,
 };
 
 static const struct qcom_nandc_props ipq8074_nandc_props = {
 	.ecc_modes = (ECC_BCH_4BIT | ECC_BCH_8BIT),
 	.is_bam = true,
+	.is_qpic = true,
 	.dev_cmd_reg_start = 0x7000,
 };
 
-- 
2.7.4

