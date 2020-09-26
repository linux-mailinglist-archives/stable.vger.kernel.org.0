Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F5B27969A
	for <lists+stable@lfdr.de>; Sat, 26 Sep 2020 06:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbgIZETD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Sep 2020 00:19:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730033AbgIZETD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Sep 2020 00:19:03 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 136A02076D;
        Sat, 26 Sep 2020 04:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601093942;
        bh=AJxwQo/L+ID93H6tPKPieFQbSPWKO3Vas2ik0yvPZ+s=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Zed3OG/wK9qxn9wnbcZ9fmAs2DU7YwezSNB6Y9AsXjQzhtgMbre9rzAVd6MzH7LQd
         UFtvvFvKJKbQ44+3YsTtarIH+cCOiJ9Ak0aCVJDBRw5pg9eNFrFcJUK5XyPPJXWmos
         6v5fAzaCzSye+xx718QJRjHbtkRgmoCJyqRZbB/g=
Date:   Fri, 25 Sep 2020 21:19:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aquini@redhat.com, cmaiolino@redhat.com,
        david@fromorbit.com, esandeen@redhat.com, hsiangkao@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org,
        ying.huang@intel.com
Subject:  [patch 1/9] mm, THP, swap: fix allocating cluster for
 swapfile by mistake
Message-ID: <20200926041901.P-A_BQZ2V%akpm@linux-foundation.org>
In-Reply-To: <20200925211725.0fea54be9e9715486efea21f@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
