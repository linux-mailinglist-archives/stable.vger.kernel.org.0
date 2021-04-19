Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23021364D11
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 23:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232885AbhDSVaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 17:30:02 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46346 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhDSVaC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 17:30:02 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4CE431C0B7A; Mon, 19 Apr 2021 23:29:31 +0200 (CEST)
Date:   Mon, 19 Apr 2021 23:29:30 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aditya Pakki <pakki001@umn.edu>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 042/103] net/rds: Avoid potential use after free in
 rds_send_remove_from_sock
Message-ID: <20210419212930.GA6626@amd>
References: <20210419130527.791982064@linuxfoundation.org>
 <20210419130529.251281725@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20210419130529.251281725@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 0c85a7e87465f2d4cbc768e245f4f45b2f299b05 ]
>=20
> In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
> is freed and later under spinlock, causing potential use-after-free.
> Set the free pointer to NULL to avoid undefined behavior.

This patch is crazy. Take a look at Message-ID:
<20210419084953.GA28564@amd>. Or just look at the patch :-).

Best regards,
								Pavel
> +++ b/net/rds/message.c
> @@ -180,6 +180,7 @@ void rds_message_put(struct rds_message *rm)
>  		rds_message_purge(rm);
> =20
>  		kfree(rm);
> +		rm =3D NULL;
>  	}
>  }
>  EXPORT_SYMBOL_GPL(rds_message_put);
> diff --git a/net/rds/send.c b/net/rds/send.c
> index 985d0b7713ac..fe5264b9d4b3 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -665,7 +665,7 @@ static void rds_send_remove_from_sock(struct list_hea=
d *messages, int status)
>  unlock_and_drop:
>  		spin_unlock_irqrestore(&rm->m_rs_lock, flags);
>  		rds_message_put(rm);
> -		if (was_on_sock)
> +		if (was_on_sock && rm)
>  			rds_message_put(rm);
>  	}
> =20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmB99joACgkQMOfwapXb+vIAGQCgnL84YaGH4RnXJ87ZuqGryccv
qM0AoMJI8M8nrmObS7svKsM+A4zKVp2Q
=Ms63
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
