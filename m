Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2A53820FD
	for <lists+stable@lfdr.de>; Sun, 16 May 2021 22:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhEPUfk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 16:35:40 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:58196 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhEPUfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 16:35:40 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id C8A701C0B76; Sun, 16 May 2021 22:34:23 +0200 (CEST)
Date:   Sun, 16 May 2021 22:34:23 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 264/530] spi: spi-zynqmp-gqspi: fix use-after-free
 in zynqmp_qspi_exec_op
Message-ID: <20210516203423.GA11471@duo.ucw.cz>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144828.501430855@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <20210512144828.501430855@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> When handling op->addr, it is using the buffer "tmpbuf" which has been
> freed. This will trigger a use-after-free KASAN warning. Let's use
> temporary variables to store op->addr.val and op->cmd.opcode to fix
> this issue.

I believe this is "cure worse than a disassease".

> +++ b/drivers/spi/spi-zynqmp-gqspi.c
> @@ -926,8 +926,9 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
>  	struct zynqmp_qspi *xqspi =3D spi_controller_get_devdata
>  				    (mem->spi->master);
>  	int err =3D 0, i;
> -	u8 *tmpbuf;
>  	u32 genfifoentry =3D 0;
> +	u16 opcode =3D op->cmd.opcode;
> +	u64 opaddr;
> =20
>  	dev_dbg(xqspi->dev, "cmd:%#x mode:%d.%d.%d.%d\n",
>  		op->cmd.opcode, op->cmd.buswidth, op->addr.buswidth,
> @@ -940,14 +941,8 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
>  	genfifoentry |=3D xqspi->genfifobus;
> =20
>  	if (op->cmd.opcode) {
> -		tmpbuf =3D kzalloc(op->cmd.nbytes, GFP_KERNEL | GFP_DMA);
> -		if (!tmpbuf) {
> -			mutex_unlock(&xqspi->op_lock);
> -			return -ENOMEM;
> -		}
> -		tmpbuf[0] =3D op->cmd.opcode;
>  		reinit_completion(&xqspi->data_completion);
> -		xqspi->txbuf =3D tmpbuf;
> +		xqspi->txbuf =3D &opcode;
>  		xqspi->rxbuf =3D NULL;
>  		xqspi->bytes_to_transfer =3D op->cmd.nbytes;
>  		xqspi->bytes_to_receive =3D 0;

So this replaces "op->cmd.nbytes" bytes big DMA buffer with 2 bytes on
stack.

First, if op->cmd.nbytes is > 2, DMA will overrun that buffer. That
can't be healthy.

Second, you really should not run DMA from on-stack buffers.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYKGBzwAKCRAw5/Bqldv6
8oRmAJ0QR2fc6gdv0wUf2oW8V3UMti2jEACeMUf6pCWcXdxiO3mwhajM0k6zdV8=
=yrfb
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
