Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217E8247027
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730883AbgHQSEe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:04:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388518AbgHQQJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:09:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E78D20B1F;
        Mon, 17 Aug 2020 16:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680582;
        bh=6NFGYLMdZuxHBt92Wm+Tz5Tb7Ixt9sANVZ1x7+ZPyb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogleyW9Im+AmBX4NMYyuDuBQp+ww+ZM8TOvKTTXUgT3M41RF6XgG440Qo9nG7xfBO
         hjqhYMQNj4Y+9JZhU/uuoH2kjeFsEd2vZ0TRuL/Vty4UToC+tl/NuTgQN72xj1ldRp
         w/4hZgUUhL7E30e67y7eO2w5Dh9l8fDXWQW6r9mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sivaprakash Murugesan <sivaprak@codeaurora.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 244/270] mtd: rawnand: qcom: avoid write to unavailable register
Date:   Mon, 17 Aug 2020 17:17:25 +0200
Message-Id: <20200817143807.971655202@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sivaprakash Murugesan <sivaprak@codeaurora.org>

commit 443440cc4a901af462239d286cd10721aa1c7dfc upstream.

SFLASHC_BURST_CFG is only available on older ipq NAND platforms, this
register has been removed when the NAND controller got implemented in
the qpic controller.

Avoid writing this register on devices which are based on qpic NAND
controller.

Fixes: dce84760b09f ("mtd: nand: qcom: Support for IPQ8074 QPIC NAND controller")
Cc: stable@vger.kernel.org
Signed-off-by: Sivaprakash Murugesan <sivaprak@codeaurora.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/1591948696-16015-2-git-send-email-sivaprak@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/qcom_nandc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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
 
@@ -2751,7 +2753,8 @@ static int qcom_nandc_setup(struct qcom_
 	u32 nand_ctrl;
 
 	/* kill onenand */
-	nandc_write(nandc, SFLASHC_BURST_CFG, 0);
+	if (!nandc->props->is_qpic)
+		nandc_write(nandc, SFLASHC_BURST_CFG, 0);
 	nandc_write(nandc, dev_cmd_reg_addr(nandc, NAND_DEV_CMD_VLD),
 		    NAND_DEV_CMD_VLD_VAL);
 
@@ -3007,12 +3010,14 @@ static const struct qcom_nandc_props ipq
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
 


