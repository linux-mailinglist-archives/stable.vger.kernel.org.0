Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7496B17FFD2
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 15:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgCJOKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 10:10:08 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39633 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgCJOKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 10:10:07 -0400
Received: by mail-ot1-f65.google.com with SMTP id a9so7048089otl.6
        for <stable@vger.kernel.org>; Tue, 10 Mar 2020 07:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UH/kbp/wpXOAAE3tRNnXeOhnV8pFJCL150z+9pntZ4A=;
        b=RWOmkRG/j7y49Wh3SB9PdFhimY5gdbbMOjfJjQXm6WmxbtGRhWUGE2xUdZ7PzL4/Y/
         Fpvm/Of6YjafgVW2nYRKdQxF+l0LSXglzjiU8dCzWmTqyOm/9m5a04/5C3CTbomPV+Wx
         BBf/GYHEx8y8vA0rDW3muZe3lQoMsG18tsNePYHtL7TDDTpKvQi5TzkvH3txUaUX7kfP
         2KUzZjvsiJ3MWXs49B++XTqiVQaLOz2Z44p2Yzy4G/nxGS8NZ52+OtdnD9qHt90rTzJ5
         fI7NhweRPwmp3LbgL1FaXgg0jWQqVtfHFWmrLzAxSRCbsZG2BT4OfAzKLfOe8C9Z8uc/
         z5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UH/kbp/wpXOAAE3tRNnXeOhnV8pFJCL150z+9pntZ4A=;
        b=MuXLHOZZnV+leuF6mW04Hs2uudiq/UyvGO9FVnBveI8LmOQyPpNgbieg1EpWpBWoVS
         NKj7dVuDOkP75ovAVWR7RZ2XsLvUVCGbIVRE+LZjEnaFl/7UXdh4PuavyeTFoDlU+hBI
         TtzXAwc1BkHrNLQBv96bPZ+D6bIO6qGhugO0lXUwnS9g+WlCm+qBLbAq8hntgfcNpuXb
         FjhbLU16UlEk0ZlohfuQf1pabIIzge1rij81f3EH7i7otDmdnRI/EOn2U4bzGpwaJNfu
         v+6Fif54O4W1M5JttfFPLuDGPszdXQfCjMboYnRyS/+oTDRKwHKlt9LWPhhxGABdMnwk
         cNpw==
X-Gm-Message-State: ANhLgQ35Fek8MV1p/1HMQK2782RVsVt+egP2WtCpYPc70R1o01rbaae9
        cFVtjw7sTHmZIyDqPZZdsjPa7NIkbBs4Q4P+jGwlWBXsib4=
X-Google-Smtp-Source: ADFU+vtwVdEQGAWAoaHHMTTQqrZlkWuEbwFRdLQaXgbygLf45P2NIhBJnC/ZRlCG+ZxCkxL54JOpEYeosmN3rZQiCHk=
X-Received: by 2002:a05:6830:1213:: with SMTP id r19mr9393949otp.17.1583849406243;
 Tue, 10 Mar 2020 07:10:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200310092119.14965-1-chris@chris-wilson.co.uk>
 <2e936d8fd2c445beb08e6dd3ee1f3891@AcuMS.aculab.com> <158384100886.16414.15741589015363013386@build.alporthouse.com>
 <723d527a4ad349b78bf11d52eba97c0e@AcuMS.aculab.com> <20200310125031.GY2935@paulmck-ThinkPad-P72>
In-Reply-To: <20200310125031.GY2935@paulmck-ThinkPad-P72>
From:   Marco Elver <elver@google.com>
Date:   Tue, 10 Mar 2020 15:09:54 +0100
Message-ID: <CANpmjNNT3HY7i9TywX0cAFqBtx2J3qOGOUG5nHzxAZ4bk_qgtg@mail.gmail.com>
Subject: Re: [PATCH] list: Prevent compiler reloads inside 'safe' list iteration
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     David Laight <David.Laight@aculab.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 10 Mar 2020 at 13:50, Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Tue, Mar 10, 2020 at 12:23:34PM +0000, David Laight wrote:
> > From: Chris Wilson
> > > Sent: 10 March 2020 11:50
> > >
> > > Quoting David Laight (2020-03-10 11:36:41)
> > > > From: Chris Wilson
> > > > > Sent: 10 March 2020 09:21
> > > > > Instruct the compiler to read the next element in the list iteration
> > > > > once, and that it is not allowed to reload the value from the stale
> > > > > element later. This is important as during the course of the safe
> > > > > iteration, the stale element may be poisoned (unbeknownst to the
> > > > > compiler).
> > > >
> > > > Eh?
> > > > I thought any function call will stop the compiler being allowed
> > > > to reload the value.
> > > > The 'safe' loop iterators are only 'safe' against called
> > > > code removing the current item from the list.
> > > >
> > > > > This helps prevent kcsan warnings over 'unsafe' conduct in releasing the
> > > > > list elements during list_for_each_entry_safe() and friends.
> > > >
> > > > Sounds like kcsan is buggy ????
>
> Adding Marco on CC for his thoughts.

I'd have to see a stack-trace with line-numbers.

But keep in mind what KCSAN does, which is report "data races". If the
KCSAN report showed 2 accesses, where one of them was a *plain* read
(and the other a write), then it's a valid data race (per LKMM's
definition). It seems this was the case here.

As mentioned, the compiler is free to transform plain accesses in
various concurrency-unfriendly ways.

FWIW, for writes we're already being quite generous, in that plain
aligned writes up to word-size are assumed to be "atomic" with the
default (conservative) config, i.e. marking such writes is optional.
Although, that's a generous assumption that is not always guaranteed
to hold (https://lore.kernel.org/lkml/20190821103200.kpufwtviqhpbuv2n@willie-the-truck/).

If there is code for which you prefer not to see KCSAN reports at all,
you are free to disable them with KCSAN_SANITIZE_file.o := n

Thanks,
-- Marco

> > > The warning kcsan gave made sense (a strange case where the emptying the
> > > list from inside the safe iterator would allow that list to be taken
> > > under a global mutex and have one extra request added to it. The
> > > list_for_each_entry_safe() should be ok in this scenario, so long as the
> > > next element is read before this element is dropped, and the compiler is
> > > instructed not to reload the element.
> >
> > Normally the loop iteration code has to hold the mutex.
> > I guess it can be released inside the loop provided no other
> > code can ever delete entries.
> >
> > > kcsan is a little more insistent on having that annotation :)
> > >
> > > In this instance I would say it was a false positive from kcsan, but I
> > > can see why it would complain and suspect that given a sufficiently
> > > aggressive compiler, we may be caught out by a late reload of the next
> > > element.
> >
> > If you have:
> >       for (; p; p = next) {
> >               next = p->next;
> >               external_function_call(void);
> >       }
> > the compiler must assume that the function call
> > can change 'p->next' and read it before the call.
>
> That "must assume" is a statement of current compiler technology.
> Given the progress over the past forty years, I would not expect this
> restriction to hold forever.  Yes, we can and probably will get the
> compiler implementers to give us command-line flags to suppress global
> analysis.  But given the progress in compilers that I have seen over
> the past 4+ decades, I would expect that the day will come when we won't
> want to be using those command-line flags.
>
> But if you want to ignore KCSAN's warnings, you are free to do so.
>
> > Is this a list with strange locking rules?
> > The only deletes are from within the loop.
> > Adds and deletes are locked.
> > The list traversal isn't locked.
> >
> > I suspect kcsan bleats because it doesn't assume the compiler
> > will use a single instruction/memory operation to read p->next.
> > That is just stupid.
>
> Heh!  If I am still around, I will ask you for your evaluation of the
> above statement in 40 years.  Actually, 10 years will likely suffice.  ;-)
>
>                                                         Thanx, Paul
