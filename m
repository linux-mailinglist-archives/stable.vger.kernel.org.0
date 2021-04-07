Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893B1356D2D
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 15:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhDGNWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 09:22:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:40544 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232568AbhDGNWG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Apr 2021 09:22:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2220AB08C;
        Wed,  7 Apr 2021 13:21:56 +0000 (UTC)
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Peter Xu <peterx@redhat.com>
Cc:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jann Horn <jannh@google.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>, Shaohua Li <shli@fb.com>,
        Nadav Amit <namit@vmware.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
References: <20210401181741.168763-1-surenb@google.com>
 <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
Message-ID: <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz>
Date:   Wed, 7 Apr 2021 15:21:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAHk-=wg8MDMLi8x+u-dee-ai0KiAavm6+JceV00gRXQRFG=Cgw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/1/21 8:59 PM, Linus Torvalds wrote:
> On Thu, Apr 1, 2021 at 11:17 AM Suren Baghdasaryan <surenb@google.com> wrote:

Thanks Suren for bringing this up!

>> We received a report that the copy-on-write issue repored by Jann Horn in
>> https://bugs.chromium.org/p/project-zero/issues/detail?id=2045 is still
>> reproducible on 4.14 and 4.19 kernels (the first issue with the reproducer
>> coded in vmsplice.c).

Note that even upstream AFAIK still has the issue unfixed when Jann's reproducer
is converted to use THPs, as Andrea has shown in
https://lore.kernel.org/linux-mm/X%2FjgLGPgPb+Xms1t@redhat.com/

> Gaah.
> 
>> I confirmed this and also that the issue was not
>> reproducible with 5.10 kernel. I tracked the fix to the following patch
>> introduced in 5.9 which changes the do_wp_page() logic:
>>
>> 09854ba94c6a 'mm: do_wp_page() simplification'
> 
> The problem here is that there's a _lot_ more patches than the few you
> found that fixed various other cases (THP etc).
> 
>> I backported this patch (#2 in the series) along with 2 prerequisite patches
>> (#1 and #4) that keep the backports clean and two followup fixes to the main
>> patch (#3 and #5). I had to skip the following fix:
>>
>> feb889fb40fa 'mm: don't put pinned pages into the swap cache'
>>
>> because it uses page_maybe_dma_pinned() which does not exists in earlier
>> kernels. Because pin_user_pages() does not exist there as well, I *think*
>> we can safely skip this fix on older kernels, but I would appreciate if
>> someone could confirm that claim.
> 
> Hmm. I think this means that swap activity can now break the
> connection to a GUP page (the whole pre-pinning model), but it
> probably isn't a new problem for 4.9/4.19.
> 
> I suspect the test there should be something like
> 
>         /* Single mapper, more references than us and the map? */
>         if (page_mapcount(page) == 1 && page_count(page) > 2)
>                 goto keep_locked;
> 
> in the pre-pinning days.
> 
> But I really think that there are a number of other commits you're
> missing too, because we had a whole series for THP fixes for the same
> exact issue.
> 
> Added Peter Xu to the cc, because he probably tracked those issues
> better than I did.

Let me shamelessly plug these links for illustrating what kind of minefield we
would be going into backporting this. Also for references what not to miss, and
what may still become broken afterwards:

https://lwn.net/Articles/849638/
https://lwn.net/Articles/849876/

> So NAK on this for now, I think this limited patch-set likely
> introduces more problems than it fixes.

I personally think there are only two options safe enough for stable backports
(so that not more harm is caused than actually prevented).

1) Ignore the issue (outside of Android at least). The security model of zygote
is unusual. Where else a parent of fork() doesn't trust the child, which is the
same binary?

BTW, I think the CVE description is very misleading:
https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2020-29374

"does not properly consider the semantics of read operations and therefore can
grant unintended write access" - the bug was never about an unintended write
access, but about an info leak from parent to child, no?

2) For backports go with the original approach of 17839856fd58 ("gup: document
and work around "COW can break either way" issue"), thus break COW during the
GUP. But only for vmplice() so that nothing else gets broken. I think 5.4 stable
(another LTS) actually backported only 17839856fd58 out of everything else, so
it should have even the THP case covered, but its userfaultfd() is now probably
broken...

>         Linus
> 

