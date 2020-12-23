Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF98E2E1F6B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 17:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgLWQZt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 11:25:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29799 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbgLWQZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 11:25:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608740661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EyXIEM4Le7OfcstCNHW3uuUenYWs3VwcIb00szymHWw=;
        b=bmQo15ym9KnL48QmQrzt5NdoeUtI9fLTmRczKXrKz16VXrr5iXSwi3qP9MIlzHiBSkyN41
        Mf3wtr2nFZItZHAO981b6nCTzG6xyvU+Ovvpd8Ix1dgcRW4Sc1+5q+EXixZh3+IHTMHPko
        JuSydK8EcLEGrMR57s4Jo+6S0fxtDLY=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-L_f5JEqiNTe0uud-JqyVrA-1; Wed, 23 Dec 2020 11:24:19 -0500
X-MC-Unique: L_f5JEqiNTe0uud-JqyVrA-1
Received: by mail-qt1-f198.google.com with SMTP id o12so12547998qtw.14
        for <stable@vger.kernel.org>; Wed, 23 Dec 2020 08:24:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EyXIEM4Le7OfcstCNHW3uuUenYWs3VwcIb00szymHWw=;
        b=aFSLxFGpTQt1xqaz2Num9R0vJVKv26cDP6G0jZSAvf0mKLJ30Dmnj1F5GeEV5tpFxa
         8WfzTDM+NYXg68KIidmJsyJx/Q/XloNGZfdzbieHtcT/upZHBS3YrmqA3tWYhX/tdFC/
         jVglkefLjeEhA+toQWbhRGbJm8SFHZcVEuNirEGQjCGMImrf7AKaiuX6WTt0zzeoNWuA
         wz6Ht2kniWcWWo4lpvVZ/zl8qY/KV2Xs3GgBpCMHLrU5rTy5X3tIf/ao5hszwP1brVzk
         jcbyQX+YnwfB1QHaN3kTcMGlF6KCwX7viImftWvT6TIv5/zp0ugwUu0q9+9tdQcfnBW6
         0i1w==
X-Gm-Message-State: AOAM533Ax6IDXSD/ZKWhIevK45n9X4g6l2+XKkqcYmHDbNqmdItfSfeC
        uimQlh1LiEJqCyDXpEZr2q3Gm1UPg7+2CyPSTnuFtyT5lgHLxM8/zVeFH7uc5mA14B1BxsF3QcZ
        yjNGNSvbJVysprl1Z
X-Received: by 2002:aed:374a:: with SMTP id i68mr14943418qtb.81.1608740659390;
        Wed, 23 Dec 2020 08:24:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwgcbL3FGE31YefcM2+Z37LUrZZHDzv89mrQDQtcUixhczsctbWEBdGuGkMFvf2kn7aFgOa2g==
X-Received: by 2002:aed:374a:: with SMTP id i68mr14943391qtb.81.1608740659142;
        Wed, 23 Dec 2020 08:24:19 -0800 (PST)
Received: from xz-x1 ([142.126.83.202])
        by smtp.gmail.com with ESMTPSA id r8sm10491757qkm.106.2020.12.23.08.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 08:24:18 -0800 (PST)
Date:   Wed, 23 Dec 2020 11:24:16 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Yu Zhao <yuzhao@google.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Nadav Amit <nadav.amit@gmail.com>,
        linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@openvz.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        stable <stable@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm/userfaultfd: fix memory corruption due to writeprotect
Message-ID: <20201223162416.GD6404@xz-x1>
References: <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
 <X+KDwu1PRQ93E2LK@google.com>
 <CAHk-=wiBWkgxLtwD7n01irD7hTQzuumtrqCkxxZx=6dbiGKUqQ@mail.gmail.com>
 <CAHk-=wjG7xx7Gsb=K0DteB1SPcKjus02zY2gFUoxMY5mm7tfsA@mail.gmail.com>
 <CAHk-=wjNv1GQn+8stK419HAqK0ofkJ1vOR9YSWSNjbW3T5as9A@mail.gmail.com>
 <X+MWppLjiR7hLgg9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <X+MWppLjiR7hLgg9@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 23, 2020 at 03:06:30AM -0700, Yu Zhao wrote:
> On Wed, Dec 23, 2020 at 01:44:42AM -0800, Linus Torvalds wrote:
> > On Tue, Dec 22, 2020 at 4:01 PM Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > >
> > > The more I look at the mprotect code, the less I like it. We seem to
> > > be much better about the TLB flushes in other places (looking at
> > > mremap, for example). The mprotect code seems to be very laissez-faire
> > > about the TLB flushing.
> > 
> > No, this doesn't help.
> > 
> > > Does adding a TLB flush to before that
> > >
> > >         pte_unmap_unlock(pte - 1, ptl);
> > >
> > > fix things for you?
> > 
> > It really doesn't fix it. Exactly because - as pointed out earlier -
> > the actual page *copy* happens outside the pte lock.
> 
> I appreciate all the pointers. It seems to me it does.
> 
> > So what can happen is:
> > 
> >  - CPU 1 holds the page table lock, while doing the write protect. It
> > has cleared the writable bit, but hasn't flushed the TLB's yet
> > 
> >  - CPU 2 did *not* have the TLB entry, sees the new read-only state,
> > takes a COW page fault, and reads the PTE from memory (into
> > vmf->orig_pte)
> 
> In handle_pte_fault(), we lock page table and check pte_write(), so
> we either see a RW pte before CPU 1 runs or a RO one with no stale tlb
> entries after CPU 1 runs, assume CPU 1 flushes tlb while holding the
> same page table lock (not mmap_lock).

I think this is not against Linus's example - where cpu2 does not have tlb
cached so it sees RO while cpu3 does have tlb cached so cpu3 can still modify
it.  So IMHO there's no problem here.

But I do think in step 2 here we overlooked _PAGE_UFFD_WP bit.  Note that if
it's uffd-wp wr-protection it's always applied along with removing of the write
bit in change_pte_range():

        if (uffd_wp) {
                ptent = pte_wrprotect(ptent);
                ptent = pte_mkuffd_wp(ptent);
        }

So instead of being handled as COW page do_wp_page() will always trap
userfaultfd-wp first, hence no chance to race with COW.

COW could only trigger after another uffd-wp-resolve ioctl which could remove
the _PAGE_UFFD_WP bit, but with Andrea's theory unprotect will only happen
after all wr-protect completes, which guarantees that when reaching the COW
path the tlb must has been flushed anyways.  Then no one should be modifying
the page anymore even without pgtable lock in COW path.

So IIUC what Linus proposed on "flushing tlb within pgtable lock" seems to
work, but it just may cause more tlb flush than Andrea's proposal especially
when the protection range is large (it's common to have a huge protection range
for e.g. VM live snapshotting, where we'll protect all guest rw ram).

My understanding of current issue is that either we can take Andrea's proposal
(although I think the group rwsem may not be extremely better than a per-mm
rwsem, which I don't know... at least not worst than that?), or we can also go
the other way (also as Andrea mentioned) so that when wr-protect:

  - for <=2M range (pmd or less), we take read rwsem, but flush tlb within
    pgtable lock

  - for >2M range, we take write rwsem directly but flush tlb once
  
Thanks,

> 
> >  - CPU 2 correctly decides it needs to be a COW, and copies the page contents
> > 
> >  - CPU 3 *does* have a stale TLB (because TLB invalidation hasn't
> > happened yet), and writes to that page in users apce
> > 
> >  - CPU 1 now does the TLB invalidate, and releases the page table lock
> > 
> >  - CPU 2 gets the page table lock, sees that its PTE matches
> > vmf->orig_pte, and switches it to be that writable copy of the page.
> > 
> > where the copy happened before CPU 3 had stopped writing to the page.
> > 
> > So the pte lock doesn't actually matter, unless we actually do the
> > page copy inside of it (on CPU2), in addition to doing the TLB flush
> > inside of it (on CPU1).
> > 
> > mprotect() is actually safe for two independent reasons: (a) it does
> > the mmap_sem for writing (so mprotect can't race with the COW logic at
> > all), and (b) it changes the vma permissions so turning something
> > read-only actually disables COW anyway, since it won't be a COW, it
> > will be a SIGSEGV.
> > 
> > So mprotect() is irrelevant, other than the fact that it shares some
> > code with that "turn it read-only in the page tables".
> > 
> > fork() is a much closer operation, in that it actually triggers that
> > COW behavior, but fork() takes the mmap_sem for writing, so it avoids
> > this too.
> > 
> > So it's really just userfaultfd and that kind of ilk that is relevant
> > here, I think. But that "you need to flush the TLB before releasing
> > the page table lock" was not true (well, it's true in other
> > circumstances - just not *here*), and is not part of the solution.
> > 
> > Or rather, if it's part of the solution here, it would have to be
> > matched with that "page copy needs to be done under the page table
> > lock too".
> > 
> >               Linus
> > 
> 

-- 
Peter Xu

