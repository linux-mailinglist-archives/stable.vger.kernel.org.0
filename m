Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6669F60B9B5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiJXURx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbiJXURc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:17:32 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0D33218F;
        Mon, 24 Oct 2022 11:34:32 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BCC8D1C0023; Mon, 24 Oct 2022 19:27:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1666632430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8iI0oxizGaV/Rk6CaNWpVh9m/z4FVWkEAwA+I2LNMNE=;
        b=XdNK+AOmImURDt4hNOxg+07HaxT0238b5Ck0YlLM0Ggnkk5DpWZ46PTSQet8wkEUhjCwlG
        SfgiA950Mx8xiA+UooSAAqIsI+Zbj/Y0+8UCFfosKmqg1ZVlq09ULCA3+WavmEOUD7Z6tA
        3xAabuB4Laa9S9bucbmO1oasIinku/w=
Date:   Mon, 24 Oct 2022 19:27:10 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anders Blomdell <anders.blomdell@control.lth.se>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH 5.10 044/390] serial: 8250: Let drivers request full
 16550A feature probing
Message-ID: <20221024172710.GA24827@duo.ucw.cz>
References: <20221024113022.510008560@linuxfoundation.org>
 <20221024113024.492214172@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20221024113024.492214172@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Maciej W. Rozycki <macro@orcam.me.uk>
>=20
> commit 9906890c89e4dbd900ed87ad3040080339a7f411 upstream.
>=20
> A SERIAL_8250_16550A_VARIANTS configuration option has been recently
> defined that lets one request the 8250 driver not to probe for 16550A
> device features so as to reduce the driver's device startup time in
> virtual machines.
>=20
> Some actual hardware devices require these features to have been fully
> determined however for their driver to work correctly, so define a flag
> to let drivers request full 16550A feature probing on a device-by-device
> basis if required regardless of the SERIAL_8250_16550A_VARIANTS option
> setting chosen.

As far as I can see, the UPF_FULL_PROBE is never set in 5.10.150 tree,
so we should not need it there.

Best regards,
								Pavel

> +++ b/drivers/tty/serial/8250/8250_port.c
> @@ -1021,7 +1021,8 @@ static void autoconfig_16550a(struct uar
>  	up->port.type =3D PORT_16550A;
>  	up->capabilities |=3D UART_CAP_FIFO;
> =20
> -	if (!IS_ENABLED(CONFIG_SERIAL_8250_16550A_VARIANTS))
> +	if (!IS_ENABLED(CONFIG_SERIAL_8250_16550A_VARIANTS) &&
> +	    !(up->port.flags & UPF_FULL_PROBE))
>  		return;
> =20
>  	/*
> --- a/include/linux/serial_core.h
> +++ b/include/linux/serial_core.h
> @@ -100,7 +100,7 @@ struct uart_icount {
>  	__u32	buf_overrun;
>  };
> =20
> -typedef unsigned int __bitwise upf_t;
> +typedef u64 __bitwise upf_t;
>  typedef unsigned int __bitwise upstat_t;
> =20
>  struct uart_port {
> @@ -207,6 +207,7 @@ struct uart_port {
>  #define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
>  #define UPF_DEAD		((__force upf_t) (1 << 30))
>  #define UPF_IOREMAP		((__force upf_t) (1 << 31))
> +#define UPF_FULL_PROBE		((__force upf_t) (1ULL << 32))
> =20
>  #define __UPF_CHANGE_MASK	0x17fff
>  #define UPF_CHANGE_MASK		((__force upf_t) __UPF_CHANGE_MASK)
>=20

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY1bK7gAKCRAw5/Bqldv6
8jy/AKCSnPcdd2aC38eYzdcYMCzIZu/ArQCeOyyUxua6fErEFY+0srB89ExlmW0=
=n2Xq
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
