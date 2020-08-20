Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1600F24ADE4
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 06:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725290AbgHTEgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 00:36:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:65063 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbgHTEgN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 00:36:13 -0400
IronPort-SDR: EW+jL4UfldUyx7WdE1ZLG5hOO8YRtJcyK03m56F3eV9kvoGVEsB8G4X5aQ7NIPuLstV0ewG/mr
 qfp7fM5SV+Cg==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="216769937"
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="216769937"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 21:36:11 -0700
IronPort-SDR: XZn4dWScW7OdwVe3M0ntHuTNGaiNEarXemCJtZ8yy28pTCGf9mvDtgFnI2DaGKQ/JZA0gjvIPf
 0T0wJyyAuCtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="472488442"
Received: from yhuang-dev.sh.intel.com (HELO yhuang-dev) ([10.239.159.164])
  by orsmga005.jf.intel.com with ESMTP; 19 Aug 2020 21:36:08 -0700
From:   "Huang\, Ying" <ying.huang@intel.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Rafael Aquini <aquini@redhat.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, THP, swap: fix allocating cluster for swapfile by mistake
References: <20200819195613.24269-1-hsiangkao@redhat.com>
Date:   Thu, 20 Aug 2020 12:36:08 +0800
In-Reply-To: <20200819195613.24269-1-hsiangkao@redhat.com> (Gao Xiang's
        message of "Thu, 20 Aug 2020 03:56:13 +0800")
Message-ID: <871rk2x7bb.fsf@yhuang-dev.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gao Xiang <hsiangkao@redhat.com> writes:

> SWP_FS doesn't mean the device is file-backed swap device,
> which just means each writeback request should go through fs
> by DIO. Or it'll just use extents added by .swap_activate(),
> but it also works as file-backed swap device.
>
> So in order to achieve the goal of the original patch,
> SWP_BLKDEV should be used instead.
>
> FS corruption can be observed with SSD device + XFS +
> fragmented swapfile due to CONFIG_THP_SWAP=y.
>
> Fixes: f0eea189e8e9 ("mm, THP, swap: Don't allocate huge cluster for file backed swap device")
> Fixes: 38d8b4e6bdc8 ("mm, THP, swap: delay splitting THP during swap out")
> Cc: "Huang, Ying" <ying.huang@intel.com>
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>

Good catch!  The fix itself looks good me!  Although the description is
a little confusing.

After some digging, it seems that SWP_FS is set on the swap devices
which make swap entry read/write go through the file system specific
callback (now used by swap over NFS only).

Best Regards,
Huang, Ying

> ---
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
>  ... 
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
