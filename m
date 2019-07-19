Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB0C6EC87
	for <lists+stable@lfdr.de>; Sat, 20 Jul 2019 00:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbfGSWdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 18:33:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49863 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfGSWdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 18:33:23 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id CCCF08032D; Sat, 20 Jul 2019 00:33:08 +0200 (CEST)
Date:   Sat, 20 Jul 2019 00:33:19 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 13/47] afs: Fix uninitialised spinlock
 afs_volume::cb_break_lock
Message-ID: <20190719223319.GA32199@amd>
References: <20190718030045.780672747@linuxfoundation.org>
 <20190718030049.759890872@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20190718030049.759890872@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Without this, the following trace may be observed when a volume-break
> callback is received:
>=20
>   INFO: trying to register non-static key.
>   the code is fine but needs lockdep annotation.

I'm sure this fixes the warning...

> diff --git a/fs/afs/callback.c b/fs/afs/callback.c
> index 5f261fbf2182..4ad701250299 100644
> --- a/fs/afs/callback.c
> +++ b/fs/afs/callback.c
> @@ -276,9 +276,9 @@ static void afs_break_one_callback(struct afs_server =
*server,
>  			struct afs_super_info *as =3D AFS_FS_S(cbi->sb);
>  			struct afs_volume *volume =3D as->volume;
> =20
> -			write_lock(&volume->cb_break_lock);
> +			write_lock(&volume->cb_v_break_lock);
>  			volume->cb_v_break++;
> -			write_unlock(&volume->cb_break_lock);
> +			write_unlock(&volume->cb_v_break_lock);
>  		} else {
>  			data.volume =3D NULL;
>  			data.fid =3D *fid;

But this is the only use of the lock.

Which is strange: we have read/write lock, but we only use the write
side. Readers don't take the lock, so it does not offer any protection
for them.

Is that correct? Does this need to be rwlock, or would plain spinlock
be enough? atomic_t?

(Problem exists in the mainline, nothing stable specific here).

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl0yRS8ACgkQMOfwapXb+vI1ZwCeLs/jEeAzqUrYgS0zSusJliCY
MrkAn2aVDKgfaTmyBERlnzdpcQOHnOGL
=bvsH
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
