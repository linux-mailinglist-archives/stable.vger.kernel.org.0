Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9609041C0CE
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 10:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244595AbhI2Im7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Sep 2021 04:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244582AbhI2Im7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Sep 2021 04:42:59 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C68C06161C
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 01:41:18 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id a14so1022100qvb.6
        for <stable@vger.kernel.org>; Wed, 29 Sep 2021 01:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9WnzaOq9/zkqgMhPdsvxfypibXxufy6o2CegxB/kxLQ=;
        b=MPAFtV6qSf3n3+SRsC4xjE4PusQk1/Dv9iDoJCUwwwxt4HaEyoFwoOXizcp54F7G0e
         7Miyz8Oi5qqMjbO/NCkT8CerL9mV6XF+JtxqeCCH08y46xV8DwrikU4Q9HffWK6Y1L56
         7yg++Qf87avVrt+CBSk4qH8waEsM96aSxBFPeN41fMJwMRJNzR0tBQOJWappplKqzW9P
         1giZzQn2bLESYHoHCYKAPpM9Y4Fa5jmEaMhr3l4V1LLzKw+BZHpZtyjzG/kSHflH/wI1
         89yWGBjLHbV9Z8ZIKOv9Wv38taBtwjFyLNDuA/R40Cbx1VJalhTswPFBvq2oZGgyBYU4
         dEFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9WnzaOq9/zkqgMhPdsvxfypibXxufy6o2CegxB/kxLQ=;
        b=daQGo6YHl1XqySh4FWyvlB6VZOFmFdClGEDScQLim9TyJfO35HGvUcwKSzBAHTDJNP
         wdtszRehiwYUMc3Plg+bGZT+68JRXkMWNZEwQ+QRepxpGoOlAPW6QJZr929Z+DvSAFmh
         xRjuhf4sWKvxH29n+xG2Kvg9nftDPA9QPbNAnTnkHrh9o95TlQ168kBLYhnQm6UQks3t
         8kNh+6+0mj57538/IUatYMeSo6pnbV+5RdH9Ad3d8g9ZT8xyZUDi2KZy4H+zRaw3nvOm
         8b2SuaDqR9xxNkZFiXtaoeDPJCvekBg0lWOIbe6YawQdOHMFcjeW0g457Ud8pH9ZuZRw
         qLuA==
X-Gm-Message-State: AOAM530rQxOrlvBiDDTyVvci/Dws2IvQIm9LPoS71kt/B043cifmDhog
        KDAl2Det34OhRwHEFKMeHtrMb2ozhHIBiP1/sHQ=
X-Google-Smtp-Source: ABdhPJzCxKG++WzJFB+VtwUhp3DYmGc5AbFkNzS/6av7PHNvUrXng97AAgOirBZAxNzmyaVtVYY3rLwkEcBClsXeluQ=
X-Received: by 2002:a0c:cb10:: with SMTP id o16mr10128330qvk.57.1632904877600;
 Wed, 29 Sep 2021 01:41:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210830121006.2978297-1-maarten.lankhorst@linux.intel.com>
 <20210830121006.2978297-9-maarten.lankhorst@linux.intel.com> <CAM0jSHP7GtkRoDV+avUKyOe6SOce0ZO_2Tzg9p8O7KR9nWk_VQ@mail.gmail.com>
In-Reply-To: <CAM0jSHP7GtkRoDV+avUKyOe6SOce0ZO_2Tzg9p8O7KR9nWk_VQ@mail.gmail.com>
From:   Matthew Auld <matthew.william.auld@gmail.com>
Date:   Wed, 29 Sep 2021 09:40:49 +0100
Message-ID: <CAM0jSHNQURsnc6yXvZsdJrK_QKDPXEemBps4QgLgMTD1dJupCQ@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 08/19] drm/i915: Fix runtime pm handling in i915_gem_shrink
To:     Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc:     Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 29 Sept 2021 at 09:37, Matthew Auld
<matthew.william.auld@gmail.com> wrote:
>
> On Mon, 30 Aug 2021 at 13:10, Maarten Lankhorst
> <maarten.lankhorst@linux.intel.com> wrote:
> >
> > We forgot to call intel_runtime_pm_put on error, fix it!
> >
> > Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
> > Fixes: cf41a8f1dc1e ("drm/i915: Finally remove obj->mm.lock.")
> > Cc: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> > Cc: <stable@vger.kernel.org> # v5.13+
>
> How does the err handling work? gem_shrink is meant to return the
> number of pages reclaimed which is an unsigned long, and yet we are
> also just returning the err here? Fortunately it looks like nothing is
> calling gem_shrinker with an actual ww context, so nothing will hit
> this yet? I think the interface needs to be reworked or something.

Can we just remove the ww context argument, or is that needed for
something in the future?

>
> > ---
> >  drivers/gpu/drm/i915/gem/i915_gem_shrinker.c | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c b/drivers/gpu=
/drm/i915/gem/i915_gem_shrinker.c
> > index e382b7f2353b..5ab136ffdeb2 100644
> > --- a/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
> > +++ b/drivers/gpu/drm/i915/gem/i915_gem_shrinker.c
> > @@ -118,7 +118,7 @@ i915_gem_shrink(struct i915_gem_ww_ctx *ww,
> >         intel_wakeref_t wakeref =3D 0;
> >         unsigned long count =3D 0;
> >         unsigned long scanned =3D 0;
> > -       int err;
> > +       int err =3D 0;
> >
> >         /* CHV + VTD workaround use stop_machine(); need to trylock vm-=
>mutex */
> >         bool trylock_vm =3D !ww && intel_vm_no_concurrent_access_wa(i91=
5);
> > @@ -242,12 +242,15 @@ i915_gem_shrink(struct i915_gem_ww_ctx *ww,
> >                 list_splice_tail(&still_in_list, phase->list);
> >                 spin_unlock_irqrestore(&i915->mm.obj_lock, flags);
> >                 if (err)
> > -                       return err;
> > +                       break;
> >         }
> >
> >         if (shrink & I915_SHRINK_BOUND)
> >                 intel_runtime_pm_put(&i915->runtime_pm, wakeref);
> >
> > +       if (err)
> > +               return err;
> > +
> >         if (nr_scanned)
> >                 *nr_scanned +=3D scanned;
> >         return count;
> > --
> > 2.32.0
> >
