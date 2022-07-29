Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E3C584F5A
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 13:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbiG2LIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 07:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbiG2LIw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 07:08:52 -0400
X-Greylist: delayed 532 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 29 Jul 2022 04:08:52 PDT
Received: from mail.thorsis.com (mail.thorsis.com [92.198.35.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 062456F7DE;
        Fri, 29 Jul 2022 04:08:51 -0700 (PDT)
From:   Alexander Dahl <ada@thorsis.com>
To:     linux-mtd@lists.infradead.org
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        peda@axentia.se, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, claudiu.beznea@microchip.com,
        bbrezillon@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mtd: rawnand: atmel: Unmap streaming DMA mappings
Date:   Fri, 29 Jul 2022 12:59:55 +0200
Message-ID: <2099405.mp5hVA6q5l@ada>
In-Reply-To: <20220728074014.145406-1-tudor.ambarus@microchip.com>
References: <20220728074014.145406-1-tudor.ambarus@microchip.com>
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Clacks-Overhead: GNU Terry Pratchett
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Tudor,

Am Donnerstag, 28. Juli 2022, 09:40:14 CEST schrieb Tudor Ambarus:
> Every dma_map_single() call should have its dma_unmap_single() counterpart,
> because the DMA address space is a shared resource and one could render the
> machine unusable by consuming all DMA addresses.
> 
> Cc: stable@vger.kernel.org
> Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  drivers/mtd/nand/raw/atmel/nand-controller.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c
> b/drivers/mtd/nand/raw/atmel/nand-controller.c index
> 6ef14442c71a..330d2dafdd2d 100644
> --- a/drivers/mtd/nand/raw/atmel/nand-controller.c
> +++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
> @@ -405,6 +405,7 @@ static int atmel_nand_dma_transfer(struct
> atmel_nand_controller *nc,
> 
>  	dma_async_issue_pending(nc->dmac);
>  	wait_for_completion(&finished);
> +	dma_unmap_single(nc->dev, buf_dma, len, dir);
> 
>  	return 0;

Acked-by: Alexander Dahl <ada@thorsis.com>

After studying 
https://www.kernel.org/doc/html/latest/core-api/dma-api-howto.html
this seems like the correct thing to do to me.

I was made aware of this patch in IRC, after discussing a strange lzo 
decompression and/or page reading error with Richard after upgrading from 
kernel v5.2.21-rt13 to v5.15.49-rt47.

Now testing this on top of 5.15.49-rt47 on two boards, both with Microchip 
sama5d27c 128MiB SiP and Spansion S34ML02G1 raw nand flash. Will report later.

Thanks and greets
Alex



