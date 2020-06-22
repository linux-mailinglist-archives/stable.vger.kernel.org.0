Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E722037D9
	for <lists+stable@lfdr.de>; Mon, 22 Jun 2020 15:23:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbgFVNXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 09:23:41 -0400
Received: from shelob.oktetlabs.ru ([91.220.146.113]:48213 "EHLO
        shelob.oktetlabs.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbgFVNXl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 09:23:41 -0400
Received: by shelob.oktetlabs.ru (Postfix, from userid 122)
        id 167F17F5EA; Mon, 22 Jun 2020 16:16:50 +0300 (MSK)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on shelob.oktetlabs.ru
X-Spam-Level: 
X-Spam-Status: No, score=0.8 required=5.0 tests=ALL_TRUSTED,DKIM_ADSP_DISCARD
        autolearn=no autolearn_force=no version=3.4.2
Received: from varda.oktetlabs.ru (varda.oktetlabs.ru [192.168.37.38])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by shelob.oktetlabs.ru (Postfix) with ESMTPS id 080567F5E9;
        Mon, 22 Jun 2020 16:16:35 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 shelob.oktetlabs.ru 080567F5E9
Authentication-Results: shelob.oktetlabs.ru/080567F5E9; dkim=none;
        dkim-atps=neutral
Received: from mkshevetskiy by varda.oktetlabs.ru with local (Exim 4.94)
        (envelope-from <mkshevetskiy@varda.oktetlabs.ru>)
        id 1jnMJO-008wpR-K4; Mon, 22 Jun 2020 16:16:34 +0300
From:   Mikhail Kshevetskiy <mikhail.kshevetskiy@oktetlabs.ru>
To:     u-boot@lists.denx.de
Cc:     scottwood@freescale.com,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        stable@vger.kernel.org,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 3/4] mtd: spinand: Do not erase the block before writing a bad block marker
Date:   Mon, 22 Jun 2020 16:16:33 +0300
Message-Id: <20200622131634.2132717-3-mikhail.kshevetskiy@oktetlabs.ru>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622131634.2132717-1-mikhail.kshevetskiy@oktetlabs.ru>
References: <20200622131634.2132717-1-mikhail.kshevetskiy@oktetlabs.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

Currently when marking a block, we use spinand_erase_op() to erase
the block before writing the marker to the OOB area. Doing so without
waiting for the operation to finish can lead to the marking failing
silently and no bad block marker being written to the flash.

In fact we don't need to do an erase at all before writing the BBM.
The ECC is disabled for raw accesses to the OOB data and we don't
need to work around any issues with chips reporting ECC errors as it
is known to be the case for raw NAND.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200218100432.32433-4-frieder.schrempf@kontron.de
---
 drivers/mtd/nand/spi/core.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index c74a7b5ef3..e0ebd9c04b 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -712,19 +712,10 @@ static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
 	};
 	int ret;
 
-	/* Erase block before marking it bad. */
 	ret = spinand_select_target(spinand, pos->target);
 	if (ret)
 		return ret;
 
-	ret = spinand_write_enable_op(spinand);
-	if (ret)
-		return ret;
-
-	ret = spinand_erase_op(spinand, pos);
-	if (ret)
-		return ret;
-
 	return spinand_write_page(spinand, &req);
 }
 
-- 
2.27.0

