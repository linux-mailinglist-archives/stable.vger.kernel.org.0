Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109503C778F
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 21:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhGMUBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 16:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbhGMUBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 16:01:05 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C21C0613DD
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 12:58:15 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 59-20020a9d0ac10000b0290462f0ab0800so23572otq.11
        for <stable@vger.kernel.org>; Tue, 13 Jul 2021 12:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pz8q3VIqFRU6Z/Otup9y1fbrbnHC3h9yRwEFMSVd4po=;
        b=DGnT4aaklkuoh4XMDUeZRq//7mSWFtV3A0L+iDHT1S+iVnLosPSNCkAyO/1rZQCrSE
         UZ/WJLPpsbZpEl741Nu13cBhXe603O65KeMnC6vjyY7W/tca69MCJW+GDo33EM2wHLLU
         uSb9A0+ximsKFnDz9J4vm+HTRu+BGvxTUIUw4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pz8q3VIqFRU6Z/Otup9y1fbrbnHC3h9yRwEFMSVd4po=;
        b=OaASG8DNM6uAuoWGPZ3IlYpeusUVpam3Js7caqyOn6QrcgbpIwGauqPzFvCUVvTRZw
         PvbEtHF3rtnfvpZB4ycDRNItalVaLTErWAj2cY4VktbdMNIIxgfUdBgg0sfTjVBLGH1c
         eusQOjB2h5n8HCzifc2cvCcWn/LsKMG7vyzUI3sLsQ9eQPn7S/c1b0iqaq+wtoruZKHj
         X1gsaCb2jhH0pgf0GqrLFmd+zPs4F11HX28qRwGlISbEgAvfek09Vp1Mg9ExmRZjwoZM
         mYQWyVNKY0svkPWEKM9ZMIZDmmC4TLstMIMFEyQilXvHjCxQ8ReKwaXYd7mPuVo/0Uuj
         eRXQ==
X-Gm-Message-State: AOAM5313Ty8+/d6xOrOt9akVFCU6UBCaas2Ep9p0q0rGe0uAwOajftgI
        eY6rmv8sBRdJJ6Ggix6d9eh23QCLYDBmWAG1d2XTZg==
X-Google-Smtp-Source: ABdhPJz9CiL//Tji/Cm8MAeN5UlQhpYrnRkpw3wA2Mbq0SpzZIBAEWBX0CbMXD846uBx7jrpmnzX3myPs/Aypjc7HYs=
X-Received: by 2002:a05:6830:2366:: with SMTP id r6mr4902260oth.188.1626206294340;
 Tue, 13 Jul 2021 12:58:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210630164413.25481-1-ville.syrjala@linux.intel.com> <2edf584b-3835-53ed-f6e3-76c7e8d581ed@linux.intel.com>
In-Reply-To: <2edf584b-3835-53ed-f6e3-76c7e8d581ed@linux.intel.com>
From:   Daniel Vetter <daniel@ffwll.ch>
Date:   Tue, 13 Jul 2021 21:58:03 +0200
Message-ID: <CAKMK7uFTYgK9rmXTNSczPdBWPTNaLBp-GitzBQb0-gX5wZWHNQ@mail.gmail.com>
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

On Thu, Jul 1, 2021 at 9:07 AM Maarten Lankhorst
<maarten.lankhorst@linux.intel.com> wrote:
> Op 30-06-2021 om 18:44 schreef Ville Syrjala:
> > From: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> >
> > The conversion to ww mutexes failed to address the fence code which
> > already returns -EDEADLK when we run out of fences. Ww mutexes on
> > the other hand treat -EDEADLK as an internal errno value indicating
> > a need to restart the operation due to a deadlock. So now when the
> > fence code returns -EDEADLK the higher level code erroneously
> > restarts everything instead of returning the error to userspace
> > as is expected.
> >
> > To remedy this let's switch the fence code to use a different errno
> > value for this. -ENOBUFS seems like a semi-reasonable unique choice.
> > Apart from igt the only user of this I could find is sna, and even
> > there all we do is dump the current fence registers from debugfs
> > into the X server log. So no user visible functionality is affected.
> > If we really cared about preserving this we could of course convert
> > back to -EDEADLK higher up, but doesn't seem like that's worth
> > the hassle here.
> >
> > Not quite sure which commit specifically broke this, but I'll
> > just attribute it to the general gem ww mutex work.
> >
> > Cc: stable@vger.kernel.org
> > Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Cc: Thomas Hellstr=C3=B6m <thomas.hellstrom@intel.com>
> > Testcase: igt/gem_pread/exhaustion
> > Testcase: igt/gem_pwrite/basic-exhaustion
> > Testcase: igt/gem_fenced_exec_thrash/too-many-fences
> > Fixes: 80f0b679d6f0 ("drm/i915: Add an implementation for i915_gem_ww_c=
tx locking, v2.")
> > Signed-off-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> > ---
> >  drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c b/drivers/gpu=
/drm/i915/gt/intel_ggtt_fencing.c
> > index cac7f3f44642..f8948de72036 100644
> > --- a/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> > +++ b/drivers/gpu/drm/i915/gt/intel_ggtt_fencing.c
> > @@ -348,7 +348,7 @@ static struct i915_fence_reg *fence_find(struct i91=
5_ggtt *ggtt)
> >       if (intel_has_pending_fb_unpin(ggtt->vm.i915))
> >               return ERR_PTR(-EAGAIN);
> >
> > -     return ERR_PTR(-EDEADLK);
> > +     return ERR_PTR(-ENOBUFS);
> >  }
> >
> >  int __i915_vma_pin_fence(struct i915_vma *vma)
>
> Makes sense..
>
> Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
>
> Is it a slightly more reent commit? Might probably be the part that conve=
rts execbuffer to use ww locks.

- please cc: dri-devel on anything gem/gt related.
- this should probably be ENOSPC or something like that for at least a
seeming retention of errno consistentcy:

https://dri.freedesktop.org/docs/drm/gpu/drm-uapi.html#recommended-ioctl-re=
turn-values

Cheers, Daniel
--=20
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
