Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4715D132D85
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 18:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgAGRtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 12:49:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35242 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728529AbgAGRtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 12:49:03 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iosyS-00037f-N9; Tue, 07 Jan 2020 17:49:00 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1iosyS-005Vvm-4w; Tue, 07 Jan 2020 17:49:00 +0000
Message-ID: <90b417dcc1db1dfa637d9369af237879dda97e96.camel@decadent.org.uk>
Subject: [stable] x86/atomic functions missing memory clobber
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Jari Ruusu <jariruusu@users.sourceforge.net>
Cc:     stable <stable@vger.kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Date:   Tue, 07 Jan 2020 17:48:55 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-E1iZZLy5/P9Ferkg29N4"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-E1iZZLy5/P9Ferkg29N4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I noticed that backports of commit 69d927bba395 "x86/atomic: Fix
smp_mb__{before,after}_atomic()" didn't touch atomic_or_long() (present
in 3.16) or atomic_inc_short() (present in 4.9 and earlier).

These functions were only implemented on x86 and not actually used in-
tree.  But it's possible they are used by some out-of-tree module, and
that commit removed compiler barriers for them.

Would it might make sense to either
1. Add the memory clobber to these functions, or
2. Delete them
on the affected stable branches?

Ben.

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.


--=-E1iZZLy5/P9Ferkg29N4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4UxIcACgkQ57/I7JWG
EQln+g/+MEzjgtB9v+q9hGnE4lio+9oS0Du6rsTBOZuWvGex1X9ChqctcvaNajCv
43PYZsOHRopYQlTAr2FuBF6r6Krj4hebAu9wQywQWk/ClYp9uLU/QhyIEh29rlHI
xpBPQ7YGVB00ufnmipo2bF3TPZYo3FNUFslI7qTViVBfZ/FEXDhUsLHzv/wZwSz2
T58IgNjKYN9R+cT4WcCYQ39tLqu2HCqSxpGaVPZ+LPMc6VNn66qdBm12QbTmk4oR
6cxmADTap4YTKiIZPzI13Gb9y/wwxLQSVvMXZDMlXTuDP9YQXm/036W7cUEDZ+eB
HcjG2d7/UL+Yp1vqqIpUdOy4LfWCzqVoOevZZzzetFnzyWR2+kGI2CAxhZxJ0/+8
3IuJaLw6w7Ch9VPhsX/p83UAL/ChjO7vckcuNoCP4CN2BMwpIvmBDLTa6mOrJNVS
2saMlcxrYUSSYlRGlsfo4wWGNNMWUvZm8mfiufw5IP4QQ7Y6WfzIXGyGurVxYnF+
h1sV3eftHWmkewnDdCjXQqhsl/pgcHQX51afKSkSCxuFTY430Po/nzc01GCpIvhc
Ol7x4Z4gKKRbuhq5z6UGXx71fW6GGFH4mMK0OhjYbnYujKbga8l8/tJDp4mAnlvs
safJo3dI+gtvs1bXTdfivjEiV/yHRSfBfXWoJyCDbDdyhxkQ5Iw=
=d8Ix
-----END PGP SIGNATURE-----

--=-E1iZZLy5/P9Ferkg29N4--
