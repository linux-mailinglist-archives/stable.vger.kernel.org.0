Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34172E40B1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408078AbgL1Ozb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:55:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:51948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441329AbgL1ORB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:17:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 301C4207B2;
        Mon, 28 Dec 2020 14:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165005;
        bh=xb0Uv21e94yMnrikOM3ZpNUJhYWgw2Lpwh5CLNix+K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y3uCfk5FMKGJuwV9x6FCIi7hK0uHwydQCHNEgxBaEnyex7jMTamqzHKkuStqSO9Hu
         E1PjZY89J1V31vHAk6l0jPz7gWUWWL8azQtCH9Q9SwOAY4lVTPdOgHzvu7ffr1MzjB
         qa/7rOKbzegnFrEHQ5vcfqjZn0heNAyjqWPYnNkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Michael Walle <michael@walle.cc>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 346/717] mtd: spi-nor: sst: fix BPn bits for the SST25VF064C
Date:   Mon, 28 Dec 2020 13:45:44 +0100
Message-Id: <20201228125037.603931498@linuxfoundation.org>
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

[ Upstream commit 989d4b72bae3b05c1564d38e71e18f65b12734fb ]

This flash part actually has 4 block protection bits.

Please note, that this patch is just based on information of the
datasheet of the datasheet and wasn't tested.

Fixes: 3e0930f109e7 ("mtd: spi-nor: Rework the disabling of block write protection")
Reported-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20201203162959.29589-2-michael@walle.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/sst.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/sst.c b/drivers/mtd/spi-nor/sst.c
index e0af6d25d573b..0ab07624fb73f 100644
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
2.27.0



