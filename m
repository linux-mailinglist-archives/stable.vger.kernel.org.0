Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9D727547F
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 11:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgIWJ0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 05:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIWJ0v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 05:26:51 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6535CC0613CE
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 02:26:51 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id a2so18303634otr.11
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 02:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Fwy9i1khoLax7Hq0RUO99NG0b7ul7bbEQzOnfJCcIbQ=;
        b=UlyZU+HgWiO3UIcvpWl2oSGsC4e/ksDINGbPAM8WHyY3Kgho5zZluah6DwgzKjpKcQ
         FBlK7yWi6S6i+PZB5zHXUIRIHDX6AkrtBbI/GPzmGxpf9CmyEZDKy7bNoj51D68ca3oo
         PujGzLpArRKhpACmxQZgfBQkehApCAckq1KVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Fwy9i1khoLax7Hq0RUO99NG0b7ul7bbEQzOnfJCcIbQ=;
        b=TpXErqRUb9kObA7ZH9Eox//uIQenz1bisLdvVm7ceZNaREeDxJJaREYucYX9Kpjkbe
         fqfH5CyUqUZPD3xplkJvlZuHjRDbitd71/Jw/Gnvt/KY0GJhpnBmre3bu8gXyo2IDOHe
         5QXO5sUFLilv6qj1ffACGQljK+clfZ4QrhdYgsf6ceS3PZPTL5vfbQNY0xrJuvJNCXsh
         6Zj5ub9/YWAOAoD7VvXs9pVe3tk2q5lRI7HOHaABuzL6XcA/+z5uCwMXWFeDoc8wdQ9a
         oLBRWdHaPdAdnDrgtkW3u1a15zEBZeZfS9rwCt2BWTyMLp3fl2byXSHIY0fDdi50zFq3
         fpYg==
X-Gm-Message-State: AOAM533gUx/4RbbSba38sk+YVPq3zeE1m79zXswXa1eTzjLm8rypuGHi
        6c72L6t2yP7sEkkBW5OTWeMXPLEyjIsgZzyrfTCpKQ==
X-Google-Smtp-Source: ABdhPJyJf/2ipzjDzTUbuzwUwjZNd9XcNNVSN3n3xKYP5sa9e1YgkcwA+GZU9AA4OeLZBswlQE31AGllTFWvEjpMF4A=
X-Received: by 2002:a05:6830:14d9:: with SMTP id t25mr5804565otq.188.1600853210764;
 Wed, 23 Sep 2020 02:26:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200922181834.2913552-1-daniel.vetter@ffwll.ch> <20200923111717.68d9eb51@eldfell>
In-Reply-To: <20200923111717.68d9eb51@eldfell>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 23 Sep 2020 11:26:39 +0200
Message-ID: <CAKMK7uFvaMRK3Zh-s21OG=V3sPQZjn7Z_WQaNMcL=_R36enR2g@mail.gmail.com>
Subject: Re: [PATCH] drm: document and enforce rules around "spurious" EBUSY
 from atomic_commit
To:     Pekka Paalanen <ppaalanen@gmail.com>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Stone <daniel@fooishbar.org>,
        Simon Ser <contact@emersion.fr>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm really not awake yet ...

On Wed, Sep 23, 2020 at 10:17 AM Pekka Paalanen <ppaalanen@gmail.com> wrote:
>
> On Tue, 22 Sep 2020 20:18:34 +0200
> Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>
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
> > has any idea what exactly the new uapi should look like. Since this
> > has been shipping for years already compositors need to deal no matter
> > what, so as a first step just try to enforce this across drivers
> > better with some checks.
> >
> > v2: Add comments and a WARN_ON to enforce this only when allowed - we
> > don't want to silently convert page flips into blocking plane updates
> > just because the driver is buggy.
> >
> > v3: Fix inverted WARN_ON (Pekka).
> >
> > v4: Drop the uapi changes, only add a WARN_ON for now to enforce some
> > rules for drivers.
>
> Dropped all addresses, because gmail refused to send this email
> otherwise.
>
> > ---
> >  drivers/gpu/drm/drm_atomic.c | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.c
> > index 58527f151984..ef106e7153a6 100644
> > --- a/drivers/gpu/drm/drm_atomic.c
> > +++ b/drivers/gpu/drm/drm_atomic.c
> > @@ -281,6 +281,10 @@ EXPORT_SYMBOL(__drm_atomic_state_free);
> >   * needed. It will also grab the relevant CRTC lock to make sure that the state
> >   * is consistent.
> >   *
> > + * WARNING: Drivers may only add new CRTC states to a @state if
> > + * drm_atomic_state.allow_modeset is set, or if it's a driver-internal commit
> > + * not created by userspace through an IOCTL call.
> > + *
> >   * Returns:
> >   *
> >   * Either the allocated state or the error code encoded into the pointer. When
> > @@ -1262,10 +1266,15 @@ int drm_atomic_check_only(struct drm_atomic_state *state)
> >       struct drm_crtc_state *new_crtc_state;
> >       struct drm_connector *conn;
> >       struct drm_connector_state *conn_state;
> > +     unsigned requested_crtc = 0;
> > +     unsigned affected_crtc = 0;
> >       int i, ret = 0;
> >
> >       DRM_DEBUG_ATOMIC("checking %p\n", state);
> >
> > +     for_each_new_crtc_in_state(state, crtc, old_crtc_state, i)
> > +             requested_crtc |= drm_crtc_mask(crtc);
> > +
> >       for_each_oldnew_plane_in_state(state, plane, old_plane_state, new_plane_state, i) {
> >               ret = drm_atomic_plane_check(old_plane_state, new_plane_state);
> >               if (ret) {
> > @@ -1313,6 +1322,24 @@ int drm_atomic_check_only(struct drm_atomic_state *state)
> >               }
> >       }
> >
> > +     for_each_new_crtc_in_state(state, crtc, old_crtc_state, i)
> > +             affected_crtc |= drm_crtc_mask(crtc);
> > +
> > +     /*
> > +      * For commits that allow modesets drivers can add other CRTCs to the
> > +      * atomic commit, e.g. when they need to reallocate global resources.
> > +      * This can cause spurious EBUSY, which robs compositors of a very
> > +      * effective sanity check for their drawing loop. Therefor only allow
> > +      * this for modeset commits.
> > +      *
> > +      * FIXME: Should add affected_crtc mask to the ATOMIC IOCTL as an output
> > +      * so compositors know what's going on.
>
> Hi,
>
> I think telling userspace the affected_crtc mask would only solve half
> of the problem: it would allow userspace to avoid attempting flips on
> the other affected CRTCs until this modeset is done, but it doesn't
> stop this non-blocking modeset from EBUSY'ing because other affected
> CRTCs are busy flipping.
>
> If the aim is to indicate userspace bugs with EBUSY, then EBUSY because
> of other CRTCs needs to be differentiable from EBUSY due to a mistake
> on this CRTC. Maybe the CRTC mask should instead be "conflicting/busy
> CRTCs", not simply "affected CRTCS"?
>
> Userspace might also be designed to always avoid modesets while any
> CRTC is busy flipping. In that case any EBUSY would be an indication of
> a (userspace) bug and a "busy CRTCs" mask could help pinpoint the issue.
>
> If userspace does a TEST_ONLY commit with a modeset on one CRTC and the
> driver pulls in another CRTC that is currently busy, will the test
> commit return with EBUSY?
>
> If yes, and *if* userspace is single-threaded wrt. to KMS updates,
> that might offer a way to work around it in userspace. But if userspace
> is flipping other CRTCs from other threads, TEST_ONLY commit does not
> help because another thread may cut in and make a CRTC busy.

This is not a legit programming model for atomic. An atomic commit is
always relative to the current state. If that state changes, then you
need to re-run your TEST_ONLY commit. So multiple threads changing
state in parallel isn't really a good idea anyway. Minimally we'd need
some kind of TEST_ONLY pile-up, so you can validate a change assuming
another commit has already happened. That's even harder than deep
queues on the commit side, we'd probably need full rollback of
commits.
-Daniel

>
>
> Thanks,
> pq
>
> > +      */
> > +     if (affected_crtc != requested_crtc) {
> > +             /* adding other CRTC is only allowed for modeset commits */
> > +             WARN_ON(!state->allow_modeset);
> > +     }
> > +
> >       return 0;
> >  }
> >  EXPORT_SYMBOL(drm_atomic_check_only);
>


-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
