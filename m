Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9C22C5FE8
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 06:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732568AbgK0Fzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 00:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731985AbgK0Fzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 00:55:39 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73152C0613D4
        for <stable@vger.kernel.org>; Thu, 26 Nov 2020 21:55:37 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id b17so4631704ljf.12
        for <stable@vger.kernel.org>; Thu, 26 Nov 2020 21:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6oFsCzS+OxTEO2y3Pf5Q7PmtJxX7xVpPrBEyrbf7RUo=;
        b=SeVtWh9H9c51M6CDCFlZJfnPlhGziPCG9JvMTC2u3NXldoIzRbJ7+NXgwsQSRZ4Smu
         +Q2EUmGpcIH2/A+gHZwyiG7y5fpEPLJ8sWj81q+cZ+LwOob4NSFrb2PaG4ULqauKosUd
         30CfIMhh+ZyqxZ5W6Msuia4UMQb7yK40v+JvpldgV/BpeaXZakffIebbmmyOu4IxY+ST
         UzGl3/kSCs5nfbcB3jF32cA6WBMzUV/JZ8Y37TxG1H471eQjYd7yaryFONoIThN57fDs
         0xH/TI0hfA1LZdpGubA9fP/zO8GE7xub2ccl4jENEp93TF5d+HfvhPFuM9S7wG23ffDZ
         cnnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6oFsCzS+OxTEO2y3Pf5Q7PmtJxX7xVpPrBEyrbf7RUo=;
        b=LEaW/3P+alccs2qtzJSPKI2ZG6YvFtD7GL3Z4LlzCDvGcCffMRRXz9Q0JwOTMpmgVH
         +4AJoSee6jHWjhUnLlI2umX4W3aHpHKqrAt+cT/ouSYZkuN4ali7e5Nc0Tj9C7Z4OTzX
         PclRR+XbfGiYB5iAWbnDMT3NuQyemdpsW7fg8ZZaPV9Kf+JkJxlJBmuKfDdTiS+eZ7j4
         KY4/3t98gjeX8tTS2vZINSZ/sMbb4RFYWqAEYM9IwMq3r5/3IOugI7+J9cXZBTgct/Wy
         4rf9vf+2d+gJW59FmFtkIXHOXI23NpQN3YkAKuGatO2TYMdJoEo8TBajMcYkfdZWBNIO
         fIVg==
X-Gm-Message-State: AOAM530ajZK+H2V5f6YSFjvgJ1xxpErlFgvyXaRxwrrEk0k18k9C++w1
        JnEK2NoFyB+OKBALbRs+rvAJP3Qle1tEeqifYlhKpA==
X-Google-Smtp-Source: ABdhPJyxRfXP3BMa7Pk4T8QpQ45MjIVv4rjENB+pf2lXEvpeBsnxtGV9V0rYFygqajTnjR5NqUWVDJLxL2uraLBj+0E=
X-Received: by 2002:a2e:9746:: with SMTP id f6mr2420428ljj.270.1606456535533;
 Thu, 26 Nov 2020 21:55:35 -0800 (PST)
MIME-Version: 1.0
References: <20201127041405.3459198-1-guro@fb.com>
In-Reply-To: <20201127041405.3459198-1-guro@fb.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 26 Nov 2020 21:55:24 -0800
Message-ID: <CALvZod56VUdDQmvoHrYFz2mfW_j2C9M+06wcWoz4oCOFmNA4eA@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg/slab: fix obj_cgroup_charge() return value handling
To:     Roman Gushchin <guro@fb.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 8:14 PM Roman Gushchin <guro@fb.com> wrote:
>
> Commit 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches
> for all allocations") introduced a regression into the handling of the
> obj_cgroup_charge() return value. If a non-zero value is returned
> (indicating of exceeding one of memory.max limits), the allocation
> should fail, instead of falling back to non-accounted mode.
>
> To make the code more readable, move memcg_slab_pre_alloc_hook()
> and memcg_slab_post_alloc_hook() calling conditions into bodies
> of these hooks.
>
> Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: stable@vger.kernel.org
> ---
>  mm/slab.h | 40 ++++++++++++++++++++++++----------------
>  1 file changed, 24 insertions(+), 16 deletions(-)
>
> diff --git a/mm/slab.h b/mm/slab.h
> index 59aeb0d9f11b..5dc89d8fb05e 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -257,22 +257,32 @@ static inline size_t obj_full_size(struct kmem_cache *s)
>         return s->size + sizeof(struct obj_cgroup *);
>  }
>
> -static inline struct obj_cgroup *memcg_slab_pre_alloc_hook(struct kmem_cache *s,
> -                                                          size_t objects,
> -                                                          gfp_t flags)
> +/*
> + * Returns true if the allocation should fail.

IMO returning false if the allocation should fail makes this more
clear. Otherwise the patch looks good to me.

> + */
> +static inline bool memcg_slab_pre_alloc_hook(struct kmem_cache *s,
> +                                            struct obj_cgroup **objcgp,
> +                                            size_t objects, gfp_t flags)
>  {
>         struct obj_cgroup *objcg;
>
> +       if (!memcg_kmem_enabled())
> +               return false;
> +
> +       if (!(flags & __GFP_ACCOUNT) && !(s->flags & SLAB_ACCOUNT))
> +               return false;
> +
>         objcg = get_obj_cgroup_from_current();
>         if (!objcg)
> -               return NULL;
> +               return false;
>
>         if (obj_cgroup_charge(objcg, flags, objects * obj_full_size(s))) {
>                 obj_cgroup_put(objcg);
> -               return NULL;
> +               return true;
>         }
>
> -       return objcg;
> +       *objcgp = objcg;
> +       return false;
>  }
