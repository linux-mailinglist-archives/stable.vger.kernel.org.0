Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB72DCCCB
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 19:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405725AbfJRR2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 13:28:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49566 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727068AbfJRR2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 13:28:48 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 08F5F801BA; Fri, 18 Oct 2019 19:28:28 +0200 (CEST)
Date:   Fri, 18 Oct 2019 19:28:43 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rick Tseng <rtseng@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: Re: [PATCH 4.19 12/81] usb: xhci: wait for CNR controller not ready
 bit in xhci resume
Message-ID: <20191018172843.GA27290@amd>
References: <20191016214805.727399379@linuxfoundation.org>
 <20191016214817.920493885@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20191016214817.920493885@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Rick Tseng <rtseng@nvidia.com>
>=20
> commit a70bcbc322837eda1ab5994d12db941dc9733a7d upstream.
>=20
> NVIDIA 3.1 xHCI card would lose power when moving power state into D3Cold.
> Thus we need to wait for CNR bit to clear in xhci resume, just as in
> xhci init.
=2E..

> @@ -1098,6 +1098,18 @@ int xhci_resume(struct xhci_hcd *xhci, b
>  		hibernated =3D true;
> =20
>  	if (!hibernated) {
> +		/*
> +		 * Some controllers might lose power during suspend, so wait
> +		 * for controller not ready bit to clear, just as in xHC init.
> +		 */
> +		retval =3D xhci_handshake(&xhci->op_regs->status,
> +					STS_CNR, 0, 10 * 1000 * 1000);
> +		if (retval) {
> +			xhci_warn(xhci, "Controller not ready at resume %d\n",
> +				  retval);
> +			spin_unlock_irq(&xhci->lock);
> +			return retval;
> +		}

AFAICT if this error happens, xhci will be unusable. So maybe print
should be at higher level that warning... that's clearly an error.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2p9ksACgkQMOfwapXb+vIROQCfbk2WVtdNEPiz6/BKaDQVHeXV
bw4An1H3wpoXtFpJoeBe1fvi3bGBj06A
=7BhU
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
