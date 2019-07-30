Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0129D7A9FF
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 15:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbfG3Nqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 09:46:46 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:38755 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728599AbfG3Nqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 09:46:45 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1hsSSh-0004LX-OZ; Tue, 30 Jul 2019 15:46:43 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1hsSSh-0003fq-DW; Tue, 30 Jul 2019 15:46:43 +0200
Date:   Tue, 30 Jul 2019 15:46:43 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     richard.weinberger@gmail.com, boris.brezillon@collabora.com,
        miquel.raynal@bootlin.com
Cc:     linux-mtd@lists.infradead.org, kernel@pengutronix.de,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] mtd: rawnand: micron: handle on-die "ECC-off" devices
 correctly
Message-ID: <20190730134643.hkufeudw6jht4dst@pengutronix.de>
References: <20190730134407.30212-1-m.felsch@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730134407.30212-1-m.felsch@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:44:31 up 73 days, 20:02, 48 users,  load average: 0.00, 0.01,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

sorry for the noise, missed the changelog:

v3:
- minor spelling issues fixed
v2:
- adapt commit message according Miquel comments
- add fixes, stable tags
- add Boris Reviewed-by

On 19-07-30 15:44, Marco Felsch wrote:
> Some devices are not supposed to support on-die ECC but experience
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
>  drivers/mtd/nand/raw/nand_micron.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mtd/nand/raw/nand_micron.c b/drivers/mtd/nand/raw/nand_micron.c
> index 1622d3145587..8ca9fad6e6ad 100644
> --- a/drivers/mtd/nand/raw/nand_micron.c
> +++ b/drivers/mtd/nand/raw/nand_micron.c
> @@ -390,6 +390,14 @@ static int micron_supports_on_die_ecc(struct nand_chip *chip)
>  	    (chip->id.data[4] & MICRON_ID_INTERNAL_ECC_MASK) != 0x2)
>  		return MICRON_ON_DIE_UNSUPPORTED;
>  
> +	/*
> +	 * It seems that there are devices which do not support ECC officially.
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
> -- 
> 2.20.1
> 
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
