Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2865A657D25
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbiL1Pj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbiL1Pj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:39:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8C1C167DF
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:39:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70598B81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAADBC433EF;
        Wed, 28 Dec 2022 15:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241993;
        bh=B4p6ac1vo6S4lnTO/r0DmYyqz4wQjAU534Px32b8+Ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bID2/eZScwAF1zMnX4qf0cDIleNE2irAhiUiHmpJ9e+ja2+HSwgAafNAXnF+qH8e/
         HcxyYpeW0sPTSLuTVNy6cU1YLPu0T9swQ4nCUCUH4LNp5p84nsr7ZW1eFmiFUJPVr4
         bJRUsrtlHRo6q67ODToaniSemFBp8BujiMtaY2GA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Bayi Cheng <bayi.cheng@mediatek.com>,
        Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Dhruva Gole <d-gole@ti.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Pratyush Yadav <pratyush@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0352/1073] mtd: spi-nor: Fix the number of bytes for the dummy cycles
Date:   Wed, 28 Dec 2022 15:32:20 +0100
Message-Id: <20221228144337.566254840@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Allen-KH Cheng <allen-kh.cheng@mediatek.com>

[ Upstream commit fdc20370d93e8c6d2f448a539d08c2c064af7694 ]

The number of bytes used by spi_nor_spimem_check_readop() may be
incorrect for the dummy cycles. Since nor->read_dummy is not initialized
before spi_nor_spimem_adjust_hwcaps().

We use both mode and wait state clock cycles instead of nor->read_dummy.

Fixes: 0e30f47232ab ("mtd: spi-nor: add support for DTR protocol")
Co-developed-by: Bayi Cheng <bayi.cheng@mediatek.com>
Signed-off-by: Bayi Cheng <bayi.cheng@mediatek.com>
Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Tested-by: Dhruva Gole <d-gole@ti.com>
Tested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Link: https://lore.kernel.org/r/20221031124633.13189-1-allen-kh.cheng@mediatek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index bee8fc4c9f07..0cf1a1797ea3 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1914,7 +1914,8 @@ static int spi_nor_spimem_check_readop(struct spi_nor *nor,
 	spi_nor_spimem_setup_op(nor, &op, read->proto);
 
 	/* convert the dummy cycles to the number of bytes */
-	op.dummy.nbytes = (nor->read_dummy * op.dummy.buswidth) / 8;
+	op.dummy.nbytes = (read->num_mode_clocks + read->num_wait_states) *
+			  op.dummy.buswidth / 8;
 	if (spi_nor_protocol_is_dtr(nor->read_proto))
 		op.dummy.nbytes *= 2;
 
-- 
2.35.1



