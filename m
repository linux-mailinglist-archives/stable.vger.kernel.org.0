Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0518F352011
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 21:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhDAToJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 15:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235128AbhDAToI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 15:44:08 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F72C0613E6
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 12:44:04 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id z1so2947209ybf.6
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 12:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iF4IO7QJLHB6aKo372bx64673+ThKmhycS/rht00sIM=;
        b=UqSXdWUdJ61mv2MAEfoJjth4rwv55Z8tDgpBepcP4WQNxezaT9RozpomUKDEgzu0kZ
         LKLYtEB76D1E7DNJXIw7AD8sDQ2qQq11WaGkX2KBicR1GyTZt6KN/a4wNIn/3MBs9rSD
         LOoxNUUwlXB2N/figtDa/594dUIrwewp4hTlnXq2bNTeurh0eWGmjjJCRh5Dd13uwS/E
         5oFKphZ5dip6g4QIUmPZBu9CPVJjtlesQX+at+Ezrlo5gRyZ6G3vetCXh9MTWCXWD+kK
         wRJ4eEvLRBc7H5+lzOm+GRxUjcr4+nsNoN8Gpreh9hQ1FGV5+iYNUvra4TjlvuW7b8dn
         8DPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iF4IO7QJLHB6aKo372bx64673+ThKmhycS/rht00sIM=;
        b=VvvI/0LQ1c2Qp4ixIGFz4VyeuXssT/b3P+bhRByozUpH2nB/MV7Lp6TElyvc/uwe9l
         3W0g2/jPtAoG6pRfIc4BwADp1u9NALFQsp/zb/1bz9k+ArvgIezKy0xqIeg/3wcrNHxB
         n0PE5Xxx8iO4N6pGujaMOWeLjB5dTJsmtLx9EmtpMSojZanXot06YvLAO0C77j0mY90P
         Ih09ujatfjNG9YHsLSlN3wG4bvNDSnFy/2e94eHHwY5B37+0R39usBTY2FTxezTA8ZII
         oGmxDctOTN/YaoHMOvH72JKaOrRzF6CjiXO/cE5Cupc7p/kG305/GbvN1Gvh12ePbyqd
         3FKA==
X-Gm-Message-State: AOAM532U6yiW4KeYi0jObuDTyCDO2qqkBRp7nMoiXsVd1+ROnprXequ1
        wl7w0zAxI9USdKnRabPD+DJpMUiuNgkjtbJzWvpT2g==
X-Google-Smtp-Source: ABdhPJxrv6pcBArSMr7HCn/xpEaCzYR1DW1hvA3LHx+g2zLnj8kZ3SEH5Uj7nc17H/9/IzV0nAhRoIJbCmibJufgJo4=
X-Received: by 2002:a25:38c1:: with SMTP id f184mr14718948yba.84.1617306242737;
 Thu, 01 Apr 2021 12:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com> <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
In-Reply-To: <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Thu, 1 Apr 2021 12:43:51 -0700
Message-ID: <CAJuCfpE48zkcM_2GABBpXssjmivKLt+r8+CEeXafqK3VNMMjDw@mail.gmail.com>
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Peter Xu <peterx@redhat.com>, stable <stable@vger.kernel.org>,
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

On Thu, Apr 1, 2021 at 11:59 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Apr 1, 2021 at 11:17 AM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > We received a report that the copy-on-write issue repored by Jann Horn in
> > https://bugs.chromium.org/p/project-zero/issues/detail?id=2045 is still
> > reproducible on 4.14 and 4.19 kernels (the first issue with the reproducer
> > coded in vmsplice.c).
>
> Gaah.
>
> > I confirmed this and also that the issue was not
> > reproducible with 5.10 kernel. I tracked the fix to the following patch
> > introduced in 5.9 which changes the do_wp_page() logic:
> >
> > 09854ba94c6a 'mm: do_wp_page() simplification'
>
> The problem here is that there's a _lot_ more patches than the few you
> found that fixed various other cases (THP etc).
>
> > I backported this patch (#2 in the series) along with 2 prerequisite patches
> > (#1 and #4) that keep the backports clean and two followup fixes to the main
> > patch (#3 and #5). I had to skip the following fix:
> >
> > feb889fb40fa 'mm: don't put pinned pages into the swap cache'
> >
> > because it uses page_maybe_dma_pinned() which does not exists in earlier
> > kernels. Because pin_user_pages() does not exist there as well, I *think*
> > we can safely skip this fix on older kernels, but I would appreciate if
> > someone could confirm that claim.
>
> Hmm. I think this means that swap activity can now break the
> connection to a GUP page (the whole pre-pinning model), but it
> probably isn't a new problem for 4.9/4.19.
>
> I suspect the test there should be something like
>
>         /* Single mapper, more references than us and the map? */
>         if (page_mapcount(page) == 1 && page_count(page) > 2)
>                 goto keep_locked;
>
> in the pre-pinning days.
>
> But I really think that there are a number of other commits you're
> missing too, because we had a whole series for THP fixes for the same
> exact issue.
>
> Added Peter Xu to the cc, because he probably tracked those issues
> better than I did.
>
> So NAK on this for now, I think this limited patch-set likely
> introduces more problems than it fixes.

Thanks for confirming my worries. I'll be happy to add additional
backports if Peter can point me to them.
Thanks,
Suren.

>
>         Linus
