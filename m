Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2C6284CFD
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 16:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgJFOFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Oct 2020 10:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgJFOE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Oct 2020 10:04:26 -0400
X-Greylist: delayed 2411 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Oct 2020 07:04:25 PDT
Received: from yawp.biot.com (yawp.biot.com [IPv6:2a01:4f8:10a:8e::fce2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8B8C061755
        for <stable@vger.kernel.org>; Tue,  6 Oct 2020 07:04:25 -0700 (PDT)
Received: from debian-spamd by yawp.biot.com with sa-checked (Exim 4.93)
        (envelope-from <bert@biot.com>)
        id 1kPmwv-00ELoB-6Z
        for stable@vger.kernel.org; Tue, 06 Oct 2020 15:24:13 +0200
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on yawp
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.4
Received: from [2a02:578:460c:1:1e1b:dff:fe91:1af5] (helo=sumner.biot.com)
        by yawp.biot.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <bert@biot.com>)
        id 1kPmwZ-00ELnC-8b; Tue, 06 Oct 2020 15:23:51 +0200
Received: from bert by sumner.biot.com with local (Exim 4.90_1)
        (envelope-from <bert@biot.com>)
        id 1kPmwY-0003Ip-Se; Tue, 06 Oct 2020 15:23:50 +0200
From:   Bert Vermeulen <bert@biot.com>
To:     tudor.ambarus@microchip.com, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bert Vermeulen <bert@biot.com>
Subject: [RESEND PATCH v2] mtd: spi-nor: Fix address width on flash chips > 16MB
Date:   Tue,  6 Oct 2020 15:23:46 +0200
Message-Id: <20201006132346.12652-1-bert@biot.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If a flash chip has more than 16MB capacity but its BFPT reports
BFPT_DWORD1_ADDRESS_BYTES_3_OR_4, the spi-nor framework defaults to 3.

The check in spi_nor_set_addr_width() doesn't catch it because addr_width
did get set. This fixes that check.

Fixes: f9acd7fa80be ("mtd: spi-nor: sfdp: default to addr_width of 3 for configurable widths")
Signed-off-by: Bert Vermeulen <bert@biot.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
---
 drivers/mtd/spi-nor/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 0369d98b2d12..a2c35ad9645c 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -3009,13 +3009,15 @@ static int spi_nor_set_addr_width(struct spi_nor *nor)
 		/* already configured from SFDP */
 	} else if (nor->info->addr_width) {
 		nor->addr_width = nor->info->addr_width;
-	} else if (nor->mtd.size > 0x1000000) {
-		/* enable 4-byte addressing if the device exceeds 16MiB */
-		nor->addr_width = 4;
 	} else {
 		nor->addr_width = 3;
 	}
 
+	if (nor->addr_width == 3 && nor->mtd.size > 0x1000000) {
+		/* enable 4-byte addressing if the device exceeds 16MiB */
+		nor->addr_width = 4;
+	}
+
 	if (nor->addr_width > SPI_NOR_MAX_ADDR_WIDTH) {
 		dev_dbg(nor->dev, "address width is too large: %u\n",
 			nor->addr_width);
-- 
2.17.1

