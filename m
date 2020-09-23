Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B764327567A
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 12:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgIWKhi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 06:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWKhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 06:37:38 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBB6C0613CE
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 03:37:38 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id w16so24479531oia.2
        for <stable@vger.kernel.org>; Wed, 23 Sep 2020 03:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dfS8bSS+06hQE0qWnnZuaBFQQAdqVz3IqVwpKRDCHi4=;
        b=fdMqx/PkNamM0iR2p4y+nAVBhBRk2izzUD8jjwAQvU1Mt9sT1BlqJc0Llhetghe/ke
         UJF4BqMJXdhqrw3E9Fw0hFvKbqf147kDxce/Jdb+Q/bN/tsr6oToxkjK8Ot5SniCWW9A
         6ahBUoAQz0OHbqRA9LVDBWqKAkeCkjqAq2s+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dfS8bSS+06hQE0qWnnZuaBFQQAdqVz3IqVwpKRDCHi4=;
        b=PAe79455fSqNHYID4MjX44GuBN+JUUuChkQhoFIetynYI5RsjQ2DJfTWPU8ATmx0pV
         q3ujFGlLMWXOpDadvCk/8rbfegIBzso8x4RSd+6eAlY9VIXvXVTXKhpG1f9pRWbEeDkD
         A3suumDzYC5jF/0v3KvPZgmZqSUNQyKoQWgdaEikogcdAAzb4Bu1fSCfFeOcpV3YIuqL
         PRxfxXz1uTW6Ltc/scgKQlqTfJ6gF5K/Sp/zAaz+xa8XsuJwgZjLrPeS7lXUE/WeKgs/
         f3szB6LcholABcTvfjYf6nrJQNWxcd13D/iyByeDJSPfarP+cbB3MUWVxXxw0rwjZgpX
         LNxg==
X-Gm-Message-State: AOAM532Ieljsq9J2HCjCgmDEzpCwdFR3NFFzgVJjHmxkRDWaScnOpVOt
        j+b9WOuhTPmQlvfYqgztlNVk5Hk0STFlinWbrkuuz0DFMGZVog==
X-Google-Smtp-Source: ABdhPJzm7c/PQ1BnKzYSqD/qfo0Dr76BNXmMMj54WAHw/w0fqE+27e0DMaEypfmUh7IFVmd7azxeyLv7MDuHy/bABfk=
X-Received: by 2002:aca:6083:: with SMTP id u125mr5345464oib.14.1600857457879;
 Wed, 23 Sep 2020 03:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200922181834.2913552-1-daniel.vetter@ffwll.ch> <20200923103137.GD6112@intel.com>
In-Reply-To: <20200923103137.GD6112@intel.com>
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed, 23 Sep 2020 12:37:26 +0200
Message-ID: <CAKMK7uEEv1w2D1NYzuU-m-UkseHgBy45-93wK2oEQdayD5CH5A@mail.gmail.com>
Subject: Re: [PATCH] drm: document and enforce rules around "spurious" EBUSY
 from atomic_commit
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Stone <daniel@fooishbar.org>,
        Pekka Paalanen <pekka.paalanen@collabora.co.uk>,
        Simon Ser <contact@emersion.fr>,
        stable <stable@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 23, 2020 at 12:31 PM Ville Syrj=C3=A4l=C3=A4
<ville.syrjala@linux.intel.com> wrote:
>
> On Tue, Sep 22, 2020 at 08:18:34PM +0200, Daniel Vetter wrote:
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
> >
> > References: https://lists.freedesktop.org/archives/dri-devel/2018-July/=
182281.html
> > Bugzilla: https://gitlab.freedesktop.org/wayland/weston/issues/24#note_=
9568
> > Cc: Daniel Stone <daniel@fooishbar.org>
> > Cc: Pekka Paalanen <pekka.paalanen@collabora.co.uk>
> > Cc: Simon Ser <contact@emersion.fr>
> > Cc: stable@vger.kernel.org
> > Cc: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> > ---
> >  drivers/gpu/drm/drm_atomic.c | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> >
> > diff --git a/drivers/gpu/drm/drm_atomic.c b/drivers/gpu/drm/drm_atomic.=
c
> > index 58527f151984..ef106e7153a6 100644
> > --- a/drivers/gpu/drm/drm_atomic.c
> > +++ b/drivers/gpu/drm/drm_atomic.c
> > @@ -281,6 +281,10 @@ EXPORT_SYMBOL(__drm_atomic_state_free);
> >   * needed. It will also grab the relevant CRTC lock to make sure that =
the state
> >   * is consistent.
> >   *
> > + * WARNING: Drivers may only add new CRTC states to a @state if
> > + * drm_atomic_state.allow_modeset is set, or if it's a driver-internal=
 commit
> > + * not created by userspace through an IOCTL call.
> > + *
> >   * Returns:
> >   *
> >   * Either the allocated state or the error code encoded into the point=
er. When
> > @@ -1262,10 +1266,15 @@ int drm_atomic_check_only(struct drm_atomic_sta=
te *state)
> >       struct drm_crtc_state *new_crtc_state;
> >       struct drm_connector *conn;
> >       struct drm_connector_state *conn_state;
> > +     unsigned requested_crtc =3D 0;
> > +     unsigned affected_crtc =3D 0;
> >       int i, ret =3D 0;
> >
> >       DRM_DEBUG_ATOMIC("checking %p\n", state);
> >
> > +     for_each_new_crtc_in_state(state, crtc, old_crtc_state, i)
> > +             requested_crtc |=3D drm_crtc_mask(crtc);
> > +
> >       for_each_oldnew_plane_in_state(state, plane, old_plane_state, new=
_plane_state, i) {
> >               ret =3D drm_atomic_plane_check(old_plane_state, new_plane=
_state);
> >               if (ret) {
> > @@ -1313,6 +1322,24 @@ int drm_atomic_check_only(struct drm_atomic_stat=
e *state)
> >               }
> >       }
> >
> > +     for_each_new_crtc_in_state(state, crtc, old_crtc_state, i)
>
> Inconsistent old vs. new.

Will fix, but also doesn't matter since I don't care about the state,
just that it's in there.

> > +             affected_crtc |=3D drm_crtc_mask(crtc);
> > +
> > +     /*
> > +      * For commits that allow modesets drivers can add other CRTCs to=
 the
> > +      * atomic commit, e.g. when they need to reallocate global resour=
ces.
> > +      * This can cause spurious EBUSY, which robs compositors of a ver=
y
> > +      * effective sanity check for their drawing loop. Therefor only a=
llow
> > +      * this for modeset commits.
> > +      *
> > +      * FIXME: Should add affected_crtc mask to the ATOMIC IOCTL as an=
 output
> > +      * so compositors know what's going on.
> > +      */
> > +     if (affected_crtc !=3D requested_crtc) {
> > +             /* adding other CRTC is only allowed for modeset commits =
*/
> > +             WARN_ON(!state->allow_modeset);
> > +     }
>
> I think this means pretty much all non-pageflip commits will
> have to have allow_modeset=3D=3Dtrue on i915 or else we just can't
> guarantee that we can anything (due to sagv and/or cdclk mainly).

I guess not enough machines with multiple outputs in the shards.

> Also a bit baffled that CI didn't hit this. I think it should be
> totally possible to hit this now. To avoid that I guess we'd just
> need to make intel_atomic_serialize_global_state() fail if it
> has to add any new crtcs when allow_modeset=3D=3Dfalse. Hopefully
> there aren't many other places that add crtcs to the state
> without forcing a modeset on them.

Oh we don't do that? That feels like a pretty bad bug ... Wacking
random other crtc without allow_modeset is pretty nasty.
-Daniel

>
> > +
> >       return 0;
> >  }
> >  EXPORT_SYMBOL(drm_atomic_check_only);
> > --
> > 2.28.0
>
> --
> Ville Syrj=C3=A4l=C3=A4
> Intel



--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
