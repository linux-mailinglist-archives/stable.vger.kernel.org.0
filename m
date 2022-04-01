Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4194EEB59
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343942AbiDAKe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343913AbiDAKe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:34:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9625D26E558
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 03:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34342612AC
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 10:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4932BC340F2;
        Fri,  1 Apr 2022 10:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648809188;
        bh=EDM/H93BjeQimefo9E/cln4TiOTd+LJ7qzR+NT1LynU=;
        h=Subject:To:Cc:From:Date:From;
        b=kpsBE9KtnARf0QZxIh/TyG+YPEaBz0U1F69ewz7zNlfTOiczkIg0tci0UXNOB2+Fn
         AykIOfYvbHlO2aFOc9qlVMx4Yx7hI9Uj/EFgqXCC5OZ/SdxyGtd2poNrhpAji0QeMY
         gNL8m5L7ViJdS5ym2oIjUE5UGSy2Z41J1Bw6ZoGc=
Subject: FAILED: patch "[PATCH] mtd: spi-nor: Skip erase logic when SPI_NOR_NO_ERASE is set" failed to apply to 4.19-stable tree
To:     tudor.ambarus@microchip.com, michael@walle.cc
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 01 Apr 2022 12:32:55 +0200
Message-ID: <16488091757220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 151c6b49d679872d6fc0b50e0ad96303091694a2 Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Mon, 28 Feb 2022 18:33:34 +0200
Subject: [PATCH] mtd: spi-nor: Skip erase logic when SPI_NOR_NO_ERASE is set

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

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 9014008e60b3..b4f141ad9c9c 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2948,10 +2948,11 @@ static void spi_nor_set_mtd_info(struct spi_nor *nor)
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

