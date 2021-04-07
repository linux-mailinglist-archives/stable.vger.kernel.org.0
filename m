Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCA5357483
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 20:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355391AbhDGSrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 14:47:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38208 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345008AbhDGSrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 14:47:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617821250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dVEk/1fEkTxDG5RFyJGsfUGGYX5/1CX7VyVlrXRHqbo=;
        b=EYWqrpqy3WFprsqxj4XZAkfDlRyxswDdDp6TBtb/iCgk9SVcPs0cFVm/RDirjqdP8I79Oj
        E05VK1trLvQThyRNiZNkeMm1PZ/0de4glpRhBlUVE8TjnyJR8FyhFbwB8Q9LbxRUFgEeJ1
        ARBuVvivqQbhU0sBKNaXXZhoC+0R/EA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-X8AAo0wFO4amFynrr9khVQ-1; Wed, 07 Apr 2021 14:47:26 -0400
X-MC-Unique: X8AAo0wFO4amFynrr9khVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E327193D;
        Wed,  7 Apr 2021 18:47:24 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B01C7094A;
        Wed,  7 Apr 2021 18:47:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 137IlEvK007320;
        Wed, 7 Apr 2021 14:47:14 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 137IlEnf007316;
        Wed, 7 Apr 2021 14:47:14 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 7 Apr 2021 14:47:14 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Linus Torvalds <torvalds@linux-foundation.org>
cc:     Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Peter Xu <peterx@redhat.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>, Shaohua Li <shli@fb.com>,
        Nadav Amit <namit@vmware.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork()
 issue"
In-Reply-To: <CAHk-=wj0JH6PnG7dW51Sr5ZqhomqSaSLTQV7z4Si2dLeSVcO_g@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.2104071432420.31819@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210401181741.168763-1-surenb@google.com> <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com> <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz> <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
 <CAJuCfpFgHMMWZgch5gfjHj936gmpDztb8ZT-vJn6G0-r5BvceA@mail.gmail.com> <CAHk-=wj0JH6PnG7dW51Sr5ZqhomqSaSLTQV7z4Si2dLeSVcO_g@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Wed, 7 Apr 2021, Linus Torvalds wrote:

> On Wed, Apr 7, 2021 at 9:33 AM Suren Baghdasaryan <surenb@google.com> wrote:
> >
> > Trying my hand at backporting the patchsets Peter mentioned proved
> > this to be far from easy with many dependencies. Let me look into
> > Vlastimil's suggestion to backport only 17839856fd58 and it sounds
> > like 5.4 already followed that path.
> 
> Well, in many ways 17839856fd58 was the "simple and obvious" fix, and
> I do think it's easily backportable.
> 
> But it *did* cause problems too. Those problems may not be issues on
> those old kernels, though.
> 
> In particular, commit 17839856fd58 caused uffd-wp to stop working
> right, and it caused some issues with debugging (I forget the exact
> details, but I think it was strace accessing PROT_NONE or write-only
> pages or something like that, and COW failed).
> 
> But yes, in many ways that commit is a much simpler and more
> straightforward one (which is why I tried it once - we ended up with
> the much more subtle and far-reaching fixes after the UFFD issues
> crept up).
> 
> The issues that 17839856fd58 caused may be entire non-events in old
> kernels. In fact, the uffd writeprotect API was added fairly recently
> (see commit 63b2d4174c4a that made it into v5.7), so the uffd-wp issue
> that was triggered probably cannot happen in the old kernels.
> 
> The strace issue might not be relevant either, but I forget what the
> details were. Mikilas should know.
> 
> See
> 
>   https://lore.kernel.org/lkml/alpine.LRH.2.02.2009031328040.6929@file01.intranet.prod.int.rdu2.redhat.com/
> 
> for Mikulas report. I never looked into it in detail, because by then
> the uffd-wp issue had already come up, so it was juat another nail in
> the coffin for that simpler approach.
> 
> Mikulas, do you remember?
> 
>             Linus

Hi

I think that we never found a root cause for this bug. I was testing if 
the whole system can run from persistent memory and found out that strace 
didn't work. I bisected it, reported it and when I received Peter Xu's 
patches (which fixed it), I stopped bothering about it.

So, we fixed it, but we don't know why.

Peter Xu's patchset that fixed it is here: 
https://lore.kernel.org/lkml/20200821234958.7896-1-peterx@redhat.com/

Mikulas

