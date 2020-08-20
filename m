Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958F224C89E
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 01:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728615AbgHTXe7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 19:34:59 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57828 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728605AbgHTXe6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 19:34:58 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8D0153A4683;
        Fri, 21 Aug 2020 09:34:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k8u50-0007Ze-JP; Fri, 21 Aug 2020 09:34:46 +1000
Date:   Fri, 21 Aug 2020 09:34:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Rafael Aquini <aquini@redhat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm, THP, swap: fix allocating cluster for swapfile by
 mistake
Message-ID: <20200820233446.GB7728@dread.disaster.area>
References: <20200820045323.7809-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820045323.7809-1-hsiangkao@redhat.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QKgWuTDL c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=7-415B0cAAAA:8
        a=xbHa4w0rJhsKUg1b8lYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
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

Ok, so at it's core this is a swap file extent versus THP swap
cluster alignment issue?

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

IOWs, if you don't make this change, does the corruption problem go
away if you align swap extents in iomap_swapfile_add_extent() to
(SWAPFILE_CLUSTER * PAGE_SIZE) instead of just PAGE_SIZE?

I.e. if the swapfile extents are aligned correctly to huge page swap
cluster size and alignment, does the swap clustering optimisations
for swapping THP pages work correctly? And, if so, is there any
performance benefit we get from enabling proper THP swap clustering
on swapfiles?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
