Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 589651819BA
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 14:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729625AbgCKN2r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 09:28:47 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54330 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729103AbgCKN2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 09:28:47 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B0E221C0317; Wed, 11 Mar 2020 14:28:45 +0100 (CET)
Date:   Wed, 11 Mar 2020 14:28:45 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4.19 84/86] efi/x86: Handle by-ref arguments covering
 multiple pages in mixed mode
Message-ID: <20200311132845.GA24349@duo.ucw.cz>
References: <20200310124530.808338541@linuxfoundation.org>
 <20200310124535.409134291@linuxfoundation.org>
 <20200311130106.GB7285@duo.ucw.cz>
 <20200311131311.GA3858095@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <20200311131311.GA3858095@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2020-03-11 14:13:11, Greg Kroah-Hartman wrote:
> On Wed, Mar 11, 2020 at 02:01:07PM +0100, Pavel Machek wrote:
> > Hi!
> >=20
> > > Currently, the mixed mode runtime service wrappers require that all b=
y-ref
> > > arguments that live in the vmalloc space have a size that is a power =
of 2,
> > > and are aligned to that same value. While this is a sensible way to
> > > construct an object that is guaranteed not to cross a page boundary, =
it is
> > > overly strict when it comes to checking whether a given object violat=
es
> > > this requirement, as we can simply take the physical address of the f=
irst
> > > and the last byte, and verify that they point into the same physical
> > > page.
> >=20
> > Dunno. If start passing buffers that _sometime_ cross page boundaries,
> > we'll get hard to debug failures. Maybe original code is better
> > buecause it catches problems earlier?
> >=20
> > Furthermore, all existing code should pass aligned, 2^n size buffers,
> > so we should not need this in stable?
>=20
> For some crazy reason you cut out the reason I applied this patch to the
> stable tree.  From the changelog text:
> 	Fixes: f6697df36bdf0bf7 ("x86/efi: Prevent mixed mode boot
>corruption with CONFIG_VMAP_STACK=3Dy")

I did not notice that, but reviewing f669 does not really help. If
there is some known code that passes unaligned (but guaranteed
not-to-cross-page) buffers here, then yes, but is it? Having
not-page-crossing guarantees is kind of hard without alignment.

People seem to be adding Fixes: tags even if it is not a bugfix, just
as reminder that this has relation to some other commit...

Best regards,
								Pavel


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXmjnjQAKCRAw5/Bqldv6
8r46AJ95Ffup+ry6cLgiiN4zf3R8RLhDEwCglGrn3tZRdjRr2iUn+Xfck7egT7w=
=tMOY
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
