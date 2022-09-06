Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 584355AF24B
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 19:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238990AbiIFRTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 13:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239205AbiIFRT3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 13:19:29 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3677297B15
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 10:08:06 -0700 (PDT)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1oVc3O-0007zk-MA; Tue, 06 Sep 2022 19:08:02 +0200
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1oVc3O-0003tQ-08;
        Tue, 06 Sep 2022 19:08:02 +0200
Message-ID: <3fb3cc8cb6bfab9dc52e351c56a31c233051c9b0.camel@decadent.org.uk>
Subject: Re: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing"
 failed to apply to 5.10-stable tree
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     peterz@infradead.org, stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Date:   Tue, 06 Sep 2022 19:07:57 +0200
In-Reply-To: <Yxc4CeyDS2tWLXfo@kroah.com>
References: <166176181110563@kroah.com>
         <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
         <YxB+xgcz9QD5BK77@kroah.com>
         <ff8d3521a32e1a425af32711856d0d8fdfa84d2b.camel@decadent.org.uk>
         <Yxc4CeyDS2tWLXfo@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Rn4sVEEkoczKfwEKu1B3"
User-Agent: Evolution 3.44.4-1+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 213.219.160.184
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-Rn4sVEEkoczKfwEKu1B3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-09-06 at 14:07 +0200, Greg KH wrote:
> On Fri, Sep 02, 2022 at 04:26:57PM +0200, Ben Hutchings wrote:
> > On Thu, 2022-09-01 at 11:43 +0200, Greg KH wrote:
> > > On Mon, Aug 29, 2022 at 04:04:58PM +0200, Ben Hutchings wrote:
> > > > On Mon, 2022-08-29 at 10:30 +0200, gregkh@linuxfoundation.org wrote=
:
> > > > > The patch below does not apply to the 5.10-stable tree.
> > > > > If someone wants it applied there, or to any other stable or long=
term
> > > > > tree, then please email the backport, including the original git =
commit
> > > > > id to <stable@vger.kernel.org>.
> > > > >=20
> > > >=20
> > > > You need commit 4e3aa9238277 "x86/nospec: Unwreck the RSB stuffing"
> > > > before this one.  I've attached the backport of that for 5.10.  I
> > > > haven't checked the older branches.
> > >=20
> > > Great, thanks, this worked.  But the backport did not apply to 4.19, =
so
> > > I will need that in order to take this one as well.
> >=20
> > I've had a look at 5.4, and it's sufficiently different from upstream
> > that I don't see how to move forward.
> >=20
> > However, I also found that the PBRSB mitigation seems broken, as commit
> > fc02735b14ff "KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS"
> > was not backported (and would be hard to add).
> >=20
> > So, perhaps it would be best to revert the backports of:
> >=20
> > 2b1299322016 x86/speculation: Add RSB VM Exit protections
> > ba6e31af2be9 x86/speculation: Add LFENCE to RSB fill sequence
> >=20
> > in stable branches older than 5.10.
>=20
> Why?  Is it because they do not work at all there, or are they causing
> problems?

- They both add unconditional LFENCE instructions, which are not
implemented on older 32-bit CPUs and will therefore result in a crash.

- The added mitigation, for PBRSB, requires removing any RET
instructions executed between VM exit and the RSB filling.  In these
older branches that hasn't been done, so the mitigation doesn't work.

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-Rn4sVEEkoczKfwEKu1B3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmMXfm0ACgkQ57/I7JWG
EQkgqxAA04fMNcX5jp86ujzgE/21Fzyxxm3BCBivX3yGebMy6xIaUw1BJf3O7rHV
PWcFFsvvDVfzeHSVPlPvOrcI6qi9By7vNTHJp/9lIkVsi4HX+42aKw3CWTmA1GPz
qdHFVKX/hgB4axM0mr/45mGL2Kp0a3S2yAbs7gq4f/47+FCF0+ZKPHr9uufIqgS0
06pHG5A89Xpi7QS8xFaqbjeepkMcSeSyMr9N2dY//uZP1Jb8wFFN/cMjTTcKZ9XG
KCCSPNnhiEX9hcMx0J+rqSuIEp0O8YBQHm1OOmw21Hpym1vBHfUK906k/OJ2PVcM
6i72AyKsc8DJzyvO8ZRefWQdXHJ7ZWDSxErG66vwwmUGqE/NbvZug1548CLEaHRV
vmkLas751qzPZlAS3iMM4FBMf2hVS2vQL76R5lC9elMECHg8KpU62NgM7yk+18gy
/FmM1A/Q+elvw3BcBMDKVQkIAQswpnho07uG/O7T3qdw9cIn+hhVtydmRmOBye0S
oPu1LGHNtLVWqT3WlDGph9xLZyo96pJKw9DxPHRDBh45NYzCRZtSzeWAeHbw62UT
Sjo8uZRtRo1/q2dnUuQQHUO8gY0LAxVRfEdiYEhJgOIcyITLVv2eXz98hOaZ3tMS
Bba/gWkIGtK7Nb8NDZTUvolJ9fzTPSrLHoPNnZ9JVWJbpqwuXcg=
=KKvh
-----END PGP SIGNATURE-----

--=-Rn4sVEEkoczKfwEKu1B3--
