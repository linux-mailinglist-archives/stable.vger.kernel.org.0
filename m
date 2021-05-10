Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA7A3798A1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 22:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbhEJU56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 16:57:58 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:58198 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbhEJU55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 16:57:57 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0BC601C0B76; Mon, 10 May 2021 22:56:51 +0200 (CEST)
Date:   Mon, 10 May 2021 22:56:50 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH 5.10 002/299] bus: mhi: core: Clear configuration from
 channel context during reset
Message-ID: <20210510205650.GA17966@amd>
References: <20210510102004.821838356@linuxfoundation.org>
 <20210510102004.900838842@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20210510102004.900838842@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Bhaumik Bhatt <bbhatt@codeaurora.org>
>=20
> commit 47705c08465931923e2f2b506986ca0bdf80380d upstream.
>=20
> When clearing up the channel context after client drivers are
> done using channels, the configuration is currently not being
> reset entirely. Ensure this is done to appropriately handle
> issues where clients unaware of the context state end up calling
> functions which expect a context.

> +++ b/drivers/bus/mhi/core/init.c
> @@ -544,6 +544,7 @@ void mhi_deinit_chan_ctxt(struct mhi_con
> +	u32 tmp;
> @@ -554,7 +555,19 @@ void mhi_deinit_chan_ctxt(struct mhi_con
=2E..
> +	tmp =3D chan_ctxt->chcfg;
> +	tmp &=3D ~CHAN_CTX_CHSTATE_MASK;
> +	tmp |=3D (MHI_CH_STATE_DISABLED << CHAN_CTX_CHSTATE_SHIFT);
> +	chan_ctxt->chcfg =3D tmp;
> +
> +	/* Update to all cores */
> +	smp_wmb();
>  }

This is really interesting code; author was careful to make sure chcfg
is updated atomically, but C compiler is free to undo that. Plus, this
will make all kinds of checkers angry.

Does the file need to use READ_ONCE and WRITE_ONCE?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCZnhIACgkQMOfwapXb+vLm+QCgrjtqO/fk9hdWsOqd82lCs93/
OkAAoJT5b/Oi5j5XtOKXCYwDFMuvzCYA
=NHPs
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
