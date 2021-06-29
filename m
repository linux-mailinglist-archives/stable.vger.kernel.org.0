Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE2C3B7695
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 18:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbhF2Qnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 12:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbhF2Qn2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 12:43:28 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0522EC061766
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 09:40:48 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id v11-20020a4a8c4b0000b029024be8350c45so5817936ooj.12
        for <stable@vger.kernel.org>; Tue, 29 Jun 2021 09:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uELLVvexdDVZ7QoY/jcBV+gQtVgk5q8UpdZvDzEAtEY=;
        b=qVLx61deuLJ7bywIsa+tF05uKf/2+b8CeHj0rPEfLWxdLgu89IBSDgt3YkH7vGacMz
         nyCK9I57XTPgV0vRTioFcpOSilac9+BbCi5wsbe4bm8lYLVU/Sc8/8wSXbRu5cPQdjaC
         0vofil/WaPZIPbw6olol4kTB0ZI80Uj436XmmLqwyVcChB9dZIzyJZ296Jj9FUZutGU4
         rcNQztRL5FCRQQMVAlPidpfneYrvhUK6sgePq7j2h8OpKgt5Hy6JAqKkB+rZdyOnibu1
         kFXJejSoHzMus5qDag0ZkQRBL0bB2BL75ikXCj6nydZtygxeVb3/XsogU093pfqmozl8
         Y+DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uELLVvexdDVZ7QoY/jcBV+gQtVgk5q8UpdZvDzEAtEY=;
        b=FugIEWt5xoFinT37n90szSsgR23QTBq0XyTuPaoXceeReYInqYR+MpIYHRcebyGS0U
         vq54iK/75onWoJpxyl7IC6yK4m8uQxYbAgmDJoKDOsPsjhgF07N0am+oq03SLjxczLl1
         wZ+7JCfnE31A0rYPVMY1Ponal3DBB2VXT7yRD5R1rAjYU10NAWprUxgnIxBrbnlAZYCO
         0xVanOUq/WdB+dQJIDvtsexRYrynTMj6VrsOY0NtnE2H0i0RIg7NmlTGehrLTIWbCn9V
         v9qI4GGXS4dVBA+IBXql57j3QdUsGu/B8GoPj0hu9MwYk3Z3S5sOhS2ZsbbQpDP6HWBS
         tSSg==
X-Gm-Message-State: AOAM532gizxPPvgGM6rOapIgxyCmq53WCe+26H4nFDzXVsckQJl2O2VI
        4+n2SMrL9LUx5A7IdG6lXE70EBzm/zIDpstku++LrA==
X-Google-Smtp-Source: ABdhPJyfUcuxxTGNuv67eCqzzb2eh7tthiLbron1HVfPakPvQeEyKynR8racWmed8vyHpxzlYhl5tHUQC2/fv76TRms=
X-Received: by 2002:a4a:9406:: with SMTP id h6mr4789265ooi.36.1624984847148;
 Tue, 29 Jun 2021 09:40:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210629161738.936790-1-glider@google.com>
In-Reply-To: <20210629161738.936790-1-glider@google.com>
From:   Marco Elver <elver@google.com>
Date:   Tue, 29 Jun 2021 18:40:34 +0200
Message-ID: <CANpmjNM-gZyGivnJY-qzcn-pVmGon+Mfy8gNxsEvdUwOvPaqNA@mail.gmail.com>
Subject: Re: [PATCH v2] kfence: skip DMA allocations
To:     Alexander Potapenko <glider@google.com>
Cc:     akpm@linux-foundation.org, dvyukov@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 29 Jun 2021 at 18:17, Alexander Potapenko <glider@google.com> wrote:
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

Reviewed-by: Marco Elver <elver@google.com>

Thanks!


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
>         return kfence_guarded_alloc(s, size, flags);
>  }
>
> --
> 2.32.0.93.g670b81a890-goog
>
