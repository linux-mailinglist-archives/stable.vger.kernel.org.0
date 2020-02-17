Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8B91610D1
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 12:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgBQLOI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 17 Feb 2020 06:14:08 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38990 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgBQLOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 06:14:08 -0500
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 1CC2D29313C;
        Mon, 17 Feb 2020 11:14:06 +0000 (GMT)
Date:   Mon, 17 Feb 2020 12:14:02 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Schrempf Frieder <frieder.schrempf@kontron.de>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Jeff Kletsky <git-commits@allycomm.com>,
        liaoweixiong <liaoweixiong@allwinnertech.com>,
        Peter Pan <peterpandong@micron.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Richard Weinberger" <richard@nod.at>
Subject: Re: [PATCH 3/3] mtd: spinand: Wait for the erase op to finish
 before writing a bad block marker
Message-ID: <20200217121402.44e00350@collabora.com>
In-Reply-To: <20200217113919.0508acc4@xps13>
References: <20200211163452.25442-1-frieder.schrempf@kontron.de>
        <20200211163452.25442-4-frieder.schrempf@kontron.de>
        <20200217113919.0508acc4@xps13>
Organization: Collabora
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 17 Feb 2020 11:39:19 +0100
Miquel Raynal <miquel.raynal@bootlin.com> wrote:

> Hi Frieder,
> 
> Schrempf Frieder <frieder.schrempf@kontron.de> wrote on Tue, 11 Feb
> 2020 16:35:53 +0000:
> 
> > From: Frieder Schrempf <frieder.schrempf@kontron.de>
> > 
> > Currently when marking a block, we use spinand_erase_op() to erase
> > the block before writing the marker to the OOB area without waiting
> > for the operation to succeed. This can lead to the marking failing
> > silently and no bad block marker being written to the flash.
> > 
> > To fix this we reuse the spinand_erase() function, that already does
> > everything we need to do before actually writing the marker.
> >   
> 
> Thanks a lot for this series!
> 
> Yet I don't really understand the point of waiting for the erasure if
> it failed: we don't really care as programming (1 -> 0) cells is always
> possible. Are you sure this lead to an error?

Actually, I think I already pointed out that we should probably write
the BBM without erasing the block. IIRC, this logic has been copied
from rawnand where some controllers don't disable the ECC engine when
doing raw accesses, leading to ECC errors if the block is not erased
before BBMs are programmed. Assuming we don't let such drivers being
merged in spinand, this erase operation can be dropped.

> 
> Also, why just not calling spinand_erase() instead of
> spinand_erase_op() from spinand_markbad()?
> 
> > Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
> > ---
> >  drivers/mtd/nand/spi/core.c | 56 ++++++++++++++++++-------------------
> >  1 file changed, 28 insertions(+), 28 deletions(-)
> > 
> > diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
> > index 925db6269861..8a69d13639e2 100644
> > --- a/drivers/mtd/nand/spi/core.c
> > +++ b/drivers/mtd/nand/spi/core.c
> > @@ -600,6 +600,32 @@ static int spinand_mtd_block_isbad(struct mtd_info *mtd, loff_t offs)
> >  	return ret;
> >  }
> >  
> > +static int __spinand_erase(struct nand_device *nand, const struct nand_pos *pos,
> > +			   bool hard_fail)

I hate those __ prefix. Please find a more descriptive name
(spinand_erase_block() or spinand_erase_and_wait()?)

> > +{
> > +	struct spinand_device *spinand = nand_to_spinand(nand);
> > +	u8 status;
> > +	int ret;
> > +
> > +	ret = spinand_select_target(spinand, pos->target);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = spinand_write_enable_op(spinand);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = spinand_erase_op(spinand, pos);
> > +	if (ret && hard_fail)
> > +		return ret;
> > +
> > +	ret = spinand_wait(spinand, &status);
> > +	if (!ret && (status & STATUS_ERASE_FAILED))
> > +		ret = -EIO;
> > +
> > +	return ret;
> > +}
> > +
> >  static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
> >  {
> >  	struct spinand_device *spinand = nand_to_spinand(nand);
> > @@ -614,16 +640,10 @@ static int spinand_markbad(struct nand_device *nand, const struct nand_pos *pos)
> >  	int ret;
> >  
> >  	/* Erase block before marking it bad. */
> > -	ret = spinand_select_target(spinand, pos->target);
> > -	if (ret)
> > -		return ret;
> > -
> > -	ret = spinand_write_enable_op(spinand);
> > +	ret = __spinand_erase(nand, pos, false);
> >  	if (ret)
> >  		return ret;
> >  
> > -	spinand_erase_op(spinand, pos);
> > -
> >  	return spinand_write_page(spinand, &req);
> >  }
> >  
> > @@ -644,27 +664,7 @@ static int spinand_mtd_block_markbad(struct mtd_info *mtd, loff_t offs)
> >  
> >  static int spinand_erase(struct nand_device *nand, const struct nand_pos *pos)
> >  {
> > -	struct spinand_device *spinand = nand_to_spinand(nand);
> > -	u8 status;
> > -	int ret;
> > -
> > -	ret = spinand_select_target(spinand, pos->target);
> > -	if (ret)
> > -		return ret;
> > -
> > -	ret = spinand_write_enable_op(spinand);
> > -	if (ret)
> > -		return ret;
> > -
> > -	ret = spinand_erase_op(spinand, pos);
> > -	if (ret)
> > -		return ret;
> > -
> > -	ret = spinand_wait(spinand, &status);
> > -	if (!ret && (status & STATUS_ERASE_FAILED))
> > -		ret = -EIO;
> > -
> > -	return ret;
> > +	return __spinand_erase(nand, pos, true);
> >  }
> >  
> >  static int spinand_mtd_erase(struct mtd_info *mtd,  
> 
> Thanks,
> Miquèl

