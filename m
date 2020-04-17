Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C742E1AE472
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 20:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730631AbgDQSKm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 14:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730718AbgDQSKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Apr 2020 14:10:41 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E26C061A0C
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 11:10:39 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id k21so2181801otl.5
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 11:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AVdZUd+aoV5hglGQdjkmyI25h/pfLO7UOhCP4bcSCiE=;
        b=hdNZikSMdnvITOdr5idNKrN1s6X3JhvTpoAifWfbNI8OucJyUTsbdw4aOT5mJ17OnY
         21Iz5+JZrcLXxR3RohsYUaExGaGqD9GpC5XAzSGFVi3BxO+jxfUpcJFM8scSN2gQ9/V7
         208IpIlcZahgGU9VLcoi9P+mf6EquFx5SuEro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AVdZUd+aoV5hglGQdjkmyI25h/pfLO7UOhCP4bcSCiE=;
        b=Tmkdpql9lRLVhEzjrkkuEVmp3macQF3/mVSeOvJ3kgACgz5GVHFvwzUEKnUiMK4Fxm
         9wDKRYRNequDVp2p/wLQVQ8wWkm8purhPEof+QO1YyTkUQ/PU06vojOg8nhgV1UzZ/kT
         gdsdT3rUnEjYvKDto8a1nK8ukbSjt+2p0zsRs/tYUtLzLouSDPt8YooW55Y7GOxNo88W
         9hOmbRGgId2+mCC4SujZIx0i1VGDFPU6bR6PaMFKbm33mmud68MMCYuTT2FZdfQGnZtF
         YYvkcizTp+RcKUSYXRB9CNpX896qf5A9+ff+JXw2DFYEcwaNIcP7cBMErrw7X+kQ4daO
         TIFw==
X-Gm-Message-State: AGi0Pubx3slGS6eqnDk/D8v5c5qm8UDrLuj1fPBwLKE7mtyUyizjPJ15
        BuAaZfnHxH1oZ4crZSCyJHCqm+XiO6V1VZzEq8VBag==
X-Google-Smtp-Source: APiQypLLEOl8ehPIa48TecTfBenMgM8WAuWmMT4h2itoYv51EVbbTPBbvw8pH+ub2oiqM6RgU+tkCpSAKtTF1/xpCLw=
X-Received: by 2002:a05:6830:1d0:: with SMTP id r16mr26334ota.303.1587147038949;
 Fri, 17 Apr 2020 11:10:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200416170420.23657-1-ville.syrjala@linux.intel.com>
 <20200417152310.GQ3456981@phenom.ffwll.local> <20200417154313.GO6112@intel.com>
In-Reply-To: <20200417154313.GO6112@intel.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Fri, 17 Apr 2020 20:10:26 +0200
Message-ID: <CAKMK7uGBWyPtm0dva=Ndk6xJx7nUKJ20kn8S37iFB8s85WWmdw@mail.gmail.com>
Subject: Re: [PATCH] drm: Fix page flip ioctl format check
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 17, 2020 at 5:43 PM Ville Syrj=C3=A4l=C3=A4
<ville.syrjala@linux.intel.com> wrote:
>
> On Fri, Apr 17, 2020 at 05:23:10PM +0200, Daniel Vetter wrote:
> > On Thu, Apr 16, 2020 at 08:04:20PM +0300, Ville Syrjala wrote:
> > > From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > >
> > > Revert back to comparing fb->format->format instead fb->format for th=
e
> > > page flip ioctl. This check was originally only here to disallow pixe=
l
> > > format changes, but when we changed it to do the pointer comparison
> > > we potentially started to reject some (but definitely not all) modifi=
er
> > > changes as well. In fact the current behaviour depends on whether the
> > > driver overrides the format info for a specific format+modifier combo=
.
> > > Eg. on i915 this now rejects compression vs. no compression changes b=
ut
> > > does not reject any other tiling changes. That's just inconsistent
> > > nonsense.
> > >
> > > The main reason we have to go back to the old behaviour is to fix pag=
e
> > > flipping with Xorg. At some point Xorg got its atomic rights taken aw=
ay
> > > and since then we can't page flip between compressed and non-compress=
ed
> > > fbs on i915. Currently we get no page flipping for any games pretty m=
uch
> > > since Mesa likes to use compressed buffers. Not sure how compositors =
are
> > > working around this (don't use one myself). I guess they must be doin=
g
> > > something to get non-compressed buffers instead. Either that or
> > > somehow no one noticed the tearing from the blit fallback.
> >
> > Mesa only uses compressed buffers if you enable modifiers, and there's =
a
> > _loooooooooooot_ more that needs to be fixed in Xorg to enable that for
> > real. Like real atomic support.
>
> Why would you need atomic for modifiers? Xorg doesn't even have
> any sensible framework for atomic and I suspect it never will.

Frankly if no one cares about atomic in X I don't think we should do
work-arounds for lack of atomic in X.

> > Without modifiers all you get is X tiling,
> > and that works just fine.
> >
> > Which would also fix this issue here you're papering over.
> >
> > So if this is the entire reason for this, I'm inclined to not do this.
> > Current Xorg is toast wrt modifiers, that's not news.
>
> Works just fine. Also pretty sure modifiers are even enabled by
> default now in modesetting.

Y/CSS is harder to scan out, you need to verify with TEST_ONLY whether
it works. Otherwise good chances for some oddball black screens on
configurations that worked before. Which is why all non-atomic
compositors reverted modifiers by default again.

> And as stated the current check doesn't have consistent behaviour
> anyway. You can still flip between different modifiers as long a the
> driver doesn't override .get_format_info() for one of them. The *only*
> case where that happens is CCS on i915. There is no valid reason to
> special case that one.

The thing is, you need atomic to make CCS work reliably enough for
compositors and distros to dare enabling it by default. CCS flipping
works with atomic. I really see no point in baking this in with as
uapi. Just fix Xorg.
-Daniel

>
> > -Daniel
> >
> > >
> > > Looking back at the original discussion on this change we pretty much
> > > just did it in the name of skipping a few extra pointer dereferences.
> > > However, I've decided not to revert the whole thing in case someone
> > > has since started to depend on these changes. None of the other check=
s
> > > are relevant for i915 anyways.
> > >
> > > Cc: stable@vger.kernel.org
> > > Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > Fixes: dbd4d5761e1f ("drm: Replace 'format->format' comparisons to ju=
st 'format' comparisons")
> > > Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com=
>
> > > ---
> > >  drivers/gpu/drm/drm_plane.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/gpu/drm/drm_plane.c b/drivers/gpu/drm/drm_plane.=
c
> > > index d6ad60ab0d38..f2ca5315f23b 100644
> > > --- a/drivers/gpu/drm/drm_plane.c
> > > +++ b/drivers/gpu/drm/drm_plane.c
> > > @@ -1153,7 +1153,7 @@ int drm_mode_page_flip_ioctl(struct drm_device =
*dev,
> > >     if (ret)
> > >             goto out;
> > >
> > > -   if (old_fb->format !=3D fb->format) {
> > > +   if (old_fb->format->format !=3D fb->format->format) {
> > >             DRM_DEBUG_KMS("Page flip is not allowed to change frame b=
uffer format.\n");
> > >             ret =3D -EINVAL;
> > >             goto out;
> > > --
> > > 2.24.1
> > >
> > > _______________________________________________
> > > dri-devel mailing list
> > > dri-devel@lists.freedesktop.org
> > > https://lists.freedesktop.org/mailman/listinfo/dri-devel
> >
> > --
> > Daniel Vetter
> > Software Engineer, Intel Corporation
> > http://blog.ffwll.ch
>
> --
> Ville Syrj=C3=A4l=C3=A4
> Intel



--=20
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
