Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8D21EB1F8
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 01:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgFAXAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 19:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgFAXAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 19:00:21 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE7EC05BD43;
        Mon,  1 Jun 2020 16:00:20 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id gl26so10802080ejb.11;
        Mon, 01 Jun 2020 16:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RXVWrJM0qErwoZtOlN6QuMQ8iwvgbXwoJOqbVdWAFHY=;
        b=Xbisw2gFUJ2KuoD5GrY5EdEz3hKD2LSX+FXSyf19uB3hWSqL2cyCBBdVSJDzm24eZA
         yRitsX00wWVhri4dWL84YRH/5TPgHP3Or58GNWyhiRsXH4TDc/wnSXC/EfSrc+cQ9uPY
         kmwJr99NcWpT18FIVNRJoylvm9IGChTJIsh7qn8UBxaya6e4j4Pwr/r9CVbhZbZa9ZAg
         jB1b5g4PtmBw+KdloZ4sU05ggtCAKh9Ra2xSDynQSEqQ8IUSTr2usZBUjODc4bw/tCIB
         UzGCGUybJ9iQEN5fa/Pv75q77zFAyuCUpgamDrFOLp2m/m80kfa0XboA4qYvItBNIC5B
         wz9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RXVWrJM0qErwoZtOlN6QuMQ8iwvgbXwoJOqbVdWAFHY=;
        b=e6V5aBVH7R7BVHp0woFsB3c9FeFwc+CmsLz9WY+KiFlFn4h4AkKvsZecZ4yTeGbd1k
         FpxdkmfViPrsllgIMGjOmcVD0PY5C46VvnnzoIj6zPdstQrPqZTwo22z1iZAT5OAvNKp
         TZ27hHas6BmUvGCvdtgEPTxFYrqA+CTgMrjcHO5wTz+7j16jd5lEWAZnKqRLn4fHRJru
         vCglAgYWGvRFSllE0uUih0kPGra3oVSAdFKVxvYDjBG8Vd9j4oBz3COyE7XIgNJcS8x7
         FWxjcIGWuAX7qbRcK19ZoTupXI1M9nkokMek+W/grBMV/oLg6ad2GnxMW6m3a5T2RhLl
         /oZg==
X-Gm-Message-State: AOAM531bmLa6VcAS0VSDoMQYsZyU9nEhAyBqJhqvpJ84PiEelVWHzoxZ
        MpwzdljGCaTR2e/LruySXxjIzf/d6ZXGOal9XjY=
X-Google-Smtp-Source: ABdhPJx71vSqtqi5aHP1BnaPIdrc7rF0WI6Cb4Hk3hNYRuJ+fBfDfxvh0/qTsskaqLy1c/pfzyBqrGbANg415hraRcs=
X-Received: by 2002:a17:906:ae85:: with SMTP id md5mr15533786ejb.213.1591052418869;
 Mon, 01 Jun 2020 16:00:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200601032204.124624-1-gthelen@google.com>
In-Reply-To: <20200601032204.124624-1-gthelen@google.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Mon, 1 Jun 2020 15:59:56 -0700
Message-ID: <CAHbLzkq84qtOqfvP5SmPoAyL+Pyffd9K3108AOYk5yKF03jBmw@mail.gmail.com>
Subject: Re: [PATCH] shmem, memcg: enable memcg aware shrinker
To:     Greg Thelen <gthelen@google.com>
Cc:     Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 31, 2020 at 8:22 PM Greg Thelen <gthelen@google.com> wrote:
>
> Since v4.19 commit b0dedc49a2da ("mm/vmscan.c: iterate only over charged
> shrinkers during memcg shrink_slab()") a memcg aware shrinker is only
> called when the per-memcg per-node shrinker_map indicates that the
> shrinker may have objects to release to the memcg and node.
>
> shmem_unused_huge_count and shmem_unused_huge_scan support the per-tmpfs
> shrinker which advertises per memcg and numa awareness.  The shmem
> shrinker releases memory by splitting hugepages that extend beyond
> i_size.
>
> Shmem does not currently set bits in shrinker_map.  So, starting with
> b0dedc49a2da, memcg reclaim avoids calling the shmem shrinker under
> pressure.  This leads to undeserved memcg OOM kills.
> Example that reliably sees memcg OOM kill in unpatched kernel:
>   FS=/tmp/fs
>   CONTAINER=/cgroup/memory/tmpfs_shrinker
>   mkdir -p $FS
>   mount -t tmpfs -o huge=always nodev $FS
>   # Create 1000 MB container, which shouldn't suffer OOM.
>   mkdir $CONTAINER
>   echo 1000M > $CONTAINER/memory.limit_in_bytes
>   echo $BASHPID >> $CONTAINER/cgroup.procs
>   # Create 4000 files.  Ideally each file uses 4k data page + a little
>   # metadata.  Assume 8k total per-file, 32MB (4000*8k) should easily
>   # fit within container's 1000 MB.  But if data pages use 2MB
>   # hugepages (due to aggressive huge=always) then files consume 8GB,
>   # which hits memcg 1000 MB limit.
>   for i in {1..4000}; do
>     echo . > $FS/$i
>   done

It looks all the inodes which have tail THP beyond i_size are on one
single list, then the shrinker actually just splits the first
nr_to_scan inodes. But since the list is not memcg aware, so it seems
it may split the THPs which are not charged to the victim memcg and
the victim memcg still may suffer from pre-mature oom, right?

>
> v5.4 commit 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg
> aware") maintains the per-node per-memcg shrinker bitmap for THP
> shrinker.  But there's no such logic in shmem.  Make shmem set the
> per-memcg per-node shrinker bits when it modifies inodes to have
> shrinkable pages.
>
> Fixes: b0dedc49a2da ("mm/vmscan.c: iterate only over charged shrinkers during memcg shrink_slab()")
> Cc: <stable@vger.kernel.org> # 4.19+
> Signed-off-by: Greg Thelen <gthelen@google.com>
> ---
>  mm/shmem.c | 61 +++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 35 insertions(+), 26 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index bd8840082c94..e11090f78cb5 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1002,6 +1002,33 @@ static int shmem_getattr(const struct path *path, struct kstat *stat,
>         return 0;
>  }
>
> +/*
> + * Expose inode and optional page to shrinker as having a possibly splittable
> + * hugepage that reaches beyond i_size.
> + */
> +static void shmem_shrinker_add(struct shmem_sb_info *sbinfo,
> +                              struct inode *inode, struct page *page)
> +{
> +       struct shmem_inode_info *info = SHMEM_I(inode);
> +
> +       spin_lock(&sbinfo->shrinklist_lock);
> +       /*
> +        * _careful to defend against unlocked access to ->shrink_list in
> +        * shmem_unused_huge_shrink()
> +        */
> +       if (list_empty_careful(&info->shrinklist)) {
> +               list_add_tail(&info->shrinklist, &sbinfo->shrinklist);
> +               sbinfo->shrinklist_len++;
> +       }
> +       spin_unlock(&sbinfo->shrinklist_lock);
> +
> +#ifdef CONFIG_MEMCG
> +       if (page && PageTransHuge(page))
> +               memcg_set_shrinker_bit(page->mem_cgroup, page_to_nid(page),
> +                                      inode->i_sb->s_shrink.id);
> +#endif
> +}
> +
>  static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
>  {
>         struct inode *inode = d_inode(dentry);
> @@ -1048,17 +1075,13 @@ static int shmem_setattr(struct dentry *dentry, struct iattr *attr)
>                          * to shrink under memory pressure.
>                          */
>                         if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
> -                               spin_lock(&sbinfo->shrinklist_lock);
> -                               /*
> -                                * _careful to defend against unlocked access to
> -                                * ->shrink_list in shmem_unused_huge_shrink()
> -                                */
> -                               if (list_empty_careful(&info->shrinklist)) {
> -                                       list_add_tail(&info->shrinklist,
> -                                                       &sbinfo->shrinklist);
> -                                       sbinfo->shrinklist_len++;
> -                               }
> -                               spin_unlock(&sbinfo->shrinklist_lock);
> +                               struct page *page;
> +
> +                               page = find_get_page(inode->i_mapping,
> +                                       (newsize & HPAGE_PMD_MASK) >> PAGE_SHIFT);
> +                               shmem_shrinker_add(sbinfo, inode, page);
> +                               if (page)
> +                                       put_page(page);
>                         }
>                 }
>         }
> @@ -1889,21 +1912,7 @@ static int shmem_getpage_gfp(struct inode *inode, pgoff_t index,
>         if (PageTransHuge(page) &&
>             DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE) <
>                         hindex + HPAGE_PMD_NR - 1) {
> -               /*
> -                * Part of the huge page is beyond i_size: subject
> -                * to shrink under memory pressure.
> -                */
> -               spin_lock(&sbinfo->shrinklist_lock);
> -               /*
> -                * _careful to defend against unlocked access to
> -                * ->shrink_list in shmem_unused_huge_shrink()
> -                */
> -               if (list_empty_careful(&info->shrinklist)) {
> -                       list_add_tail(&info->shrinklist,
> -                                     &sbinfo->shrinklist);
> -                       sbinfo->shrinklist_len++;
> -               }
> -               spin_unlock(&sbinfo->shrinklist_lock);
> +               shmem_shrinker_add(sbinfo, inode, page);
>         }
>
>         /*
> --
> 2.27.0.rc0.183.gde8f92d652-goog
>
>
