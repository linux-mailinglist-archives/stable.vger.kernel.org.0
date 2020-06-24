Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DBC2075B4
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 16:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390438AbgFXO22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 10:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389874AbgFXO21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 10:28:27 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075E7C061573;
        Wed, 24 Jun 2020 07:28:27 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k6so2521310wrn.3;
        Wed, 24 Jun 2020 07:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PiWiHsaEad5didbDUehQ2S2m3Yftt2YsakynGFf9Gs0=;
        b=Nu+np0n72SdMxJT+2W+cTbf+cZpSQxe5CoSfkI0ccIWfwtAvtaJ4QqPw8v4pMalCPa
         94gQ7dOLAW41i/MTqpv6Jj9oiQ/uQVjEmnrDJX05bbeg/VeimOTeZNslsUmqgzokARLY
         1gq4GebAiYXa+XDQwvsBbpA7jlElcHjjTt2jrlWpn7iw/8yVLWkFP1Ghg6JhR3sinFmd
         wHx65PtH5w5Zv2EEt/vqfEZaMZMgSADukjw8pAVM2QSTlkoYNNz4m4j/CQ6eUSMTUtRm
         pK/NiKXfnagUi9IaVWmj7uGdjp0qhYIkV1dJHk3Y++L8y82P0i3EZay0nrf6T1W3jPhg
         BGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PiWiHsaEad5didbDUehQ2S2m3Yftt2YsakynGFf9Gs0=;
        b=tmO5e2ETxyQt9aNFUwtvvBzUOL3YX0vw1rTvUp9ic6RrDWmuBKuhJ/RkBEvD7xr3g3
         X/jaP5vDLyEU3zn6UsaJE9GUBOc5WdoTvGhhPlN8mXeJ4J6OQe2fd6LjTY+cSnuviwEz
         oo1hPzbi264aVvUZFgC2uFKyfV1rUC1ohrkTGzGhTyj6AGQ1LAuFOlcAomSuNdYw5Wtk
         deFk5tUD7vLMAVV6GE7UAIhtOJwskJxldbRCIVSl33aP1zlQB+IvqNSyLu8M7vvsBuZ7
         CzYd7oRRfrhm5KzX6kvi4f78EflEy+JgZQ+zt793rHcZtuCEvcCmCcd+X5FavUNxSvoK
         Twug==
X-Gm-Message-State: AOAM532LiXuGzIVHILMij9eD59gJ1KESjqtk3kJmfWjh8SG8aywAYh0F
        gwR6+9hD4Fyn9tY5eEEXOTY2QVXTaUCICv/o79s=
X-Google-Smtp-Source: ABdhPJwJ+sKk5oPI4pshdfh0Hw7+ZIzklpgmcScMvoQnx+clkwdB91Ph7WEcOwwBFW6QNrAN9iHaMO98Cw5Ef74Tt6w=
X-Received: by 2002:a5d:6a46:: with SMTP id t6mr4383998wrw.374.1593008905685;
 Wed, 24 Jun 2020 07:28:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200623155456.3092836-1-daniel.vetter@ffwll.ch> <20200624092910.3280448-1-daniel.vetter@ffwll.ch>
In-Reply-To: <20200624092910.3280448-1-daniel.vetter@ffwll.ch>
From:   Alex Deucher <alexdeucher@gmail.com>
Date:   Wed, 24 Jun 2020 10:28:14 -0400
Message-ID: <CADnq5_Nm==8UFsuGd0BxKixajdb0-J_D7TucrEE8AxzeXYLbDA@mail.gmail.com>
Subject: Re: [PATCH] drm/fb-helper: Fix vt restore
To:     Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        linux-fbdev@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        David Airlie <airlied@linux.ie>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        shlomo@fastmail.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        "for 3.8" <stable@vger.kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Peter Rosin <peda@axentia.se>,
        Qiujun Huang <hqjagain@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 5:29 AM Daniel Vetter <daniel.vetter@ffwll.ch> wrot=
e:
>
> In the past we had a pile of hacks to orchestrate access between fbdev
> emulation and native kms clients. We've tried to streamline this, by
> always preferring the kms side above fbdev calls when a drm master
> exists, because drm master controls access to the display resources.
>
> Unfortunately this breaks existing userspace, specifically Xorg. When
> exiting Xorg first restores the console to text mode using the KDSET
> ioctl on the vt. This does nothing, because a drm master is still
> around. Then it drops the drm master status, which again does nothing,
> because logind is keeping additional drm fd open to be able to
> orchestrate vt switches. In the past this is the point where fbdev was
> restored, as part of the ->lastclose hook on the drm side.
>
> Now to fix this regression we don't want to go back to letting fbdev
> restore things whenever it feels like, or to the pile of hacks we've
> had before. Instead try and go with a minimal exception to make the
> KDSET case work again, and nothing else.
>
> This means that if userspace does a KDSET call when switching between
> graphical compositors, there will be some flickering with fbcon
> showing up for a bit. But a) that's not a regression and b) userspace
> can fix it by improving the vt switching dance - logind should have
> all the information it needs.
>
> While pondering all this I'm also wondering wheter we should have a
> SWITCH_MASTER ioctl to allow race-free master status handover. But
> that's for another day.
>
> v2: Somehow forgot to cc all the fbdev people.
>
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
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Nathan Chancellor <natechancellor@gmail.com>
> Cc: Qiujun Huang <hqjagain@gmail.com>
> Cc: Peter Rosin <peda@axentia.se>
> Cc: linux-fbdev@vger.kernel.org
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> ---
>  drivers/gpu/drm/drm_fb_helper.c  | 63 +++++++++++++++++++++++++-------
>  drivers/video/fbdev/core/fbcon.c |  3 +-
>  include/uapi/linux/fb.h          |  1 +
>  3 files changed, 52 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_hel=
per.c
> index 170aa7689110..ae69bf8e9bcc 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -227,18 +227,9 @@ int drm_fb_helper_debug_leave(struct fb_info *info)
>  }
>  EXPORT_SYMBOL(drm_fb_helper_debug_leave);
>
> -/**
> - * drm_fb_helper_restore_fbdev_mode_unlocked - restore fbdev configurati=
on
> - * @fb_helper: driver-allocated fbdev helper, can be NULL
> - *
> - * This should be called from driver's drm &drm_driver.lastclose callbac=
k
> - * when implementing an fbcon on top of kms using this helper. This ensu=
res that
> - * the user isn't greeted with a black screen when e.g. X dies.
> - *
> - * RETURNS:
> - * Zero if everything went ok, negative error code otherwise.
> - */
> -int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_h=
elper)
> +static int
> +__drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_hel=
per,
> +                                           bool force)
>  {
>         bool do_delayed;
>         int ret;
> @@ -250,7 +241,16 @@ int drm_fb_helper_restore_fbdev_mode_unlocked(struct=
 drm_fb_helper *fb_helper)
>                 return 0;
>
>         mutex_lock(&fb_helper->lock);
> -       ret =3D drm_client_modeset_commit(&fb_helper->client);
> +       if (force) {
> +               /*
> +                * Yes this is the _locked version which expects the mast=
er lock
> +                * to be held. But for forced restores we're intentionall=
y
> +                * racing here, see drm_fb_helper_set_par().
> +                */
> +               ret =3D drm_client_modeset_commit_locked(&fb_helper->clie=
nt);
> +       } else {
> +               ret =3D drm_client_modeset_commit(&fb_helper->client);
> +       }
>
>         do_delayed =3D fb_helper->delayed_hotplug;
>         if (do_delayed)
> @@ -262,6 +262,22 @@ int drm_fb_helper_restore_fbdev_mode_unlocked(struct=
 drm_fb_helper *fb_helper)
>
>         return ret;
>  }
> +
> +/**
> + * drm_fb_helper_restore_fbdev_mode_unlocked - restore fbdev configurati=
on
> + * @fb_helper: driver-allocated fbdev helper, can be NULL
> + *
> + * This should be called from driver's drm &drm_driver.lastclose callbac=
k
> + * when implementing an fbcon on top of kms using this helper. This ensu=
res that
> + * the user isn't greeted with a black screen when e.g. X dies.
> + *
> + * RETURNS:
> + * Zero if everything went ok, negative error code otherwise.
> + */
> +int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_h=
elper)
> +{
> +       return __drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, fal=
se);
> +}
>  EXPORT_SYMBOL(drm_fb_helper_restore_fbdev_mode_unlocked);
>
>  #ifdef CONFIG_MAGIC_SYSRQ
> @@ -1318,6 +1334,7 @@ int drm_fb_helper_set_par(struct fb_info *info)
>  {
>         struct drm_fb_helper *fb_helper =3D info->par;
>         struct fb_var_screeninfo *var =3D &info->var;
> +       bool force;
>
>         if (oops_in_progress)
>                 return -EBUSY;
> @@ -1327,7 +1344,25 @@ int drm_fb_helper_set_par(struct fb_info *info)
>                 return -EINVAL;
>         }
>
> -       drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper);
> +       /*
> +        * Normally we want to make sure that a kms master takes
> +        * precedence over fbdev, to avoid fbdev flickering and
> +        * occasionally stealing the display status. But Xorg first sets
> +        * the vt back to text mode using the KDSET IOCTL with KD_TEXT,
> +        * and only after that drops the master status when exiting.
> +        *
> +        * In the past this was caught by drm_fb_helper_lastclose(), but
> +        * on modern systems where logind always keeps a drm fd open to
> +        * orchestrate the vt switching, this doesn't work.
> +        *
> +        * To no break the userspace ABI we have this special case here,

"To not break"
With that fixed:
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

> +        * which is only used for the above case. Everything else uses
> +        * the normal commit function, which ensures that we never steal
> +        * the display from an active drm master.
> +        */
> +       force =3D var->activate & FB_ACTIVATE_KD_TEXT;
> +
> +       __drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, force);
>
>         return 0;
>  }
> diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/=
fbcon.c
> index 9d28a8e3328f..e2a490c5ae08 100644
> --- a/drivers/video/fbdev/core/fbcon.c
> +++ b/drivers/video/fbdev/core/fbcon.c
> @@ -2402,7 +2402,8 @@ static int fbcon_blank(struct vc_data *vc, int blan=
k, int mode_switch)
>                 ops->graphics =3D 1;
>
>                 if (!blank) {
> -                       var.activate =3D FB_ACTIVATE_NOW | FB_ACTIVATE_FO=
RCE;
> +                       var.activate =3D FB_ACTIVATE_NOW | FB_ACTIVATE_FO=
RCE |
> +                               FB_ACTIVATE_KD_TEXT;
>                         fb_set_var(info, &var);
>                         ops->graphics =3D 0;
>                         ops->var =3D info->var;
> diff --git a/include/uapi/linux/fb.h b/include/uapi/linux/fb.h
> index b6aac7ee1f67..4c14e8be7267 100644
> --- a/include/uapi/linux/fb.h
> +++ b/include/uapi/linux/fb.h
> @@ -205,6 +205,7 @@ struct fb_bitfield {
>  #define FB_ACTIVATE_ALL               64       /* change all VCs on this=
 fb    */
>  #define FB_ACTIVATE_FORCE     128      /* force apply even when no chang=
e*/
>  #define FB_ACTIVATE_INV_MODE  256       /* invalidate videomode */
> +#define FB_ACTIVATE_KD_TEXT   512       /* for KDSET vt ioctl */
>
>  #define FB_ACCELF_TEXT         1       /* (OBSOLETE) see fb_info.flags a=
nd vc_mode */
>
> --
> 2.27.0
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
