Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B43F2DF1D1
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 22:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727689AbgLSVfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 16:35:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbgLSVfU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 16:35:20 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F50CC0613CF;
        Sat, 19 Dec 2020 13:34:32 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id g18so3655642pgk.1;
        Sat, 19 Dec 2020 13:34:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=GR/9hOO/0RtdTbEih619Bg4o+4UPA19MgIbfVnUs0Mk=;
        b=mM3SUmiME4fn4JhGrTlFqC6IKbra/T8VERe0GEmueXMz7FsbAihr+8AYYXUz/fIRLM
         TisyCwuOThJqC3eV3M/gN+6tK3RYklfCQ6/vHv+9rk4aHrRkalYLHMlEUoCV5Hx/W9SL
         1NoyB9ONStZg1kj+ZI6vSBAafpmTT9DK8WpJM5FJWpiXMdmHPp3njFYE73UxdoNFyriA
         UZejynBNIeP3LDZXDekQ+rOK36aWyNVpzlbTt95Raz85yXcYMqU7JnQ8WkFsACHHV+95
         xkdbXfzuU032PD/0czlwr0Q91C1U0gavebk6p/w4s2rbJYSTQRwZzwBJeBwrXtoafTI9
         KWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=GR/9hOO/0RtdTbEih619Bg4o+4UPA19MgIbfVnUs0Mk=;
        b=Ipi7urrGkezirzOJNOWjY16PkprkbC7Po3mIn9Bs6bsyJT+lxTJ86V7P3iG7ZcAMxD
         lL7maE9IrJwvNFjDUR6J4D3DIywfolyFC6sOb46c35z75Sq3v1wDlSFi3YIJPMULGUr/
         H6jaRG8nlOaeK3IRpig6J0xEn1PSiu64c/xU5LCueyoFNKcEgD0X61pitY9YBFDLriHU
         iBusqUjddnAukYIWQyaz0+2NRuK+mFbyWZeJ7qKiuPUvmRmgsGpC4BeKy1c1edIkht7i
         anNMuesvzFL4u0uh33jHf6awTxD7Oo8fXDFydZIxIhHwAFjkVK7UnG22kfDBGuAR2qN3
         /cmw==
X-Gm-Message-State: AOAM533otv6GWI6eUxoBT26jp9iNxN6/w75E4eXdjFoYL7AUrV9IVLB1
        D1rQfM5cKAfK0ygwKUaOyqGG8E+IqzIoXA==
X-Google-Smtp-Source: ABdhPJznVOtGmo9knSrzX+2u3iwKNNv7PxvDNTT+65ljhJPaTx8P6JkuJc/KJierCvA+XyUEra7BvQ==
X-Received: by 2002:a63:9dc1:: with SMTP id i184mr2871810pgd.409.1608413672018;
        Sat, 19 Dec 2020 13:34:32 -0800 (PST)
Received: from ?IPv6:2601:647:4700:9b2:c998:6c11:32cc:4648? ([2601:647:4700:9b2:c998:6c11:32cc:4648])
        by smtp.gmail.com with ESMTPSA id il14sm10670827pjb.51.2020.12.19.13.34.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Dec 2020 13:34:31 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <X95RRZ3hkebEmmaj@redhat.com>
Date:   Sat, 19 Dec 2020 13:34:29 -0800
Cc:     linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable@vger.kernel.org, minchan@kernel.org,
        Andy Lutomirski <luto@kernel.org>, yuzhao@google.com,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
References: <20201219043006.2206347-1-namit@vmware.com>
 <X95RRZ3hkebEmmaj@redhat.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ cc=E2=80=99ing some more people who have experience with similar =
problems ]

> On Dec 19, 2020, at 11:15 AM, Andrea Arcangeli <aarcange@redhat.com> =
wrote:
>=20
> Hello,
>=20
> On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
>> Analyzing this problem indicates that there is a real bug since
>> mmap_lock is only taken for read in mwriteprotect_range(). This might
>=20
> Never having to take the mmap_sem for writing, and in turn never
> blocking, in order to modify the pagetables is quite an important
> feature in uffd that justifies uffd instead of mprotect. It's not the
> most important reason to use uffd, but it'd be nice if that guarantee
> would remain also for the UFFDIO_WRITEPROTECT API, not only for the
> other pgtable manipulations.
>=20
>> Consider the following scenario with 3 CPUs (cpu2 is not shown):
>>=20
>> cpu0				cpu1
>> ----				----
>> userfaultfd_writeprotect()
>> [ write-protecting ]
>> mwriteprotect_range()
>> mmap_read_lock()
>> change_protection()
>>  change_protection_range()
>>   ...
>>   change_pte_range()
>>   [ defer TLB flushes]
>> 				userfaultfd_writeprotect()
>> 				 mmap_read_lock()
>> 				 change_protection()
>> 				 [ write-unprotect ]
>> 				 ...
>> 				  [ unprotect PTE logically ]
>> 				...
>> 				[ page-fault]
>> 				...
>> 				wp_page_copy()
>> 				[ set new writable page in PTE]
>=20
> Can't we check mm_tlb_flush_pending(vma->vm_mm) if MM_CP_UFFD_WP_ALL
> is set and do an explicit (potentially spurious) tlb flush before
> write-unprotect?

There is a concrete scenario that I actually encountered and then there =
is a
general problem.

In general, the kernel code assumes that PTEs that are read from the
page-tables are coherent across all the TLBs, excluding permission =
promotion
(i.e., the PTE may have higher permissions in the page-tables than those
that are cached in the TLBs).

We therefore need to both: (a) protect change_protection_range() from =
the
changes of others who might defer TLB flushes without taking mmap_sem =
for
write (e.g., try_to_unmap_one()); and (b) to protect others (e.g.,
page-fault handlers) from concurrent changes of change_protection().

We have already encountered several similar bugs, and debugging such =
issues
s time consuming and these bugs impact is substantial (memory =
corruption,
security). So I think we should only stick to general solutions.

So perhaps your the approach of your proposed solution is feasible, but =
it
would have to be applied all over the place: we will need to add a check =
for
mm_tlb_flush_pending() and conditionally flush the TLB in every case in
which PTEs are read and there might be an assumption that the
access-permission reflect what the TLBs hold. This includes page-fault
handlers, but also NUMA migration code in change_protection(), softdirty
cleanup in clear_refs_write() and maybe others.

[ I have in mind another solution, such as keeping in each page-table a=20=

=E2=80=9Ctable-generation=E2=80=9D which is the mm-generation at the =
time of the change,
and only flush if =E2=80=9Ctable-generation=E2=80=9D=3D=3D=E2=80=9Cmm-gene=
ration=E2=80=9D, but it requires
some thought on how to avoid adding new memory barriers. ]

IOW: I think the change that you suggest is insufficient, and a proper
solution is too intrusive for =E2=80=9Cstable".

As for performance, I can add another patch later to remove the TLB =
flush
that is unnecessarily performed during change_protection_range() that =
does
permission promotion. I know that your concern is about the =
=E2=80=9Cprotect=E2=80=9D case
but I cannot think of a good immediate solution that avoids taking =
mmap_lock
for write.

Thoughts?

