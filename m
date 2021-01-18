Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6402F97F4
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 03:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbhARCus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 21:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730270AbhARCuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 21:50:40 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3313C061573;
        Sun, 17 Jan 2021 18:49:57 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id be12so7848852plb.4;
        Sun, 17 Jan 2021 18:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=oyXzGEzTVn5EWmDkOEirveY6pyyWOy/cjy9jZHLDBhA=;
        b=KifJQoJMSkkF7WXcAEylNnC9/t4DxId/faenhimlV5cXFeazVaBXk0i3oZJ6UU1egz
         pTAqV7AkQ4OpM9Ona1XSsnZwrjKtnt/IxSCoIk50vehJ0L5Eo6EqVv9d2Vl6zSa2NZF8
         FQwbmzYRMlj73hBYYa5TF/gC/XDFuGKyhJUvc+bZIvi/noVOZTc6vQYBZleeLkqdNDq1
         Wq6h91hq5f5zcsc6MquHz3Hnf4mZATQrbm+uHfiAYKg2G83UL06VBaJnPeEOJiMeVXGn
         04ch8EV1O5Ym8AtvuCnEPH76Gn9VQD9YQYtmuuyNVhTUsMBLu2FuQrYZMlg+lz19fcSm
         d43w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=oyXzGEzTVn5EWmDkOEirveY6pyyWOy/cjy9jZHLDBhA=;
        b=nNKguP8BwtfJGj8tgy3JK3d9lDEYyuaq0wq75POMRALrzs5Qw1X1s1aYiZ+YgXz6yl
         M46cHl0MM9P7clXZ9nwn1dNgipgnsaN9FE1x3lvEAY4BprdaSet8t1M6XBOGQ7tPwVyh
         nV6Q+Gw9BIQRKwRfGtBgY10UILQGXa6oabOnhD90Xx/8gWE90jeUus7VoINBd1bSQPa8
         DhL7YLb97aJ+ql+1T0HToIkteWZrDLxPHrdgPyn9EnTy6CZwp1FgTljidf3JWUQFjB9G
         Fq6C+Zk3+3Q3gfYO+qOE91w08wrIXSFi+qEGt73OwHXoM3EQmtP0NRsEN1FZGco5Q9zd
         Wqiw==
X-Gm-Message-State: AOAM532D8x1xcOny0BPhXM1vkDaspJeWLL1VOzkzp7vqaP6PIoKYZV31
        PubbRJzCNDoOG2cZubv/xzY=
X-Google-Smtp-Source: ABdhPJy/0yfCh/m/qz03tbvSbW0EkJJWVQLFeNt/sZWm409X5BfXwzgIv6MVeKj2qEn7AHbmX2Tjrg==
X-Received: by 2002:a17:902:ecca:b029:de:b5bc:c852 with SMTP id a10-20020a170902eccab02900deb5bcc852mr1610645plh.59.1610938197040;
        Sun, 17 Jan 2021 18:49:57 -0800 (PST)
Received: from [192.168.88.245] (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id 85sm6223715pfc.39.2021.01.17.18.49.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 17 Jan 2021 18:49:56 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <YASPEYs0QVI88xfM@google.com>
Date:   Sun, 17 Jan 2021 18:49:53 -0800
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
        Mel Gorman <mgorman@suse.de>, cai@lca.pw
Content-Transfer-Encoding: quoted-printable
Message-Id: <0BB9D243-F527-409D-8A9E-612DFD4EE993@gmail.com>
References: <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
 <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
 <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
 <X/3+6ZnRCNOwhjGT@google.com>
 <2C7AE23B-ACA3-4D55-A907-AF781C5608F0@gmail.com>
 <20210112214337.GA10434@willie-the-truck> <YAO/9YVceghRYo4T@google.com>
 <85DAADF4-2537-40BD-8580-A57C201FF5F3@gmail.com>
 <YAQAhyOFqEdjTRPJ@google.com>
 <1A664155-462A-451D-A21E-D749A0ADBD09@gmail.com>
 <YASPEYs0QVI88xfM@google.com>
To:     Yu Zhao <yuzhao@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Jan 17, 2021, at 11:25 AM, Yu Zhao <yuzhao@google.com> wrote:
>=20
> On Sun, Jan 17, 2021 at 02:13:43AM -0800, Nadav Amit wrote:
>>> On Jan 17, 2021, at 1:16 AM, Yu Zhao <yuzhao@google.com> wrote:
>>>=20
>>> On Sat, Jan 16, 2021 at 11:32:22PM -0800, Nadav Amit wrote:
>>>>> On Jan 16, 2021, at 8:41 PM, Yu Zhao <yuzhao@google.com> wrote:
>>>>>=20
>>>>> On Tue, Jan 12, 2021 at 09:43:38PM +0000, Will Deacon wrote:
>>>>>> On Tue, Jan 12, 2021 at 12:38:34PM -0800, Nadav Amit wrote:
>>>>>>>> On Jan 12, 2021, at 11:56 AM, Yu Zhao <yuzhao@google.com> =
wrote:
>>>>>>>> On Tue, Jan 12, 2021 at 11:15:43AM -0800, Nadav Amit wrote:
>>>>>>>>> I will send an RFC soon for per-table deferred TLB flushes =
tracking.
>>>>>>>>> The basic idea is to save a generation in the page-struct that =
tracks
>>>>>>>>> when deferred PTE change took place, and track whenever a TLB =
flush
>>>>>>>>> completed. In addition, other users - such as mprotect - would =
use
>>>>>>>>> the tlb_gather interface.
>>>>>>>>>=20
>>>>>>>>> Unfortunately, due to limited space in page-struct this would =
only
>>>>>>>>> be possible for 64-bit (and my implementation is only for =
x86-64).
>>>>>>>>=20
>>>>>>>> I don't want to discourage you but I don't think this would end =
up
>>>>>>>> well. PPC doesn't necessarily follow one-page-struct-per-table =
rule,
>>>>>>>> and I've run into problems with this before while trying to do
>>>>>>>> something similar.
>>>>>>>=20
>>>>>>> Discourage, discourage. Better now than later.
>>>>>>>=20
>>>>>>> It will be relatively easy to extend the scheme to be per-VMA =
instead of
>>>>>>> per-table for architectures that prefer it this way. It does =
require
>>>>>>> TLB-generation tracking though, which Andy only implemented for =
x86, so I
>>>>>>> will focus on x86-64 right now.
>>>>>>=20
>>>>>> Can you remind me of what we're missing on arm64 in this area, =
please? I'm
>>>>>> happy to help get this up and running once you have something I =
can build
>>>>>> on.
>>>>>=20
>>>>> I noticed arm/arm64 don't support =
ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH.
>>>>> Would it be something worth pursuing? Arm has been using =
mm_cpumask,
>>>>> so it might not be too difficult I guess?
>>>>=20
>>>> [ +Mel Gorman who implemented ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH ]
>>>>=20
>>>> IIUC, there are at least two bugs in x86 implementation.
>>>>=20
>>>> First, there is a missing memory barrier in tlbbatch_add_mm() =
between
>>>> inc_mm_tlb_gen() and the read of mm_cpumask().
>>>=20
>>> In arch_tlbbatch_add_mm()? inc_mm_tlb_gen() has builtin barrier as =
its
>>> comment says -- atomic update ops that return values are also full
>>> memory barriers.
>>=20
>> Yes, you are correct.
>>=20
>>>> Second, try_to_unmap_flush() clears flush_required after flushing. =
Another
>>>> thread can call set_tlb_ubc_flush_pending() after the flush and =
before
>>>> flush_required is cleared, and the indication that a TLB flush is =
pending
>>>> can be lost.
>>>=20
>>> This isn't a problem either because flush_required is per thread.
>>=20
>> Sorry, I meant mm->tlb_flush_batched . It is not per-thread.
>> flush_tlb_batched_pending() clears it after flush and indications =
that
>> set_tlb_ubc_flush_pending() sets in between can be lost.
>=20
> Hmm, the PTL argument above flush_tlb_batched_pending() doesn't seem
> to hold when USE_SPLIT_PTE_PTLOCKS is set. Do you have a reproducer?
> KCSAN might be able to help in this case.

I do not have a reproducer. It is just based on my understanding of this
code.

I will give a short try for building a reproducer, although for some =
reason
=E2=80=9Cyou guys=E2=80=9D complain that my reproducers do not work for =
you (is it PTI that
I disable? idle=3Dpoll? running in a VM?). It is also not likely to be =
too
easy to build a reproducer that actually triggers a memory corruption.

Anyhow, apparently KCSAN has already shouted about this code, causing =
Qian
Cai to add "data_race()" to avoid KCSAN from shouting (9c1177b62a8c
"mm/rmap: annotate a data race at tlb_flush_batched=E2=80=9D).

Note that Andrea asked me not to hijack this thread and have a different =
one
on this issue.

