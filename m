Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15DAB16E99F
	for <lists+stable@lfdr.de>; Tue, 25 Feb 2020 16:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbgBYPJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Feb 2020 10:09:39 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:46368 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730317AbgBYPJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Feb 2020 10:09:39 -0500
Received: by mail-oi1-f195.google.com with SMTP id a22so12813527oid.13
        for <stable@vger.kernel.org>; Tue, 25 Feb 2020 07:09:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9cDwZ28udznvhBb1aAzh17WbQCMgWdUOeNZ0A/sEav4=;
        b=FuW/DWwXsO0+PsvmY7s51CHvYYSBFYyIaw28mlnjGepveGeUI8TqvZH4xWam+EOZd3
         yMnLu8sbTWOmm9/uOWtssG2rRwVcHVIxTAxrjpdFT/1REpnmBoVGmX7yzuknBUUwvx1c
         CZ+q7B5MPZcU4AFZJqsUhZiS5Tp8qqoylEN7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9cDwZ28udznvhBb1aAzh17WbQCMgWdUOeNZ0A/sEav4=;
        b=RfqOe8x+67l+kfif9TPtofXC6L4rcRaOFrVxh+lfdtHrTA401zTyg5nQKll2OlIysG
         eHfnzdfuYJ6bzQ9/f/qbotabcB1HNSaEPWuI1/lDsZOfpBtEtSQQ3p7bDeLRpj5GhTzO
         H6KTi5GAuKsOxJqTw38o8Soby955qF/W/ZnRy4U8Vf+ctaGsfvKyNAJI90UPr5dzXc/L
         /GVaJFtHc88AZpYpLKgWAXQfQiGBHQBM9TOjwyVFYC2HLQGWhlxMmIUsHrcw7f+xGMj1
         VhE1VTwjEHEtwbrA1ER8c6qYIKdPWi52UEnKPGY1XbRXKIlLCXF5Ri+UKt8LMBviz6aE
         Xchg==
X-Gm-Message-State: APjAAAU9n5mi+8n6EaFLVUlkdGF3UuHtEErgyPTugbKnoF2TKFT2MHtJ
        0IywNhTioGyh19pR3t7Ul9u9m8SDtpQnQMATD9hjDg==
X-Google-Smtp-Source: APXvYqzXoeHzDks1jVe82JmoFxt46VhHfpaYIYTIfpvJi7eCKumzsbsgXuiD5fiBxTklbaucHIRSdUF4M4oX5qmIL8Y=
X-Received: by 2002:a05:6808:10b:: with SMTP id b11mr4059228oie.110.1582643377746;
 Tue, 25 Feb 2020 07:09:37 -0800 (PST)
MIME-Version: 1.0
References: <20200225115024.2386811-1-daniel.vetter@ffwll.ch> <20200225144814.GC13686@intel.com>
In-Reply-To: <20200225144814.GC13686@intel.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Tue, 25 Feb 2020 16:09:26 +0100
Message-ID: <CAKMK7uFKJd1G8qT2Kup8nOfp22V7eQmDZC=6bdU=UEpqO7K3QQ@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm: avoid spurious EBUSY due to nonblocking
 atomic modesets
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Stone <daniels@collabora.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 25, 2020 at 3:48 PM Ville Syrj=C3=A4l=C3=A4
<ville.syrjala@linux.intel.com> wrote:
>
> On Tue, Feb 25, 2020 at 12:50:24PM +0100, Daniel Vetter wrote:
> > When doing an atomic modeset with ALLOW_MODESET drivers are allowed to
> > pull in arbitrary other resources, including CRTCs (e.g. when
> > reconfiguring global resources).
> >
> > But in nonblocking mode userspace has then no idea this happened,
> > which can lead to spurious EBUSY calls, both:
> > - when that other CRTC is currently busy doing a page_flip the
> >   ALLOW_MODESET commit can fail with an EBUSY
> > - on the other CRTC a normal atomic flip can fail with EBUSY because
> >   of the additional commit inserted by the kernel without userspace's
> >   knowledge
> >
> > For blocking commits this isn't a problem, because everyone else will
> > just block until all the CRTC are reconfigured. Only thing userspace
> > can notice is the dropped frames without any reason for why frames got
> > dropped.
> >
> > Consensus is that we need new uapi to handle this properly, but no one
> > has any idea what exactly the new uapi should look like. As a stop-gap
> > plug this problem by demoting nonblocking commits which might cause
> > issues by including CRTCs not in the original request to blocking
> > commits.
> >
> > v2: Add comments and a WARN_ON to enforce this only when allowed - we
> > don't want to silently convert page flips into blocking plane updates
> > just because the driver is buggy.
> >
> > v3: Fix inverted WARN_ON (Pekka).
> >
> > References: https://lists.freedesktop.org/archives/dri-devel/2018-July/=
182281.html
> > Bugzilla: https://gitlab.freedesktop.org/wayland/weston/issues/24#note_=
9568
> > Cc: Daniel Stone <daniel@fooishbar.org>
> > Cc: Pekka Paalanen <pekka.paalanen@collabora.co.uk>
> > Cc: stable@vger.kernel.org
> > Reviewed-by: Daniel Stone <daniels@collabora.com>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > ---
> >  drivers/gpu/drm/drm_atomic.c | 34 +++++++++++++++++++++++++++++++---
> >  1 file changed, 31 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.=
c
> > index 9ccfbf213d72..4c035abf98b8 100644
> > --- a/drivers/gpu/drm/drm_atomic.c
> > +++ b/drivers/gpu/drm/drm_atomic.c
> > @@ -1362,15 +1362,43 @@ EXPORT_SYMBOL(drm_atomic_commit);
> >  int drm_atomic_nonblocking_commit(struct drm_atomic_state *state)
> >  {
> >       struct drm_mode_config *config =3D &state->dev->mode_config;
> > -     int ret;
> > +     unsigned requested_crtc =3D 0;
> > +     unsigned affected_crtc =3D 0;
> > +     struct drm_crtc *crtc;
> > +     struct drm_crtc_state *crtc_state;
> > +     bool nonblocking =3D true;
> > +     int ret, i;
> > +
> > +     /*
> > +      * For commits that allow modesets drivers can add other CRTCs to=
 the
> > +      * atomic commit, e.g. when they need to reallocate global resour=
ces.
> > +      *
> > +      * But when userspace also requests a nonblocking commit then use=
rspace
> > +      * cannot know that the commit affects other CRTCs, which can res=
ult in
> > +      * spurious EBUSY failures. Until we have better uapi plug this b=
y
> > +      * demoting such commits to blocking mode.
> > +      */
> > +     for_each_new_crtc_in_state(state, crtc, crtc_state, i)
> > +             requested_crtc |=3D drm_crtc_mask(crtc);
> >
> >       ret =3D drm_atomic_check_only(state);
> >       if (ret)
> >               return ret;
> >
> > -     DRM_DEBUG_ATOMIC("committing %p nonblocking\n", state);
> > +     for_each_new_crtc_in_state(state, crtc, crtc_state, i)
> > +             affected_crtc |=3D drm_crtc_mask(crtc);
> > +
> > +     if (affected_crtc !=3D requested_crtc) {
> > +             /* adding other CRTC is only allowed for modeset commits =
*/
> > +             WARN_ON(!state->allow_modeset);
>
> Not sure that's really true. What if the driver needs to eg.
> redistribute FIFO space or something between the pipes? Or do we
> expect drivers to now examine state->allow_modeset to figure out
> if they're allowed to do certain things?

Maybe we need more fine-grained flags here, but adding other states
(and blocking a commit flow) is exactly the uapi headaches this patch
tries to solve here. So if our driver currently adds crtc states to
reallocate fifo between pipes for an atomic flip then yes we're
breaking userspace. Well, everyone figured out by now that you get
random EBUSY and dropped frames for no apparent reason at all, and
work around it. But happy, they are not.

Also we've already crossed that bridge a bit with mucking around with
allow_modeset from driver code with the self refresh helpers.

Cheers, Daniel

>
> > +
> > +             DRM_DEBUG_ATOMIC("demoting %p to blocking mode to avoid E=
BUSY\n", state);
> > +             nonblocking =3D false;
> > +     } else {
> > +             DRM_DEBUG_ATOMIC("committing %p nonblocking\n", state);
> > +     }
> >
> > -     return config->funcs->atomic_commit(state->dev, state, true);
> > +     return config->funcs->atomic_commit(state->dev, state, nonblockin=
g);
> >  }
> >  EXPORT_SYMBOL(drm_atomic_nonblocking_commit);
> >
> > --
> > 2.24.1
> >
> > _______________________________________________
> > Intel-gfx mailing list
> > Intel-gfx@lists.freedesktop.org
> > https://lists.freedesktop.org/mailman/listinfo/intel-gfx
>
> --
> Ville Syrj=C3=A4l=C3=A4
> Intel



--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
