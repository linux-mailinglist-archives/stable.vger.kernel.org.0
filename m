Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59FA3B84A3
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 16:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235826AbhF3OH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 10:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbhF3OGz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 10:06:55 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6ECC06122F
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 07:03:09 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id g3-20020a4ae8830000b029024c9afa2547so647798ooe.6
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 07:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c0F//f0x+IlSuTVhD2o09FmJBTCLPD1WCy4S2G9ePpc=;
        b=a/z4bOFfSrZMHOKq5nfEiUadvfO9+JWMzXVisHQSDedJlx2RH1WWBTmLDfoP3mBcqk
         9t5uMt+LafclLyJtVbIYofEIeLsPuQGK+gRNQKyq1jgdZesUWyYgfJUbr7j6j0gwqkGs
         9LMkxjqjGFyiXtkz3b272td5PsqwfV+pwgfxudf2tQvTt2/J5+1MfWEHJfXQCJPIP7Xq
         AuWIshMO2OFbzJwXxyAVl9XrT8q5hc2ejH7LwaZpghqKIBEpexfL1nqL9gIz4cVHw+nN
         4XaFnYBXIrDLHFwmghFwT5h3lf8ipJiRDNdEpcABg2X4WP1mH+6MObCP1xcExYBn33p4
         59vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c0F//f0x+IlSuTVhD2o09FmJBTCLPD1WCy4S2G9ePpc=;
        b=Sf/w3HYb9bGL//FSm7DqxFWElwUvoHZIZzJEIPNzBfRDkm+1wyC/X2PeguSRFClY0w
         2WesZH7leROcsmI/DN8LnEy3rFJfEUFlCjiCIQYHQ2w2vzH4tl7mFL/mCqOdRjbAec5N
         IJnR64CcuQGS+xuXHN9N6BqQsH25pTVhQhM5v7Onct+qZ6Z2SEbwp3Xw6eO1R745JrrB
         Guakt5RoiwTyJJCh5Juv5sFjdAV7dOwKkKDZxSKhcWzcEOHwdW9NrnT9ZENmtvlP2pyc
         ECN7pzPriYwVbWfXEhGB9rzxrWRfmip+gD5cMorUzKOYVPiGE4TX/aJh+JEpY8RBsrMs
         cBkQ==
X-Gm-Message-State: AOAM531wj8TEjc1HI/tbuxgkKQYWT2gkiEUWTQag3/Q6/r/VuRrSK5eX
        W30seGPWSd+ZC8Xhn3bjCABrkUGZmB5B90zs4j+QSw==
X-Google-Smtp-Source: ABdhPJzhU6va1OQ+ffknnRGi+3XNwnd77TIu63SOlmaTjFu4VTxpZBUWtxk+KN60aRBNpB1K8W1vcePNsu1717j+uRY=
X-Received: by 2002:a4a:6049:: with SMTP id t9mr8547439oof.14.1625061788645;
 Wed, 30 Jun 2021 07:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210630135313.1072577-1-glider@google.com> <20210630135313.1072577-2-glider@google.com>
In-Reply-To: <20210630135313.1072577-2-glider@google.com>
From:   Marco Elver <elver@google.com>
Date:   Wed, 30 Jun 2021 16:02:53 +0200
Message-ID: <CANpmjNPuFY66OwXxTvGs_t8eic1et9ZMJV5RDL_mkPVNkHqHzg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] kfence: skip all GFP_ZONEMASK allocations
To:     Alexander Potapenko <glider@google.com>
Cc:     akpm@linux-foundation.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org,
        jrdr.linux@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 30 Jun 2021 at 15:53, Alexander Potapenko <glider@google.com> wrote:
> Allocation requests outside ZONE_NORMAL (MOVABLE, HIGHMEM or DNA) cannot

s/DNA/DMA/
... but probably no need to do v4 just for this (everyone knows we're
not yet in the business of allocating DNA ;-)).

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

With the change below, you can add:

  Reviewed-by: Marco Elver <elver@google.com>


> ---
>
> v2:
>  - added parentheses around the GFP clause, as requested by Marco
> v3:
>  - ignore GFP_ZONEMASK, which also covers __GFP_HIGHMEM and __GFP_MOVABLE
>  - move the flag check at the beginning of the function, as requested by
>    Souptick Joarder
> ---
>  mm/kfence/core.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 33bb20d91bf6a..d51f77329fd3c 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -740,6 +740,14 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
>         if (size > PAGE_SIZE)
>                 return NULL;
>
> +       /*
> +        * Skip allocations from non-default zones, including DMA. We cannot guarantee that pages
> +        * in the KFENCE pool will have the requested properties (e.g. reside in DMAable memory).

Comments should still be 80 cols, like the rest of the file. :-/

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
