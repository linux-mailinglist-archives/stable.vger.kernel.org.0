Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAAA12F39D6
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 20:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406056AbhALTQ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 14:16:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404141AbhALTQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 14:16:28 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10C8C061794;
        Tue, 12 Jan 2021 11:15:47 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id v3so1909493plz.13;
        Tue, 12 Jan 2021 11:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0tRaNGrEjZ7VVI8rFnwR+cCsJ6NqUdiRrcFX266r1hA=;
        b=nZvzMKx81n2G28HYoQ/+aIE94yv+8MT80iS8KL/p+cZogpTMtg7LEaE6IaLKjN5npw
         P45Xye1qNiJqZXvZIHqwdvJl4tls1lzIkP271lsxVIWqNfaZ2m7ZUVPzR9nwLs6Yeqn+
         wUfy7GVR6z4Ljy52m2pZHBUbVZ+1OqAjgvsYGJDuBJVPP9vep2XnhENByI5DyI6iRPRQ
         qs6Iu8ulYLuLYuh7u+13QGzHWBDvIHilrTtOdDCZfYHXFfuPuhEd9HcJpEyY46uY/E57
         NBOWxhWnB911wOM1z9imVOIf0uGy/3ORlYD0wwFDlfTxQGYW1ex4FmAN0MDzn/kQLzOC
         IlFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0tRaNGrEjZ7VVI8rFnwR+cCsJ6NqUdiRrcFX266r1hA=;
        b=qKqAWJZTTmeR7v8rIkrghgS6XTfZhtELb1AO1HCB3Ds7QsEVXQw9CKWVlQhNq5N8kZ
         h/yNharW/ZVsG849YryznR4iov0maxlTmcR8kFPiSwDU5qVQrVsVsmLSCtm0hmokYMol
         L4kA48CigMmIdfqQann1zJnR8dxFlFYFOH0Pz6MOpVwh4Znam7kiOv/hYkByRyPZ+t9N
         d2plV1r/WiD916TDyhzWe/+O5Bmipbm7sROuPzmbPlJo3aAUnanzKMmsk6HiWnB/999j
         2WNyUw1GkC9EbhgVMFNHDe4WtCST3jqoBLPAwl+cQboJ6Cn5YO8NTow76CiNLcYnXqK5
         7Vjg==
X-Gm-Message-State: AOAM532o/uMPCZCRGKs9vsnNVlMLf4AN5VuQLtae4hZfippTyU85sjLM
        CPRhZC9bfRBazBcDR9w1BU0=
X-Google-Smtp-Source: ABdhPJzTSMc3aE7AVU9T1WA+JTz7FKFYlJFbcpHt9QckdzpjexzJv1H5KVXZm87aONq1oi7Qirw0nA==
X-Received: by 2002:a17:90b:3892:: with SMTP id mu18mr602891pjb.143.1610478947197;
        Tue, 12 Jan 2021 11:15:47 -0800 (PST)
Received: from [192.168.88.245] (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id iw4sm4194789pjb.55.2021.01.12.11.15.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jan 2021 11:15:46 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
Date:   Tue, 12 Jan 2021 11:15:43 -0800
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>, Yu Zhao <yuzhao@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>, surenb@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
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
 <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
 <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
To:     Laurent Dufour <ldufour@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Jan 12, 2021, at 11:02 AM, Laurent Dufour =
<ldufour@linux.vnet.ibm.com> wrote:
>=20
> Le 12/01/2021 =C3=A0 17:57, Peter Zijlstra a =C3=A9crit :
>> On Tue, Jan 12, 2021 at 04:47:17PM +0100, Laurent Dufour wrote:
>>> Le 12/01/2021 =C3=A0 12:43, Vinayak Menon a =C3=A9crit :
>>>> Possibility of race against other PTE modifiers
>>>>=20
>>>> 1) Fork - We have seen a case of SPF racing with fork marking PTEs =
RO and that
>>>> is described and fixed here =
https://lore.kernel.org/patchwork/patch/1062672/
>> Right, that's exactly the kind of thing I was worried about.
>>>> 2) mprotect - change_protection in mprotect which does the deferred =
flush is
>>>> marked under vm_write_begin/vm_write_end, thus SPF bails out on =
faults
>>>> on those VMAs.
>> Sure, mprotect also changes vm_flags, so it really needs that anyway.
>>>> 3) userfaultfd - mwriteprotect_range is not protected unlike in (2) =
above.
>>>> But SPF does not take UFFD faults.
>>>> 4) hugetlb - hugetlb_change_protection - called from mprotect and =
covered by
>>>> (2) above.
>>>> 5) Concurrent faults - SPF does not handle all faults. Only anon =
page faults.
>> What happened to shared/file-backed stuff? ISTR I had that working.
>=20
> File-backed mappings are not processed in a speculative way, there =
were options to manage some of them depending on the underlying file =
system but that's still not done.
>=20
> Shared anonymous mapping, are also not yet handled in a speculative =
way (vm_ops is not null).
>=20
>>>> Of which do_anonymous_page and do_swap_page are =
NONE/NON-PRESENT->PRESENT
>>>> transitions without tlb flush. And I hope do_wp_page with RO->RW is =
fine as well.
>> The tricky one is demotion, specifically write to non-write.
>>>> I could not see a case where speculative path cannot see a PTE =
update done via
>>>> a fault on another CPU.
>> One you didn't mention is the NUMA balancing scanning crud; although =
I
>> think that's fine, loosing a PTE update there is harmless. But I've =
not
>> thought overly hard on it.
>=20
> That's a good point, I need to double check on that side.
>=20
>>> You explained it fine. Indeed SPF is handling deferred TLB =
invalidation by
>>> marking the VMA through vm_write_begin/end(), as for the fork case =
you
>>> mentioned. Once the PTL is held, and the VMA's seqcount is checked, =
the PTE
>>> values read are valid.
>> That should indeed work, but are we really sure we covered them all?
>> Should we invest in better TLBI APIs to make sure we can't get this
>> wrong?
>=20
> That may be a good option to identify deferred TLB invalidation but =
I've no clue on what this API would look like.

I will send an RFC soon for per-table deferred TLB flushes tracking.
The basic idea is to save a generation in the page-struct that tracks
when deferred PTE change took place, and track whenever a TLB flush
completed. In addition, other users - such as mprotect - would use
the tlb_gather interface.

Unfortunately, due to limited space in page-struct this would only
be possible for 64-bit (and my implementation is only for x86-64).

It would still require to do the copying while holding the PTL though.

