Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617E54C71C4
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 17:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbiB1QeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 11:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233788AbiB1QeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 11:34:20 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FD8443DE;
        Mon, 28 Feb 2022 08:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646066021; x=1677602021;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UdSjyJ1B+8BlqPXgKZCokBvRIg9/Y/nN4hv5bYbeSv8=;
  b=H93m1Zy1ONPvoY1GqCE8xWHc2CzPIOZxV2P4nKKwmx97+qNzNC3IG0NQ
   lrAB4/Ii/yvOp0h39u1lkSGxqsh8ATdq2bDY+8Cu8odDSgH4hshRUWQPb
   YLmXX+cxgIZLJvx9KiollU2OK+czBA2E6HEDwk4hyVUWMp+e/IsB7hVXI
   XJRM7DB6ZN45Bm6oVB4H//kMUspaWa7pOkUBc9ymev1yd05zuMGn9q/zy
   JvbfUGNfmKmZAJgjBaZzV4i+VQEZPHpMOqdyE0j3DUcXIqEMAn2RqAm2M
   BtNcAn+AHHtj8xDRpUmHidljcZGC/Zt3j3f8bd7zTrMFRQHfX+MGdVls1
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,142,1643698800"; 
   d="scan'208";a="87262415"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Feb 2022 09:33:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 28 Feb 2022 09:33:40 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Mon, 28 Feb 2022 09:33:37 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <p.yadav@ti.com>, <michael@walle.cc>
CC:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <nicolas.ferre@microchip.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] mtd: spi-nor: Skip erase logic when SPI_NOR_NO_ERASE is set
Date:   Mon, 28 Feb 2022 18:33:34 +0200
Message-ID: <20220228163334.277730-1-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Even if SPI_NOR_NO_ERASE was set, one could still send erase opcodes
to the flash. It is not recommended to send unsupported opcodes to
flashes. Fix the logic and do not set mtd->_erase when SPI_NOR_NO_ERASE
is specified. With this users will not be able to issue erase opcodes to
flashes and instead they will recive an -ENOTSUPP error.

Cc: stable@vger.kernel.org
Fixes: b199489d37b2 ("mtd: spi-nor: add the framework for SPI NOR")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/mtd/spi-nor/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 86a536c97c18..cd2d094ef837 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2969,10 +2969,11 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
 	mtd->flags = MTD_CAP_NORFLASH;
 	if (nor->info->flags & SPI_NOR_NO_ERASE)
 		mtd->flags |= MTD_NO_ERASE;
+	else
+		mtd->_erase = spi_nor_erase;
 	mtd->writesize = nor->params->writesize;
 	mtd->writebufsize = nor->params->page_size;
 	mtd->size = nor->params->size;
-	mtd->_erase = spi_nor_erase;
 	mtd->_read = spi_nor_read;
 	/* Might be already set by some SST flashes. */
 	if (!mtd->_write)
-- 
2.25.1

