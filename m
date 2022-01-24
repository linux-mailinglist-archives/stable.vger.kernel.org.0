Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A03449A9DD
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1323755AbiAYD3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:29:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58008 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442455AbiAXVF1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:05:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CD946143D;
        Mon, 24 Jan 2022 21:05:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB3DC340E8;
        Mon, 24 Jan 2022 21:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058324;
        bh=VMKrBuXEekjkIWHWkoqddSFajUZpNRkPS7zlR8F06+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pmRH3mNghiN15OThU1rD0kGhcX7t8+Hy+hXkTI6CFv6PlLizhyiUfKTLtt3Cyfl9O
         D+tKRzdiRYBjYWKk+aOINHfk/urNYgfljHdiVUvSDMDOZ6dXw9CWv+CLgg+hgJTcxx
         2BBdc8T6qhPB6+Fyr2JcW5gI+LNDmOvJH8frsAJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Michael Walle <michael@walle.cc>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0252/1039] mtd: spi-nor: Get rid of nor->page_size
Date:   Mon, 24 Jan 2022 19:34:01 +0100
Message-Id: <20220124184133.797138495@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

[ Upstream commit 5854d4a6cc356ba3e16d8593ac1c089a32d1759c ]

nor->page_size duplicated what nor->params->page_size indicates
for no good reason. page_size is a flash parameter of fixed value
and it is better suited to be found in nor->params->page_size.

Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20211029172633.886453-5-tudor.ambarus@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c   | 19 +++++++++----------
 drivers/mtd/spi-nor/xilinx.c | 17 ++++++++++-------
 include/linux/mtd/spi-nor.h  |  2 --
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index cc08bd707378f..fa66dfed002d2 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1952,6 +1952,7 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
 	size_t page_offset, page_remain, i;
 	ssize_t ret;
+	u32 page_size = nor->params->page_size;
 
 	dev_dbg(nor->dev, "to 0x%08x, len %zd\n", (u32)to, len);
 
@@ -1968,16 +1969,15 @@ static int spi_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 		 * calculated with an AND operation. On the other cases we
 		 * need to do a modulus operation (more expensive).
 		 */
-		if (is_power_of_2(nor->page_size)) {
-			page_offset = addr & (nor->page_size - 1);
+		if (is_power_of_2(page_size)) {
+			page_offset = addr & (page_size - 1);
 		} else {
 			uint64_t aux = addr;
 
-			page_offset = do_div(aux, nor->page_size);
+			page_offset = do_div(aux, page_size);
 		}
 		/* the size of data remaining on the first page */
-		page_remain = min_t(size_t,
-				    nor->page_size - page_offset, len - i);
+		page_remain = min_t(size_t, page_size - page_offset, len - i);
 
 		addr = spi_nor_convert_addr(nor, addr);
 
@@ -3094,7 +3094,7 @@ int spi_nor_scan(struct spi_nor *nor, const char *name,
 	 * We need the bounce buffer early to read/write registers when going
 	 * through the spi-mem layer (buffers have to be DMA-able).
 	 * For spi-mem drivers, we'll reallocate a new buffer if
-	 * nor->page_size turns out to be greater than PAGE_SIZE (which
+	 * nor->params->page_size turns out to be greater than PAGE_SIZE (which
 	 * shouldn't happen before long since NOR pages are usually less
 	 * than 1KB) after spi_nor_scan() returns.
 	 */
@@ -3171,8 +3171,7 @@ int spi_nor_scan(struct spi_nor *nor, const char *name,
 		mtd->flags |= MTD_NO_ERASE;
 
 	mtd->dev.parent = dev;
-	nor->page_size = nor->params->page_size;
-	mtd->writebufsize = nor->page_size;
+	mtd->writebufsize = nor->params->page_size;
 
 	if (of_property_read_bool(np, "broken-flash-reset"))
 		nor->flags |= SNOR_F_BROKEN_RESET;
@@ -3341,8 +3340,8 @@ static int spi_nor_probe(struct spi_mem *spimem)
 	 * and add this logic so that if anyone ever adds support for such
 	 * a NOR we don't end up with buffer overflows.
 	 */
-	if (nor->page_size > PAGE_SIZE) {
-		nor->bouncebuf_size = nor->page_size;
+	if (nor->params->page_size > PAGE_SIZE) {
+		nor->bouncebuf_size = nor->params->page_size;
 		devm_kfree(nor->dev, nor->bouncebuf);
 		nor->bouncebuf = devm_kmalloc(nor->dev,
 					      nor->bouncebuf_size,
diff --git a/drivers/mtd/spi-nor/xilinx.c b/drivers/mtd/spi-nor/xilinx.c
index 1138bdbf41998..0658e47564bac 100644
--- a/drivers/mtd/spi-nor/xilinx.c
+++ b/drivers/mtd/spi-nor/xilinx.c
@@ -28,11 +28,12 @@ static const struct flash_info xilinx_parts[] = {
  */
 static u32 s3an_convert_addr(struct spi_nor *nor, u32 addr)
 {
+	u32 page_size = nor->params->page_size;
 	u32 offset, page;
 
-	offset = addr % nor->page_size;
-	page = addr / nor->page_size;
-	page <<= (nor->page_size > 512) ? 10 : 9;
+	offset = addr % page_size;
+	page = addr / page_size;
+	page <<= (page_size > 512) ? 10 : 9;
 
 	return page | offset;
 }
@@ -40,6 +41,7 @@ static u32 s3an_convert_addr(struct spi_nor *nor, u32 addr)
 static int xilinx_nor_setup(struct spi_nor *nor,
 			    const struct spi_nor_hwcaps *hwcaps)
 {
+	u32 page_size;
 	int ret;
 
 	ret = spi_nor_xread_sr(nor, nor->bouncebuf);
@@ -64,10 +66,11 @@ static int xilinx_nor_setup(struct spi_nor *nor,
 	 */
 	if (nor->bouncebuf[0] & XSR_PAGESIZE) {
 		/* Flash in Power of 2 mode */
-		nor->page_size = (nor->page_size == 264) ? 256 : 512;
-		nor->mtd.writebufsize = nor->page_size;
-		nor->mtd.size = 8 * nor->page_size * nor->info->n_sectors;
-		nor->mtd.erasesize = 8 * nor->page_size;
+		page_size = (nor->params->page_size == 264) ? 256 : 512;
+		nor->params->page_size = page_size;
+		nor->mtd.writebufsize = page_size;
+		nor->mtd.size = 8 * page_size * nor->info->n_sectors;
+		nor->mtd.erasesize = 8 * page_size;
 	} else {
 		/* Flash in Default addressing mode */
 		nor->params->convert_addr = s3an_convert_addr;
diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
index f67457748ed84..fc90fce26e337 100644
--- a/include/linux/mtd/spi-nor.h
+++ b/include/linux/mtd/spi-nor.h
@@ -371,7 +371,6 @@ struct spi_nor_flash_parameter;
  * @bouncebuf_size:	size of the bounce buffer
  * @info:		SPI NOR part JEDEC MFR ID and other info
  * @manufacturer:	SPI NOR manufacturer
- * @page_size:		the page size of the SPI NOR
  * @addr_width:		number of address bytes
  * @erase_opcode:	the opcode for erasing a sector
  * @read_opcode:	the read opcode
@@ -401,7 +400,6 @@ struct spi_nor {
 	size_t			bouncebuf_size;
 	const struct flash_info	*info;
 	const struct spi_nor_manufacturer *manufacturer;
-	u32			page_size;
 	u8			addr_width;
 	u8			erase_opcode;
 	u8			read_opcode;
-- 
2.34.1



