Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1990217A4C
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 23:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbgGGVZe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 17:25:34 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:34420 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728790AbgGGVZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 17:25:33 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 82A871C0C10; Tue,  7 Jul 2020 23:25:31 +0200 (CEST)
Date:   Tue, 7 Jul 2020 23:25:31 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Brian Moyles <bmoyles@netflix.com>,
        Mauricio Faria de Oliveira <mfo@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4.19 13/36] crypto: af_alg - fix use-after-free in
 af_alg_accept() due to bh_lock_sock()
Message-ID: <20200707212530.GA11158@amd>
References: <20200707145749.130272978@linuxfoundation.org>
 <20200707145749.760045378@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20200707145749.760045378@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This patch also modifies the main refcnt to include both normal
> and nokey sockets.  This way we don't have to fudge the nokey
> ref count when a socket changes from nokey to normal.
>=20
> Credits go to Mauricio Faria de Oliveira who diagnosed this bug
> and sent a patch for it:


> @@ -308,12 +302,14 @@ int af_alg_accept(struct sock *sk, struc
> =20
>  	sk2->sk_family =3D PF_ALG;
> =20
> -	if (nokey || !ask->refcnt++)
> +	if (atomic_inc_return_relaxed(&ask->refcnt) =3D=3D 1)
>  		sock_hold(sk);
> -	ask->nokey_refcnt +=3D nokey;
> +	if (nokey) {
> +		atomic_inc(&ask->nokey_refcnt);
> +		atomic_set(&alg_sk(sk2)->nokey_refcnt, 1);
> +	}

Should we set the nokey_refcnt to 0 using atomic_set, too?
Aternatively, should the nokey_refcnt be initialized using
ATOMIC_INIT()?

Best regards,
								Pavel


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8E6EoACgkQMOfwapXb+vIzPQCfUWlLGyhpkXge1oeg0coA6HJH
KfsAmgJKYu3lRraU1nqAFtOB1TkosHaF
=raSn
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
