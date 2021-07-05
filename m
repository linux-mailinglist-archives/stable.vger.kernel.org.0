Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F155A3BC2C5
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 20:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhGESli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 14:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhGESli (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 14:41:38 -0400
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B63EC061574;
        Mon,  5 Jul 2021 11:39:01 -0700 (PDT)
Received: by mail-vk1-xa2f.google.com with SMTP id x125so3567241vkf.0;
        Mon, 05 Jul 2021 11:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8RGR343XciEw4r49tal51/o0IM93ao9egPitNRMuYtk=;
        b=LUzCOtv0sQoF7PFn+gm4X8wvqk87wizhwa7fYe8hCDBmXKYnrbEdIMLhFkQAqSOfDt
         +WmCSX+z2U6g6EIh/l4o1wZzjHGE3mPpplY61u2JX9FwynvisiZ2ek3QoOQscTUvW/ah
         g6lSbZfrvo4Mws/eU8DxuSmLPrazYa4ddHgsvN4q9mbcaPG7hF+fnDa/y+TQaGFFBFFF
         1v3JLvVBZS3N3kFMn2v5kVD7atZwk8ROlSrNl8/X6Q05QMC+jSFMtcFU3sogY+3YCAb5
         gZ7KJSfS2cBEQ+yWDa2XjCgaw5h/cc77OOtRHYTxuyc4bbol57kW8vqCJWzaV2hYInw8
         wZlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8RGR343XciEw4r49tal51/o0IM93ao9egPitNRMuYtk=;
        b=t1DL4dnjp23zktHw0ghrSOWEuun1nGlHJwLo3AIOD0F4bFaOb2y344OsNtfGHW/fdU
         P2v/dh6G/RtIemWVtBhIASjc8KvoqLy1q3XnFPDB5etcYSlKAveTSr/ZIJcSQ2cTvf9a
         Ma46UMzZCeQaQIwUKUJq3t7kzXJVK9QP+31YzeYK5RQDQlWwc22iw5Q+CFcsCgjTy84D
         /ijpzo6Emcf6kpuk+5Xhh2VmPm0S3p1c6+J2rxMwVE64yXP+FpYF1zUvRy6DEREEoFtL
         gzSXYqgXp5vhh+RklrWunc9AJuG+3rj2bcaKKcC/Nc15hzwTui2n/Ptk6WZFSGfhZXCs
         n47w==
X-Gm-Message-State: AOAM533kdhniHFreGy8lVvgPNGdF4YdiYn8sGri8IEvd53A2oVZWQgEF
        lGpLcPHCmTUYFWqukSv51BnXFqOtPVYAyk2LVM8=
X-Google-Smtp-Source: ABdhPJyDAA8P3Y7ihO5d6u3yIu3VvIZsmID2jcLyEH5yrlCwDbJKyBIZykRzPvKEuYIJvAhkbV5eomSVxutLUcA5iLk=
X-Received: by 2002:a1f:1d94:: with SMTP id d142mr9920891vkd.6.1625510340577;
 Mon, 05 Jul 2021 11:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210630150234.1109496-1-glider@google.com> <20210630150234.1109496-2-glider@google.com>
In-Reply-To: <20210630150234.1109496-2-glider@google.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Tue, 6 Jul 2021 00:08:48 +0530
Message-ID: <CAFqt6za+n_12WpNFLOVK1s3kZ4_3eUNLycj0m41+vOLs1OpLPQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] kfence: skip all GFP_ZONEMASK allocations
To:     Alexander Potapenko <glider@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org,
        Linux-MM <linux-mm@kvack.org>, stable@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 30, 2021 at 8:32 PM Alexander Potapenko <glider@google.com> wrote:
>
> Allocation requests outside ZONE_NORMAL (MOVABLE, HIGHMEM or DMA) cannot
> be fulfilled by KFENCE, because KFENCE memory pool is located in a
> zone different from the requested one.
>
> Because callers of kmem_cache_alloc() may actually rely on the
> allocation to reside in the requested zone (e.g. memory allocations done
> with __GFP_DMA must be DMAable), skip all allocations done with
> GFP_ZONEMASK and/or respective SLAB flags (SLAB_CACHE_DMA and
> SLAB_CACHE_DMA32).
>
> Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Souptick Joarder <jrdr.linux@gmail.com>
> Cc: stable@vger.kernel.org # 5.12+
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Reviewed-by: Marco Elver <elver@google.com>
>
> ---
>
> v2:
>  - added parentheses around the GFP clause, as requested by Marco
> v3:
>  - ignore GFP_ZONEMASK, which also covers __GFP_HIGHMEM and __GFP_MOVABLE
>  - move the flag check at the beginning of the function, as requested by
>    Souptick Joarder

Acked-by: Souptick Joarder <jrdr.linux@gmail.com>

> v4:
>  - minor fixes to description and comment formatting
> ---
>  mm/kfence/core.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 33bb20d91bf6a..1cbdb62e6d0fb 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -740,6 +740,15 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
>         if (size > PAGE_SIZE)
>                 return NULL;
>
> +       /*
> +        * Skip allocations from non-default zones, including DMA. We cannot
> +        * guarantee that pages in the KFENCE pool will have the requested
> +        * properties (e.g. reside in DMAable memory).
> +        */
> +       if ((flags & GFP_ZONEMASK) ||
> +           (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32)))
> +               return NULL;
> +
>         /*
>          * allocation_gate only needs to become non-zero, so it doesn't make
>          * sense to continue writing to it and pay the associated contention
> --
> 2.32.0.93.g670b81a890-goog
>
