Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAFDE32C849
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381278AbhCDAfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233119AbhCDAAt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 19:00:49 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F85C061765
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 15:17:46 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id z11so39904067lfb.9
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 15:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bJioWY2SyxYVyQ6HbJCASiO240osNAH7hbvsbBMN9q8=;
        b=FoRQIWOrOSWpnQbeeOXEI0flZTsv0PV0p6wcI8b93AXHcM1gZ9aSnR1JoGSQ7lgbr2
         kqVLxVWd6pXmGnnj6l3QenA5IzsbN0UptJpSd2tLC9BrhNhfIQJZg9nB5Uj2nGB1bY8D
         eDxdv3YfhpMCGKxTMQbxtC6iSYy0t+VepEzieFcHY/2yYJ2YLCgecFfgiDt0F9Hm0jk9
         O7MVXDHKDSSsq0dj8J/OQcQNe0x8KFa6yLZ2DYMjQDjsp728TzXjhJkTby2uUZRcUhTv
         EFhOCncRRxDkD4iVeoGMRenftxA9y/iA12zP7+x7Bgg9/08hogDFwBNfHnJQEFzROPTL
         41KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bJioWY2SyxYVyQ6HbJCASiO240osNAH7hbvsbBMN9q8=;
        b=YVlJRuzwsliMsoF3NjwFcJnVZ5N48ua7ADtRaWs6Xvcwac+vfpICf6EyC3D0KCHu7j
         DLbnE9EsPzEGXC2JJmfacjisRAIvdpfchsrOCY80OSYr888by9HYtQfR85NYLpzura1S
         Y9zRtYQkd2usP2PRPH0nN6d2jfozfyfFuUq4L0dZdnu3+NbIx4xE2Yhgvl2xd6Cy7Mfp
         hkuo2a+o5buH8YlqN8glMY5w9qt1HDNRQAuPJQCvLineCog9p/tivqjK4Qz3G1ylIJ4W
         oMtE+gHEAZj6k3tZCQBVsaj1j0VJ5t8cZFZ8aPPMaQtQk58D0//+6vO5QXBJGUWSgtck
         B5MA==
X-Gm-Message-State: AOAM5300XAyf0/+3FV20jD7d5JLrddA0TR89TFmu3e3NXSSk5uIfAIrX
        kjsb5jBO+2ssFihWH4wwMIrnfZ//l0+vG5Er9xNbSQ==
X-Google-Smtp-Source: ABdhPJwSap1Hmdo4W6UsN9k0+5d5TjS6UvplVqmtOBVMz5oOgVSyMr6q/AHiggxT/mVjyVJIN+BjMLUH/Vf8V/n18TQ=
X-Received: by 2002:a05:6512:10c8:: with SMTP id k8mr587955lfg.299.1614813464307;
 Wed, 03 Mar 2021 15:17:44 -0800 (PST)
MIME-Version: 1.0
References: <20210303185807.2160264-1-surenb@google.com>
In-Reply-To: <20210303185807.2160264-1-surenb@google.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Wed, 3 Mar 2021 15:17:30 -0800
Message-ID: <CALvZod73Uem8jzP3QQdQ6waXbx80UUOTJQS7WBwnmaCdq++8xw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] mm/madvise: replace ptrace attach requirement for process_madvise
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>, jeffv@google.com,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>, edgararriaga@google.com,
        Tim Murray <timmurray@google.com>, fweimer@redhat.com,
        oleg@redhat.com, jmorris@namei.org, Linux MM <linux-mm@kvack.org>,
        selinux@vger.kernel.org, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org, stable@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 3, 2021 at 10:58 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> process_madvise currently requires ptrace attach capability.
> PTRACE_MODE_ATTACH gives one process complete control over another
> process. It effectively removes the security boundary between the
> two processes (in one direction). Granting ptrace attach capability
> even to a system process is considered dangerous since it creates an
> attack surface. This severely limits the usage of this API.
> The operations process_madvise can perform do not affect the correctness
> of the operation of the target process; they only affect where the data
> is physically located (and therefore, how fast it can be accessed).
> What we want is the ability for one process to influence another process
> in order to optimize performance across the entire system while leaving
> the security boundary intact.
> Replace PTRACE_MODE_ATTACH with a combination of PTRACE_MODE_READ
> and CAP_SYS_NICE. PTRACE_MODE_READ to prevent leaking ASLR metadata
> and CAP_SYS_NICE for influencing process performance.
>
> Cc: stable@vger.kernel.org # 5.10+
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Acked-by: David Rientjes <rientjes@google.com>
> ---
> changes in v3
> - Added Reviewed-by: Kees Cook <keescook@chromium.org>
> - Created man page for process_madvise per Andrew's request: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=a144f458bad476a3358e3a45023789cb7bb9f993
> - cc'ed stable@vger.kernel.org # 5.10+ per Andrew's request
> - cc'ed linux-security-module@vger.kernel.org per James Morris's request
>
>  mm/madvise.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index df692d2e35d4..01fef79ac761 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1198,12 +1198,22 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
>                 goto release_task;
>         }
>
> -       mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
> +       /* Require PTRACE_MODE_READ to avoid leaking ASLR metadata. */
> +       mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
>         if (IS_ERR_OR_NULL(mm)) {
>                 ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
>                 goto release_task;
>         }
>
> +       /*
> +        * Require CAP_SYS_NICE for influencing process performance. Note that
> +        * only non-destructive hints are currently supported.

How is non-destructive defined? Is MADV_DONTNEED non-destructive?

> +        */
> +       if (!capable(CAP_SYS_NICE)) {
> +               ret = -EPERM;
> +               goto release_mm;
> +       }
> +
>         total_len = iov_iter_count(&iter);
>
>         while (iov_iter_count(&iter)) {
> @@ -1218,6 +1228,7 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
>         if (ret == 0)
>                 ret = total_len - iov_iter_count(&iter);
>
> +release_mm:
>         mmput(mm);
>  release_task:
>         put_task_struct(task);
> --
> 2.30.1.766.gb4fecdf3b7-goog
>
