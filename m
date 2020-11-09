Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E232AC394
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 19:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbgKISUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 13:20:49 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57406 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729119AbgKISUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 13:20:49 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 925701C0B7A; Mon,  9 Nov 2020 19:20:46 +0100 (CET)
Date:   Mon, 9 Nov 2020 19:20:46 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: Re: [PATCH 4.19 01/71] drm/i915: Break up error capture compression
 loops with cond_resched()
Message-ID: <20201109182046.GA20488@amd>
References: <20201109125019.906191744@linuxfoundation.org>
 <20201109125019.973892170@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <20201109125019.973892170@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 7d5553147613b50149238ac1385c60e5c7cacb34 upstream.
>=20
> As the error capture will compress user buffers as directed to by the
> user, it can take an arbitrary amount of time and space. Break up the
> compression loops with a call to cond_resched(), that will allow other
> processes to schedule (avoiding the soft lockups) and also serve as a
> warning should we try to make this loop atomic in the future.

This was queued for 4.19-stable, but is very likely wrong.

> Testcase: igt/gem_exec_capture/many-*
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20200916090059.3189-2=
-chris@chris-wilson.co.uk
> (cherry picked from commit 293f43c80c0027ff9299036c24218ac705ce584e)
> Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

> @@ -347,6 +349,7 @@ static int compress_page(struct compress
>  	if (!i915_memcpy_from_wc(ptr, src, PAGE_SIZE))
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
take so long to trigger softlockup detectors...=20

Best regards,
                                                                Pavel
							=09
>=20

--=20
http://www.livejournal.com/~pavelmachek

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+piH0ACgkQMOfwapXb+vK89ACgu7Vl6vjbAbNNbvzPx6ppWhBn
USoAn1vS4a68nIaWfU7+oypwqaJLWcbi
=kSD6
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
