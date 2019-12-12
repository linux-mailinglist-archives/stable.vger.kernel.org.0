Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE5F11D409
	for <lists+stable@lfdr.de>; Thu, 12 Dec 2019 18:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730161AbfLLRcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Dec 2019 12:32:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34958 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730061AbfLLRcY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Dec 2019 12:32:24 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ifSK3-00027O-P9; Thu, 12 Dec 2019 17:32:19 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ifSK3-0005J3-82; Thu, 12 Dec 2019 17:32:19 +0000
Message-ID: <e51e280b1a2ec31d4a9acb541b26f2e5420c703d.camel@decadent.org.uk>
Subject: Re: [PATCH 4.9 45/47] Smack: Dont ignore other bprm->unsafe flags
 if LSM_UNSAFE_PTRACE is set
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jann Horn <jannh@google.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date:   Thu, 12 Dec 2019 17:32:14 +0000
In-Reply-To: <20191212170649.GA1681017@kroah.com>
References: <20191006172016.873463083@linuxfoundation.org>
         <20191006172019.260683324@linuxfoundation.org>
         <64c5b8b423774029c3030ae778bf214d36499d2a.camel@decadent.org.uk>
         <20191212170649.GA1681017@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-5TWjip13pX9rhqBM9tED"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-5TWjip13pX9rhqBM9tED
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2019-12-12 at 18:06 +0100, Greg Kroah-Hartman wrote:
> On Thu, Dec 05, 2019 at 03:50:07PM +0000, Ben Hutchings wrote:
> > On Sun, 2019-10-06 at 19:21 +0200, Greg Kroah-Hartman wrote:
> > > From: Jann Horn <jannh@google.com>
> > >=20
> > > commit 3675f052b43ba51b99b85b073c7070e083f3e6fb upstream.
> > [...]
> > > --- a/security/smack/smack_lsm.c
> > > +++ b/security/smack/smack_lsm.c
> > > @@ -949,7 +949,8 @@ static int smack_bprm_set_creds(struct l
> > > =20
> > >  		if (rc !=3D 0)
> > >  			return rc;
> > > -	} else if (bprm->unsafe)
> > > +	}
> > > +	if (bprm->unsafe & ~LSM_UNSAFE_PTRACE)
> >=20
> > I think this needs to be ~(LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)
> > for 4.9 and older branches.
>=20
> Why?  Where did the LSM_UNSAFE_PTRACE_CAP requirement come from (or
> really, go away?)

LSM_UNSAFE_PTRACE_CAP was combined with LSM_UNSAFE_PTRACE by:

commit 9227dd2a84a765fcfef1677ff17de0958b192eda
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Mon Jan 23 17:26:31 2017 +1300

    exec: Remove LSM_UNSAFE_PTRACE_CAP

If I understand the patch ("Smack: Dont ignore other bprm->unsafe
flags =E2=80=A6") correctly, this function should have one if-statement
handling LSM_UNSAFE_PTRACE (and LSM_UNSAFE_PTRACE_CAP if it exists),
followed by another if-statement handling all other flags in
bprm->unsafe.

Ben.

--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.


--=-5TWjip13pX9rhqBM9tED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3yeZ8ACgkQ57/I7JWG
EQlZtA//Vc+1fMfaULjuYh6nSrneMY6YWu/Y5Q1MFJoxEycjb7rMr9CYFyfTa2gK
S+SQdPneKD3Aqc7j/nYwdXLC3M8JvSHQHzUMQS6AqB377LPlsHDKEoTkZDv7aTFv
g4PP7L2S3JIKGKkehRu63OEVPbBWyXkNcFmVdnzwxF/aH2x1cBcdAeiyK4wa8Ggb
4nIHDH7quI3BMAllYH5bwVrz5K3GF2l/kaEhLEsi/EtYHZ+mgdMhFFDzwBWyiIYU
/J4LEUKf85qtDn/8fToactAOW8Q50oMoPlt/apQ/GnzWbUIjlhDq9DCp5wtjdMXW
lBhm7W9H8G10lTGeq/hz68WmnWGZT8lMAJ6hqD5wacGTuO2d2JHNrlboLVZWs7RY
M3uDgJAUTWebubmFr3eu1dahnDxMPy5OIz2f/hxzHZB9A++4s56WKfHH3X2TZG6m
8gU/57zhLBg3u9LWeR2P4K7IXWqtibfN7dy7qnNO16xhX7pRcCjRqM9YlbSO8Yxs
Zxe1HPcUphhiHXt2V3j2fAWk9UPNxFeCEg0T3SMAVlR1+0FfxBS/STDbYnWJV0oq
5vUi+QnJYGE8N6Bcy7yyphubfbfEne9AYzUkwj6+OZcKGxyke4QMbS5wioeTsCJk
eyaW/S95ud0OmgJc8rESE8sORgJeyL4Lqq2NWsqFbCqmZxQtJDY=
=Halt
-----END PGP SIGNATURE-----

--=-5TWjip13pX9rhqBM9tED--
