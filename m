Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD28632EBB3
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhCEM4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:56:09 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59558 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhCEMzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 07:55:52 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2DBD31C0B81; Fri,  5 Mar 2021 13:55:49 +0100 (CET)
Date:   Fri, 5 Mar 2021 13:55:48 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.11 070/104] f2fs: handle unallocated section and zone
 on pinned/atgc
Message-ID: <20210305125548.GA20940@amd>
References: <20210305120903.166929741@linuxfoundation.org>
 <20210305120906.599343616@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20210305120906.599343616@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 632faca72938f9f63049e48a8c438913828ac7a9 ]
>=20
> If we have large section/zone, unallocated segment makes them corrupted.
>=20
> E.g.,
>=20
>   - Pinned file:       -1 119304647 119304647
>   - ATGC   data:       -1 119304647 119304647

Ok.

> +++ b/fs/f2fs/segment.h
> @@ -101,11 +101,11 @@ static inline void sanity_check_seg_type(struct f2f=
s_sb_info *sbi,
>  #define BLKS_PER_SEC(sbi)					\
>  	((sbi)->segs_per_sec * (sbi)->blocks_per_seg)
>  #define GET_SEC_FROM_SEG(sbi, segno)				\
> -	((segno) / (sbi)->segs_per_sec)
> +	(((segno) =3D=3D -1) ? -1: (segno) / (sbi)->segs_per_sec)

But now we have macro that evaluates its argument two times, and we
have users passing non-trivial arguments to it. Should these become
inline functions?

fs/f2fs/segment.h:  return GET_SEC_FROM_SEG(sbi, (unsigned int)reserved_seg=
ments(sbi));

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmBCKlQACgkQMOfwapXb+vK5mwCfVgO+b/agpIbxnaU9bOdNtsGb
dlcAoLJQNU5PkpyVx3Frf9sXP8axA4YQ
=1olV
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
