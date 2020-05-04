Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96ED71C39CB
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 14:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgEDMqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 08:46:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:38696 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727950AbgEDMqk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 08:46:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2057BABD0;
        Mon,  4 May 2020 12:46:40 +0000 (UTC)
Subject: Re: [PATCH v2] drm/ast: Don't check new mode if CRTC is being
 disabled
To:     airlied@redhat.com, daniel@ffwll.ch, kraxel@redhat.com,
        sam@ravnborg.org, emil.velikov@collabora.com, cogarre@gmail.com
Cc:     dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
References: <20200504121203.7203-1-tzimmermann@suse.de>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Autocrypt: addr=tzimmermann@suse.de; keydata=
 mQENBFs50uABCADEHPidWt974CaxBVbrIBwqcq/WURinJ3+2WlIrKWspiP83vfZKaXhFYsdg
 XH47fDVbPPj+d6tQrw5lPQCyqjwrCPYnq3WlIBnGPJ4/jreTL6V+qfKRDlGLWFjZcsrPJGE0
 BeB5BbqP5erN1qylK9i3gPoQjXGhpBpQYwRrEyQyjuvk+Ev0K1Jc5tVDeJAuau3TGNgah4Yc
 hdHm3bkPjz9EErV85RwvImQ1dptvx6s7xzwXTgGAsaYZsL8WCwDaTuqFa1d1jjlaxg6+tZsB
 9GluwvIhSezPgnEmimZDkGnZRRSFiGP8yjqTjjWuf0bSj5rUnTGiyLyRZRNGcXmu6hjlABEB
 AAG0J1Rob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBzdXNlLmRlPokBVAQTAQgAPhYh
 BHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJbOdLgAhsDBQkDwmcABQsJCAcCBhUKCQgLAgQWAgMB
 Ah4BAheAAAoJEGgNwR1TC3ojR80H/jH+vYavwQ+TvO8ksXL9JQWc3IFSiGpuSVXLCdg62AmR
 irxW+qCwNncNQyb9rd30gzdectSkPWL3KSqEResBe24IbA5/jSkPweJasgXtfhuyoeCJ6PXo
 clQQGKIoFIAEv1s8l0ggPZswvCinegl1diyJXUXmdEJRTWYAtxn/atut1o6Giv6D2qmYbXN7
 mneMC5MzlLaJKUtoH7U/IjVw1sx2qtxAZGKVm4RZxPnMCp9E1MAr5t4dP5gJCIiqsdrVqI6i
 KupZstMxstPU//azmz7ZWWxT0JzgJqZSvPYx/SATeexTYBP47YFyri4jnsty2ErS91E6H8os
 Bv6pnSn7eAq5AQ0EWznS4AEIAMYmP4M/V+T5RY5at/g7rUdNsLhWv1APYrh9RQefODYHrNRH
 UE9eosYbT6XMryR9hT8XlGOYRwKWwiQBoWSDiTMo/Xi29jUnn4BXfI2px2DTXwc22LKtLAgT
 RjP+qbU63Y0xnQN29UGDbYgyyK51DW3H0If2a3JNsheAAK+Xc9baj0LGIc8T9uiEWHBnCH+R
 dhgATnWWGKdDegUR5BkDfDg5O/FISymJBHx2Dyoklv5g4BzkgqTqwmaYzsl8UxZKvbaxq0zb
 ehDda8lvhFXodNFMAgTLJlLuDYOGLK2AwbrS3Sp0AEbkpdJBb44qVlGm5bApZouHeJ/+n+7r
 12+lqdsAEQEAAYkBPAQYAQgAJhYhBHIX+6yM6c9jRKFo5WgNwR1TC3ojBQJbOdLgAhsMBQkD
 wmcAAAoJEGgNwR1TC3ojpfcIAInwP5OlcEKokTnHCiDTz4Ony4GnHRP2fXATQZCKxmu4AJY2
 h9ifw9Nf2TjCZ6AMvC3thAN0rFDj55N9l4s1CpaDo4J+0fkrHuyNacnT206CeJV1E7NYntxU
 n+LSiRrOdywn6erjxRi9EYTVLCHcDhBEjKmFZfg4AM4GZMWX1lg0+eHbd5oL1as28WvvI/uI
 aMyV8RbyXot1r/8QLlWldU3NrTF5p7TMU2y3ZH2mf5suSKHAMtbE4jKJ8ZHFOo3GhLgjVrBW
 HE9JXO08xKkgD+w6v83+nomsEuf6C6LYrqY/tsZvyEX6zN8CtirPdPWu/VXNRYAl/lat7lSI
 3H26qrE=
Message-ID: <e5b7c9d4-da92-61f3-23f4-30ad51aade8e@suse.de>
Date:   Mon, 4 May 2020 14:46:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200504121203.7203-1-tzimmermann@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mUEoQtfPhE5vZ9461JgjJq65vInc1QSzm"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mUEoQtfPhE5vZ9461JgjJq65vInc1QSzm
Content-Type: multipart/mixed; boundary="85cm4miHjUi3OXXKTxklqcbviJa7hk541";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: airlied@redhat.com, daniel@ffwll.ch, kraxel@redhat.com, sam@ravnborg.org,
 emil.velikov@collabora.com, cogarre@gmail.com
Cc: dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
 stable@vger.kernel.org
Message-ID: <e5b7c9d4-da92-61f3-23f4-30ad51aade8e@suse.de>
Subject: Re: [PATCH v2] drm/ast: Don't check new mode if CRTC is being
 disabled
References: <20200504121203.7203-1-tzimmermann@suse.de>
In-Reply-To: <20200504121203.7203-1-tzimmermann@suse.de>

--85cm4miHjUi3OXXKTxklqcbviJa7hk541
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



Am 04.05.20 um 14:12 schrieb Thomas Zimmermann:
> Suspending failed because there's no mode if the CRTC is being
> disabled. Early-out in this case. This fixes runtime PM for ast.
>=20
> v2:
> 	* add Tested-by/Reviewed-by tags

s/Reviewed-by/Reported-by

Will be fixed in v3.

> 	* add Fixes tags and CC (Sam)
> 	* improved comment
>=20
> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> Reported-by: Cary Garrett <cogarre@gmail.com>
> Tested-by: Cary Garrett <cogarre@gmail.com>
> Fixes: b48e1b6ffd28 ("drm/ast: Add CRTC helpers for atomic modesetting"=
)
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: <stable@vger.kernel.org> # v5.6+
> ---
>  drivers/gpu/drm/ast/ast_mode.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_m=
ode.c
> index 7a9f20a2fd303..0cbbb21edb4e1 100644
> --- a/drivers/gpu/drm/ast/ast_mode.c
> +++ b/drivers/gpu/drm/ast/ast_mode.c
> @@ -801,6 +801,9 @@ static int ast_crtc_helper_atomic_check(struct drm_=
crtc *crtc,
>  		return -EINVAL;
>  	}
> =20
> +	if (!state->enable)
> +		return 0; /* no mode checks if CRTC is being disabled */
> +
>  	ast_state =3D to_ast_crtc_state(state);
> =20
>  	format =3D ast_state->format;
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--85cm4miHjUi3OXXKTxklqcbviJa7hk541--

--mUEoQtfPhE5vZ9461JgjJq65vInc1QSzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEchf7rIzpz2NEoWjlaA3BHVMLeiMFAl6wDq0ACgkQaA3BHVML
eiOG4AgAuPIqFe4NgpUsglsAOb49yjEcWFLLBfkn6FyjksXWXU4FSEelpTNfFliO
XHmYtu228nwSJbJFFu+jiHOTD3Y3OGbUMq2ffJBMRHN2utApuHhJB/2izMCwzGgP
ta+cSByWgXbGzvXXJfgUOCq3cUtSbP2JFRjYnE+Ig6gKP3Fd/OxNWkRIbawz8X0j
e2yuDE6kDkV0dfsipSH4oRsw9tv5B2evK2/pnR/E1sD5sKJ8LrVD8BSmxO4X++wE
Z5CIyXVgmgcQSakaaw0garxSMzA+a7LSqvGniXVRYj6DFRDpQ0t+4ohCTpfnY0LW
OXR+Xn4ufhLxLw3ly8eRkW6j7umXyQ==
=gtoc
-----END PGP SIGNATURE-----

--mUEoQtfPhE5vZ9461JgjJq65vInc1QSzm--
