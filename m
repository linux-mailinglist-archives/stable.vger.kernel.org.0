Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E5D32F1A0
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 18:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhCERpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 12:45:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbhCERpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 12:45:21 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336CBC061760
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 09:45:21 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id e2so3805284ljo.7
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 09:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fjmoW72/ku1lnLXMuAm6ZbrP9WWp23FQh9M1c5WKSl8=;
        b=A9upIdY3NrsolQX2lFBy06Za+fmkomHdOwQcUyiHv6xHc7YqCQkQn8C6s0QHzCTaev
         SPR5qphZ57qK3qBIyHtSjH7FuFLszlLhqzw1qfcJhyzvX40a4/NJhPfKIvpxqznGT893
         DRtYpo3aDFSUVvdgLQxmy+u29XYt2x56ELWBlMwArbOh3mRWENcJlAdQXEzeRInYX4Dj
         8eSHEoYHoj08rC2K0VG4xfUTeh8kxNYHZZVMA08IIc5dA/y4QPSpteJOU1GAgKZG4bCt
         ryJoO/evucYsYRC1Tic8ime0iJWw/SzNmpqAA9Zadn9IUvBgXQcNW2l5TBAXTeQPZyL7
         FDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fjmoW72/ku1lnLXMuAm6ZbrP9WWp23FQh9M1c5WKSl8=;
        b=sOhnATDPBEKS9TZS/IwRGpvL5dPqazwBKjI6NLr+aMrB89VuVPPBmPONkthCLB993f
         0diFNXvJovgOSamj9/NUFESNlE4EMfVrgI5dE5pgBVJvqOXo7sy1muGQAVmKcUMGgDix
         S6u8XFtakAI23dOgqcknmEbQRyIa0WSJNDmzxHKXJC65dWPYoNQf8Fd3sfGG2zmsbqmy
         CwQtqR7duy8sWZ6GCXckJq0eYdANFT1oy4Ihtf1VG3AgbRbJOYuSyWBtVJN61dTPF/J3
         1pgUf8aANJdB4fICnqbn5g78Pa4242pX6I5b71xqes86vtVDT3t0sfH7jCSKt5rXQoD+
         gw9Q==
X-Gm-Message-State: AOAM531EZt+JIfzM8zsFk0BrV2BAHIOCfwyt3hXV+56dzgQds/qbHxR8
        MjHg/DSRvDODaYi+sRdrVSXevxqAT9AMbtDKbYPDHg==
X-Google-Smtp-Source: ABdhPJyK/dVc1k+/qBKUx8d5GEaTi/dVKzYSI4dp4RHRGb8oEpa+bUgfpktgJn4unjvrnTrj45o6DabtPYORirmP6Rw=
X-Received: by 2002:a2e:9195:: with SMTP id f21mr5616413ljg.160.1614966319338;
 Fri, 05 Mar 2021 09:45:19 -0800 (PST)
MIME-Version: 1.0
References: <20210303185807.2160264-1-surenb@google.com> <CALvZod73Uem8jzP3QQdQ6waXbx80UUOTJQS7WBwnmaCdq++8xw@mail.gmail.com>
 <CAJuCfpFgDRezmQMjCajXzBp86UbMLMJbqEaeo0_J+pneZ5XOgg@mail.gmail.com>
 <CALvZod4nZ6W05N-4ostUEz5EbCuEvuBpc4LRYfAFgwQU-wb9dQ@mail.gmail.com> <b45d9599-b917-10c3-6b86-6ecd8db16d43@redhat.com>
In-Reply-To: <b45d9599-b917-10c3-6b86-6ecd8db16d43@redhat.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Fri, 5 Mar 2021 09:45:07 -0800
Message-ID: <CALvZod6b8H-=N6WVrgMVLE3=pm-ELWerjAO5v5KHSH-ih337+g@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] mm/madvise: replace ptrace attach requirement for process_madvise
To:     David Hildenbrand <david@redhat.com>
Cc:     Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>,
        Kees Cook <keescook@chromium.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        Minchan Kim <minchan@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?Q?Edgar_Arriaga_Garc=C3=ADa?= <edgararriaga@google.com>,
        Tim Murray <timmurray@google.com>,
        Florian Weimer <fweimer@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        James Morris <jmorris@namei.org>,
        Linux MM <linux-mm@kvack.org>,
        SElinux list <selinux@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 5, 2021 at 9:37 AM David Hildenbrand <david@redhat.com> wrote:
>
> On 04.03.21 01:03, Shakeel Butt wrote:
> > On Wed, Mar 3, 2021 at 3:34 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >>
> >> On Wed, Mar 3, 2021 at 3:17 PM Shakeel Butt <shakeelb@google.com> wrote:
> >>>
> >>> On Wed, Mar 3, 2021 at 10:58 AM Suren Baghdasaryan <surenb@google.com> wrote:
> >>>>
> >>>> process_madvise currently requires ptrace attach capability.
> >>>> PTRACE_MODE_ATTACH gives one process complete control over another
> >>>> process. It effectively removes the security boundary between the
> >>>> two processes (in one direction). Granting ptrace attach capability
> >>>> even to a system process is considered dangerous since it creates an
> >>>> attack surface. This severely limits the usage of this API.
> >>>> The operations process_madvise can perform do not affect the correctness
> >>>> of the operation of the target process; they only affect where the data
> >>>> is physically located (and therefore, how fast it can be accessed).
> >>>> What we want is the ability for one process to influence another process
> >>>> in order to optimize performance across the entire system while leaving
> >>>> the security boundary intact.
> >>>> Replace PTRACE_MODE_ATTACH with a combination of PTRACE_MODE_READ
> >>>> and CAP_SYS_NICE. PTRACE_MODE_READ to prevent leaking ASLR metadata
> >>>> and CAP_SYS_NICE for influencing process performance.
> >>>>
> >>>> Cc: stable@vger.kernel.org # 5.10+
> >>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >>>> Reviewed-by: Kees Cook <keescook@chromium.org>
> >>>> Acked-by: Minchan Kim <minchan@kernel.org>
> >>>> Acked-by: David Rientjes <rientjes@google.com>
> >>>> ---
> >>>> changes in v3
> >>>> - Added Reviewed-by: Kees Cook <keescook@chromium.org>
> >>>> - Created man page for process_madvise per Andrew's request: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=a144f458bad476a3358e3a45023789cb7bb9f993
> >>>> - cc'ed stable@vger.kernel.org # 5.10+ per Andrew's request
> >>>> - cc'ed linux-security-module@vger.kernel.org per James Morris's request
> >>>>
> >>>>   mm/madvise.c | 13 ++++++++++++-
> >>>>   1 file changed, 12 insertions(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/mm/madvise.c b/mm/madvise.c
> >>>> index df692d2e35d4..01fef79ac761 100644
> >>>> --- a/mm/madvise.c
> >>>> +++ b/mm/madvise.c
> >>>> @@ -1198,12 +1198,22 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
> >>>>                  goto release_task;
> >>>>          }
> >>>>
> >>>> -       mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
> >>>> +       /* Require PTRACE_MODE_READ to avoid leaking ASLR metadata. */
> >>>> +       mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
> >>>>          if (IS_ERR_OR_NULL(mm)) {
> >>>>                  ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
> >>>>                  goto release_task;
> >>>>          }
> >>>>
> >>>> +       /*
> >>>> +        * Require CAP_SYS_NICE for influencing process performance. Note that
> >>>> +        * only non-destructive hints are currently supported.
> >>>
> >>> How is non-destructive defined? Is MADV_DONTNEED non-destructive?
> >>
> >> Non-destructive in this context means the data is not lost and can be
> >> recovered. I follow the logic described in
> >> https://lwn.net/Articles/794704/ where Minchan was introducing
> >> MADV_COLD and MADV_PAGEOUT as non-destructive versions of MADV_FREE
> >> and MADV_DONTNEED. Following that logic, MADV_FREE and MADV_DONTNEED
> >> would be considered destructive hints.
> >> Note that process_madvise_behavior_valid() allows only MADV_COLD and
> >> MADV_PAGEOUT at the moment, which are both non-destructive.
> >>
> >
> > There is a plan to support MADV_DONTNEED for this syscall. Do we need
> > to change these access checks again with that support?
>
> Eh, I absolutely don't think letting another process discard memory in
> another process' address space is a good idea. The target process can
> observe that easily and might even run into real issues.
>
> What's the use case?
>

Userspace oom reaper. Please look at
https://lore.kernel.org/linux-api/20201014183943.GA1489464@google.com/T/
