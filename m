Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659BE499FD6
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1842235AbiAXXBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:01:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837266AbiAXWnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:43:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2573BC06B5B3;
        Mon, 24 Jan 2022 13:05:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2A1DB812A4;
        Mon, 24 Jan 2022 21:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C774C340E5;
        Mon, 24 Jan 2022 21:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058327;
        bh=600Hk523HnsrfpbtHaU+cy1D3C+NbPHA0zIhJYZR4X4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W/aQrUEW++ieWvYbgzy7sLoOLBK7IgPwr0NmLiOLi79Caq7W67fEplGND2UCxF0//
         p5zwvndYwqlBYs/CXm7h+5SEmzq53f8fuigknZOcdGB4vQSHxCeqAas5HHpaBkvFur
         deAvd2hnxejESX9HSU0IGG9gggdTIKQQPc0CtUUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0253/1039] mtd: spi-nor: Fix mtd size for s3an flashes
Date:   Mon, 24 Jan 2022 19:34:02 +0100
Message-Id: <20220124184133.828118858@linuxfoundation.org>
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

[ Upstream commit f656b419d41aabafb6b526abc3988dfbf2e5c1ba ]

As it was before the blamed commit, s3an_nor_scan() was called
after mtd size was set with params->size, and it overwrote the mtd
size value with '8 * nor->page_size * nor->info->n_sectors' when
XSR_PAGESIZE was set. With the introduction of
s3an_post_sfdp_fixups(), we missed to update the mtd size for the
s3an flashes. Fix the mtd size by updating both nor->params->size,
(which will update the mtd_info size later on) and nor->mtd.size
(which is used in spi_nor_set_addr_width()).

Fixes: 641edddb4f43 ("mtd: spi-nor: Add s3an_post_sfdp_fixups()")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Link: https://lore.kernel.org/r/20211207140254.87681-2-tudor.ambarus@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/xilinx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/xilinx.c b/drivers/mtd/spi-nor/xilinx.c
index 0658e47564bac..0ac1d681e84d5 100644
--- a/drivers/mtd/spi-nor/xilinx.c
+++ b/drivers/mtd/spi-nor/xilinx.c
@@ -69,7 +69,8 @@ static int xilinx_nor_setup(struct spi_nor *nor,
 		page_size = (nor->params->page_size == 264) ? 256 : 512;
 		nor->params->page_size = page_size;
 		nor->mtd.writebufsize = page_size;
-		nor->mtd.size = 8 * page_size * nor->info->n_sectors;
+		nor->params->size = 8 * page_size * nor->info->n_sectors;
+		nor->mtd.size = nor->params->size;
 		nor->mtd.erasesize = 8 * page_size;
 	} else {
 		/* Flash in Default addressing mode */
-- 
2.34.1



