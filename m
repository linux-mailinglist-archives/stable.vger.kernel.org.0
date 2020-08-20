Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F28424C286
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 17:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbgHTPvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 11:51:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48246 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728622AbgHTPvl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 11:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597938699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R6ghZf9v2o9kk/8rogKtOdOOtqVr3hm3Y5dvwh2/Dy0=;
        b=g2Ohspesn9N6QBM2rCCWapOMELf6QJeDDGE/+h4SCmV9gtrJwFk8HsP6tcYK50tjeS6wJN
        LQ9ZdLCcfg/rvZofEN1P8Jln5gui54Y61l+uj+QojFe9fn1vJsTb/6TanAe3Svp8Jwh9jl
        NTEU0jbjlM5kZbuYuLyfmEVsuXbY/vE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-lMVDHeFMMuKcctS_nkLwSg-1; Thu, 20 Aug 2020 11:51:37 -0400
X-MC-Unique: lMVDHeFMMuKcctS_nkLwSg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 24DE08030B1;
        Thu, 20 Aug 2020 15:51:36 +0000 (UTC)
Received: from optiplex-lnx (unknown [10.3.128.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EBDDD19C66;
        Thu, 20 Aug 2020 15:51:27 +0000 (UTC)
Date:   Thu, 20 Aug 2020 11:51:25 -0400
From:   Rafael Aquini <aquini@redhat.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Dave Chinner <david@fromorbit.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm, THP, swap: fix allocating cluster for swapfile by
 mistake
Message-ID: <20200820155125.GB3071325@optiplex-lnx>
References: <20200820045323.7809-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820045323.7809-1-hsiangkao@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 12:53:23PM +0800, Gao Xiang wrote:
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
>  			goto nextsi;
>  		}
>  		if (size == SWAPFILE_CLUSTER) {
> -			if (!(si->flags & SWP_FS))
> +			if (si->flags & SWP_BLKDEV)
>  				n_ret = swap_alloc_cluster(si, swp_entries);
>  		} else
>  			n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
> -- 
> 2.18.1
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

