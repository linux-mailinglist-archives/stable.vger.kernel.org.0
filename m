Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8F92D0DF2
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 13:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730384AbfJILsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 07:48:41 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42982 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbfJILsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 07:48:40 -0400
Received: by mail-ot1-f67.google.com with SMTP id c10so1427336otd.9
        for <stable@vger.kernel.org>; Wed, 09 Oct 2019 04:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RdvAMuUQxe0Qi+V1vQERcuk1lbOQES8EHOAEiADwjx4=;
        b=vsXIJOY2nMi/MfBY1pJtQhlwrpew68PURn3w5LdtO1wXmFIG/536TJk5IfLDQSjxHl
         aCcIAFc6mxLObXfo8dSV0kDEFdQUu30qi9WbACCGXISBuqwYLSqhtf7e+TQID+sijrdB
         JJZJK70VrxacHEkuS8d5zZ4z5j4ipDVyZHOrFgqHdvluWbnOLKdUvQo8CdYnRbZSa7+T
         7JJxJRHmbQR60rpJ5MDn3GRrdYSOA96ZkZ7O2bF/HOZ0J+0q0kjKYmxWHpkKJerJucD/
         rmLy4QY8IduKFni2m5wVCcQtLiX4IL7Y2PX8r9BIUqU8Iq30N90IVokYEg6g3sutEyVG
         i7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RdvAMuUQxe0Qi+V1vQERcuk1lbOQES8EHOAEiADwjx4=;
        b=oc6XqxXr1DUZon9pSWRvVnicIctjVlrTLTOc0EWlksiR5DM0SdV0bwf2J5S0uFVpMq
         EfRLQ+yhZAqoE23AQy4XbaUSOymvCV7pjNKlKZVEEFQHoBPrdN8jveBQUrLnHE/4N37q
         MdJyE5OCc+cFvKd7aW6USMuO/S1Y5IXfhgCA3+o+83181EoRX6Rqxh7JNupHZU7yp7Hk
         /r2R6C0TV3gsPtilKQm5m66fdt4MM+pHVA0FHBCvf5LeXTjVzx1LAsPvS4jOR34PhxbM
         0UAl3SGMQ8zWeZxmz3HSQSLxm5MSkl0qnBj4h/FRzMaMW7uOs9kdnLfMwv5STVO4NZl7
         iaYg==
X-Gm-Message-State: APjAAAVeadybnInofJ26BbaGqCaU6P7tJLxu4eLPa/lCnMeJVdUl8EH0
        Hk4H5SyyCm139kFHGeLuGdrukgQIM3qBKv8kCmTqKQ==
X-Google-Smtp-Source: APXvYqyXTwYgrj0c7UYR5UOFwxokPf4vTsxbTx3fy2BDq5QidLoMSOhiLMdFoee85BdD5EQHBPP1Vxuuj+PwahJ4k7s=
X-Received: by 2002:a9d:724e:: with SMTP id a14mr2516551otk.23.1570621719468;
 Wed, 09 Oct 2019 04:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191008154418.GA16972@andrea> <20191009113134.5171-1-christian.brauner@ubuntu.com>
In-Reply-To: <20191009113134.5171-1-christian.brauner@ubuntu.com>
From:   Marco Elver <elver@google.com>
Date:   Wed, 9 Oct 2019 13:48:27 +0200
Message-ID: <CANpmjNMgVub_pSGVfjBOtXg1ufdBvpXC_XUTnvNyQeF17JSCSw@mail.gmail.com>
Subject: Re: [PATCH] taskstats: fix data-race
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Andrea Parri <parri.andrea@gmail.com>, bsingharora@gmail.com,
        Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 9 Oct 2019 at 13:31, Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> When assiging and testing taskstats in taskstats_exit() there's a race
> when writing and reading sig->stats when a thread-group with more than
> one thread exits:
>
> cpu0:
> thread catches fatal signal and whole thread-group gets taken down
>  do_exit()
>  do_group_exit()
>  taskstats_exit()
>  taskstats_tgid_alloc()
> The tasks reads sig->stats without holding sighand lock seeing garbage.
>
> cpu1:
> task calls exit_group()
>  do_exit()
>  do_group_exit()
>  taskstats_exit()
>  taskstats_tgid_alloc()
> The task takes sighand lock and assigns new stats to sig->stats.
>
> Fix this by using smp_load_acquire() and smp_store_release().
>
> Reported-by: syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com
> Fixes: 34ec12349c8a ("taskstats: cleanup ->signal->stats allocation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
> ---
> /* v1 */
> Link: https://lore.kernel.org/r/20191005112806.13960-1-christian.brauner@ubuntu.com
>
> /* v2 */
> Link: https://lore.kernel.org/r/20191006235216.7483-1-christian.brauner@ubuntu.com
> - Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>:
>   - fix the original double-checked locking using memory barriers
>
> /* v3 */
> Link: https://lore.kernel.org/r/20191007110117.1096-1-christian.brauner@ubuntu.com/
> - Andrea Parri <parri.andrea@gmail.com>:
>   - document memory barriers to make checkpatch happy
>
> /* v4 */
> - Andrea Parri <parri.andrea@gmail.com>:
>   - use smp_load_acquire(), not READ_ONCE()
>   - update commit message

Acked-by: Marco Elver <elver@google.com>

Note that this now looks almost like what I suggested, except the
return at the end of the function is accessing sig->stats again. In
this case, it seems it's fine assuming sig->stats cannot be written
elsewhere. Just wanted to point it out to make sure it's considered.

Thanks!

> ---
>  kernel/taskstats.c | 24 +++++++++++++++---------
>  1 file changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> index 13a0f2e6ebc2..e6b45315607a 100644
> --- a/kernel/taskstats.c
> +++ b/kernel/taskstats.c
> @@ -554,24 +554,30 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
>  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
>  {
>         struct signal_struct *sig = tsk->signal;
> -       struct taskstats *stats;
> +       struct taskstats *stats_new, *stats;
>
> -       if (sig->stats || thread_group_empty(tsk))
> -               goto ret;
> +       /* Pairs with smp_store_release() below. */
> +       stats = smp_load_acquire(sig->stats);
> +       if (stats || thread_group_empty(tsk))
> +               return stats;
>
>         /* No problem if kmem_cache_zalloc() fails */
> -       stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> +       stats_new = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
>
>         spin_lock_irq(&tsk->sighand->siglock);
>         if (!sig->stats) {
> -               sig->stats = stats;
> -               stats = NULL;
> +               /*
> +                * Pairs with smp_store_release() above and order the
> +                * kmem_cache_zalloc().
> +                */
> +               smp_store_release(&sig->stats, stats_new);
> +               stats_new = NULL;
>         }
>         spin_unlock_irq(&tsk->sighand->siglock);
>
> -       if (stats)
> -               kmem_cache_free(taskstats_cache, stats);
> -ret:
> +       if (stats_new)
> +               kmem_cache_free(taskstats_cache, stats_new);
> +
>         return sig->stats;
>  }
>
> --
> 2.23.0
>
