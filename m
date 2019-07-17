Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFADF6C0BE
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 20:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfGQSCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 14:02:37 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:46695 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbfGQSCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jul 2019 14:02:37 -0400
Received: by mail-yw1-f66.google.com with SMTP id z197so11052037ywd.13
        for <stable@vger.kernel.org>; Wed, 17 Jul 2019 11:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yDzRsEyxIuuSai2DRMs+IGwIO+YipV0U+XFpyiaB7ek=;
        b=KV6HAxQGdn6bho66u6GdESZdwwdD5tjW0fDv1ZWRFWmhV9jQO5H7q5tBN4YlahuMN8
         xHlxAttU7druDTETF9Oi1KMdYnaRSqBOoIn64k5cuiuYGQ4v+oGTISwXQraV6l5MxKnI
         /pXA0Z9KuUVxOjF1INofKw1JWFWI5GKL38xdnoah2mPGzZqrDlZuiPgsshkxn9SkE9RD
         4/C90o3L6ZPqIEBmWavIP7H2Mp3oautWncUe1weerJg8VfUv4DDUnoCeZp8rfQMjLfkU
         gDyKAi9AdYmM2rxLhZ3O2qlqNqvnSp+ODNOPhS3edwqcT+5bAxOtHefqfQAih6cPsWOx
         zMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yDzRsEyxIuuSai2DRMs+IGwIO+YipV0U+XFpyiaB7ek=;
        b=OJW6OOqkknv3baqDuUBgwh+TIbaBTD5W+YG+Lub644ehgzRI8F6fVlggZ7heUEUzos
         6qh2YbPRInh7WFP3W0TiWPoNbIm6p1lJxCmC//Y/YRCNQDkMSKRQUe0ZUcxIJIRk97Vg
         wnoWHqgJL6MgKGTv+VVuIrGLjHGiJgliEZ1qOn/3XTJlX3SwjIi/rTmZMm3aX9VPo+LW
         tkFbHL68AanFOzs6YXU38TQ5JtfbVEhO+q4cC6F5mECbskg4q0eBQ9B7T6ija/EK8gXq
         CfMf/z3UfEZrryZUlHTzQ11qKYnsf/eTcC8kPLvRDxFt8W/+/lKf6jP08f/j4Iq49CnG
         DRrA==
X-Gm-Message-State: APjAAAU86sFK3VtXerT3f6I2Mi1wxOoc/+a1cMa58Z1j/ujOSz6YPs3F
        BRxSGQrDnGfpY3bR9VkKkVfrGsqdvp7sQzvHE3cJDA==
X-Google-Smtp-Source: APXvYqx8Dv3M/w0Y+tfgf5v5o8BgqNuNH2nvV6nFlb9tCRft8Hoq2fYaYtrbULzBbF+h70b2g7Pn/ZHWVRQWxxJXD1U=
X-Received: by 2002:a0d:c345:: with SMTP id f66mr23890145ywd.10.1563386555880;
 Wed, 17 Jul 2019 11:02:35 -0700 (PDT)
MIME-Version: 1.0
References: <1563385526-20805-1-git-send-email-yang.shi@linux.alibaba.com>
In-Reply-To: <1563385526-20805-1-git-send-email-yang.shi@linux.alibaba.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 17 Jul 2019 11:02:24 -0700
Message-ID: <CALvZod7CJ6W5RGRVzyc8J=dWgOHeHGFT+43NWGQjATvEqRjkMg@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: check if mem cgroup is disabled or not before
 calling memcg slab shrinker
To:     Yang Shi <yang.shi@linux.alibaba.com>
Cc:     Vladimir Davydov <vdavydov.dev@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Roman Gushchin <guro@fb.com>, Hugh Dickins <hughd@google.com>,
        Qian Cai <cai@lca.pw>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 17, 2019 at 10:45 AM Yang Shi <yang.shi@linux.alibaba.com> wrote:
>
> Shakeel Butt reported premature oom on kernel with
> "cgroup_disable=memory" since mem_cgroup_is_root() returns false even
> though memcg is actually NULL.  The drop_caches is also broken.
>
> It is because commit aeed1d325d42 ("mm/vmscan.c: generalize shrink_slab()
> calls in shrink_node()") removed the !memcg check before
> !mem_cgroup_is_root().  And, surprisingly root memcg is allocated even
> though memory cgroup is disabled by kernel boot parameter.
>
> Add mem_cgroup_disabled() check to make reclaimer work as expected.
>
> Fixes: aeed1d325d42 ("mm/vmscan.c: generalize shrink_slab() calls in shrink_node()")
> Reported-by: Shakeel Butt <shakeelb@google.com>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Qian Cai <cai@lca.pw>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: stable@vger.kernel.org  4.19+
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>

> ---
>  mm/vmscan.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f8e3dcd..c10dc02 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -684,7 +684,14 @@ static unsigned long shrink_slab(gfp_t gfp_mask, int nid,
>         unsigned long ret, freed = 0;
>         struct shrinker *shrinker;
>
> -       if (!mem_cgroup_is_root(memcg))
> +       /*
> +        * The root memcg might be allocated even though memcg is disabled
> +        * via "cgroup_disable=memory" boot parameter.  This could make
> +        * mem_cgroup_is_root() return false, then just run memcg slab
> +        * shrink, but skip global shrink.  This may result in premature
> +        * oom.
> +        */
> +       if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
>                 return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
>
>         if (!down_read_trylock(&shrinker_rwsem))
> --
> 1.8.3.1
>
