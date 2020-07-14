Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C1B21FE5C
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 22:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgGNUP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 16:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgGNUP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 16:15:27 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C4AC061755
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 13:15:27 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l17so7184908iok.7
        for <stable@vger.kernel.org>; Tue, 14 Jul 2020 13:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=basnieuwenhuizen-nl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/p+bzwQ5QmwSIzj6F5AB3nkYDC6rYoTIEY0YZ290OuQ=;
        b=XFk3n0rC1iLpK80lY+HAOO1hbISONecERQS6IMwz1DkGmZrBJDxS1q2tfAPOgs5tJT
         QVtM2ceFLcUn64poiMwiP9T8x47Gyd9jYo66OPWOAlF8gah2QUztXKlAMYJB/TGMePkX
         rUkkrr6/uRaxzvHY5wQlniEV6Y1OM+AZejg5DpMeOc7YxjYLCu7Va7K22Zrjgi7DkVY6
         IbpGJDcU9/sigTr9SrZvm81ql6U62wCZ49+d4FFyR2oIdww+BW47IkzCkueVbqG5IPDr
         XBpUFTUX6AXJdfnJob5g9djHoX7pfHe2iTIJS998V/Opugxy3/OGm8Prnzv1YB11mROB
         Z3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/p+bzwQ5QmwSIzj6F5AB3nkYDC6rYoTIEY0YZ290OuQ=;
        b=gMvG/SSyvGYk04HULTVaFxq5Kg54H4fyFOnZpwt5KmQcZljmh5TeJd9GNkXTPLMRyf
         eIDU+RFeK7CXXMtV/KQV2cYkD1WC0Le0CEyBT/o5qsuZq+iGgbOOCE3qbvBA17bFnpTY
         cuEQQ81cAhMGGWEcDl/S+Z1Ty7bawxlICktqm55zbDd86ZUJqJ5UwuSUOVHUgfrDT4OD
         ItcJd+9rAinqpMLSmXhcISwru2FPGHeR+118s+BxS5F4tPwuibsitlUCA4XvyimcxznF
         vKd+8YE4mgbIHlhdkItvEBrbqOXUcX1qUx0P4ySzw9wNufsbVu1g4W814t/w9RalJZVT
         cI8w==
X-Gm-Message-State: AOAM532Ye6rTgBa9hBNpxmlaJJRZMiKgfWNRLMOgxBKDMO0N4iPOLK4C
        dQUJm0mcglv4GDwf0NL3vMDu2LwQ0vK/GX1o6LkOyg==
X-Google-Smtp-Source: ABdhPJwDIGVrJ7lxywITvDgwcv+EfcTlfNr95Jjd9li82NJlpmmppxQ7J1WX4hGgfSFieyM5CTPkkDsIYmau/LZrIHs=
X-Received: by 2002:a05:6602:22d5:: with SMTP id e21mr4801657ioe.98.1594757726673;
 Tue, 14 Jul 2020 13:15:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200714200646.14041-1-chris@chris-wilson.co.uk>
In-Reply-To: <20200714200646.14041-1-chris@chris-wilson.co.uk>
From:   Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Date:   Tue, 14 Jul 2020 22:14:40 +0200
Message-ID: <CAP+8YyFz5qii=3pK4t2GKxgC=z6_Q0dsGTGzXX=tUgLihrp41g@mail.gmail.com>
Subject: Re: [PATCH 1/3] dma-buf/sw_sync: Avoid recursive lock during fence signal.
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     ML dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx@lists.freedesktop.org,
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

Thanks for updating the patch. LGTM

On Tue, Jul 14, 2020 at 10:07 PM Chris Wilson <chris@chris-wilson.co.uk> wr=
ote:
>
> From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
>
> Calltree:
>   timeline_fence_release
>   drm_sched_entity_wakeup
>   dma_fence_signal_locked
>   sync_timeline_signal
>   sw_sync_ioctl
>
> Releasing the reference to the fence in the fence signal callback
> seems reasonable to me, so this patch avoids the locking issue in
> sw_sync.
>
> d3862e44daa7 ("dma-buf/sw-sync: Fix locking around sync_timeline lists")
> fixed the recursive locking issue but caused an use-after-free. Later
> d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt free")
> fixed the use-after-free but reintroduced the recursive locking issue.
>
> In this attempt we avoid the use-after-free still because the release
> function still always locks, and outside of the locking region in the
> signal function we have properly refcounted references.
>
> We furthermore also avoid the recurive lock by making sure that either:
>
> 1) We have a properly refcounted reference, preventing the signal from
>    triggering the release function inside the locked region.
> 2) The refcount was already zero, and hence nobody will be able to trigge=
r
>    the release function from the signal function.
>
> v2: Move dma_fence_signal() into second loop in preparation to moving
> the callback out of the timeline obj->lock.
>
> Fixes: d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt free"=
)
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>  drivers/dma-buf/sw_sync.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
> index 348b3a9170fa..807c82148062 100644
> --- a/drivers/dma-buf/sw_sync.c
> +++ b/drivers/dma-buf/sw_sync.c
> @@ -192,6 +192,7 @@ static const struct dma_fence_ops timeline_fence_ops =
=3D {
>  static void sync_timeline_signal(struct sync_timeline *obj, unsigned int=
 inc)
>  {
>         struct sync_pt *pt, *next;
> +       LIST_HEAD(signal);
>
>         trace_sync_timeline(obj);
>
> @@ -203,21 +204,32 @@ static void sync_timeline_signal(struct sync_timeli=
ne *obj, unsigned int inc)
>                 if (!timeline_fence_signaled(&pt->base))
>                         break;
>
> -               list_del_init(&pt->link);
> -               rb_erase(&pt->node, &obj->pt_tree);
> -
>                 /*
> -                * A signal callback may release the last reference to th=
is
> -                * fence, causing it to be freed. That operation has to b=
e
> -                * last to avoid a use after free inside this loop, and m=
ust
> -                * be after we remove the fence from the timeline in orde=
r to
> -                * prevent deadlocking on timeline->lock inside
> -                * timeline_fence_release().
> +                * We need to take a reference to avoid a release during
> +                * signalling (which can cause a recursive lock of obj->l=
ock).
> +                * If refcount was already zero, another thread is alread=
y
> +                * taking care of destroying the fence.
>                  */
> -               dma_fence_signal_locked(&pt->base);
> +               if (!dma_fence_get_rcu(&pt->base))
> +                       continue;
> +
> +               list_move_tail(&pt->link, &signal);
> +               rb_erase(&pt->node, &obj->pt_tree);
>         }
>
>         spin_unlock_irq(&obj->lock);
> +
> +       list_for_each_entry_safe(pt, next, &signal, link) {
> +               /*
> +                * This needs to be cleared before release, otherwise the
> +                * timeline_fence_release function gets confused about al=
so
> +                * removing the fence from the pt_tree.
> +                */
> +               list_del_init(&pt->link);
> +
> +               dma_fence_signal(&pt->base);
> +               dma_fence_put(&pt->base);
> +       }
>  }
>
>  /**
> --
> 2.20.1
>
