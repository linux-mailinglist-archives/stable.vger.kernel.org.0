Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A581D9607
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 14:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgESMP7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 08:15:59 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48288 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728612AbgESMP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 08:15:59 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8DA941C025A; Tue, 19 May 2020 14:15:57 +0200 (CEST)
Date:   Tue, 19 May 2020 14:15:57 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Borislav Petkov <bp@suse.de>, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 4.19 63/80] x86: Fix early boot crash on gcc-10, third try
Message-ID: <20200519121557.GB8342@amd>
References: <20200518173450.097837707@linuxfoundation.org>
 <20200518173503.119342410@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <20200518173503.119342410@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!


> To fix that, the initial attempt was to mark the one function which
> generates the stack canary with:
>=20
>   __attribute__((optimize("-fno-stack-protector"))) ... start_secondary(v=
oid *unused)
>=20
> however, using the optimize attribute doesn't work cumulatively
> as the attribute does not add to but rather replaces previously
> supplied optimization options - roughly all -fxxx options.
>=20
> The key one among them being -fno-omit-frame-pointer and thus leading to
> not present frame pointer - frame pointer which the kernel needs.
>=20
> The next attempt to prevent compilers from tail-call optimizing
> the last function call cpu_startup_entry(), shy of carving out
> start_secondary() into a separate compilation unit and building it with
> -fno-stack-protector, was to add an empty asm("").
>=20
> This current solution was short and sweet, and reportedly, is supported
> by both compilers but we didn't get very far this time: future (LTO?)
> optimization passes could potentially eliminate this, which leads us
> to the third attempt: having an actual memory barrier there which the
> compiler cannot ignore or move around etc.
>=20
> That should hold for a long time, but hey we said that about the other
> two solutions too so...

You need compiler barrier, but mb() compiles down to

asm volatile(ALTERNATIVE("lock; addl $0,-4(%%esp)", "mfence", \
    				     		          X86_FEATURE_XMM2)
    				     		          :::
    				     		          "memory",
    				     		          "cc")

I believe that is a bit of overkill.

I see that empty asm("") is not effective. asm volatile("", :::
"memory") should be effective, AFAICT. You should be able to use
existing barrier() macro.

https://elixir.bootlin.com/linux/latest/source/include/linux/compiler-gcc.h=
#L20

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7Dzf0ACgkQMOfwapXb+vKpeACfW5BaiRlhaceJZKA/LNVEXW4M
a6YAn15O9i3omDyX+jW1blS/34tTJw1A
=Q7Ws
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
