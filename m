Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E8224A77F
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 22:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHSUIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 16:08:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbgHSUIm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 16:08:42 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 381BF207FF;
        Wed, 19 Aug 2020 20:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597867721;
        bh=7k+9WMddfuJ0F9Ua6gbFbUCP9jsYN5UcnCcqFl2Wvac=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=CFxuI9n2O2QZwNj9nE4wa8jMIXHW7wfgXKfbYh3H/hBk61wXwIH2J8ESVDqlo0zp2
         e09BFkscy794gvuoHksvktsEJyuc4pWNTReedOogK/1cpVQoeg5s2y/W+95sLSF83W
         ZupMeE0jvny6GNwQ8ISDuwrJrFcl3tNLzVigZziU=
Date:   Wed, 19 Aug 2020 13:08:40 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     hsiangkao@redhat.com, mm-commits@vger.kernel.org,
        stable@vger.kernel.org, ying.huang@intel.com
Subject:  +
 mm-thp-swap-fix-allocating-cluster-for-swapfile-by-mistake.patch added to
 -mm tree
Message-ID: <20200819200840.LXlYKh31y%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: fix allocating cluster for swapfile by mistake
has been added to the -mm tree.  Its filename is
     mm-thp-swap-fix-allocating-cluster-for-swapfile-by-mistake.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-swap-fix-allocating-cluster-for-swapfile-by-mistake.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-swap-fix-allocating-cluster-for-swapfile-by-mistake.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gao Xiang <hsiangkao@redhat.com>
Subject: mm, THP, swap: fix allocating cluster for swapfile by mistake

SWP_FS doesn't mean the device is file-backed swap device, which just
means each writeback request should go through fs by DIO.  Or it'll just
use extents added by .swap_activate(), but it also works as file-backed
swap device.

So in order to achieve the goal of the original patch, SWP_BLKDEV should
be used instead.

FS corruption can be observed with SSD device + XFS + fragmented swapfile
due to CONFIG_THP_SWAP=y.

I reproduced the issue with the following details:

Environment:
QEMU + upstream kernel + buildroot + NVMe (2 GB)

Kernel config:
CONFIG_BLK_DEV_NVME=y
CONFIG_THP_SWAP=y

Some reproducable steps:
mkfs.xfs -f /dev/nvme0n1
mkdir /tmp/mnt
mount /dev/nvme0n1 /tmp/mnt
bs="32k"
sz="1024m"    # doesn't matter too much, I also tried 16m
xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
xfs_io -f -c "pwrite -F -S 0 -b $bs 0 $sz" -c "fdatasync" /tmp/mnt/sw
xfs_io -f -c "pwrite -R -b $bs 0 $sz" -c "fsync" /tmp/mnt/sw

mkswap /tmp/mnt/sw
swapon /tmp/mnt/sw

stress --vm 2 --vm-bytes 600M   # doesn't matter too much as well

Symptoms:
 - FS corruption (e.g. checksum failure)
 - memory corruption at: 0xd2808010
 - segfault

Link: https://lkml.kernel.org/r/20200819195613.24269-1-hsiangkao@redhat.com
Fixes: f0eea189e8e9 ("mm, THP, swap: Don't allocate huge cluster for file backed swap device")
Fixes: 38d8b4e6bdc8 ("mm, THP, swap: delay splitting THP during swap out")
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-thp-swap-fix-allocating-cluster-for-swapfile-by-mistake
+++ a/mm/swapfile.c
@@ -1078,7 +1078,7 @@ start_over:
 			goto nextsi;
 		}
 		if (size == SWAPFILE_CLUSTER) {
-			if (!(si->flags & SWP_FS))
+			if (si->flags & SWP_BLKDEV)
 				n_ret = swap_alloc_cluster(si, swp_entries);
 		} else
 			n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,
_

Patches currently in -mm which might be from hsiangkao@redhat.com are

mm-thp-swap-fix-allocating-cluster-for-swapfile-by-mistake.patch

