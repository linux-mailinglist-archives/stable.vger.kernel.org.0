Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F244038D748
	for <lists+stable@lfdr.de>; Sat, 22 May 2021 21:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhEVTpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 May 2021 15:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbhEVToC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 May 2021 15:44:02 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D5BC06174A
        for <stable@vger.kernel.org>; Sat, 22 May 2021 12:41:33 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id b9-20020a17090a9909b029015cf9effaeaso9063951pjp.5
        for <stable@vger.kernel.org>; Sat, 22 May 2021 12:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SFKpmD5a58yAK0KX7PZrq6XiX162OZLnkIzoJqpkFsw=;
        b=A/6spznnPg8LSJl1adzNGiDbP6PsR9UtVSJLHhg+rzzqecRdM9ToFCvsmKeUmSnhDp
         ozgCQ32wH4Rx6CvC23I5J5VJtyxgZr7MVN5bz2ZP0AmXqTddWiUrA26WNzS7owGWL2fC
         o0lw1n8SNPeGjNAxBTUR2+V0+mkOi3YuHY7Kyv5Q6Pd6qTOAkP+f99UhYxBVjnnJcxJh
         NmfzXms9svvF/3KFxF49WTQ2e09yKzGJnfsiZ8Q5+1VqALD/e5T0/DzGsMZp+Cr+GDUv
         Ufy66Prpwtcba5Un53lBSRO4wk0uHTaatXGx5p1czvRLC9kt9rS9x/Oz3/+sTA2cAIQR
         MZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SFKpmD5a58yAK0KX7PZrq6XiX162OZLnkIzoJqpkFsw=;
        b=kn31nDDFdsDW+uXIHNGJXIYa3Fvbnfd5MLbobJ1lZ//TA/uMfCrLQB6iVVzM/LDc7E
         VMNoBraW78mJ2rGqcK2j2iBd5T4Kc2uZ/7bjJvVp8bWkWJQO9q+q92sWB/VLEgA9qedN
         DQuuuA1gkN5UaOMe5RR+/aIHyyCIoTYpipu3bD2QGb8q/1iOLoF57AIHwfls7PpnGzkr
         +lv6iXDBvjaOhJe19s6d1VvRnljRFHQpaBHdOqhyg6SIJRkPNagfebb1JjYHN4960Tjh
         r5PHQdir2keAHPPaKb3QAeB3CYT99iN4pA5h44tG3BnklcO25gIFV2NBit/HYaR3bzC0
         O7fA==
X-Gm-Message-State: AOAM530s8XrqjfLo6WEtdaDieZUC679Na/k+sS+IXmjYHHC3Tb0jXfVH
        BgI1nH28dUXbtbXEujdKstYxRYNaokc7gx9o5XYgqA==
X-Google-Smtp-Source: ABdhPJyLyvSmE/jiPGphlisECKYEs6RoJ/qavgE71eSKDSMNQxkYZiGy4nVoDHjFCzjJQuOGZcnk6aMfrms8zJe2dW4=
X-Received: by 2002:a17:90b:4b0f:: with SMTP id lx15mr16376461pjb.184.1621712492667;
 Sat, 22 May 2021 12:41:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210521233952.236434-1-mike.kravetz@oracle.com>
In-Reply-To: <20210521233952.236434-1-mike.kravetz@oracle.com>
From:   Mina Almasry <almasrymina@google.com>
Date:   Sat, 22 May 2021 12:41:21 -0700
Message-ID: <CAHS8izMVBZ2W+4ug6mKtU3B0QhcLz7SyPePxOgqAD8Ou3xx52Q@mail.gmail.com>
Subject: Re: [PATCH] userfaultfd: hugetlbfs: fix new flag usage in error path
To:     Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Linux-MM <linux-mm@kvack.org>,
        open list <linux-kernel@vger.kernel.org>,
        Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 21, 2021 at 4:40 PM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>
> In commit d6995da31122 ("hugetlb: use page.private for hugetlb specific
> page flags") the use of PagePrivate to indicate a reservation count
> should be restored at free time was changed to the hugetlb specific flag
> HPageRestoreReserve.  Changes to a userfaultfd error path as well as a
> VM_BUG_ON() in remove_inode_hugepages() were overlooked.
>
> Users could see incorrect hugetlb reserve counts if they experience an
> error with a UFFDIO_COPY operation.  Specifically, this would be the
> result of an unlikely copy_huge_page_from_user error.  There is not an
> increased chance of hitting the VM_BUG_ON.
>
> Fixes: d6995da31122 ("hugetlb: use page.private for hugetlb specific page flags")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
> ---
>  fs/hugetlbfs/inode.c |  2 +-
>  mm/userfaultfd.c     | 28 ++++++++++++++--------------
>  2 files changed, 15 insertions(+), 15 deletions(-)
>

Reviewed-by: Mina Almasry <almasry.mina@google.com>

I'm guessing this may interact with my patch in review "[PATCH v3] mm,
hugetlb: fix resv_huge_pages underflow on UFFDIO_COPY". I'll rebase my
patch and re-test.

> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 9d9e0097c1d3..55efd3dd04f6 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -529,7 +529,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>                          * the subpool and global reserve usage count can need
>                          * to be adjusted.
>                          */
> -                       VM_BUG_ON(PagePrivate(page));
> +                       VM_BUG_ON(HPageRestoreReserve(page));
>                         remove_huge_page(page);
>                         freed++;
>                         if (!truncate_op) {
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 5508f7d9e2dc..9ce5a3793ad4 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -432,38 +432,38 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
>                  * If a reservation for the page existed in the reservation
>                  * map of a private mapping, the map was modified to indicate
>                  * the reservation was consumed when the page was allocated.
> -                * We clear the PagePrivate flag now so that the global
> +                * We clear the HPageRestoreReserve flag now so that the global
>                  * reserve count will not be incremented in free_huge_page.
>                  * The reservation map will still indicate the reservation
>                  * was consumed and possibly prevent later page allocation.
>                  * This is better than leaking a global reservation.  If no
> -                * reservation existed, it is still safe to clear PagePrivate
> -                * as no adjustments to reservation counts were made during
> -                * allocation.
> +                * reservation existed, it is still safe to clear
> +                * HPageRestoreReserve as no adjustments to reservation counts
> +                * were made during allocation.
>                  *
>                  * The reservation map for shared mappings indicates which
>                  * pages have reservations.  When a huge page is allocated
>                  * for an address with a reservation, no change is made to
> -                * the reserve map.  In this case PagePrivate will be set
> -                * to indicate that the global reservation count should be
> +                * the reserve map.  In this case HPageRestoreReserve will be
> +                * set to indicate that the global reservation count should be
>                  * incremented when the page is freed.  This is the desired
>                  * behavior.  However, when a huge page is allocated for an
>                  * address without a reservation a reservation entry is added
> -                * to the reservation map, and PagePrivate will not be set.
> -                * When the page is freed, the global reserve count will NOT
> -                * be incremented and it will appear as though we have leaked
> -                * reserved page.  In this case, set PagePrivate so that the
> -                * global reserve count will be incremented to match the
> -                * reservation map entry which was created.
> +                * to the reservation map, and HPageRestoreReserve will not be
> +                * set. When the page is freed, the global reserve count will
> +                * NOT be incremented and it will appear as though we have
> +                * leaked reserved page.  In this case, set HPageRestoreReserve
> +                * so that the global reserve count will be incremented to
> +                * match the reservation map entry which was created.
>                  *
>                  * Note that vm_alloc_shared is based on the flags of the vma
>                  * for which the page was originally allocated.  dst_vma could
>                  * be different or NULL on error.
>                  */
>                 if (vm_alloc_shared)
> -                       SetPagePrivate(page);
> +                       SetHPageRestoreReserve(page);
>                 else
> -                       ClearPagePrivate(page);
> +                       ClearHPageRestoreReserve(page);
>                 put_page(page);
>         }
>         BUG_ON(copied < 0);
> --
> 2.31.1
>
