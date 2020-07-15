Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C234C220BE8
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 13:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgGOL0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 07:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbgGOL0w (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 07:26:52 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7EAC061755
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 04:26:52 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t27so1617883ill.9
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 04:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=basnieuwenhuizen-nl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=COp5Uj1JYEJjbgvfwbwB526nGPvq1pgxwxhRQEYDs38=;
        b=zErirLMsjaDtIihNgfun5NFNN4muHJSCuQOaLA4CsB7XbCvRWzgi6EgbXr2iPgz1s6
         1GZvV2GnnB2ex0yWW+GFD9vrZQJNVuIUUfRNzfsL52pqiM6rW5mx4T7iWZBOYCDHXBvl
         b8ooATL5V4c+OKUvZl/uPSi1J3umNnC9G3HqJgfFUNZRfDx7KmEtK9aESdOpOwYuWku0
         /VRFME6GIgBUqj5hMt6ODzum3vK2XrTRAzmKgfh6G5FrbQiLtSZN263qawqElArPHIy3
         unPLYW5JXlQlPWx4pCTpmU9zBOmmidgGWNJwWmYtA8iLX9QQlWjn5jHeZaNzjbHLcOd6
         KT7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=COp5Uj1JYEJjbgvfwbwB526nGPvq1pgxwxhRQEYDs38=;
        b=d6UFfVITnh46KOWWS0y2P9QDtiI21bmwJhcDclahfuW5y/QyLuqYWXmRyiUYNnhef6
         plV3foDWFgw2D3nxmPqXDx7ppx8dfjBgh+JZUCcgVlWgnxcK86mDqNCheb6kfZRaG/qp
         Y6CyuroS8mju64v9spmKh1i1OLe5IaxpbacbwxwxRCCIWjppeDfdY71Qz0IkH7RV6KaG
         K2nGUAGeSNEAL9cwLBEOBIRduWYbdkgrtX1ZHmsNheQwvEod6d1k3NaOnLvSgfRshHzJ
         fgawJElGqy7QfzcQ9jrNx4JK21ObkkjyY8ztgfGkrravo5ZEzhUxSuIDZ64jvVHVin+s
         BlIw==
X-Gm-Message-State: AOAM532k5coH6VctANIXredYqXy2oX6leNBVXuqjfbtfmddmwLqoqO7/
        lf6VZ5yInx4EP+zjQSGDIbbLQokbY85u8mf0hQ3aoCR1WOI=
X-Google-Smtp-Source: ABdhPJwGcytIdVnCyjfSZgCsjpzt9ouJexyzvr7b1purwL8ETWMndS3H5iiBJzkyr59J6yheBaAEn+ACAU04AtVRseI=
X-Received: by 2002:a92:1b8c:: with SMTP id f12mr9162218ill.93.1594812411495;
 Wed, 15 Jul 2020 04:26:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200715100432.13928-1-chris@chris-wilson.co.uk> <20200715100432.13928-2-chris@chris-wilson.co.uk>
In-Reply-To: <20200715100432.13928-2-chris@chris-wilson.co.uk>
From:   Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Date:   Wed, 15 Jul 2020 13:26:40 +0200
Message-ID: <CAP+8YyFU1G84=0JAVeeK=cssc+GX5Jc1kYDyTTU8hYzrQzHHBQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] dma-buf/sw_sync: Avoid recursive lock during fence signal
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

Reviewed-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

On Wed, Jul 15, 2020 at 12:04 PM Chris Wilson <chris@chris-wilson.co.uk> wr=
ote:
>
> If a signal callback releases the sw_sync fence, that will trigger a
> deadlock as the timeline_fence_release recurses onto the fence->lock
> (used both for signaling and the the timeline tree).
>
> If we always hold a reference for an unsignaled fence held by the
> timeline, we no longer need to detach the fence from the timeline upon
> release. This is only possible since commit ea4d5a270b57
> ("dma-buf/sw_sync: force signal all unsignaled fences on dying timeline")
> where we introduced decoupling of the fences from the timeline upon relea=
se.
>
> Reported-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
> Fixes: d3c6dd1fb30d ("dma-buf/sw_sync: Synchronize signal vs syncpt free"=
)
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Gustavo Padovan <gustavo@padovan.org>
> Cc: Christian K=C3=B6nig <christian.koenig@amd.com>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/dma-buf/sw_sync.c | 32 +++++++-------------------------
>  1 file changed, 7 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
> index 348b3a9170fa..4cc2ac03a84a 100644
> --- a/drivers/dma-buf/sw_sync.c
> +++ b/drivers/dma-buf/sw_sync.c
> @@ -130,16 +130,7 @@ static const char *timeline_fence_get_timeline_name(=
struct dma_fence *fence)
>
>  static void timeline_fence_release(struct dma_fence *fence)
>  {
> -       struct sync_pt *pt =3D dma_fence_to_sync_pt(fence);
>         struct sync_timeline *parent =3D dma_fence_parent(fence);
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(fence->lock, flags);
> -       if (!list_empty(&pt->link)) {
> -               list_del(&pt->link);
> -               rb_erase(&pt->node, &parent->pt_tree);
> -       }
> -       spin_unlock_irqrestore(fence->lock, flags);
>
>         sync_timeline_put(parent);
>         dma_fence_free(fence);
> @@ -203,18 +194,11 @@ static void sync_timeline_signal(struct sync_timeli=
ne *obj, unsigned int inc)
>                 if (!timeline_fence_signaled(&pt->base))
>                         break;
>
> -               list_del_init(&pt->link);
> +               list_del(&pt->link);
>                 rb_erase(&pt->node, &obj->pt_tree);
>
> -               /*
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
> -                */
>                 dma_fence_signal_locked(&pt->base);
> +               dma_fence_put(&pt->base);
>         }
>
>         spin_unlock_irq(&obj->lock);
> @@ -261,13 +245,9 @@ static struct sync_pt *sync_pt_create(struct sync_ti=
meline *obj,
>                         } else if (cmp < 0) {
>                                 p =3D &parent->rb_left;
>                         } else {
> -                               if (dma_fence_get_rcu(&other->base)) {
> -                                       sync_timeline_put(obj);
> -                                       kfree(pt);
> -                                       pt =3D other;
> -                                       goto unlock;
> -                               }
> -                               p =3D &parent->rb_left;
> +                               dma_fence_put(&pt->base);
> +                               pt =3D other;
> +                               goto unlock;
>                         }
>                 }
>                 rb_link_node(&pt->node, parent, p);
> @@ -278,6 +258,7 @@ static struct sync_pt *sync_pt_create(struct sync_tim=
eline *obj,
>                               parent ? &rb_entry(parent, typeof(*pt), nod=
e)->link : &obj->pt_list);
>         }
>  unlock:
> +       dma_fence_get(&pt->base); /* keep a ref for the timeline */
>         spin_unlock_irq(&obj->lock);
>
>         return pt;
> @@ -316,6 +297,7 @@ static int sw_sync_debugfs_release(struct inode *inod=
e, struct file *file)
>         list_for_each_entry_safe(pt, next, &obj->pt_list, link) {
>                 dma_fence_set_error(&pt->base, -ENOENT);
>                 dma_fence_signal_locked(&pt->base);
> +               dma_fence_put(&pt->base);
>         }
>
>         spin_unlock_irq(&obj->lock);
> --
> 2.20.1
>
