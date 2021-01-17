Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E01D2F918A
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 10:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbhAQJRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 04:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726906AbhAQJRl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 04:17:41 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29385C061573
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 01:17:01 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id q2so25376799iow.13
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 01:17:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mZflcXCXKMWVfqwHzby3E6sfE8/fieUegFMgVhkxjfI=;
        b=exSiN7bFYQ/L0N+xF+/kWru5w5ANyx12gi51ac7fwJT+exIfYMAS0Jys4EnLErwvet
         cpF62pvQmSX90MonSzbPTslrB0LZn0WwOFK8qXNODTw0747IxEMnHLEWAI+XMU7RceK6
         JveCNeSLaF5Z1FblnXyTi4z2vihuQNaXBiDVX61gMD0DxqR2yIFeGmqnP5IZMF6/5Svs
         KUvcC+29IJS1OYgqRHvy+RTRNS7rlfvm0DZVcFeTs5MUq0CCC/ZZRSIpS9XkoKs96neh
         r/6M+t/RymbkcAhOG0cq5yMM83WIy2fHC1jkA3RzxnsTLPppVQhaJR3jOKrC+wXlepko
         iN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mZflcXCXKMWVfqwHzby3E6sfE8/fieUegFMgVhkxjfI=;
        b=LBCMILCO1YC2L73toEkHd5h1O4JIlS66bFThHkzyzVPQ1d9ZqMJCQ3rudbEuwgUYcd
         vYy2J/nwALMBserbhm+avnniYjb1EAOBwQXd/jfQNydO43D7eJ16+Ji3ck7cu+hvTuFK
         sFNjid72JtePGG85zXcVz0f0M0tykgk734gQs4INyTYbOGw488OyDcehIPz9QAXUal9g
         70SRqcA4nYTbND1AoRVKargwSopWENFX29J4h9enNgjz2iBgHf9fN6n0pITujpA58w4t
         x7Zru/wkbJkQ0FVSzMIdp81RA27hf/3M6zrLt/hWCVK7TJuvKL18hSzAK6BlQFV3WhJg
         CfWA==
X-Gm-Message-State: AOAM5314JzGYIDHzlr/KCmkQLyJMiZ5pwMHRtFhHfRVjw2RSUBA9V2Nw
        7hIZy1uBpAcXiYM1KFxGXfyuuQ==
X-Google-Smtp-Source: ABdhPJw8z8W1y60Zj0aqQcX8sqyHe8eJMeFJFBKiIqlddiHOoU4BBdJtNeGTGkb2JNSyUCA53QQd0Q==
X-Received: by 2002:a6b:f202:: with SMTP id q2mr13515212ioh.87.1610875020227;
        Sun, 17 Jan 2021 01:17:00 -0800 (PST)
Received: from google.com ([2620:15c:183:200:4146:6dab:8acb:d876])
        by smtp.gmail.com with ESMTPSA id i4sm3660491ios.54.2021.01.17.01.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 01:16:59 -0800 (PST)
Date:   Sun, 17 Jan 2021 02:16:55 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Will Deacon <will@kernel.org>,
        Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, surenb@google.com,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <YAQAhyOFqEdjTRPJ@google.com>
References: <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
 <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
 <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
 <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
 <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
 <X/3+6ZnRCNOwhjGT@google.com>
 <2C7AE23B-ACA3-4D55-A907-AF781C5608F0@gmail.com>
 <20210112214337.GA10434@willie-the-truck>
 <YAO/9YVceghRYo4T@google.com>
 <85DAADF4-2537-40BD-8580-A57C201FF5F3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <85DAADF4-2537-40BD-8580-A57C201FF5F3@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 16, 2021 at 11:32:22PM -0800, Nadav Amit wrote:
> > On Jan 16, 2021, at 8:41 PM, Yu Zhao <yuzhao@google.com> wrote:
> > 
> > On Tue, Jan 12, 2021 at 09:43:38PM +0000, Will Deacon wrote:
> >> On Tue, Jan 12, 2021 at 12:38:34PM -0800, Nadav Amit wrote:
> >>>> On Jan 12, 2021, at 11:56 AM, Yu Zhao <yuzhao@google.com> wrote:
> >>>> On Tue, Jan 12, 2021 at 11:15:43AM -0800, Nadav Amit wrote:
> >>>>> I will send an RFC soon for per-table deferred TLB flushes tracking.
> >>>>> The basic idea is to save a generation in the page-struct that tracks
> >>>>> when deferred PTE change took place, and track whenever a TLB flush
> >>>>> completed. In addition, other users - such as mprotect - would use
> >>>>> the tlb_gather interface.
> >>>>> 
> >>>>> Unfortunately, due to limited space in page-struct this would only
> >>>>> be possible for 64-bit (and my implementation is only for x86-64).
> >>>> 
> >>>> I don't want to discourage you but I don't think this would end up
> >>>> well. PPC doesn't necessarily follow one-page-struct-per-table rule,
> >>>> and I've run into problems with this before while trying to do
> >>>> something similar.
> >>> 
> >>> Discourage, discourage. Better now than later.
> >>> 
> >>> It will be relatively easy to extend the scheme to be per-VMA instead of
> >>> per-table for architectures that prefer it this way. It does require
> >>> TLB-generation tracking though, which Andy only implemented for x86, so I
> >>> will focus on x86-64 right now.
> >> 
> >> Can you remind me of what we're missing on arm64 in this area, please? I'm
> >> happy to help get this up and running once you have something I can build
> >> on.
> > 
> > I noticed arm/arm64 don't support ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH.
> > Would it be something worth pursuing? Arm has been using mm_cpumask,
> > so it might not be too difficult I guess?
> 
> [ +Mel Gorman who implemented ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH ]
> 
> IIUC, there are at least two bugs in x86 implementation.
> 
> First, there is a missing memory barrier in tlbbatch_add_mm() between
> inc_mm_tlb_gen() and the read of mm_cpumask().

In arch_tlbbatch_add_mm()? inc_mm_tlb_gen() has builtin barrier as its
comment says -- atomic update ops that return values are also full
memory barriers.

> Second, try_to_unmap_flush() clears flush_required after flushing. Another
> thread can call set_tlb_ubc_flush_pending() after the flush and before
> flush_required is cleared, and the indication that a TLB flush is pending
> can be lost.

This isn't a problem either because flush_required is per thread.

> I am working on addressing these issues among others, but, as you already
> saw, I am a bit slow.
> 
> On a different but related topic: Another thing that I noticed that Arm does
> not do is batching TLB flushes across VMAs. Since Arm does not have its own
> tlb_end_vma(), it uses the default tlb_end_vma(), which flushes each VMA
> separately. Peter Zijlstra’s comment says that there are advantages in
> flushing each VMA separately, but I am not sure it is better or intentional
> (especially since x86 does not do so).
> 
> I am trying to remove the arch-specific tlb_end_vma() and have a config
> option to control this behavior.

One thing worth noting is not all arm/arm64 hw versions support ranges.
(system_supports_tlb_range()). But IIUC what you are trying to do, this
isn't a problem.

> Again, sorry for being slow. I hope to send an RFC soon.

No worries. I brought it up only because I noticed it and didn't want
it to slip away.
