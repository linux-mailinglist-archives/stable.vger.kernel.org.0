Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A231B7928
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 17:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgDXPNf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 11:13:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56088 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726908AbgDXPNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 11:13:35 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jS01F-0008Gr-Is; Fri, 24 Apr 2020 16:13:33 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jS01F-00F5UL-4p; Fri, 24 Apr 2020 16:13:33 +0100
Message-ID: <8783c94cb802ade8a45cdf4233fe3b7341cca5c9.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 208/245] namei: allow restricted O_CREAT of FIFOs
 and regular files
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Solar Designer <solar@openwall.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Salvatore Mesoraca <s.mesoraca16@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Apr 2020 16:13:22 +0100
In-Reply-To: <20200424135205.GA27204@openwall.com>
References: <lsq.1587683027.831233700@decadent.org.uk>
         <lsq.1587683028.722200761@decadent.org.uk>
         <20200424135205.GA27204@openwall.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-G7TFAlgBTbsPFt4nkwf+"
User-Agent: Evolution 3.36.1-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-G7TFAlgBTbsPFt4nkwf+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-04-24 at 15:52 +0200, Solar Designer wrote:
> On Fri, Apr 24, 2020 at 12:07:15AM +0100, Ben Hutchings wrote:
> > 3.16.83-rc1 review patch.  If anyone has any objections, please let me =
know.
>=20
> I do.  This patch is currently known-buggy, see this thread:
>=20
> https://www.openwall.com/lists/oss-security/2020/01/28/2
>=20
> It is (partially) fixed with these newer commits in 5.5 and 5.5.2:
>=20
> commit d0cb50185ae942b03c4327be322055d622dc79f6
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sun Jan 26 09:29:34 2020 -0500
>=20
>     do_last(): fetch directory ->i_mode and ->i_uid before it's too late
>    =20
>     may_create_in_sticky() call is done when we already have dropped the
>     reference to dir.
>    =20
>     Fixes: 30aba6656f61e (namei: allow restricted O_CREAT of FIFOs and re=
gular files)
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>=20
> commit d76341d93dedbcf6ed5a08dfc8bce82d3e9a772b
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Sat Feb 1 16:26:45 2020 +0000
>=20
>     vfs: fix do_last() regression
>    =20
>     commit 6404674acd596de41fd3ad5f267b4525494a891a upstream.
[...]
> At least inclusion of the above fixes is mandatory for any backports.

I know, and those are the next 2 patches in the series.

> Also, I think no one has fixed the logic of may_create_in_sticky() so
> that it wouldn't unintentionally apply the "protection" when the file
> is neither a FIFO nor a regular file (something I found and mentioned in
> the oss-security posting above).
[...]
> I think the implementation of may_create_in_sticky() should be rewritten
> such that it'd directly correspond to the textual description in the
> comment above.  As we've seen, trying to write the code "more optimally"
> resulted in its logic actually being different from the description.
>=20
> Meanwhile, I think backporting known-so-buggy code is a bad idea.

I can see that it's not quite right, but does it matter in practice?=20
Directories and symlinks are handled separately; sockets can't be
opened anyway; block and character devices wonn't normally appear in a
sticky directory.

Ben.

--=20
Ben Hutchings
Knowledge is power.  France is bacon.



--=-G7TFAlgBTbsPFt4nkwf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl6jAhIACgkQ57/I7JWG
EQlUpA/9Er5XJcG/bsXQ/WFew/O336Cp3duv3JdZcKLGCHo+v2TVueTvCkG9mhgC
rXDQsVOhHhByqU3jAB39MFCXvnigImZGi7IpEdLRpdJGYSsfRqPOLR6dsyGRoDYp
wxCGA3UQHnyLfvwVoS/jY83p31vgBbGgj4t7He2e7/Mrx7CkL3qdjoGzu9Xl6O+3
GvOm4rnkfMbTkKImdzJ6hhh5v4AuMqobfbp8P2xlsv3hwy56tNslhrdVNAH1WbDy
tog2jQdWPg24RXTiv1EaYxw6bKCivIK07m/RgqZH/znVk9FUBsUKtfb9Kq4Z5UO7
EyIpgwvOpLA8ctZr0RPL7mlMdiSz8QcHLMBawq0G60OVxIuBMfmGfuTVeBuZs9F2
FxbPN44ULZMra9vbgGvexKnfWAsgpzab7G+95K9cs+vomudPO25soCO8yo9JjdZt
llH71ClBc2/kOXJnr5O1hQQ0deo9OdlxxIODeN0S7mbwNxEAMZwe8TJ3gBU9ZMC0
a9pizROPYj846HlEZ8OKuVsnvNiVyf4MdsaYJ7DjkW81nOWyi0fYqRBj5ol2Nqkb
eGmgqZtatjkwlLX7L/zImm774E/UOOmcHZIpC3O+wp/zgvwiDhhnKpeBW74VdZS7
9hAww3ZS/1p4P3NQ8l657fu5N/uOGb+ux8ulB1U1HI19oHHNS4I=
=xc5f
-----END PGP SIGNATURE-----

--=-G7TFAlgBTbsPFt4nkwf+--
