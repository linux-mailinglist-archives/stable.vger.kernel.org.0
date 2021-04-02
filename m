Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61196352445
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 02:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbhDBANL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 20:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbhDBANL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 20:13:11 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF39AC061788
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 17:13:09 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id w8so3567285ybt.3
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 17:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hHqIw7rwlLy52EhAj8Y5YIj9xb4HwP2k6pw7NNvVpTY=;
        b=wMlWmeMUbG3ksG53fNAV62RO3KYm+XW2Jy/PkcB62I7y8EFBc0W0xa7PuwrmA7WG33
         +s+m391aUoVeVt6tu9yTmJI97zVLUqWFSGGS5c/6QILy1GhNOXry1+MtRs0wRv4U3Xih
         nwGyOtioUq9gJN5kIIDc4xQUoSGgbFKvFkqzMl22ftqWXG7DwoZ6mZdJFOFgE8d9bxsz
         CpwV+yLabVHc3s1+i50LwNAzkf5ZwJlzdWmTgIZsSSA+dP24FlqsZX+cG5xV2BuLbOF4
         HHlP0z85+Nt7Y8sds/kSRHqOUjIG+TZDhFvWEJ7VMIaC13h7U967EnWHHdfN66rGFZp2
         dvsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hHqIw7rwlLy52EhAj8Y5YIj9xb4HwP2k6pw7NNvVpTY=;
        b=l/VPizOQuj63dTIHoOEycn5cHAtua5x/Wkk91VH/78/JMwTn23rVTn16QjDaDUfslz
         vne+NdS+TWp48hZXkvxeShURkPY7d70Sk5NJqPKfQtRmbrVjJpLldkMReGwlpIOY66fe
         5atM/yIgqvTtF1xBpkdZ4ZvWncIXCie/dw4FINkaJ+vklJ0AdoKDEo1ZZGng5wxJiZ86
         51rI1GFc00heNcVzLwjtNlU/JcMSTD29TUmE5vsZawGskcfs/jS7nDJGpEgGXN1TpES0
         OlTggOsH3wr7lIl3ez6O+jEwygaTo04SxNWPgcxxbp2XsZRlggkm9C7c7vplett3l/EZ
         0Gvw==
X-Gm-Message-State: AOAM531tU3mvBFBflvfT3LFoYgZvK+2hFpzlP5DhDdXqAuJ9wSLjp69r
        PDTerY6woJJfaD/r/REEkQDeM2FS5Jukaz9Pj3snIA==
X-Google-Smtp-Source: ABdhPJxu0dT8nkXGyRm50Qls2b5F+9qxb4gCieCPj/ZRjbq6oQW2/8J4QHLhVlucS8uhbWZowdxRrfGeWDlRj0SVf28=
X-Received: by 2002:a25:38c1:: with SMTP id f184mr16120789yba.84.1617322388880;
 Thu, 01 Apr 2021 17:13:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com> <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
 <CAJuCfpE48zkcM_2GABBpXssjmivKLt+r8+CEeXafqK3VNMMjDw@mail.gmail.com> <20210401234720.GB628002@xz-x1>
In-Reply-To: <20210401234720.GB628002@xz-x1>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 1 Apr 2021 17:12:57 -0700
Message-ID: <CAJuCfpGYB10pActvGdtgrgEjNxuFOL4R9KYxMjFQoRK-k_+A1A@mail.gmail.com>
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
To:     Peter Xu <peterx@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>, Shaohua Li <shli@fb.com>,
        Nadav Amit <namit@vmware.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 1, 2021 at 4:47 PM Peter Xu <peterx@redhat.com> wrote:
>
> Hi, Suren,
>
> On Thu, Apr 01, 2021 at 12:43:51PM -0700, Suren Baghdasaryan wrote:
> > On Thu, Apr 1, 2021 at 11:59 AM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > On Thu, Apr 1, 2021 at 11:17 AM Suren Baghdasaryan <surenb@google.com> wrote:
> > > >
> > > > We received a report that the copy-on-write issue repored by Jann Horn in
> > > > https://bugs.chromium.org/p/project-zero/issues/detail?id=2045 is still
> > > > reproducible on 4.14 and 4.19 kernels (the first issue with the reproducer
> > > > coded in vmsplice.c).
> > >
> > > Gaah.
> > >
> > > > I confirmed this and also that the issue was not
> > > > reproducible with 5.10 kernel. I tracked the fix to the following patch
> > > > introduced in 5.9 which changes the do_wp_page() logic:
> > > >
> > > > 09854ba94c6a 'mm: do_wp_page() simplification'
> > >
> > > The problem here is that there's a _lot_ more patches than the few you
> > > found that fixed various other cases (THP etc).
> > >
> > > > I backported this patch (#2 in the series) along with 2 prerequisite patches
> > > > (#1 and #4) that keep the backports clean and two followup fixes to the main
> > > > patch (#3 and #5). I had to skip the following fix:
> > > >
> > > > feb889fb40fa 'mm: don't put pinned pages into the swap cache'
> > > >
> > > > because it uses page_maybe_dma_pinned() which does not exists in earlier
> > > > kernels. Because pin_user_pages() does not exist there as well, I *think*
> > > > we can safely skip this fix on older kernels, but I would appreciate if
> > > > someone could confirm that claim.
> > >
> > > Hmm. I think this means that swap activity can now break the
> > > connection to a GUP page (the whole pre-pinning model), but it
> > > probably isn't a new problem for 4.9/4.19.
> > >
> > > I suspect the test there should be something like
> > >
> > >         /* Single mapper, more references than us and the map? */
> > >         if (page_mapcount(page) == 1 && page_count(page) > 2)
> > >                 goto keep_locked;
> > >
> > > in the pre-pinning days.
> > >
> > > But I really think that there are a number of other commits you're
> > > missing too, because we had a whole series for THP fixes for the same
> > > exact issue.
> > >
> > > Added Peter Xu to the cc, because he probably tracked those issues
> > > better than I did.
> > >
> > > So NAK on this for now, I think this limited patch-set likely
> > > introduces more problems than it fixes.
> >
> > Thanks for confirming my worries. I'll be happy to add additional
> > backports if Peter can point me to them.
>
> If for a full-alignment with current upstream, I can at least think of below
> series:
>
> Early cow for general pages:
> https://lore.kernel.org/lkml/20200925222600.6832-1-peterx@redhat.com/
>
> A race fix for copy_page and gup-fast:
> https://lore.kernel.org/linux-mm/0-v4-908497cf359a+4782-gup_fork_jgg@nvidia.com/
>
> Early cow for hugetlbfs (which is very recently):
> https://lore.kernel.org/lkml/20210217233547.93892-1-peterx@redhat.com/
>
> But I believe they'll bring a number of dependencies too like the page pinned
> work; so seems not easy.

Thanks Peter. Let me try backporting these and I'll see if it's doable.

>
> Btw, AFAICT you don't need patch 4/5 in this series for 4.14/4.19, since
> those're only for uffd-wp and it doesn't exist until 5.7.

Got it. Will drop it from the next series.
Thanks,
Suren.

>
> Thanks,
>
> --
> Peter Xu
>
