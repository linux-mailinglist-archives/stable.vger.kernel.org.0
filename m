Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52820410CFF
	for <lists+stable@lfdr.de>; Sun, 19 Sep 2021 21:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbhISTIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Sep 2021 15:08:04 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:34478 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbhISTIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Sep 2021 15:08:04 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 202401C0B79; Sun, 19 Sep 2021 21:06:38 +0200 (CEST)
Date:   Sun, 19 Sep 2021 21:06:38 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        stable@kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 5.10 045/306] f2fs: fix to do sanity check for sb/cp
 fields correctly
Message-ID: <20210919190638.GA12836@amd>
References: <20210916155753.903069397@linuxfoundation.org>
 <20210916155755.480312003@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20210916155755.480312003@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

This code looks quite confused: part of function returns 1 on
corruption, part returns -errno. The problem is not stable-specific.

Best regards,
								Pavel

> @@ -3058,6 +3061,17 @@ int f2fs_sanity_check_ckpt(struct f2fs_s
>  		return 1;
>  	}
> =20
> +	nat_blocks =3D nat_segs << log_blocks_per_seg;
> +	nat_bits_bytes =3D nat_blocks / BITS_PER_BYTE;
> +	nat_bits_blocks =3D F2FS_BLK_ALIGN((nat_bits_bytes << 1) + 8);
> +	if (__is_set_ckpt_flags(ckpt, CP_NAT_BITS_FLAG) &&
> +		(cp_payload + F2FS_CP_PACKS +
> +		NR_CURSEG_PERSIST_TYPE + nat_bits_blocks >=3D blocks_per_seg)) {
> +		f2fs_warn(sbi, "Insane cp_payload: %u, nat_bits_blocks: %u)",
> +			  cp_payload, nat_bits_blocks);
> +		return -EFSCORRUPTED;
> +	}
> +
>  	if (unlikely(f2fs_cp_error(sbi))) {
>  		f2fs_err(sbi, "A bug case: need to run fsck");
>  		return 1;
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmFHij4ACgkQMOfwapXb+vInUACgqfnS2ENLFCITtklR3ryxbyTN
wzcAoKMtY+fR5/iYZYJWvuMSK8qDrvKT
=7OU5
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
