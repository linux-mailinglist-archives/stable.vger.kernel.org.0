Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0C4FAEC9
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 11:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfKMKr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Nov 2019 05:47:26 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:50828 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbfKMKr0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Nov 2019 05:47:26 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A1F421C122C; Wed, 13 Nov 2019 11:47:24 +0100 (CET)
Date:   Wed, 13 Nov 2019 11:47:24 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 4.19 027/125] HID: wacom: generic: Treat serial number
 and related fields as unsigned
Message-ID: <20191113104724.GD32553@amd>
References: <20191111181438.945353076@linuxfoundation.org>
 <20191111181444.186103315@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bajzpZikUji1w+G9"
Content-Disposition: inline
In-Reply-To: <20191111181444.186103315@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bajzpZikUji1w+G9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Jason Gerecke <killertofu@gmail.com>
>=20
> commit ff479731c3859609530416a18ddb3db5db019b66 upstream.
>=20
> The HID descriptors for most Wacom devices oddly declare the serial
> number and other related fields as signed integers. When these numbers
> are ingested by the HID subsystem, they are automatically sign-extended
> into 32-bit integers. We treat the fields as unsigned elsewhere in the
> kernel and userspace, however, so this sign-extension causes problems.
> In particular, the sign-extended tool ID sent to userspace as ABS_MISC
> does not properly match unsigned IDs used by xf86-input-wacom and libwaco=
m.
>=20
> We introduce a function 'wacom_s32tou' that can undo the automatic sign
> extension performed by 'hid_snto32'. We call this function when processing
> the serial number and related fields to ensure that we are dealing with
> and reporting the unsigned form. We opt to use this method rather than
> adding a descriptor fixup in 'wacom_hid_usage_quirk' since it should be
> more robust in the face of future devices.

> +++ b/drivers/hid/wacom.h
> @@ -205,6 +205,21 @@ static inline void wacom_schedule_work(s
>  	}
>  }
> =20
> +/*
> + * Convert a signed 32-bit integer to an unsigned n-bit integer. Undoes
> + * the normally-helpful work of 'hid_snto32' for fields that use signed
> + * ranges for questionable reasons.
> + */
> +static inline __u32 wacom_s32tou(s32 value, __u8 n)
> +{
> +	switch (n) {
> +	case 8:  return ((__u8)value);
> +	case 16: return ((__u16)value);
> +	case 32: return ((__u32)value);
> +	}
> +	return value & (1 << (n - 1)) ? value & (~(~0U << n)) : value;
> +}

Can we do something like:

    BUG_ON(n>32);
    if (n=3D=3D32) return ((__u32)value);
    return value & ((1 << n) - 1);

instead?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bajzpZikUji1w+G9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl3L3zsACgkQMOfwapXb+vL8/QCgiIe5oadhm4mIYIdDv4aDxKpc
7xAAoKcXIlCR+wWD6Y3I/GPxZDGSo9KG
=sUjw
-----END PGP SIGNATURE-----

--bajzpZikUji1w+G9--
