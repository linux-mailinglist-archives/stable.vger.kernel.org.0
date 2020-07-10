Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8342721B3FC
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 13:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgGJLbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 07:31:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:33566 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbgGJLbd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 07:31:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2F02AE56;
        Fri, 10 Jul 2020 11:31:30 +0000 (UTC)
Subject: Re: [PATCH] drm/fb-helper: Fix vt restore
To:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>
Cc:     David Airlie <airlied@linux.ie>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        shlomo@fastmail.com, stable@vger.kernel.org,
        Daniel Vetter <daniel.vetter@intel.com>,
        =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
References: <20200623155456.3092836-1-daniel.vetter@ffwll.ch>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <ac847c3c-e93c-4a4b-c6ca-2362af7e3aa3@suse.de>
Date:   Fri, 10 Jul 2020 13:31:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200623155456.3092836-1-daniel.vetter@ffwll.ch>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UEVDRlW74y98w2X6O5TFy9Ob2jguaRVEB"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UEVDRlW74y98w2X6O5TFy9Ob2jguaRVEB
Content-Type: multipart/mixed; boundary="e8biO4xY56enENhSiRL7VWkiA5tZdMGbm";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
 DRI Development <dri-devel@lists.freedesktop.org>
Cc: David Airlie <airlied@linux.ie>,
 Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
 shlomo@fastmail.com, stable@vger.kernel.org,
 Daniel Vetter <daniel.vetter@intel.com>, =?UTF-8?Q?Michel_D=c3=a4nzer?=
 <michel@daenzer.net>
Message-ID: <ac847c3c-e93c-4a4b-c6ca-2362af7e3aa3@suse.de>
Subject: Re: [PATCH] drm/fb-helper: Fix vt restore
References: <20200623155456.3092836-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20200623155456.3092836-1-daniel.vetter@ffwll.ch>

--e8biO4xY56enENhSiRL7VWkiA5tZdMGbm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

this patch might not be enougth. I started Xorg and then did 'kill -9'
on the Xorg process. Xorg went away, but the console did not come back.

Best regards
Thomas

Am 23.06.20 um 17:54 schrieb Daniel Vetter:
> In the past we had a pile of hacks to orchestrate access between fbdev
> emulation and native kms clients. We've tried to streamline this, by
> always preferring the kms side above fbdev calls when a drm master
> exists, because drm master controls access to the display resources.
>=20
> Unfortunately this breaks existing userspace, specifically Xorg. When
> exiting Xorg first restores the console to text mode using the KDSET
> ioctl on the vt. This does nothing, because a drm master is still
> around. Then it drops the drm master status, which again does nothing,
> because logind is keeping additional drm fd open to be able to
> orchestrate vt switches. In the past this is the point where fbdev was
> restored, as part of the ->lastclose hook on the drm side.
>=20
> Now to fix this regression we don't want to go back to letting fbdev
> restore things whenever it feels like, or to the pile of hacks we've
> had before. Instead try and go with a minimal exception to make the
> KDSET case work again, and nothing else.
>=20
> This means that if userspace does a KDSET call when switching between
> graphical compositors, there will be some flickering with fbcon
> showing up for a bit. But a) that's not a regression and b) userspace
> can fix it by improving the vt switching dance - logind should have
> all the information it needs.
>=20
> While pondering all this I'm also wondering wheter we should have a
> SWITCH_MASTER ioctl to allow race-free master status handover. But
> that's for another day.
>=20
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D208179
> Cc: shlomo@fastmail.com
> Reported-and-Tested-by: shlomo@fastmail.com
> Cc: Michel D=C3=A4nzer <michel@daenzer.net>
> Fixes: 64914da24ea9 ("drm/fbdev-helper: don't force restores")
> Cc: Noralf Tr=C3=B8nnes <noralf@tronnes.org>
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel@ffwll.ch>
> Cc: dri-devel@lists.freedesktop.org
> Cc: <stable@vger.kernel.org> # v5.7+
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  drivers/gpu/drm/drm_fb_helper.c  | 63 +++++++++++++++++++++++++-------=

>  drivers/video/fbdev/core/fbcon.c |  3 +-
>  include/uapi/linux/fb.h          |  1 +
>  3 files changed, 52 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_h=
elper.c
> index 170aa7689110..ae69bf8e9bcc 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -227,18 +227,9 @@ int drm_fb_helper_debug_leave(struct fb_info *info=
)
>  }
>  EXPORT_SYMBOL(drm_fb_helper_debug_leave);
> =20
> -/**
> - * drm_fb_helper_restore_fbdev_mode_unlocked - restore fbdev configura=
tion
> - * @fb_helper: driver-allocated fbdev helper, can be NULL
> - *
> - * This should be called from driver's drm &drm_driver.lastclose callb=
ack
> - * when implementing an fbcon on top of kms using this helper. This en=
sures that
> - * the user isn't greeted with a black screen when e.g. X dies.
> - *
> - * RETURNS:
> - * Zero if everything went ok, negative error code otherwise.
> - */
> -int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb=
_helper)
> +static int
> +__drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_h=
elper,
> +					    bool force)
>  {
>  	bool do_delayed;
>  	int ret;
> @@ -250,7 +241,16 @@ int drm_fb_helper_restore_fbdev_mode_unlocked(stru=
ct drm_fb_helper *fb_helper)
>  		return 0;
> =20
>  	mutex_lock(&fb_helper->lock);
> -	ret =3D drm_client_modeset_commit(&fb_helper->client);
> +	if (force) {
> +		/*
> +		 * Yes this is the _locked version which expects the master lock
> +		 * to be held. But for forced restores we're intentionally
> +		 * racing here, see drm_fb_helper_set_par().
> +		 */
> +		ret =3D drm_client_modeset_commit_locked(&fb_helper->client);
> +	} else {
> +		ret =3D drm_client_modeset_commit(&fb_helper->client);
> +	}
> =20
>  	do_delayed =3D fb_helper->delayed_hotplug;
>  	if (do_delayed)
> @@ -262,6 +262,22 @@ int drm_fb_helper_restore_fbdev_mode_unlocked(stru=
ct drm_fb_helper *fb_helper)
> =20
>  	return ret;
>  }
> +
> +/**
> + * drm_fb_helper_restore_fbdev_mode_unlocked - restore fbdev configura=
tion
> + * @fb_helper: driver-allocated fbdev helper, can be NULL
> + *
> + * This should be called from driver's drm &drm_driver.lastclose callb=
ack
> + * when implementing an fbcon on top of kms using this helper. This en=
sures that
> + * the user isn't greeted with a black screen when e.g. X dies.
> + *
> + * RETURNS:
> + * Zero if everything went ok, negative error code otherwise.
> + */
> +int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb=
_helper)
> +{
> +	return __drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, false);=

> +}
>  EXPORT_SYMBOL(drm_fb_helper_restore_fbdev_mode_unlocked);
> =20
>  #ifdef CONFIG_MAGIC_SYSRQ
> @@ -1318,6 +1334,7 @@ int drm_fb_helper_set_par(struct fb_info *info)
>  {
>  	struct drm_fb_helper *fb_helper =3D info->par;
>  	struct fb_var_screeninfo *var =3D &info->var;
> +	bool force;
> =20
>  	if (oops_in_progress)
>  		return -EBUSY;
> @@ -1327,7 +1344,25 @@ int drm_fb_helper_set_par(struct fb_info *info)
>  		return -EINVAL;
>  	}
> =20
> -	drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper);
> +	/*
> +	 * Normally we want to make sure that a kms master takes
> +	 * precedence over fbdev, to avoid fbdev flickering and
> +	 * occasionally stealing the display status. But Xorg first sets
> +	 * the vt back to text mode using the KDSET IOCTL with KD_TEXT,
> +	 * and only after that drops the master status when exiting.
> +	 *
> +	 * In the past this was caught by drm_fb_helper_lastclose(), but
> +	 * on modern systems where logind always keeps a drm fd open to
> +	 * orchestrate the vt switching, this doesn't work.
> +	 *
> +	 * To no break the userspace ABI we have this special case here,
> +	 * which is only used for the above case. Everything else uses
> +	 * the normal commit function, which ensures that we never steal
> +	 * the display from an active drm master.
> +	 */
> +	force =3D var->activate & FB_ACTIVATE_KD_TEXT;
> +
> +	__drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, force);
> =20
>  	return 0;
>  }
> diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/cor=
e/fbcon.c
> index 9d28a8e3328f..e2a490c5ae08 100644
> --- a/drivers/video/fbdev/core/fbcon.c
> +++ b/drivers/video/fbdev/core/fbcon.c
> @@ -2402,7 +2402,8 @@ static int fbcon_blank(struct vc_data *vc, int bl=
ank, int mode_switch)
>  		ops->graphics =3D 1;
> =20
>  		if (!blank) {
> -			var.activate =3D FB_ACTIVATE_NOW | FB_ACTIVATE_FORCE;
> +			var.activate =3D FB_ACTIVATE_NOW | FB_ACTIVATE_FORCE |
> +				FB_ACTIVATE_KD_TEXT;
>  			fb_set_var(info, &var);
>  			ops->graphics =3D 0;
>  			ops->var =3D info->var;
> diff --git a/include/uapi/linux/fb.h b/include/uapi/linux/fb.h
> index b6aac7ee1f67..4c14e8be7267 100644
> --- a/include/uapi/linux/fb.h
> +++ b/include/uapi/linux/fb.h
> @@ -205,6 +205,7 @@ struct fb_bitfield {
>  #define FB_ACTIVATE_ALL	       64	/* change all VCs on this fb	*/
>  #define FB_ACTIVATE_FORCE     128	/* force apply even when no change*/=

>  #define FB_ACTIVATE_INV_MODE  256       /* invalidate videomode */
> +#define FB_ACTIVATE_KD_TEXT   512       /* for KDSET vt ioctl */
> =20
>  #define FB_ACCELF_TEXT		1	/* (OBSOLETE) see fb_info.flags and vc_mode =
*/
> =20
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--e8biO4xY56enENhSiRL7VWkiA5tZdMGbm--

--UEVDRlW74y98w2X6O5TFy9Ob2jguaRVEB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFIBAEBCAAyFiEEchf7rIzpz2NEoWjlaA3BHVMLeiMFAl8IUY8UHHR6aW1tZXJt
YW5uQHN1c2UuZGUACgkQaA3BHVMLeiOCpwf+OgEbboFX6WaH3GPX5r2S+oQ70qr3
JpgddEnE8IEZYarjfthHUcqjHtURRG2ULkrSOMNMGB7+fOZz9EMB9L255JhnToWp
7mpRAnOYYc4pHCNFvdRgeqB0Hy58V2pmW2xKscJ58/nP2p9999o8u+odyYlLVyjX
ci9JbL0OVO3VyHe+2Z/hgIXJjmeyG+AdBPp8BeX4MfGzwXtxVgvxO6KhK/4Kc7XB
h7hSzkc3pBGVYKi9Ik8z5JSDFw60RNXsX3HDDz28uuGpiNHazC/hd8U6Ytfhcq5M
KxTWSfmupqpIiG63POuPFp2SkWkX4AdajzbERXvpnZM4YyPwch9q7lwF0g==
=TtTE
-----END PGP SIGNATURE-----

--UEVDRlW74y98w2X6O5TFy9Ob2jguaRVEB--
