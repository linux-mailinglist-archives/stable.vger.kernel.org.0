Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1C63B84AA
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 16:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235854AbhF3OI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 10:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbhF3OHp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 10:07:45 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2443FC0613A2
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 07:05:14 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 22so3116919oix.10
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 07:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z2uiTpNersMN8HJUWHLpDYZtWDK8S9orWhI2Zo6WiGs=;
        b=oayVw5cjlZgx6zdpVUV/6ceXodfrKK37WnFyxV6ofinTSexATHYcZMeMEYfgO94S38
         LrIuKOU15J44jXucd9mHWIUvABQlWuBZ1uFrsoJJ8i1WSNDjxaFJP86bNVPHJfsWkfzk
         W4/ztA0rGxKru1iizX9yserjaIrTr5+v0fvZEzPNwXF/8LVwK7kwf3vlsqwATPd3zRRo
         diANT295/Wx0s0BtrSqvRYSDdyvksduwJ6ixANG0nXLnMzndD3zGqIWNVPnHvuvqH6Lk
         ZGZZwi3sE/8n0ehh5CAc3AqjWv/q06FAmQMzTAtHfdPn3FuhIAN9+nHKolVJCAPVIFk5
         +dRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z2uiTpNersMN8HJUWHLpDYZtWDK8S9orWhI2Zo6WiGs=;
        b=E9PjZap0+y6hmnybUTQc5fL2/FOn3h/8EW6yqNeMqpOJPoXgfVjmiWqE22CpAszASV
         QfZBahQSVAVgFYqrTH95StHo2vwDycSMNc/Mb58WCYrnlZrL+SmhHKC5tFZndHcfgRfA
         bSOyEmUidl3VQlWl9SymjWsPHqrRqS0y1w8a3ndG+gbju5VaCc41LuPFrVOuXSIngYx1
         opn28idkQpLQfFISSeqio3z5yH6zvHx1kOlhVBNVn+0rnRzQxnmeZVCJT7OOyMuK8OkS
         tljLxm6NxayUtdMAp/s8kAXcrhljL9CeIrAtADYSpHZIbwEHFgpgg6bMyJ/SZ45B6El4
         3+vw==
X-Gm-Message-State: AOAM530Vrz4gZ9O0UbJzXCrIIF9MWJpZLRY2vrOaKcDg0o3TvnIPK6ls
        3opZjqgyCLGD7aUwDJGGnCmInzifoJAWHI+5qLQWug==
X-Google-Smtp-Source: ABdhPJxXxHM73q0alhjLm92ujxh0zyleB4LmD3cFkecIwgewq4J+x1hrDugM3DPKVsWS2IjCw4cghadZ0kF/VXmM/hk=
X-Received: by 2002:a05:6808:7c8:: with SMTP id f8mr13788175oij.121.1625061912970;
 Wed, 30 Jun 2021 07:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210630135313.1072577-1-glider@google.com>
In-Reply-To: <20210630135313.1072577-1-glider@google.com>
From:   Marco Elver <elver@google.com>
Date:   Wed, 30 Jun 2021 16:05:00 +0200
Message-ID: <CANpmjNNWjks8fH6FBgjryEFm4z5vqn-ehyjXbcBj7x90hZpTjA@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] kfence: move the size check to the beginning of __kfence_alloc()
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
>
> Check the allocation size before toggling kfence_allocation_gate.
> This way allocations that can't be served by KFENCE will not result in
> waiting for another CONFIG_KFENCE_SAMPLE_INTERVAL without allocating
> anything.
>
> Suggested-by: Marco Elver <elver@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: stable@vger.kernel.org # 5.12+
> Signed-off-by: Alexander Potapenko <glider@google.com>

Reviewed-by: Marco Elver <elver@google.com>


> ---
>  mm/kfence/core.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 4d21ac44d5d35..33bb20d91bf6a 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -733,6 +733,13 @@ void kfence_shutdown_cache(struct kmem_cache *s)
>
>  void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
>  {
> +       /*
> +        * Perform size check before switching kfence_allocation_gate, so that
> +        * we don't disable KFENCE without making an allocation.
> +        */
> +       if (size > PAGE_SIZE)
> +               return NULL;
> +
>         /*
>          * allocation_gate only needs to become non-zero, so it doesn't make
>          * sense to continue writing to it and pay the associated contention
> @@ -757,9 +764,6 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
>         if (!READ_ONCE(kfence_enabled))
>                 return NULL;
>
> -       if (size > PAGE_SIZE)
> -               return NULL;
> -
>         return kfence_guarded_alloc(s, size, flags);
>  }
>
> --
> 2.32.0.93.g670b81a890-goog
>
