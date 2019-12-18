Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA1BA1245DD
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 12:35:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfLRLfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 06:35:02 -0500
Received: from foss.arm.com ([217.140.110.172]:42990 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbfLRLfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 06:35:01 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EC51E30E;
        Wed, 18 Dec 2019 03:35:00 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A8303F6CF;
        Wed, 18 Dec 2019 03:35:00 -0800 (PST)
Date:   Wed, 18 Dec 2019 11:34:58 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Siddharth Kapoor <ksiddharth@google.com>
Cc:     lee.jones@linaro.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: Kernel panic on Google Pixel devices due to regulator patch
Message-ID: <20191218113458.GA3219@sirena.org.uk>
References: <CAJRo92+eD9F6Q60yVY2PfwaPWO_8Dts8QwH7mhpJaem7SpLihg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
In-Reply-To: <CAJRo92+eD9F6Q60yVY2PfwaPWO_8Dts8QwH7mhpJaem7SpLihg@mail.gmail.com>
X-Cookie: Power is poison.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2019 at 11:51:55PM +0800, Siddharth Kapoor wrote:

> I would like to share a concern with the regulator patch which is part of
> 4.9.196 LTS kernel.

That's an *extremely* old kernel.

> https://lore.kernel.org/lkml/20190904124250.25844-1-broonie@kernel.org/

That's the patch "[PATCH] regulator: Defer init completion for a while
after late_initcall" which defers disabling of idle regulators for a
while.

Please include human readable descriptions of things like commits and
issues being discussed in e-mail in your mails, this makes them much
easier for humans to read especially when they have no internet access.
I do frequently catch up on my mail on flights or while otherwise
travelling so this is even more pressing for me than just being about
making things a bit easier to read.

> We have reverted the patch in Pixel kernels and would like you to look in=
to
> this and consider reverting it upstream as well.

I've got nothing to do with the stable kernels so there's nothing I can
do here, sorry.  However if this is triggering anything it's almost
certainly some kind of timing issue (this code isn't new, it's just
being run a bit later) and is only currently working through luck so I
do strongly recommend trying to figure out the actual problem since it's
liable to come back and bite you later - we did find one buggy driver in
mainline as a result of this change, it's possible you've got another
one. =20

Possibly your GPU supplies need to be flagged as always on, possibly
your GPU driver is forgetting to enable some supplies it needs, or
possibly there's a missing always-on constraint on one of the regulators
depending on how the driver expects this to work (if it's a proprietary
driver it shouldn't be using the regulator API itself).  I'm quite
surprised you've not seen any issue before given that the supplies would
still be being disabled earlier.

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl36DrsACgkQJNaLcl1U
h9AGKwf+OZSKCw53a+rwTPUrG52C/vtaOOk0D2VRDUbWhPCqqWaxRi0gm9l48XLR
pksY4mNcf858gPLUA7CoOrOjia2b/HlSNyourAGO0D1fhUNz6Eaw35fIvAkbeoXn
W6OiNHTWypmt6UN1pLP5g46eLZV8VTfYRnHkJiqCVsskrNo4Fk9uPlaZlfRwi/Sd
DwMoQ4Ai2mMDvJcAWu4btXt9rU54FKDltJOrzFoN6U5DR00nbQw3yD1+ZozX6lFk
wxXSGNGvqvEcPSi+Ub6x6j6VHEQFJXPQ3Gdm5QN29Pbh7WMd5Cx7QhfIwanHB1Iy
p4w5Cvux9SobwfkelqtedR2a3ZVtNw==
=dvpQ
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
