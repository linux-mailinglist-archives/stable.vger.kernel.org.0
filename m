Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C35173C7795
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 21:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhGMUCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 16:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhGMUCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 16:02:19 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99985C0613DD
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 12:59:29 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id u11so30011095oiv.1
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 12:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xnQQUXc3QMGZAz8RD89dQUszF69iaN4BV55ilY+w0jw=;
        b=Hby+7cPnaRos0wbhI1gC0V3k/Lk5NljyIb3hHXs6gjvazDu81hEtlnv0YZr4b4SWjT
         un2oVRUTl89CKhW0dKwOmlu3gInGtcaINyWcXZJQ/80lJpYDIH6Qjvnbp82LPFwxp8j6
         gu9OE1T5mqIWZ6na7GLnEPxB3HkYgNIjLFNww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xnQQUXc3QMGZAz8RD89dQUszF69iaN4BV55ilY+w0jw=;
        b=QwFMFmIMWOrrqn+dazM/7ZtDiiZ/apaUbPpfZdNsiyUYCAEz2SYELyntzr8qZPFRDU
         zbNV0xJH7FMWdnrhHX8YoejmbKL8R2EVM+FOy8AxIuyYXN63mb7YX1xZhp9wqfNYcYNx
         p5pII9uHXr5NQrkfbZS3B3QQNnGfrK5SuoRed0jOOSFVld7UbMxjjXjLxzbML7JJm/1E
         Al4Jz9A2LOnH1vsDoIfUxaKOMG6i5rFOu9ry4Ni7jou/FrPU50BunmZavVTtiWq7rvC3
         n/8zAju6Wx/9fuIW/5ddVDuegPW257WNbCE4uY+PZSR7S4pD6OZg4i/AjmND86JnIOsh
         dyIg==
X-Gm-Message-State: AOAM53153O7OCrn+LmLKPEpL04yxzakdFtZC8zyX8VedgCUz6lz5IMWM
        gKSfTbcyx4z2HvwsiLCbEYDlCIwFLZsW9juwyOf2JA==
X-Google-Smtp-Source: ABdhPJyKWw9l5Jy4vGJ871uTbkCaIb4FsSAwkk9RDaqxUotmeEunyw2fH3DRu0oMkTSlg4DTK2iLVS9OyKmOmkJJqu4=
X-Received: by 2002:aca:d4cf:: with SMTP id l198mr866791oig.14.1626206369052;
 Tue, 13 Jul 2021 12:59:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210630164413.25481-1-ville.syrjala@linux.intel.com>
 <2edf584b-3835-53ed-f6e3-76c7e8d581ed@linux.intel.com> <CAKMK7uFTYgK9rmXTNSczPdBWPTNaLBp-GitzBQb0-gX5wZWHNQ@mail.gmail.com>
In-Reply-To: <CAKMK7uFTYgK9rmXTNSczPdBWPTNaLBp-GitzBQb0-gX5wZWHNQ@mail.gmail.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 13 Jul 2021 21:59:18 +0200
Message-ID: <CAKMK7uFjgu_TkPFYs0DTdAh9tdDbdpUc0S1n5XUfHJaq_0FHVw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/gt: Fix -EDEADLK handling regression
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel <dri-devel@lists.freedesktop.org>
Cc:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@intel.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 13, 2021 at 9:58 PM Daniel Vetter <daniel@ffwll.ch> wrote:
>
> On Thu, Jul 1, 2021 at 9:07 AM Maarten Lankhorst
> <maarten.lankhorst@linux.intel.com> wrote:
> > Op 30-06-2021 om 18:44 schreef Ville Syrjala:
> > > From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > >
> > > The conversion to ww mutexes failed to address the fence code which
> > > already returns -EDEADLK when we run out of fences. Ww mutexes on
> > > the other hand treat -EDEADLK as an internal errno value indicating
> > > a need to restart the operation due to a deadlock. So now when the
> > > fence code returns -EDEADLK the higher level code erroneously
> > > restarts everything instead of returning the error to userspace
> > > as is expected.
> > >
> > > To remedy this let's switch the fence code to use a different errno
> > > value for this. -ENOBUFS seems like a semi-reasonable unique choice.
> > > Apart from igt the only user of this I could find is sna, and even
> > > there all we do is dump the current fence registers from debugfs
> > > into the X server log. So no user visible functionality is affected.
> > > If we really cared about preserving this we could of course convert
> > > back to -EDEADLK higher up, but doesn't seem like that's worth
> > > the hassle here.
> > >
> > > Not quite sure which commit specifically broke this, but I'll
> > > just attribute it to the general gem ww mutex work.
> > >
> > > Cc: stable@vger.kernel.org
> > > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > > Cc: Thomas Hellstr=C3=B6m <thomas.hellstrom@intel.com>
> > > Testcase: igt/gem_pread/exhaustion
> > > Testcase: igt/gem_pwrite/basic-exhaustion
> > > Testcase: igt/gem_fenced_exec_thrash/too-many-fences
> > > Fixes: 80f0b679d6f0 ("drm/i915: Add an implementation for i915_gem_ww=
_ctx locking, v2.")
> > > Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com=
>
> > > ---
> > >  drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c b/drivers/g=
pu/drm/i915/gt/intel_ggtt_fencing.c
> > > index cac7f3f44642..f8948de72036 100644
> > > --- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> > > +++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> > > @@ -348,7 +348,7 @@ static struct i915_fence_reg *fence_find(struct i=
915_ggtt *ggtt)
> > >       if (intel_has_pending_fb_unpin(ggtt->vm.i915))
> > >               return ERR_PTR(-EAGAIN);
> > >
> > > -     return ERR_PTR(-EDEADLK);
> > > +     return ERR_PTR(-ENOBUFS);
> > >  }
> > >
> > >  int __i915_vma_pin_fence(struct i915_vma *vma)
> >
> > Makes sense..
> >
> > Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> >
> > Is it a slightly more reent commit? Might probably be the part that con=
verts execbuffer to use ww locks.
>
> - please cc: dri-devel on anything gem/gt related.
> - this should probably be ENOSPC or something like that for at least a
> seeming retention of errno consistentcy:
>
> https://dri.freedesktop.org/docs/drm/gpu/drm-uapi.html#recommended-ioctl-=
return-values

Other option would be to map that back to EDEADLK in the execbuf ioctl
somewhere, so we retain a distinct errno code.
-Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
