Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7239226876
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387821AbgGTQTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387793AbgGTQLY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:11:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AF762065E;
        Mon, 20 Jul 2020 16:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261483;
        bh=CtKdk9rcMkOi904ATgMN+hXqgC52DDcBc5R/+Q/9P70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijo1cFtxugTMSza3GaVyiil1PlRJevQpD8riq8QdZFGtu7uGIjxoufSiwPBKg3Uls
         Pnbt7WX62CXMZshIJcTnXwUsKKNKSMh76/pkQoarOxhbd9N3UVoSldmdwabP7dFqIA
         LVs+pYRSftIs5SeBzC48CpKM6FA+dtoJi+T5lK14=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mantas Pucka <mantas@8devices.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.7 132/244] mtd: spi-nor: winbond: Fix 4-byte opcode support for w25q256
Date:   Mon, 20 Jul 2020 17:36:43 +0200
Message-Id: <20200720152832.124665561@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mantas Pucka <mantas@8devices.com>

commit e8aec15dd5842b5b11b0e621a2293348d3574a61 upstream.

There are 2 different chips (w25q256fv and w25q256jv) that share
the same JEDEC ID. Only w25q256jv fully supports 4-byte opcodes.
Use SFDP header version to differentiate between them.

Fixes: 10050a02f7d5 ("mtd: spi-nor: Add 4B_OPCODES flag to w25q256")
Signed-off-by: Mantas Pucka <mantas@8devices.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/spi-nor/sfdp.c    |    4 ----
 drivers/mtd/spi-nor/sfdp.h    |    6 ++++++
 drivers/mtd/spi-nor/winbond.c |   29 +++++++++++++++++++++++++++--
 3 files changed, 33 insertions(+), 6 deletions(-)

--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -21,10 +21,6 @@
 #define SFDP_4BAIT_ID		0xff84  /* 4-byte Address Instruction Table */
 
 #define SFDP_SIGNATURE		0x50444653U
-#define SFDP_JESD216_MAJOR	1
-#define SFDP_JESD216_MINOR	0
-#define SFDP_JESD216A_MINOR	5
-#define SFDP_JESD216B_MINOR	6
 
 struct sfdp_header {
 	u32		signature; /* Ox50444653U <=> "SFDP" */
--- a/drivers/mtd/spi-nor/sfdp.h
+++ b/drivers/mtd/spi-nor/sfdp.h
@@ -7,6 +7,12 @@
 #ifndef __LINUX_MTD_SFDP_H
 #define __LINUX_MTD_SFDP_H
 
+/* SFDP revisions */
+#define SFDP_JESD216_MAJOR	1
+#define SFDP_JESD216_MINOR	0
+#define SFDP_JESD216A_MINOR	5
+#define SFDP_JESD216B_MINOR	6
+
 /* Basic Flash Parameter Table */
 
 /*
--- a/drivers/mtd/spi-nor/winbond.c
+++ b/drivers/mtd/spi-nor/winbond.c
@@ -8,6 +8,31 @@
 
 #include "core.h"
 
+static int
+w25q256_post_bfpt_fixups(struct spi_nor *nor,
+			 const struct sfdp_parameter_header *bfpt_header,
+			 const struct sfdp_bfpt *bfpt,
+			 struct spi_nor_flash_parameter *params)
+{
+	/*
+	 * W25Q256JV supports 4B opcodes but W25Q256FV does not.
+	 * Unfortunately, Winbond has re-used the same JEDEC ID for both
+	 * variants which prevents us from defining a new entry in the parts
+	 * table.
+	 * To differentiate between W25Q256JV and W25Q256FV check SFDP header
+	 * version: only JV has JESD216A compliant structure (version 5).
+	 */
+	if (bfpt_header->major == SFDP_JESD216_MAJOR &&
+	    bfpt_header->minor == SFDP_JESD216A_MINOR)
+		nor->flags |= SNOR_F_4B_OPCODES;
+
+	return 0;
+}
+
+static struct spi_nor_fixups w25q256_fixups = {
+	.post_bfpt = w25q256_post_bfpt_fixups,
+};
+
 static const struct flash_info winbond_parts[] = {
 	/* Winbond -- w25x "blocks" are 64K, "sectors" are 4KiB */
 	{ "w25x05", INFO(0xef3010, 0, 64 * 1024,  1,  SECT_4K) },
@@ -53,8 +78,8 @@ static const struct flash_info winbond_p
 	{ "w25q80bl", INFO(0xef4014, 0, 64 * 1024,  16, SECT_4K) },
 	{ "w25q128", INFO(0xef4018, 0, 64 * 1024, 256, SECT_4K) },
 	{ "w25q256", INFO(0xef4019, 0, 64 * 1024, 512,
-			  SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
-			  SPI_NOR_4B_OPCODES) },
+			  SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ)
+	  .fixups = &w25q256_fixups },
 	{ "w25q256jvm", INFO(0xef7019, 0, 64 * 1024, 512,
 			     SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ) },
 	{ "w25q256jw", INFO(0xef6019, 0, 64 * 1024, 512,


