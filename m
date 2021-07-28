Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20DB03D8B8B
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 12:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhG1KPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 06:15:04 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54838 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhG1KPD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 06:15:03 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 688A31C0B7C; Wed, 28 Jul 2021 12:15:01 +0200 (CEST)
Date:   Wed, 28 Jul 2021 12:15:00 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 103/167] cifs: only write 64kb at a time when
 fallocating a small region of a file
Message-ID: <20210728101500.GC30574@amd>
References: <20210726153839.371771838@linuxfoundation.org>
 <20210726153842.851690981@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Content-Disposition: inline
In-Reply-To: <20210726153842.851690981@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 2485bd7557a7edb4520b4072af464f0a08c8efe0 ]
>=20
> We only allow sending single credit writes through the SMB2_write() synch=
ronous
> api so split this into smaller chunks.

I'm not sure if this matters, but if len is ever zero, we'll return
uninitialized value from the function.

Best regards,
								Pavel

> +++ b/fs/cifs/smb2ops.c
> @@ -3466,7 +3466,7 @@ static int smb3_simple_fallocate_write_range(unsign=
ed int xid,
>  					     char *buf)
>  {
>  	struct cifs_io_parms io_parms =3D {0};
> -	int nbytes;
> +	int rc, nbytes;
>  	struct kvec iov[2];
> =20
>  	io_parms.netfid =3D cfile->fid.netfid;
> @@ -3474,13 +3474,25 @@ static int smb3_simple_fallocate_write_range(unsi=
gned int xid,
>  	io_parms.tcon =3D tcon;
>  	io_parms.persistent_fid =3D cfile->fid.persistent_fid;
>  	io_parms.volatile_fid =3D cfile->fid.volatile_fid;
> -	io_parms.offset =3D off;
> -	io_parms.length =3D len;
> =20
> -	/* iov[0] is reserved for smb header */
> -	iov[1].iov_base =3D buf;
> -	iov[1].iov_len =3D io_parms.length;
> -	return SMB2_write(xid, &io_parms, &nbytes, iov, 1);
> +	while (len) {
> +		io_parms.offset =3D off;
> +		io_parms.length =3D len;
> +		if (io_parms.length > SMB2_MAX_BUFFER_SIZE)
> +			io_parms.length =3D SMB2_MAX_BUFFER_SIZE;
> +		/* iov[0] is reserved for smb header */
> +		iov[1].iov_base =3D buf;
> +		iov[1].iov_len =3D io_parms.length;
> +		rc =3D SMB2_write(xid, &io_parms, &nbytes, iov, 1);
> +		if (rc)
> +			break;
> +		if (nbytes > len)
> +			return -EINVAL;
> +		buf +=3D nbytes;
> +		off +=3D nbytes;
> +		len -=3D nbytes;
> +	}
> +	return rc;
>  }
> =20
>  static int smb3_simple_fallocate_range(unsigned int xid,

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmEBLiQACgkQMOfwapXb+vKtgwCfaLJn28EwRPsIBgz2lNrVGS31
v5cAnisWdXnEltPKtPv9nW0M6dtlOZHB
=OwWV
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
