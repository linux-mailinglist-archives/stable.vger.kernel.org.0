Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38720595790
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 12:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbiHPKIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 06:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiHPKHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 06:07:54 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF23DCE5;
        Tue, 16 Aug 2022 02:09:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 9CDC96600363;
        Tue, 16 Aug 2022 10:09:55 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1660640996;
        bh=UwVGjoVej6+DPEt5C/pkEjitJeLt0M/cBydSA/bfdQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AosFn7pt+1QLjDkVNSdhDB41d34g7CimXuprljhvI4FPZzI/laLs4D7OYOoDW36HS
         dOu6VsOLip5jf3+BQYcKxmFeS00kV++m/EStvYtkOpLTaM7BYTaVP5WknUdN6m9VAs
         65C0t5G+EYsLoqJhAHp38iC5F/L5ypYw4cFpL4NMifsE8ffzL+P+xNE9AU85EI2Fyu
         th6t3OcJIFVpGOyBfjYDss2KPSrGNjB7gqMERN7M8eqTqd9QIdRuL7VXjVwnkX2XNd
         chHsM/k9URQXyEceZkksJXFEm4wbSUA5eG7TGAlnSe6/gKFI54MqHzQcrhBkU94HU/
         IB/mHt905bmsA==
Date:   Tue, 16 Aug 2022 11:09:52 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Tudor Ambarus <tudor.ambarus@microchip.com>
Cc:     <miquel.raynal@bootlin.com>, <richard@nod.at>, <vigneshr@ti.com>,
        <peda@axentia.se>, <nicolas.ferre@microchip.com>,
        <alexandre.belloni@bootlin.com>, <claudiu.beznea@microchip.com>,
        <bbrezillon@kernel.org>, <linux-mtd@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mtd: rawnand: atmel: Unmap streaming DMA mappings
Message-ID: <20220816110952.31cf212b@collabora.com>
In-Reply-To: <20220728074014.145406-1-tudor.ambarus@microchip.com>
References: <20220728074014.145406-1-tudor.ambarus@microchip.com>
Organization: Collabora
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 28 Jul 2022 10:40:14 +0300
Tudor Ambarus <tudor.ambarus@microchip.com> wrote:

> Every dma_map_single() call should have its dma_unmap_single() counterpart,
> because the DMA address space is a shared resource and one could render the
> machine unusable by consuming all DMA addresses.
> 
> Cc: stable@vger.kernel.org
> Fixes: f88fc122cc34 ("mtd: nand: Cleanup/rework the atmel_nand driver")
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  drivers/mtd/nand/raw/atmel/nand-controller.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mtd/nand/raw/atmel/nand-controller.c b/drivers/mtd/nand/raw/atmel/nand-controller.c
> index 6ef14442c71a..330d2dafdd2d 100644
> --- a/drivers/mtd/nand/raw/atmel/nand-controller.c
> +++ b/drivers/mtd/nand/raw/atmel/nand-controller.c
> @@ -405,6 +405,7 @@ static int atmel_nand_dma_transfer(struct atmel_nand_controller *nc,
>  
>  	dma_async_issue_pending(nc->dmac);
>  	wait_for_completion(&finished);
> +	dma_unmap_single(nc->dev, buf_dma, len, dir);
>  
>  	return 0;
>  

