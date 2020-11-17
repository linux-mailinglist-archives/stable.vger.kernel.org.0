Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160A92B6518
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731114AbgKQNak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:30:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730544AbgKQNah (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:37 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 713202078E;
        Tue, 17 Nov 2020 13:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619838;
        bh=SRWrzidpz1bA2eErxINd4qxHZVMh8LqjQ3WtTqAAJu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gkZ5O8xZNNfpxBQjX4DPndg2jsZsTaA4BFXOUEVQ8/jIhn7n5+smHnUj+mcdk4JLR
         AleWWqzIgTkx46uL503ng77ZxT1p5fPdUtZV8kGutH4VRK0iT7MVCrO5GuH9/U3c5J
         BG5x+o4ijKTXP7nG1cLv8U1S6G5rS8mEEdIltN5o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bert Vermeulen <bert@biot.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>, Joel Stanley <joel@jms.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 020/255] mtd: spi-nor: Fix address width on flash chips > 16MB
Date:   Tue, 17 Nov 2020 14:02:40 +0100
Message-Id: <20201117122139.927316406@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bert Vermeulen <bert@biot.com>

[ Upstream commit 324f78dfb442b82365548b657ec4e6974c677502 ]

If a flash chip has more than 16MB capacity but its BFPT reports
BFPT_DWORD1_ADDRESS_BYTES_3_OR_4, the spi-nor framework defaults to 3.

The check in spi_nor_set_addr_width() doesn't catch it because addr_width
did get set. This fixes that check.

Fixes: f9acd7fa80be ("mtd: spi-nor: sfdp: default to addr_width of 3 for configurable widths")
Signed-off-by: Bert Vermeulen <bert@biot.com>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Tested-by: Joel Stanley <joel@jms.id.au>
Tested-by: Cédric Le Goater <clg@kaod.org>
Link: https://lore.kernel.org/r/20201006132346.12652-1-bert@biot.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index b37d6c1936de1..f0ae7a01703a1 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -3008,13 +3008,15 @@ static int spi_nor_set_addr_width(struct spi_nor *nor)
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
2.27.0



