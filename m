Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2BF1D217E
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 23:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbgEMVwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 17:52:13 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55624 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729487AbgEMVwM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 17:52:12 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 342A21C0285; Wed, 13 May 2020 23:52:11 +0200 (CEST)
Date:   Wed, 13 May 2020 23:52:10 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Dave Jones <dsj@fb.com>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 4.19 41/48] x86/unwind/orc: Prevent unwinding before ORC
 initialization
Message-ID: <20200513215210.GB27858@amd>
References: <20200513094351.100352960@linuxfoundation.org>
 <20200513094402.645961403@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7ZAtKRhVyVSsbBD2"
Content-Disposition: inline
In-Reply-To: <20200513094402.645961403@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7ZAtKRhVyVSsbBD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Josh Poimboeuf <jpoimboe@redhat.com>
>=20
> commit 98d0c8ebf77e0ba7c54a9ae05ea588f0e9e3f46e upstream.
>=20
> If the unwinder is called before the ORC data has been initialized,
> orc_find() returns NULL, and it tries to fall back to using frame
> pointers.  This can cause some unexpected warnings during boot.
>=20
> Move the 'orc_init' check from orc_find() to __unwind_init(), so that it
> doesn't even try to unwind from an uninitialized state.

> @@ -563,6 +560,9 @@ EXPORT_SYMBOL_GPL(unwind_next_frame);
>  void __unwind_start(struct unwind_state *state, struct task_struct *task,
>  		    struct pt_regs *regs, unsigned long *first_frame)
>  {
> +	if (!orc_init)
> +		goto done;
> +
>  	memset(state, 0, sizeof(*state));
>  	state->task =3D task;
> =20

As this returns the *state to the caller, should the "goto done" move
below the memset? Otherwise we are returning partialy-initialized
struct, which is ... weird.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--7ZAtKRhVyVSsbBD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl68bAoACgkQMOfwapXb+vIO/wCfeBz+IYxkM6JcitMdJYsM+hlL
nbMAn1Tq0iWjnwpbT7Xhq4LpYViSDVSd
=vaev
-----END PGP SIGNATURE-----

--7ZAtKRhVyVSsbBD2--
