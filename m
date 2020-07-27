Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AE522F7C2
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 20:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgG0Sb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 14:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgG0Sb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 14:31:28 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2908CC061794
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 11:31:28 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id k6so15156227oij.11
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 11:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E2pbIJT/KbxGNYrIC+oluHCr/NaAuyjtB/NrFDyV1m0=;
        b=jcwVB9s5sYf5bZBq7kqWvkNiyANx15wXURt2NC7AKpt1IiOxEALZaDhZr0F3OiVYAk
         HFPuCjXNJ5WZySy1OoOZPu3Eec9dOI3JRonWrICj4Uf1sfJ0nK2szUMXncQcpY/aUNSQ
         609rmkIfZbgWGWGLIyORbflSmjW/zwunWfzzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E2pbIJT/KbxGNYrIC+oluHCr/NaAuyjtB/NrFDyV1m0=;
        b=syv9pDIS24snaIlYGp921eI6Luu7ABnP42fWhTUFatXGVx/+I3pJQLZLyDbSOglqDj
         hbXjlX4yyVmLUG00DN2rxTREx/PSV9BNydf2w61yr8l218fku4CFqxx/CF01DOCLlRna
         m8Z7YQRAgpSJ7Ak4tSyoZj+rAX8iZZr2PDTErP1jU4fgr2uYyHV9LoQIHH0KqzPhtai9
         8ZWluIf5p1U8tSMFE80drp65Emn0IlNWvDnfZ/hN3hQNlfwMgb9nwjUXMXwyXQXXlg4/
         Ql3qm4KYpu9BrhEAZwId6uIPoP3T84uFjZwnwCuUuFUvjo0gUC6wEV0IH0r5rlaQ0o1W
         B2CA==
X-Gm-Message-State: AOAM532XzTXEyU6kAMzKhku2N+vTjXikIHeBVLtZNTkUj7kGx2KZQo6F
        yUSWilvmzGxwuUedrwDMyjfL78FxN8O6r6Wwov5FsA==
X-Google-Smtp-Source: ABdhPJwVOZCkbufYa2PYEOhlJjIOQuf3ucj9M5lEAMHpdN39GA9TwZ1V00Rf/UchsYfcYelEBAFI4ASD8OtDka9/GqI=
X-Received: by 2002:aca:ab87:: with SMTP id u129mr531919oie.128.1595874687574;
 Mon, 27 Jul 2020 11:31:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200727073707.21097-1-tzimmermann@suse.de> <20200727073707.21097-2-tzimmermann@suse.de>
 <20200727104043.GU6419@phenom.ffwll.local> <857217a7-aadc-f6c9-c713-679e390f2537@suse.de>
In-Reply-To: <857217a7-aadc-f6c9-c713-679e390f2537@suse.de>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Mon, 27 Jul 2020 20:31:16 +0200
Message-ID: <CAKMK7uEOUy4hBdWieqt=uUK3o3mu2iPSYFLjyfWxkC9bE7ibCA@mail.gmail.com>
Subject: Re: [PATCH 1/3] drm/ast: Do full modeset if the primary plane's
 format changes
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     Emil Velikov <emil.l.velikov@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        stable <stable@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 1:24 PM Thomas Zimmermann <tzimmermann@suse.de> wro=
te:
>
> Hi
>
> Am 27.07.20 um 12:40 schrieb daniel@ffwll.ch:
> > On Mon, Jul 27, 2020 at 09:37:05AM +0200, Thomas Zimmermann wrote:
> >> The atomic modesetting code tried to distinguish format changes from
> >> full modesetting operations. In practice, this was buggy and the forma=
t
> >> registers were often updated even for simple pageflips.
> >
> > Nah it's not buggy, it's intentional. Most hw can update formats in a f=
lip
> > withouth having to shut down the hw to do so.
>
> Admittedly it was intentional when I write it, but it never really
> worked. I think it might have even updated these color registers on each
> frame.
>
> >
> >
> >> Instead do a full modeset if the primary plane changes formats. It's
> >> just as rare as an actual mode change, so there will be no performance
> >> penalty.
> >>
> >> The patch also replaces a reference to drm_crtc_state.allow_modeset wi=
th
> >> the correct call to drm_atomic_crtc_needs_modeset().
> >>
> >> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> >> Fixes: 4961eb60f145 ("drm/ast: Enable atomic modesetting")
> >> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> >> Cc: Gerd Hoffmann <kraxel@redhat.com>
> >> Cc: Dave Airlie <airlied@redhat.com>
> >> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> >> Cc: Sam Ravnborg <sam@ravnborg.org>
> >> Cc: Emil Velikov <emil.l.velikov@gmail.com>
> >> Cc: "Y.C. Chen" <yc_chen@aspeedtech.com>
> >> Cc: <stable@vger.kernel.org> # v5.6+
> >> ---
> >>  drivers/gpu/drm/ast/ast_mode.c | 23 ++++++++++++++++-------
> >>  1 file changed, 16 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_=
mode.c
> >> index 154cd877d9d1..3680a000b812 100644
> >> --- a/drivers/gpu/drm/ast/ast_mode.c
> >> +++ b/drivers/gpu/drm/ast/ast_mode.c
> >> @@ -527,8 +527,8 @@ static const uint32_t ast_primary_plane_formats[] =
=3D {
> >>  static int ast_primary_plane_helper_atomic_check(struct drm_plane *pl=
ane,
> >>                                               struct drm_plane_state *=
state)
> >>  {
> >> -    struct drm_crtc_state *crtc_state;
> >> -    struct ast_crtc_state *ast_crtc_state;
> >> +    struct drm_crtc_state *crtc_state, *old_crtc_state;
> >> +    struct ast_crtc_state *ast_crtc_state, *old_ast_crtc_state;
> >>      int ret;
> >>
> >>      if (!state->crtc)
> >> @@ -550,6 +550,15 @@ static int ast_primary_plane_helper_atomic_check(=
struct drm_plane *plane,
> >>
> >>      ast_crtc_state->format =3D state->fb->format;
> >>
> >> +    old_crtc_state =3D drm_atomic_get_old_crtc_state(state->state, st=
ate->crtc);
> >> +    if (!old_crtc_state)
> >> +            return 0;
> >> +    old_ast_crtc_state =3D to_ast_crtc_state(old_crtc_state);
> >> +    if (!old_ast_crtc_state)
> >
> > The above two if checks should never fail, I'd wrap them in a WARN_ON.
>
> Really? But what's the old state when the first mode is being programmed?

Uh, atomic _always_ has a state. That's why you need to call
drm_mode_config_reset, to get this entire machinery started. Also, the
sw state is supposed to always match the hw state (at least once all
the nonblocking commit workers have caught up).

> >
> >> +            return 0;
> >> +    if (ast_crtc_state->format !=3D old_ast_crtc_state->format)
> >> +            crtc_state->mode_changed =3D true;
> >> +
> >>      return 0;
> >>  }
> >>
> >> @@ -775,18 +784,18 @@ static void ast_crtc_helper_atomic_flush(struct =
drm_crtc *crtc,
> >>
> >>      ast_state =3D to_ast_crtc_state(crtc->state);
> >>
> >> -    format =3D ast_state->format;
> >> -    if (!format)
> >> +    if (!drm_atomic_crtc_needs_modeset(crtc->state))
> >>              return;
> >>
> >> +    format =3D ast_state->format;
> >> +    if (drm_WARN_ON_ONCE(dev, !format))
> >> +            return; /* BUG: We didn't set format in primary check(). =
*/
> >
> > Hm that entire ast_state->format machinery looks kinda strange, can't y=
ou
> > just look up the primary plane state everywhere and that's it?
> > drm_framebuffer are fully invariant and refcounted to the state, so the=
re
> > really shouldn't be any need to copy format around.
>
> ast_state->format is the format that has to be programmed in
> atomic_flush(). If it's NULL, the current format was used. Updating the
> primary plane's format also requires the vbios info, which depends on
> CRTC state. So it's collected in the CRTC's atomic_check().
>
> It felt natural to use the various atomic_check() functions to collect
> and store and store away these structures, and later use them in
> atomic_flush().
>
> I'd prefer to keep the current design. It's the one that worked best
> while writing the atomic-modesetting support for ast.

So if you have actual checks in atomic_check for validation, then this
makes sense - it avoids computing stuff twice and getting in wrong in
one case.

But from reading ast code all you do is store the temporary lookup in
there, and that's really just confusing. You can just look up the
atomic state, at least in atomic_check (in the commit side it's mildly
more annoying, we need to fix a few things). But it's also not totally
horrible ofc, just would be nice to improve this.
-Daniel


> Best regard
> Thomas
>
> >
> > But that's maybe for a next patch. With the commit message clarified th=
at
> > everything works as designed, and maybe the two WARN_ON added:
> >
> > Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> >
> >> +
> >>      vbios_mode_info =3D &ast_state->vbios_mode_info;
> >>
> >>      ast_set_color_reg(ast, format);
> >>      ast_set_vbios_color_reg(ast, format, vbios_mode_info);
> >>
> >> -    if (!crtc->state->mode_changed)
> >> -            return;
> >> -
> >>      adjusted_mode =3D &crtc->state->adjusted_mode;
> >>
> >>      ast_set_vbios_mode_reg(ast, adjusted_mode, vbios_mode_info);
> >> --
> >> 2.27.0
> >>
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
