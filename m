Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEC0A3B3799
	for <lists+stable@lfdr.de>; Thu, 24 Jun 2021 22:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbhFXUMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Jun 2021 16:12:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:46744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232120AbhFXUMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 24 Jun 2021 16:12:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0FF9613B3;
        Thu, 24 Jun 2021 20:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624565421;
        bh=OCHElhvYoD6BDgY07IFd/eaIraH+0hiQu/h81hEMkgk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VNcrw/Oaprf5kSwI+DjcJCH39mU1U/xHDvIyVt7APT4IrFAN1t7S6SHazqetWg3FW
         J0Tn/3G44nIEGY+OO68enuTfjTOruDR/OSHK0IFar1z4Saabh4K59xmxM4lrM4fgek
         EwhRaLhPmUB9f5GxCuvuT8wkI69I5DYau2cfD/gvccu43qq9EmeERaWV3KE+JuU2jU
         H008pCNb+nCha3lhCr0gNFSrchH/P4btZSgBovZAw8knnZLR/bzCS5VuhPKGj7iUuo
         ktQZ8wcmFt4saq1wO/7i4sFVmyhu+WEj7v01VKAFY323MBItrA5avao+0bKfEs6cOY
         gpcVCCqprKN3w==
Date:   Thu, 24 Jun 2021 22:10:17 +0200
From:   Wolfram Sang <wsa@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-i2c@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] i2c: robotfuzz-osif: fix control-request directions
Message-ID: <YNTmqcrYb9KzW8Zh@kunai>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Johan Hovold <johan@kernel.org>, linux-i2c@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
References: <20210524090912.3989-1-johan@kernel.org>
 <YNL2NLSpBQqnc2bH@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="MKR9idyquUPZmLcd"
Content-Disposition: inline
In-Reply-To: <YNL2NLSpBQqnc2bH@hovoldconsulting.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MKR9idyquUPZmLcd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 23, 2021 at 10:52:04AM +0200, Johan Hovold wrote:
> On Mon, May 24, 2021 at 11:09:12AM +0200, Johan Hovold wrote:
> > The direction of the pipe argument must match the request-type direction
> > bit or control requests may fail depending on the host-controller-driver
> > implementation.
> >=20
> > Control transfers without a data stage are treated as OUT requests by
> > the USB stack and should be using usb_sndctrlpipe(). Failing to do so
> > will now trigger a warning.
> >=20
> > Fix the OSIFI2C_SET_BIT_RATE and OSIFI2C_STOP requests which erroneously
> > used the osif_usb_read() helper and set the IN direction bit.
> >=20
> > Reported-by: syzbot+9d7dadd15b8819d73f41@syzkaller.appspotmail.com
> > Fixes: 83e53a8f120f ("i2c: Add bus driver for for OSIF USB i2c device.")
> > Cc: stable@vger.kernel.org      # 3.14
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Johan Hovold <johan@kernel.org>
> > ---
>=20
> Wolfram, can you pick this one up for 5.14?

Sorry, I thought Andrew was the maintainer of this driver and was
waiting for his ack. But he is not, this driver is unmaintained. So, I
trust you and picked it up now.

Applied to for-current, thanks!


--MKR9idyquUPZmLcd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmDU5qgACgkQFA3kzBSg
KbZA9BAAlhZEQnPgQHEocCgFHoL1zsrDnKA9gZn+wDnz7rH0OwCm0/lIWwB8+qxb
UyFLr+8weobCh+gN84wlMf2CFa7gGJd+rbZotd6UE33SyCehMkO1HRiZ452W3uLn
f64KzEkj3IR3HQ8LjijdssCveh+B0IbP6ggtQ6d6GPUbVXDINk2xdyAH+NlOr01L
ga2oPVSH8iOGsG2BLRE84e69jVzdJ3RikE9F6SalellJLfbAurOShwpuwW2is4ym
2bIDvdX/LFj4vlT68LVY54KBpmpXMv3/tunFMPKvJkntsURLSGZJ+6XHbwOMAixT
6bfyE+RDSxxKp0Z3cRvsR7BQlL618Yze34SDHTCpmcvZOHAR2o9nEr9Xf/5dc5+B
msh/2gY2H71+1aTE0o/bqzs9Igqih641uboiCYiVu+CLZ/QHij1GtfAkROV0N2Uu
wnw42od3gc3+BhTtnbqQi4epzA9RMsLtQ3dMzWoEahIQYS23w8yqUo+IjVRiFWNE
rNlxA5qyA/VHFBjBVAVNNC+lleAhVBC2xr/r1PqQGn0n66neakAyf73EOS0SfXER
fmdR1/qnLfEoa+wCOVha7SwOHYbxG7tXVJw5mwjOdaNflGIc96tOdx0WdLfMJ4eE
dnweudbMJ6MOaG60+2Qx/rCVeQdqTPSQKvN5ES3MBRwYRdvZlCo=
=Tg0E
-----END PGP SIGNATURE-----

--MKR9idyquUPZmLcd--
