Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7431119C92C
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 20:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388875AbgDBSxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 14:53:23 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:43444 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732214AbgDBSxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 14:53:23 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E08941C30CA; Thu,  2 Apr 2020 20:53:21 +0200 (CEST)
Date:   Thu, 2 Apr 2020 20:53:21 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH 4.19 105/116] bpf: Explicitly memset the bpf_attr
 structure
Message-ID: <20200402185320.GA8077@duo.ucw.cz>
References: <20200401161542.669484650@linuxfoundation.org>
 <20200401161555.630698707@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
In-Reply-To: <20200401161555.630698707@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> commit 8096f229421f7b22433775e928d506f0342e5907 upstream.
>=20
> For the bpf syscall, we are relying on the compiler to properly zero out
> the bpf_attr union that we copy userspace data into. Unfortunately that
> doesn't always work properly, padding and other oddities might not be
> correctly zeroed, and in some tests odd things have been found when the
> stack is pre-initialized to other values.
>=20
> Fix this by explicitly memsetting the structure to 0 before using
> it.

Is not that a gcc bug? I mean, that's seriously unhelpful behaviour
=66rom security perspective.

Is there any reason to believe this is not causing problems elsewhere?

$ grep -ri "=3D {}" . | wc -l
2152

I'm pretty sure many of these are before return to userspace... I
picked one at random:

=2E/drivers/media/cec/cec-api.c-static long cec_adap_g_caps(struct cec_adap=
ter *adap,
=2E/drivers/media/cec/cec-api.c-                      struct cec_caps __use=
r *parg)
=2E/drivers/media/cec/cec-api.c-{
=2E/drivers/media/cec/cec-api.c:  struct cec_caps caps =3D {};
=2E/drivers/media/cec/cec-api.c-
=2E/drivers/media/cec/cec-api.c-  strscpy(caps.driver, adap->devnode.dev.pa=
rent->driver->name,
=2E/drivers/media/cec/cec-api.c-          sizeof(caps.driver));
=2E/drivers/media/cec/cec-api.c-  strscpy(caps.name, adap->name, sizeof(cap=
s.name));
=2E/drivers/media/cec/cec-api.c-  caps.available_log_addrs =3D adap->availa=
ble_log_addrs;
=2E/drivers/media/cec/cec-api.c-  caps.capabilities =3D adap->capabilities;
=2E/drivers/media/cec/cec-api.c-  caps.version =3D LINUX_VERSION_CODE;
=2E/drivers/media/cec/cec-api.c-  if (copy_to_user(parg, &caps, sizeof(caps=
)))
=2E/drivers/media/cec/cec-api.c-          return -EFAULT;
=2E/drivers/media/cec/cec-api.c-  return 0;
=2E/drivers/media/cec/cec-api.c-}

Should we fix gcc, instead?

Best regards,
								Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXoY0oAAKCRAw5/Bqldv6
8jBPAKCO1CPqb2VuZvn3ff2zklH3fQ078ACfTyBx2FZF/flzA/HwPuDghMC7+pg=
=skZm
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
