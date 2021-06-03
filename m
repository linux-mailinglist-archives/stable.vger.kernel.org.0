Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B644399700
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 02:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhFCAkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 20:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhFCAkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 20:40:52 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8C1C061756
        for <stable@vger.kernel.org>; Wed,  2 Jun 2021 17:39:06 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 131so4916756ljj.3
        for <stable@vger.kernel.org>; Wed, 02 Jun 2021 17:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tHz0sv4wSEqXmjQTly2ZRYHwvH6S3eLd6ObBfZrh1OA=;
        b=XAnLTVNFLKsMmm7a1+kcmf2EJpcL9+s/kbjvcS5GqrOSLAV8oC2NEdpumvqOXhImpg
         Ikmpd9AAlVulHpEyD6EmG33qEaMs89KchHXJ7S+5pVtTGqeo80tw4h1B5Fv6Qmjz2C8I
         VubYdVJ5A7Cy4vD03W/D1WHS6NdIafWjay0CCJpV7PnnAgFU6IUn5EQPy/xlzjScyrmW
         417l9t40oxWH1EKKFioGOoRV6mzENH4wfnMmgIETZHGHcU8/H0+nFwexT0LAibH5cDEI
         LbwZl8CD74omhn9FR49a03LOA2esk67D2mOQfzcR0NaW8/RVVpn+XYuBqAF86jcxm6rj
         mimg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tHz0sv4wSEqXmjQTly2ZRYHwvH6S3eLd6ObBfZrh1OA=;
        b=O3AvFNVvYuSAAVVSXvA/jibHWTpX9zz89rQBws0/OIkWYoZom6J/zbZrhYv3Gzy/GA
         Sa5PCMbs3qPEJ/3ZyThQTT4JXyQbwBZs9ooeEI3nCfij3IbivjjgNXFYrONg1vh3S3od
         xeeMLbHeyAZ7SkHVMtCyVgZBRpVQieQCd0wNxqy1YP6IIurXNPPyDEFZfcQd+oyrBGNG
         FBRY3czyzJjcTxfDu9bnqlyM/ZuFUy19R9aiFML1IGtKGm0TIssZhD/RFrwKgEr+AQaQ
         RCkhqqzbQN7Yp2xVgKB3C+LV5JyuI+N1DJHv+1YCpe9BPAVA1+McnarM71ePsgEEvV+J
         GoFA==
X-Gm-Message-State: AOAM531Ji99oueZ/OGfK8cvnHLhfx8UO9Bqv3ettFwRpc9JZJTKPoqeF
        ogTvRi4+rSEc3nVcYjshAE4t/A/1pF1+cF1GEj30Zw==
X-Google-Smtp-Source: ABdhPJyt+a9uEh1DFDjQ4V4Z7+jdc83QSOIk7ExwqAlt9nF0MAqDFme7jI9F4hqAyjLm/+vNt88catSSVAGZqMuFtLU=
X-Received: by 2002:a2e:99c2:: with SMTP id l2mr27389313ljj.125.1622680742416;
 Wed, 02 Jun 2021 17:39:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210602234954.122199-1-mike.kravetz@oracle.com>
In-Reply-To: <20210602234954.122199-1-mike.kravetz@oracle.com>
From:   Mina Almasry <almasrymina@google.com>
Date:   Wed, 2 Jun 2021 17:38:51 -0700
Message-ID: <CAHS8izPD4mY_5MgAfNnjCQPN3Xc3Ttn8KDnT4Ub3XwgiiGbSjw@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: expand restore_reserve_on_error functionality
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Linux-MM <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 2, 2021 at 4:50 PM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> The routine restore_reserve_on_error is called to restore reservation
> information when an error occurs after page allocation.  The routine
> alloc_huge_page modifies the mapping reserve map and potentially the
> reserve count during allocation.  If code calling alloc_huge_page
> encounters an error after allocation and needs to free the page, the
> reservation information needs to be adjusted.
>
> Currently, restore_reserve_on_error only takes action on pages for which
> the reserve count was adjusted(HPageRestoreReserve flag).  There is
> nothing wrong with these adjustments.  However, alloc_huge_page ALWAYS
> modifies the reserve map during allocation even if the reserve count is
> not adjusted.  This can cause issues as observed during development of
> this patch [1].
>
> One specific series of operations causing an issue is:
> - Create a shared hugetlb mapping
>   Reservations for all pages created by default
> - Fault in a page in the mapping
>   Reservation exists so reservation count is decremented
> - Punch a hole in the file/mapping at index previously faulted
>   Reservation and any associated pages will be removed
> - Allocate a page to fill the hole
>   No reservation entry, so reserve count unmodified
>   Reservation entry added to map by alloc_huge_page
> - Error after allocation and before instantiating the page
>   Reservation entry remains in map
> - Allocate a page to fill the hole
>   Reservation entry exists, so decrement reservation count
> This will cause a reservation count underflow as the reservation count
> was decremented twice for the same index.
>
> A user would observe a very large number for HugePages_Rsvd in
> /proc/meminfo.  This would also likely cause subsequent allocations of
> hugetlb pages to fail as it would 'appear' that all pages are reserved.
>
> This sequence of operations is unlikely to happen, however they were
> easily reproduced and observed using hacked up code as described in [1].
>
> Address the issue by having the routine restore_reserve_on_error take
> action on pages where HPageRestoreReserve is not set.  In this case, we
> need to remove any reserve map entry created by alloc_huge_page.  A new
> helper routine vma_del_reservation assists with this operation.
>
> There are three callers of alloc_huge_page which do not currently call
> restore_reserve_on error before freeing a page on error paths.  Add
> those missing calls.
>
> [1] https://lore.kernel.org/linux-mm/20210528005029.88088-1-almasrymina@google.com/
> Fixes: 96b96a96ddee ("mm/hugetlb: fix huge page reservation leak in private mapping error paths"
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> Cc: <stable@vger.kernel.org>
> ---
>  fs/hugetlbfs/inode.c    |   1 +
>  include/linux/hugetlb.h |   2 +
>  mm/hugetlb.c            | 120 ++++++++++++++++++++++++++++++++--------
>  3 files changed, 100 insertions(+), 23 deletions(-)
>
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 21f7a5c92e8a..926eeb9bf4eb 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -735,6 +735,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>                 __SetPageUptodate(page);
>                 error = huge_add_to_page_cache(page, mapping, index);
>                 if (unlikely(error)) {
> +                       restore_reserve_on_error(h, &pseudo_vma, addr, page);
>                         put_page(page);
>                         mutex_unlock(&hugetlb_fault_mutex_table[hash]);
>                         goto out;
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 44721df20e89..b375b31f60c4 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -627,6 +627,8 @@ struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
>                                 unsigned long address);
>  int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
>                         pgoff_t idx);
> +void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
> +                               unsigned long address, struct page *page);
>
>  /* arch callback */
>  int __init __alloc_bootmem_huge_page(struct hstate *h);
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 9a616b7a8563..36b691c3eabf 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2259,12 +2259,18 @@ static void return_unused_surplus_pages(struct hstate *h,
>   * be restored when a newly allocated huge page must be freed.  It is
>   * to be called after calling vma_needs_reservation to determine if a
>   * reservation exists.
> + *
> + * vma_del_reservation is used in error paths where an entry in the reserve
> + * map was created during huge page allocation and must be removed.  It is to
> + * be called after calling vma_needs_reservation to determine if a reservation
> + * exists.
>   */
>  enum vma_resv_mode {
>         VMA_NEEDS_RESV,
>         VMA_COMMIT_RESV,
>         VMA_END_RESV,
>         VMA_ADD_RESV,
> +       VMA_DEL_RESV,
>  };
>  static long __vma_reservation_common(struct hstate *h,
>                                 struct vm_area_struct *vma, unsigned long addr,
> @@ -2308,11 +2314,21 @@ static long __vma_reservation_common(struct hstate *h,
>                         ret = region_del(resv, idx, idx + 1);
>                 }
>                 break;
> +       case VMA_DEL_RESV:
> +               if (vma->vm_flags & VM_MAYSHARE) {
> +                       region_abort(resv, idx, idx + 1, 1);
> +                       ret = region_del(resv, idx, idx + 1);
> +               } else {
> +                       ret = region_add(resv, idx, idx + 1, 1, NULL, NULL);
> +                       /* region_add calls of range 1 should never fail. */
> +                       VM_BUG_ON(ret < 0);
> +               }
> +               break;

I haven't tested, but at first glance I don't think this quite works,
no? The thing is that alloc_huge_page() does a
vma_commit_reservation() which does add_region() regardless if
vm_flags & VM_MAYSHARE or not, so to unroll that we need a function
that does a region_del() regardless if vm_flags & VM_MAYSHARE or not.
I wonder if the root of the bug is the unconditional region_add()
vma_commit_reservation() does.

Also, I believe hugetlb_unreserve_pages() calls region_del() directly,
and doesn't go through the vma_*_reservation() interface. If you're
adding a delete function it may be nice to convert that to use the new
function as well.

I'm happy to take this fix over and submit a v2, since I think I
understand the problem and can readily reproduce the issue (I just add
the warning and some prints and run the userfaultfd tests).

>         default:
>                 BUG();
>         }
>
> -       if (vma->vm_flags & VM_MAYSHARE)
> +       if (vma->vm_flags & VM_MAYSHARE || mode == VMA_DEL_RESV)
>                 return ret;
>         /*
>          * We know private mapping must have HPAGE_RESV_OWNER set.
> @@ -2360,25 +2376,39 @@ static long vma_add_reservation(struct hstate *h,
>         return __vma_reservation_common(h, vma, addr, VMA_ADD_RESV);
>  }
>
> +static long vma_del_reservation(struct hstate *h,
> +                       struct vm_area_struct *vma, unsigned long addr)
> +{
> +       return __vma_reservation_common(h, vma, addr, VMA_DEL_RESV);
> +}
> +
>  /*
> - * This routine is called to restore a reservation on error paths.  In the
> - * specific error paths, a huge page was allocated (via alloc_huge_page)
> - * and is about to be freed.  If a reservation for the page existed,
> - * alloc_huge_page would have consumed the reservation and set
> - * HPageRestoreReserve in the newly allocated page.  When the page is freed
> - * via free_huge_page, the global reservation count will be incremented if
> - * HPageRestoreReserve is set.  However, free_huge_page can not adjust the
> - * reserve map.  Adjust the reserve map here to be consistent with global
> - * reserve count adjustments to be made by free_huge_page.
> + * This routine is called to restore reservation information on error paths.
> + * It should ONLY be called for pages allocated via alloc_huge_page(), and
> + * the hugetlb mutex should remain held when calling this routine.
> + *
> + * It handles two specific cases:
> + * 1) A reservation was in place and page consumed the reservation.
> + *    HPageRestoreRsvCnt is set in the page.
> + * 2) No reservation was in place for the page, so HPageRestoreRsvCnt is
> + *    not set.  However, alloc_huge_page always updates the reserve map.
> + *
> + * In case 1, free_huge_page will increment the global reserve count.  But,
> + * free_huge_page does not have enough context to adjust the reservation map.
> + * This case deals primarily with private mappings.  Adjust the reserve map
> + * here to be consistent with global reserve count adjustments to be made
> + * by free_huge_page.  Make sure the reserve map indicates there is a
> + * reservation present.
> + *
> + * In case 2, simply undo reserve map modifications done by alloc_huge_page.
>   */
> -static void restore_reserve_on_error(struct hstate *h,
> -                       struct vm_area_struct *vma, unsigned long address,
> -                       struct page *page)
> +void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
> +                       unsigned long address, struct page *page)
>  {
> -       if (unlikely(HPageRestoreReserve(page))) {
> -               long rc = vma_needs_reservation(h, vma, address);
> +       long rc = vma_needs_reservation(h, vma, address);
>
> -               if (unlikely(rc < 0)) {
> +       if (HPageRestoreReserve(page)) {
> +               if (unlikely(rc < 0))
>                         /*
>                          * Rare out of memory condition in reserve map
>                          * manipulation.  Clear HPageRestoreReserve so that
> @@ -2391,16 +2421,57 @@ static void restore_reserve_on_error(struct hstate *h,
>                          * accounting of reserve counts.
>                          */
>                         ClearHPageRestoreReserve(page);
> -               } else if (rc) {
> -                       rc = vma_add_reservation(h, vma, address);
> -                       if (unlikely(rc < 0))
> +               else if (rc)
> +                       (void)vma_add_reservation(h, vma, address);
> +               else
> +                       vma_end_reservation(h, vma, address);
> +       } else {
> +               if (!rc) {
> +                       /*
> +                        * This indicates there is an entry in the reserve map
> +                        * added by alloc_huge_page.  We know it was added
> +                        * before the alloc_huge_page call, otherwise
> +                        * HPageRestoreReserve would be set on the page.
> +                        * Remove the entry so that a subsequent allocation
> +                        * does not consume a reservation.
> +                        */
> +                       rc = vma_del_reservation(h, vma, address);
> +                       if (rc < 0)
>                                 /*
> -                                * See above comment about rare out of
> -                                * memory condition.
> +                                * VERY rare out of memory condition.  Since
> +                                * we can not delete the entry, set
> +                                * HPageRestoreReserve so that the reserve
> +                                * count will be incremented when the page
> +                                * is freed.  This reserve will be consumed
> +                                * on a subsequent allocation.
>                                  */
> -                               ClearHPageRestoreReserve(page);
> +                               SetHPageRestoreReserve(page);
> +               } else if (rc < 0) {
> +                       /*
> +                        * Rare out of memory condition from
> +                        * vma_needs_reservation call.  Memory allocation is
> +                        * only attempted if a new entry is needed.  Therefore,
> +                        * this implies there is not an entry in the
> +                        * reserve map.
> +                        *
> +                        * For shared mappings, no entry in the map indicates
> +                        * no reservation.  We are done.
> +                        */
> +                       if (!(vma->vm_flags & VM_MAYSHARE))
> +                               /*
> +                                * For private mappings, no entry indicates
> +                                * a reservation is present.  Since we can
> +                                * not add an entry, set SetHPageRestoreReserve
> +                                * on the page so reserve count will be
> +                                * incremented when freed.  This reserve will
> +                                * be consumed on a subsequent allocation.
> +                                */
> +                               SetHPageRestoreReserve(page);
>                 } else
> -                       vma_end_reservation(h, vma, address);
> +                       /*
> +                        * No reservation present, do nothing
> +                        */
> +                        vma_end_reservation(h, vma, address);
>         }
>  }
>
> @@ -4176,6 +4247,8 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
>                                 spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
>                                 entry = huge_ptep_get(src_pte);
>                                 if (!pte_same(src_pte_old, entry)) {
> +                                       restore_reserve_on_error(h, vma, addr,
> +                                                               new);
>                                         put_page(new);
>                                         /* dst_entry won't change as in child */
>                                         goto again;
> @@ -5174,6 +5247,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
>         if (vm_shared || is_continue)
>                 unlock_page(page);
>  out_release_nounlock:
> +       restore_reserve_on_error(h, dst_vma, dst_addr, page);
>         put_page(page);
>         goto out;
>  }
> --
> 2.31.1
>
