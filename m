Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88F021B5E8
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 15:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgGJNJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 09:09:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:41400 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbgGJNJu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 09:09:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 05864AD45;
        Fri, 10 Jul 2020 13:09:48 +0000 (UTC)
Subject: Re: [PATCH] drm/fb-helper: Fix vt restore
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     David Airlie <airlied@linux.ie>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>, shlomo@fastmail.com,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel@daenzer.net>
References: <20200623155456.3092836-1-daniel.vetter@ffwll.ch>
 <ac847c3c-e93c-4a4b-c6ca-2362af7e3aa3@suse.de>
 <CAKMK7uFi0nkf1fSUZaqff-oskoTKMS0Rh_69_Sd9JQ69NMhOMA@mail.gmail.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
Message-ID: <f2b05939-43c4-1b9c-f462-09ed630c3d63@suse.de>
Date:   Fri, 10 Jul 2020 15:09:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAKMK7uFi0nkf1fSUZaqff-oskoTKMS0Rh_69_Sd9JQ69NMhOMA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="K2Ex8wthZpBzdKi5zn9UCF5jPp7SWvTrd"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--K2Ex8wthZpBzdKi5zn9UCF5jPp7SWvTrd
Content-Type: multipart/mixed; boundary="PaXZsG6FtCFcQWV50REzZJbMsCFeoxEm6";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>,
 Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
 stable <stable@vger.kernel.org>, shlomo@fastmail.com,
 DRI Development <dri-devel@lists.freedesktop.org>,
 Daniel Vetter <daniel.vetter@intel.com>, =?UTF-8?Q?Michel_D=c3=a4nzer?=
 <michel@daenzer.net>
Message-ID: <f2b05939-43c4-1b9c-f462-09ed630c3d63@suse.de>
Subject: Re: [PATCH] drm/fb-helper: Fix vt restore
References: <20200623155456.3092836-1-daniel.vetter@ffwll.ch>
 <ac847c3c-e93c-4a4b-c6ca-2362af7e3aa3@suse.de>
 <CAKMK7uFi0nkf1fSUZaqff-oskoTKMS0Rh_69_Sd9JQ69NMhOMA@mail.gmail.com>
In-Reply-To: <CAKMK7uFi0nkf1fSUZaqff-oskoTKMS0Rh_69_Sd9JQ69NMhOMA@mail.gmail.com>

--PaXZsG6FtCFcQWV50REzZJbMsCFeoxEm6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi

Am 10.07.20 um 14:38 schrieb Daniel Vetter:
> On Fri, Jul 10, 2020 at 1:31 PM Thomas Zimmermann <tzimmermann@suse.de>=
 wrote:
>>
>> Hi Daniel,
>>
>> this patch might not be enougth. I started Xorg and then did 'kill -9'=

>> on the Xorg process. Xorg went away, but the console did not come back=
=2E
>=20
> Hm don't you need to reset your terminal to text mode in that case
> first? Iirc there's a sysrq. All again assuming not terribly modern
> system where that stuff is all done by logind.

I don't know. I just noticed that kill -9 did not restore the terminal
and apparently it was related to these patches. Maybe it did not even
work before?

Best regards
Thomas

> -Daniel
>=20
>>
>> Best regards
>> Thomas
>>
>> Am 23.06.20 um 17:54 schrieb Daniel Vetter:
>>> In the past we had a pile of hacks to orchestrate access between fbde=
v
>>> emulation and native kms clients. We've tried to streamline this, by
>>> always preferring the kms side above fbdev calls when a drm master
>>> exists, because drm master controls access to the display resources.
>>>
>>> Unfortunately this breaks existing userspace, specifically Xorg. When=

>>> exiting Xorg first restores the console to text mode using the KDSET
>>> ioctl on the vt. This does nothing, because a drm master is still
>>> around. Then it drops the drm master status, which again does nothing=
,
>>> because logind is keeping additional drm fd open to be able to
>>> orchestrate vt switches. In the past this is the point where fbdev wa=
s
>>> restored, as part of the ->lastclose hook on the drm side.
>>>
>>> Now to fix this regression we don't want to go back to letting fbdev
>>> restore things whenever it feels like, or to the pile of hacks we've
>>> had before. Instead try and go with a minimal exception to make the
>>> KDSET case work again, and nothing else.
>>>
>>> This means that if userspace does a KDSET call when switching between=

>>> graphical compositors, there will be some flickering with fbcon
>>> showing up for a bit. But a) that's not a regression and b) userspace=

>>> can fix it by improving the vt switching dance - logind should have
>>> all the information it needs.
>>>
>>> While pondering all this I'm also wondering wheter we should have a
>>> SWITCH_MASTER ioctl to allow race-free master status handover. But
>>> that's for another day.
>>>
>>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D208179
>>> Cc: shlomo@fastmail.com
>>> Reported-and-Tested-by: shlomo@fastmail.com
>>> Cc: Michel D=C3=A4nzer <michel@daenzer.net>
>>> Fixes: 64914da24ea9 ("drm/fbdev-helper: don't force restores")
>>> Cc: Noralf Tr=C3=B8nnes <noralf@tronnes.org>
>>> Cc: Thomas Zimmermann <tzimmermann@suse.de>
>>> Cc: Daniel Vetter <daniel.vetter@intel.com>
>>> Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>>> Cc: Maxime Ripard <mripard@kernel.org>
>>> Cc: David Airlie <airlied@linux.ie>
>>> Cc: Daniel Vetter <daniel@ffwll.ch>
>>> Cc: dri-devel@lists.freedesktop.org
>>> Cc: <stable@vger.kernel.org> # v5.7+
>>> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
>>> ---
>>>  drivers/gpu/drm/drm_fb_helper.c  | 63 +++++++++++++++++++++++++-----=
--
>>>  drivers/video/fbdev/core/fbcon.c |  3 +-
>>>  include/uapi/linux/fb.h          |  1 +
>>>  3 files changed, 52 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb=
_helper.c
>>> index 170aa7689110..ae69bf8e9bcc 100644
>>> --- a/drivers/gpu/drm/drm_fb_helper.c
>>> +++ b/drivers/gpu/drm/drm_fb_helper.c
>>> @@ -227,18 +227,9 @@ int drm_fb_helper_debug_leave(struct fb_info *in=
fo)
>>>  }
>>>  EXPORT_SYMBOL(drm_fb_helper_debug_leave);
>>>
>>> -/**
>>> - * drm_fb_helper_restore_fbdev_mode_unlocked - restore fbdev configu=
ration
>>> - * @fb_helper: driver-allocated fbdev helper, can be NULL
>>> - *
>>> - * This should be called from driver's drm &drm_driver.lastclose cal=
lback
>>> - * when implementing an fbcon on top of kms using this helper. This =
ensures that
>>> - * the user isn't greeted with a black screen when e.g. X dies.
>>> - *
>>> - * RETURNS:
>>> - * Zero if everything went ok, negative error code otherwise.
>>> - */
>>> -int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *=
fb_helper)
>>> +static int
>>> +__drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb=
_helper,
>>> +                                         bool force)
>>>  {
>>>       bool do_delayed;
>>>       int ret;
>>> @@ -250,7 +241,16 @@ int drm_fb_helper_restore_fbdev_mode_unlocked(st=
ruct drm_fb_helper *fb_helper)
>>>               return 0;
>>>
>>>       mutex_lock(&fb_helper->lock);
>>> -     ret =3D drm_client_modeset_commit(&fb_helper->client);
>>> +     if (force) {
>>> +             /*
>>> +              * Yes this is the _locked version which expects the ma=
ster lock
>>> +              * to be held. But for forced restores we're intentiona=
lly
>>> +              * racing here, see drm_fb_helper_set_par().
>>> +              */
>>> +             ret =3D drm_client_modeset_commit_locked(&fb_helper->cl=
ient);
>>> +     } else {
>>> +             ret =3D drm_client_modeset_commit(&fb_helper->client);
>>> +     }
>>>
>>>       do_delayed =3D fb_helper->delayed_hotplug;
>>>       if (do_delayed)
>>> @@ -262,6 +262,22 @@ int drm_fb_helper_restore_fbdev_mode_unlocked(st=
ruct drm_fb_helper *fb_helper)
>>>
>>>       return ret;
>>>  }
>>> +
>>> +/**
>>> + * drm_fb_helper_restore_fbdev_mode_unlocked - restore fbdev configu=
ration
>>> + * @fb_helper: driver-allocated fbdev helper, can be NULL
>>> + *
>>> + * This should be called from driver's drm &drm_driver.lastclose cal=
lback
>>> + * when implementing an fbcon on top of kms using this helper. This =
ensures that
>>> + * the user isn't greeted with a black screen when e.g. X dies.
>>> + *
>>> + * RETURNS:
>>> + * Zero if everything went ok, negative error code otherwise.
>>> + */
>>> +int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *=
fb_helper)
>>> +{
>>> +     return __drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, f=
alse);
>>> +}
>>>  EXPORT_SYMBOL(drm_fb_helper_restore_fbdev_mode_unlocked);
>>>
>>>  #ifdef CONFIG_MAGIC_SYSRQ
>>> @@ -1318,6 +1334,7 @@ int drm_fb_helper_set_par(struct fb_info *info)=

>>>  {
>>>       struct drm_fb_helper *fb_helper =3D info->par;
>>>       struct fb_var_screeninfo *var =3D &info->var;
>>> +     bool force;
>>>
>>>       if (oops_in_progress)
>>>               return -EBUSY;
>>> @@ -1327,7 +1344,25 @@ int drm_fb_helper_set_par(struct fb_info *info=
)
>>>               return -EINVAL;
>>>       }
>>>
>>> -     drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper);
>>> +     /*
>>> +      * Normally we want to make sure that a kms master takes
>>> +      * precedence over fbdev, to avoid fbdev flickering and
>>> +      * occasionally stealing the display status. But Xorg first set=
s
>>> +      * the vt back to text mode using the KDSET IOCTL with KD_TEXT,=

>>> +      * and only after that drops the master status when exiting.
>>> +      *
>>> +      * In the past this was caught by drm_fb_helper_lastclose(), bu=
t
>>> +      * on modern systems where logind always keeps a drm fd open to=

>>> +      * orchestrate the vt switching, this doesn't work.
>>> +      *
>>> +      * To no break the userspace ABI we have this special case here=
,
>>> +      * which is only used for the above case. Everything else uses
>>> +      * the normal commit function, which ensures that we never stea=
l
>>> +      * the display from an active drm master.
>>> +      */
>>> +     force =3D var->activate & FB_ACTIVATE_KD_TEXT;
>>> +
>>> +     __drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, force);
>>>
>>>       return 0;
>>>  }
>>> diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/c=
ore/fbcon.c
>>> index 9d28a8e3328f..e2a490c5ae08 100644
>>> --- a/drivers/video/fbdev/core/fbcon.c
>>> +++ b/drivers/video/fbdev/core/fbcon.c
>>> @@ -2402,7 +2402,8 @@ static int fbcon_blank(struct vc_data *vc, int =
blank, int mode_switch)
>>>               ops->graphics =3D 1;
>>>
>>>               if (!blank) {
>>> -                     var.activate =3D FB_ACTIVATE_NOW | FB_ACTIVATE_=
FORCE;
>>> +                     var.activate =3D FB_ACTIVATE_NOW | FB_ACTIVATE_=
FORCE |
>>> +                             FB_ACTIVATE_KD_TEXT;
>>>                       fb_set_var(info, &var);
>>>                       ops->graphics =3D 0;
>>>                       ops->var =3D info->var;
>>> diff --git a/include/uapi/linux/fb.h b/include/uapi/linux/fb.h
>>> index b6aac7ee1f67..4c14e8be7267 100644
>>> --- a/include/uapi/linux/fb.h
>>> +++ b/include/uapi/linux/fb.h
>>> @@ -205,6 +205,7 @@ struct fb_bitfield {
>>>  #define FB_ACTIVATE_ALL             64       /* change all VCs on th=
is fb    */
>>>  #define FB_ACTIVATE_FORCE     128    /* force apply even when no cha=
nge*/
>>>  #define FB_ACTIVATE_INV_MODE  256       /* invalidate videomode */
>>> +#define FB_ACTIVATE_KD_TEXT   512       /* for KDSET vt ioctl */
>>>
>>>  #define FB_ACCELF_TEXT               1       /* (OBSOLETE) see fb_in=
fo.flags and vc_mode */
>>>
>>>
>>
>> --
>> Thomas Zimmermann
>> Graphics Driver Developer
>> SUSE Software Solutions Germany GmbH
>> Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
>> (HRB 36809, AG N=C3=BCrnberg)
>> Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer
>>
>=20
>=20

--=20
Thomas Zimmermann
Graphics Driver Developer
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
(HRB 36809, AG N=C3=BCrnberg)
Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer


--PaXZsG6FtCFcQWV50REzZJbMsCFeoxEm6--

--K2Ex8wthZpBzdKi5zn9UCF5jPp7SWvTrd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFIBAEBCAAyFiEEchf7rIzpz2NEoWjlaA3BHVMLeiMFAl8IaJcUHHR6aW1tZXJt
YW5uQHN1c2UuZGUACgkQaA3BHVMLeiNP3ggAlfUykStVcYQ1d7597l1hoQGVdQ8M
a0GkpOzkIxUWFyBQeUg2HyZ8wy+/xl6K66vG/hYUKpuC3IjjWYkohrDd8hP9QJII
RpUFyUvHE1NjziI7+l1tNB1nhrnk0Bx1V/B9TIobeWVqKStV63OypyUwm2ElOGMZ
K8FLpNkvkq4s+osioi/P9KsENjFvaFQfz3vRayfDxgxVa3wQEiUGWQ1h3MRExY++
nHOqRfowL6/Ls/GCLbNsMr86pDQFYmv5TPiQ22UaE0EUGWO1/IF7jsWfpASuQSer
dcNWEp2fVYSdXr1YLK2SHxQd2+RfwaMTmIV8KOqGqLzjyu3scBC+3JyC2w==
=7Xdo
-----END PGP SIGNATURE-----

--K2Ex8wthZpBzdKi5zn9UCF5jPp7SWvTrd--
