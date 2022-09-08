Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2925B1D84
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 14:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiIHMpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 08:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiIHMor (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 08:44:47 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1892716A
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 05:44:41 -0700 (PDT)
Received: from 213.219.160.184.adsl.dyn.edpnet.net ([213.219.160.184] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1oWGtZ-0000iy-Uv; Thu, 08 Sep 2022 14:44:37 +0200
Received: from ben by deadeye with local (Exim 4.96)
        (envelope-from <ben@decadent.org.uk>)
        id 1oWGtZ-000XaC-18;
        Thu, 08 Sep 2022 14:44:37 +0200
Message-ID: <61fd8fab49c19340656b2b5fbad5bc1e9f73d955.camel@decadent.org.uk>
Subject: Re: FAILED: patch "[PATCH] x86/nospec: Fix i386 RSB stuffing"
 failed to apply to 5.10-stable tree
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, peterz@infradead.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Date:   Thu, 08 Sep 2022 14:44:33 +0200
In-Reply-To: <20220908060949.dcybz74j3wm7pzrg@desk>
References: <166176181110563@kroah.com>
         <3e14d81d0576aed9583d07fbd14e6a502f2d4739.camel@decadent.org.uk>
         <YxB+xgcz9QD5BK77@kroah.com>
         <ff8d3521a32e1a425af32711856d0d8fdfa84d2b.camel@decadent.org.uk>
         <Yxc4CeyDS2tWLXfo@kroah.com>
         <3fb3cc8cb6bfab9dc52e351c56a31c233051c9b0.camel@decadent.org.uk>
         <20220906212010.rfvxzkt25nwakfad@desk>
         <4c8251e607ad3248bf6309069a3d7c577c4da7a5.camel@decadent.org.uk>
         <20220908060949.dcybz74j3wm7pzrg@desk>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-Uqd5LwnZa2vWjzDMBq7q"
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


--=-Uqd5LwnZa2vWjzDMBq7q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-09-07 at 23:09 -0700, Pawan Gupta wrote:
> On Wed, Sep 07, 2022 at 02:23:58AM +0200, Ben Hutchings wrote:
> > > > - The added mitigation, for PBRSB, requires removing any RET
> > > > instructions executed between VM exit and the RSB filling.  In thes=
e
> > > > older branches that hasn't been done, so the mitigation doesn't wor=
k.
> > >=20
> > > I checked 4.19 and 5.4, I don't see any RET between VM-exit and RSB
> > > filling. Could you please point me to any specific instance you are
> > > seeing?
> >=20
> > Yes, you're right.  The backported versions avoid this problem.  They
> > are quite different from the upstream commit - and I would have
> > appreciated some explanation of this in their commit messages.
>=20
> Ahh right, I will keep in mind next time.
>=20
> > So, let's try again to move forward.  I've attached a backport for 4.19
> > and 5.4 (only tested with the latter so far).
>=20
> I am not understanding why lfence in single-entry-fill sequence is okay
> on 32-bit kernels?
>=20
> #define __FILL_ONE_RETURN                               \
>         __FILL_RETURN_SLOT                              \
>         add     $(BITS_PER_LONG/8), %_ASM_SP;           \
>         lfence;

This isn't exactly about whether the kernel is 32-bit vs 64-bit, it's
about whether the code may run on a processor that lacks support for
LFENCE (part of SSE2).

- SSE2 is architectural on x86_64, so 64-bit kernels can use LFENCE
unconditionally.
- PBRSB doesn't affect any of those old processors, so its mitigation
can use LFENCE unconditionally.  (Those procesors don't support VMX
either.)

Ben.

--=20
Ben Hutchings
For every action, there is an equal and opposite criticism. - Harrison

--=-Uqd5LwnZa2vWjzDMBq7q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmMZ47EACgkQ57/I7JWG
EQkjfBAAq1jDQyHAtNWORvoDxY0KGQ/61tl0SlfhHfmiLhoLi+LlyDb9U6W2qhhd
OblU5blmM8g++Z01A0XQ239s19kWY4nslHdpaeyGIDK/a4Dr0+BIb8irDUC97rii
5liX8HmaUgoaFa/TIYFBYA1LjvKhLJXW6iL3iWxhlfyOCsISkJy30yuVWlzIVSg2
aVrnMzhZB3fN4IaX/i1PlLgw7POkhvO5Xp+Y0FjVZ6dr3+1zdza5uBYrBcQvLenq
Awa+bBjL88g1Jl8UJQJlfgv5wKXMVMuqLLmmDf36f+otxasusB3lFk76uFf+X3Po
6Md3xb4sKK8wufrYz1vS75TI1MfieVnZRv3n0zgRbEruJ2boa8gJhJEsN0dWgTUx
yhth8la4qOIJyH64PNgmqd9N+KYj+3+ATawOig8fwbUmRhZhB46cJHYopHeFBnoA
DVa88nuXGS5vzv2MSdKbODIq4LgYpJMf7XqPwxFfC8A34GS+WTiqry5LBEFsxXve
vyr9TKMVqY96HWbJeJtePlpRsPHSF69X8BHwzxxH4RiyUM4PNphQagXG84Xt0qfs
epHmVK2uqkGky/sD2HNabW3smHqfakCiVtEIcrlod/AeoQYTP8s4Unx6VfEs5UxW
RFIcLK6i4TauBORWrOJxl+nYM4XdxCm3qvnzzOlbtbtoZlu02s8=
=LXj+
-----END PGP SIGNATURE-----

--=-Uqd5LwnZa2vWjzDMBq7q--
