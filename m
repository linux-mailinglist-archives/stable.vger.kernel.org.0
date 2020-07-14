Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E504921F919
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728118AbgGNSSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728117AbgGNSSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 14:18:08 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACA8C061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 11:18:07 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id a12so18272072ion.13
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 11:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=basnieuwenhuizen-nl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qP0R56NmACuZfQBOGe7GHMFJGEspG1ZFRF+wSCIliJY=;
        b=k7LlDSWzO2k8YDSqu0v9vHtVhhsIcXCux8SWVgG0f+jVgrUOodGu+YMrocHSzmn4P7
         3M9ekimxEBROcTQjoEHfM92T7D2FyiN7Mrq1iAzBl2b/4fElZ3NKy1OD4n3GkCkQk7nn
         LRS/po/899R9sYQL9rCT9iQDVO2gFRs40vaIUUlVRECgwdfRSgufwzHNDV9KUHD14TEv
         My6vjIO0zL4MKN41Io3L0yyJdvdJq+jlWjGUPKS7MT021gePuB3vqI+vHhMJ4xec6NUm
         3kMuPhMUgrdWfuSQt4ex0/Pn1ScNV8omFbTQBcd5v9ETRi8rDloKpMXiO9dSLuCtGZ9/
         ehZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qP0R56NmACuZfQBOGe7GHMFJGEspG1ZFRF+wSCIliJY=;
        b=oMexMe4aB/vWvet+0QwW1zPJleJ/tGB0Q2V3eZZmHh+XZaftzFmpDqcMc4Yh0IHOuX
         CvvNQpWXwstSFzl3FXbUqfEaWWJPqn42W5SmZGpNdbpKDNrSgFJ3uq9HtBeEuSMBri+f
         Ighfvz0hDN1HvztNSyM6f6cjlIp3TebOZjmIvGQwJrU0YYFZ2shc3EoiOSgzsr/7Bp+I
         2P+MWIYmxwBNtnI4B47coJUfF4k1d/EY9I16ClHF+Im4nUV6uB84jeLwjhjKxHzRsIol
         mawtjX+lpBut49VBbg3Vlk0lVxuwjqDl06UV+h5CjkLs9/ypAyi+1BtoVFsNhqOh+Cep
         dwcw==
X-Gm-Message-State: AOAM530i0tRu7C8htMNCNgs6MlFT1UBjPwWtqhAosEsEy/CmVWNkP7cO
        alzyyaFeoxdvZwtnYpbX4wLL+hD5OxU1xRqwqpGGwg==
X-Google-Smtp-Source: ABdhPJwnlPdwQytQb8lIOgL9ShjgfiAklsx46CixJItkK4hiNbgHDnKPB5MOXMBRGj7S1GkhFqT/hK95Y383cfZXeGo=
X-Received: by 2002:a6b:6510:: with SMTP id z16mr6192789iob.136.1594750687096;
 Tue, 14 Jul 2020 11:18:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200714154102.450826-1-bas@basnieuwenhuizen.nl> <159474395996.28702.17306720345476579062@build.alporthouse.com>
In-Reply-To: <159474395996.28702.17306720345476579062@build.alporthouse.com>
From:   Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Date:   Tue, 14 Jul 2020 20:17:21 +0200
Message-ID: <CAP+8YyHnBB1AZ5XwEoaiy8pnDg2gNNKtJGweSiqunbmaaNsY6A@mail.gmail.com>
Subject: Re: [PATCH] dma-buf/sw_sync: Avoid recursive lock during fence signal.
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     ML dri-devel <dri-devel@lists.freedesktop.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 14, 2020 at 6:26 PM Chris Wilson <chris@chris-wilson.co.uk> wro=
te:
>
> Quoting Bas Nieuwenhuizen (2020-07-14 16:41:02)
> > Calltree:
> >   timeline_fence_release
> >   drm_sched_entity_wakeup
> >   dma_fence_signal_locked
> >   sync_timeline_signal
> >   sw_sync_ioctl
> >
> > Releasing the reference to the fence in the fence signal callback
> > seems reasonable to me, so this patch avoids the locking issue in
> > sw_sync.
> >
> > d3862e44daa7 ("dma-buf/sw-sync: Fix locking around sync_timeline lists"=
)
> > fixed the recursive locking issue but caused an use-after-free. Later
> > d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt free")
> > fixed the use-after-free but reintroduced the recursive locking issue.
> >
> > In this attempt we avoid the use-after-free still because the release
> > function still always locks, and outside of the locking region in the
> > signal function we have properly refcounted references.
> >
> > We furthermore also avoid the recurive lock by making sure that either:
> >
> > 1) We have a properly refcounted reference, preventing the signal from
> >    triggering the release function inside the locked region.
> > 2) The refcount was already zero, and hence nobody will be able to trig=
ger
> >    the release function from the signal function.
> >
> > Fixes: d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt fre=
e")
> > Cc: Sumit Semwal <sumit.semwal@linaro.org>
> > Cc: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Gustavo Padovan <gustavo@padovan.org>
> > Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> > ---
> >  drivers/dma-buf/sw_sync.c | 28 ++++++++++++++++++++--------
> >  1 file changed, 20 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
> > index 348b3a9170fa..30a482f75d56 100644
> > --- a/drivers/dma-buf/sw_sync.c
> > +++ b/drivers/dma-buf/sw_sync.c
> > @@ -192,9 +192,12 @@ static const struct dma_fence_ops timeline_fence_o=
ps =3D {
> >  static void sync_timeline_signal(struct sync_timeline *obj, unsigned i=
nt inc)
> >  {
> >         struct sync_pt *pt, *next;
> > +       struct list_head ref_list;
> >
> >         trace_sync_timeline(obj);
> >
> > +       INIT_LIST_HEAD(&ref_list);
> > +
> >         spin_lock_irq(&obj->lock);
> >
> >         obj->value +=3D inc;
> > @@ -206,18 +209,27 @@ static void sync_timeline_signal(struct sync_time=
line *obj, unsigned int inc)
> >                 list_del_init(&pt->link);
> >                 rb_erase(&pt->node, &obj->pt_tree);
> >
> > -               /*
> > -                * A signal callback may release the last reference to =
this
> > -                * fence, causing it to be freed. That operation has to=
 be
> > -                * last to avoid a use after free inside this loop, and=
 must
> > -                * be after we remove the fence from the timeline in or=
der to
> > -                * prevent deadlocking on timeline->lock inside
> > -                * timeline_fence_release().
> > -                */
> > +               /* We need to take a reference to avoid a release durin=
g
> > +                * signalling (which can cause a recursive lock of obj-=
>lock).
> > +                * If refcount was already zero, another thread is alre=
ady taking
> > +                * care of destructing the fence, so the signal cannot =
release
> > +                * it again and we hence will not have the recursive lo=
ck. */
>
> /*
>  * Block commentary style:
>  * https://www.kernel.org/doc/html/latest/process/coding-style.html#comme=
nting
>  */
>
> > +               if (dma_fence_get_rcu(&pt->base))
> > +                       list_add_tail(&pt->link, &ref_list);
>
> Ok.
>
> > +
> >                 dma_fence_signal_locked(&pt->base);
> >         }
> >
> >         spin_unlock_irq(&obj->lock);
> > +
> > +       list_for_each_entry_safe(pt, next, &ref_list, link) {
> > +               /* This needs to be cleared before release, otherwise t=
he
> > +                * timeline_fence_release function gets confused about =
also
> > +                * removing the fence from the pt_tree. */
> > +               list_del_init(&pt->link);
> > +
> > +               dma_fence_put(&pt->base);
> > +       }
>
> How serious is the problem of one fence callback freeing another pt?
>
> Following the pattern here
>
>         spin_lock(&obj->lock);
>         list_for_each_entry_safe(pt, next, &obj->pt_list, link) {
>                 if (!timeline_fence_signaled(&pt->base))
>                         break;
>
>                 if (!dma_fence_get_rcu(&pt->base))
>                         continue; /* too late! */
>
>                 rb_erase(&pt->node, &obj->pt_tree);
>                 list_move_tail(&pt->link, &ref_list);
>         }
>         spin_unlock(&obj->lock);
>
>         list_for_each_entry_safe(pt, next, &ref_list, link) {
>                 list_del_init(&pt->link);
>                 dma_fence_signal(&pt->base);

Question is what the scope should be. Using this method we only take a
reference and avoid releasing the fences we're going to signal.
However the lock is on the timeline and dma_fence_signal already takes
the lock, so if the signal ends up releasing any of the other fences
in the timeline (e.g. the fences that are later than the new value),
then we are still going to have the recursive locking issue.

One solution to that would be splitting the lock into 2 locks: 1
protecting pt_list + pt_tree and 1 protecting value & serving as the
lock for the fences. Then we can only take the list lock in the
release function and dma_fence_signal takes the value lock. However,
then you still have issues like if a callback for fence A (when called
it holds the lock of A's timeline) adds a callback to fence B of the
same timeline (requires the fence lock) we still have a recursion
locking issue.

I'm not sure it is reasonable for the last use case to work, because I
only see it working with per-fence locks, but per-fence locks are
deadlock prone due to the order of taking links not really being
fixed.



>                 dma_fence_put(&pt->base);
>         }
>
> Marginal extra cost for signaling along the debug sw_timeline for total
> peace of mind.
> -Chris
