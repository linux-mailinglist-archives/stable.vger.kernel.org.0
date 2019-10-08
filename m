Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 497B5D02C0
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 23:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730722AbfJHVUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 17:20:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55910 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730720AbfJHVUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 17:20:45 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 31D218030B; Tue,  8 Oct 2019 23:20:28 +0200 (CEST)
Date:   Tue, 8 Oct 2019 23:20:41 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     "H. Peter Anvin" <hpa@zytor.com>
Cc:     linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Ingo Molnar <mingo@redhat.com>, Chen Yu <yu.c.chen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [tip: x86/urgent] x86/CPU/AMD: Clear RDRAND CPUID bit on AMD
 family 15h/16h
Message-ID: <20191008212041.GA7222@amd>
References: <7543af91666f491547bd86cebb1e17c66824ab9f.1566229943.git.thomas.lendacky@amd.com>
 <156652264945.9541.4969272027980914591.tip-bot2@tip-bot2>
 <20190824181929.GA18551@amd>
 <409703ae-6d70-3f6a-d6fc-b7dada3c2797@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <409703ae-6d70-3f6a-d6fc-b7dada3c2797@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >> x86/CPU/AMD: Clear RDRAND CPUID bit on AMD family 15h/16h
> >>
> >> There have been reports of RDRAND issues after resuming from suspend on
> >> some AMD family 15h and family 16h systems. This issue stems from a BI=
OS
> >> not performing the proper steps during resume to ensure RDRAND continu=
es
> >> to function properly.
> >=20
> > There are quite a few unanswered questions here.
> >=20
> > a) Is there/should there be CVE for this?
> >=20
> > b) Can we perform proper steps in kernel, thus making RDRAND usable
> > even when BIOS is buggy?
> >=20
>=20
> The kernel should at least be able to set its internal "CPUID" bit, visib=
le
> through /proc/cpuinfo.

Actually, with hindsight I see two possible improvements here:

1) Not having enabled s2ram in config does not mean machine was not
suspended/resumed, then new kernel executed via kexec.

2) We really can continue using the RDRAND: we know how it fails
(constant pattern) so we can check for the failure in kernel, and can
continue to use it... It will certainly work until first suspend, and
there's good chance it will work after that, too. (We still need to
prevent userspace from using it).

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2c/akACgkQMOfwapXb+vIAIgCfTtdPEk+einOr1l0u8g3JJUIR
Hw8An3EIBITYsbuZfkKzqYAG/mjHPUe/
=XIae
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
