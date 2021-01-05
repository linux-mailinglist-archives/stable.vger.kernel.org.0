Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A27F2EB202
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 19:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbhAESFY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 13:05:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44445 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727678AbhAESFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 13:05:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609869837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tjij9xYMf6Y62hwh1O7GXaGMsMvqywzvQeHIvJ4Lc+s=;
        b=SbEjl9w6eEmY+VCdEaVzFoyufe9vXicPhHXGdKGW23mX2iEwR8ouiYH9mJgle5X909JPoa
        SJtINKopGqxvo2LP9UE65hRE080+p6rBqHIFxU1jkwQCmPJyF2QaWDWmj5XhmYhPpT4X8N
        kccAuO7Xkk2flaIX+yudZBXxOlbTEuM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-Xh2GoTdcN1qQiXdJXLzRog-1; Tue, 05 Jan 2021 13:03:53 -0500
X-MC-Unique: Xh2GoTdcN1qQiXdJXLzRog-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B25DA0CA0;
        Tue,  5 Jan 2021 18:03:52 +0000 (UTC)
Received: from mail (ovpn-112-76.rdu2.redhat.com [10.10.112.76])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6DBB5E1B5;
        Tue,  5 Jan 2021 18:03:48 +0000 (UTC)
Date:   Tue, 5 Jan 2021 13:03:48 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
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
Message-ID: <X/SqBG7KDKZhSUHu@redhat.com>
References: <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
 <20210105153727.GK3040@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210105153727.GK3040@hirez.programming.kicks-ass.net>
User-Agent: Mutt/2.0.4 (2020-12-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 05, 2021 at 04:37:27PM +0100, Peter Zijlstra wrote:
> (your other email clarified this point; the COW needs to copy while
> holding the PTL and we need TLBI under PTL if we're to change this)

The COW doesn't need to hold the PT lock, the TLBI broadcast doesn't
need to be delivered under PT lock either.

Simply there need to be a TLBI broadcast before the copy. The patch I
sent here https://lkml.kernel.org/r/X+QLr1WmGXMs33Ld@redhat.com that
needs to be cleaned up with some abstraction and better commentary
also misses a smp_mb() in the case flush_tlb_page is not called, but
that's a small detail.

> And I'm thinking the speculative page fault series steps right into all
> this, it fundamentally avoids mmap_sem and entirely relies on the PTL.

I thought about that but that only applies to some kind of "anon" page
fault.

Here the problem isn't just the page fault, the problem is not to
regress clear_refs to block on page fault I/O, and all
MAP_PRIVATE/MAP_SHARED filebacked faults bitting the disk to read
/usr/ will still prevent clear_refs from running (and the other way
around) if it has to take the mmap_sem for writing.

I don't look at the speculative page fault for a while but last I
checked there was nothing there that can tame the above major
regression from CPU speed to disk I/O speed that would be inflicted on
both clear_refs on huge mm and on uffd-wp.

Thanks,
Andrea

