Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223153FB2A4
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 10:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbhH3ImU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 30 Aug 2021 04:42:20 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:43889 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbhH3ImU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 04:42:20 -0400
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id A8274240012;
        Mon, 30 Aug 2021 08:41:23 +0000 (UTC)
Date:   Mon, 30 Aug 2021 10:41:22 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Frieder Schrempf <frieder@fris.de>
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        stable@vger.kernel.org,
        voice INTER connect GmbH <developer@voiceinterconnect.de>,
        Alexander Lobakin <alobakin@pm.me>,
        Felix Fietkau <nbd@nbd.name>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        Richard Weinberger <richard@nod.at>,
        YouChing Lin <ycllin@mxic.com.tw>
Subject: Re: [RESEND PATCH 5.10.x] mtd: spinand: Fix incorrect parameters
 for on-die ECC
Message-ID: <20210830104122.58f9cdaf@xps13>
In-Reply-To: <20210830072108.13770-1-frieder@fris.de>
References: <20210830072108.13770-1-frieder@fris.de>
Organization: Bootlin
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Frieder,

Frieder Schrempf <frieder@fris.de> wrote on Mon, 30 Aug 2021 09:21:07
+0200:

> From: Frieder Schrempf <frieder.schrempf@kontron.de>
> 
> The new generic NAND ECC framework stores the configuration and requirements
> in separate places since commit 93ef92f6f422 (" mtd: nand: Use the new generic ECC object ").
> In 5.10.x The SPI NAND layer still uses only the requirements to track the ECC
> properties. This mismatch leads to values of zero being used for ECC strength
> and step_size in the SPI NAND layer wherever nanddev_get_ecc_conf() is used and
> therefore breaks the SPI NAND on-die ECC support in 5.10.x.
> 
> By using nanddev_get_ecc_requirements() instead of nanddev_get_ecc_conf() for
> SPI NAND, we make sure that the correct parameters for the detected chip are
> used. In later versions (5.11.x) this is fixed anyway with the implementation
> of the SPI NAND on-die ECC engine.
> 
> Cc: stable@vger.kernel.org # 5.10.x
> Reported-by: voice INTER connect GmbH <developer@voiceinterconnect.de>
> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>

Why not just reverting 9a333a72c1d0 ("mtd: spinand: Use
nanddev_get_ecc_conf() when relevant")? I think using this "new"
nanddev_get_ecc_requirements() helper because it fits the purpose even
if it is wrong [1] doesn't bring the right information. I know it is
strictly equivalent but I would personally prefer keeping the old
writing "nand->eccreq.xxxx".

[1] We don't want the requirements but the actual current configuration
here, which was the primary purpose of the initial patch which ended
being a mistake at that point in time because the SPI-NAND core was not
ready yet.

Thanks,
Miquèl

> ---
> Resending this with an improved subject prefix and because the
> previous mail wasn't delivered to some of the lists.
> ---
>  drivers/mtd/nand/spi/core.c     | 6 +++---
>  drivers/mtd/nand/spi/macronix.c | 6 +++---
>  drivers/mtd/nand/spi/toshiba.c  | 6 +++---
>  3 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
> index 558d8a14810b..8794a1f6eacd 100644
> --- a/drivers/mtd/nand/spi/core.c
> +++ b/drivers/mtd/nand/spi/core.c
> @@ -419,7 +419,7 @@ static int spinand_check_ecc_status(struct
> spinand_device *spinand, u8 status)
>  		 * fixed, so let's return the maximum possible value
> so that
>  		 * wear-leveling layers move the data immediately.
>  		 */
> -		return nanddev_get_ecc_conf(nand)->strength;
> +		return nanddev_get_ecc_requirements(nand)->strength;
>  
>  	case STATUS_ECC_UNCOR_ERROR:
>  		return -EBADMSG;
> @@ -1090,8 +1090,8 @@ static int spinand_init(struct spinand_device
> *spinand) mtd->oobavail = ret;
>  
>  	/* Propagate ECC information to mtd_info */
> -	mtd->ecc_strength = nanddev_get_ecc_conf(nand)->strength;
> -	mtd->ecc_step_size = nanddev_get_ecc_conf(nand)->step_size;
> +	mtd->ecc_strength =
> nanddev_get_ecc_requirements(nand)->strength;
> +	mtd->ecc_step_size =
> nanddev_get_ecc_requirements(nand)->step_size; 
>  	return 0;
>  
> diff --git a/drivers/mtd/nand/spi/macronix.c
> b/drivers/mtd/nand/spi/macronix.c index 8e801e4c3a00..cd7a9cacc3fb
> 100644 --- a/drivers/mtd/nand/spi/macronix.c
> +++ b/drivers/mtd/nand/spi/macronix.c
> @@ -84,11 +84,11 @@ static int mx35lf1ge4ab_ecc_get_status(struct
> spinand_device *spinand,
>  		 * data around if it's not necessary.
>  		 */
>  		if (mx35lf1ge4ab_get_eccsr(spinand, &eccsr))
> -			return nanddev_get_ecc_conf(nand)->strength;
> +			return
> nanddev_get_ecc_requirements(nand)->strength; 
> -		if (WARN_ON(eccsr >
> nanddev_get_ecc_conf(nand)->strength ||
> +		if (WARN_ON(eccsr >
> nanddev_get_ecc_requirements(nand)->strength || !eccsr))
> -			return nanddev_get_ecc_conf(nand)->strength;
> +			return
> nanddev_get_ecc_requirements(nand)->strength; 
>  		return eccsr;
>  
> diff --git a/drivers/mtd/nand/spi/toshiba.c
> b/drivers/mtd/nand/spi/toshiba.c index 21fde2875674..6fe7bd2a94d2
> 100644 --- a/drivers/mtd/nand/spi/toshiba.c
> +++ b/drivers/mtd/nand/spi/toshiba.c
> @@ -90,12 +90,12 @@ static int tx58cxgxsxraix_ecc_get_status(struct
> spinand_device *spinand,
>  		 * data around if it's not necessary.
>  		 */
>  		if (spi_mem_exec_op(spinand->spimem, &op))
> -			return nanddev_get_ecc_conf(nand)->strength;
> +			return
> nanddev_get_ecc_requirements(nand)->strength; 
>  		mbf >>= 4;
>  
> -		if (WARN_ON(mbf >
> nanddev_get_ecc_conf(nand)->strength || !mbf))
> -			return nanddev_get_ecc_conf(nand)->strength;
> +		if (WARN_ON(mbf >
> nanddev_get_ecc_requirements(nand)->strength || !mbf))
> +			return
> nanddev_get_ecc_requirements(nand)->strength; 
>  		return mbf;
>  
