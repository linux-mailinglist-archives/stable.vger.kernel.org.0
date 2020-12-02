Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5247C2CCA39
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 00:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387817AbgLBXBk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 18:01:40 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:38379 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgLBXBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 18:01:40 -0500
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E408D23E4A;
        Thu,  3 Dec 2020 00:00:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1606950056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TnA/qUXIYTXaM01hsHMLcQl3An0XNPm+t1vCVx7R0w8=;
        b=kSsyKryQib1ypctEuHcEV3YtWwpvJ4y+79qu6gvXBVIg/BKbTYziL5tcYwFbMaHgA0uNsh
        RntnQuL54pMs8LMPF0x5ZCZB6AcbUUKumu5r5/BBT6RdUcRSwIrhLnaMSK+ayLdTUq9Xjj
        mv7DdUqgOzgLf3VJjJJ+LV12y9VCvkI=
From:   Michael Walle <michael@walle.cc>
To:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Michael Walle <michael@walle.cc>, stable@vger.kernel.org
Subject: [PATCH v7 1/7] mtd: spi-nor: sst: fix BPn bits for the SST25VF064C
Date:   Thu,  3 Dec 2020 00:00:34 +0100
Message-Id: <20201202230040.14009-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201202230040.14009-1-michael@walle.cc>
References: <20201202230040.14009-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This flash part actually has 4 block protection bits.

Reported-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Michael Walle <michael@walle.cc>
---
I didn't add the Fixes: tag because we depend on the 4bit BP support which
was introduced in 5.7.

changes since v6:
 - new patch

 drivers/mtd/spi-nor/sst.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/sst.c b/drivers/mtd/spi-nor/sst.c
index e0af6d25d573..0ab07624fb73 100644
--- a/drivers/mtd/spi-nor/sst.c
+++ b/drivers/mtd/spi-nor/sst.c
@@ -18,7 +18,8 @@ static const struct flash_info sst_parts[] = {
 			      SECT_4K | SST_WRITE) },
 	{ "sst25vf032b", INFO(0xbf254a, 0, 64 * 1024, 64,
 			      SECT_4K | SST_WRITE) },
-	{ "sst25vf064c", INFO(0xbf254b, 0, 64 * 1024, 128, SECT_4K) },
+	{ "sst25vf064c", INFO(0xbf254b, 0, 64 * 1024, 128,
+			      SECT_4K | SPI_NOR_4BIT_BP) },
 	{ "sst25wf512",  INFO(0xbf2501, 0, 64 * 1024,  1,
 			      SECT_4K | SST_WRITE) },
 	{ "sst25wf010",  INFO(0xbf2502, 0, 64 * 1024,  2,
-- 
2.20.1

