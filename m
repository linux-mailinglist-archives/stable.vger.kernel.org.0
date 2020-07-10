Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0A221B535
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 14:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGJMid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 08:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgGJMid (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 08:38:33 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80B7C08C5CE
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 05:38:32 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id x83so4634834oif.10
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 05:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=08ZcktxTO10xoX+Q5v0Z1idL1b3n6Q7rtcIJ/2he/VA=;
        b=Qw9JDAtOPDsyHhqyIjYoRxhyCJeUUkNFXCA/EsdzEB3myHFHEWVtCiUQt/syYunNGl
         kE+wvhxB5N25jgk0UBfZIw88A1CKFXtRGuVuEa28nSNLnrMhSOqh6jPsHLaUBSIhsDtc
         4Z8W2H/5PLdFG1c3bC2yWvbgTYYqHCehFgz7E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=08ZcktxTO10xoX+Q5v0Z1idL1b3n6Q7rtcIJ/2he/VA=;
        b=nP/L34BH65kztmNFwr2IWrSrQL/1FVEfRgLMZakKj15je9d3SWBCvsTp2RCk224jUM
         kZ9L/v/8m8WfFedGWJRWOKPIx1PstSvd8SKPPL6Q6ubch/YWypQXMRRpBtY58auhKgnB
         Rt14XHIfDV52Mv6f0tYy5AUx3sNfz7O6LW1Kd5ihl+7dU24af7tcmL/C3KcCt25SZ98C
         ybLv88wf1H8csAb7lCz973vDWLzGKNaVWyTKNlLu1hidOtiawgxH6WNsPcCiztwmL83B
         v7+9cOO47ZuJgEfrf/G0uInwc1e0yFsJb4e4mtoXtsQKiVgwZnk0qAYwQNoQLzQ7QgwZ
         GcOg==
X-Gm-Message-State: AOAM530FXQZRdPuR7ctNCoa3dhm6z7PFjhfEwAlTCGM/xlerTviJoWpb
        XcZ7cr9flOzLjiMHRAIKYA2rBGhMlgNM8SdgGEXelSeS
X-Google-Smtp-Source: ABdhPJxwAGJgXEBx0bB7ow7my2bGgc+2hpKGXEc3867g+wUzcDszHfYx/ehJkx2M5H4i3UQozKyjGSc3aeAtWJXS9w4=
X-Received: by 2002:aca:da03:: with SMTP id r3mr4073986oig.14.1594384712295;
 Fri, 10 Jul 2020 05:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200623155456.3092836-1-daniel.vetter@ffwll.ch> <ac847c3c-e93c-4a4b-c6ca-2362af7e3aa3@suse.de>
In-Reply-To: <ac847c3c-e93c-4a4b-c6ca-2362af7e3aa3@suse.de>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri, 10 Jul 2020 14:38:21 +0200
Message-ID: <CAKMK7uFi0nkf1fSUZaqff-oskoTKMS0Rh_69_Sd9JQ69NMhOMA@mail.gmail.com>
Subject: Re: [PATCH] drm/fb-helper: Fix vt restore
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        shlomo@fastmail.com, stable <stable@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 10, 2020 at 1:31 PM Thomas Zimmermann <tzimmermann@suse.de> wro=
te:
>
> Hi Daniel,
>
> this patch might not be enougth. I started Xorg and then did 'kill -9'
> on the Xorg process. Xorg went away, but the console did not come back.

Hm don't you need to reset your terminal to text mode in that case
first? Iirc there's a sysrq. All again assuming not terribly modern
system where that stuff is all done by logind.
-Daniel

>
> Best regards
> Thomas
>
> Am 23.06.20 um 17:54 schrieb Daniel Vetter:
> > In the past we had a pile of hacks to orchestrate access between fbdev
> > emulation and native kms clients. We've tried to streamline this, by
> > always preferring the kms side above fbdev calls when a drm master
> > exists, because drm master controls access to the display resources.
> >
> > Unfortunately this breaks existing userspace, specifically Xorg. When
> > exiting Xorg first restores the console to text mode using the KDSET
> > ioctl on the vt. This does nothing, because a drm master is still
> > around. Then it drops the drm master status, which again does nothing,
> > because logind is keeping additional drm fd open to be able to
> > orchestrate vt switches. In the past this is the point where fbdev was
> > restored, as part of the ->lastclose hook on the drm side.
> >
> > Now to fix this regression we don't want to go back to letting fbdev
> > restore things whenever it feels like, or to the pile of hacks we've
> > had before. Instead try and go with a minimal exception to make the
> > KDSET case work again, and nothing else.
> >
> > This means that if userspace does a KDSET call when switching between
> > graphical compositors, there will be some flickering with fbcon
> > showing up for a bit. But a) that's not a regression and b) userspace
> > can fix it by improving the vt switching dance - logind should have
> > all the information it needs.
> >
> > While pondering all this I'm also wondering wheter we should have a
> > SWITCH_MASTER ioctl to allow race-free master status handover. But
> > that's for another day.
> >
> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D208179
> > Cc: shlomo@fastmail.com
> > Reported-and-Tested-by: shlomo@fastmail.com
> > Cc: Michel D=C3=A4nzer <michel@daenzer.net>
> > Fixes: 64914da24ea9 ("drm/fbdev-helper: don't force restores")
> > Cc: Noralf Tr=C3=B8nnes <noralf@tronnes.org>
> > Cc: Thomas Zimmermann <tzimmermann@suse.de>
> > Cc: Daniel Vetter <daniel.vetter@intel.com>
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Maxime Ripard <mripard@kernel.org>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: Daniel Vetter <daniel@ffwll.ch>
> > Cc: dri-devel@lists.freedesktop.org
> > Cc: <stable@vger.kernel.org> # v5.7+
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > ---
> >  drivers/gpu/drm/drm_fb_helper.c  | 63 +++++++++++++++++++++++++-------
> >  drivers/video/fbdev/core/fbcon.c |  3 +-
> >  include/uapi/linux/fb.h          |  1 +
> >  3 files changed, 52 insertions(+), 15 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_h=
elper.c
> > index 170aa7689110..ae69bf8e9bcc 100644
> > --- a/drivers/gpu/drm/drm_fb_helper.c
> > +++ b/drivers/gpu/drm/drm_fb_helper.c
> > @@ -227,18 +227,9 @@ int drm_fb_helper_debug_leave(struct fb_info *info=
)
> >  }
> >  EXPORT_SYMBOL(drm_fb_helper_debug_leave);
> >
> > -/**
> > - * drm_fb_helper_restore_fbdev_mode_unlocked - restore fbdev configura=
tion
> > - * @fb_helper: driver-allocated fbdev helper, can be NULL
> > - *
> > - * This should be called from driver's drm &drm_driver.lastclose callb=
ack
> > - * when implementing an fbcon on top of kms using this helper. This en=
sures that
> > - * the user isn't greeted with a black screen when e.g. X dies.
> > - *
> > - * RETURNS:
> > - * Zero if everything went ok, negative error code otherwise.
> > - */
> > -int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb=
_helper)
> > +static int
> > +__drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb_h=
elper,
> > +                                         bool force)
> >  {
> >       bool do_delayed;
> >       int ret;
> > @@ -250,7 +241,16 @@ int drm_fb_helper_restore_fbdev_mode_unlocked(stru=
ct drm_fb_helper *fb_helper)
> >               return 0;
> >
> >       mutex_lock(&fb_helper->lock);
> > -     ret =3D drm_client_modeset_commit(&fb_helper->client);
> > +     if (force) {
> > +             /*
> > +              * Yes this is the _locked version which expects the mast=
er lock
> > +              * to be held. But for forced restores we're intentionall=
y
> > +              * racing here, see drm_fb_helper_set_par().
> > +              */
> > +             ret =3D drm_client_modeset_commit_locked(&fb_helper->clie=
nt);
> > +     } else {
> > +             ret =3D drm_client_modeset_commit(&fb_helper->client);
> > +     }
> >
> >       do_delayed =3D fb_helper->delayed_hotplug;
> >       if (do_delayed)
> > @@ -262,6 +262,22 @@ int drm_fb_helper_restore_fbdev_mode_unlocked(stru=
ct drm_fb_helper *fb_helper)
> >
> >       return ret;
> >  }
> > +
> > +/**
> > + * drm_fb_helper_restore_fbdev_mode_unlocked - restore fbdev configura=
tion
> > + * @fb_helper: driver-allocated fbdev helper, can be NULL
> > + *
> > + * This should be called from driver's drm &drm_driver.lastclose callb=
ack
> > + * when implementing an fbcon on top of kms using this helper. This en=
sures that
> > + * the user isn't greeted with a black screen when e.g. X dies.
> > + *
> > + * RETURNS:
> > + * Zero if everything went ok, negative error code otherwise.
> > + */
> > +int drm_fb_helper_restore_fbdev_mode_unlocked(struct drm_fb_helper *fb=
_helper)
> > +{
> > +     return __drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, fal=
se);
> > +}
> >  EXPORT_SYMBOL(drm_fb_helper_restore_fbdev_mode_unlocked);
> >
> >  #ifdef CONFIG_MAGIC_SYSRQ
> > @@ -1318,6 +1334,7 @@ int drm_fb_helper_set_par(struct fb_info *info)
> >  {
> >       struct drm_fb_helper *fb_helper =3D info->par;
> >       struct fb_var_screeninfo *var =3D &info->var;
> > +     bool force;
> >
> >       if (oops_in_progress)
> >               return -EBUSY;
> > @@ -1327,7 +1344,25 @@ int drm_fb_helper_set_par(struct fb_info *info)
> >               return -EINVAL;
> >       }
> >
> > -     drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper);
> > +     /*
> > +      * Normally we want to make sure that a kms master takes
> > +      * precedence over fbdev, to avoid fbdev flickering and
> > +      * occasionally stealing the display status. But Xorg first sets
> > +      * the vt back to text mode using the KDSET IOCTL with KD_TEXT,
> > +      * and only after that drops the master status when exiting.
> > +      *
> > +      * In the past this was caught by drm_fb_helper_lastclose(), but
> > +      * on modern systems where logind always keeps a drm fd open to
> > +      * orchestrate the vt switching, this doesn't work.
> > +      *
> > +      * To no break the userspace ABI we have this special case here,
> > +      * which is only used for the above case. Everything else uses
> > +      * the normal commit function, which ensures that we never steal
> > +      * the display from an active drm master.
> > +      */
> > +     force =3D var->activate & FB_ACTIVATE_KD_TEXT;
> > +
> > +     __drm_fb_helper_restore_fbdev_mode_unlocked(fb_helper, force);
> >
> >       return 0;
> >  }
> > diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/cor=
e/fbcon.c
> > index 9d28a8e3328f..e2a490c5ae08 100644
> > --- a/drivers/video/fbdev/core/fbcon.c
> > +++ b/drivers/video/fbdev/core/fbcon.c
> > @@ -2402,7 +2402,8 @@ static int fbcon_blank(struct vc_data *vc, int bl=
ank, int mode_switch)
> >               ops->graphics =3D 1;
> >
> >               if (!blank) {
> > -                     var.activate =3D FB_ACTIVATE_NOW | FB_ACTIVATE_FO=
RCE;
> > +                     var.activate =3D FB_ACTIVATE_NOW | FB_ACTIVATE_FO=
RCE |
> > +                             FB_ACTIVATE_KD_TEXT;
> >                       fb_set_var(info, &var);
> >                       ops->graphics =3D 0;
> >                       ops->var =3D info->var;
> > diff --git a/include/uapi/linux/fb.h b/include/uapi/linux/fb.h
> > index b6aac7ee1f67..4c14e8be7267 100644
> > --- a/include/uapi/linux/fb.h
> > +++ b/include/uapi/linux/fb.h
> > @@ -205,6 +205,7 @@ struct fb_bitfield {
> >  #define FB_ACTIVATE_ALL             64       /* change all VCs on this=
 fb    */
> >  #define FB_ACTIVATE_FORCE     128    /* force apply even when no chang=
e*/
> >  #define FB_ACTIVATE_INV_MODE  256       /* invalidate videomode */
> > +#define FB_ACTIVATE_KD_TEXT   512       /* for KDSET vt ioctl */
> >
> >  #define FB_ACCELF_TEXT               1       /* (OBSOLETE) see fb_info=
.flags and vc_mode */
> >
> >
>
> --
> Thomas Zimmermann
> Graphics Driver Developer
> SUSE Software Solutions Germany GmbH
> Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
> (HRB 36809, AG N=C3=BCrnberg)
> Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=B6rffer
>


--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
