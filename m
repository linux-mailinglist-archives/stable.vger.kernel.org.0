Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81484786C8
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 09:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfG2H5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 03:57:20 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:53414 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfG2H5U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 03:57:20 -0400
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 2875528A6AB;
        Mon, 29 Jul 2019 08:57:19 +0100 (BST)
Date:   Mon, 29 Jul 2019 09:57:15 +0200
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     richard.weinberger@gmail.com, miquel.raynal@bootlin.com,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH v2] mtd: rawnand: micron: handle on-die "ECC-off"
 devices correctly
Message-ID: <20190729095715.2de79aea@collabora.com>
In-Reply-To: <20190729070652.12629-1-m.felsch@pengutronix.de>
References: <20190729070652.12629-1-m.felsch@pengutronix.de>
Organization: Collabora
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Jul 2019 09:06:52 +0200
Marco Felsch <m.felsch@pengutronix.de> wrote:

> Some devices are supposed to do not support on-die ECC but experience

		^ are not supposed to support

> shows that internal ECC machinery can actually be enabled through the
> "SET FEATURE (EFh)" command, even if a read of the "READ ID Parameter
> Tables" returns that it is not.
> 
> Currently, the driver checks the "READ ID Parameter" field directly
> after having enabled the feature. If the check fails it returns
> immediately but leaves the ECC on. When using buggy chips like
> MT29F2G08ABAGA and MT29F2G08ABBGA, all future read/program cycles will
> go through the on-die ECC, confusing the host controller which is
> supposed to be the one handling correction.
> 
> To address this in a common way we need to turn off the on-die ECC
> directly after reading the "READ ID Parameter" and before checking the
> "ECC status".
> 
> Cc: stable@vger.kernel.org
> Fixes: dbc44edbf833 ("mtd: rawnand: micron: Fix on-die ECC detection logic")
> Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> ---
> v2:
> - adapt commit message according Miquel comments
> - add fixes, stable tags
> - add Boris rb-tag
> 
>  drivers/mtd/nand/raw/nand_micron.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/nand/raw/nand_micron.c b/drivers/mtd/nand/raw/nand_micron.c
> index 1622d3145587..fb199ad2f1a6 100644
> --- a/drivers/mtd/nand/raw/nand_micron.c
> +++ b/drivers/mtd/nand/raw/nand_micron.c
> @@ -390,6 +390,14 @@ static int micron_supports_on_die_ecc(struct nand_chip *chip)
>  	    (chip->id.data[4] & MICRON_ID_INTERNAL_ECC_MASK) != 0x2)
>  		return MICRON_ON_DIE_UNSUPPORTED;
>  
> +	/*
> +	 * It seems that there are devices which do not support ECC official.

								    ^officially.

> +	 * At least the MT29F2G08ABAGA / MT29F2G08ABBGA devices supports
> +	 * enabling the ECC feature but don't reflect that to the READ_ID table.
> +	 * So we have to guarantee that we disable the ECC feature directly
> +	 * after we did the READ_ID table command. Later we can evaluate the
> +	 * ECC_ENABLE support.
> +	 */
>  	ret = micron_nand_on_die_ecc_setup(chip, true);
>  	if (ret)
>  		return MICRON_ON_DIE_UNSUPPORTED;
> @@ -398,13 +406,13 @@ static int micron_supports_on_die_ecc(struct nand_chip *chip)
>  	if (ret)
>  		return MICRON_ON_DIE_UNSUPPORTED;
>  
> -	if (!(id[4] & MICRON_ID_ECC_ENABLED))
> -		return MICRON_ON_DIE_UNSUPPORTED;
> -
>  	ret = micron_nand_on_die_ecc_setup(chip, false);
>  	if (ret)
>  		return MICRON_ON_DIE_UNSUPPORTED;
>  
> +	if (!(id[4] & MICRON_ID_ECC_ENABLED))
> +		return MICRON_ON_DIE_UNSUPPORTED;
> +
>  	ret = nand_readid_op(chip, 0, id, sizeof(id));
>  	if (ret)
>  		return MICRON_ON_DIE_UNSUPPORTED;

