Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20D832C9F8
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbhCDBTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 20:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238674AbhCDBTG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 20:19:06 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6321DC061765
        for <stable@vger.kernel.org>; Wed,  3 Mar 2021 17:17:56 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id n195so26663890ybg.9
        for <stable@vger.kernel.org>; Wed, 03 Mar 2021 17:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cDGMmdlKM20UbxSk1D5HECStpUJywJgGf1k2Ph58Sv4=;
        b=Biwa5C9LBzhQgtedUPAK6nj6XvZwKukqS173MEMYHs8EnBOalCdRzddBpT28z/s4M1
         C8jiWaLWV/QeBcbnLZuTVpheAwE2sHqBop6iq/q/mBXyF34ewhHxWbtn+X0gHy3oR7U9
         upFl7iFJXW9cxs22jmCAvu5tsd8n2xCN4g7YTATbMYcezrCQ5pwIF8GgMsOfhUHej2M9
         NvjUIMacn8ixwWQreNum7fI/cxxMiNbKqyDmZ4BiA2UNW9f61p6vQqOKHOtVPqzoyfo5
         C32W6Q8M4FOHGBaX5TSrasEPYyOGQLtl8k2JNOOYsoBsLWPWoGB9e1hMX/uuTzqrC7pF
         TuAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cDGMmdlKM20UbxSk1D5HECStpUJywJgGf1k2Ph58Sv4=;
        b=oOUl1vKM8Kj137mH1JDMrDxvozfQRla8b06wsfDv75ebTmCBoC0oJxz1B6eJOf+o9K
         htzVpZ9I/RX9smzB8Xvah5gmFMgYvUJHuNzZYerocizrdU/F4dMIyB9t73jycLUqGylW
         /hZdiVEdZ9b9J1pWBcb5WhmgEK6STzmd4mTd4pko6RGJob0u+fFBzcG/moAtyWlmlTEE
         4/z6z4UFbLmLoAC3+HqZpVHqel/JrvhKpmmw+EwyiBeRZBgDYDXIV303/vBGt0bRUd8W
         BKj/mqs4gv3G90dguKLzf9JbYRxYt91OtLpiD1i3WxnPSPFB7jAY+5bhZzU2Gb9EERNL
         bisQ==
X-Gm-Message-State: AOAM532o3mHc+iyb163CICNpuiu5FfLAxL3eD9tfXMhTressdwEC8N73
        VonYFjZljRIgllMvBspk7ajfCuQmcHGu6ZLiGIHo1Q==
X-Google-Smtp-Source: ABdhPJyfPshyKfeDIOoqAVg5Fwk8zLy1gznd2y9ophif2UxaiMhTBt3pbqxOJ6plYf+5MPVAog6sGYQXCN5R/Gnxis0=
X-Received: by 2002:a5b:751:: with SMTP id s17mr3016364ybq.111.1614820675298;
 Wed, 03 Mar 2021 17:17:55 -0800 (PST)
MIME-Version: 1.0
References: <20210303185807.2160264-1-surenb@google.com> <CALvZod73Uem8jzP3QQdQ6waXbx80UUOTJQS7WBwnmaCdq++8xw@mail.gmail.com>
 <CAJuCfpFgDRezmQMjCajXzBp86UbMLMJbqEaeo0_J+pneZ5XOgg@mail.gmail.com> <CALvZod4nZ6W05N-4ostUEz5EbCuEvuBpc4LRYfAFgwQU-wb9dQ@mail.gmail.com>
In-Reply-To: <CALvZod4nZ6W05N-4ostUEz5EbCuEvuBpc4LRYfAFgwQU-wb9dQ@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 3 Mar 2021 17:17:44 -0800
Message-ID: <CAJuCfpFGoG0KaBKqpCzdPP+yXbY=jR24o+TvUkYDiw3uXJJfAw@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] mm/madvise: replace ptrace attach requirement for process_madvise
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
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

On Wed, Mar 3, 2021 at 4:04 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Wed, Mar 3, 2021 at 3:34 PM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > On Wed, Mar 3, 2021 at 3:17 PM Shakeel Butt <shakeelb@google.com> wrote:
> > >
> > > On Wed, Mar 3, 2021 at 10:58 AM Suren Baghdasaryan <surenb@google.com> wrote:
> > > >
> > > > process_madvise currently requires ptrace attach capability.
> > > > PTRACE_MODE_ATTACH gives one process complete control over another
> > > > process. It effectively removes the security boundary between the
> > > > two processes (in one direction). Granting ptrace attach capability
> > > > even to a system process is considered dangerous since it creates an
> > > > attack surface. This severely limits the usage of this API.
> > > > The operations process_madvise can perform do not affect the correctness
> > > > of the operation of the target process; they only affect where the data
> > > > is physically located (and therefore, how fast it can be accessed).
> > > > What we want is the ability for one process to influence another process
> > > > in order to optimize performance across the entire system while leaving
> > > > the security boundary intact.
> > > > Replace PTRACE_MODE_ATTACH with a combination of PTRACE_MODE_READ
> > > > and CAP_SYS_NICE. PTRACE_MODE_READ to prevent leaking ASLR metadata
> > > > and CAP_SYS_NICE for influencing process performance.
> > > >
> > > > Cc: stable@vger.kernel.org # 5.10+
> > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > Reviewed-by: Kees Cook <keescook@chromium.org>
> > > > Acked-by: Minchan Kim <minchan@kernel.org>
> > > > Acked-by: David Rientjes <rientjes@google.com>
> > > > ---
> > > > changes in v3
> > > > - Added Reviewed-by: Kees Cook <keescook@chromium.org>
> > > > - Created man page for process_madvise per Andrew's request: https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/commit/?id=a144f458bad476a3358e3a45023789cb7bb9f993
> > > > - cc'ed stable@vger.kernel.org # 5.10+ per Andrew's request
> > > > - cc'ed linux-security-module@vger.kernel.org per James Morris's request
> > > >
> > > >  mm/madvise.c | 13 ++++++++++++-
> > > >  1 file changed, 12 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/madvise.c b/mm/madvise.c
> > > > index df692d2e35d4..01fef79ac761 100644
> > > > --- a/mm/madvise.c
> > > > +++ b/mm/madvise.c
> > > > @@ -1198,12 +1198,22 @@ SYSCALL_DEFINE5(process_madvise, int, pidfd, const struct iovec __user *, vec,
> > > >                 goto release_task;
> > > >         }
> > > >
> > > > -       mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
> > > > +       /* Require PTRACE_MODE_READ to avoid leaking ASLR metadata. */
> > > > +       mm = mm_access(task, PTRACE_MODE_READ_FSCREDS);
> > > >         if (IS_ERR_OR_NULL(mm)) {
> > > >                 ret = IS_ERR(mm) ? PTR_ERR(mm) : -ESRCH;
> > > >                 goto release_task;
> > > >         }
> > > >
> > > > +       /*
> > > > +        * Require CAP_SYS_NICE for influencing process performance. Note that
> > > > +        * only non-destructive hints are currently supported.
> > >
> > > How is non-destructive defined? Is MADV_DONTNEED non-destructive?
> >
> > Non-destructive in this context means the data is not lost and can be
> > recovered. I follow the logic described in
> > https://lwn.net/Articles/794704/ where Minchan was introducing
> > MADV_COLD and MADV_PAGEOUT as non-destructive versions of MADV_FREE
> > and MADV_DONTNEED. Following that logic, MADV_FREE and MADV_DONTNEED
> > would be considered destructive hints.
> > Note that process_madvise_behavior_valid() allows only MADV_COLD and
> > MADV_PAGEOUT at the moment, which are both non-destructive.
> >
>
> There is a plan to support MADV_DONTNEED for this syscall. Do we need
> to change these access checks again with that support?

I think so. Destructive hints affect the data, so we will probably
need stricter checks for those hints.
