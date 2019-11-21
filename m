Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A0A105AF5
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 21:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKUUQg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 15:16:36 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45956 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbfKUUQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 15:16:36 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3697C1C1BCE; Thu, 21 Nov 2019 21:16:34 +0100 (CET)
Date:   Thu, 21 Nov 2019 21:16:18 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 233/422] netfilter: nf_tables: avoid BUG_ON usage
Message-ID: <20191121201618.GB15106@duo.ucw.cz>
References: <20191119051400.261610025@linuxfoundation.org>
 <20191119051414.205983228@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <20191119051414.205983228@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Florian Westphal <fw@strlen.de>
>=20
> [ Upstream commit fa5950e498e7face21a1761f327e6c1152f778c3 ]
>=20
> None of these spots really needs to crash the kernel.
> In one two cases we can jsut report error to userspace, in the other
> cases we can just use WARN_ON (and leak memory instead).

Do these conditions trigger for someone, to warrant -stable patch?

> +++ b/net/netfilter/nft_cmp.c
> @@ -79,7 +79,8 @@ static int nft_cmp_init(const struct nft_ctx *ctx, cons=
t struct nft_expr *expr,
> =20
>  	err =3D nft_data_init(NULL, &priv->data, sizeof(priv->data), &desc,
>  			    tb[NFTA_CMP_DATA]);
> -	BUG_ON(err < 0);
> +	if (err < 0)
> +		return err;
> =20
>  	priv->sreg =3D nft_parse_register(tb[NFTA_CMP_SREG]);
>  	err =3D nft_validate_register_load(priv->sreg, desc.len);
> @@ -129,7 +130,8 @@ static int nft_cmp_fast_init(const struct nft_ctx *ct=
x,
> =20
>  	err =3D nft_data_init(NULL, &data, sizeof(data), &desc,
>  			    tb[NFTA_CMP_DATA]);
> -	BUG_ON(err < 0);
> +	if (err < 0)
> +		return err;
> =20
>  	priv->sreg =3D nft_parse_register(tb[NFTA_CMP_SREG]);
>  	err =3D nft_validate_register_load(priv->sreg, desc.len);

This goes from "kill kernel with backtrace" to "silently return
failure". Should WARN_ON() be preserved here?

Best regards,
								Pavel
							=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXdbwkgAKCRAw5/Bqldv6
8l5qAKC9n9Z+1mVzS9IM9LaSttCq2lqVeACgp6Ckp2puBkyXe9dWOAY6omkyMYQ=
=edJ9
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
