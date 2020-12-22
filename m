Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FF82E109B
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 00:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgLVXkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 18:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbgLVXkc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 18:40:32 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A300C0613D6
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 15:39:52 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id t8so13521187iov.8
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 15:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A0AkWSCozRMC8MnKl4n5pkXo4MvucVXsl5zrvsOTgMg=;
        b=Gpicw7ClBK8Sf4PuS+AS96JVD1BIWe1SiSOoBQB/DkQJVimB3RhRNRQVEf6H2EYbPG
         jfbYkoQLbRLuc6S2EsVPyUln8mY5cfkPOrmbwDjw/Cl9xTLiKtU6EvBXRVuVEM800JV1
         dLMlGxTgJTmEi7qqxSMSsTCWP6C4mWWqd7eP57H2x8rL4/1JmxKA8aiPFC9o2LTmN5Rc
         gI/GHD3snPdzXeYfv9uHeN4aHzDzJWx1OAdlpv4wmtn4gunHE5m7d0RWWZkjcmIBofmN
         SBLs600H3WS97RCH8jeNSCCyiKctceDF7R5GQaewMVd3XfzxbPQxfRLVucQJcTdZBkBu
         y3EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A0AkWSCozRMC8MnKl4n5pkXo4MvucVXsl5zrvsOTgMg=;
        b=mh6acwCH/6BxQPwSzCdFBXj2KKQEp6pCp5EIUghs9jMCAhI5FL6bdTJMTzcrwqwiko
         9/GIPke+WBqr3g1gW/kvhbeYcJm8IH+3HjDXAMR9Rh/ilwPp9zp/H0lH31L3Zv7ZRvvl
         Ys92QgGVJJDaTHW0YlYloZ+64zV1DGQiz57VU2mKN5HUA/avHT4yX0ULZ596yP4zhmUe
         IkP+ztokDOHGp8Wo1Anc4Qq3yB4bglpNZgTLx9SQczL9AeHozyRzZctnhEAic/+oGzaP
         LgCcnXOruXCxHbh0Ab0JmxARZT3Old5GMz7w1ekeG7QH3SUWxSChB3vqizatHAH7Iq0I
         v6xw==
X-Gm-Message-State: AOAM5322FPX60PUC4d6DzvxKRu+aaBShT+hfutG+vv6v+x9EHJkj3dMw
        ev/mcoAHwVbfH0nQvCYlwF7g9A==
X-Google-Smtp-Source: ABdhPJze60CMPQrTraoojTdyLspc3Yt/g4avyDkIBJdaGN9P0XqCx2ZXAqLq0zxQWkwk2fLZ42gYaA==
X-Received: by 2002:a05:6602:314b:: with SMTP id m11mr20046182ioy.165.1608680391276;
        Tue, 22 Dec 2020 15:39:51 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id s1sm24167582iot.0.2020.12.22.15.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 15:39:50 -0800 (PST)
Date:   Tue, 22 Dec 2020 16:39:46 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
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
Message-ID: <X+KDwu1PRQ93E2LK@google.com>
References: <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
 <X+JhwVX3s5mU9ZNx@google.com>
 <X+Js/dFbC5P7C3oO@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+Js/dFbC5P7C3oO@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 05:02:37PM -0500, Andrea Arcangeli wrote:
> On Tue, Dec 22, 2020 at 02:14:41PM -0700, Yu Zhao wrote:
> > This works but I don't prefer this option because 1) this is new
> > way of making pte_wrprotect safe and 2) it's specific to ufd and
> > can't be applied to clear_soft_dirty() which has no "catcher". No
> 
> I didn't look into clear_soft_dirty issue, I can look into that.
> 
> To avoid having to deal with a 3rd solution it will have to use one of
> the two:
> 
> 1) avoid deferring tlb flush and enforce a sync flush before dropping
>   the PT lock even if mm_mm_tlb_flush_pending is true ->
>   write_protect_page in KSM
> 
> 2) add its own new catcher for its own specific marker (for UFFD-WP
>    the marker is _PAGE_UFFD_WP, for change_prot_numa is PROT_NONE on a
>    vma->vm_pgprot not PROT_NONE, for soft dirty it could be
>    _PAGE_SOFT_DIRTY) to send the page fault to a dead end before the
>    pte value is interpreted.
> 
> > matter how good the documentation about this new way is now, it
> > will be out of date, speaking from my personal experience.
> 
> A common catcher for all 3 is not possible because each catcher
> depends on whatever marker and whatever pte value they set that may
> lead to a different deterministic path where to put the catcher or
> multiple paths even. do_numa_page requires a catcher in a different
> place already.
> 
> Or well, a common catcher for all 3 is technically possible but it'd
> perform slower requiring to check things twice.
> 
> But perhaps the soft_dirty can use the same catcher of uffd-wp given
> the similarity?
> 
> > I'd go with what Nadav has -- the memory corruption problem has been
> > there for a while and nobody has complained except Nadav. This makes
> > me think people is less likely to notice any performance issues from
> > holding mmap_lock for write in his patch either.
> 
> uffd-wp is a fairly new feature, the current users are irrelevant,
> keeping it optimal is just for the future potential.
> 
> > But I can't say I have zero concern with the potential performance
> > impact given that I have been expecting the fix to go to stable,
> > which I care most. So the next option on my list is to have a
> 
> Actually stable would be very fine to go with Nadav patch and use the
> mmap_lock_write unconditionally. The optimal fix is only relevant for
> the future potential, so it's only relevant for Linus's tree.
> 
> However the feature is recent enough that it won't require a deep
> backport so the optimal fix is likely fine for stable as well,
> generally stable prefers the same fix as in the upstream when there's
> no major backport rejection issue.
> 
> The alternative solution for uffd is to do the deferred flush under
> mmap_lock_write if len is > HPAGE_PMD_SIZE, or to tell
> change_protection not to defer the flush and to take the
> mmap_lock_read for <= HPAGE_PMD_SIZE. That will avoid depending on the
> catcher and then userfaultfd_writeprotect(mode_wp=true)
> userfaultfd_writeprotect(mode_wp=false) can even run in parallel at
> all times. The cons is large userfaultfd_writeprotect will block for
> I/O and those would happen at least in the postcopy live snapshotting
> use case.
> 
> The main cons is that it'd require modification to change_protection
> so it actually looks more intrusive, not less.
> 
> Overall anything that allows to wrprotect 1 pte with only the
> mmap_lock_read exactly like KSM write_protect_page, would be enough for
> uffd-wp.
> 
> What isn't ok in terms of future potential is unconditional
> mmap_lock_write as in the original suggested patch in my view. It
> doesn't mean we can take mmap_lock_write when the operation is large
> and there is actually more benefit from deferring the flush.
> 
> > common "catcher" in do_wp_page() which singles out pages that have
> > page_mapcount equal to one and reuse them instead of trying to
> 
> I don't think the page_mapcount matters here. If the wp page reuse was
> more accurate (as it was before) we wouldn't notice this issue, but it
> still would be a bug that there were stale TLB entries. It worked by
> luck.

Can you please correct my understanding below? Thank you.

Generally speaking, we have four possible combinations relevant to
this discussion:
  1) anon, COW
  2) anon, non-COW
  3) file, COW
  4) file, non-COW

Assume we pte_wrprotect while holding mmap_lock for read, all four
combinations can be routed to do_wp_page(). The difference is that
1) and 3) are guaranteed to be RO when they become COW, and what we
do on top of their existing state doesn't make any difference.

2) is the false positive because of what we do, and it's causing the
memory corruption because do_wp_page() tries to make copies of pages
that seem to be RO but may have stale RW tlb entries pending flush.

If we grab mmap_lock for write, we block the fault that tries to copy
before we flush. Once it's done, we'll have two faulting CPUs, one
that had the stale entry and would otherwise do the damage and the
other that tries to copy. Then there is the silly part: we make a copy
and swap it with the only user who already has it...

We are talking about non-COW anon pages here -- they can't be mapped
more than once. So why not just identify them by checking
page_mapcount == 1 and then unconditionally reuse them? (This is
probably where I've missed things.)

4) may also be false positive (there are other legit cases relying on
it), and it's correctly identified by !PageAnon() +
VM_WRITE|VM_SHARED. For this category, we always reuse and we hitch
a free ride.
