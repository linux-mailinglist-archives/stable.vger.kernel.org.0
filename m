Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840154D1313
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 10:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238320AbiCHJMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 04:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiCHJMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 04:12:36 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8BE21E34;
        Tue,  8 Mar 2022 01:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646730700; x=1678266700;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=dt5nXBEH13ocfQEG1E2enePW6gJAUmwutTqF7/GLjFA=;
  b=ti8jAxNIG6wiBApKMGg+JoahwUOazVFzv3aSYZO1nxzT72d6y0EnSzC6
   pLcqJGorBn3NCE4WIB46rve3moNMyrT/Sd1CJnimEAZfBeLRa5ZE3+6Mp
   UUkaRGNioESGs/nrWkLgwoKA8XUkhX3sMJtvrH6QHAzg6m8dO9AUIJhrL
   ocUnLHiZFHlK7CY7g53cpgcdxGNikxM5wTErDS1MQ8S9SNkSaUqOA2DK/
   2l35yGtX23MS/1acCxBti40IPFZ16F1ZzA/MdvK8QHRkAls+xPD9akJ36
   mE7GuBsgBE9NLnXc0PCrle6ytGsAfH7mr06Jwoih/ow5Dfw5t2ZKmcX/p
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,164,1643698800"; 
   d="scan'208";a="164903324"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Mar 2022 02:11:40 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 8 Mar 2022 02:11:39 -0700
Received: from ROB-ULT-M18064N.mchp-main.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 8 Mar 2022 02:11:37 -0700
From:   Tudor Ambarus <tudor.ambarus@microchip.com>
To:     <p.yadav@ti.com>, <michael@walle.cc>
CC:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] mtd: spi-nor: core: Skip setting erase types when SPI_NOR_NO_ERASE is set
Date:   Tue, 8 Mar 2022 11:11:35 +0200
Message-ID: <20220308091135.88615-1-tudor.ambarus@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Even if SPI_NOR_NO_ERASE was specified at flash declaration, the erase
type of size nor->info->sector_size was incorrectly set as supported.
Don't set erase types when SPI_NOR_NO_ERASE is set.

Fixes: b199489d37b2 ("mtd: spi-nor: add the framework for SPI NOR")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
---
v2:
- add comment, update commit message, split change in individual commit
- add fixes tag and cc to stable.

 drivers/mtd/spi-nor/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index b4f141ad9c9c..64cf7b9df621 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2392,6 +2392,10 @@ static void spi_nor_no_sfdp_init_params(struct spi_nor *nor)
 					SPINOR_OP_PP, SNOR_PROTO_8_8_8_DTR);
 	}
 
+	/* Skip setting erase types when SPI_NOR_NO_ERASE is set. */
+	if (nor->info->flags & SPI_NOR_NO_ERASE)
+		return;
+
 	/*
 	 * Sector Erase settings. Sort Erase Types in ascending order, with the
 	 * smallest erase size starting at BIT(0).
-- 
2.25.1

