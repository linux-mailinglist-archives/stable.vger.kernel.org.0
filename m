Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8952EAEDC
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 16:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbhAEPjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 10:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbhAEPjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 10:39:31 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C1E7C061574;
        Tue,  5 Jan 2021 07:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4gg5v8gYolfKEI/M5DZ6ILyDSGPGL00ihhXUV/cqmCI=; b=cOauWB3Xr42RBSMHO7PQU/Qyh1
        /QNF1n5YXhHE7cyf9lPTvk7S8GVTlyJY+bYDID/AYz8XgqcAFcbA0eT2tmoaVdAQ0jgrzd+2JWI9g
        uU5u/fBnPw50d7SVBgO+f0Z6fhZZQh5bWC+4QlSvSqHUQ72s0Y3U64m9FJ/KFrCYjJjzFKJ2hiM+F
        rfi/+aQc7Xg4VUoC2BRDbKE9C7DEB+qZIXLt7BLi0XKXJ6E9gOQ1eGoqwGzCyvU1m5Vr1tKFERCBy
        wXAtq1knz8fFQxQ7iU+7Wgqnvtq8B6GmTELgqMsYYf+0dJayBCOFk2gXiUhlIA+prgnK6qaeP8n61
        9tCKnPQQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kwoOm-001OSY-K1; Tue, 05 Jan 2021 15:37:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4D3E230015A;
        Tue,  5 Jan 2021 16:37:27 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3ED9E201B8B84; Tue,  5 Jan 2021 16:37:27 +0100 (CET)
Date:   Tue, 5 Jan 2021 16:37:27 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>, Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>, Yu Zhao <yuzhao@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <20210105153727.GK3040@hirez.programming.kicks-ass.net>
References: <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 21, 2020 at 08:16:11PM -0800, Linus Torvalds wrote:

> So I think the basic rule is that "if you hold mmap_sem for writing,
> you're always safe". And that really should be considered the
> "default" locking.
> 
> ANY time you make a modification to the VM layer, you should basically
> always treat it as a write operation, and get the mmap_sem for
> writing.
> 
> Yeah, yeah, that's a bit simplified, and it ignores various special
> cases (and the hardware page table walkers that obviously take no
> locks at all), but if you hold the mmap_sem for writing you won't
> really race with anything else - not page faults, and not other
> "modify this VM".

> To a first approximation, everybody that changes the VM should take
> the mmap_sem for writing, and the readers should just be just about
> page fault handling (and I count GUP as "page fault handling" too -
> it's kind of the same "look up page" rather than "modify vm" kind of
> operation).
> 
> And there are just a _lot_ more page faults than there are things that
> modify the page tables and the vma's.
> 
> So having that mental model of "lookup of pages in a VM take mmap_semn
> for reading, any modification of the VM uses it for writing" makes
> sense both from a performance angle and a logical standpoint. It's the
> correct model.

> And it's worth noting that COW is still "lookup of pages", even though
> it might modify the page tables in the process. The same way lookup
> can modify the page tables to mark things accessed or dirty.
> 
> So COW is still a lookup operation, in ways that "change the
> writabiility of this range" very much is not. COW is "lookup for
> write", and the magic we do to copy to make that write valid is still
> all about the lookup of the page.

(your other email clarified this point; the COW needs to copy while
holding the PTL and we need TLBI under PTL if we're to change this)

> Which brings up another mental mistake I saw earlier in this thread:
> you should not think "mmap_sem is for vma, and the page table lock is
> for the page table changes".
> 
> mmap_sem is the primary lock for any modifications to the VM layout,
> whether it be in the vma's or in the page tables.
> 
> Now, the page table lock does exist _in_addition_to_ the mmap_sem, but
> it is partly because
> 
>  (a) we have things that historically walked the page tables _without_
> walking the vma's (notably the virtual memory scanning)
> 
>  (b) we do allow concurrent page faults, so we then need a lower-level
> lock to serialize the parallelism we _do_ have.

And I'm thinking the speculative page fault series steps right into all
this, it fundamentally avoids mmap_sem and entirely relies on the PTL.

Which opens it up to exactly these races explored here.

The range lock approach does not suffer this, but I'm still worried
about the actual performance of that thing.
