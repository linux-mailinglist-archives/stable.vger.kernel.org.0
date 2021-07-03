Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436473BA935
	for <lists+stable@lfdr.de>; Sat,  3 Jul 2021 17:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbhGCPYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Jul 2021 11:24:41 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39196 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhGCPYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Jul 2021 11:24:41 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E7E0F1C0B81; Sat,  3 Jul 2021 17:22:06 +0200 (CEST)
Date:   Sat, 3 Jul 2021 17:22:05 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.4 41/57] x86/fpu: Reset state for all signal restore
 failures
Message-ID: <20210703152205.GC3004@amd>
References: <20210628144256.34524-1-sashal@kernel.org>
 <20210628144256.34524-42-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
Content-Disposition: inline
In-Reply-To: <20210628144256.34524-42-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit efa165504943f2128d50f63de0c02faf6dcceb0d upstream.
>=20
> If access_ok() or fpregs_soft_set() fails in __fpu__restore_sig() then the
> function just returns but does not clear the FPU state as it does for all
> other fatal failures.
>=20
> Clear the FPU state for these failures as well.

That's quite a confusing calling convention, right?

> +++ b/arch/x86/kernel/fpu/signal.c
> @@ -262,15 +262,23 @@ static int __fpu__restore_sig(void __user *buf, voi=
d __user *buf_fx, int size)
>  		return 0;
>  	}
> =20
> -	if (!access_ok(VERIFY_READ, buf, size))
> +	if (!access_ok(VERIFY_READ, buf, size)) {
> +		fpu__clear(fpu);
>  		return -EACCES;
> +	}

This returns -errno on failure.

>  	fpu__activate_curr(fpu);
> =20
> -	if (!static_cpu_has(X86_FEATURE_FPU))
> -		return fpregs_soft_set(current, NULL,
> -				       0, sizeof(struct user_i387_ia32_struct),
> -				       NULL, buf) !=3D 0;
> +	if (!static_cpu_has(X86_FEATURE_FPU)) {
> +		int ret =3D fpregs_soft_set(current, NULL, 0,
> +					  sizeof(struct user_i387_ia32_struct),
> +					  NULL, buf);
> +
> +		if (ret)
> +			fpu__clear(fpu);
> +
> +		return ret !=3D 0;
> +	}

And this explicitely turns negative error into 1 for maximum confusion.

I don't see the same confusion in mainline.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany


--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDggJ0ACgkQMOfwapXb+vILuwCfZgedwyD/ZOuDzetWeuyKpdCn
5H4AoJYYkAsv+IsY6ADwONrtiVJv54t3
=2R9/
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
