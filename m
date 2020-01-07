Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09FB132EE2
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 19:59:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbgAGS7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 13:59:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35680 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728358AbgAGS7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 13:59:50 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iou4y-0007Yc-E1; Tue, 07 Jan 2020 18:59:48 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1iou4x-00693y-QG; Tue, 07 Jan 2020 18:59:47 +0000
Message-ID: <524de39bbeee91d14561e411d55e9f3aa29be96f.camel@decadent.org.uk>
Subject: Re: [stable] x86/atomic functions missing memory clobber
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Jari Ruusu <jariruusu@users.sourceforge.net>,
        stable <stable@vger.kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Date:   Tue, 07 Jan 2020 18:59:43 +0000
In-Reply-To: <20200107181450.GA2014625@kroah.com>
References: <90b417dcc1db1dfa637d9369af237879dda97e96.camel@decadent.org.uk>
         <20200107181450.GA2014625@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-yYD1g1DEQhieM0PjrXjl"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-yYD1g1DEQhieM0PjrXjl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-01-07 at 19:14 +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 07, 2020 at 05:48:55PM +0000, Ben Hutchings wrote:
> > I noticed that backports of commit 69d927bba395 "x86/atomic: Fix
> > smp_mb__{before,after}_atomic()" didn't touch atomic_or_long() (present
> > in 3.16) or atomic_inc_short() (present in 4.9 and earlier).
> >=20
> > These functions were only implemented on x86 and not actually used in-
> > tree.  But it's possible they are used by some out-of-tree module, and
> > that commit removed compiler barriers for them.
> >=20
> > Would it might make sense to either
> > 1. Add the memory clobber to these functions, or
> > 2. Delete them
> > on the affected stable branches?
>=20
> Looks like we can drop atomic_inc_short for 4.9 as there are no users,
> same for 4.4.  I'll go do that now.  It's not like the "fix" is really
> needed here because of that :)

Upstream commit for this is:

commit 31b35f6b4d5285a311e10753f4eb17304326b211
Author: Dmitry Vyukov <dvyukov@google.com>
Date:   Fri May 26 19:29:00 2017 +0200

    locking/x86: Remove the unused atomic_inc_short() methd

Ben.

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.



--=-yYD1g1DEQhieM0PjrXjl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4U1R8ACgkQ57/I7JWG
EQllhBAAubATrS8jOsxaGZYhdo1XaE7Go98it6FXNh9mjouZ7Nk4lXjTBOtM2XKn
GcshN7zs/b/D4qWUCTCJMugswlk6okcHsRTeoup2iNSqC58MOhWR/40MrkEicArP
H4iY03AteckZHX5F3Z4ECvRqo96xrbzRsaNy+Xw+QBMXveWiPc38kRGMAVSAwP+g
PnedhunKP4q4MfW1gx1GYJeG5apXxc4pDnokDcJtg+/TCiiLBvbYuynoKoWq1VZk
ndIoCMf63y2601AeU9vpfY5kgbww93E0Azvb4QWgAoCM9/mbenxWyJC+gEDd5ZPT
CkFmdtqBI9Ka/+hHOKMMUvLCqgPvwKnrqUXjtsYGH2ONiSBIufnMuR6FS6XCtq26
1Aw9lXDSHbLChxNOnbY866qhip5RIxFY/L29FPy69MvtecSxe/dbwJvEtY43Mn4o
yeCFHoMQEUFIPAH8qGs6nmf6iJWQyJ9Gw8J6sOCzzUUSoKlIQQHTfxmr4DvnHBj1
C++1078pMma798RsXG9u2Di6p/gNViYxPi5xijtGxUGAfI1Ovq3eYRaVUw1Eu2tc
Zc0dD4w0medwL3xEmFNxguk4o7dTejfwGZ7h46l+4lfdkr3fxShWh1Y3Tpl8Tts5
57AbkLCZnev7NGDYWDZsn6naGSh2wBSxiPRDnnvGDo++Ov03XpU=
=BGFN
-----END PGP SIGNATURE-----

--=-yYD1g1DEQhieM0PjrXjl--
