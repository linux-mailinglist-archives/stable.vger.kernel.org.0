Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AC72E3D99
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439779AbgL1ORf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:17:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2501882AbgL1ORf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4790F20731;
        Mon, 28 Dec 2020 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165013;
        bh=4ZAjtiNhyy67T3/NhtzWs5anx1Ee+dBA71kE24FTrVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5c+J2Q2LfFXeGg5h+On68nEE2P0IE+PpuC5mAwcQzpBQnTtaomt5R8PE/4J/GkZ9
         rIRakSXLRyEOPdilgl9qedvT4RdYCnpcmJBzBFS9O3UbX0CnPjwkXHg4lNqjMhrof6
         NOrVmCUxmW2h7+pv0LtnSN46Uo8Eck9yyGun1f7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 349/717] mtd: spi-nor: atmel: fix unlock_all() for AT25FS010/040
Date:   Mon, 28 Dec 2020 13:45:47 +0100
Message-Id: <20201228125037.749614123@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 8c174d1511d235ed6c049dcb2b704777ad0df7a5 ]

These flashes have some weird BP bits mapping which aren't supported in
the current locking code. Just add a simple unlock op to unprotect the
entire flash array which is needed for legacy behavior.

Fixes: 3e0930f109e7 ("mtd: spi-nor: Rework the disabling of block write protection")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20201203162959.29589-7-michael@walle.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/atmel.c | 53 +++++++++++++++++++++++++++++++++++--
 drivers/mtd/spi-nor/core.c  |  2 +-
 drivers/mtd/spi-nor/core.h  |  1 +
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/spi-nor/atmel.c b/drivers/mtd/spi-nor/atmel.c
index 49d392c6c8bc5..deacf87a68a06 100644
--- a/drivers/mtd/spi-nor/atmel.c
+++ b/drivers/mtd/spi-nor/atmel.c
@@ -8,10 +8,59 @@
 
 #include "core.h"
 
+/*
+ * The Atmel AT25FS010/AT25FS040 parts have some weird configuration for the
+ * block protection bits. We don't support them. But legacy behavior in linux
+ * is to unlock the whole flash array on startup. Therefore, we have to support
+ * exactly this operation.
+ */
+static int atmel_at25fs_lock(struct spi_nor *nor, loff_t ofs, uint64_t len)
+{
+	return -EOPNOTSUPP;
+}
+
+static int atmel_at25fs_unlock(struct spi_nor *nor, loff_t ofs, uint64_t len)
+{
+	int ret;
+
+	/* We only support unlocking the whole flash array */
+	if (ofs || len != nor->params->size)
+		return -EINVAL;
+
+	/* Write 0x00 to the status register to disable write protection */
+	ret = spi_nor_write_sr_and_check(nor, 0);
+	if (ret)
+		dev_dbg(nor->dev, "unable to clear BP bits, WP# asserted?\n");
+
+	return ret;
+}
+
+static int atmel_at25fs_is_locked(struct spi_nor *nor, loff_t ofs, uint64_t len)
+{
+	return -EOPNOTSUPP;
+}
+
+static const struct spi_nor_locking_ops atmel_at25fs_locking_ops = {
+	.lock = atmel_at25fs_lock,
+	.unlock = atmel_at25fs_unlock,
+	.is_locked = atmel_at25fs_is_locked,
+};
+
+static void atmel_at25fs_default_init(struct spi_nor *nor)
+{
+	nor->params->locking_ops = &atmel_at25fs_locking_ops;
+}
+
+static const struct spi_nor_fixups atmel_at25fs_fixups = {
+	.default_init = atmel_at25fs_default_init,
+};
+
 static const struct flash_info atmel_parts[] = {
 	/* Atmel -- some are (confusingly) marketed as "DataFlash" */
-	{ "at25fs010",  INFO(0x1f6601, 0, 32 * 1024,   4, SECT_4K | SPI_NOR_HAS_LOCK) },
-	{ "at25fs040",  INFO(0x1f6604, 0, 64 * 1024,   8, SECT_4K | SPI_NOR_HAS_LOCK) },
+	{ "at25fs010",  INFO(0x1f6601, 0, 32 * 1024,   4, SECT_4K | SPI_NOR_HAS_LOCK)
+		.fixups = &atmel_at25fs_fixups },
+	{ "at25fs040",  INFO(0x1f6604, 0, 64 * 1024,   8, SECT_4K | SPI_NOR_HAS_LOCK)
+		.fixups = &atmel_at25fs_fixups },
 
 	{ "at25df041a", INFO(0x1f4401, 0, 64 * 1024,   8, SECT_4K | SPI_NOR_HAS_LOCK) },
 	{ "at25df321",  INFO(0x1f4700, 0, 64 * 1024,  64, SECT_4K | SPI_NOR_HAS_LOCK) },
diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 61b00d4965475..ad6c79d9a7f86 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -906,7 +906,7 @@ static int spi_nor_write_16bit_cr_and_check(struct spi_nor *nor, u8 cr)
  *
  * Return: 0 on success, -errno otherwise.
  */
-static int spi_nor_write_sr_and_check(struct spi_nor *nor, u8 sr1)
+int spi_nor_write_sr_and_check(struct spi_nor *nor, u8 sr1)
 {
 	if (nor->flags & SNOR_F_HAS_16BIT_SR)
 		return spi_nor_write_16bit_sr_and_check(nor, sr1);
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index 6f2f6b27173fd..6f62ee861231a 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -409,6 +409,7 @@ void spi_nor_unlock_and_unprep(struct spi_nor *nor);
 int spi_nor_sr1_bit6_quad_enable(struct spi_nor *nor);
 int spi_nor_sr2_bit1_quad_enable(struct spi_nor *nor);
 int spi_nor_sr2_bit7_quad_enable(struct spi_nor *nor);
+int spi_nor_write_sr_and_check(struct spi_nor *nor, u8 sr1);
 
 int spi_nor_xread_sr(struct spi_nor *nor, u8 *sr);
 ssize_t spi_nor_read_data(struct spi_nor *nor, loff_t from, size_t len,
-- 
2.27.0



