Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7554A1610E9
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 12:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbgBQLRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 06:17:25 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:39058 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728788AbgBQLRZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 06:17:25 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 61D4B293121;
        Mon, 17 Feb 2020 11:17:23 +0000 (GMT)
Date:   Mon, 17 Feb 2020 12:17:17 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Jeff Kletsky <git-commits@allycomm.com>,
        liaoweixiong <liaoweixiong@allwinnertech.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Peter Pan <peterpandong@micron.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Richard Weinberger" <richard@nod.at>
Subject: Re: [PATCH 1/3] mtd: spinand: Stop using spinand->oobbuf for
 buffering bad block markers
Message-ID: <20200217121717.2152db2c@collabora.com>
In-Reply-To: <20200211163452.25442-2-frieder.schrempf@kontron.de>
References: <20200211163452.25442-1-frieder.schrempf@kontron.de>
        <20200211163452.25442-2-frieder.schrempf@kontron.de>
Organization: Collabora
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 11 Feb 2020 16:35:33 +0000
Schrempf Frieder <frieder.schrempf@kontron.de> wrote:

> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> For reading and writing the bad block markers, spinand->oobbuf is
> currently used as a buffer for the marker bytes. During the
> underlying read and write operations to actually get/set the content
> of the OOB area, the content of spinand->oobbuf is reused and changed
> by accessing it through spinand->oobbuf and/or spinand->databuf.
> 
> This is a flaw in the original design of the SPI MEM core and at the
> latest from 13c15e07eedf ("mtd: spinand: Handle the case where
> PROGRAM LOAD does not reset the cache") on, it results in not having
> the bad block marker written at all, as the spinand->oobbuf is
> cleared to 0xff after setting the marker bytes to zero.
> 
> To fix it, we now just store the two bytes for the marker on the
> stack and let the read/write operations copy it from/to the page
> buffer later.
> 
> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> ---
>  drivers/mtd/nand/spi/core.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
> index 89f6beefb01c..5d267a67a5f7 100644
> --- a/drivers/mtd/nand/spi/core.c
> +++ b/drivers/mtd/nand/spi/core.c
> @@ -568,18 +568,18 @@ static int spinand_mtd_write(struct mtd_info *mtd, loff_t to,
>  static bool spinand_isbad(struct nand_device *nand, const struct nand_pos *pos)
>  {
>  	struct spinand_device *spinand = nand_to_spinand(nand);
> +	u8 marker[] = { 0, 0 };

How about

	u8 marker[2] = { };

?

>  	struct nand_page_io_req req = {
>  		.pos = *pos,
>  		.ooblen = 2,

		.ooblen = sizeof(marker),

>  		.ooboffs = 0,
> -		.oobbuf.in = spinand->oobbuf,
> +		.oobbuf.in = marker,
>  		.mode = MTD_OPS_RAW,
>  	};
>  
> -	memset(spinand->oobbuf, 0, 2);
>  	spinand_select_target(spinand, pos->target);
>  	spinand_read_page(spinand, &req, false);
> -	if (spinand->oobbuf[0] != 0xff || spinand->oobbuf[1] != 0xff)
> +	if (marker[0] != 0xff || marker[1] != 0xff)
>  		return true;
>  
>  	return false;
> @@ -603,11 +603,12 @@ static int spinand_mtd_block_isbad(struct mtd_info *mtd, loff_t offs)
>  static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
>  {
>  	struct spinand_device *spinand = nand_to_spinand(nand);
> +	u8 marker[] = { 0, 0 };
>  	struct nand_page_io_req req = {
>  		.pos = *pos,
>  		.ooboffs = 0,
>  		.ooblen = 2,
> -		.oobbuf.out = spinand->oobbuf,
> +		.oobbuf.out = marker,

Ditto.

>  	};
>  	int ret;
>  
> @@ -622,7 +623,6 @@ static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
>  
>  	spinand_erase_op(spinand, pos);
>  
> -	memset(spinand->oobbuf, 0, 2);
>  	return spinand_write_page(spinand, &req);
>  }
>  

With these minor things addressed

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
