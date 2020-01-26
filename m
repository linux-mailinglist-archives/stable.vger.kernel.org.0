Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D18EE149C48
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 19:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgAZS3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 13:29:31 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:49498 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgAZS3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 13:29:31 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 309901C013C; Sun, 26 Jan 2020 19:29:29 +0100 (CET)
Date:   Sun, 26 Jan 2020 19:29:18 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 625/639] packet: fix data-race in
 fanout_flow_is_huge()
Message-ID: <20200126182917.GA26911@amd>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093207.912523612@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20200124093207.912523612@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Eric Dumazet <edumazet@google.com>
>=20
> [ Upstream commit b756ad928d98e5ef0b74af7546a6a31a8dadde00 ]
>=20
> KCSAN reported the following data-race [1]
>=20
> Adding a couple of READ_ONCE()/WRITE_ONCE() should silence it.
>=20
> Since the report hinted about multiple cpus using the history
> concurrently, I added a test avoiding writing on it if the
> victim slot already contains the desired value.

>  static bool fanout_flow_is_huge(struct packet_sock *po, struct sk_buff *=
skb)
>  {
> -	u32 rxhash;
> +	u32 *history =3D po->rollover->history;
> +	u32 victim, rxhash;
>  	int i, count =3D 0;
> =20
>  	rxhash =3D skb_get_hash(skb);
>  	for (i =3D 0; i < ROLLOVER_HLEN; i++)
> -		if (po->rollover->history[i] =3D=3D rxhash)
> +		if (READ_ONCE(history[i]) =3D=3D rxhash)
>  			count++;
> =20
> -	po->rollover->history[prandom_u32() % ROLLOVER_HLEN] =3D rxhash;
> +	victim =3D prandom_u32() % ROLLOVER_HLEN;
> +
> +	/* Avoid dirtying the cache line if possible */
> +	if (READ_ONCE(history[victim]) !=3D rxhash)
> +		WRITE_ONCE(history[victim], rxhash);
> +

Replacing simple asignment with if() is ... not nice and with all the
"volatile" magic in _ONCE macros may not be win for
everyone. [Actually, I don't think this is win here. This is not
exactly hot path, is it? Is it likely that array aready contains
required value?]

If this is going to get more common, should we get
WRITE_ONCE_NONDIRTY() macro hiding the uglyness?

Best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl4t2n0ACgkQMOfwapXb+vKWZACfXGUxeWdbOxPidKjzXNS5xqcf
llUAmwZqpQqfdyEY953YC5qnZziTVQa/
=ckpY
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
