Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0592064CBFC
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 15:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbiLNOTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 09:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiLNOTA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 09:19:00 -0500
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9109F26ACC;
        Wed, 14 Dec 2022 06:18:57 -0800 (PST)
Received: (Authenticated sender: herve.codina@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6FF0A1C0017;
        Wed, 14 Dec 2022 14:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1671027536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dmQ807XpApqJy3ky8AyyrotvaoAVGYYY3USozGQUBPY=;
        b=ey/o2OPoCIMiHTZDssVN7DDIBmfA4kbOab/vKfPdBPvMleF2g50wjKo9+EBCswUhxORexP
        WCKreG+QPA7HRnlNVHf6S1iteh09o26ckOCfXJkK0wvf0GaPYqbkqnzGZg65pZv+Nt5ieK
        1oHWDQFUIZ14BYD+AdWhLCd8a1KXgaJE3APXF4TfjtshYlWKGqzwecO+cjmDRIg99Ab72S
        xKx2HjeJ/5UZjERUzizoNajx8ZuibmwxCfC3VdHodEuCF8+SPUkxR4vIO7svwfeGyi6INZ
        F39EaeHlyuAjuAvDGnebwtdsMfpNqUQ1LSlP7BYUWpw0Z5CMaqLxgXT8kiBs7A==
Date:   Wed, 14 Dec 2022 15:18:53 +0100
From:   Herve Codina <herve.codina@bootlin.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-spi@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] spi: fsl_spi: Don't change speed while chipselect is
 active
Message-ID: <20221214151853.797daf7d@bootlin.com>
In-Reply-To: <8aab84c51aa330cf91f4b43782a1c483e150a4e3.1671025244.git.christophe.leroy@csgroup.eu>
References: <8aab84c51aa330cf91f4b43782a1c483e150a4e3.1671025244.git.christophe.leroy@csgroup.eu>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christophe,

On Wed, 14 Dec 2022 14:41:33 +0100
Christophe Leroy <christophe.leroy@csgroup.eu> wrote:

> Commit c9bfcb315104 ("spi_mpc83xx: much improved driver") made
> modifications to the driver to not perform speed changes while
> chipselect is active. But those changes where lost with the
> convertion to tranfer_one.
>=20
> Previous implementation was allowing speed changes during
> message transfer when cs_change flag was set.
> At the time being, core SPI does not provide any feature to change
> speed while chipselect is off, so do not allow any speed change during
> message transfer, and perform the transfer setup in prepare_message
> in order to set correct speed while chipselect is still off.
>=20
> Reported-by: Herve Codina <herve.codina@bootlin.com>
> Fixes: 64ca1a034f00 ("spi: fsl_spi: Convert to transfer_one")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
> Tested-by: Herve Codina <herve.codina@bootlin.com>
> ---
>  drivers/spi/spi-fsl-spi.c | 19 ++++++++++++++++---
>  1 file changed, 16 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
> index 731624f157fc..93152144fd2e 100644
> --- a/drivers/spi/spi-fsl-spi.c
> +++ b/drivers/spi/spi-fsl-spi.c
> @@ -333,13 +333,26 @@ static int fsl_spi_prepare_message(struct spi_contr=
oller *ctlr,
>  {
>  	struct mpc8xxx_spi *mpc8xxx_spi =3D spi_controller_get_devdata(ctlr);
>  	struct spi_transfer *t;
> +	struct spi_transfer *first;
> +
> +	first =3D list_first_entry(&m->transfers, struct spi_transfer,
> +				 transfer_list);
> =20
>  	/*
>  	 * In CPU mode, optimize large byte transfers to use larger
>  	 * bits_per_word values to reduce number of interrupts taken.
> +	 *
> +	 * Some glitches can appear on the SPI clock when the mode changes.
> +	 * Check that there is no speed change during the transfer and set it up
> +	 * now to change the mode without having a chip-select asserted.
>  	 */
> -	if (!(mpc8xxx_spi->flags & SPI_CPM_MODE)) {
> -		list_for_each_entry(t, &m->transfers, transfer_list) {
> +	list_for_each_entry(t, &m->transfers, transfer_list) {
> +		if (t->speed_hz !=3D first->speed_hz) {
> +			dev_err(&m->spi->dev,
> +				"speed_hz cannot change during message.\n");
> +			return -EINVAL;
> +		}
> +		if (!(mpc8xxx_spi->flags & SPI_CPM_MODE)) {
>  			if (t->len < 256 || t->bits_per_word !=3D 8)
>  				continue;
>  			if ((t->len & 3) =3D=3D 0)
> @@ -348,7 +361,7 @@ static int fsl_spi_prepare_message(struct spi_control=
ler *ctlr,
>  				t->bits_per_word =3D 16;
>  		}
>  	}
> -	return 0;
> +	return fsl_spi_setup_transfer(m->spi, first);
>  }
> =20
>  static int fsl_spi_transfer_one(struct spi_controller *controller,

Looks good to me.

Reviewed-by: Herve Codina <herve.codina@bootlin.com>

Regards,
Herv=C3=A9

--=20
Herv=C3=A9 Codina, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
