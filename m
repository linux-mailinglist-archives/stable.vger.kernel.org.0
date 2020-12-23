Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DD62E161A
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731049AbgLWC5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:57:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729062AbgLWC5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 21:57:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608692180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oQSg++8hqjm9ylbYItdg31CyNp28bld5EmBEiWJuSeg=;
        b=Carh6leZr76Ute2VTkihRp0EgiwZfSGoNAPmL53nn8wRdUsq9mil1Xoe8gNefw+aFuBYw5
        dS13g7IEtkmzMdAE9tc7mQDhjDlC8bskK8TQPVAgVLRu8KczLHqWzotCIFJXPWxOZm+M8y
        ZT79vFe/YGcKVTcUBHwtwPyWewJzAIA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-IqAB_F8YPAm43LgACWvnIQ-1; Tue, 22 Dec 2020 21:56:18 -0500
X-MC-Unique: IqAB_F8YPAm43LgACWvnIQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C2FD7801817;
        Wed, 23 Dec 2020 02:56:15 +0000 (UTC)
Received: from mail (ovpn-112-5.rdu2.redhat.com [10.10.112.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C6045D9CC;
        Wed, 23 Dec 2020 02:56:12 +0000 (UTC)
Date:   Tue, 22 Dec 2020 21:56:11 -0500
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <X+Kxy3oBMSLz8Eaq@redhat.com>
References: <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+KDwu1PRQ93E2LK@google.com>
User-Agent: Mutt/2.0.3 (2020-12-04)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 04:39:46PM -0700, Yu Zhao wrote:
> We are talking about non-COW anon pages here -- they can't be mapped
> more than once. So why not just identify them by checking
> page_mapcount == 1 and then unconditionally reuse them? (This is
> probably where I've missed things.)

The problem in depending on page_mapcount to decide if it's COW or
non-COW (respectively wp_page_copy or wp_page_reuse) is that is GUP
may elevate the count of a COW anon page that become a non-COW anon
page.

This is Jann's idea not mine.

The problem is we have an unprivileged long term GUP like vmsplice
that facilitates elevating the page count indefinitely, until the
parent finally writes a secret to it. Theoretically a short term pin
would do it too so it's not just vmpslice, but the short term pin
would be incredibly more challenging to become a concern since it'd
kill a phone battery and flash before it can read any data.

So what happens with your page_mapcount == 1 check is that it doesn't
mean non-COW (we thought it did until it didn't for the long term gup
pin in vmsplice).

Jann's testcases does fork() and set page_mapcount 2 and page_count to
2, vmsplice, take unprivileged infinitely long GUP pin to set
page_count to 3, queue the page in the pipe with page_count elevated,
munmap to drop page_count to 2 and page_mapcount to 1.

page_mapcount is 1, so you'd think the page is non-COW and owned by
the parent, but the child can still read it so it's very much still
wp_page_copy material if the parent tries to modify it. Otherwise the
child can read the content.

This was supposed to be solvable by just doing the COW in gup(write=0)
case if page_mapcount > 1 with commit 17839856fd58. I'm not exactly
sure why that didn't fly and it had to be reverted by Peter in
a308c71bf1e6e19cc2e4ced31853ee0fc7cb439a but at the time this was
happening I was side tracked by urgent issues and I didn't manage to
look back of how we ended up with the big hammer page_count == 1 check
instead to decide if to call wp_page_reuse or wp_page_shared.

So anyway, the only thing that is clear to me is that keeping the
child from reading the page_mapcount == 1 pages of the parent, is the
only reason why wp_page_reuse(vmf) will only be called on
page_count(page) == 1 and not on page_mapcount(page) == 1.

It's also the reason why your page_mapcount assumption will risk to
reintroduce the issue, and I only wish we could put back page_mapcount
== 1 back there.

Still even if we put back page_mapcount there, it is not ok to leave
the page fault with stale TLB entries and to rely on the fact
wp_page_shared won't run. It'd also avoid the problem but I think if
you leave stale TLB entries in change_protection just like NUMA
balancing does, it also requires a catcher just like NUMA balancing
has, or it'd truly work by luck.

So until we can put a page_mapcount == 1 check back there, the
page_count will be by definition unreliable because of the speculative
lookups randomly elevating all non zero page_counts at any time in the
background on all pages, so you will never be able to tell if a page
is true COW or if it's just a spurious COW because of a speculative
lookup. It is impossible to differentiate a speculative lookup from a
vmsplice ref in a child.

Thanks,
Andrea

