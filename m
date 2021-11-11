Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B151244DABF
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 17:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbhKKQuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 11:50:46 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:44028 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbhKKQuq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 11:50:46 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F16961C0B77; Thu, 11 Nov 2021 17:47:55 +0100 (CET)
Date:   Thu, 11 Nov 2021 17:47:54 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>,
        Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Zubin Mithra <zsm@chromium.org>
Subject: Re: [PATCH 4.19 01/16] block: introduce multi-page bvec helpers
Message-ID: <20211111164754.GA29545@duo.ucw.cz>
References: <20211110182001.994215976@linuxfoundation.org>
 <20211110182002.041203616@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <20211110182002.041203616@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Ming Lei <ming.lei@redhat.com>
>=20
> commit 3d75ca0adef4280650c6690a0c4702a74a6f3c95 upstream.
>=20
> This patch introduces helpers of 'mp_bvec_iter_*' for multi-page bvec
> support.
>=20
> The introduced helpers treate one bvec as real multi-page segment,
> which may include more than one pages.
>=20
> The existed helpers of bvec_iter_* are interfaces for supporting current
> bvec iterator which is thought as single-page by drivers, fs, dm and
> etc. These introduced helpers will build single-page bvec in flight, so
> this way won't break current bio/bvec users, which needn't any
> change.

I don't understand why we have this in 4.19-stable. I don't see
followup patches needing it, and it does not claim to fix a bug.

> +#define mp_bvec_iter_bvec(bvec, iter)				\
> +((struct bio_vec) {						\
> +	.bv_page	=3D mp_bvec_iter_page((bvec), (iter)),	\
> +	.bv_len		=3D mp_bvec_iter_len((bvec), (iter)),	\
> +	.bv_offset	=3D mp_bvec_iter_offset((bvec), (iter)),	\
> +})
> +
> +/* For building single-page bvec in flight */
> + #define bvec_iter_offset(bvec, iter)				\
> +	(mp_bvec_iter_offset((bvec), (iter)) % PAGE_SIZE)
> +

Plus this one is strange. IIRC preprocessor directives have to put #
in column zero?

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYY1JOgAKCRAw5/Bqldv6
8oPrAJ9Src2Q2Dyal2GgwRHc1QluAaxboQCgq0VdB92UlzXrBAEYpR7XQo/4YMg=
=amyN
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
