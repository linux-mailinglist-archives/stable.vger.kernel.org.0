Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFC84967EB
	for <lists+stable@lfdr.de>; Fri, 21 Jan 2022 23:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiAUWfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 17:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiAUWfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 17:35:51 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4BEC06173B
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 14:35:51 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id p7so12280737uao.6
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 14:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0lPulDTNyk1tT0uyWXBSfXERYQLBy2175ie9JUMp2N4=;
        b=irAoru8GAZzoUOxiaEjcHP1bv4tmeWLyRhmRZkD+NLtC5XfBtuYM52oRoGamnEloZW
         3tFevZbNyl4g+rfx0hO92ibSsoodiQRcMgGk6X2mh4m2NMGU4wqJ0yKqMov8F11cNDN9
         tj7ClcGH1afsoCIXopKvub9otzw5KmYm+hoDNR9iEBc+e+q0+QWDnTQ3c7DjS4Czjjzj
         nYum5NyaKP9vkCAJVY1ivd2drT2ahKYnDJktGh/lREw2y5+aE/U+e5Pdhr7FaR/ou/To
         3ek+vQsYWrxfhEPi53onAfsGziGiMYXK4ksZL6ua4tGNY8ZguMhg7q3RqGoii+f3kIZB
         oreQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0lPulDTNyk1tT0uyWXBSfXERYQLBy2175ie9JUMp2N4=;
        b=AHzW7BvCqgtWb6cUXBsM4Rfp06zxP6A2zS8aAKhLvmeJRuas0Az2BAT48o1RQm3bIy
         pC0Ac6CMIeeDKa+FqKjk9ErOXRp3ADhKxpO5slwm8sBicNaDXGbP0Z0z9OZU2Q819/tU
         2Bu6EEfqOpUmGp51wGil0pRhZTpABgf/oG0z+7ycY55fKa5+p4K2rPiygfu6PQDdLkIw
         pBgBPEGxyLXZMp2NKC6JkHS8l7twOgga6vPl14gHDsqZZ9Ewiu+DBWhR98hoHA6ADyZ1
         NlhMAyH9g+3hs1SAzJIUi5xDR36bLREk4g9eQA6Xv4bsLbnnDnY+S9Q6ueVYpUjXIxCq
         fLzA==
X-Gm-Message-State: AOAM530MAR0kd7k6wKStO8FpOAUmNiXH6E/DpEjufCGOzEWBPMA2BoJS
        mx6afcQrW7fgGm9TD1hvh5l8ivIjp6RpFYowcaNnIg==
X-Google-Smtp-Source: ABdhPJxlLDGonXr/zA+7Qq2vhDQVOTU+DxKYdIj2cT/2wRs3d4deZjRDmJhaFVt1P3ia7qc093ayBfk1bAlK536/8Is=
X-Received: by 2002:a67:c48e:: with SMTP id d14mr2674726vsk.67.1642804547204;
 Fri, 21 Jan 2022 14:35:47 -0800 (PST)
MIME-Version: 1.0
References: <20220118230539.323058-1-pcc@google.com> <Yefh00fKOIPj+kYC@hirez.programming.kicks-ass.net>
 <CAMn1gO5n6GofyRv6dvpEe0xRekRx=wneQzwP-n=9Qj6Pez6eEg@mail.gmail.com> <Yek81DNvQAXMxHwB@hirez.programming.kicks-ass.net>
In-Reply-To: <Yek81DNvQAXMxHwB@hirez.programming.kicks-ass.net>
From:   Peter Collingbourne <pcc@google.com>
Date:   Fri, 21 Jan 2022 14:35:36 -0800
Message-ID: <CAMn1gO53G6-sZE8RiLAD2uERbW1XtvyZbRonNGbHonzD058yAA@mail.gmail.com>
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

On Thu, Jan 20, 2022 at 2:43 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Wed, Jan 19, 2022 at 03:28:32PM -0800, Peter Collingbourne wrote:
> > On Wed, Jan 19, 2022 at 2:03 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > On Tue, Jan 18, 2022 at 03:05:39PM -0800, Peter Collingbourne wrote:
> > > > After submitting a patch with a compare-exchange loop similar to this
> > > > one to set the KASAN tag in the page flags, Andrey Konovalov pointed
> > > > out that we should be using READ_ONCE() to read the page flags. Fix
> > > > it here.
> > >
> > > What does it actually fix? If it manages to split the read and read
> > > garbage the cmpxchg will fail and we go another round, no harm done.
> >
> > What I wasn't sure about was whether the compiler would be allowed to
> > break this code by hoisting the read of page->flags out of the loop
> > (because nothing in the loop actually writes to page->flags aside from
> > the compare-exchange, and if that succeeds we're *leaving* the loop).
>
> The cmpxchg is a barrier() and as such I don't think it's allowed to
> hoist anything out of the loop.

Yes it looks like it's at least as powerful as a barrier() because the
implementations I looked at (arm64 and x86) use inline asm with memory
operand (i.e. same as barrier()).

> The bigger problem is I think that page_cpuid_last() usage which does a
> second load of page->flags, and given sufficient races that could
> actually load a different value and then things would be screwy. But
> that's not actually fixed.

Right, the patch you provided (which I posted as v2) inlines the
page_cpuid_last() and should resolve this.

> > > > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > > > Link: https://linux-review.googlesource.com/id/I2e1f5b5b080ac9c4e0eb7f98768dba6fd7821693
> > >
> > > That's that doing here?
> >
> > I upload my changes to Gerrit and link to them here so that I (and
> > others) can see the progression of the patch via the web UI.
>
> What's the life-time guarantee for that URL existing? Because if it
> becomes part of the git commit, it had better stay around 'forever'
> etc..

I'd be surprised if it went away any time soon, the same hosting is
used for projects like Android and Chromium which have been using it
for years and have a long track record of stability.

Also note that the link is useful independent of the host continuing
to be up, it means that you can also do a search of the mailing list
archive like so:
https://lore.kernel.org/all/?q=I2e1f5b5b080ac9c4e0eb7f98768dba6fd7821693
(or the equivalent link on a different mailing list archive if
lore.kernel.org ever gets shut down) and find the progression of the
patch that way. This is particularly useful if (as in this case) the
subject line of the patch changes.

Peter
