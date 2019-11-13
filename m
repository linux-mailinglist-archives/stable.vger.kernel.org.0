Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70FE0FAE5B
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 11:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfKMKT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 05:19:56 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:44722 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfKMKT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 05:19:56 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 06E5C1C1229; Wed, 13 Nov 2019 11:19:54 +0100 (CET)
Date:   Wed, 13 Nov 2019 11:19:54 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 4.19 062/125] ALSA: usb-audio: Fix possible NULL
 dereference at create_yamaha_midi_quirk()
Message-ID: <20191113101954.GA32553@amd>
References: <20191111181438.945353076@linuxfoundation.org>
 <20191111181448.565879068@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20191111181448.565879068@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Takashi Iwai <tiwai@suse.de>
>=20
> commit 60849562a5db4a1eee2160167e4dce4590d3eafe upstream.
>=20
> The previous addition of descriptor validation may lead to a NULL
> dereference at create_yamaha_midi_quirk() when either injd or outjd is
> NULL.  Add proper non-NULL checks.

This is wrong.

> @@ -259,8 +259,8 @@ static int create_yamaha_midi_quirk(stru
>  					NULL, USB_MS_MIDI_OUT_JACK);
>  	if (!injd && !outjd)
>  		return -ENODEV;

Clearly code wants to allow at most one of them to be NULL.

> -	if (!snd_usb_validate_midi_desc(injd) ||
> -	    !snd_usb_validate_midi_desc(outjd))
> +	if (!(injd && snd_usb_validate_midi_desc(injd)) ||
> +	    !(outjd && snd_usb_validate_midi_desc(outjd)))
>  		return -ENODEV;

Yet it will return here if it is. Correct check would be

+     if (!(!injd || snd_usb_validate_midi_desc(injd)) ||
+         !(!outjd || snd_usb_validate_midi_desc(outjd)))

AFAICT.

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3L2MoACgkQMOfwapXb+vKkvwCfQwemC8SZ0emRIQydohEHDrpA
oQwAn1dEXHbybsKKrhheQUqGeQG0zE90
=bi0F
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
