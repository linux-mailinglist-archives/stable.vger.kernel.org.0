Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91F47673A3
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 19:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfGLRAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 13:00:21 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:44123 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727226AbfGLRAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Jul 2019 13:00:21 -0400
Received: by mail-vs1-f68.google.com with SMTP id v129so7108585vsb.11
        for <stable@vger.kernel.org>; Fri, 12 Jul 2019 10:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xa/JIc+XiGXpm5Gi1iHsvZxDgn8MNFaOrmXkkSzsQhU=;
        b=ntqoYFzy45x5nH1dbIIy2cdYjWHGlisy72XlIy7vKgmOHMuEOp7rDYlRHlZK5KslUH
         cSTpclAr5jlrXouH5YXj/oC00K9V2ghHhHw5d2MyX/IbEwftEaNyQEvwu+2TrCmJttMg
         xijN++2pDIXgAsaQHll/UjzHAU3PaAauqgv+/kdMpO7jC1H7ZyUwIPBWmFNz+HsyGizf
         MrMMIAbe0d4SZhTIaQ9W4WsvET4ZWBQevj8ib5gZJbA4OZV6O5oHSL7Gb+KNGINVtHcY
         OQDqXrSB1xBkuCMCkTj4BW87ZeLpazRD/6qFbuYcuSIzLvdke2rMmvWZJ1YaNQ4tP6YS
         LU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xa/JIc+XiGXpm5Gi1iHsvZxDgn8MNFaOrmXkkSzsQhU=;
        b=lvqCosd3s19h5TaNKQ+mmjr1jicY1yDthE8Bk67hQ1LUfv3kcZ8ZcE42z5Omo2TRpk
         bBK+J1BMckDYz9+L3M49bwF17h17enVOmK4V8AdG6gk+Q3OOAzewiGydIQfTnaFEkq8Z
         yw93hu8wxr7qP9EIIuyyCc7c5VZYPXdK2XDaAF0SU6ZsjVKCoWgn0iHg+F5KU9ggvvzC
         sZiDUpbsYCEWCkdSfWFPlam6x7x1NzQ3RPjYQ4fXkDv9miTAnOJzqlmMHbqcALxsoAsU
         1Z+5dLuh3AqmxPdWtAnpyN8KIXtC0tW4BxvFXIiKo6f4UnPnoQYtLa24sRjahUZ22I5/
         RXMw==
X-Gm-Message-State: APjAAAWTxx08YDP3h9lpXgXdK+KyeSZtFs73J5xqn4jpHvLk8g5vWhCA
        MN1XMpSGvho8ZJ6ZNm2rbBHWQ8YDwgC1GhB2+1a4pQ==
X-Google-Smtp-Source: APXvYqwLnT96Jqh0/cv6O2LK00nrN85AzB6P4BY5Khs4jQZ53nF/9r7GJrdQ7XU76VyyHVvvZl0qdlQfCDUjrdBy0fc=
X-Received: by 2002:a67:ba12:: with SMTP id l18mr9474162vsn.29.1562950819093;
 Fri, 12 Jul 2019 10:00:19 -0700 (PDT)
MIME-Version: 1.0
References: <1558073209-79549-1-git-send-email-chenjianhong2@huawei.com>
 <CANN689G6mGLSOkyj31ympGgnqxnJosPVc4EakW5gYGtA_45L7g@mail.gmail.com>
 <df001b6fbe2a4bdc86999c78933dab7f@huawei.com> <20190711182002.9bb943006da6b61ab66b95fd@linux-foundation.org>
 <71c4329e246344eeb38c8ac25c63c09d@huawei.com>
In-Reply-To: <71c4329e246344eeb38c8ac25c63c09d@huawei.com>
From:   Michel Lespinasse <walken@google.com>
Date:   Fri, 12 Jul 2019 10:00:06 -0700
Message-ID: <CANN689H1wtbKOqhpTSuxvTDcsU00y1xXd8wRVFvbG_2p3WvoqQ@mail.gmail.com>
Subject: Re: [PATCH] mm/mmap: fix the adjusted length error
To:     "chenjianhong (A)" <chenjianhong2@huawei.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "mhocko@suse.com" <mhocko@suse.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        "jannh@google.com" <jannh@google.com>,
        "steve.capper@arm.com" <steve.capper@arm.com>,
        "tiny.windzz@gmail.com" <tiny.windzz@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "wangle (H)" <wangle6@huawei.com>,
        "Chengang (L)" <cg.chen@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 12, 2019 at 3:53 AM chenjianhong (A)
<chenjianhong2@huawei.com> wrote:
> Thank you for your reply!
> > How significant is this problem in real-world use cases?  How much trou=
ble is it causing?
>    In my opinion, this problem is very rare in real-world use cases. In a=
rm64
>    or x86 environment, the virtual memory is enough. In arm32 environment=
,
>    each process has only 3G or 4G or less, but we seldom use out all of t=
he virtual memory,
>    it only happens in some special environment. They almost use out all t=
he virtual memory, and
>    in some moment, they will change their working mode so they will relea=
se and allocate
>    memory again. This current length limitation will cause this problem. =
I explain it's the memory
>    length limitation. But they can't accept the reason, it is unreasonabl=
e that we fail to allocate
>    memory even though the memory gap is enough.

Right. So to summarize, you have a customer accidentally hitting this
and asking you about it ? and I assume their workload is not public ?

> > Have you looked further into this?  Michel is concerned about the perfo=
rmance cost of the current solution.
>    The current algorithm(change before) is wonderful, and it has been use=
d for a long time, I don't
>    think it is worthy to change the whole algorithm in order to fix this =
problem. Therefore, I just
>    adjust the gap_start and gap_end value in place of the length. My chan=
ge really affects the
>    performance because I calculate the gap_start and gap_end value again =
and again. Does it affect
>    too much performance?  I have no complex environment, so I can't test =
it, but I don't think it will cause
>    too much performance loss. First, I don't change the whole algorithm. =
Second, unmapped_area and
>    unmapped_area_topdown function aren't used frequently. Maybe there are=
 some big performance problems
>    I'm not concerned about. But I think if that's not a problem, there sh=
ould be a limitation description.

The case I am worried about is if there are a lot of gaps that are
large enough for an unaligned allocation, but too small for an aligned
one.

You could create the bad case as follows:
- Allocate a huge memory block (no need to populate it, so it can
really be as large as virtual memory will allow)
- Free a bunch of 2M holes in that block, but none of them are aligned
- Try to force allocation of a 2M aligned block

With the current code, the allocation will quickly skip over the
unaligned 2M holes. It will either find a 4M gap and allocate a 2M
aligned block from it, or it will fail, but it will be quick in either
case. With the suggested change, the allocation would try each of the
unaligned 2M holes, which could take a long time, before eventually
either finding a large enough aligned gap, or failing.

I can see two ways around this:
- the code could search for a 4M gap at first, like it currently does,
and that fails it could look at all 2M gaps and see if one of them is
aligned. So, there would still be the slow case, but only if the
initial (fast) check failed. Maybe there should be a sysfs setting to
enable the second pass, which would be disabled by default at least on
64-bit systems.
- If the issue only happens when allocating huge pages, and we know
the possible huge page sizes for a process from the start, we could
maintain more information about the gaps so that we could quickly
search for a suitable aligned gaps. that is, for each subtree we would
store both the highest 4K aligned size that can be allocated, and the
highest 2M aligned size as well. That makes a more complete solution
but probably overkill as we are not hitting this frequently enough to
justify the complications.

>
> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Friday, July 12, 2019 9:20 AM
> To: chenjianhong (A) <chenjianhong2@huawei.com>
> Cc: Michel Lespinasse <walken@google.com>; Greg Kroah-Hartman <gregkh@lin=
uxfoundation.org>; mhocko@suse.com; Vlastimil Babka <vbabka@suse.cz>; Kiril=
l A. Shutemov <kirill.shutemov@linux.intel.com>; Yang Shi <yang.shi@linux.a=
libaba.com>; jannh@google.com; steve.capper@arm.com; tiny.windzz@gmail.com;=
 LKML <linux-kernel@vger.kernel.org>; linux-mm <linux-mm@kvack.org>; stable=
@vger.kernel.org; willy@infradead.org
> Subject: Re: [PATCH] mm/mmap: fix the adjusted length error
>
> On Sat, 18 May 2019 07:05:07 +0000 "chenjianhong (A)" <chenjianhong2@huaw=
ei.com> wrote:
>
> > I explain my test code and the problem in detail. This problem is
> > found in 32-bit user process, because its virtual is limited, 3G or 4G.
> >
> > First, I explain the bug I found. Function unmapped_area and
> > unmapped_area_topdowns adjust search length to account for worst case
> > alignment overhead, the code is ' length =3D info->length + info->align=
_mask; '.
> > The variable info->length is the length we allocate and the variable
> > info->align_mask accounts for the alignment, because the gap_start  or
> > info->gap_end
> > value also should be an alignment address, but we can't know the alignm=
ent offset.
> > So in the current algorithm, it uses the max alignment offset, this
> > value maybe zero or other(0x1ff000 for shmat function).
> > Is it reasonable way? The required value is longer than what I allocate=
.
> > What's more,  why for the first time I can allocate the memory
> > successfully Via shmat, but after releasing the memory via shmdt and I
> > want to attach again, it fails. This is not acceptable for many people.
> >
> > Second, I explain my test code. The code I have sent an email. The
> > following is the step. I don't think it's something unusual or
> > unreasonable, because the virtual memory space is enough, but the
> > process can allocate from it. And we can't pass explicit addresses to
> > function mmap or shmat, the address is getting from the left vma gap.
> >  1, we allocat large virtual memory;
> >  2, we allocate hugepage memory via shmat, and release one  of the
> > hugepage memory block;  3, we allocate hugepage memory by shmat again,
> > this will fail.
>
> How significant is this problem in real-world use cases?  How much troubl=
e is it causing?
>
> > Third, I want to introduce my change in the current algorithm. I don't
> > change the current algorithm. Also, I think there maybe a better way
> > to fix this error. Nowadays, I can just adjust the gap_start value.
>
> Have you looked further into this?  Michel is concerned about the perform=
ance cost of the current solution.
>


--=20
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
