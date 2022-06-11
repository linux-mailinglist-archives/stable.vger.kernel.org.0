Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA4954712A
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 03:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236391AbiFKBm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 21:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbiFKBm6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 21:42:58 -0400
Received: from bluehome.net (bluehome.net [96.66.250.149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BD84388E1
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 18:42:57 -0700 (PDT)
Received: from valencia (valencia.lan [10.0.0.17])
        by bluehome.net (Postfix) with ESMTPSA id AD6534B40507
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 18:42:56 -0700 (PDT)
Date:   Fri, 10 Jun 2022 18:42:55 -0700
From:   Jason Self <jason@bluehome.net>
To:     stable@vger.kernel.org
Subject: Re: Build error on openrisc with CONFIG_CRYPTO_LIB_CURVE25519
Message-ID: <20220610184255.20ecde41@valencia>
In-Reply-To: <20220610182523.2f5620a2@valencia>
References: <20220609162943.6e3bba4f@valencia>
        <YqLTecx7MGFPOvhw@kroah.com>
        <20220610182523.2f5620a2@valencia>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//yxBD+26kMviKYogqTPtiiY";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Sig_//yxBD+26kMviKYogqTPtiiY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Jun 2022 18:25:23 -0700
Jason Self <jason@bluehome.net> wrote:

> On Fri, 10 Jun 2022 07:15:37 +0200
> Greg KH <greg@kroah.com> wrote:
>=20
> > On Thu, Jun 09, 2022 at 04:29:43PM -0700, Jason Self wrote: =20
> > > In building 5.15.46 & 5.10.121 with CRYPTO_LIB_CURVE25519=3Dm I
> > > get the following. My workaround is to leave it as
> > > CRYPTO_LIB_CURVE25519=3Dn for now.
> > >=20
> > > CONFIG_OR1K_1200=3Dy
> > > CONFIG_OPENRISC_BUILTIN_DTB=3D"or1ksim"
> > >=20
> > >   sed 's/\.ko$/\.o/' modules.order | scripts/mod/modpost    -o
> > >   modules-only.symvers -i vmlinux.symvers   -T - ERROR: modpost:
> > >   "__crypto_memneq" [lib/crypto/libcurve25519.ko] undefined!
> > > make[1]: *** [scripts/Makefile.modpost:134:
> > > modules-only.symvers] Error 1 make[1]: *** Deleting file
> > > 'modules-only.symvers' make: *** [Makefile:1783: modules] Error
> > > 2   =20
> >=20
> >=20
> > Is this a new problem, or has it always been there for these
> > kernel trees? =20
>=20
> It's new; it began in 5.15.45 & 5.10.120, which is when make
> oldconfig first prompted about CONFIG_CRYPTO_LIB_CURVE25519.

The result of my git bisect between 5.15.44 and 5.15.45 tell me the
following. It's the same "lib/crypto: add prompts back to crypto
libraries" commit when I bisect between 5.10.119 and 5.10.120.


e16cc79b0f916069de223bdb567fa0bc2ccd18a5 is the first bad commit
commit e16cc79b0f916069de223bdb567fa0bc2ccd18a5
Author: Justin M. Forbes <jforbes@fedoraproject.org>
Date:   Thu Jun 2 22:23:23 2022 +0200

    lib/crypto: add prompts back to crypto libraries
   =20
    commit e56e18985596617ae426ed5997fb2e737cffb58b upstream.
   =20
    Commit 6048fdcc5f269 ("lib/crypto: blake2s: include as built-in")
    took away a number of prompt texts from other crypto libraries.
    This makes values flip from built-in to module when oldconfig
    runs, and causes problems when these crypto libs need to be built
    in for thingslike BIG_KEYS.
   =20
    Fixes: 6048fdcc5f269 ("lib/crypto: blake2s: include as built-in")
    Cc: Herbert Xu <herbert@gondor.apana.org.au>
    Cc: linux-crypto@vger.kernel.org
    Signed-off-by: Justin M. Forbes <jforbes@fedoraproject.org>
    [Jason: - moved menu into submenu of lib/ instead of root menu
            - fixed chacha sub-dependencies for CONFIG_CRYPTO]
    Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

 crypto/Kconfig     |  2 --
 lib/Kconfig        |  2 ++
 lib/crypto/Kconfig | 17 ++++++++++++-----
 3 files changed, 14 insertions(+), 7 deletions(-)
bisect run success



--Sig_//yxBD+26kMviKYogqTPtiiY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE9hGpCP+hZcaZWE7UnQ2zG1RaMZgFAmKj8x8ACgkQnQ2zG1Ra
MZgPXA/+Ph6CYrZ0dzxIbGcXWMsVaaMUdl3CIzo3OktwsqX8RWsLTPnEVRjuJBdj
fZWpc9iu3gltOeCLYyh5WPDaUf2FZXFn6uq9OZ/KBUN6IlTHhqZ9n2+3La/5T1H7
Kch+JWUelwQSrJftK6gRbCum792wQ4uW+XJDMeuGD2dKVBV5CHgUzYy7ZP9Bvx1e
0d4bVf3L6EpJlffwkv70oBAjZcVbo4uSd1Sa/T9YC+4Ujhmqr+SWVO2C8ZNj0Owo
bjq2TkBQnUmHm4gALYtRaWZqfx0wPytwSy1PezG471J117It/lG8ziwQpRxmN0dI
sKCEHjeda7wXA+Lcecivh1n3pV0ffzZtRPpmQuJz4LJCMIUA/5BLXYT8/Pu3TE7d
k5pVxVARUXzu7p1zBCTXJywQRsCIvcwZ1QCybVQ36SxTLUmTSOKQw1uIxq7EmJvj
4E7A6L21QLfxxqeHHNM8hgU8GGFd5PIXnNa1R4XHtnvHWX5A+j8qEd9ZZ1Vl9kQo
LLuKeLksEX0tOpJK7cQ6f0gEbc9beKRD8j9xtqKZEo1Roo0rr0mydGnurAbzjF6U
nR39CbCrhozwrG6wO8LHForbm7S9FQke5J9AZJ+vhHYiZZ3lRW96nS0YvXkP4CHp
J2Ht24Tr756bfv1x2LOEA3qcC3+bG9ua0CpfzHt2Ja2fTeHIgTU=
=pOpz
-----END PGP SIGNATURE-----

--Sig_//yxBD+26kMviKYogqTPtiiY--
