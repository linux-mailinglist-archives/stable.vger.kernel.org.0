Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA986C11B5
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 13:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjCTMTl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 08:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCTMTj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 08:19:39 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7343AA2;
        Mon, 20 Mar 2023 05:19:37 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 30F8E1C0AB3; Mon, 20 Mar 2023 13:19:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucw.cz; s=gen1;
        t=1679314776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eNxJmlFZB/0YKUdc31TWsxrRMD42zr8AsrYFHY5N9k0=;
        b=nPybOODVD7HsilWToR6PjqIvMalpZ/cnyEFwdSDeLpNCI3ofoOzTxncsj2LYU4nL3tc9GK
        fgsM4GqMZNpT196D1TmRYyLmgUNM212t2OP6G8Bei5q6izwZJit2971VNUIP+QoBQsixqv
        FME2ICr+/y4FPo57w12hSH/qQ+0boEM=
Date:   Mon, 20 Mar 2023 13:19:35 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Gow <davidgow@google.com>,
        Sergio =?iso-8859-1?Q?Gonz=E1lez?= Collado 
        <sergio.collado@gmail.com>, Richard Weinberger <richard@nod.at>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 2/5] rust: arch/um: Disable FP/SIMD
 instruction to match x86
Message-ID: <ZBhPV61xAvXfjHw3@duo.ucw.cz>
References: <20230314124435.471553-1-sashal@kernel.org>
 <20230314124435.471553-2-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OccBeRj3MwfmCdSy"
Content-Disposition: inline
In-Reply-To: <20230314124435.471553-2-sashal@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OccBeRj3MwfmCdSy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 8849818679478933dd1d9718741f4daa3f4e8b86 ]
>=20
> The kernel disables all SSE and similar FP/SIMD instructions on
> x86-based architectures (partly because we shouldn't be using floats in
> the kernel, and partly to avoid the need for stack alignment, see:
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D53383 )
>=20
> UML does not do the same thing, which isn't in itself a problem, but
> does add to the list of differences between UML and "normal" x86 builds.
>=20
> In addition, there was a crash bug with LLVM < 15 / rustc < 1.65 when
> building with SSE, so disabling it fixes rust builds with earlier
> compiler versions, see:
> https://github.com/Rust-for-Linux/linux/pull/881

We don't have rust in 4.14, so cited problem can't hit us. This should
not go to -stable.

(Plus, KBUILD_RUSTFLAGS is not going to exist in -stable).

Best regards,
								Pavel

> +# Disable SSE and other FP/SIMD instructions to match normal x86
> +#
> +KBUILD_CFLAGS +=3D -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
> +KBUILD_RUSTFLAGS +=3D -Ctarget-feature=3D-sse,-sse2,-sse3,-ssse3,-sse4.1=
,-sse4.2,-avx,-avx2
> +
>  ifeq ($(CONFIG_X86_32),y)
>  START :=3D 0x8048000
> =20

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--OccBeRj3MwfmCdSy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZBhPVwAKCRAw5/Bqldv6
8hdZAJ9bpYIUNwjMLCkVFVeaC2k1hRoDTgCdGeEf4fQ5/TyBNsddTmb7ebxG/fc=
=aPqH
-----END PGP SIGNATURE-----

--OccBeRj3MwfmCdSy--
