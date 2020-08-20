Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6934E24C23D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 17:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgHTPcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 11:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbgHTPcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 11:32:00 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1732AC061385;
        Thu, 20 Aug 2020 08:32:00 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id o18so3000309eje.7;
        Thu, 20 Aug 2020 08:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=msZh1S5NuZX02zho73S2OZYmPkkP6K5y19k9T2pRLlU=;
        b=eEQiNAr7rWImjK6RLknd81QWM9qtZqSYCjD9pFF78tYd4TULEoiAOd8XfONRjXELup
         E4CNQ1gh1sZl0QDdS6kR8HrKAHNfSD+4o0BLmZc4Rt5ObBJHIUcBPiiBhfYSHIsJQGEv
         GOK6LIqNuD/dnKlE0VEvbndrg3mORYdlPSWKgZRcW76Ucd2BJmf1B9QSmhwPCeMoMtM/
         Yng6JQdTv/He2XKn2KdPtyGWPSehTDalQBD2wuBGTb92X89VDQShPYLtgU22ECsgcCb7
         mfTETbXBT2BnlsJ7RTJUySNQnCAtIoC54fKjVRxTl/dkN9JeIok7CTmdO3W9KBDEKZkO
         bIoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=msZh1S5NuZX02zho73S2OZYmPkkP6K5y19k9T2pRLlU=;
        b=QTlFnil6mVQyWvnfyrACdcFe7xUzVI38P9CdLNCkCquvd5tN4laAwxt5f2YJSGjBM8
         HQHQmNrAgDcxzPpyEfZkealtUeaSDICzSH7LuORPkUrSTxfM0ro1nLdV9GmkbXTQPfmC
         sRWnBPFBrXbVGdzjHxFto8mVaRT5/6P5oUMUQpgaemDePipDA2Hzl9qiZKugdJSdN5A8
         9/h+WBgEa4iUL22Ft3OCoxbDjkSjSWaaZatSSoOLmRRErKgpmSf6bve/2tzX/Cj7bUKR
         rlV5FIyOgTe1YovLKQdlvyO9CvIyRBXJ8z4xhe7dWs+X2DxvAqgeNGIS7nbOmeEFNh+3
         bwdA==
X-Gm-Message-State: AOAM532haOYFblxxWoYvoR6C+idtGIGXRYJCTSAwyLk332w8aZUzxaWv
        un3WgSe8aooIsm9yq6sZmpfrxQuX+WTow2+VQ+Y=
X-Google-Smtp-Source: ABdhPJzD+zk0t+nWGD6xbgEYzbLJU9rJ448TkrySkRv6QD+kn8cqo7BHXH1FT90ym+QcSpF3F2Vrku7Pi7nKPbUArzU=
X-Received: by 2002:a17:906:84e1:: with SMTP id zp1mr3535972ejb.499.1597937518785;
 Thu, 20 Aug 2020 08:31:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200820045323.7809-1-hsiangkao@redhat.com>
In-Reply-To: <20200820045323.7809-1-hsiangkao@redhat.com>
From:   Yang Shi <shy828301@gmail.com>
Date:   Thu, 20 Aug 2020 08:31:46 -0700
Message-ID: <CAHbLzkramrQbkQeBBy-ZzHKy6Uqt6ONVxKeouVyu-6_cvFpNmA@mail.gmail.com>
Subject: Re: [PATCH v2] mm, THP, swap: fix allocating cluster for swapfile by mistake
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Rafael Aquini <aquini@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 19, 2020 at 9:54 PM Gao Xiang <hsiangkao@redhat.com> wrote:
>
> SWP_FS is used to make swap_{read,write}page() go through
> the filesystem, and it's only used for swap files over
> NFS. So, !SWP_FS means non NFS for now, it could be either
> file backed or device backed. Something similar goes with
> legacy SWP_FILE.
>
> So in order to achieve the goal of the original patch,
> SWP_BLKDEV should be used instead.
>
> FS corruption can be observed with SSD device + XFS +
> fragmented swapfile due to CONFIG_THP_SWAP=y.
>
> I reproduced the issue with the following details:
>
> Environment:
> QEMU + upstream kernel + buildroot + NVMe (2 GB)
>
> Kernel config:
> CONFIG_BLK_DEV_NVME=y
> CONFIG_THP_SWAP=y
>
> Some reproducable steps:
> mkfs.xfs -f /dev/nvme0n1
> mkdir /tmp/mnt
> mount /dev/nvme0n1 /tmp/mnt
> bs="32k"
> sz="1024m"    # doesn't matter too much, I also tried 16m
> xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
> xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
> xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
> xfs_io -f -c "pwrite -F -S 0 -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
> xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fsync" /tmp/mnt/sw
>
> mkswap /tmp/mnt/sw
> swapon /tmp/mnt/sw
>
> stress --vm 2 --vm-bytes 600M   # doesn't matter too much as well
>
> Symptoms:
>  - FS corruption (e.g. checksum failure)
>  - memory corruption at: 0xd2808010
>  - segfault
>
> Fixes: f0eea189e8e9 ("mm, THP, swap: Don't allocate huge cluster for file backed swap device")
> Fixes: 38d8b4e6bdc8 ("mm, THP, swap: delay splitting THP during swap out")
> Cc: "Huang, Ying" <ying.huang@intel.com>
> Cc: Yang Shi <yang.shi@linux.alibaba.com>
> Cc: Rafael Aquini <aquini@redhat.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> v1: https://lore.kernel.org/r/20200819195613.24269-1-hsiangkao@redhat.com
>
> changes since v1:
>  - improve commit message description

Thanks for incorporating this. Reviewed-by: Yang Shi <shy828301@gmail.com>

>
> Hi Andrew,
> Kindly consider this one instead if no other concerns...
>
> Thanks,
> Gao Xiang
>
>  mm/swapfile.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 6c26916e95fd..2937daf3ca02 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1074,7 +1074,7 @@ int get_swap_pages(int n_goal, swp_entry_t swp_entries[], int entry_size)
>                         goto nextsi;
>                 }
>                 if (size == SWAPFILE_CLUSTER) {
> -                       if (!(si->flags & SWP_FS))
> +                       if (si->flags & SWP_BLKDEV)
>                                 n_ret = swap_alloc_cluster(si, swp_entries);
>                 } else
>                         n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
> --
> 2.18.1
>
>
