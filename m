Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F332E1F64
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 17:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgLWQYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 11:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:57190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgLWQYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 11:24:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6ED1E2229C;
        Wed, 23 Dec 2020 16:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608740611;
        bh=JGM+26aHL4PtP44Zg8xOYHbq6LRGGL7oFlrZL0Y3xx4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WiVzcUdXRW1Pd8E9I9Pip4Mr0xbK1ynGN7oZ+yJseqr+P3f6PM4AJtesIPRJfkaLZ
         wj4TNCsvRVVJNyyyxHopbcughBpG72EX3K2tJdkcmOkAp+vTJlW61J9S8lcKvGAuK8
         JiqqirlP4idJizlgQnkGXfJTumL3VpgU5wKM8zTGCdPkFJJuOl36AbL0uA5pfee6TB
         Ymv05AGVfJ+CTbcD6/OGkXhB8CYNZWtE95Ge/p0clmZibJNaUX+Yb4eqgNTOdhOsvm
         aTuPsG4uuHYQFkm/XDjrjCoIJdVLPyZXbq8Gzds/oPIgVkTyTKUWFanZ1CtbRJyqxx
         HZ9us+z5DBO6A==
Date:   Wed, 23 Dec 2020 16:23:26 +0000
From:   Will Deacon <will@kernel.org>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Yu Zhao <yuzhao@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <20201223162325.GA22699@willie-the-truck>
References: <20201221172711.GE6640@xz-x1>
 <76B4F49B-ED61-47EA-9BE4-7F17A26B610D@gmail.com>
 <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <D4916F41-DE4A-42C6-8702-944382631A02@gmail.com>
 <X+I7TcwMsiS1Bhy/@google.com>
 <E36448EB-2888-42FE-A9F2-2DCF0508C138@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E36448EB-2888-42FE-A9F2-2DCF0508C138@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 11:20:21AM -0800, Nadav Amit wrote:
> > On Dec 22, 2020, at 10:30 AM, Yu Zhao <yuzhao@google.com> wrote:
> > 
> > On Tue, Dec 22, 2020 at 04:40:32AM -0800, Nadav Amit wrote:
> >>> On Dec 21, 2020, at 1:24 PM, Yu Zhao <yuzhao@google.com> wrote:
> >>> 
> >>> On Mon, Dec 21, 2020 at 12:26:22PM -0800, Linus Torvalds wrote:
> >>>> On Mon, Dec 21, 2020 at 12:23 PM Nadav Amit <nadav.amit@gmail.com> wrote:
> >>>>> Using mmap_write_lock() was my initial fix and there was a strong pushback
> >>>>> on this approach due to its potential impact on performance.
> >>>> 
> >>>> From whom?
> >>>> 
> >>>> Somebody who doesn't understand that correctness is more important
> >>>> than performance? And that userfaultfd is not the most important part
> >>>> of the system?
> >>>> 
> >>>> The fact is, userfaultfd is CLEARLY BUGGY.
> >>>> 
> >>>>         Linus
> >>> 
> >>> Fair enough.
> >>> 
> >>> Nadav, for your patch (you might want to update the commit message).
> >>> 
> >>> Reviewed-by: Yu Zhao <yuzhao@google.com>
> >>> 
> >>> While we are all here, there is also clear_soft_dirty() that could
> >>> use a similar fix…
> >> 
> >> Just an update as for why I have still not sent v2: I fixed
> >> clear_soft_dirty(), created a reproducer, and the reproducer kept failing.
> >> 
> >> So after some debugging, it appears that clear_refs_write() does not flush
> >> the TLB. It indeed calls tlb_finish_mmu() but since 0758cd830494
> >> ("asm-generic/tlb: avoid potential double flush”), tlb_finish_mmu() does not
> >> flush the TLB since there is clear_refs_write() does not call to
> >> __tlb_adjust_range() (unless there are nested TLBs are pending).
> > 
> > Sorry Nadav, I assumed you knew this existing problem fixed by:
> > https://patchwork.kernel.org/project/linux-mm/cover/20201210121110.10094-1-will@kernel.org/
> > 
> 
> Thanks, Yu! For some reason I assumed it was already upstreamed and did not
> look back (yet if I was cc’d on v2…)

I'll repost in the new year, as it was a bit tight for the merge window.
I've made a note to put you on cc.

> Yet, something still goes bad. Debugging.

Did you figure this out? I tried to read the whole thread, but it's a bit
of a rollercoaster.

Will
