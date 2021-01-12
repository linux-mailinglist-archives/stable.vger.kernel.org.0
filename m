Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF85D2F364F
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 18:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbhALQ7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 11:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbhALQ7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 11:59:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D27C061786;
        Tue, 12 Jan 2021 08:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=W8sMe2vPnGNuau7lYL1rG0wWEO1MGNksSV6JbP+KXRU=; b=fuc0kPd50jC9pP+pM5HMJPVrw1
        bn1MsFzPePeT3dMvCXifMdM+cyBh3dyB2A7Ypz3wavELXFqksqp0G7SGCCjDAbs/OyQNjnQNbG5Y6
        ydx/Pm0suPbw/iXlkemkBE9fk9Spigk2EG0bpF4Zv3A8Lonpi1gEtbjOHeMLG+7h+r2SWMXdIy/e+
        6UPkQCamW+VA/JqChv9B3RJ7Wp7BeVzztpfBLVdp2NAnu7srinxNUE04HKPfDt7l8xoHNyc5zzRTi
        x93hzpyt8aN4nWzTi8QobzWx9TIlf3bas8kki5zY8pl4nouDHTL/i9XZJsenqYpOW73qHYgrVPLv0
        smU62aIg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1kzMzW-0054Be-2e; Tue, 12 Jan 2021 16:58:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3932B30015A;
        Tue, 12 Jan 2021 17:57:55 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1FE8420BF4004; Tue, 12 Jan 2021 17:57:55 +0100 (CET)
Date:   Tue, 12 Jan 2021 17:57:55 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc:     Vinayak Menon <vinmenon@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>, Yu Zhao <yuzhao@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>, surenb@google.com
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
References: <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
 <20210105153727.GK3040@hirez.programming.kicks-ass.net>
 <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
 <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 12, 2021 at 04:47:17PM +0100, Laurent Dufour wrote:
> Le 12/01/2021 à 12:43, Vinayak Menon a écrit :

> > Possibility of race against other PTE modifiers
> > 
> > 1) Fork - We have seen a case of SPF racing with fork marking PTEs RO and that
> > is described and fixed here https://lore.kernel.org/patchwork/patch/1062672/

Right, that's exactly the kind of thing I was worried about.

> > 2) mprotect - change_protection in mprotect which does the deferred flush is
> > marked under vm_write_begin/vm_write_end, thus SPF bails out on faults
> > on those VMAs.

Sure, mprotect also changes vm_flags, so it really needs that anyway.

> > 3) userfaultfd - mwriteprotect_range is not protected unlike in (2) above.
> > But SPF does not take UFFD faults.
> > 4) hugetlb - hugetlb_change_protection - called from mprotect and covered by
> > (2) above.

> > 5) Concurrent faults - SPF does not handle all faults. Only anon page faults.

What happened to shared/file-backed stuff? ISTR I had that working.

> > Of which do_anonymous_page and do_swap_page are NONE/NON-PRESENT->PRESENT
> > transitions without tlb flush. And I hope do_wp_page with RO->RW is fine as well.

The tricky one is demotion, specifically write to non-write.

> > I could not see a case where speculative path cannot see a PTE update done via
> > a fault on another CPU.

One you didn't mention is the NUMA balancing scanning crud; although I
think that's fine, loosing a PTE update there is harmless. But I've not
thought overly hard on it.

> You explained it fine. Indeed SPF is handling deferred TLB invalidation by
> marking the VMA through vm_write_begin/end(), as for the fork case you
> mentioned. Once the PTL is held, and the VMA's seqcount is checked, the PTE
> values read are valid.

That should indeed work, but are we really sure we covered them all?
Should we invest in better TLBI APIs to make sure we can't get this
wrong?


