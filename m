Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0268433D12E
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 10:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236366AbhCPJxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 05:53:23 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:53216 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236376AbhCPJxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 05:53:20 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0CF2A1C0B8B; Tue, 16 Mar 2021 10:53:18 +0100 (CET)
Date:   Tue, 16 Mar 2021 10:53:17 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Pavel Machek <pavel@denx.de>
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 012/120] tcp: annotate tp->write_seq lockless reads
Message-ID: <20210316095317.GC12946@amd>
References: <20210315135720.002213995@linuxfoundation.org>
 <20210315135720.418426545@linuxfoundation.org>
 <20210316095049.GB12946@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
In-Reply-To: <20210316095049.GB12946@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >=20
> > From: Eric Dumazet <edumazet@google.com>
>=20
> Dup.

Aha, sorry, crossed mails. Still I wonder if hiding assignment into
macro is good:

> > --- a/net/ipv4/tcp_minisocks.c
> > +++ b/net/ipv4/tcp_minisocks.c
> > @@ -510,7 +510,7 @@ struct sock *tcp_create_openreq_child(co
> >  	newtp->app_limited =3D ~0U;
> > =20
> >  	tcp_init_xmit_timers(newsk);
> > -	newtp->write_seq =3D newtp->pushed_seq =3D treq->snt_isn + 1;
> > +	WRITE_ONCE(newtp->write_seq, newtp->pushed_seq =3D treq->snt_isn + 1);
>=20
> Would it be better to do assignment to pushed_seq outside of
> WRITE_ONCE macro? This is ... "interesting".

Best regards,
								Pavel



--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBQgA0ACgkQMOfwapXb+vK3yQCeLJ+76EJmgJy2npJfJUko//zp
ujEAnj3DgTZ/NUoQ/Zf94PQ/UJBlZxvO
=aDh+
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--
