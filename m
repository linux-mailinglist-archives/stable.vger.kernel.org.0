Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1C782E16D6
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgLWDC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:02:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29673 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728650AbgLWCTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 21:19:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608689884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RSrw7UyAcSToLq3PDPtiYAZ23LuaYf/Nbwi9L4K4JI8=;
        b=FyIPT93YRn6o+v0ucGvdMmcWW7KqrQuawHXS4/mc/Dkw++z4Mud83hUfviG7wCzi3kPYjW
        cH9NdhBR4b3Awiqzo60Y47eZhor0T5WxABBKE0lTBOo/MDncrqL7EKTz1PIZULAHkuUCca
        FrrxZ9aNHwU48mjoIX9zQLnwceGdtak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-K-wofS1uNcuihB7U42RsaQ-1; Tue, 22 Dec 2020 21:18:03 -0500
X-MC-Unique: K-wofS1uNcuihB7U42RsaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B71C800D62;
        Wed, 23 Dec 2020 02:18:01 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7696C5D9CC;
        Wed, 23 Dec 2020 02:17:57 +0000 (UTC)
Date:   Tue, 22 Dec 2020 21:17:56 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <X+Ko1E808VVFx0+C@redhat.com>
References: <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
 <CAHk-=wjG7xx7Gsb=K0DteB1SPcKjus02zY2gFUoxMY5mm7tfsA@mail.gmail.com>
 <X+KOC4sRtUs4Ljqq@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+KOC4sRtUs4Ljqq@google.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 05:23:39PM -0700, Yu Zhao wrote:
> and 2) people are spearheading multiple efforts to reduce the mmap_lock
> contention, which hopefully would make ufd users suffer less soon.

In my view UFFD is an already deployed working solution that
eliminates the mmap_lock_write contention to allocate and free memory.

We need to add a UFFDIO_POPULATE to use in combination with
UFFD_FEATURE_SIGBUS (UFFDIO_POPULATE just needs to zero out a page or
THP and map it, it'll be indistinguishable to UFFDIO_ZEROPAGE, but it
will solve the last performance bottleneck by avoiding a suprious
wrprotect fault after the allocation).

After that malloc based on uffd should become competitive single
threaded and it won't ever require the mmap_lock_write so allocations
and freeing of memory can continue indefinitely from all threaded in
parallel. There will never be another mmap or munmap stalling all
threads.

This is not why uffd was created, it's just a secondary performance
benefit of uffd, but it's still a relevant benefit in my view.

Every time I hear people with major mmap_lock_write issues I recommend
uffd, but you know, until we add the UFFDIO_POPULATE, it will still
have higher fixed allocation overhead because of the wprotect fault
after UFFDIO_ZEROCOPY. UFFDIO_COPY also would be not as optimal as a
clear_page and currently it's not even THP capable.

In addition you'll get a SIGBUS after an user after free. It's not
like when you have a malloc lib doing MADV_DONTNEED at PAGE_SIZE
granularity to rate limit the costly munmap, and then the app does an
use after free and it reads zero or writes to a newly faulted in page.

The above will not require any special privilege and all allocated
virtual memory remains fully swappable, because SIGBUS mode will never
have to block any kernel initiated faults.

uffd-wp also is totally usable unprivileged by default to replace
various software dirty bits with the info provided in O(1) instead of
O(N), as long as the writes are done in userland also unprivileged by
default without tweaking any sysctl and with zero risk of increasing
reproduciblity of any exploit against unrelated random kernel bugs.

So if we're forced to take the mmap_lock_write it'd be cool if at
least we can avoid it for 1 single pte or hugepmd wrprotection, as it
happens in write_protect_page() KSM.

Thanks,
Andrea

