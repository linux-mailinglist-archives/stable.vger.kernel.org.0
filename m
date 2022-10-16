Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883BB5FFDAC
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 08:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiJPGwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 02:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiJPGwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 02:52:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0A43D581
        for <stable@vger.kernel.org>; Sat, 15 Oct 2022 23:52:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FFE060A4C
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 06:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86768C433D6;
        Sun, 16 Oct 2022 06:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665903135;
        bh=rJ2a8Bxr4zXVdoEJJY33DdPQWDfvYtKnCNW4DiInKcc=;
        h=Subject:To:Cc:From:Date:From;
        b=D9bdyxTN+VKdkGhxs1M4JPmbK4l9oVwFKEtBb1Pww2/bTCMhIdOOgxu33Otxx8sF/
         Q22twAsm+h3T+TeooEJkDMAOocOdig3YR+sqqKw76GzRQTHBWRD/+oJ4UDQ7oBc65C
         Q7RHh9QrbPRwbo75hwcTx4m2r8nvheA+ZKvisDYk=
Subject: FAILED: patch "[PATCH] mtd: rawnand: atmel: Unmap streaming DMA mappings" failed to apply to 4.14-stable tree
To:     tudor.ambarus@microchip.com, ada@thorsis.com,
        boris.brezillon@collabora.com, miquel.raynal@bootlin.com,
        peda@axentia.se
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 08:53:02 +0200
Message-ID: <1665903182202224@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1161703c9bd6 ("mtd: rawnand: atmel: Unmap streaming DMA mappings")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1161703c9bd664da5e3b2eb1a3bb40c210e026ea Mon Sep 17 00:00:00 2001
From: Tudor Ambarus <tudor.ambarus@microchip.com>
Date: Thu, 28 Jul 2022 10:40:14 +0300
Subject: [PATCH] mtd: rawnand: atmel: Unmap streaming DMA mappings

Every dma_map_single() call should have its dma_unmap_single() counterpart,
because the DMA address space is a shared resource and one could render the
machine unusable by consuming all DMA addresses.

Link: https://lore.kernel.org/lkml/13c6c9a2-6db5-c3bf-349b-4c127ad3496a@axentia.se/
Cc: stable@vger.kernel.org
Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Alexander Dahl <ada@thorsis.com>
Reported-by: Peter Rosin <peda@axentia.se>
Tested-by: Alexander Dahl <ada@thorsis.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Tested-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220728074014.145406-1-tudor.ambarus@microchip.com

diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
index c9ac3baf68c0..41c6bd6e2d72 100644
--- a/drivers/mtd/nand/raw/atmel/nand-controller.c
+++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
@@ -405,6 +405,7 @@ static int atmel_nand_dma_transfer(struct atmel_nand_controller *nc,
 
 	dma_async_issue_pending(nc->dmac);
 	wait_for_completion(&finished);
+	dma_unmap_single(nc->dev, buf_dma, len, dir);
 
 	return 0;
 

