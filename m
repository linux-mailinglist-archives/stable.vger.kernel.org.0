Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C401B1C557A
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 14:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgEEMcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 08:32:02 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:44628 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbgEEMcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 08:32:01 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 96A681C0225; Tue,  5 May 2020 14:31:59 +0200 (CEST)
Date:   Tue, 5 May 2020 14:31:59 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 4.19 28/37] dmaengine: dmatest: Fix iteration non-stop
 logic
Message-ID: <20200505123159.GC28722@amd>
References: <20200504165448.264746645@linuxfoundation.org>
 <20200504165451.307643203@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline
In-Reply-To: <20200504165451.307643203@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> So, to the point, the conditional of checking the thread to be stopped be=
ing
> first part of conjunction logic prevents to check iterations. Thus, we ha=
ve to
> always check both conditions to be able to stop after given
> iterations.

I ... don't understand. AFAICT the code is equivalent. Both && and ||
operators permit "short" execution... but second part of expression
has no sideeffects, so...

> @@ -567,8 +567,8 @@ static int dmatest_func(void *data)
>  	flags =3D DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
> =20
>  	ktime =3D ktime_get();
> -	while (!kthread_should_stop()
> -	       && !(params->iterations && total_tests >=3D params->iterations))=
 {
> +	while (!(kthread_should_stop() ||
> +	       (params->iterations && total_tests >=3D params->iterations))) {
>  		struct dma_async_tx_descriptor *tx =3D NULL;
>  		struct dmaengine_unmap_data *um;
>  		dma_addr_t *dsts;

let a =3D kthread_should_stop()
let b =3D (params->iterations && total_tests >=3D params->iterations)

You are changing !a & !b into !(a | b). But that's equivalent
expression. I hate to admit, but I had to draw truth table to prove
that.

!a & !b   0 0 -> 1
       	  else -> 0

!(a | b)  0 0 -> 1
     	   else -> 0
	  =20
What am I missing?

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl6xXL4ACgkQMOfwapXb+vJIvQCgwg/672KLMZ1Cjt4fjfpDJNIl
u4YAoIuFw3pH/JnK7hMHG1ueLt3qm8V0
=w4yg
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
