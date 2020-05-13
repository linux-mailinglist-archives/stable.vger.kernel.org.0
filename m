Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 044B51D1AB6
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 18:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389499AbgEMQJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 12:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389465AbgEMQJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 12:09:47 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFD7C061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 09:09:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id F3BB42A02F5;
        Wed, 13 May 2020 17:09:45 +0100 (BST)
Date:   Wed, 13 May 2020 18:09:43 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <Tudor.Ambarus@microchip.com>,
        <linux-mtd@lists.infradead.org>, stable@vger.kernel.org
Subject: Re: [PATCH resend] mtd: spinand: Propagate ECC information to the
 MTD structure
Message-ID: <20200513180943.63efe337@collabora.com>
In-Reply-To: <20200513131029.15603-1-miquel.raynal@bootlin.com>
References: <20200513131029.15603-1-miquel.raynal@bootlin.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 13 May 2020 15:10:29 +0200
Miquel Raynal <miquel.raynal@bootlin.com> wrote:

> This is done by default in the raw NAND core (nand_base.c) but was
> missing in the SPI-NAND core. Without these two lines the ecc_strength
> and ecc_step_size values are not exported to the user through sysfs.
> 
> This fix depends on recent changes and should not be backported as-is.
> 
> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
> 
> This patch is extracted from a bigger series and needs to be merged
> now as a fix. I haven't changed anything from it's original
> submission.
> 
>  drivers/mtd/nand/spi/core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
> index b6bb358b96ce..248c4d7a0cf4 100644
> --- a/drivers/mtd/nand/spi/core.c
> +++ b/drivers/mtd/nand/spi/core.c
> @@ -1089,6 +1089,10 @@ static int spinand_init(struct spinand_device *spinand)
>  
>  	mtd->oobavail = ret;
>  
> +	/* Propagate ECC information to mtd_info */
> +	mtd->ecc_strength = nand->ecc.ctx.conf.strength;
> +	mtd->ecc_step_size = nand->ecc.ctx.conf.step_size;
> +
>  	return 0;
>  
>  err_cleanup_nanddev:

