Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4E84F255D
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiDEHt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbiDEHqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:46:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34535986ED;
        Tue,  5 Apr 2022 00:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F80F616BF;
        Tue,  5 Apr 2022 07:41:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585C1C340EE;
        Tue,  5 Apr 2022 07:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144501;
        bh=kKv3h1PM8s2Yt6ZDkeIQfYvCSD2E814Yxv5WpEI05aY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dM42QHxKg/taDjS7PSnmCMD5oP/VJN6bocBi7tBmT8RVTFX6cCLX2kqRu75yXto88
         BlCIH0PNkYZOxZn5xSFdEwpYxHnz/CiMcrgDpTaOu0EEAaL/Os5fuFihNcQnMwjHGQ
         g/m7baRprhZfrxkqR4NEbcP+Agg4FpT2lFPjK/y0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH 5.17 0068/1126] mtd: spi-nor: Skip erase logic when SPI_NOR_NO_ERASE is set
Date:   Tue,  5 Apr 2022 09:13:35 +0200
Message-Id: <20220405070409.565822309@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 151c6b49d679872d6fc0b50e0ad96303091694a2 upstream.

Even if SPI_NOR_NO_ERASE was set, one could still send erase opcodes
to the flash. It is not recommended to send unsupported opcodes to
flashes. Fix the logic and do not set mtd->_erase when SPI_NOR_NO_ERASE
is specified. With this users will not be able to issue erase opcodes to
flashes and instead they will recive an -ENOTSUPP error.

Fixes: b199489d37b2 ("mtd: spi-nor: add the framework for SPI NOR")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220228163334.277730-1-tudor.ambarus@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -3181,10 +3181,11 @@ static void spi_nor_set_mtd_info(struct
 	mtd->flags = MTD_CAP_NORFLASH;
 	if (nor->info->flags & SPI_NOR_NO_ERASE)
 		mtd->flags |= MTD_NO_ERASE;
+	else
+		mtd->_erase = spi_nor_erase;
 	mtd->writesize = nor->params->writesize;
 	mtd->writebufsize = nor->params->page_size;
 	mtd->size = nor->params->size;
-	mtd->_erase = spi_nor_erase;
 	mtd->_read = spi_nor_read;
 	/* Might be already set by some SST flashes. */
 	if (!mtd->_write)


