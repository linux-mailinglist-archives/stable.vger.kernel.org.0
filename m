Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BDE2F3D89
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437989AbhALVhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 16:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436995AbhALUjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 15:39:19 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CDBC061795;
        Tue, 12 Jan 2021 12:38:38 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id y12so2364587pji.1;
        Tue, 12 Jan 2021 12:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Lzi27mDYmFcrs7p6VfaaQdinYQz+DZ+BY3frqF3MRnQ=;
        b=qqCT8YTF8xP5wb4YAL7sm2TWdT8kLObSBGDnFYSR4cs3hyzUa2R1Iqp3Mca7fsupGe
         3fmu7KnMs2XqPX5p/3+w6UGkwnwHEC2VE2MJhcX3Mw6HXySLH4QJUU6KA1Zvu4iKMSKf
         dW6amBlWvrmiveAx7ro3E9Us5ZYYtcgsvgbtaX9gjbqbByupf4qOQ6dhDtGMPBDTZ2ll
         3hc8exh2DytLWgYeGIwoPm0SXJ1nUO9bsXYR38/nxOT1ApBCKErSvlCe1hpIRtCq+Ovk
         wPkw3cpgJ5DhXf37yE0WAOP4oabEOjFGexZxs4BkWrx6S4Q6XtfHAKMeJZLzQiABxY1y
         6YWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Lzi27mDYmFcrs7p6VfaaQdinYQz+DZ+BY3frqF3MRnQ=;
        b=VMLpXbJWxRjYX6BpD7r/9EBx71euvgIVUCit2RhIb2Ci+/QtcREReK931CD6e9ZBuj
         k0CWlx+yTtyVZVOkv/HaG00DgHSxC7kUggm/s+hvq66qpNw3AwFtfHpKEjiwtt2i3lwf
         FZr0WcU6SfOZ8Ck901aobBqryyVWei0aiwkg37k4qy9EETRXpaqOgvAX0SuzADmRAh1z
         VJ3yuNyRtftwgd618f79t/Wc0oUewrYlmwWheYORQRYsB9HRkKJmfdaw+R+ObE4aD4l4
         Yl/KgKRlriO7fnv2Z5zobwcJMq10bvOoJ+vBfhO97xJRoIYzvJkVFlgdsaH/61QrHD0T
         RxiA==
X-Gm-Message-State: AOAM530JmcU6SiNO1ljmxcwvbu9T1BJBjfvJ4trkDnOlSr4Lr+r+Jsm9
        OuFdvroTWy/JePocDRgqJ+Q=
X-Google-Smtp-Source: ABdhPJx7vZU1MtqqAvD4/kxPnCG0+n6cnGs77bm/ecc82WnkafuesHic/ggsTLl4cKvraCn2qUiQGA==
X-Received: by 2002:a17:90a:5509:: with SMTP id b9mr956711pji.53.1610483917949;
        Tue, 12 Jan 2021 12:38:37 -0800 (PST)
Received: from [192.168.88.245] (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id h11sm4314040pjg.46.2021.01.12.12.38.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jan 2021 12:38:36 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X/3+6ZnRCNOwhjGT@google.com>
Date:   Tue, 12 Jan 2021 12:38:34 -0800
Cc:     Laurent Dufour <ldufour@linux.vnet.ibm.com>,
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
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>, surenb@google.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <2C7AE23B-ACA3-4D55-A907-AF781C5608F0@gmail.com>
References: <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <CAHk-=wj=CcOHQpG0cUGfoMCt2=Uaifpqq-p-mMOmW8XmrBn4fQ@mail.gmail.com>
 <20210105153727.GK3040@hirez.programming.kicks-ass.net>
 <bfb1cbe6-a705-469d-c95a-776624817e33@codeaurora.org>
 <0201238b-e716-2a3c-e9ea-d5294ff77525@linux.vnet.ibm.com>
 <X/3VE64nr91WCtuM@hirez.programming.kicks-ass.net>
 <ec912505-ed4d-a45d-2ed4-7586919da4de@linux.vnet.ibm.com>
 <C7D5A74C-25BF-458A-AAD9-61E484B9F225@gmail.com>
 <X/3+6ZnRCNOwhjGT@google.com>
To:     Yu Zhao <yuzhao@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Jan 12, 2021, at 11:56 AM, Yu Zhao <yuzhao@google.com> wrote:
>=20
> On Tue, Jan 12, 2021 at 11:15:43AM -0800, Nadav Amit wrote:
>>> On Jan 12, 2021, at 11:02 AM, Laurent Dufour =
<ldufour@linux.vnet.ibm.com> wrote:
>>>=20
>>> Le 12/01/2021 =C3=A0 17:57, Peter Zijlstra a =C3=A9crit :
>>>> On Tue, Jan 12, 2021 at 04:47:17PM +0100, Laurent Dufour wrote:
>>>>> Le 12/01/2021 =C3=A0 12:43, Vinayak Menon a =C3=A9crit :
>>>>>> Possibility of race against other PTE modifiers
>>>>>>=20
>>>>>> 1) Fork - We have seen a case of SPF racing with fork marking =
PTEs RO and that
>>>>>> is described and fixed here =
https://lore.kernel.org/patchwork/patch/1062672/
>>>> Right, that's exactly the kind of thing I was worried about.
>>>>>> 2) mprotect - change_protection in mprotect which does the =
deferred flush is
>>>>>> marked under vm_write_begin/vm_write_end, thus SPF bails out on =
faults
>>>>>> on those VMAs.
>>>> Sure, mprotect also changes vm_flags, so it really needs that =
anyway.
>>>>>> 3) userfaultfd - mwriteprotect_range is not protected unlike in =
(2) above.
>>>>>> But SPF does not take UFFD faults.
>>>>>> 4) hugetlb - hugetlb_change_protection - called from mprotect and =
covered by
>>>>>> (2) above.
>>>>>> 5) Concurrent faults - SPF does not handle all faults. Only anon =
page faults.
>>>> What happened to shared/file-backed stuff? ISTR I had that working.
>>>=20
>>> File-backed mappings are not processed in a speculative way, there =
were options to manage some of them depending on the underlying file =
system but that's still not done.
>>>=20
>>> Shared anonymous mapping, are also not yet handled in a speculative =
way (vm_ops is not null).
>>>=20
>>>>>> Of which do_anonymous_page and do_swap_page are =
NONE/NON-PRESENT->PRESENT
>>>>>> transitions without tlb flush. And I hope do_wp_page with RO->RW =
is fine as well.
>>>> The tricky one is demotion, specifically write to non-write.
>>>>>> I could not see a case where speculative path cannot see a PTE =
update done via
>>>>>> a fault on another CPU.
>>>> One you didn't mention is the NUMA balancing scanning crud; =
although I
>>>> think that's fine, loosing a PTE update there is harmless. But I've =
not
>>>> thought overly hard on it.
>>>=20
>>> That's a good point, I need to double check on that side.
>>>=20
>>>>> You explained it fine. Indeed SPF is handling deferred TLB =
invalidation by
>>>>> marking the VMA through vm_write_begin/end(), as for the fork case =
you
>>>>> mentioned. Once the PTL is held, and the VMA's seqcount is =
checked, the PTE
>>>>> values read are valid.
>>>> That should indeed work, but are we really sure we covered them =
all?
>>>> Should we invest in better TLBI APIs to make sure we can't get this
>>>> wrong?
>>>=20
>>> That may be a good option to identify deferred TLB invalidation but =
I've no clue on what this API would look like.
>>=20
>> I will send an RFC soon for per-table deferred TLB flushes tracking.
>> The basic idea is to save a generation in the page-struct that tracks
>> when deferred PTE change took place, and track whenever a TLB flush
>> completed. In addition, other users - such as mprotect - would use
>> the tlb_gather interface.
>>=20
>> Unfortunately, due to limited space in page-struct this would only
>> be possible for 64-bit (and my implementation is only for x86-64).
>=20
> I don't want to discourage you but I don't think this would end up
> well. PPC doesn't necessarily follow one-page-struct-per-table rule,
> and I've run into problems with this before while trying to do
> something similar.

Discourage, discourage. Better now than later.

It will be relatively easy to extend the scheme to be per-VMA instead of
per-table for architectures that prefer it this way. It does require
TLB-generation tracking though, which Andy only implemented for x86, so =
I
will focus on x86-64 right now.

[ For per-VMA it would require an additional cmpxchg, I presume to save =
the
last deferred generation though. ]

> I'd recommend per-vma and per-category (unmapping, clearing writable
> and clearing dirty) tracking, which only rely on arch-independent data
> structures, i.e., vm_area_struct and mm_struct.

I think that tracking changes on =E2=80=9Cwhat was changed=E2=80=9D =
granularity is harder
and more fragile.

Let me finish trying the clean up the mess first, since fullmm and
need_flush_all semantics were mixed; there are 3 different flushing =
schemes
for mprotect(), munmap() and try_to_unmap(); there are missing memory
barriers; mprotect() performs TLB flushes even when permissions are
promoted; etc.

There are also some optimizations that we discussed before, such on x86 =
-=20
RW->RO does not require a TLB flush if a PTE is not dirty, etc.

I am trying to finish something so you can say how terrible it is, so I =
will
not waste too much time. ;-)

>> It would still require to do the copying while holding the PTL =
though.
>=20
> IMO, this is unacceptable. Most archs don't support per-table PTL, and
> even x86_64 can be configured to use per-mm PTL. What if we want to
> support a larger page size in the feature?
>=20
> It seems to me the only way to solve the problem with self-explanatory
> code and without performance impact is to check mm_tlb_flush_pending
> and the writable bit (and two other cases I mentioned above) at the
> same time. Of course, this requires a lot of effort to audit the
> existing uses, clean them up and properly wrap them up with new
> primitives, BUG_ON all invalid cases and document the exact workflow
> to prevent misuses.
>=20
> I've mentioned the following before -- it only demonstrates the rough
> idea.
>=20
> diff --git a/mm/memory.c b/mm/memory.c
> index 5e9ca612d7d7..af38c5ee327e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4403,8 +4403,11 @@ static vm_fault_t handle_pte_fault(struct =
vm_fault *vmf)
> 		goto unlock;
> 	}
> 	if (vmf->flags & FAULT_FLAG_WRITE) {
> -		if (!pte_write(entry))
> +		if (!pte_write(entry)) {
> +			if (mm_tlb_flush_pending(vmf->vma->vm_mm))
> +				flush_tlb_page(vmf->vma, vmf->address);
> 			return do_wp_page(vmf);
> +		}
> 		entry =3D pte_mkdirty(entry);
> 	}
> 	entry =3D pte_mkyoung(entry);

I understand. This might be required, regardless of the deferred flushes
detection scheme. If we assume that no write-unprotect requires a COW =
(which
should be true in this case, since we take a reference on the page), =
your
proposal should be sufficient.

Still, I think that there are many unnecessary TLB flushes right now,
and others that might be missed due to the overly complicated =
invalidation
schemes.=20

Regardless, as Andrea pointed, this requires first to figure out the
semantics of mprotect() and friends when pages are pinned.

