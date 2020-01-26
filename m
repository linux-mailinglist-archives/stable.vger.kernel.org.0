Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9666C149C04
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 18:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgAZRNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 12:13:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52260 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbgAZRNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 12:13:39 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ivlTe-0007Wy-4e; Sun, 26 Jan 2020 17:13:38 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ivlTd-0012Yf-Ol; Sun, 26 Jan 2020 17:13:37 +0000
Message-ID: <114b087b50c83cfa3cc9afc8e08641a0d1ab8ce4.camel@decadent.org.uk>
Subject: Re: [PATCH] fix 3.16 unknown rela relocation 4 error
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Woody Suwalski <terraluna977@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     stable <stable@vger.kernel.org>
Date:   Sun, 26 Jan 2020 17:13:32 +0000
In-Reply-To: <48d562fd-f80a-69ae-56e5-d0bada0feeed@gmail.com>
References: <48d562fd-f80a-69ae-56e5-d0bada0feeed@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-l/T8Jq/8x20HtJEtG9xW"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-l/T8Jq/8x20HtJEtG9xW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2020-01-25 at 22:16 -0500, Woody Suwalski wrote:
> Trying to use an AMD64 3.16 kernel built on a new Debian system fails=20
> because
> most of the kernel modules can not be loaded.

I don't recommend using the latest toolchain for 3.16 (certainly gcc 9
won't work).  But I will apply this since it's such a simple fix.=20
Thanks for the backport.

Ben.

> This patch handles the PLT32 relocation errors for kernels modules built=
=20
> with binutils
> newer then 2.31, similar to:
> [    5.742485] module: autofs4: Unknown rela relocation: 4
> [    5.742536] systemd[1]: Failed to insert module 'autofs4': Exec=20
> format error
>=20
> This patch is based on a mainline kernel patch=20
> b21ebf2fb4cde1618915a97cc773e287ff49173e
> From: "H.J. Lu" <hjl.tools@gmail.com>
> Date: Wed, 7 Feb 2018 14:20:09 -0800
> Subject: x86: Treat R_X86_64_PLT32 as R_X86_64_PC32
>=20
> Signed-off-by: Woody Suwalski <terraluna977@gmail.com>
>=20
> --- a/arch/x86/tools/relocs.c    2020-01-24 18:48:09.477919152 -0500
> +++ b/arch/x86/tools/relocs.c    2020-01-24 18:48:53.645612045 -0500
> @@ -763,6 +763,7 @@ static int do_reloc64(struct section *se
>       switch (r_type) {
>       case R_X86_64_NONE:
>       case R_X86_64_PC32:
> +    case R_X86_64_PLT32:
>           /*
>            * NONE can be ignored and PC relative relocations don't
>            * need to be adjusted.
> --- a/arch/x86/kernel/module.c    2020-01-24 18:46:54.922670590 -0500
> +++ b/arch/x86/kernel/module.c    2020-01-24 18:47:46.714112016 -0500
> @@ -180,6 +180,7 @@ int apply_relocate_add(Elf64_Shdr *sechd
>                   goto overflow;
>               break;
>           case R_X86_64_PC32:
> +        case R_X86_64_PLT32:
>               val -=3D (u64)loc;
>               *(u32 *)loc =3D val;
>   #if 0
>=20
--=20
Ben Hutchings
The program is absolutely right; therefore, the computer must be wrong.



--=-l/T8Jq/8x20HtJEtG9xW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4tyL0ACgkQ57/I7JWG
EQnDABAAiq5hKPXIeNqducstec+5xobajzMwM13kj6uwspdGpvAkPiLIvysz+h+H
K3bxP4Rb9GWtK1ONFDKBRYzYZtdvPHXjh0IwXCwegZi6tPdGbOvzWgpLZEVgkj4y
5xYAww1VQn8aWm2qyZnAljkVbgqrk/QOypRTIfOmwQH+hzOGPk3UTe0/b1i1sv1Z
SJ7Pfq2HFR0zg7pg14wTCi0SuFOdFlX0MZCD1yANOTRGKL5cnqwq714e4gCttBJN
ZFL7b9FTepOJChxG6D5o3uwQJMUZDzqBvC4bq7rIn7Zcg8BJNNTghChtTYNQdH/8
WeTTJ3OnOPgLKm2wZ2CYfzqJBpYTyQ5uQE4lv1FDUu1ctbhGK803Y4eWpNMNtShu
urc68r7FPCdeT+JrK68hI8ARTkw6gMOdKXrdxWNtSZI4CSw3FY4gTULC7Ft3eR9P
F0jbnF+3Hz1rjk7OjuDaX2LqCpY0oWVlukazr7Qmn5cMgY1EFgnNUzLO+z+ENBSK
RL0w0RJjZnCuQpUmHFG26m+A6ZBH+u7mam/K6Ti+p1iuVNIrSReVyw7EqePH3Rhk
tzQEWnaXdWni1lktM/2tqDItqN/1hL3glzkH/RCbC/sgkxP8kEsSaPnWqQDkB8yr
ihpv5UJ42jzH4a1Phup2CffUJH+bR+4LLRh86Uni7CBie1ecWvA=
=EvLl
-----END PGP SIGNATURE-----

--=-l/T8Jq/8x20HtJEtG9xW--
