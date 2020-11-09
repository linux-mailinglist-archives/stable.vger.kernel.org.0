Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845F72AB4C5
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgKIKYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:24:42 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39050 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgKIKYm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 05:24:42 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 25B7E1C0B88; Mon,  9 Nov 2020 11:24:39 +0100 (CET)
Date:   Mon, 9 Nov 2020 11:24:37 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Chris Wilson <chris@chris-wilson.co.uk>,
        kernel list <linux-kernel@vger.kernel.org>
Cc:     intel-gfx@lists.freedesktop.org,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        stable@vger.kernel.org
Subject: 4.19-stable: Re: [PATCH 2/3] drm/i915: Break up error capture
 compression loops with cond_resched()
Message-ID: <20201109102437.GA15835@amd>
References: <20200916090059.3189-1-chris@chris-wilson.co.uk>
 <20200916090059.3189-2-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20200916090059.3189-2-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> As the error capture will compress user buffers as directed to by the
> user, it can take an arbitrary amount of time and space. Break up the
> compression loops with a call to cond_resched(), that will allow other
> processes to schedule (avoiding the soft lockups) and also serve as a
> warning should we try to make this loop atomic in the future.
>=20
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>

This was queued for 4.19-stable, but is very likely wrong.

> @@ -397,6 +399,7 @@ static int compress_page(struct i915_vma_compress *c,
>  	if (!(wc && i915_memcpy_from_wc(ptr, src, PAGE_SIZE)))
>  		memcpy(ptr, src, PAGE_SIZE);
>  	dst->pages[dst->page_count++] =3D ptr;
> +	cond_resched();
> =20
>  	return 0;
>  }

4.19 compress_page begins with

static int compress_page(struct compress *c,
=2E..
        page =3D __get_free_page(GFP_ATOMIC | __GFP_NOWARN);

and likely may not sleep. That changed with commit
a42f45a2a85998453078, but that one is not present in 4.19..

I believe we don't need this in stable: dumping of error file will not
take so long to trigger softlockup detectors... and if userland access
blocked, we would be able to reschedule, anyway.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+pGOUACgkQMOfwapXb+vIvQgCcDwo9ICEQfTFKE7D+KQj2Ngzp
v9sAnjFdQRjvjH8ijc41QciyP5sDpOWb
=rh9u
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
