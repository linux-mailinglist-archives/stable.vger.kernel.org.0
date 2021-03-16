Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D762633D103
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 10:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234293AbhCPJmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 05:42:10 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52002 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbhCPJll (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 05:41:41 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 269FD1C0B8B; Tue, 16 Mar 2021 10:41:38 +0100 (CET)
Date:   Tue, 16 Mar 2021 10:41:37 +0100
From:   Pavel Machek <pavel@denx.de>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 011/120] tcp: annotate tp->copied_seq lockless reads
Message-ID: <20210316094137.GA12946@amd>
References: <20210315135720.002213995@linuxfoundation.org>
 <20210315135720.384809636@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20210315135720.384809636@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> From: Eric Dumazet <edumazet@google.com>

Two From: fields here.

> [ Upstream commit 7db48e983930285b765743ebd665aecf9850582b ]
>=20
> There are few places where we fetch tp->copied_seq while
> this field can change from IRQ or other cpu.

And there are few such places even after the patch is applied; I
quoted them below.

Doing addition to variable without locking... is kind of
interesting. Are you sure it is okay?

> @@ -2112,7 +2112,7 @@ int tcp_recvmsg(struct sock *sk, struct
>  			if (urg_offset < used) {
>  				if (!urg_offset) {
>  					if (!sock_flag(sk, SOCK_URGINLINE)) {
> -						++*seq;
> +						WRITE_ONCE(*seq, *seq + 1);
>  						urg_hole++;
>  						offset++;
>  						used--;
> @@ -2134,7 +2134,7 @@ int tcp_recvmsg(struct sock *sk, struct
>  			}
>  		}
> =20
> -		*seq +=3D used;
> +		WRITE_ONCE(*seq, *seq + used);
>  		copied +=3D used;
>  		len -=3D used;
> =20
> @@ -2163,7 +2163,7 @@ skip_copy:
> =20
>  	found_fin_ok:
>  		/* Process the FIN. */
> -		++*seq;
> +		WRITE_ONCE(*seq, *seq + 1);
>  		if (!(flags & MSG_PEEK))
>  			sk_eat_skb(sk, skb);
>  		break;

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBQfVEACgkQMOfwapXb+vJ9VgCfY34c39nassZfZh50cm1j60Ga
R8gAoI7SBRhkbGI2pxLQRXw5I+v93yzD
=dGFU
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
