Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9C025FC8
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 10:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbfEVIuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 04:50:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41991 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728501AbfEVIt7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 04:49:59 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id EAC9D80375; Wed, 22 May 2019 10:49:46 +0200 (CEST)
Date:   Wed, 22 May 2019 10:49:56 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4.19 046/105] crypto: ccree - dont map MAC key on stack
Message-ID: <20190522084956.GA8174@amd>
References: <20190520115247.060821231@linuxfoundation.org>
 <20190520115250.198221588@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20190520115250.198221588@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The MAC hash key might be passed to us on stack. Copy it to
> a slab buffer before mapping to gurantee proper DMA mapping.
>=20
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Cc: stable@vger.kernel.org # v4.19+
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  drivers/crypto/ccree/cc_hash.c |   24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
>=20
> --- a/drivers/crypto/ccree/cc_hash.c
> +++ b/drivers/crypto/ccree/cc_hash.c
> @@ -64,6 +64,7 @@ struct cc_hash_alg {
>  struct hash_key_req_ctx {
>  	u32 keylen;
>  	dma_addr_t key_dma_addr;
> +	u8 *key;
>  };
> =20
>  /* hash per-session context */

AFAICT, key is used just as a local variable in cc_hash_setkey() and
cc_xcbc_setkey() functions. Could we make it local variable to save a
bit of memory (and make code less confusing)?

Thanks,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzlDTQACgkQMOfwapXb+vIQ0QCcDSSdcT4Tv7b1+R4FFx0y7il2
IVsAnis8HV7aeF0xFoyRUiImbljnMOKD
=UK2z
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
