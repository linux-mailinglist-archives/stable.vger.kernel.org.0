Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5013A24C71F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 23:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgHTVVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 17:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbgHTVVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 17:21:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D3572076E;
        Thu, 20 Aug 2020 21:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597958513;
        bh=p2gXg9nJIDIsetl5VIzY63aTbOJYO5HutFLqxEJU9CA=;
        h=Date:From:To:Subject:From;
        b=RU1aAQZcEnP/DhZK45YF6rZ2u2yn8CssSIaiQx0Mr+ukmdZc0EZfLZ0FjSOZZNqKn
         H03RLOFbvTY/PIKa532qoHQAnB/O/6uxKFtE5sHjFYru0hAjciT+j0ybLITpVD8S5o
         dZUQdtQQgKqk/d5BMbcu+7jM8YLK49Pi8AYhfjSE=
Date:   Thu, 20 Aug 2020 14:21:50 -0700
From:   akpm@linux-foundation.org
To:     aquini@redhat.com, cmaiolino@redhat.com, esandeen@redhat.com,
        hsiangkao@redhat.com, mm-commits@vger.kernel.org,
        shy828301@gmail.com, stable@vger.kernel.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  +
 mm-thp-swap-fix-allocating-cluster-for-swapfile-by-mistake.patch added to
 -mm tree
Message-ID: <20200820212150.0xnBC1KKQ%akpm@linux-foundation.org>
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

