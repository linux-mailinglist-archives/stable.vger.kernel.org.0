Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC06645D37F
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 04:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345783AbhKYDPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 22:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344371AbhKYDNa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 22:13:30 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0BCC061A15
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 18:43:51 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id b67so7561928qkg.6
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 18:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PXridyzDH88ezOus9JldJrTVkWKs5hAHCUfqx0GIMqI=;
        b=FZ/WlhCbLrF4pDZucpHyb60GApFv+G4q/M1qakBJnNRaf+fylT6zkfnanpTfVWWVKL
         wfiJRJMlDxORaIBtPwgXJZPsyr6HK1+IJUDjYevTOtD2n1j0ba9gt6D6kdsm5vGmbFSW
         JcibHE1SChL0p/7JENnWAs7NBvGZlsokZ2Gtm2g17AWeaQamPv1ZHGP+pyP/gySY7dAQ
         WrGn+gW6/l90Jt/Wymi0YdQeWy0BTzfh6i41eMgUzmwWXUnh/TdwV6lSFrJinvBmPAyb
         uEA/5wP+IXf02ZJXWI8rr2edhQ1sn7VSkeCJADNbPKALDbdGV43wTEyWWJ+wwudxreeB
         WRxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PXridyzDH88ezOus9JldJrTVkWKs5hAHCUfqx0GIMqI=;
        b=RB7OBQzyEunhd6ifyXu+2kOQcPOWqmML9vS3atXDPbdILdpAUFvBsgmdoRE0P1ElUE
         CraY+VL2/eNaMmx6zFKtwRLMKq2miV2R7U5pCpUoUWnKXHyMgmB9mQbMMUIjottprs1/
         vN1+H3wXeMzZIAgm8UdYvxYGCMjMVGqbbJCHwtCmwvufrZNZbsqeSGtqkMey1hVo8/4J
         zwM/nG23nWBtK5Fn2+g6pF2MzzUuAOkb05Yn4MHAk6e8CIsLA+4erDKDVM971YOK+QYf
         L2hMi+xSl66/4YoQ5VEQTqCRwrXssduxffEfSoFE6jIG68irqWZE+n3aU4Sa3hXiHO/+
         QmUQ==
X-Gm-Message-State: AOAM531NqCCtKrw7QSGwHmln5uSGXiS0TqLK2ZaVIKqB/oo8Chc9JuJZ
        7fQkaMKkEn4CQkYa6WqLAAQMRlG/51XIW1zg8GvGwg==
X-Google-Smtp-Source: ABdhPJxd7aaatYgJmCD/NjuKZ1DDUCqtM13QZ2gH1QLSFgZAYzleM+VQCps0+oIRLuGzKTJuLA6reBxY3fXIVVKVUTs=
X-Received: by 2002:a25:b0a8:: with SMTP id f40mr2368543ybj.125.1637808230156;
 Wed, 24 Nov 2021 18:43:50 -0800 (PST)
MIME-Version: 1.0
References: <20211124094317.69719-1-ligang.bdlg@bytedance.com>
In-Reply-To: <20211124094317.69719-1-ligang.bdlg@bytedance.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Thu, 25 Nov 2021 10:43:11 +0800
Message-ID: <CAMZfGtX6n=H+7QXR2zpBTA5u6Q18DaJL=wZ6CFPVwEpGevGtBg@mail.gmail.com>
Subject: Re: [PATCH v3] shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode
To:     Gang Li <ligang.bdlg@bytedance.com>
Cc:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux- stable <stable@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 5:43 PM Gang Li <ligang.bdlg@bytedance.com> wrote:
>
> This patch fixes a data race in commit 779750d20b93 ("shmem: split huge pages
> beyond i_size under memory pressure").
>
> Here are call traces:
>
> Call Trace 1:
>         shmem_unused_huge_shrink+0x3ae/0x410
>         ? __list_lru_walk_one.isra.5+0x33/0x160
>         super_cache_scan+0x17c/0x190
>         shrink_slab.part.55+0x1ef/0x3f0
>         shrink_node+0x10e/0x330
>         kswapd+0x380/0x740
>         kthread+0xfc/0x130
>         ? mem_cgroup_shrink_node+0x170/0x170
>         ? kthread_create_on_node+0x70/0x70
>         ret_from_fork+0x1f/0x30
>
> Call Trace 2:
>         shmem_evict_inode+0xd8/0x190
>         evict+0xbe/0x1c0
>         do_unlinkat+0x137/0x330
>         do_syscall_64+0x76/0x120
>         entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>
> The simultaneous deletion of adjacent elements in the local list (@list)
> by shmem_unused_huge_shrink and shmem_evict_inode will break the list.
>
> Image there are 3 items in the local list (@list).
> In the first traversal, A is not deleted from @list.
>
>   1)    A->B->C
>         ^
>         |
>         pos (leave)
>
> In the second traversal, B is deleted from @list. Concurrently, A is
> deleted from @list through shmem_evict_inode() since last reference counter of
> inode is dropped by other thread. Then the @list is corrupted.
>
>   2)    A->B->C
>         ^  ^
>         |  |
>      evict pos (drop)
>
> Fix:
>
> We should make sure the item is either on the global list or deleted from
> any local list before iput().
>
> Fixed by moving inodes that are on @list and will not be deleted back to
> global list before iput.
>
> Fixes: 779750d20b93 ("shmem: split huge pages beyond i_size under memory pressure")
> Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>
>
> ---
>
> Changes in v3:
> - Add more comment.
> - Use list_move(&info->shrinklist, &sbinfo->shrinklist) instead of
>   list_move(pos, &sbinfo->shrinklist) for consistency.
>
> Changes in v2: https://lore.kernel.org/all/20211124030840.88455-1-ligang.bdlg@bytedance.com/
> - Move spinlock to the front of iput instead of changing lock type
>   since iput will call evict which may cause deadlock by requesting
>   shrinklist_lock.
> - Add call trace in commit message.
>
> v1: https://lore.kernel.org/lkml/20211122064126.76734-1-ligang.bdlg@bytedance.com/
>
> ---
>  mm/shmem.c | 35 ++++++++++++++++++++---------------
>  1 file changed, 20 insertions(+), 15 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 9023103ee7d8..ab2df692bd58 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -569,7 +569,6 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>                 /* inode is about to be evicted */
>                 if (!inode) {
>                         list_del_init(&info->shrinklist);
> -                       removed++;
>                         goto next;
>                 }
>
> @@ -577,15 +576,16 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>                 if (round_up(inode->i_size, PAGE_SIZE) ==
>                                 round_up(inode->i_size, HPAGE_PMD_SIZE)) {
>                         list_move(&info->shrinklist, &to_remove);
> -                       removed++;
>                         goto next;
>                 }
>
>                 list_move(&info->shrinklist, &list);
>  next:
> +               removed++;
>                 if (!--batch)
>                         break;
>         }
> +       sbinfo->shrinklist_len -= removed;
>         spin_unlock(&sbinfo->shrinklist_lock);
>
>         list_for_each_safe(pos, next, &to_remove) {
> @@ -602,7 +602,7 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>                 inode = &info->vfs_inode;
>
>                 if (nr_to_split && split >= nr_to_split)
> -                       goto leave;
> +                       goto move_back;
>
>                 page = find_get_page(inode->i_mapping,
>                                 (inode->i_size & HPAGE_PMD_MASK) >> PAGE_SHIFT);
> @@ -616,38 +616,43 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>                 }
>
>                 /*
> -                * Leave the inode on the list if we failed to lock
> -                * the page at this time.
> +                * Move the inode on the list back to shrinklist if we failed
> +                * to lock the page at this time.
>                  *
>                  * Waiting for the lock may lead to deadlock in the
>                  * reclaim path.
>                  */
>                 if (!trylock_page(page)) {
>                         put_page(page);
> -                       goto leave;
> +                       goto move_back;
>                 }
>
>                 ret = split_huge_page(page);
>                 unlock_page(page);
>                 put_page(page);
>
> -               /* If split failed leave the inode on the list */
> +               /* If split failed move the inode on the list back to shrinklist */
>                 if (ret)
> -                       goto leave;
> +                       goto move_back;
>
>                 split++;
>  drop:
>                 list_del_init(&info->shrinklist);
> -               removed++;
> -leave:
> +               goto put;
> +move_back:
> +               /* inodes that are on @list and will not be deleted must be moved back to
> +                * global list before iput for two reasons:
> +                * 1. iput in lock: iput call shmem_evict_inode, then cause deadlock.
> +                * 2. iput before lock: shmem_evict_inode may grab the inode on @list,
> +                *    which will cause race.
> +                */

Multi-line comment is like the following format.

/*
 * Comment here.
 */

And I also suggest reworking the comments here. Something like:

/*
 * Make sure the inode is either on the global list or deleted from
 * any local list before iput() since it could be deleted in another
 * thread once we put the inode (then the local list is corrupted).
 */

With that.

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

> +               spin_lock(&sbinfo->shrinklist_lock);
> +               list_move(&info->shrinklist, &sbinfo->shrinklist);
> +               sbinfo->shrinklist_len++;
> +               spin_unlock(&sbinfo->shrinklist_lock);
> +put:
>                 iput(inode);
>         }
>
> -       spin_lock(&sbinfo->shrinklist_lock);
> -       list_splice_tail(&list, &sbinfo->shrinklist);
> -       sbinfo->shrinklist_len -= removed;
> -       spin_unlock(&sbinfo->shrinklist_lock);
> -
>         return split;
>  }
>
> --
> 2.20.1
>
