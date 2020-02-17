Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E576C1618BF
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 18:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgBQRYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 12:24:46 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:42764 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729584AbgBQRYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 12:24:46 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 1D9BE2667C2;
        Mon, 17 Feb 2020 17:24:44 +0000 (GMT)
Date:   Mon, 17 Feb 2020 18:24:38 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Schrempf Frieder <frieder.schrempf@kontron.de>
Cc:     Boris Brezillon <bbrezillon@kernel.org>,
        Jeff Kletsky <git-commits@allycomm.com>,
        liaoweixiong <liaoweixiong@allwinnertech.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] mtd: spinand: Don not erase the block before
 writing a bad block marker
Message-ID: <20200217182438.76a25592@collabora.com>
In-Reply-To: <20200217155213.5594-4-frieder.schrempf@kontron.de>
References: <20200217155213.5594-1-frieder.schrempf@kontron.de>
        <20200217155213.5594-4-frieder.schrempf@kontron.de>
Organization: Collabora
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In the subject: s/Don not/Do not/

On Mon, 17 Feb 2020 15:54:12 +0000
Schrempf Frieder <frieder.schrempf@kontron.de> wrote:

> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> Currently when marking a block, we use spinand_erase_op() to erase
> the block before writing the marker to the OOB area. Doing so without
> waiting for the operation to finish can lead to the marking failing
> silently and no bad block marker being written to the flash.
> 
> In fact we don't need to do an erase at all before writing the BBM.
> The ECC is disabled for the raw access to the OOB data and we don't

			  s/the raw access/raw accesses/

> need to work around any issues with chips reporting ECC errors as it
> is known to be the case for raw NAND.
> 
> Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
> Changes in v2:
>  * Instead of waiting for the erase operation to finish, just don't
>    do an erase at all, as it is not needed.
>  * Update the commit message
> ---
>  drivers/mtd/nand/spi/core.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
> index a94287884453..8dda51bbdd11 100644
> --- a/drivers/mtd/nand/spi/core.c
> +++ b/drivers/mtd/nand/spi/core.c
> @@ -613,7 +613,6 @@ static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
>  	};
>  	int ret;
>  
> -	/* Erase block before marking it bad. */
>  	ret = spinand_select_target(spinand, pos->target);
>  	if (ret)
>  		return ret;
> @@ -622,8 +621,6 @@ static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
>  	if (ret)
>  		return ret;
>  
> -	spinand_erase_op(spinand, pos);
> -
>  	return spinand_write_page(spinand, &req);
>  }
>  

