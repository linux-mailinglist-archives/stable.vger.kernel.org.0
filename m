Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991EF357232
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 18:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236026AbhDGQd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 12:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbhDGQdz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 12:33:55 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089F3C061756
        for <stable@vger.kernel.org>; Wed,  7 Apr 2021 09:33:45 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 185so15234441ybf.3
        for <stable@vger.kernel.org>; Wed, 07 Apr 2021 09:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0lwsn0u8IqnICGvyAtiBlcyUYYkzwv4EZu9XbSKhZrg=;
        b=TWEJp7OutTUnO1JIFD74hY9u3yciqYCtgTdf56knITi6CkAmDtCZZXDMRNzmbxnwrh
         bLHAUsZyRk7YcRxxvH0CTDeN94hfbeaxsbuMc3jFOmszMsXYQ6t7s+4XYsSSQoYD0XMm
         g0xESiZe/ihc/ZUZhY1zfewcJSN5cKnL5I05FBSo4ZfGoR6AO9Fbk6mSYP5PU7/ek/WR
         /2DTrzU+zBKENUWBy14uNSqqlSy3Bj83K+hkINV0y2/4b3cQXOJasAoO0gzC31WUmfgX
         sK/EqdltijimdWmmrGTeeKImYGQK5Mukh16EitOpxY/MQh11Uz77zdL7q/9GmnfUQp66
         gw+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0lwsn0u8IqnICGvyAtiBlcyUYYkzwv4EZu9XbSKhZrg=;
        b=Yz1TwGhUD/as/RESxSmw9A1P4L+ASfWecWTirSBisQIFoDB8+tEXlwMQmScZgs9EyY
         jOZA17eiyDlFEXi8gXPnVoAFmdDkqAao4sP87yaFEQw6VhNruQZHqXX5N1kBIwEIx3vw
         rzIjbXkusMbzaHNohlJRSQa7mmcq4Z8tNUHPAo++/TSzCXGslrgMLKKAaanuP+TLhfWa
         9tNzRdVGOlTRT5nn47VEm5e7EpITJfPckTqem6pE0+x+BEVeVEpbyUqMtGZR1wwusBu2
         lBt2NMkO4fXH+TfNUTnsM7MPDgvpLZ5Ld9iTpztW03qCiKQ9IISNj85SsAxwK2/+NaHO
         3GvA==
X-Gm-Message-State: AOAM5302Z0ZMYmFOtWBOjqQ2DE8CjXlSD6qP2DPzH6ClaerUxh6ADGPv
        7kzYeuUieZUQHzlvkvhLe4QGeFStlPYqnYFwiBgaLA==
X-Google-Smtp-Source: ABdhPJxMcZIjSk5SxemHmmgHhUXGk613blsBNSxX/7m9hmiZI2uoGUA/6Ddd825mHLMNN1EViUgxwXpkg1G7eOH3h+0=
X-Received: by 2002:a25:c801:: with SMTP id y1mr5843563ybf.250.1617813224849;
 Wed, 07 Apr 2021 09:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com> <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
 <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz> <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
In-Reply-To: <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Wed, 7 Apr 2021 09:33:34 -0700
Message-ID: <CAJuCfpFgHMMWZgch5gfjHj936gmpDztb8ZT-vJn6G0-r5BvceA@mail.gmail.com>
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Vlastimil Babka <vbabka@suse.cz>, Peter Xu <peterx@redhat.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>, Shaohua Li <shli@fb.com>,
        Nadav Amit <namit@vmware.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 7, 2021 at 9:07 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Wed, Apr 7, 2021 at 6:22 AM Vlastimil Babka <vbabka@suse.cz> wrote:
> >
> > 1) Ignore the issue (outside of Android at least). The security model of zygote
> > is unusual. Where else a parent of fork() doesn't trust the child, which is the
> > same binary?
>
> Agreed. I think this is basically an android-only issue (with
> _possibly_ some impact on crazy "pin-and-fork" loads), and doesn't
> necessarily merit a backport at all.
>
> If Android people insist on using very old kernels, knowing that they
> do things that are questionable with those old kernels, at some point
> it's just _their_ problem.

We don't really insist on using old kernels but rather we are stuck
with them for some time.
Trying my hand at backporting the patchsets Peter mentioned proved
this to be far from easy with many dependencies. Let me look into
Vlastimil's suggestion to backport only 17839856fd58 and it sounds
like 5.4 already followed that path. Thanks for all the information!
Suren.

>
>                  Linus
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
