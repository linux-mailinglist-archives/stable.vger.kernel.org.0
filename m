Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597C2AA5B8
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 16:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbfIEOZZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 10:25:25 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43275 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387471AbfIEOZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 10:25:25 -0400
Received: by mail-ot1-f65.google.com with SMTP id b2so2339033otq.10
        for <stable@vger.kernel.org>; Thu, 05 Sep 2019 07:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E+RP5UlEdwnE5M3v207zco80S1MuGtzYQwRYbxNgOvM=;
        b=jI/0I8lY8nJ9WQA4xJuS6FgJO72verEKAZMd4CxkGU4gsWXhALk0pk/tQRSV9Vaxze
         5wuNi8KNcP4mUCv8ZhOvSZbARnpePMk8CrtPfJndR8flsu3K+q+E3yMvS25RxvxKleUh
         abs/G91wGAs+S3spH+xs8Nwd+oEE45Bfz5wLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E+RP5UlEdwnE5M3v207zco80S1MuGtzYQwRYbxNgOvM=;
        b=UsYmHH+t+NnQ50e+G1YqqymLC3bPw/lI1m2G5eTXChGD7eqWD43qsng8lIrugJXS8Y
         crJopwSpNkeCVqtmcrZlib8IMHeXFTtY8FnS72MI/cNqKGEfnjAdXKDxcz0goRNE1Yud
         1yoQToGEBMe/+Ol7aEBjga96gesNVg/FdaPBypbBjuKT+oa4HQ0wJkEqh4ihyCDX7MmD
         3JJsu36wmM5dzFHUQGCA5ZeMEa+PmykQvU4Qn5zsMUgQ6iW9y2oqfjHqp5IP+jrl2iN2
         os/HQnUoSEluNPo8S5OCjZ1eZu2QRiJQW2wQNG7Mmsxly6uS9MAlhT++qnZvstf2/dip
         t8WA==
X-Gm-Message-State: APjAAAUNKyhUwT+V2zCwTDe+515w5lAjx1aA5mX0qdhowbmbup6OCxE1
        VH3Kp6STU+zikrndKX4Q2+lNX6jJCSXEfhsTvj7p4g==
X-Google-Smtp-Source: APXvYqzPGW08/2WIrfFIz0HDgHG9P+F7pfa5hXKBnhQMHqoAvEFFLe1cP1f0Al3v+E/uRB/fdkMD7qaNyG25yEktgHw=
X-Received: by 2002:a9d:7006:: with SMTP id k6mr2797974otj.303.1567693524288;
 Thu, 05 Sep 2019 07:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190903190642.32588-1-daniel.vetter@ffwll.ch> <ed222af0-4d87-88eb-1de0-4020a7cf6cf3@linux.intel.com>
In-Reply-To: <ed222af0-4d87-88eb-1de0-4020a7cf6cf3@linux.intel.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu, 5 Sep 2019 16:25:13 +0200
Message-ID: <CAKMK7uEjMJZ67hhHKRo0_Drx8NpcuxWoC6VN_JqONrkhZ831Tg@mail.gmail.com>
Subject: Re: [PATCH 1/3] drm/atomic: Take the atomic toys away from X
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Alex Deucher <alexdeucher@gmail.com>,
        Adam Jackson <ajax@redhat.com>, Sean Paul <sean@poorly.run>,
        David Airlie <airlied@linux.ie>,
        stable <stable@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 5, 2019 at 4:19 PM Maarten Lankhorst
<maarten.lankhorst@linux.intel.com> wrote:
>
> Op 03-09-2019 om 21:06 schreef Daniel Vetter:
> > The -modesetting ddx has a totally broken idea of how atomic works:
> > - doesn't disable old connectors, assuming they get auto-disable like
> >   with the legacy setcrtc
> > - assumes ASYNC_FLIP is wired through for the atomic ioctl
> > - not a single call to TEST_ONLY
> >
> > Iow the implementation is a 1:1 translation of legacy ioctls to
> > atomic, which is a) broken b) pointless.
> >
> > We already have bugs in both i915 and amdgpu-DC where this prevents us
> > from enabling neat features.
> >
> > If anyone ever cares about atomic in X we can easily add a new atomic
> > level (req->value =3D=3D 2) for X to get back the shiny toys.
> >
> > Since these broken versions of -modesetting have been shipping,
> > there's really no other way to get out of this bind.
> >
> > References: https://gitlab.freedesktop.org/xorg/xserver/issues/629
> > References: https://gitlab.freedesktop.org/xorg/xserver/merge_requests/=
180
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Michel D=C3=A4nzer <michel@daenzer.net>
> > Cc: Alex Deucher <alexdeucher@gmail.com>
> > Cc: Adam Jackson <ajax@redhat.com>
> > Cc: Sean Paul <sean@poorly.run>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > ---
> >  drivers/gpu/drm/drm_ioctl.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
> > index 2c120c58f72d..1cb7b4c3c87c 100644
> > --- a/drivers/gpu/drm/drm_ioctl.c
> > +++ b/drivers/gpu/drm/drm_ioctl.c
> > @@ -334,6 +334,9 @@ drm_setclientcap(struct drm_device *dev, void *data=
, struct drm_file *file_priv)
> >               file_priv->universal_planes =3D req->value;
> >               break;
> >       case DRM_CLIENT_CAP_ATOMIC:
> > +             /* The modesetting DDX has a totally broken idea of atomi=
c. */
> > +             if (strstr(current->comm, "X"))
> > +                     return -EOPNOTSUPP;
> >               if (!drm_core_check_feature(dev, DRIVER_ATOMIC))
> >                       return -EOPNOTSUPP;
> >               if (req->value > 1)
>
> Good riddance!
>
> Missing one more:
> commit abbc0697d5fbf53f74ce0bcbe936670199764cfa
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Wed Apr 24 16:33:29 2019 +1000
>
>     drm/fb: revert the i915 Actually configure untiled displays from mast=
er
>
>     This code moved in here in master, so revert it the same way.
>
>     This is the same revert as 9fa246256e09 ("Revert "drm/i915/fbdev:
>     Actually configure untiled displays"") in drm-fixes.
>
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> Can we unrevert that now?

My idea is to land this in drm-misc-fixes first (or maybe
drm-misc-next-fixes). And then we can land the revert of the revert
once that's backmerged into drm-intel. -fixes since this one here is
cc: stable.

And yes I'll add a reference to that one in the commit message when merging=
.

> With that fixed, on the whole series:
>
> Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>

Thanks, Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
