Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740C348B796
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 20:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238134AbiAKTqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 14:46:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238043AbiAKTqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 14:46:03 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D00C061751
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:46:03 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id n68so61994ybg.6
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 11:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cYM3w6sF3GdNlmdqLvAoD7AhfrvfG2EVFga6RBsDJ9A=;
        b=Mt4ZASK5zi7OxlYN4uGWn9Al8aSRx+NyY1vjI15KA4jFibPPBJTK0LsBdKI5/wVDN8
         eaABaF1xFQE5sKb+gEqCtpMfku5ENOs52hdnXevVJEeqkfTXfnGEpBFzZsj+jfJWBUkt
         cN+W5nWoQmVm/euxNmr/0ztHk2yUYx/vRTQTcNKIwSpGIz2F/Gb5GzPPiWUP4kPl0H51
         XyiW2xfhxi12nT22oA6Ee1rnwDGadXCICsVO0HHCylk/goPrjd8gJLBDggGTVy3r7aPM
         QbQs5su1PWXq2rThuWhQNw/0zOCtFqj/I0l7eSxQsagO9kSbvlXtzMZJmIzsuJPPtLHJ
         VqIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cYM3w6sF3GdNlmdqLvAoD7AhfrvfG2EVFga6RBsDJ9A=;
        b=ZhJlVGHp8PSi74xXsKBMUXwod1d56RnnoaM9fi3y3fjogzeZ8jxfWGzjie5XYgPB4l
         fQxgEMEqvAhhomJB0+ChBOKGtrjpeQ0WaHZ3MSZSlbbjwrTPFpjJzzgadfnvkt5Xx2F3
         mnK9B7BGIDoFNz4GfIlFkf3L6ntj3Si+jN6+rcuUW/FNH3J7FEjzQ8arAkL/OY59Ss7K
         Le0xNu/aQba9FZMM5CC1HNl9uzWICDEjVc56yEWMjj0YrCIC05jCQeOVB+ECmPekBOvV
         VXYdnMmMSBUDtTKtAi1KB+96i7acJp/9excGid8dXqMQ6pNL4AhRCBm1b8CbfQCsgJL+
         emCQ==
X-Gm-Message-State: AOAM5330wToIjnzuZA/MoX7y2Xt65IOAHl/rYFFS284lK63NEWgV7d+0
        Q5NwQwHbpXibtqJHWQ/084SzQoQW/VHq3kLPmzD0Ww==
X-Google-Smtp-Source: ABdhPJxtRLe6Zimy3MHweCXdFfLcBfuLcx3Mq7DAKN8ULSy5mN/rEw3QfyO4i0xleuMlT2sGdO3D6SZbc67H3XCCgIw=
X-Received: by 2002:a25:a4e9:: with SMTP id g96mr7699463ybi.318.1641930362162;
 Tue, 11 Jan 2022 11:46:02 -0800 (PST)
MIME-Version: 1.0
References: <20220111071212.1210124-1-surenb@google.com> <Yd3RClhoz24rrU04@sol.localdomain>
 <CAHk-=wgwb6pJjvHYmOMT-yp5RYvw0pbv810Wcxdm5S7dWc-s0g@mail.gmail.com> <Yd3dZklleDnJCQ46@gmail.com>
In-Reply-To: <Yd3dZklleDnJCQ46@gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Tue, 11 Jan 2022 11:45:50 -0800
Message-ID: <CAJuCfpHq+YuvGxUN_6T0Hhit9xqrHptEURUYA9yoQ=a4Mxm=ug@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        syzbot <syzbot+cdb5dd11c97cc532efad@syzkaller.appspotmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 11, 2022 at 11:41 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Jan 11, 2022 at 11:11:32AM -0800, Linus Torvalds wrote:
> > On Tue, Jan 11, 2022 at 10:48 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > The write here needs to use smp_store_release(), since it is paired with the
> > > concurrent READ_ONCE() in psi_trigger_poll().
> >
> > A smp_store_release() doesn't make sense pairing with a READ_ONCE().
> >
> > Any memory ordering that the smp_store_release() does on the writing
> > side is entirely irrelevant, since the READ_ONCE() doesn't imply any
> > ordering on the reading side. Ordering one but not the other is
> > nonsensical.
> >
> > So the proper pattern is to use a WRITE_ONCE() to pair with a
> > READ_ONCE() (when you don't care about memory ordering, or you handle
> > it explicitly), or a smp_load_acquire() with a smp_store_release() (in
> > which case writes before the smp_store_release() on the writing side
> > will be ordered wrt accesses after smp_load_acquire() on the reading
> > side).
> >
> > Of course, in practice, for pointers, the whole "dereference off a
> > pointer" on the read side *does* imply a barrier in all relevant
> > situations. So yes, a smp_store_release() -> READ_ONCE() does work in
> > practice, although it's technically wrong (in particular, it's wrong
> > on alpha, because of the completely broken memory ordering that alpha
> > has that doesn't even honor data dependencies as read-side orderings)
> >
> > But in this case, I do think that since there's some setup involved
> > with the trigger pointer, the proper serialization is to use
> > smp_store_release() to set the pointer, and then smp_load_acquire() on
> > the reading side.
> >
> > Or just use the RCU primitives - they are even better optimized, and
> > handle exactly that case, and can be more efficient on some
> > architectures if release->acquire isn't already cheap.
> >
> > That said, we've pretty much always accepted that normal word writes
> > are not going to tear, so we *have* also accepted just
> >
> >  - do any normal store of a value on the write side
> >
> >  - do a READ_ONCE() on the reading side
> >
> > where the reading side doesn't actually care *what* value it gets, it
> > only cares that the value it gets is *stable* (ie no compiler reloads
> > that might show up as two different values on the reading side).
> >
> > Of course, that has the same issue as WRITE_ONCE/READ_ONCE - you need
> > to worry about memory ordering separately.
> >
> > > > +     seq->private = new;
> > >
> > > Likewise here.
> >
> > Yeah, same deal, except here you can't even use the RCU ones, because
> > 'seq->private' isn't annotated for RCU.
> >
> > Or you'd do the casting, of course.
> >
>
> This is yet another case of "one time init".  There have been long discussions
> on this topic before:
> * https://lore.kernel.org/linux-fsdevel/20200713033330.205104-1-ebiggers@kernel.org/T/#u
> * https://lore.kernel.org/lkml/20200916233042.51634-1-ebiggers@kernel.org/T/#u
> * https://lwn.net/Articles/827180/
>
> I even attempted to document the best practices:
> * https://lore.kernel.org/linux-fsdevel/20200717044427.68747-1-ebiggers@kernel.org/T/#u
>
> However, no one could agree on whether READ_ONCE() or smp_load_acquire() should
> be used.  smp_load_acquire() is always correct, so it remains my preference.
> However, READ_ONCE() is correct in some cases, and some people (including the
> primary LKMM maintainer) insist that it be used in all such cases, as well as in
> rcu_dereference() even though this places difficult-to-understand constraints on
> how rcu_dereference() can be used.
>
> My preference is that smp_load_acquire() be used.  But be aware that this risks
> the READ_ONCE() people coming out of the woodwork and arguing for READ_ONCE().

I like my chances here (I believe we do need memory ordering in this
case). I'll post a fix with smp_load_acquire/smp_store_release shortly
after I run my tests. Thanks for the guidance!

>
> - Eric
