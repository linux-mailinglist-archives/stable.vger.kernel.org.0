Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9401A42ECC9
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 10:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234590AbhJOIx4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 15 Oct 2021 04:53:56 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:44853 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbhJOIx4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 04:53:56 -0400
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id D9F6624000C;
        Fri, 15 Oct 2021 08:51:47 +0000 (UTC)
Date:   Fri, 15 Oct 2021 10:51:46 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Harvey Hunt <harveyhuntnexus@gmail.com>, list@opendingux.net,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] mtd: rawnand: Export
 nand_read_page_hwecc_oob_first()
Message-ID: <20211015105146.3d2fbd08@xps13>
In-Reply-To: <70G01R.2VROMW06O3O83@crapouillou.net>
References: <20211009184952.24591-1-paul@crapouillou.net>
        <20211009184952.24591-3-paul@crapouillou.net>
        <20211015081313.60018976@xps13>
        <70G01R.2VROMW06O3O83@crapouillou.net>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

paul@crapouillou.net wrote on Fri, 15 Oct 2021 09:38:31 +0100:

> Hi Miquel,
> 
> Le ven., oct. 15 2021 at 08:13:13 +0200, Miquel Raynal <miquel.raynal@bootlin.com> a écrit :
> > Hi Paul,
> > 
> > paul@crapouillou.net wrote on Sat,  9 Oct 2021 20:49:51 +0200:
> >   
> >>  Move the function nand_read_page_hwecc_oob_first() (previously
> >>  nand_davinci_read_page_hwecc_oob_first()) to nand_base.c, and >> export it
> >>  as a GPL symbol, so that it can be used by more modules.  
> >> >>  Cc: <stable@vger.kernel.org> # v5.2  
> >>  Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the >> JZ4740")
> >>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> >>  ---
> >>   drivers/mtd/nand/raw/davinci_nand.c | 70 >> +----------------------------
> >>   drivers/mtd/nand/raw/nand_base.c    | 69 >> ++++++++++++++++++++++++++++
> >>   include/linux/mtd/rawnand.h         |  2 +
> >>   3 files changed, 72 insertions(+), 69 deletions(-)  
> >> >>  diff --git a/drivers/mtd/nand/raw/davinci_nand.c >> b/drivers/mtd/nand/raw/davinci_nand.c  
> >>  index 89de24d3bb7a..45fec8c192ab 100644
> >>  --- a/drivers/mtd/nand/raw/davinci_nand.c
> >>  +++ b/drivers/mtd/nand/raw/davinci_nand.c
> >>  @@ -371,74 +371,6 @@ static int nand_davinci_correct_4bit(struct >> nand_chip *chip, u_char *data,
> >>   	return corrected;
> >>   }  
> >> >>  -/**  
> >>  - * nand_read_page_hwecc_oob_first - hw ecc, read oob first
> >>  - * @chip: nand chip info structure
> >>  - * @buf: buffer to store read data
> >>  - * @oob_required: caller requires OOB data read to chip->oob_poi
> >>  - * @page: page number to read
> >>  - *
> >>  - * Hardware ECC for large page chips, require OOB to be read >> first. For this
> >>  - * ECC mode, the write_page method is re-used from ECC_HW. These >> methods
> >>  - * read/write ECC from the OOB area, unlike the ECC_HW_SYNDROME >> support with
> >>  - * multiple ECC steps, follows the "infix ECC" scheme and >> reads/writes ECC from
> >>  - * the data area, by overwriting the NAND manufacturer bad block >> markings.
> >>  - */
> >>  -static int nand_davinci_read_page_hwecc_oob_first(struct nand_chip >> *chip,
> >>  -						  uint8_t *buf,
> >>  -						  int oob_required, int page)
> >>  -{
> >>  -	struct mtd_info *mtd = nand_to_mtd(chip);
> >>  -	int i, eccsize = chip->ecc.size, ret;
> >>  -	int eccbytes = chip->ecc.bytes;
> >>  -	int eccsteps = chip->ecc.steps;
> >>  -	uint8_t *p = buf;
> >>  -	uint8_t *ecc_code = chip->ecc.code_buf;
> >>  -	unsigned int max_bitflips = 0;
> >>  -
> >>  -	/* Read the OOB area first */
> >>  -	ret = nand_read_oob_op(chip, page, 0, chip->oob_poi, >> mtd->oobsize);
> >>  -	if (ret)
> >>  -		return ret;
> >>  -
> >>  -	ret = nand_read_page_op(chip, page, 0, NULL, 0);
> >>  -	if (ret)
> >>  -		return ret;
> >>  -
> >>  -	ret = mtd_ooblayout_get_eccbytes(mtd, ecc_code, chip->oob_poi, 0,
> >>  -					 chip->ecc.total);
> >>  -	if (ret)
> >>  -		return ret;
> >>  -
> >>  -	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
> >>  -		int stat;
> >>  -
> >>  -		chip->ecc.hwctl(chip, NAND_ECC_READ);
> >>  -
> >>  -		ret = nand_read_data_op(chip, p, eccsize, false, false);
> >>  -		if (ret)
> >>  -			return ret;
> >>  -
> >>  -		stat = chip->ecc.correct(chip, p, &ecc_code[i], NULL);
> >>  -		if (stat == -EBADMSG &&
> >>  -		    (chip->ecc.options & NAND_ECC_GENERIC_ERASED_CHECK)) {
> >>  -			/* check for empty pages with bitflips */
> >>  -			stat = nand_check_erased_ecc_chunk(p, eccsize,
> >>  -							   &ecc_code[i],
> >>  -							   eccbytes, NULL, 0,
> >>  -							   chip->ecc.strength);
> >>  -		}
> >>  -
> >>  -		if (stat < 0) {
> >>  -			mtd->ecc_stats.failed++;
> >>  -		} else {
> >>  -			mtd->ecc_stats.corrected += stat;
> >>  -			max_bitflips = max_t(unsigned int, max_bitflips, stat);
> >>  -		}
> >>  -	}
> >>  -	return max_bitflips;
> >>  -}
> >>  -  
> >>   >> /*----------------------------------------------------------------------  
> */
> >> >>   /* An ECC layout for using 4-bit ECC with small-page flash, storing  
> >>  @@ -648,7 +580,7 @@ static int davinci_nand_attach_chip(struct >> nand_chip *chip)
> >>   			} else if (chunks == 4 || chunks == 8) {
> >>   				mtd_set_ooblayout(mtd,
> >>   						  nand_get_large_page_ooblayout());
> >>  -				chip->ecc.read_page = nand_davinci_read_page_hwecc_oob_first;
> >>  +				chip->ecc.read_page = nand_read_page_hwecc_oob_first;
> >>   			} else {
> >>   				return -EIO;
> >>   			}
> >>  diff --git a/drivers/mtd/nand/raw/nand_base.c >> b/drivers/mtd/nand/raw/nand_base.c
> >>  index 3d6c6e880520..cb5f343b9fa2 100644
> >>  --- a/drivers/mtd/nand/raw/nand_base.c
> >>  +++ b/drivers/mtd/nand/raw/nand_base.c
> >>  @@ -3160,6 +3160,75 @@ static int nand_read_page_hwecc(struct >> nand_chip *chip, uint8_t *buf,
> >>   	return max_bitflips;
> >>   }  
> >> >>  +/**  
> >>  + * nand_read_page_hwecc_oob_first - Hardware ECC page read with ECC
> >>  + *                                  data read from OOB area
> >>  + * @chip: nand chip info structure
> >>  + * @buf: buffer to store read data
> >>  + * @oob_required: caller requires OOB data read to chip->oob_poi
> >>  + * @page: page number to read
> >>  + *
> >>  + * Hardware ECC for large page chips, require OOB to be read >> first. For this  
> > 
> > requires
> > 
> > With this ECC configuration?
> >   
> >>  + * ECC mode, the write_page method is re-used from ECC_HW. These >> methods  
> > 
> > I do not understand this sentence nor the next one about syndrome. I
> > believe it is related to your engine and should not leak into the > core.
> >   
> >>  + * read/write ECC from the OOB area, unlike the ECC_HW_SYNDROME >> support with
> >>  + * multiple ECC steps, follows the "infix ECC" scheme and >> reads/writes ECC from
> >>  + * the data area, by overwriting the NAND manufacturer bad block >> markings.  
> > 
> > That's a sentence I don't like. What do you mean exactly?
> > 
> > What "Infix ECC" scheme is?
> > 
> > Do you mean that unlike the syndrome  mode it *does not* overwrite the
> > BBM ?  
> 
> I don't mean anything. I did not write that comment. I just moved the function verbatim with no changes. If something needs to be fixed, then it needs to be fixed before/after this patch.

Well, this comment should be adapted because as-is I don't think it's
wise to move it around.

> 
> >>  + */
> >>  +int nand_read_page_hwecc_oob_first(struct nand_chip *chip, uint8_t >> *buf,
> >>  +				   int oob_required, int page)
> >>  +{
> >>  +	struct mtd_info *mtd = nand_to_mtd(chip);
> >>  +	int i, eccsize = chip->ecc.size, ret;
> >>  +	int eccbytes = chip->ecc.bytes;
> >>  +	int eccsteps = chip->ecc.steps;
> >>  +	uint8_t *p = buf;
> >>  +	uint8_t *ecc_code = chip->ecc.code_buf;
> >>  +	unsigned int max_bitflips = 0;
> >>  +
> >>  +	/* Read the OOB area first */
> >>  +	ret = nand_read_oob_op(chip, page, 0, chip->oob_poi, >> mtd->oobsize);
> >>  +	if (ret)
> >>  +		return ret;
> >>  +
> >>  +	ret = nand_read_page_op(chip, page, 0, NULL, 0);  
> > 
> > Definitely not, your are requesting the chip to do the read_page
> > operation twice. You only need a nand_change_read_column I believe.  
> 
> Again, this code is just being moved around - don't shoot the messenger :)

haha

Well, now you touch the core, so I need to be more careful, and the
code is definitely wrong, so even if we don't move that code off, you
definitely want to fix it in order to improve your performances.

> >>  +	if (ret)
> >>  +		return ret;
> >>  +
> >>  +	ret = mtd_ooblayout_get_eccbytes(mtd, ecc_code, chip->oob_poi, 0,
> >>  +					 chip->ecc.total);
> >>  +	if (ret)
> >>  +		return ret;
> >>  +
> >>  +	for (i = 0; eccsteps; eccsteps--, i += eccbytes, p += eccsize) {
> >>  +		int stat;
> >>  +
> >>  +		chip->ecc.hwctl(chip, NAND_ECC_READ);
> >>  +
> >>  +		ret = nand_read_data_op(chip, p, eccsize, false, false);
> >>  +		if (ret)
> >>  +			return ret;
> >>  +
> >>  +		stat = chip->ecc.correct(chip, p, &ecc_code[i], NULL);
> >>  +		if (stat == -EBADMSG &&
> >>  +		    (chip->ecc.options & NAND_ECC_GENERIC_ERASED_CHECK)) {
> >>  +			/* check for empty pages with bitflips */
> >>  +			stat = nand_check_erased_ecc_chunk(p, eccsize,
> >>  +							   &ecc_code[i],
> >>  +							   eccbytes, NULL, 0,
> >>  +							   chip->ecc.strength);
> >>  +		}
> >>  +
> >>  +		if (stat < 0) {
> >>  +			mtd->ecc_stats.failed++;
> >>  +		} else {
> >>  +			mtd->ecc_stats.corrected += stat;
> >>  +			max_bitflips = max_t(unsigned int, max_bitflips, stat);
> >>  +		}
> >>  +	}
> >>  +	return max_bitflips;
> >>  +}
> >>  +EXPORT_SYMBOL_GPL(nand_read_page_hwecc_oob_first);
> >>  +
> >>   /**
> >>    * nand_read_page_syndrome - [REPLACEABLE] hardware ECC syndrome >> based page read
> >>    * @chip: nand chip info structure
> >>  diff --git a/include/linux/mtd/rawnand.h >> b/include/linux/mtd/rawnand.h
> >>  index b2f9dd3cbd69..5b88cd51fadb 100644
> >>  --- a/include/linux/mtd/rawnand.h
> >>  +++ b/include/linux/mtd/rawnand.h
> >>  @@ -1539,6 +1539,8 @@ int nand_read_data_op(struct nand_chip *chip, >> void *buf, unsigned int len,
> >>   		      bool force_8bit, bool check_only);
> >>   int nand_write_data_op(struct nand_chip *chip, const void *buf,
> >>   		       unsigned int len, bool force_8bit);
> >>  +int nand_read_page_hwecc_oob_first(struct nand_chip *chip, uint8_t >> *buf,
> >>  +				   int oob_required, int page);  
> > 
> > You certainly want to add this symbol closer to the other read/write
> > page helpers?  
> 
> Where would that be? The other read/write page helpers are all "static" so they don't appear in any header.

I believe we should keep this header local as long as there are no
other users.


Thanks,
Miquèl
