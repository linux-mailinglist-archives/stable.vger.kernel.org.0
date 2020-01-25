Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2E41495EE
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 14:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725821AbgAYNaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 08:30:39 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:48662 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYNaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 08:30:39 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 3EF881C25F4; Sat, 25 Jan 2020 14:30:37 +0100 (CET)
Date:   Sat, 25 Jan 2020 14:30:36 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 177/639] rtc: ds1307: rx8130: Fix alarm handling
Message-ID: <20200125133036.GD14064@duo.ucw.cz>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093109.349854130@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sgneBHv3152wZ8jf"
Content-Disposition: inline
In-Reply-To: <20200124093109.349854130@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sgneBHv3152wZ8jf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> When the EXTENSION.WADA bit is set, register 0x19 contains a bitmap of
> week days, not a day of month. As Linux only handles a single alarm
> without repetition using day of month is more flexible, so clear this
> bit. (Otherwise a value depending on time.tm_wday would have to be
> written to register 0x19.)

So the comment explains why WADA bit needs to be clear.

> @@ -749,8 +749,8 @@ static int rx8130_set_alarm(struct device *dev, struc=
t rtc_wkalrm *t)
>  	if (ret < 0)
>  		return ret;
> =20
> -	ctl[0] &=3D ~RX8130_REG_EXTENSION_WADA;
> +	ctl[0] &=3D RX8130_REG_EXTENSION_WADA;

But then code is changed to preserve WADA bit while it was clearing it
before.

What is going on here?

Given WADA bit is already clear, is it -stable material?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--sgneBHv3152wZ8jf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXixC/AAKCRAw5/Bqldv6
8j5ZAKCoLBAKcnonc5k5CQeMZfSUgRMOtACfRADMVoC2UqdvBXpFyVPT9TXuvSM=
=vnLk
-----END PGP SIGNATURE-----

--sgneBHv3152wZ8jf--
