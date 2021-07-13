Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E5C3C7825
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 22:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhGMUtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 16:49:36 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:49256 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234394AbhGMUtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 16:49:36 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2D9CF1C0B7A; Tue, 13 Jul 2021 22:46:44 +0200 (CEST)
Date:   Tue, 13 Jul 2021 22:46:43 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Geoffrey D. Bennett" <g@b4.vu>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 5.10 007/593] ALSA: usb-audio: scarlett2: Fix wrong
 resume call
Message-ID: <20210713204643.GA21897@amd>
References: <20210712060843.180606720@linuxfoundation.org>
 <20210712060843.978749134@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20210712060843.978749134@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This patch corrects those issues.  It introduces a new value type,
> USB_MIXER_BESPOKEN, which indicates a non-standard mixer element, and
> use this type for all scarlett2 mixer elements, as well as
> initializing the fixed unit id 0 for avoiding the overflow.

New mixer value is introduced, but printing code in mixer.c is not
updated.

Is something like this needed?


> +++ b/sound/usb/mixer.h
> @@ -55,6 +55,7 @@ enum {
>  	USB_MIXER_U16,
>  	USB_MIXER_S32,
>  	USB_MIXER_U32,
> +	USB_MIXER_BESPOKEN,	/* non-standard type */
>  };
>

Best regards,
							Pavel

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 2b5281ef8fca..83d5e4d19128 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3294,7 +3294,7 @@ static void snd_usb_mixer_dump_cval(struct snd_info_b=
uffer *buffer,
 {
 	struct usb_mixer_elem_info *cval =3D mixer_elem_list_to_info(list);
 	static const char * const val_types[] =3D {
-		"BOOLEAN", "INV_BOOLEAN", "S8", "U8", "S16", "U16", "S32", "U32",
+		"BOOLEAN", "INV_BOOLEAN", "S8", "U8", "S16", "U16", "S32", "U32", "BESPO=
KEN",=20
 	};

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDt+7MACgkQMOfwapXb+vKiegCeLQBSOze1TjPqUt9nn9/tvpv+
iuwAoKteVnR/byH8Ie4pCWcnQDEwO6VA
=ZLiS
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
