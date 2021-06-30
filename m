Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706943B7DCD
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 09:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232704AbhF3HFZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 03:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232018AbhF3HFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 03:05:25 -0400
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306CDC061766;
        Wed, 30 Jun 2021 00:02:56 -0700 (PDT)
Received: by mail-ua1-x933.google.com with SMTP id c20so618764uar.12;
        Wed, 30 Jun 2021 00:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DWGJQjLPHSCbQm/Yojx5qSO/ziuBYx37jmq+GyBBQNA=;
        b=NRSymyDmOFevXISrQD3H5aC2pmJ6AvTmWud+3xO6T5O2wvFj+vqFmQ1bd4TL9qyvRH
         rYtv3y3KDLfgQjQ1i1t5WJsQd3qSgLQwLgQisQTKENnPkk+86N+QISP02Qhh2n4PzA1H
         RA4FsznmVS6Lf7j9EUQypfp+Y401dXqSzp8nqNYPxHAjjbHxz2PrPxGozTyGVFtX8Ycg
         PRF29KJaC55AAv07F58A7UR/z/hOwVH0m7dOmmDIPOXQ1VZf03hSa2K6CsnYVCtn8TTf
         326E6AG82FdSH7WpmR0LLSXJ/KFAgHpClrWpwKcPbpRKdBexW79Uh3p/CWEKFVGRkhXR
         qWag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DWGJQjLPHSCbQm/Yojx5qSO/ziuBYx37jmq+GyBBQNA=;
        b=k7G9UCskDvr0YBPu6yWhr4L/lMhd2jNLhztX0FD6biDT8DkjLBOEg7Fj1FyaTD893o
         Q7QbIAp4GPEutDuByApON5807N7kZfG6LkChF56tRIhZIFWet9f4a2bk2uMGfgRSrPEr
         J0YCh5GhLhscN5OGi/MZHPUlQA1KJbCCucSs+9x0KdDRMFvjD95lP0ufh2CsfwOb8cvi
         i5QDQL0jMTO2mefEylscZjgL9/eK7K/HQTuw9lxnhrJCPWWLgF73g1mGMI9F1OyoswDG
         bEW0VDUs3li1BJlP9OEI8WmY8hawPPn0pGpdmcgg/cmJTbJOnZgFcVRY+50od4oTmbKL
         XYNA==
X-Gm-Message-State: AOAM532PiizCYpMV8BXEYhfNwJIR9OSWtqDaEfnHxtVYx93Y4XmDXe4b
        ILxk/XyDsVgE2Xn96X3QU3i3GA6XQFzy8ZzscXI=
X-Google-Smtp-Source: ABdhPJwYoGKIfotZeQTeYk/Fps+YEiMMdTjYBiQq8rzg4yQdxhpX9sPXUqSrgq0gFfUdpgg66wWjoHgyfiEgZAhLJ+Q=
X-Received: by 2002:ab0:36da:: with SMTP id v26mr14995990uau.118.1625036575349;
 Wed, 30 Jun 2021 00:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210629161738.936790-1-glider@google.com>
In-Reply-To: <20210629161738.936790-1-glider@google.com>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Wed, 30 Jun 2021 12:32:43 +0530
Message-ID: <CAFqt6zZ8ZL8WtTg368VJ0WHjXc+YzMuA9D8OBXJ5T9j0ePctQQ@mail.gmail.com>
Subject: Re: [PATCH v2] kfence: skip DMA allocations
To:     Alexander Potapenko <glider@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Vyukov <dvyukov@google.com>, elver@google.com,
        linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>,
        stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 29, 2021 at 9:47 PM Alexander Potapenko <glider@google.com> wrote:
>
> Allocation requests with __GFP_DMA/__GFP_DMA32 or
> SLAB_CACHE_DMA/SLAB_CACHE_DMA32 cannot be fulfilled by KFENCE, because
> they must reside in low memory, whereas KFENCE memory pool is located in
> high memory.
>
> Skip such allocations to avoid crashes where DMAable memory is expected.
>
> Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org # 5.12+
> Signed-off-by: Alexander Potapenko <glider@google.com>
>
> ---
>
> v2:
>  - added parentheses around the GFP clause, as requested by Marco
> ---
>  mm/kfence/core.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 4d21ac44d5d35..f7ce3d876bc9e 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -760,6 +760,14 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
>         if (size > PAGE_SIZE)
>                 return NULL;
>
> +       /*
> +        * Skip DMA allocations. These must reside in the low memory, which we
> +        * cannot guarantee.
> +        */
> +       if ((flags & (__GFP_DMA | __GFP_DMA32)) ||
> +           (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32)))
> +               return NULL;
> +

I prefer to move this check at the top of the function.
Although it won't make much difference except avoiding atomic operations
in case this condition is true.

>         return kfence_guarded_alloc(s, size, flags);
>  }
>
> --
> 2.32.0.93.g670b81a890-goog
>
>
