Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A8245D3D2
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 05:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbhKYENW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 23:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbhKYELW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 23:11:22 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9CACC061748
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 20:08:11 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id q64so8212584qkd.5
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 20:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dP3yZrGzb9R1iOzqxrTkQjJTMoOKsAT1OEs2kYMMg74=;
        b=udnW4TACgVBEHiQOw5KT9xMkvLQmjdfGlEEGtF2Hz8uc2nycBd4B6q54WvA7dT3suq
         mWpf2x+I5QexmCZ18kCZB4U5h3dyuIHPSmDujKxP4HXA9l3IuN13k4lYeCWZgkJ2LcYp
         SxAybxt8OXRgkCsW5zfR/Z0MQXOquRWWQxJwkOg9hXEuUXJeAggz/sOB/mVhmxoexPsP
         GfVNQ8lDR+EoStUauvz3Jk0PlmHra4DKBYB0AzktF+bAmKTyfSDK2bxHGfNLza+dRgKo
         LhREi4xonYQyRnh89cE0wPp9vpToNaD84B8sOw7iFC87a5UnEtSFDPwxq+Ydc/nUHwEr
         Mq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dP3yZrGzb9R1iOzqxrTkQjJTMoOKsAT1OEs2kYMMg74=;
        b=w6Yco7Oy4pHKV17a4TlE4T47MbNoAo15KSnf8jHkOflkQGUvyZ7fNx8YtXM86xG/2l
         KdQB9yHzSRD8bXuCJ5G+ZdftU5RCo5PbpoycdOsVT9hg1o6c0m1jC+e/bzDwFesDHiR/
         CmzfxoLt9zevD/rO2Ml0fHPKh1U2Mg88DdOvZef60FZGh7E7V0hda5hn6IFgSjuTn79i
         WPZ8Ux1FztmqUKjfytJHel9yp1s06JKUqBIPLDl3HNz4pIcWwCYb0xWLXhey60XyPBdM
         sNJa8Twthuli7i8nkmJcbV4khc9SLCB7i1YhCZt/GICno8yvnofzTHj1Yqv9tV1RhxLL
         hm1Q==
X-Gm-Message-State: AOAM533akV9oZMQHnxT0ZliQdR8TNLymdMGIjg4VhaIBg8WktTYvgFLv
        e7+nV+0x6+OJzzUmAai4LF274dq7C+H7/7AgJnDEEg==
X-Google-Smtp-Source: ABdhPJy66/tQ4CNBBLx69eIsGB+A6cvgvKIrd45tNyK1KRALISbSOii9fareZYyDNTWIUa76/pKptXIYbjQ2uBu+Syo=
X-Received: by 2002:a25:d2ca:: with SMTP id j193mr2903638ybg.419.1637813290882;
 Wed, 24 Nov 2021 20:08:10 -0800 (PST)
MIME-Version: 1.0
References: <20211125031244.89848-1-ligang.bdlg@bytedance.com>
In-Reply-To: <20211125031244.89848-1-ligang.bdlg@bytedance.com>
From:   Muchun Song <songmuchun@bytedance.com>
Date:   Thu, 25 Nov 2021 12:07:31 +0800
Message-ID: <CAMZfGtWo2EDW+U02x2hREhNkmnKvDrMZvO=dumM5y8d0TwEEPg@mail.gmail.com>
Subject: Re: [PATCH v4] shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode
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

On Thu, Nov 25, 2021 at 11:12 AM Gang Li <ligang.bdlg@bytedance.com> wrote:
>
> This patch fixes a data race in commit 779750d20b93 ("shmem: split huge pages
> beyond i_size under memory pressure").
>
> Here are call traces causing race:
>
>    Call Trace 1:
>      shmem_unused_huge_shrink+0x3ae/0x410
>      ? __list_lru_walk_one.isra.5+0x33/0x160
>      super_cache_scan+0x17c/0x190
>      shrink_slab.part.55+0x1ef/0x3f0
>      shrink_node+0x10e/0x330
>      kswapd+0x380/0x740
>      kthread+0xfc/0x130
>      ? mem_cgroup_shrink_node+0x170/0x170
>      ? kthread_create_on_node+0x70/0x70
>      ret_from_fork+0x1f/0x30
>
>    Call Trace 2:
>      shmem_evict_inode+0xd8/0x190
>      evict+0xbe/0x1c0
>      do_unlinkat+0x137/0x330
>      do_syscall_64+0x76/0x120
>      entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>
> A simple explanation:
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
> We should make sure the inode is either on the global list or deleted from
> any local list before iput().
>
> Fixed by moving inodes back to global list before we put them.
>
> Fixes: 779750d20b93 ("shmem: split huge pages beyond i_size under memory pressure")
> Signed-off-by: Gang Li <ligang.bdlg@bytedance.com>

You have forgotten my Reviewed-by and  Kirill A. Shutemov's Acked-by
as well as Cc: stable@vger.kernel.org.

> ---
>  mm/shmem.c | 34 +++++++++++++++++++---------------
>  1 file changed, 19 insertions(+), 15 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 9023103ee7d8..e6ccb2a076ff 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -569,7 +569,6 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>                 /* inode is about to be evicted */
>                 if (!inode) {
>                         list_del_init(&info->shrinklist);
> -                       removed++;

I believe there is a warning about @removed since it's unused.

>                         goto next;
>                 }
>
> @@ -577,12 +576,12 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>                 if (round_up(inode->i_size, PAGE_SIZE) ==
>                                 round_up(inode->i_size, HPAGE_PMD_SIZE)) {
>                         list_move(&info->shrinklist, &to_remove);
> -                       removed++;
>                         goto next;
>                 }
>
>                 list_move(&info->shrinklist, &list);
>  next:
> +               sbinfo->shrinklist_len--;
>                 if (!--batch)
>                         break;
>         }
> @@ -602,7 +601,7 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
>                 inode = &info->vfs_inode;
>
>                 if (nr_to_split && split >= nr_to_split)
> -                       goto leave;
> +                       goto move_back;
>
>                 page = find_get_page(inode->i_mapping,
>                                 (inode->i_size & HPAGE_PMD_MASK) >> PAGE_SHIFT);
> @@ -616,38 +615,43 @@ static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
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
> +               /*
> +               * Make sure the inode is either on the global list or deleted from
> +               * any local list before iput() since it could be deleted in another
> +               * thread once we put the inode (then the local list is corrupted).
> +               */
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
