Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6C112F91AC
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 11:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbhAQKPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 05:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbhAQKO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 05:14:27 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6CFC061574;
        Sun, 17 Jan 2021 02:13:47 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id my11so7165669pjb.1;
        Sun, 17 Jan 2021 02:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=kM4/ftF+Rvmt4g0dAJ4kjwNYOlnjlcoIsKfNkTddmQk=;
        b=bMqkTFfYgBUu23b/obK/hcsIdemE0N/RHZsH6r9PgitEWqtyeNXC6ztJ8doxYPX5qg
         8DYvrEz5p/i0QGvWe9c/PFj2BWqhmkw4h7KuGSYVuk5B/8NYDbV2yYLIZr4HZ1wweimC
         srDGicAKLbVLw5gjMTFS8YojadJnz28haN4oI4mJNhAorumjRlcbrZmS3pIv+m4CkS0Q
         t7mEjEkrpwYbGwwNRaKoR9QTOonDsf+K5yJlVSpG6t/hvCcP+t4M9O4kzgTuU7Qxq4Z8
         jPQ82m8JKBUC4/F/2ygenzMwe+EuiG426Pw7D2XNy84g/qSr0clRBpuDbmJ/+WCe1/kj
         lJ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=kM4/ftF+Rvmt4g0dAJ4kjwNYOlnjlcoIsKfNkTddmQk=;
        b=hiQwor7BwpfWxwzolPFI0Z5Zb0ShIUIZ+xQ2mXCjeLUNDcyGGkW87zPl66d6qopOkH
         G5Z618hSjfNkTvrW577lwsMlWMrF7eSXZucmxVuNxMyNz/9/4OUzAI8kCqWwwK3o4Ly5
         iRof/uvyvb+TnPBCpX9s331S8B2sanv5uAn1xO0Fq1mvWfvIrBHkUp4+Jclpt8cQKPRU
         8n0+9TiqIAoZbjvsOmk/qZ2DBZE+ICq9eyRMqU2l+30HgRG9HeCMiVlcoFscEQIRsVhA
         BH2x+rKyegrGayWrbBOlrii1VmcxK4NUEZxnI/ztd2yGU3ywtEqnTId58nBRGuqSwtGQ
         k8zw==
X-Gm-Message-State: AOAM530SKP0mmFYU5fa49nXZUD6x5HCDq4/zi3wh4hx6OKjgkwZmjPYh
        4/2Rr1TSaO6Lqb7iV2CxTzg=
X-Google-Smtp-Source: ABdhPJwl9rbDMIoHEUAdQfZEZdwm6jOJv80g2EQCS92pb7H79MA8Rba032kdcMOagIAocy9TAa/zxA==
X-Received: by 2002:a17:90b:4b86:: with SMTP id lr6mr20046721pjb.107.1610878426380;
        Sun, 17 Jan 2021 02:13:46 -0800 (PST)
Received: from [192.168.88.245] (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id h11sm12434640pjg.46.2021.01.17.02.13.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Jan 2021 02:13:45 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <YAQAhyOFqEdjTRPJ@google.com>
Date:   Sun, 17 Jan 2021 02:13:43 -0800
Cc:     Will Deacon <will@kernel.org>,
        Laurent Dufour <ldufour@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Vinayak Menon <vinmenon@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, surenb@google.com,
        Mel Gorman <mgorman@suse.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <1A664155-462A-451D-A21E-D749A0ADBD09@gmail.com>
References: <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
 <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
 <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
 <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
 <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
 <X/3+6ZnRCNOwhjGT@google.com>
 <2C7AE23B-ACA3-4D55-A907-AF781C5608F0@gmail.com>
 <20210112214337.GA10434@willie-the-truck> <YAO/9YVceghRYo4T@google.com>
 <85DAADF4-2537-40BD-8580-A57C201FF5F3@gmail.com>
 <YAQAhyOFqEdjTRPJ@google.com>
To:     Yu Zhao <yuzhao@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Jan 17, 2021, at 1:16 AM, Yu Zhao <yuzhao@google.com> wrote:
>=20
> On Sat, Jan 16, 2021 at 11:32:22PM -0800, Nadav Amit wrote:
>>> On Jan 16, 2021, at 8:41 PM, Yu Zhao <yuzhao@google.com> wrote:
>>>=20
>>> On Tue, Jan 12, 2021 at 09:43:38PM +0000, Will Deacon wrote:
>>>> On Tue, Jan 12, 2021 at 12:38:34PM -0800, Nadav Amit wrote:
>>>>>> On Jan 12, 2021, at 11:56 AM, Yu Zhao <yuzhao@google.com> wrote:
>>>>>> On Tue, Jan 12, 2021 at 11:15:43AM -0800, Nadav Amit wrote:
>>>>>>> I will send an RFC soon for per-table deferred TLB flushes =
tracking.
>>>>>>> The basic idea is to save a generation in the page-struct that =
tracks
>>>>>>> when deferred PTE change took place, and track whenever a TLB =
flush
>>>>>>> completed. In addition, other users - such as mprotect - would =
use
>>>>>>> the tlb_gather interface.
>>>>>>>=20
>>>>>>> Unfortunately, due to limited space in page-struct this would =
only
>>>>>>> be possible for 64-bit (and my implementation is only for =
x86-64).
>>>>>>=20
>>>>>> I don't want to discourage you but I don't think this would end =
up
>>>>>> well. PPC doesn't necessarily follow one-page-struct-per-table =
rule,
>>>>>> and I've run into problems with this before while trying to do
>>>>>> something similar.
>>>>>=20
>>>>> Discourage, discourage. Better now than later.
>>>>>=20
>>>>> It will be relatively easy to extend the scheme to be per-VMA =
instead of
>>>>> per-table for architectures that prefer it this way. It does =
require
>>>>> TLB-generation tracking though, which Andy only implemented for =
x86, so I
>>>>> will focus on x86-64 right now.
>>>>=20
>>>> Can you remind me of what we're missing on arm64 in this area, =
please? I'm
>>>> happy to help get this up and running once you have something I can =
build
>>>> on.
>>>=20
>>> I noticed arm/arm64 don't support ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH.
>>> Would it be something worth pursuing? Arm has been using mm_cpumask,
>>> so it might not be too difficult I guess?
>>=20
>> [ +Mel Gorman who implemented ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH ]
>>=20
>> IIUC, there are at least two bugs in x86 implementation.
>>=20
>> First, there is a missing memory barrier in tlbbatch_add_mm() between
>> inc_mm_tlb_gen() and the read of mm_cpumask().
>=20
> In arch_tlbbatch_add_mm()? inc_mm_tlb_gen() has builtin barrier as its
> comment says -- atomic update ops that return values are also full
> memory barriers.

Yes, you are correct.

>=20
>> Second, try_to_unmap_flush() clears flush_required after flushing. =
Another
>> thread can call set_tlb_ubc_flush_pending() after the flush and =
before
>> flush_required is cleared, and the indication that a TLB flush is =
pending
>> can be lost.
>=20
> This isn't a problem either because flush_required is per thread.

Sorry, I meant mm->tlb_flush_batched . It is not per-thread.
flush_tlb_batched_pending() clears it after flush and indications that
set_tlb_ubc_flush_pending() sets in between can be lost.

>> I am working on addressing these issues among others, but, as you =
already
>> saw, I am a bit slow.
>>=20
>> On a different but related topic: Another thing that I noticed that =
Arm does
>> not do is batching TLB flushes across VMAs. Since Arm does not have =
its own
>> tlb_end_vma(), it uses the default tlb_end_vma(), which flushes each =
VMA
>> separately. Peter Zijlstra=E2=80=99s comment says that there are =
advantages in
>> flushing each VMA separately, but I am not sure it is better or =
intentional
>> (especially since x86 does not do so).
>>=20
>> I am trying to remove the arch-specific tlb_end_vma() and have a =
config
>> option to control this behavior.
>=20
> One thing worth noting is not all arm/arm64 hw versions support =
ranges.
> (system_supports_tlb_range()). But IIUC what you are trying to do, =
this
> isn't a problem.

I just wanted to get rid of arch-specific tlb_start_vma() it in order to
cleanup the code (I am doing first the VMA-deferred tracking, as you =
asked).
While I was doing that, I noticed that Arm does per-VMA TLB flushes. I =
do
not know whether it is intentional, but it seems rather easy to get this
behavior unintentionally.=
