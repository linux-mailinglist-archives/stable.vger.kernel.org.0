Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96CC3367572
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 01:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240431AbhDUXAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 19:00:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:60240 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232642AbhDUXAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 19:00:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B7162B2F0;
        Wed, 21 Apr 2021 22:59:36 +0000 (UTC)
Subject: Re: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
To:     Suren Baghdasaryan <surenb@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Peter Xu <peterx@redhat.com>, stable <stable@vger.kernel.org>,
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
 <c7d580fe-e467-4f08-a11d-6b8ceaf41e8f@suse.cz>
 <CAHk-=wiQCrpxGL4o5piCSqJF0jahUUYW=9R=oGATiiPnkaGY0g@mail.gmail.com>
 <CAJuCfpFgHMMWZgch5gfjHj936gmpDztb8ZT-vJn6G0-r5BvceA@mail.gmail.com>
 <CAHk-=wj0JH6PnG7dW51Sr5ZqhomqSaSLTQV7z4Si2dLeSVcO_g@mail.gmail.com>
 <alpine.LRH.2.02.2104071432420.31819@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=whUKYdWbKfFzXXnK8n04oCMwEgSnG8Y3tgE=YZUjiDvbA@mail.gmail.com>
 <CAJuCfpHa+eydE_voX38V-jtv5J_RnyT=eY12-VmcLbVG_u2dyA@mail.gmail.com>
 <CAJuCfpHJjtv_=jLULge8D4EK_AK2yGLMcWKcGSaknzuWm0DFtA@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <01f47bcc-ed9d-85c0-2dd1-a7f604d1ad28@suse.cz>
Date:   Thu, 22 Apr 2021 00:59:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CAJuCfpHJjtv_=jLULge8D4EK_AK2yGLMcWKcGSaknzuWm0DFtA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/21/21 10:01 PM, Suren Baghdasaryan wrote:
> On Wed, Apr 7, 2021 at 2:53 PM Suren Baghdasaryan <surenb@google.com> wrote:
>>
>> On Wed, Apr 7, 2021 at 12:23 PM Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>> >
>> > On Wed, Apr 7, 2021 at 11:47 AM Mikulas Patocka <mpatocka@redhat.com> wrote:
>> > >
>> > > So, we fixed it, but we don't know why.
>> > >
>> > > Peter Xu's patchset that fixed it is here:
>> > > https://lore.kernel.org/lkml/20200821234958.7896-1-peterx@redhat.com/
>> >
>> > Yeah, that's the part that ends up being really painful to backport
>> > (with all the subsequent fixes too), so the 4.14 people would prefer
>> > to avoid it.
>> >
>> > But I think that if it's a "requires dax pmem and ptrace on top", it
>> > may simply be a non-issue for those users. Although who knows - maybe
>> > that ends up being a real issue on Android..
>>
>> A lot to digest, so I need to do some reading now. Thanks everyone!
> 
> After a delay due to vacation I prepared backports of 17839856fd58
> ("gup: document and work around "COW can break either way" issue") for
> 4.14 and 4.19 kernels. As Linus pointed out, uffd-wp was introduced
> later in 5.7, so is not an issue for 4.x kernels. The issue with THPs
> is still unresolved, so with or without this patch it's still there
> (Android is not affected by this since we do not use THPs with older
> kernels).

Which THP issue do you mean here? The race that was part of the same Project
zero report and was solved by a different patch adding some locking? Or the
vmsplice info leak but applied to THP's? Because if it's the latter then I
believe 17839856fd58 did solve that too. It was the later switch of approach to
rely just on page_count() that left THP side unfixed.

> Andrea pointed out that there are other issues and to properly fix
> them his COR approach is needed. However it has not been accepted yet,
> so I can't really backport it. I'll be happy to do that though if it
> is accepted in the future.
> 
> Peter, you mentioned https://lkml.org/lkml/2020/8/10/439 patch to
> distinguish real writes vs enforced COW read requests, however I also
> see that you had a later version of this patch here:
> https://lore.kernel.org/patchwork/patch/1286506/. Which one should I
> backport? Or is it not needed in the absence of uffd-wp support in the
> earlier kernels?
> Thanks,
> Suren.
> 
>>
>> >
>> >             Linus
> 

