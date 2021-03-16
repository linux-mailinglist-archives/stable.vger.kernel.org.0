Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A2B33D124
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 10:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbhCPJvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 05:51:15 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52956 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236330AbhCPJuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 05:50:52 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 446261C0B8B; Tue, 16 Mar 2021 10:50:50 +0100 (CET)
Date:   Tue, 16 Mar 2021 10:50:49 +0100
From:   Pavel Machek <pavel@denx.de>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 012/120] tcp: annotate tp->write_seq lockless reads
Message-ID: <20210316095049.GB12946@amd>
References: <20210315135720.002213995@linuxfoundation.org>
 <20210315135720.418426545@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <20210315135720.418426545@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> From: Eric Dumazet <edumazet@google.com>

Dup.


> We need to add READ_ONCE() annotations, and also make
> sure write sides use corresponding WRITE_ONCE() to avoid
> store-tearing.

> @@ -1037,7 +1037,7 @@ new_segment:
>  		sk->sk_wmem_queued +=3D copy;
>  		sk_mem_charge(sk, copy);
>  		skb->ip_summed =3D CHECKSUM_PARTIAL;
> -		tp->write_seq +=3D copy;
> +		WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
>  		TCP_SKB_CB(skb)->end_seq +=3D copy;
>  		tcp_skb_pcount_set(skb, 0);
>

I wonder if this needs to do READ_ONCE, too?

> @@ -1391,7 +1391,7 @@ new_segment:
>  		if (!copied)
>  			TCP_SKB_CB(skb)->tcp_flags &=3D ~TCPHDR_PSH;
> =20
> -		tp->write_seq +=3D copy;
> +		WRITE_ONCE(tp->write_seq, tp->write_seq + copy);
>  		TCP_SKB_CB(skb)->end_seq +=3D copy;
>  		tcp_skb_pcount_set(skb, 0);
>

And here.

> @@ -2593,9 +2594,12 @@ int tcp_disconnect(struct sock *sk, int
>  	sock_reset_flag(sk, SOCK_DONE);
>  	tp->srtt_us =3D 0;
>  	tp->rcv_rtt_last_tsecr =3D 0;
> -	tp->write_seq +=3D tp->max_window + 2;
> -	if (tp->write_seq =3D=3D 0)
> -		tp->write_seq =3D 1;
> +
> +	seq =3D tp->write_seq + tp->max_window + 2;
> +	if (!seq)
> +		seq =3D 1;
> +	WRITE_ONCE(tp->write_seq, seq);

And here.

> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -510,7 +510,7 @@ struct sock *tcp_create_openreq_child(co
>  	newtp->app_limited =3D ~0U;
> =20
>  	tcp_init_xmit_timers(newsk);
> -	newtp->write_seq =3D newtp->pushed_seq =3D treq->snt_isn + 1;
> +	WRITE_ONCE(newtp->write_seq, newtp->pushed_seq =3D treq->snt_isn + 1);

Would it be better to do assignment to pushed_seq outside of
WRITE_ONCE macro? This is ... "interesting".

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBQf3kACgkQMOfwapXb+vKgIwCdHCjqPEK7PmDmmfIAd0twUUWA
AhsAoIJipW/LvtuR27NuwI01WjMYOpGO
=8Gfw
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
