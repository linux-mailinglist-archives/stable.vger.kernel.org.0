Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F7924AE41
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 07:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725778AbgHTFFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 01:05:46 -0400
Received: from mga05.intel.com ([192.55.52.43]:17883 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgHTFFp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 01:05:45 -0400
IronPort-SDR: wehtcBhL0Sbn4S/1dLRB32iaRmCMYILlCo9/+1N079sEIwpNKWeQOHp95/9fFIDMElrw+RIJL7
 hZzNFQmPkoEw==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="240065053"
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="240065053"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 22:05:45 -0700
IronPort-SDR: OZXJvMO5PQiH3Cf2UlhbyGFZwCTjlc8v6u8s9AzvCb+Q1uF/+A1WFMIKnvpDPlYKARZ2UU4xK2
 FFp6QNT31ZVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="320731690"
Received: from yhuang-dev.sh.intel.com (HELO yhuang-dev) ([10.239.159.164])
  by fmsmga004.fm.intel.com with ESMTP; 19 Aug 2020 22:05:43 -0700
From:   "Huang\, Ying" <ying.huang@intel.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        Yang Shi <yang.shi@linux.alibaba.com>,
        Rafael Aquini <aquini@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] mm, THP, swap: fix allocating cluster for swapfile by mistake
References: <20200820045323.7809-1-hsiangkao@redhat.com>
Date:   Thu, 20 Aug 2020 13:05:42 +0800
In-Reply-To: <20200820045323.7809-1-hsiangkao@redhat.com> (Gao Xiang's message
        of "Thu, 20 Aug 2020 12:53:23 +0800")
Message-ID: <87wo1tx5y1.fsf@yhuang-dev.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Gao Xiang <hsiangkao@redhat.com> writes:

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

Thanks!

Reviewed-by: "Huang, Ying" <ying.huang@intel.com>

Best Regards,
Huang, Ying
