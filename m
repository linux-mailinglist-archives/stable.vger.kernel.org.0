Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7304943DE
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 00:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiASX2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 18:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiASX2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 18:28:45 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C12C061574
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 15:28:44 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id 2so7568856uax.10
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 15:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SAvFOz8ghr5oAZyEvyWgFSjE0cOqBv8pLZgD3az/Alw=;
        b=bsrpLBeEmGPON4IVnn1J9LS41vfyBHVbscaKWsuCglNOrJmCd5wbVfUTccva0jnF4t
         279q+9zbrD+ZWr8qrelwJQTRhNzSYbs5gig4TBG0nyZEqIinSkCPAxiYOvna0hrEiv5D
         xoeJC9NwShyhujgekVKeZa14J68SMjQo3LSdBUda1rDhWMATtytzbjfPJCNxcthKatxB
         wt70R5w+8MsTAylz4/5aRRwYbrOpRn5RU8pogPtfenu6omPyh9m0vxuWpD+rg4Rk5VS2
         Cm+SF06WzCepcaQQeTQ12imr97K+3TkPsU54aR6k7wXd2b9y4OVXuKL4xdbvd/7zw4B+
         P/YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SAvFOz8ghr5oAZyEvyWgFSjE0cOqBv8pLZgD3az/Alw=;
        b=YIPr4fqcQjaSP2ADAfT+H8DyhWOMh5ExtTEXuNcFTCm336gwzclnwESG5WZQMwlZE9
         Ds8mI+uV0qQ8Qk7oI5Xm1p5EXCg+u3k+RNd9Tg56NBRCFNItvvUDG45pOLS8fSJeC3e+
         SsWNaqDI1bKdFwn+BkqrsLsfhgtxTqesoasFqSESC546fqtuAlWYVsadNsTfdNBGA4Vv
         B8BNte4tjNLWF0+uYJ4OuvthnJXLcElGUXKOTuMFpElw4QsGuG9/sJ6USHeYnGGgiouv
         q4oRMsg0yc/L5DcE5rzDTKWYobSMhH9wWAM27yGxVDBFyQ1qN+lV9mpGAg46uex7myVy
         VS7w==
X-Gm-Message-State: AOAM532FsoiQKsJ1MblaSaVLSDTbnQiqKBFSCBmluO6xf4YsocE5bYz6
        5GCA7MPIQOOlRjR6FfazqpCTNGFnbusOKjuW3tLftQ==
X-Google-Smtp-Source: ABdhPJztNtP2ASrwQij4Hnq8zUdL8VnM6LFy0K4AN9sQGIkxltMSEPOR/5D8UuhwRg2Dmn31bBqJ3tpesxaIKOurOlI=
X-Received: by 2002:a67:6587:: with SMTP id z129mr140195vsb.61.1642634923681;
 Wed, 19 Jan 2022 15:28:43 -0800 (PST)
MIME-Version: 1.0
References: <20220118230539.323058-1-pcc@google.com> <Yefh00fKOIPj+kYC@hirez.programming.kicks-ass.net>
In-Reply-To: <Yefh00fKOIPj+kYC@hirez.programming.kicks-ass.net>
From:   Peter Collingbourne <pcc@google.com>
Date:   Wed, 19 Jan 2022 15:28:32 -0800
Message-ID: <CAMn1gO5n6GofyRv6dvpEe0xRekRx=wneQzwP-n=9Qj6Pez6eEg@mail.gmail.com>
Subject: Re: [PATCH] mm/mmzone.c: fix page_cpupid_xchg_last() to READ_ONCE()
 the page flags
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 19, 2022 at 2:03 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Jan 18, 2022 at 03:05:39PM -0800, Peter Collingbourne wrote:
> > After submitting a patch with a compare-exchange loop similar to this
> > one to set the KASAN tag in the page flags, Andrey Konovalov pointed
> > out that we should be using READ_ONCE() to read the page flags. Fix
> > it here.
>
> What does it actually fix? If it manages to split the read and read
> garbage the cmpxchg will fail and we go another round, no harm done.

What I wasn't sure about was whether the compiler would be allowed to
break this code by hoisting the read of page->flags out of the loop
(because nothing in the loop actually writes to page->flags aside from
the compare-exchange, and if that succeeds we're *leaving* the loop).
That could potentially result in a loop that never terminates if the
first compare-exchange fails. This is largely a theoretical problem as
far as I know; the assembly produced by clang and gcc on x86_64 and
arm64 appears to be doing the expected thing for now, and we're using
inline asm for compare-exchange instead of the compiler builtins on
those architectures (and on all other architectures it seems? no
matches for __atomic_compare_exchange outside of kcsan and the
selftests) so the compiler wouldn't be able to look inside it anyway.

> > Fixes: 75980e97dacc ("mm: fold page->_last_nid into page->flags where possible")
>
> As per the above argument, I don't think this rates a Fixes tag, there
> is no actual fix.

Okay, I'll remove it unless you find the above convincing.

> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > Link: https://linux-review.googlesource.com/id/I2e1f5b5b080ac9c4e0eb7f98768dba6fd7821693
>
> That's that doing here?

I upload my changes to Gerrit and link to them here so that I (and
others) can see the progression of the patch via the web UI.

> > Cc: stable@vger.kernel.org
>
> That's massively over-selling things.

Fair enough since it isn't causing an actual problem, I'll remove this tag.

> > ---
> >  mm/mmzone.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/mmzone.c b/mm/mmzone.c
> > index eb89d6e018e2..f84b84b0d3fc 100644
> > --- a/mm/mmzone.c
> > +++ b/mm/mmzone.c
> > @@ -90,7 +90,7 @@ int page_cpupid_xchg_last(struct page *page, int cpupid)
> >       int last_cpupid;
> >
> >       do {
> > -             old_flags = flags = page->flags;
> > +             old_flags = flags = READ_ONCE(page->flags);
> >               last_cpupid = page_cpupid_last(page);
> >
> >               flags &= ~(LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT);
>
> I think that if you want to touch that code, something like the below
> makes more sense...

Yeah, that looks a bit nicer. I'll send a v2 and update the other patch as well.

Peter
