Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64CB1D3EC4
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 22:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgENUNo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 16:13:44 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:59634 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgENUNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 16:13:44 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 74AA11C0288; Thu, 14 May 2020 22:13:41 +0200 (CEST)
Date:   Thu, 14 May 2020 22:13:40 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Dave Jones <dsj@fb.com>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: [PATCH 4.19 41/48] x86/unwind/orc: Prevent unwinding before ORC
 initialization
Message-ID: <20200514201340.GA14148@amd>
References: <20200513094351.100352960@linuxfoundation.org>
 <20200513094402.645961403@linuxfoundation.org>
 <20200513215210.GB27858@amd>
 <20200514194457.wipphhvyhzcshcup@treble>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <20200514194457.wipphhvyhzcshcup@treble>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > From: Josh Poimboeuf <jpoimboe@redhat.com>
> > >=20
> > > commit 98d0c8ebf77e0ba7c54a9ae05ea588f0e9e3f46e upstream.
> > >=20
> > > If the unwinder is called before the ORC data has been initialized,
> > > orc_find() returns NULL, and it tries to fall back to using frame
> > > pointers.  This can cause some unexpected warnings during boot.
> > >=20
> > > Move the 'orc_init' check from orc_find() to __unwind_init(), so that=
 it
> > > doesn't even try to unwind from an uninitialized state.
> >=20
> > > @@ -563,6 +560,9 @@ EXPORT_SYMBOL_GPL(unwind_next_frame);
> > >  void __unwind_start(struct unwind_state *state, struct task_struct *=
task,
> > >  		    struct pt_regs *regs, unsigned long *first_frame)
> > >  {
> > > +	if (!orc_init)
> > > +		goto done;
> > > +
> > >  	memset(state, 0, sizeof(*state));
> > >  	state->task =3D task;
> > > =20
> >=20
> > As this returns the *state to the caller, should the "goto done" move
> > below the memset? Otherwise we are returning partialy-initialized
> > struct, which is ... weird.
>=20
> Yeah, it is a little weird.  In most cases it should be fine, but there
> is an edge case where if there's a corrupt ORC table and this returns
> early, 'arch_stack_walk_reliable() -> unwind_error()' could check an
> uninitialized value.
>=20
> Also the __unwind_start() error handling needs to set that error bit
> anyway, in its error cases.  I'll fix it up.

I did this in the mean time. It moves goto around memset, and I
believe that 8 in get_reg should have been sizeof(long) [not that it
matters, x86-32 is protected by build bug on.]

Signed-off-by: Pavel Machek <pavel@ucw.cz>

Best regards,
								Pavel

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 169b96492b7c..90cb3cb2b4f1 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -375,7 +375,7 @@ static bool deref_stack_iret_regs(struct unwind_state *=
state, unsigned long addr
 static bool get_reg(struct unwind_state *state, unsigned int reg_off,
 		    unsigned long *val)
 {
-	unsigned int reg =3D reg_off/8;
+	unsigned int reg =3D reg_off/sizeof(long);
=20
 	if (!state->regs)
 		return false;
@@ -589,12 +589,12 @@ EXPORT_SYMBOL_GPL(unwind_next_frame);
 void __unwind_start(struct unwind_state *state, struct task_struct *task,
 		    struct pt_regs *regs, unsigned long *first_frame)
 {
-	if (!orc_init)
-		goto done;
-
 	memset(state, 0, sizeof(*state));
 	state->task =3D task;
=20
+	if (!orc_init)
+		goto done;
+=09
 	/*
 	 * Refuse to unwind the stack of a task while it's executing on another
 	 * CPU.  This check is racy, but that's ok: the unwinder has other


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl69pnQACgkQMOfwapXb+vJT4wCgnKFI6MrEHmzkLntrelInmSqf
fMsAoKAofZLJUHurE9J5j6kxvotwlvYv
=nT2r
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
