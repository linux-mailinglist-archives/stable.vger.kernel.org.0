Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C203366B4B4
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 00:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjAOXOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Jan 2023 18:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjAOXOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Jan 2023 18:14:23 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6351E9CB
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 15:14:22 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id o63so27461187vsc.10
        for <stable@vger.kernel.org>; Sun, 15 Jan 2023 15:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=86dZ2QP+sHr0Jg65uUt9BrhUPIsdfEcbXYkErF8fpe8=;
        b=Im/CuRNvt2HbuN0YhQaoN3HBTTH8A9o3TzZnpRoJtWLjbUXAdbWA3NAongNzK79PcQ
         Qxnh3WpYwmU5TtOSHWPz/Oeme1I2UYZgMUIiWfQkgygOkRsnmwzw7X81+CaVEdCTjCt3
         WONAceBrl3RKn2IjP5jU+1x7657QgRrlekQb+0y7IxVMRXCxva1JSK82jze7W4sTKL/h
         UlsoAl14g/RD8sFGVXcpDkcdeWj3irHzPoJrLjwoNanov4ou6A7LGeqsnzCKp8Zm24qv
         6wHprB12URJWT+V9mQD33Z3WB/UUrYf93Ij0FH/KuPf66U1yFrPoLu8qA5YUuhcc+yaC
         7F0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=86dZ2QP+sHr0Jg65uUt9BrhUPIsdfEcbXYkErF8fpe8=;
        b=nJyJIpEwAeUTHk6URjKy4Pjp/oISRpKjYlSNOm6hDYmyrDjwWq+eqRJit1duWDbG6i
         UV0UWA2r4TXiQ7X0a/O9eL/jJwmdaXt96sRSXopPV7ygxpSyc89A2lS8fT/nJDsACJcH
         DlVWrWXqhvaG6MSkZwalSPSVEB4hIczkvdnjy1zw5myNljKi9PHYb+NLNeuHiFUmMuJA
         Xa9ysCajB3SFKE3jyaG7wJZcX0fCqf3sUXuxpmscqmWYxTnV/2+sYb9px/xbSd97rC9W
         3u9KdTgxLZXzCIQv7Lf6fd8p8FiZW0XvOCZm3Bs8Pn4pOHQDZT1lAp1FSL20OJzTmpZJ
         v3+A==
X-Gm-Message-State: AFqh2kosypDUTwQ+nJofGTSc27vrde0zNc+NTjCzr0my7+dJCg6HQzYp
        DYsHM5Bt1XnO61v78bTGvNXalwNoWMipCyUKSjoQzg==
X-Google-Smtp-Source: AMrXdXvr9+3nCniBtFEFOOdagtwnvEr8KGuwOTzqhvMxyHOBldSHehd5Tr5QzMJnq4k+mEDLBKbmu317q91j3p2T6JQ=
X-Received: by 2002:a67:ecd4:0:b0:3ce:8835:de03 with SMTP id
 i20-20020a67ecd4000000b003ce8835de03mr7285245vsp.50.1673824460397; Sun, 15
 Jan 2023 15:14:20 -0800 (PST)
MIME-Version: 1.0
References: <20230115133330.28420-1-msizanoen@qtmlabs.xyz> <20230115134651.30028-1-msizanoen@qtmlabs.xyz>
In-Reply-To: <20230115134651.30028-1-msizanoen@qtmlabs.xyz>
From:   Yu Zhao <yuzhao@google.com>
Date:   Sun, 15 Jan 2023 16:13:44 -0700
Message-ID: <CAOUHufahcS0G_GApTdmzE4_Nb_70LGaCkgV0NR_xJuWN2NdJVg@mail.gmail.com>
Subject: Re: [PATCH v2] mm: do not try to migrate lru_gen if it's not
 associated with a memcg
To:     msizanoen1 <msizanoen@qtmlabs.xyz>
Cc:     Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 15, 2023 at 6:47 AM msizanoen1 <msizanoen@qtmlabs.xyz> wrote:
>
> In some cases, memory cgroup migration can be initiated by userspace
> right after a process was created and right before `lru_gen_add_mm()` is
> called (e.g. by some program watching a cgroup and moving away any
> processes it detects[1]), which results in the following sequence of
> WARNs followed by an Oops as the kernel attempts to perform a
> `lru_gen_add_mm()` twice on the same `mm`:

...

> Fix this by simply leaving the lru_gen alone if it has not been
> associated with a memcg yet, as it should eventually be assigned to the
> right cgroup anyway.
>
> [1]: https://gitlab.freedesktop.org/benzea/uresourced/-/blob/master/cgroupify/cgroupify.c
>
> v2:
>         Added stable cc tags
>
> Signed-off-by: N/A (patch should not be copyrightable)
> Cc: stable@vger.kernel.org

Thanks for the fix.  Cc'ing stable is the right thing to do. The
commit message and the comment styles could be easily adjusted to
align with the guidelines.

I don't think the N/A is acceptible though. I fully respect it if you
wish to remain anonymous -- I can send a similar fix crediting you
as the "anonymous user <msizanoen@qtmlabs.xyz>" who reported this bug.

A bit of background on how I broke it: an old version I have on 4.15
calls lru_gen_add_mm() before cgroup_post_fork(), which excludes
cgroup migrations by cgroup_threadgroup_rwsem. When I rebased it, I
made lru_gen_add_mm() depend on task_lock for the synchronization with
cgroup migrations -- the decoupling seemed (still seems) to make it
less complicated -- but this is not safe unless we have the check below.




> ---
>  mm/vmscan.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd6637fcd8f9..0cac40e7484c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3323,13 +3323,19 @@ void lru_gen_migrate_mm(struct mm_struct *mm)
>         if (mem_cgroup_disabled())
>                 return;
>
> +       /* This could happen if cgroup migration is invoked before the process
> +        * lru_gen is associated with a memcg (e.g. during process creation).
> +        * Simply ignore it in this case as the lru_gen will get assigned the
> +        * right cgroup later. */
> +       if (!mm->lru_gen.memcg)
> +               return;
> +
>         rcu_read_lock();
>         memcg = mem_cgroup_from_task(task);
>         rcu_read_unlock();
>         if (memcg == mm->lru_gen.memcg)
>                 return;
>
> -       VM_WARN_ON_ONCE(!mm->lru_gen.memcg);
>         VM_WARN_ON_ONCE(list_empty(&mm->lru_gen.list));
>
>         lru_gen_del_mm(mm);
