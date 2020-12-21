Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5A82DF842
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 05:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgLUEdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Dec 2020 23:33:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgLUEdE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Dec 2020 23:33:04 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B36DC0613D3;
        Sun, 20 Dec 2020 20:32:24 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id et9so3925613qvb.10;
        Sun, 20 Dec 2020 20:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RGHUG3YS9PlJTlCOsXIUaVWRNdpgvr2K2PPmz+gxhDY=;
        b=XEmACCz/oBW8KpdmFP65y2OmfKersoYJGYoS1JM6sPEmGnRoCz4pfVKQoOIYr5lrk+
         iq02YDaAT+f4A6P1moYcyl2LXknuPsaYb480dNRK/YN6ZC5mnU7gkao+G1z00dUqO2+m
         MNwZXf3+7myWlnIN2tndHM3SlE6pNG5Uued4fvxQ6eZnme4wydgN0tyAxO5GpNi4e39y
         iCGo1K2dhnw2omUsh+rbiD9UbxRaiUIvuoiZl5xIS/Oqr+r44dGRAAssAS/huehr40ca
         vjbDKHkuJsUhfHenof7ljlJCkl8vXS6dfhHA4YNvuWlMuK+lBX/MpLf/BlQPHzBuxwRM
         WIJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RGHUG3YS9PlJTlCOsXIUaVWRNdpgvr2K2PPmz+gxhDY=;
        b=Y67tDx3iSbK6SvB/LuZ/q2gJtPqd1L3uVgs4GX5h9XfG1rt/mKI2Azk6lj4zkd3rwJ
         kVDw2av3RRJTwIasncPaktqWxR5s+fjrvQG6FIGKUdPiP4ElNAYmUvgueRt4y2DClGJG
         dmyICn977bpUmrWP4vm0Y+COeeYs55mE+mstJVpi1NHjB4eCDU1ZllWutRPV4MMIq8jB
         g2x4wjya+zNc8Ifrgs9aL+2oyh/SyeUj3eF835ao4jQ9fFDLApkK3O5yg1cislzvTkRt
         lOxRGKEl6pOp/zfsSRcQ4h/7A2YLR0G/OG4q9n+6OVZ16fjOGbNRn9k63uKYl2J/N84A
         rwvA==
X-Gm-Message-State: AOAM530QlASdP0IF9BKikuu/2EXJ+VAjNjx0rHm1MvZjqYPs/zY0m4oE
        5v7bMTYaPzmuHMw5Xu810NzCC/824e1LaQ==
X-Google-Smtp-Source: ABdhPJy2vx8dxbMeNtjO8DuPkEpXCO2mR8iu5ujBlJatrx8oO4h8ea5O0c7MzCAJxH0Ztkx1Q3WtKA==
X-Received: by 2002:a17:902:b90c:b029:db:f23d:d684 with SMTP id bf12-20020a170902b90cb02900dbf23dd684mr14617589plb.43.1608521592635;
        Sun, 20 Dec 2020 19:33:12 -0800 (PST)
Received: from [10.0.1.14] (c-24-4-128-201.hsd1.ca.comcast.net. [24.4.128.201])
        by smtp.gmail.com with ESMTPSA id jx4sm13608056pjb.24.2020.12.20.19.33.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Dec 2020 19:33:11 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X98fZOiLNmnDQKhN@google.com>
Date:   Sun, 20 Dec 2020 19:33:09 -0800
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, minchan@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3680387D-65F1-4078-A19D-F77DE8544B96@gmail.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
 <X97pprdcRXusLGnq@google.com>
 <DDA15360-D6D4-46A8-95A4-5EE34107A407@gmail.com>
 <X98fZOiLNmnDQKhN@google.com>
To:     Yu Zhao <yuzhao@google.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Dec 20, 2020, at 1:54 AM, Yu Zhao <yuzhao@google.com> wrote:
>=20
> On Sun, Dec 20, 2020 at 12:06:38AM -0800, Nadav Amit wrote:
>>> On Dec 19, 2020, at 10:05 PM, Yu Zhao <yuzhao@google.com> wrote:
>>>=20
>>> On Sat, Dec 19, 2020 at 01:34:29PM -0800, Nadav Amit wrote:
>>>> [ cc=E2=80=99ing some more people who have experience with similar =
problems ]
>>>>=20
>>>>> On Dec 19, 2020, at 11:15 AM, Andrea Arcangeli =
<aarcange@redhat.com> wrote:
>>>>>=20
>>>>> Hello,
>>>>>=20
>>>>> On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
>>>>>> Analyzing this problem indicates that there is a real bug since
>>>>>> mmap_lock is only taken for read in mwriteprotect_range(). This =
might
>>>>>=20
>>>>> Never having to take the mmap_sem for writing, and in turn never
>>>>> blocking, in order to modify the pagetables is quite an important
>>>>> feature in uffd that justifies uffd instead of mprotect. It's not =
the
>>>>> most important reason to use uffd, but it'd be nice if that =
guarantee
>>>>> would remain also for the UFFDIO_WRITEPROTECT API, not only for =
the
>>>>> other pgtable manipulations.
>>>>>=20
>>>>>> Consider the following scenario with 3 CPUs (cpu2 is not shown):
>>>>>>=20
>>>>>> cpu0				cpu1
>>>>>> ----				----
>>>>>> userfaultfd_writeprotect()
>>>>>> [ write-protecting ]
>>>>>> mwriteprotect_range()
>>>>>> mmap_read_lock()
>>>>>> change_protection()
>>>>>> change_protection_range()
>>>>>> ...
>>>>>> change_pte_range()
>>>>>> [ defer TLB flushes]
>>>>>> 				userfaultfd_writeprotect()
>>>>>> 				 mmap_read_lock()
>>>>>> 				 change_protection()
>>>>>> 				 [ write-unprotect ]
>>>>>> 				 ...
>>>>>> 				  [ unprotect PTE logically ]
>>>>>> 				...
>>>>>> 				[ page-fault]
>>>>>> 				...
>>>>>> 				wp_page_copy()
>>>>>> 				[ set new writable page in PTE]
>>>=20
>>> I don't see any problem in this example -- wp_page_copy() calls
>>> ptep_clear_flush_notify(), which should take care of the stale entry
>>> left by cpu0.
>>>=20
>>> That being said, I suspect the memory corruption you observed is
>>> related this example, with cpu1 running something else that flushes
>>> conditionally depending on pte_write().
>>>=20
>>> Do you know which type of pages were corrupted? file, anon, etc.
>>=20
>> First, Yu, you are correct. My analysis is incorrect, but let me have
>> another try (below). To answer your (and Andrea=E2=80=99s) question - =
this happens
>> with upstream without any changes, excluding a small fix to the =
selftest,
>> since it failed (got stuck) due to missing wake events. [1]
>>=20
>> We are talking about anon memory.
>>=20
>> So to correct myself, I think that what I really encountered was =
actually
>> during MM_CP_UFFD_WP_RESOLVE (i.e., when the protection is removed). =
The
>> problem was that in this case the =E2=80=9Cwrite=E2=80=9D-bit was =
removed during unprotect.
>=20
> Thanks. You are right about when the problem happens: UFD write-
> UNprotecting. But it's not UFD write-UNprotecting that removes the
> writable bit -- the bit can only be removed during COW or UFD
> write-protecting. So your original example was almost correct, except
> the last line describing cpu1.

The scenario is a bit confusing, so stay with me. The idea behind uffd
unprotect is indeed only to mark the PTE logically as uffd-unprotected, =
and
not to *set* the writable bit, allowing the #PF handler to do COW or
whatever correctly upon #PF.

However, the problem that we have is that if a page is already writable,
write-unprotect *clears* the writable bit, making it write-protected (at
least for anonymous pages). This is not good from performance =
point-of-view,
but also a correctness issue, as I pointed out.

In some more detail: mwriteprotect_range() uses vm_get_page_prot() to
compute the new protection. For anonymous private memory, at least on =
x86,
this means the write-bit in the protection is clear. So later,
change_pte_range() *clears* the write-bit during *unprotection*.

That=E2=80=99s the reason the second part of my patch - the change to =
preserve_write
- fixes the problem.

> The problem is how do_wp_page() handles non-COW pages. (For COW pages,
> do_wp_page() works correctly by either reusing an existing page or
> make a new copy out of it.) In UFD case, the existing page may not
> have been properly write-protected. As you pointed out, the tlb flush
> may not be done yet. Making a copy can potentially race with the
> writer on cpu2.

Just to clarify the difference - You regard a scenario of UFFD
write-protect, while I am pretty sure the problem I encountered is =
during
write-unprotect.

I am not sure we are on the same page (but we may be). The problem I =
have is
with cow_user_page() that is called by do_wp_page() before any TLB flush
took place (either by change_protection_range() or by do_wp_page() which
does flush, but after the copy).

Let me know if you regard a different scenario.

> Should we fix the problem by ensuring integrity of the copy? IMO, no,
> because do_wp_page() shouldn't copy at all in this case. It seems it
> was recently broken by
>=20
>  be068f29034f mm: fix misplaced unlock_page in do_wp_page()
>  09854ba94c6a mm: do_wp_page() simplification
>=20
> I haven't study them carefully. But if you could just revert them and
> run the test again, we'd know where exactly to look at next.

These patches regard the wp_page_reuse() case, which makes me think we
are not on the same page. I do not see a problem with wp_page_reuse()
since it does not make a copy of the page. If you can explain what I
am missing, it would be great.

