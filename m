Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4211A2544
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 17:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgDHPeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 11:34:50 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38396 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbgDHPet (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Apr 2020 11:34:49 -0400
Received: by mail-ot1-f65.google.com with SMTP id t28so7179106ott.5
        for <stable@vger.kernel.org>; Wed, 08 Apr 2020 08:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K6kuZ26CWF862u+YAgOFKjz0URhYlPzxaTNumInGnYM=;
        b=WUYosuCoPQIiZ/7e5EhdyNCObUcn0FUDWb5yz3qvn8YkGPJZ3rcOhss0iHr/w5LV06
         iV7KFB8ALqoafI6NCyBjOwKazwENH+qgsBdMXRZQKplKKjuMBKJ9wZJujBdN35qNmr5J
         YC/hgmLIsxBsdhTeSV/Gh9TEFgm6h07xs/tzc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K6kuZ26CWF862u+YAgOFKjz0URhYlPzxaTNumInGnYM=;
        b=RNw5VsLHvJs13WShnurLsn69XdY2LfbdEOdm27Ko9TB1xig5zIYsqTmRnRFx+cBE4W
         AjoamWKhSFkzmG91kRpyuc8iyK1RGqGVfHcndDSLHFEPvKoWOMVmxVVXj277nzsP+EaZ
         QoLknu8GQG9Hyl/J0MQBKBcytrz8ci6z3Vq25f4QiUNi5p/O0nnjlx6yAlq3eKhBuz+k
         2q+3KJ/E4gw8mDUmqsJIcJabQlTjTu2tcUNfcg6QCnGu4D2+7w1/qKpTZvlIo5YXzIi5
         o66h19nIZo72d4ouiT+IZxhn75ONNc1EqxcEtJaGUyWlc0eQ95UWQYo+7ga41VdRaFA6
         EyFw==
X-Gm-Message-State: AGi0Pub/h1HS5JZtBZTOsDKf+w+if9WscFY3ELhLJdlqrB/n9JWuaYu+
        dgJwSBCqEl1cQxlYa+NDileiUGPqihk+te5y9a3fUQ==
X-Google-Smtp-Source: APiQypKRH5lC3ZTSO/hYsts/TmDhcuGS/bvDfGxUjfhh3FkRXfQjReAUOJhcICyiOhiZeOh7lGRSHx7m0zcAOKcz0AI=
X-Received: by 2002:a9d:2056:: with SMTP id n80mr6403788ota.281.1586360088211;
 Wed, 08 Apr 2020 08:34:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200225115024.2386811-1-daniel.vetter@ffwll.ch>
 <20200225144814.GC13686@intel.com> <CAKMK7uFKJd1G8qT2Kup8nOfp22V7eQmDZC=6bdU=UEpqO7K3QQ@mail.gmail.com>
 <20200225153400.GE13686@intel.com> <20200408140327.GT6112@intel.com>
In-Reply-To: <20200408140327.GT6112@intel.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 8 Apr 2020 17:34:35 +0200
Message-ID: <CAKMK7uEpMomx4XCXnX7m_xLapUFpR7c2jU2DqBTzgVrk8R-Cew@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm: avoid spurious EBUSY due to nonblocking
 atomic modesets
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     Daniel Stone <daniels@collabora.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        stable <stable@vger.kernel.org>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 8, 2020 at 4:03 PM Ville Syrj=C3=A4l=C3=A4
<ville.syrjala@linux.intel.com> wrote:
>
> On Tue, Feb 25, 2020 at 05:34:00PM +0200, Ville Syrj=C3=A4l=C3=A4 wrote:
> > On Tue, Feb 25, 2020 at 04:09:26PM +0100, Daniel Vetter wrote:
> > > On Tue, Feb 25, 2020 at 3:48 PM Ville Syrj=C3=A4l=C3=A4
> > > <ville.syrjala@linux.intel.com> wrote:
> > > >
> > > > On Tue, Feb 25, 2020 at 12:50:24PM +0100, Daniel Vetter wrote:
> > > > > When doing an atomic modeset with ALLOW_MODESET drivers are allow=
ed to
> > > > > pull in arbitrary other resources, including CRTCs (e.g. when
> > > > > reconfiguring global resources).
> > > > >
> > > > > But in nonblocking mode userspace has then no idea this happened,
> > > > > which can lead to spurious EBUSY calls, both:
> > > > > - when that other CRTC is currently busy doing a page_flip the
> > > > >   ALLOW_MODESET commit can fail with an EBUSY
> > > > > - on the other CRTC a normal atomic flip can fail with EBUSY beca=
use
> > > > >   of the additional commit inserted by the kernel without userspa=
ce's
> > > > >   knowledge
> > > > >
> > > > > For blocking commits this isn't a problem, because everyone else =
will
> > > > > just block until all the CRTC are reconfigured. Only thing usersp=
ace
> > > > > can notice is the dropped frames without any reason for why frame=
s got
> > > > > dropped.
> > > > >
> > > > > Consensus is that we need new uapi to handle this properly, but n=
o one
> > > > > has any idea what exactly the new uapi should look like. As a sto=
p-gap
> > > > > plug this problem by demoting nonblocking commits which might cau=
se
> > > > > issues by including CRTCs not in the original request to blocking
> > > > > commits.
> > > > >
> > > > > v2: Add comments and a WARN_ON to enforce this only when allowed =
- we
> > > > > don't want to silently convert page flips into blocking plane upd=
ates
> > > > > just because the driver is buggy.
> > > > >
> > > > > v3: Fix inverted WARN_ON (Pekka).
> > > > >
> > > > > References: https://lists.freedesktop.org/archives/dri-devel/2018=
-July/182281.html
> > > > > Bugzilla: https://gitlab.freedesktop.org/wayland/weston/issues/24=
#note_9568
> > > > > Cc: Daniel Stone <daniel@fooishbar.org>
> > > > > Cc: Pekka Paalanen <pekka.paalanen@collabora.co.uk>
> > > > > Cc: stable@vger.kernel.org
> > > > > Reviewed-by: Daniel Stone <daniels@collabora.com>
> > > > > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > > > > ---
> > > > >  drivers/gpu/drm/drm_atomic.c | 34 ++++++++++++++++++++++++++++++=
+---
> > > > >  1 file changed, 31 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_a=
tomic.c
> > > > > index 9ccfbf213d72..4c035abf98b8 100644
> > > > > --- a/drivers/gpu/drm/drm_atomic.c
> > > > > +++ b/drivers/gpu/drm/drm_atomic.c
> > > > > @@ -1362,15 +1362,43 @@ EXPORT_SYMBOL(drm_atomic_commit);
> > > > >  int drm_atomic_nonblocking_commit(struct drm_atomic_state *state=
)
> > > > >  {
> > > > >       struct drm_mode_config *config =3D &state->dev->mode_config=
;
> > > > > -     int ret;
> > > > > +     unsigned requested_crtc =3D 0;
> > > > > +     unsigned affected_crtc =3D 0;
> > > > > +     struct drm_crtc *crtc;
> > > > > +     struct drm_crtc_state *crtc_state;
> > > > > +     bool nonblocking =3D true;
> > > > > +     int ret, i;
> > > > > +
> > > > > +     /*
> > > > > +      * For commits that allow modesets drivers can add other CR=
TCs to the
> > > > > +      * atomic commit, e.g. when they need to reallocate global =
resources.
> > > > > +      *
> > > > > +      * But when userspace also requests a nonblocking commit th=
en userspace
> > > > > +      * cannot know that the commit affects other CRTCs, which c=
an result in
> > > > > +      * spurious EBUSY failures. Until we have better uapi plug =
this by
> > > > > +      * demoting such commits to blocking mode.
> > > > > +      */
> > > > > +     for_each_new_crtc_in_state(state, crtc, crtc_state, i)
> > > > > +             requested_crtc |=3D drm_crtc_mask(crtc);
> > > > >
> > > > >       ret =3D drm_atomic_check_only(state);
> > > > >       if (ret)
> > > > >               return ret;
> > > > >
> > > > > -     DRM_DEBUG_ATOMIC("committing %p nonblocking\n", state);
> > > > > +     for_each_new_crtc_in_state(state, crtc, crtc_state, i)
> > > > > +             affected_crtc |=3D drm_crtc_mask(crtc);
> > > > > +
> > > > > +     if (affected_crtc !=3D requested_crtc) {
> > > > > +             /* adding other CRTC is only allowed for modeset co=
mmits */
> > > > > +             WARN_ON(!state->allow_modeset);
> > > >
> > > > Not sure that's really true. What if the driver needs to eg.
> > > > redistribute FIFO space or something between the pipes? Or do we
> > > > expect drivers to now examine state->allow_modeset to figure out
> > > > if they're allowed to do certain things?
> > >
> > > Maybe we need more fine-grained flags here, but adding other states
> > > (and blocking a commit flow) is exactly the uapi headaches this patch
> > > tries to solve here. So if our driver currently adds crtc states to
> > > reallocate fifo between pipes for an atomic flip then yes we're
> > > breaking userspace. Well, everyone figured out by now that you get
> > > random EBUSY and dropped frames for no apparent reason at all, and
> > > work around it. But happy, they are not.
> >
> > I don't think we do this currently for the FIFO, but in theory we
> > could.
> >
> > The one thing we might do currently is cdclk reprogramming, but that
> > can only happen without a full modeset when there's only a single
> > active pipe. So we shouldn't hit this right now. But that restriction
> > is going to disappear in the future, at which point we may want to
> > do this even with multiple active pipes.
>
> Looks like we're hitting something like this on some CI systems.
> After a bit of pondering I guess we could fix that by not sending
> out any flips events until all crtcs have finished the commit. Not
> a full solution though as it can't help if there are multiple threads
> trying to commit independently on different CRTC and one thread
> happens to need a full modeset on all CRTCs. But seems like it
> should solve the the single threaded CI fails we're seeing.

Well it's more annoying, since I typed this patch last we gained some
igt which actually check that we can push through commits
indepedently, which now fail on latest gen and so CI tells me "you
can't merge this patch".

Also note that this here is just a userspace api issue, ordering
commits more carefully can't fix anything here.

I guess maybe we should just merge this patch meanwhile and tell CI
that the breakage is expected.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
