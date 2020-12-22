Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE432E0FC2
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 22:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgLVVP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 16:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727729AbgLVVP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 16:15:27 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6CAC0613D6
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 13:14:47 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id w18so13282116iot.0
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 13:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hhOVWQMRBXTSxgOfOIlTbGi5pKxxOrfplky7l7BBnhM=;
        b=Ip7kUhtQWlGrcq5tqC3mriHnfwJr6UnXCyCGy7bdOw1QIjqw9R+RuWLait9zupVB/W
         N/PMKfqY9LMNFAxSEA69SzO9GFIDf7bks71HwmakaefIOdOUlaE79LoUbGHXsB6P7RE3
         /b5RIkP+YskPlcKAvTGfPh7x0cqiKhqL9Oj5IEpjrFvyBYgc4Agz6eDxs8G6YtyGPwdr
         dDSBWBvMjI7CMmffmS6vVvfDGW/Zuwu1UafsVOywolmrVXYIPSe9ApZWZp7DFr0lqMZD
         nAPZ7T8KSgpiTjW/reG3rOuKkTDhp3TGrU1lsyM9kmAxIjJ8igq8mw2tuGtcw/hF5F3O
         bN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hhOVWQMRBXTSxgOfOIlTbGi5pKxxOrfplky7l7BBnhM=;
        b=b78PhiTilZPwchgN6Zj70hC7llOg5IWQY6wl8WyQ8W9CfFfmboo+KMlXmvuhwUf0/d
         g5dy1QwSWhJMY+C5AcpiKfyUoPlh6HTAAAcY01oFBzKNnbujTrsIvjRfyDCwX8ga4hcm
         UBIblvXWH9TtbYsrgbQzBXjQ978LvN9Zlz9aB1XPOWAiyUm6mWRGFllSic2TQbJN1Aeu
         67IRPn/v6/ZXI2SbPW+XmQBvAQOdX0f7eC34ZxAPeLxWc82iWk4o4VeVwnbFWlZTFDkV
         YH7HNXkNZl1gXXlwH3LAkKgBcntdNSuXdcbhSEaVP5fMFSFGdEyxDU/9tRifA6doGN/n
         7zwQ==
X-Gm-Message-State: AOAM530fg9QuW5qA6GrEtA7vsf7vMjSKtEz/MUi9RDeRPXARNlMajQzx
        GrR/zjA8QXNuAzOTmMpeLAf/xQ==
X-Google-Smtp-Source: ABdhPJxfvkmrgxRwPhJVhZdoBnVyrDjWBSKVVTgZqSpV5Xu5LW9Vh4lIVRG4eU7w49W/WV66Ah9suQ==
X-Received: by 2002:a05:6638:25ca:: with SMTP id u10mr20995078jat.33.1608671686222;
        Tue, 22 Dec 2020 13:14:46 -0800 (PST)
Received: from google.com ([2620:15c:183:200:7220:84ff:fe09:2d90])
        by smtp.gmail.com with ESMTPSA id l20sm24341771ioh.49.2020.12.22.13.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 13:14:45 -0800 (PST)
Date:   Tue, 22 Dec 2020 14:14:41 -0700
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
Message-ID: <X+JhwVX3s5mU9ZNx@google.com>
References: <X+D0hTZCrWS3P5Pi@google.com>
 <CAHk-=wg_UBuo7ro1fpEGkMyFKA1+PxrE85f9J_AhUfr-nJPpLQ@mail.gmail.com>
 <9E301C7C-882A-4E0F-8D6D-1170E792065A@gmail.com>
 <CAHk-=wg-Y+svNy3CDkJjj0X_CJkSbpERLg64-Vqwq5u7SC4z0g@mail.gmail.com>
 <X+ESkna2z3WjjniN@google.com>
 <1FCC8F93-FF29-44D3-A73A-DF943D056680@gmail.com>
 <20201221223041.GL6640@xz-x1>
 <CAHk-=wh-bG4thjXUekLtrCg8FRrdWjtT40ibXXLSm_hzQG8eOw@mail.gmail.com>
 <CALCETrV=8tY7h=aaudWBEn-MJnNkm2wz5qjH49SYqwkjYTpOaA@mail.gmail.com>
 <X+JJqK91plkBVisG@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X+JJqK91plkBVisG@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 22, 2020 at 02:31:52PM -0500, Andrea Arcangeli wrote:
> On Mon, Dec 21, 2020 at 07:19:35PM -0800, Andy Lutomirski wrote:
> > instance of this (with mmap_sem held for write) in x86:
> > mark_screen_rdonly().  Dare I ask how broken this is?  We could likely
> 
> That one is buggy despite it takes the mmap_write_lock... inverting
> the last two lines would fix it though.
> 
> -	mmap_write_unlock(mm);
> 	flush_tlb_mm_range(mm, 0xA0000, 0xA0000 + 32*PAGE_SIZE, PAGE_SHIFT, false);
> +	mmap_write_unlock(mm);
> 
> The issue here is that rightfully wp_page_copy copies outside the PT
> lock (good thing) and it correctly assumes during the copy nobody can
> modify the page if the fault happened in a write access and the pte
> had no _PAGE_WRITE bit set.
> 
> The bug is clearly in userfaultfd_writeprotect that doesn't enforce
> the above invariant.
> 
> If the userfaultfd_wrprotect(mode_wp = false) run after the deferred
> TLB flush this could never happen because the uffd_wp bit was still
> set and the page fault would hit the handle_userfault dead end and
> it'd have to be restarted from scratch.
> 
> Leaving stale tlb entries after dropping the PT lock and with only the
> mmap_lock_read is only ok if the page fault has a "check" that catches
> that specific case, so that specific case is fully serialized by the
> PT lock alone and the "catch" path is fully aware about the stale TLB
> entries that were left around.
> 
> So looking at the two cases that predates uffd-wp that already did a
> RW->RO transition with the mmap_lock_read, they both comply with the
> wp_page_copy invariant but with two different techniques:
> 
> 1) change_protection is called by the scheduler with the
>   mmap_read_lock and with a deferred TLB flush, and things don't fall
>   apart completely there simply because we catch that in do_numa_page:
> 
> 	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
> +               /* catch it: no risk to end up in wp_page_copy even if the change_protection
> +	           is running concurrently and the tlb flush is still pending */
> 		return do_numa_page(vmf);
> 
>   do_numa_page doesn't issue any further tlb flush, but basically
>   restores the pte to the previous value, so then the pending flush
>   becomes a noop, since there was no modification to the pte in the
>   first place after do_numa_page runs.
> 
> 2) ksm write_protect_page is also called with mmap_read_lock, and it
>    will simply not defer the flush. If the tlb flush is done inside
>    the PT lock it is ok to take mmap_read_lock since the page fault
>    code will not make any assumption about the TLB before reading the
>    pagetable content under PT lock.
> 
>    In fact if mm_tlb_flush_pending(mm) is true, write_protect_page in
>    KSM has to issue an extra synchronous flush before dropping the PT
>    lock, even if it finds the _PAGE_WRITE bit is already clear,
>    precisely because there can be another deferred flush that cleared
>    the pte but didn't flush the TLB yet.
> 
> userfaultfd_writeprotect() is already using the technique in 1) to be
> safe, except the un-wrprotect can break it if run while the tlb flush
> is still pending...
> 
> The good thing is this guarantee must be provided not more granular
> even than a vma, not per-mm and a vma cannot be registered on two
> different uffd ctx at the same time, so the locking can happen all
> internal to the uffd ctx.
> 
> My previous suggestion to use a mutex to serialize
> userfaultfd_writeprotect with a mutex will still work, but we can run
> as many wrprotect and un-wrprotect as we want in parallel, as long as
> they're not simultaneous, we can do much better than a mutex.
> 
> Ideally we would need a new two_group_semaphore, where each group can
> run as many parallel instances as it wants, but no instance of one
> group can run in parallel with any instance of the other group. AFIK
> such a kind of lock doesn't exist right now.
> 
> wrprotect if left alone never had an issue since we had a working
> "catch" check for it well before wp_page_copy could run. unprotect
> also if left alone was ok since it's a permission upgrade.
> 
> Alternatively, we can solve this with the same technique as in 2),
> because all it matters is that the 4k pte modification doesn't take
> the mmap_lock_write. A modification to a single 4k pte or a single 2m
> hugepmd is very likely indication that there's going to be a flood of
> those in parallel from all CPUs and likely there's also a flood of
> page faults from all CPUs in parallel. In addition for a 4k wrprotect
> or un-wrprotect there's not a significant benefit in deferring the TLB
> flush.
> 
> I don't think we can take the mmap_write_lock unconditionally because
> one of the main reasons to deal with the extra complexity of resolving
> page faults in userland is to bypass mprotect entirely.
> 
> Example, JITs can use unprivileged uffd to eliminate the software-set
> dirty bit every time it modifies memory, that would then require
> frequent wrprotect/un-wrprotect during page faults and the less likely
> we have to block for I/O during those CPU-only events, the
> better. This is one of the potential use cases, but there's plenty
> more.
> 
> So the alternative would be to take mmap_read_lock for "len <=
> HPAGE_PMD_SIZE" and the mmap_write_lock otherwise, and to add a
> parameter in change_protection to tell it to flush before dropping the
> PT lock and not defer the flush. So this is going to be more intrusive
> in the VM and it's overall unnecessary.
> 
> The below is mostly untested... but it'd be good to hear some feedback
> before doing more work in this direction.

This works but I don't prefer this option because 1) this is new
way of making pte_wrprotect safe and 2) it's specific to ufd and
can't be applied to clear_soft_dirty() which has no "catcher". No
matter how good the documentation about this new way is now, it
will be out of date, speaking from my personal experience.

I'd go with what Nadav has -- the memory corruption problem has been
there for a while and nobody has complained except Nadav. This makes
me think people is less likely to notice any performance issues from
holding mmap_lock for write in his patch either.

But I can't say I have zero concern with the potential performance
impact given that I have been expecting the fix to go to stable,
which I care most. So the next option on my list is to have a
common "catcher" in do_wp_page() which singles out pages that have
page_mapcount equal to one and reuse them instead of trying to
make copies when they have elevated page_count or are locked. Think
this as a common "catcher" for anybody who pte_wrprotect but doesn't
belong to the COW category (ksm, fork, etc.). I have to stress that
I don't know if this can be done confidently enough to be included
in stable, hence the second option on my list.

> From 4ace4d1b53f5cb3b22a5c2dc33facc4150b112d6 Mon Sep 17 00:00:00 2001
> From: Andrea Arcangeli <aarcange@redhat.com>
> Date: Tue, 22 Dec 2020 14:30:16 -0500
> Subject: [PATCH 1/1] mm: userfaultfd: avoid leaving stale TLB after
>  userfaultfd_writeprotect()
> 
> change_protection() is called by userfaultfd_writeprotect() with the
> mmap_lock_read like in change_prot_numa().
> 
> The page fault code in wp_copy_page() rightfully assumes if the CPU
> issued a write fault and the write bit in the pagetable is not set, no
> CPU can write to the page. That's wrong assumption after
> userfaultfd_writeprotect(). That's also wrong assumption after
> change_prot_numa() where the regular page fault code also would assume
> that if the present bit is not set and the page fault is running,
> there should be no stale TLB entry, but there is still.
> 
> So to stay safe, the page fault code must be prevented to run as long
> as long as the TLB flush remains pending. That is already achieved by
> the do_numa_page() path for change_prot_numa() and by the
> userfaultfd_pte_wp() path for userfaultfd_writeprotect().
> 
> The problem that needs fixing is that an un-wrprotect
> (i.e. userfaultfd_writeprotect() with UFFDIO_WRITEPROTECT_MODE_WP not
> set) could run in between the original wrprotect
> (i.e. userfaultfd_writeprotect() with UFFDIO_WRITEPROTECT_MODE_WP set)
> and wp_copy_page, while the TLB flush remains pending.
> 
> In such case the userfaultfd_pte_wp() check will stop being effective
> to prevent the regular page fault code to run.
> 
> CPU0			CPU 1		CPU 2
> ------			--------	-------
> userfaultfd_wrprotect(mode_wp = true)
> PT lock
> atomic set _PAGE_UFFD_WP and clear _PAGE_WRITE
> PT unlock
> 
> 			do_page_fault FAULT_FLAG_WRITE
> 					userfaultfd_wrprotect(mode_wp = false)
> 					PT lock
> 					ATOMIC clear _PAGE_UFFD_WP <- problem
> 					/* _PAGE_WRITE not set */
> 					PT unlock
> 					XXXXXXXXXXXXXX BUG RACE window open here
> 
> 			PT lock
> 			FAULT_FLAG_WRITE is set by CPU
> 			_PAGE_WRITE is still clear in pte
> 			PT unlock
> 
> 			wp_page_copy
> 			copy_user_page runs with stale TLB
> 
> deferred tlb flush <- too late
> XXXXXXXXXXXXXX BUG RACE window close here
> ================================================================================
> 
> If the userfaultfd_wrprotect(mode_wp = false) can only run after the
> deferred TLB flush the above cannot happen either, because the uffd_wp
> bit will remain set until after the TLB flush and the page fault would
> reliably hit the handle_userfault() dead end as long as the TLB is
> stale.
> 
> So to fix this we need to prevent any un-wrprotect to start until the
> last outstanding wrprotect completed and to prevent any further
> wrprotect until the last outstanding un-wrprotect completed. Then
> wp_page_copy can still run in parallel but only with the un-wrprotect,
> and that's fine since it's a permission promotion.
> 
> We would need a new two_group_semaphore, where each group can run as
> many parallel instances as it wants, but no instance of one group can
> run in parallel with any instance of the other group. The below rwsem
> with two atomics approximates that kind lock.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  fs/userfaultfd.c | 39 +++++++++++++++++++++++++++++++++++++++
>  mm/memory.c      | 20 ++++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 894cc28142e7..3729ca99dae5 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -76,6 +76,20 @@ struct userfaultfd_ctx {
>  	bool mmap_changing;
>  	/* mm with one ore more vmas attached to this userfaultfd_ctx */
>  	struct mm_struct *mm;
> +	/*
> +	 * We cannot let userfaultd_writeprotect(mode_wp = false)
> +	 * clear _PAGE_UFFD_WP from the pgtable, until the last
> +	 * outstanding userfaultd_writeprotect(mode_wp = true)
> +	 * completes, because the TLB flush is deferred. The page
> +	 * fault must be forced to enter handle_userfault() while the
> +	 * TLB flush is deferred, and that's achieved with the
> +	 * _PAGE_UFFD_WP bit. The _PAGE_UFFD_WP can only be cleared
> +	 * after there are no stale TLB entries left, only then it'll
> +	 * be safe again for the page fault to continue and not hit
> +	 * the handle_userfault() dead end anymore.
> +	 */
> +	struct rw_semaphore wrprotect_rwsem;
> +	atomic64_t wrprotect_count[2];
>  };
>  
>  struct userfaultfd_fork_ctx {
> @@ -1783,6 +1797,7 @@ static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
>  	struct uffdio_writeprotect __user *user_uffdio_wp;
>  	struct userfaultfd_wake_range range;
>  	bool mode_wp, mode_dontwake;
> +	bool contention;
>  
>  	if (READ_ONCE(ctx->mmap_changing))
>  		return -EAGAIN;
> @@ -1808,9 +1823,30 @@ static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
>  	if (mode_wp && mode_dontwake)
>  		return -EINVAL;
>  
> +	VM_WARN_ON(atomic64_read(&ctx->wrprotect_count[0]) < 0);
> +	VM_WARN_ON(atomic64_read(&ctx->wrprotect_count[1]) < 0);
> +	atomic64_inc(&ctx->wrprotect_count[mode_wp ? 0 : 1]);
> +	smp_mb__after_atomic();
> +	contention = atomic64_read(&ctx->wrprotect_count[mode_wp ? 1 : 0]) > 0;
> +	if (!contention)
> +		down_read(&ctx->wrprotect_rwsem);
> +	else {
> +		down_write(&ctx->wrprotect_rwsem);
> +		if (!atomic64_read(&ctx->wrprotect_count[mode_wp ? 1 : 0])) {
> +			contention = false;
> +			downgrade_write(&ctx->wrprotect_rwsem);
> +		}
> +
> +	}
>  	ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
>  				  uffdio_wp.range.len, mode_wp,
>  				  &ctx->mmap_changing);
> +	if (!contention)
> +		up_read(&ctx->wrprotect_rwsem);
> +	else
> +		up_write(&ctx->wrprotect_rwsem);
> +	smp_mb__before_atomic();
> +	atomic64_dec(&ctx->wrprotect_count[mode_wp ? 0 : 1]);
>  	if (ret)
>  		return ret;
>  
> @@ -1958,6 +1994,9 @@ static void init_once_userfaultfd_ctx(void *mem)
>  	init_waitqueue_head(&ctx->fault_wqh);
>  	init_waitqueue_head(&ctx->event_wqh);
>  	init_waitqueue_head(&ctx->fd_wqh);
> +	init_rwsem(&ctx->wrprotect_rwsem);
> +	atomic64_set(&ctx->wrprotect_count[0], 0);
> +	atomic64_set(&ctx->wrprotect_count[1], 0);
>  	seqcount_spinlock_init(&ctx->refile_seq, &ctx->fault_pending_wqh.lock);
>  }
>  
> diff --git a/mm/memory.c b/mm/memory.c
> index 7d608765932b..4ff9f21d5a7b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3085,6 +3085,12 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  
> +	/*
> +	 * STALE_TLB_WARNING: while the uffd_wp bit is set, the TLB
> +	 * can be stale. We cannot allow do_wp_page to proceed or
> +	 * it'll wrongly assume that nobody can still be writing to
> +	 * the page if !pte_write.
> +	 */
>  	if (userfaultfd_pte_wp(vma, *vmf->pte)) {
>  		pte_unmap_unlock(vmf->pte, vmf->ptl);
>  		return handle_userfault(vmf, VM_UFFD_WP);
> @@ -4274,6 +4280,12 @@ static inline vm_fault_t create_huge_pmd(struct vm_fault *vmf)
>  static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf, pmd_t orig_pmd)
>  {
>  	if (vma_is_anonymous(vmf->vma)) {
> +		/*
> +		 * STALE_TLB_WARNING: while the uffd_wp bit is set,
> +		 * the TLB can be stale. We cannot allow wp_huge_pmd()
> +		 * to proceed or it'll wrongly assume that nobody can
> +		 * still be writing to the page if !pmd_write.
> +		 */
>  		if (userfaultfd_huge_pmd_wp(vmf->vma, orig_pmd))
>  			return handle_userfault(vmf, VM_UFFD_WP);
>  		return do_huge_pmd_wp_page(vmf, orig_pmd);
> @@ -4388,6 +4400,10 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
>  	if (!pte_present(vmf->orig_pte))
>  		return do_swap_page(vmf);
>  
> +	/*
> +	 * STALE_TLB_WARNING: if the pte is NUMA protnone the TLB can
> +	 * be stale.
> +	 */
>  	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma))
>  		return do_numa_page(vmf);
>  
> @@ -4503,6 +4519,10 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>  			return 0;
>  		}
>  		if (pmd_trans_huge(orig_pmd) || pmd_devmap(orig_pmd)) {
> +			/*
> +			 * STALE_TLB_WARNING: if the pmd is NUMA
> +			 * protnone the TLB can be stale.
> +			 */
>  			if (pmd_protnone(orig_pmd) && vma_is_accessible(vma))
>  				return do_huge_pmd_numa_page(&vmf, orig_pmd);
>  
> 
