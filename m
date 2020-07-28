Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96195230AC5
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 14:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729782AbgG1M5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 08:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729622AbgG1M5S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 08:57:18 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566D1C0619D2
        for <stable@vger.kernel.org>; Tue, 28 Jul 2020 05:57:18 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d1so9850774plr.8
        for <stable@vger.kernel.org>; Tue, 28 Jul 2020 05:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jGv59OL3eBSwcPKc8/h9cDYwkm0Ga9KFVIVK1NEWRJE=;
        b=SNQADGVnE0GT2O1e70IvNnIdtBVC4WTc8bSWAD5HxNOIq9P1xHSKpegGI6WKHj2wz6
         1gz19deudrkxNb9cNbrDAXXSOkqEdWfAquJnQu1/sPK7we2vCeOB9tYCa88Czg/oqkd2
         a2+OCvZ/gy2eUX8qxOx0YGJ9RROfHCz+duDtMWGV3xV9/Wk/rs8iyqBe8irr2jETNMl3
         K5fNojIW+bkRFjYqCrEUTDq1SHAnJ0ONf972MRoy9gaFBxUcy5pv2sEAp2h6Q82ek7AE
         Q0B+C2WLgtVFYWLO4+DDDDEqCNpw8XCzvbpDXb5h8d8OVGiB2zQ1yZ0rjpZ1aqeG2+qX
         Oorw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jGv59OL3eBSwcPKc8/h9cDYwkm0Ga9KFVIVK1NEWRJE=;
        b=SktBH7eHaMMugLF3XG7244d2g4Jars0kOEBjYu4yxXHJJ7ny1sqkEK+GsJFUVJRnjG
         eiiJDyqpTn3aOIHtnIlSRTpu8dtrDKQaMXNhIA2GPsf0KYXc1R7VNE8KLDQ6mgYzd4y9
         4vwZQjlna/2742SFK8pAiilrug/SHsw3p7GflIU59Q+1LOTm3vZbbUtl6XsT6fR+erUu
         f3YD+aImbnzdhCKBQ+Dv6erdC1jZbjuYFJqsN1XJFHeKn15mOoICdhh+z4yviM3W7MGT
         x/n3ABFnqDYpeRCBnfnzwQevKdnuCpGEdqWzvNqmPFb8/DxS9UViFrc/3zPvjz+06Bcq
         Ua/A==
X-Gm-Message-State: AOAM5325NtQQ8aN0jXk9vd8uUsIYkGw5jzzMDJ2hmRzyzjC0nR/IYXFx
        Ak7vWFsuAtse8OvrMjFP3fNwb/iU6obA8tUHmeuJjQ==
X-Google-Smtp-Source: ABdhPJzkoNBZsvO7dZrfGpe7loV05LDnvZRT8DVZMLBwOq1H+rzaEz8juFb93qjBu8kbRj7UBAau9HT+us4b4tJg66A=
X-Received: by 2002:a17:902:9b97:: with SMTP id y23mr23964341plp.189.1595941037785;
 Tue, 28 Jul 2020 05:57:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200727134914.312934924@linuxfoundation.org> <20200727134918.205538211@linuxfoundation.org>
In-Reply-To: <20200727134918.205538211@linuxfoundation.org>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Tue, 28 Jul 2020 20:56:41 +0800
Message-ID: <CAMZfGtWVtGeMfu=04LiNVcLrBpmexUryHjy-dujo77CpJhcwGg@mail.gmail.com>
Subject: Re: [External] [PATCH 4.19 76/86] mm: memcg/slab: fix memory leak at
 non-root kmem_cache destroy
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Roman Gushchin <guro@fb.com>, Vlastimil Babka <vbabka@suse.cz>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 27, 2020 at 10:12 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Muchun Song <songmuchun@bytedance.com>
>
> commit d38a2b7a9c939e6d7329ab92b96559ccebf7b135 upstream.
>
> If the kmem_cache refcount is greater than one, we should not mark the
> root kmem_cache as dying.  If we mark the root kmem_cache dying
> incorrectly, the non-root kmem_cache can never be destroyed.  It
> resulted in memory leak when memcg was destroyed.  We can use the
> following steps to reproduce.
>
>   1) Use kmem_cache_create() to create a new kmem_cache named A.
>   2) Coincidentally, the kmem_cache A is an alias for kmem_cache B,
>      so the refcount of B is just increased.
>   3) Use kmem_cache_destroy() to destroy the kmem_cache A, just
>      decrease the B's refcount but mark the B as dying.
>   4) Create a new memory cgroup and alloc memory from the kmem_cache
>      B. It leads to create a non-root kmem_cache for allocating memory.
>   5) When destroy the memory cgroup created in the step 4), the
>      non-root kmem_cache can never be destroyed.
>
> If we repeat steps 4) and 5), this will cause a lot of memory leak.  So
> only when refcount reach zero, we mark the root kmem_cache as dying.
>
> Fixes: 92ee383f6daa ("mm: fix race between kmem_cache destroy, create and deactivate")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Acked-by: Roman Gushchin <guro@fb.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Shakeel Butt <shakeelb@google.com>
> Cc: <stable@vger.kernel.org>
> Link: http://lkml.kernel.org/r/20200716165103.83462-1-songmuchun@bytedance.com
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  mm/slab_common.c |   35 ++++++++++++++++++++++++++++-------
>  1 file changed, 28 insertions(+), 7 deletions(-)
>
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -310,6 +310,14 @@ int slab_unmergeable(struct kmem_cache *
>         if (s->refcount < 0)
>                 return 1;
>
> +#ifdef CONFIG_MEMCG_KMEM
> +       /*
> +        * Skip the dying kmem_cache.
> +        */
> +       if (s->memcg_params.dying)
> +               return 1;
> +#endif
> +
>         return 0;
>  }
>
> @@ -832,12 +840,15 @@ static int shutdown_memcg_caches(struct
>         return 0;
>  }
>
> -static void flush_memcg_workqueue(struct kmem_cache *s)
> +static void memcg_set_kmem_cache_dying(struct kmem_cache *s)
>  {
>         mutex_lock(&slab_mutex);
>         s->memcg_params.dying = true;
>         mutex_unlock(&slab_mutex);

We should remove mutex_lock/unlock(&slab_mutex) here, because
we already hold the slab_mutex from kmem_cache_destroy().


> +}
>
> +static void flush_memcg_workqueue(struct kmem_cache *s)
> +{
>         /*
>          * SLUB deactivates the kmem_caches through call_rcu_sched. Make
>          * sure all registered rcu callbacks have been invoked.
> @@ -858,10 +869,6 @@ static inline int shutdown_memcg_caches(
>  {
>         return 0;
>  }
> -
> -static inline void flush_memcg_workqueue(struct kmem_cache *s)
> -{
> -}
>  #endif /* CONFIG_MEMCG_KMEM */
>
>  void slab_kmem_cache_release(struct kmem_cache *s)
> @@ -879,8 +886,6 @@ void kmem_cache_destroy(struct kmem_cach
>         if (unlikely(!s))
>                 return;
>
> -       flush_memcg_workqueue(s);
> -
>         get_online_cpus();
>         get_online_mems();
>
> @@ -890,6 +895,22 @@ void kmem_cache_destroy(struct kmem_cach
>         if (s->refcount)
>                 goto out_unlock;
>
> +#ifdef CONFIG_MEMCG_KMEM
> +       memcg_set_kmem_cache_dying(s);
> +
> +       mutex_unlock(&slab_mutex);
> +
> +       put_online_mems();
> +       put_online_cpus();
> +
> +       flush_memcg_workqueue(s);
> +
> +       get_online_cpus();
> +       get_online_mems();
> +
> +       mutex_lock(&slab_mutex);
> +#endif
> +
>         err = shutdown_memcg_caches(s);
>         if (!err)
>                 err = shutdown_cache(s);
>
>


--
Yours,
Muchun
