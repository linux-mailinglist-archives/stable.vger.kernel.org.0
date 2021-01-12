Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9893D2F3596
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 17:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406721AbhALQVg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 11:21:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406720AbhALQVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 11:21:36 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C19C061575;
        Tue, 12 Jan 2021 08:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kGhDTdR81n8CCCQR9d/r+9bXMVr0PrWXkf3bbzi9Cmk=; b=jw0bbm3h0gKYOSgp/1sdWmgJxd
        /lSBwrp9P6yT2bn/aBJU4Y08wCsKXQg+eJk72u0dLNq5ITFWukFLmy2qqOlrSbqVRlfx2H4sg/SiM
        1NXrCHbC5zJTRrA3HODWP1NJVXDVQtWB3lyWXzlKZ/+16Rp5QuLGXbVXmCNGxIY4rZbu99ZphFgEW
        8co6b9/frgBDmYZp7e/Ix3NmDzAxJKZRKPocR95StWDrTHgAMA9ZJQNh6EMpu4ampoE2lsgZjNZx1
        FChxxysEsw814GKA2Nppyw3S3fe/AG35OTn40zDYc4HaD/Yn3j67IIaGm0kMJsPI4Jy/1sADjn/Xe
        6mpWEE8Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kzMPT-0003UZ-OU; Tue, 12 Jan 2021 16:20:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9EE413077B1;
        Tue, 12 Jan 2021 17:20:41 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 894C320CC0313; Tue, 12 Jan 2021 17:20:41 +0100 (CET)
Date:   Tue, 12 Jan 2021 17:20:41 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>, Yu Zhao <yuzhao@google.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X/3MWWYY0FlBpH9r@hirez.programming.kicks-ass.net>
References: <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
 <20210105153727.GK3040@hirez.programming.kicks-ass.net>
 <X/SqBG7KDKZhSUHu@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X/SqBG7KDKZhSUHu@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 01:03:48PM -0500, Andrea Arcangeli wrote:
> On Tue, Jan 05, 2021 at 04:37:27PM +0100, Peter Zijlstra wrote:
> > (your other email clarified this point; the COW needs to copy while
> > holding the PTL and we need TLBI under PTL if we're to change this)
> 
> The COW doesn't need to hold the PT lock, the TLBI broadcast doesn't
> need to be delivered under PT lock either.
> 
> Simply there need to be a TLBI broadcast before the copy. The patch I
> sent here https://lkml.kernel.org/r/X+QLr1WmGXMs33Ld@redhat.com that
> needs to be cleaned up with some abstraction and better commentary
> also misses a smp_mb() in the case flush_tlb_page is not called, but
> that's a small detail.

That's horrific crap. All of that tlb-pending stuff is batshit, and this
makes it worse.

> > And I'm thinking the speculative page fault series steps right into all
> > this, it fundamentally avoids mmap_sem and entirely relies on the PTL.
> 
> I thought about that but that only applies to some kind of "anon" page
> fault.

That must be something new; it used to handle all faults. I specifically
spend quite a bit of time getting the file crud right (which Linus
initially fingered for being horrible broken).

SPF fundamentally elides the mmap_sem, which Linus said must serialize
faults.

> Here the problem isn't just the page fault, the problem is not to
> regress clear_refs to block on page fault I/O, and all

IIRC we do the actual reads without any locks held, just like
VM_FAULT_RETRY does today. You take the fault, find you need IO, drop
locks, do IO, retake fault.

> MAP_PRIVATE/MAP_SHARED filebacked faults bitting the disk to read
> /usr/ will still prevent clear_refs from running (and the other way
> around) if it has to take the mmap_sem for writing.
> 
> I don't look at the speculative page fault for a while but last I
> checked there was nothing there that can tame the above major
> regression from CPU speed to disk I/O speed that would be inflicted on
> both clear_refs on huge mm and on uffd-wp.

All of the clear_refs nonsense is immaterial to SPF. Also, who again
cares about clear_refs? Why is it important?
