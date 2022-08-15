Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42E425939A4
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243925AbiHOTZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245603AbiHOTXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:23:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2ED02ED4D;
        Mon, 15 Aug 2022 11:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1976E6117D;
        Mon, 15 Aug 2022 18:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFC1C433D7;
        Mon, 15 Aug 2022 18:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588844;
        bh=gFrUklpuRgI6eVxNJB5v/dnFrPZN8LmmVIzIU24QMHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FCAUUlDCCf8yaZiM574L7d+ePdAuhie4K3HAtFROh2r8wnQ72QQIaBBfPcc3EMHA5
         HtYFt9P5rWUI1OrfmBzIe32+JaHRf/o+x9FUaWiAXY1RzJZXUoE9K/8aTcjj+KXm9w
         Gw/1Om0xebWyPkmyuMaKj0w17D20JXuQcpsGqYPI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Alexander Sverdlin <alexander.sverdlin@nokia.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 533/779] mtd: spi-nor: fix spi_nor_spimem_setup_op() call in spi_nor_erase_{sector,chip}()
Date:   Mon, 15 Aug 2022 20:02:57 +0200
Message-Id: <20220815180400.072136972@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrice Chotard <patrice.chotard@foss.st.com>

[ Upstream commit f8cd9f632f4415b1e8838bdca8ab42cfb37a6584 ]

For erase operations, reg_proto must be used as indicated in
struct spi_nor description in spi-nor.h.

This issue was found when DT property spi-tx-bus-width is set to 4.
In this case the spi_mem_op->addr.buswidth is set to 4 for erase command
which is not correct.

Tested on stm32mp157c-ev1 board with mx66l51235f spi-nor.

Fixes: 0e30f47232ab ("mtd: spi-nor: add support for DTR protocol")
Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
[ta: use nor->reg_proto in spi_nor_controller_ops_erase()]
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Tested-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Link: https://lore.kernel.org/r/20220629133013.3382393-1-patrice.chotard@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index d97cdbc2b9de..eb5d7b3d1860 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -177,7 +177,7 @@ static int spi_nor_controller_ops_write_reg(struct spi_nor *nor, u8 opcode,
 
 static int spi_nor_controller_ops_erase(struct spi_nor *nor, loff_t offs)
 {
-	if (spi_nor_protocol_is_dtr(nor->write_proto))
+	if (spi_nor_protocol_is_dtr(nor->reg_proto))
 		return -EOPNOTSUPP;
 
 	return nor->controller_ops->erase(nor, offs);
@@ -1195,7 +1195,7 @@ static int spi_nor_erase_chip(struct spi_nor *nor)
 				   SPI_MEM_OP_NO_DUMMY,
 				   SPI_MEM_OP_NO_DATA);
 
-		spi_nor_spimem_setup_op(nor, &op, nor->write_proto);
+		spi_nor_spimem_setup_op(nor, &op, nor->reg_proto);
 
 		ret = spi_mem_exec_op(nor->spimem, &op);
 	} else {
@@ -1340,7 +1340,7 @@ int spi_nor_erase_sector(struct spi_nor *nor, u32 addr)
 				   SPI_MEM_OP_NO_DUMMY,
 				   SPI_MEM_OP_NO_DATA);
 
-		spi_nor_spimem_setup_op(nor, &op, nor->write_proto);
+		spi_nor_spimem_setup_op(nor, &op, nor->reg_proto);
 
 		return spi_mem_exec_op(nor->spimem, &op);
 	} else if (nor->controller_ops->erase) {
-- 
2.35.1



