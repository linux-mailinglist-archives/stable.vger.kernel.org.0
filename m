Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855261576F6
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbgBJM4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728854AbgBJMlh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:41:37 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 946A22085B;
        Mon, 10 Feb 2020 12:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338496;
        bh=kzcWBAzn3Ck2D384MPoUCXUGQQBdOU+MwAGkn6NkYNQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tj4B0le/fIqoR87sY2bQSU2wF+ukrBnFMKKywEHootye3g7pauuHjCZ7WdkSb0tyE
         W5hyrGnily0JzKk835lX+UgwMIopCcKO+dj3YrY1g5oYniH13IySdOgl63I2GE+X4d
         IhN+AxzdnYlrU5LhQbIZjwoyGK/jeNIhAiOmvoso=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.5 285/367] mtd: spi-nor: Split mt25qu512a (n25q512a) entry into two
Date:   Mon, 10 Feb 2020 04:33:18 -0800
Message-Id: <20200210122450.244209204@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

commit bd8a6e31b87b39a03ab11820776363640440dbe0 upstream.

mt25q family is different from n25q family of devices, even though manf
ID and device IDs are same. mt25q flash has bit 6 set in 5th byte of
READ ID response which can be used to distinguish it from n25q variant.
mt25q flashes support stateless 4 Byte addressing opcodes where as n25q
flashes don't. Therefore, have two separate entries for mt25qu512a and
n25q512a.

Fixes: 9607af6f857f ("mtd: spi-nor: Rename "n25q512a" to "mt25qu512a (n25q512a)"")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/spi-nor/spi-nor.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -2461,15 +2461,16 @@ static const struct flash_info spi_nor_i
 	{ "n25q256a",    INFO(0x20ba19, 0, 64 * 1024,  512, SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ) },
 	{ "n25q256ax1",  INFO(0x20bb19, 0, 64 * 1024,  512, SECT_4K | SPI_NOR_QUAD_READ) },
 	{ "n25q512ax3",  INFO(0x20ba20, 0, 64 * 1024, 1024, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ) },
+	{ "mt25qu512a",  INFO6(0x20bb20, 0x104400, 64 * 1024, 1024,
+			       SECT_4K | USE_FSR | SPI_NOR_DUAL_READ |
+			       SPI_NOR_QUAD_READ | SPI_NOR_4B_OPCODES) },
+	{ "n25q512a",    INFO(0x20bb20, 0, 64 * 1024, 1024, SECT_4K |
+			      SPI_NOR_QUAD_READ) },
 	{ "n25q00",      INFO(0x20ba21, 0, 64 * 1024, 2048, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ | NO_CHIP_ERASE) },
 	{ "n25q00a",     INFO(0x20bb21, 0, 64 * 1024, 2048, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ | NO_CHIP_ERASE) },
 	{ "mt25ql02g",   INFO(0x20ba22, 0, 64 * 1024, 4096,
 			      SECT_4K | USE_FSR | SPI_NOR_QUAD_READ |
 			      NO_CHIP_ERASE) },
-	{ "mt25qu512a (n25q512a)", INFO(0x20bb20, 0, 64 * 1024, 1024,
-					SECT_4K | USE_FSR | SPI_NOR_DUAL_READ |
-					SPI_NOR_QUAD_READ |
-					SPI_NOR_4B_OPCODES) },
 	{ "mt25qu02g",   INFO(0x20bb22, 0, 64 * 1024, 4096, SECT_4K | USE_FSR | SPI_NOR_QUAD_READ | NO_CHIP_ERASE) },
 
 	/* Micron */


