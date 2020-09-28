Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BE627B6E0
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 23:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgI1VOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 17:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgI1VOe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 17:14:34 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AF4A2083B;
        Mon, 28 Sep 2020 21:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601327673;
        bh=tjsTkIRXqjHLGw6LDuNrYJt7zXExe3VVCx0YnixlVl4=;
        h=Date:From:To:Subject:From;
        b=Sl58rgrLz9napzoJVIUlKi/rTUbcClkZYViCMD4Dj++Bke/K1LqEDhnjblIJxHnVW
         gm5p3nl/upD3/qCpaBJG75KtILeUCj40eCmJ+Ui6cBqemKNm7LLZDxAEeuXmVlIvdJ
         KrA4jPHeWVFDyfp45yHxqZT9V2omKP4hnIUku33s=
Date:   Mon, 28 Sep 2020 14:14:32 -0700
From:   akpm@linux-foundation.org
To:     aquini@redhat.com, cmaiolino@redhat.com, david@fromorbit.com,
        esandeen@redhat.com, hsiangkao@redhat.com,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        stable@vger.kernel.org, willy@infradead.org, ying.huang@intel.com
Subject:  [merged]
 mm-thp-swap-fix-allocating-cluster-for-swapfile-by-mistake.patch removed
 from -mm tree
Message-ID: <20200928211432.2CKpALyN-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm, THP, swap: fix allocating cluster for swapfile by mistake
has been removed from the -mm tree.  Its filename was
     mm-thp-swap-fix-allocating-cluster-for-swapfile-by-mistake.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gao Xiang <hsiangkao@redhat.com>
Subject: mm, THP, swap: fix allocating cluster for swapfile by mistake

SWP_FS is used to make swap_{read,write}page() go through the filesystem,
and it's only used for swap files over NFS.  So, !SWP_FS means non NFS for
now, it could be either file backed or device backed.  Something similar
goes with legacy SWP_FILE.

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


Link: https://lkml.kernel.org/r/20200820045323.7809-1-hsiangkao@redhat.com
Fixes: f0eea189e8e9 ("mm, THP, swap: Don't allocate huge cluster for file backed swap device")
Fixes: 38d8b4e6bdc8 ("mm, THP, swap: delay splitting THP during swap out")
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Eric Sandeen <esandeen@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
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

swap-rename-swp_fs-to-swap_fs_ops-to-avoid-ambiguity.patch

