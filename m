Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCD62DF2B3
	for <lists+stable@lfdr.de>; Sun, 20 Dec 2020 03:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgLTCCd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 21:02:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726660AbgLTCCd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 21:02:33 -0500
X-Gm-Message-State: AOAM5327tcH6Qn9qlsgFKhygZIiq8BAvSIq+9wwEsuwK2TWvqtvfSceU
        vKEpoJz0Ao08D9Tb9EgpqIcp+THmuTaGrUqbg3RIQw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608429712;
        bh=SnpmJA7RQYbU8RQ1XC54nkNwo0zSWeRz3Ts91x0CAyc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Nms3CFFBJJJy0s56usyXXOLaHkRo+WDd7vpHZqCp3Cme881lJ1swcOmCkLiRvEoMx
         vybkG3PhWN09A/Xlzt8Er8Zq94wts93DYz1kadJY6/pIn//yURv1UQ/ws1w1xemk1Q
         4uyiz/t6dSOKZx97OZ3gKmETRNMvnJpCsu8FXGyyd0pIDiOAVKkGy2HhDQCZ/gX2KW
         Rx1EOrZdDSEloB1glSu7mfDlpo1coYvvzuXrKpjfaZZXQyRZfClVy7lBHM+L5ByfvJ
         tT5i+z/tDsNFn8WWiWS8u/miUdoIg6EqADkwWM2mL8eF7lwSVtQdg460qQh0GARtsj
         LnaHAFUEZlHmQ==
X-Google-Smtp-Source: ABdhPJzxkWdxDEIeterCyrf+stzY/SxYI2/cfKC96RyQnm/M7F1J5UlK0mql+LLdDoZep39P+HqZkPXviX7k/HBMW5w=
X-Received: by 2002:a1c:1d85:: with SMTP id d127mr10455072wmd.49.1608429710342;
 Sat, 19 Dec 2020 18:01:50 -0800 (PST)
MIME-Version: 1.0
References: <20201219043006.2206347-1-namit@vmware.com> <X95RRZ3hkebEmmaj@redhat.com>
 <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
In-Reply-To: <EDC00345-B46E-4396-8379-98E943723809@gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 19 Dec 2020 18:01:39 -0800
X-Gmail-Original-Message-ID: <CALCETrVtsdeOtGWMUcmT1dzDBxRpecpZDe02L61qEmJmFxSvYw@mail.gmail.com>
Message-ID: <CALCETrVtsdeOtGWMUcmT1dzDBxRpecpZDe02L61qEmJmFxSvYw@mail.gmail.com>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
To:     Nadav Amit <nadav.amit@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Andy Lutomirski <luto@kernel.org>, Yu Zhao <yuzhao@google.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 19, 2020 at 1:34 PM Nadav Amit <nadav.amit@gmail.com> wrote:
>
> [ cc=E2=80=99ing some more people who have experience with similar proble=
ms ]
>
> > On Dec 19, 2020, at 11:15 AM, Andrea Arcangeli <aarcange@redhat.com> wr=
ote:
> >
> > Hello,
> >
> > On Fri, Dec 18, 2020 at 08:30:06PM -0800, Nadav Amit wrote:
> >> Analyzing this problem indicates that there is a real bug since
> >> mmap_lock is only taken for read in mwriteprotect_range(). This might
> >
> > Never having to take the mmap_sem for writing, and in turn never
> > blocking, in order to modify the pagetables is quite an important
> > feature in uffd that justifies uffd instead of mprotect. It's not the
> > most important reason to use uffd, but it'd be nice if that guarantee
> > would remain also for the UFFDIO_WRITEPROTECT API, not only for the
> > other pgtable manipulations.
> >
> >> Consider the following scenario with 3 CPUs (cpu2 is not shown):
> >>
> >> cpu0                         cpu1
> >> ----                         ----
> >> userfaultfd_writeprotect()
> >> [ write-protecting ]
> >> mwriteprotect_range()
> >> mmap_read_lock()
> >> change_protection()
> >>  change_protection_range()
> >>   ...
> >>   change_pte_range()
> >>   [ defer TLB flushes]
> >>                              userfaultfd_writeprotect()
> >>                               mmap_read_lock()
> >>                               change_protection()
> >>                               [ write-unprotect ]
> >>                               ...
> >>                                [ unprotect PTE logically ]
> >>                              ...
> >>                              [ page-fault]
> >>                              ...
> >>                              wp_page_copy()
> >>                              [ set new writable page in PTE]
> >
> > Can't we check mm_tlb_flush_pending(vma->vm_mm) if MM_CP_UFFD_WP_ALL
> > is set and do an explicit (potentially spurious) tlb flush before
> > write-unprotect?
>
> There is a concrete scenario that I actually encountered and then there i=
s a
> general problem.
>
> In general, the kernel code assumes that PTEs that are read from the
> page-tables are coherent across all the TLBs, excluding permission promot=
ion
> (i.e., the PTE may have higher permissions in the page-tables than those
> that are cached in the TLBs).
>
> We therefore need to both: (a) protect change_protection_range() from the
> changes of others who might defer TLB flushes without taking mmap_sem for
> write (e.g., try_to_unmap_one()); and (b) to protect others (e.g.,
> page-fault handlers) from concurrent changes of change_protection().
>
> We have already encountered several similar bugs, and debugging such issu=
es
> s time consuming and these bugs impact is substantial (memory corruption,
> security). So I think we should only stick to general solutions.
>
> So perhaps your the approach of your proposed solution is feasible, but i=
t
> would have to be applied all over the place: we will need to add a check =
for
> mm_tlb_flush_pending() and conditionally flush the TLB in every case in
> which PTEs are read and there might be an assumption that the
> access-permission reflect what the TLBs hold. This includes page-fault
> handlers, but also NUMA migration code in change_protection(), softdirty
> cleanup in clear_refs_write() and maybe others.

I missed the beginning of this thread, but it looks to me like
userfaultfd changes PTEs with not locking except mmap_read_lock().  It
also calls inc_tlb_flush_pending(), which is very explicitly
documented as requiring the pagetable lock.  Those docs must be wrong,
because mprotect() uses the mmap_sem write lock, which is just fine,
but ISTM some kind of mutual exclusion with proper acquire/release
ordering is indeed needed.  So the userfaultfd code seems bogus.

I think userfaultfd either needs to take a real lock (probably doesn't
matter which) or the core rules about PTEs need to be rewritten.
