Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9282E40AC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731675AbgL1OzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:55:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:51268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441347AbgL1ORG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6640522583;
        Mon, 28 Dec 2020 14:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165011;
        bh=yILNp6kH/yw5GNmBb/hw2thVBIH/jQnLg3VdnXrTiR4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZKU+1NO/shupuddV9rpAe8uAEF/8TcIAyCc/yZgmvkMwWA+4ZYUuWlEk8cb/HXyEq
         XgGj2qvPtOkVqrM2ni2SiOZd4UN1IkED7EUUX3lib/nAHyh2qd9PdiHJP26GLt8Sev
         3CAUZRqO5menYAUPc4FSXPjkyK3xwS9TPYoRZuJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 348/717] mtd: spi-nor: atmel: remove global protection flag
Date:   Mon, 28 Dec 2020 13:45:46 +0100
Message-Id: <20201228125037.701027739@linuxfoundation.org>
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

[ Upstream commit e6204d4620276398ed7317d64c369813a1f96615 ]

This is considered bad for the following reasons:
 (1) We only support the block protection with BPn bits for write
     protection. Not all Atmel parts support this.
 (2) Newly added flash chip will automatically inherit the "has
     locking" support and thus needs to explicitly tested. Better
     be opt-in instead of opt-out.
 (3) There are already supported flashes which doesn't support
     the locking scheme. So I assume this wasn't properly tested
     before adding that chip; which enforces my previous argument
     that locking support should be an opt-in.

Remove the global flag and add individual flags to all flashes which
supports BP locking. In particular the following flashes don't support
the BP scheme:
 - AT26F004
 - AT25SL321
 - AT45DB081D

Please note, that some flashes which are marked as SPI_NOR_HAS_LOCK just
support Global Protection, i.e. not our supported block protection
locking scheme. This is to keep backwards compatibility with the
current "unlock all at boot" mechanism. In particular the following
flashes doesn't have BP bits:
 - AT25DF041A
 - AT25DF321
 - AT25DF321A
 - AT25DF641
 - AT26DF081A
 - AT26DF161A
 - AT26DF321

Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20201203162959.29589-4-michael@walle.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/atmel.c | 28 +++++++++-------------------
 1 file changed, 9 insertions(+), 19 deletions(-)

diff --git a/drivers/mtd/spi-nor/atmel.c b/drivers/mtd/spi-nor/atmel.c
index 3f5f21a473a69..49d392c6c8bc5 100644
--- a/drivers/mtd/spi-nor/atmel.c
+++ b/drivers/mtd/spi-nor/atmel.c
@@ -10,37 +10,27 @@
 
 static const struct flash_info atmel_parts[] = {
 	/* Atmel -- some are (confusingly) marketed as "DataFlash" */
-	{ "at25fs010",  INFO(0x1f6601, 0, 32 * 1024,   4, SECT_4K) },
-	{ "at25fs040",  INFO(0x1f6604, 0, 64 * 1024,   8, SECT_4K) },
+	{ "at25fs010",  INFO(0x1f6601, 0, 32 * 1024,   4, SECT_4K | SPI_NOR_HAS_LOCK) },
+	{ "at25fs040",  INFO(0x1f6604, 0, 64 * 1024,   8, SECT_4K | SPI_NOR_HAS_LOCK) },
 
-	{ "at25df041a", INFO(0x1f4401, 0, 64 * 1024,   8, SECT_4K) },
-	{ "at25df321",  INFO(0x1f4700, 0, 64 * 1024,  64, SECT_4K) },
-	{ "at25df321a", INFO(0x1f4701, 0, 64 * 1024,  64, SECT_4K) },
-	{ "at25df641",  INFO(0x1f4800, 0, 64 * 1024, 128, SECT_4K) },
+	{ "at25df041a", INFO(0x1f4401, 0, 64 * 1024,   8, SECT_4K | SPI_NOR_HAS_LOCK) },
+	{ "at25df321",  INFO(0x1f4700, 0, 64 * 1024,  64, SECT_4K | SPI_NOR_HAS_LOCK) },
+	{ "at25df321a", INFO(0x1f4701, 0, 64 * 1024,  64, SECT_4K | SPI_NOR_HAS_LOCK) },
+	{ "at25df641",  INFO(0x1f4800, 0, 64 * 1024, 128, SECT_4K | SPI_NOR_HAS_LOCK) },
 
 	{ "at25sl321",	INFO(0x1f4216, 0, 64 * 1024, 64,
 			     SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ) },
 
 	{ "at26f004",   INFO(0x1f0400, 0, 64 * 1024,  8, SECT_4K) },
-	{ "at26df081a", INFO(0x1f4501, 0, 64 * 1024, 16, SECT_4K) },
-	{ "at26df161a", INFO(0x1f4601, 0, 64 * 1024, 32, SECT_4K) },
-	{ "at26df321",  INFO(0x1f4700, 0, 64 * 1024, 64, SECT_4K) },
+	{ "at26df081a", INFO(0x1f4501, 0, 64 * 1024, 16, SECT_4K | SPI_NOR_HAS_LOCK) },
+	{ "at26df161a", INFO(0x1f4601, 0, 64 * 1024, 32, SECT_4K | SPI_NOR_HAS_LOCK) },
+	{ "at26df321",  INFO(0x1f4700, 0, 64 * 1024, 64, SECT_4K | SPI_NOR_HAS_LOCK) },
 
 	{ "at45db081d", INFO(0x1f2500, 0, 64 * 1024, 16, SECT_4K) },
 };
 
-static void atmel_default_init(struct spi_nor *nor)
-{
-	nor->flags |= SNOR_F_HAS_LOCK;
-}
-
-static const struct spi_nor_fixups atmel_fixups = {
-	.default_init = atmel_default_init,
-};
-
 const struct spi_nor_manufacturer spi_nor_atmel = {
 	.name = "atmel",
 	.parts = atmel_parts,
 	.nparts = ARRAY_SIZE(atmel_parts),
-	.fixups = &atmel_fixups,
 };
-- 
2.27.0



