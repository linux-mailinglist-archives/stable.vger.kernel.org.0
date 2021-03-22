Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629463448C6
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 16:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhCVPHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 11:07:50 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:50602 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbhCVPH2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 11:07:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616425646; x=1647961646;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PKEVxUCgPKYfeTmheletBgau4WWVsW+3puprPtDA3sw=;
  b=UqJwbP2E1/2iPZWxAne/s1a9lo7NKUVqdz8VQHpE15hmf3p7Kr6MECx9
   g3Q7sokmdEM5Wj7umRxofohmmrHA95O1UCi248nu9U3ygX+P2lRXRQHDq
   5OHYahKw4zEX0IRSZxzhFUu4iqKH+5VgokCCFzwdlXObaNQ12Nbg/xLkr
   mCUNnJz+uN882/FxRsb7EQseCPyLcrXHVt5y7WBiX2nIgdiRcGGIpgxxp
   2qHqAupXCQzu5l0k4w0Cu9k7WyrVqsY920dJCzvD98PjiQAGTwyUaAiLg
   fu1XXJrBXpUbAu4FJCo9/9n+dtcfYkCIWOkXkByWmFHqFwYq0CXoLjZi6
   A==;
IronPort-SDR: 2k6wZB5WbX+HIh6DWKmt2jsnNmQ88DYxESFLawyT2CQbVn6VCxREeIZdFanxgafkNYJ/q+FZsM
 /+35jIGaslhfYDgkHTCwBNmRPN4y5Qs8fv8ambqE4V2sMN7uj90lfz/ULpyHBAwi1bbq5MtF4c
 46Xs18xj+5zv9Rk/8t4C6YV/oAryI4PqSJ/pvHsV+z+j/X74hquJOiQNmid6rqGff4Yffi+79D
 kzvdmqB71j8VIhr7CZ9c52XuCy/2NXC3RZUu9EDsYCoVFdd+Dj402ts/9ZmC7Yi8+3ZA+s3/0D
 xm0=
X-IronPort-AV: E=Sophos;i="5.81,269,1610434800"; 
   d="scan'208";a="119923115"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Mar 2021 08:07:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 22 Mar 2021 08:07:19 -0700
Received: from atudor-ThinkPad-T470p.amer.actel.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Mon, 22 Mar 2021 08:07:16 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>
CC:     <nicolas.ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <ludovic.desroches@microchip.com>, <bbrezillon@kernel.org>,
        <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Kai Stuhlemmer (ebee Engineering)" <kai.stuhlemmer@ebee.de>,
        <stable@vger.kernel.org>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH] mtd: rawnand: atmel: Update ecc_stats.corrected counter
Date:   Mon, 22 Mar 2021 17:07:14 +0200
Message-ID: <20210322150714.101585-1-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Kai Stuhlemmer (ebee Engineering)" <kai.stuhlemmer@ebee.de>

Update MTD ECC statistics with the number of corrected bits.

Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Cc: stable@vger.kernel.org
Signed-off-by: Kai Stuhlemmer (ebee Engineering) <kai.stuhlemmer@ebee.de>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/mtd/nand/raw/atmel/nand-controller.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index e6ceec8f50dc..8aab1017b460 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -883,10 +883,12 @@ static int atmel_nand_pmecc_correct_data(struct nand_chip *chip, void *buf,
 							  NULL, 0,
 							  chip->ecc.strength);
 
-		if (ret >= 0)
+		if (ret >= 0) {
+			mtd->ecc_stats.corrected += ret;
 			max_bitflips = max(ret, max_bitflips);
-		else
+		} else {
 			mtd->ecc_stats.failed++;
+		}
 
 		databuf += chip->ecc.size;
 		eccbuf += chip->ecc.bytes;
-- 
2.25.1

