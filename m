Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48AD25FB1A4
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 13:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiJKLmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 07:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJKLmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 07:42:19 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081557C32E;
        Tue, 11 Oct 2022 04:42:17 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9C7A91C0025; Tue, 11 Oct 2022 13:42:15 +0200 (CEST)
Date:   Tue, 11 Oct 2022 13:42:15 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, xen-devel@lists.xenproject.org,
        nathan@kernel.org, ndesaulniers@google.com, llvm@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 4.19 5/6] x86/entry: Work around Clang __bdos()
 bug
Message-ID: <20221011114215.GA12851@duo.ucw.cz>
References: <20221009205443.1203725-1-sashal@kernel.org>
 <20221009205443.1203725-5-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20221009205443.1203725-5-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Kees Cook <keescook@chromium.org>
>=20
> [ Upstream commit 3e1730842f142add55dc658929221521a9ea62b6 ]
>=20
> Clang produces a false positive when building with CONFIG_FORTIFY_SOURCE=
=3Dy
> and CONFIG_UBSAN_BOUNDS=3Dy when operating on an array with a dynamic
> offset. Work around this by using a direct assignment of an empty
> instance. Avoids this warning:
>=20
> ../include/linux/fortify-string.h:309:4: warning: call to __write_overflo=
w_field declared with 'warn
> ing' attribute: detected write beyond size of field (1st parameter); mayb=
e use struct_group()? [-Wat
> tribute-warning]
>                         __write_overflow_field(p_size_field, size);
>                         ^
>=20
> which was isolated to the memset() call in xen_load_idt().
>=20
> Note that this looks very much like another bug that was worked around:
> https://github.com/ClangBuiltLinux/linux/issues/1592

At least in 4.19, there's no UBSAN_BOUNDS. Sounds like we don't need
it in old kernels?

Best regards,
								Pavel
> +++ b/arch/x86/xen/enlighten_pv.c
> @@ -752,6 +752,7 @@ static void xen_load_idt(const struct desc_ptr *desc)
>  {
>  	static DEFINE_SPINLOCK(lock);
>  	static struct trap_info traps[257];
> +	static const struct trap_info zero =3D { };
>  	unsigned out;
> =20
>  	trace_xen_cpu_load_idt(desc);
> @@ -761,7 +762,7 @@ static void xen_load_idt(const struct desc_ptr *desc)
>  	memcpy(this_cpu_ptr(&idt_desc), desc, sizeof(idt_desc));
> =20
>  	out =3D xen_convert_trap_info(desc, traps, false);
> -	memset(&traps[out], 0, sizeof(traps[0]));
> +	traps[out] =3D zero;
> =20
>  	xen_mc_flush();
>  	if (HYPERVISOR_set_trap_table(traps))
> --=20
> 2.35.1

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY0VWlwAKCRAw5/Bqldv6
8ohVAJsF4vk8+1nzRcz7J6Zq4UFdI6Kl8ACffFGKzc5xIB2EYvVi0yKvMcv+Y2Y=
=eeGa
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
