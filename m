Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469CB27C6F2
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730837AbgI2LuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:50:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729109AbgI2Ltk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:49:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7086920702;
        Tue, 29 Sep 2020 11:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380179;
        bh=Q/m+p19fGpSZRNM1q+hlas88GnmrACDglBobpx5O7Rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdr16MeMThmAOCCPuWJoGFq9Nx4vgOnFdtFLf3c4WQJ+Otucog+A6xfjC2z1KJEfG
         1q0OiiFnwQulnE5FgDX6Ods9inqVZo4If4jyv+duIEwof9JwX6Ao60LSf3giREiUIj
         2BHC3GoJ+9lirxU0n42zsry/HzMSEtQCrA+7t38k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gao Xiang <hsiangkao@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        Yang Shi <shy828301@gmail.com>,
        Rafael Aquini <aquini@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 91/99] mm, THP, swap: fix allocating cluster for swapfile by mistake
Date:   Tue, 29 Sep 2020 13:02:14 +0200
Message-Id: <20200929105934.220677499@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit 41663430588c737dd735bad5a0d1ba325dcabd59 upstream.

SWP_FS is used to make swap_{read,write}page() go through the
filesystem, and it's only used for swap files over NFS.  So, !SWP_FS
means non NFS for now, it could be either file backed or device backed.
Something similar goes with legacy SWP_FILE.

So in order to achieve the goal of the original patch, SWP_BLKDEV should
be used instead.

FS corruption can be observed with SSD device + XFS + fragmented
swapfile due to CONFIG_THP_SWAP=y.

I reproduced the issue with the following details:

Environment:

  QEMU + upstream kernel + buildroot + NVMe (2 GB)

Kernel config:

  CONFIG_BLK_DEV_NVME=y
  CONFIG_THP_SWAP=y

Some reproducible steps:

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

Fixes: f0eea189e8e9 ("mm, THP, swap: Don't allocate huge cluster for file backed swap device")
Fixes: 38d8b4e6bdc8 ("mm, THP, swap: delay splitting THP during swap out")
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Carlos Maiolino <cmaiolino@redhat.com>
Cc: Eric Sandeen <esandeen@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20200820045323.7809-1-hsiangkao@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1074,7 +1074,7 @@ start_over:
 			goto nextsi;
 		}
 		if (size == SWAPFILE_CLUSTER) {
-			if (!(si->flags & SWP_FS))
+			if (si->flags & SWP_BLKDEV)
 				n_ret = swap_alloc_cluster(si, swp_entries);
 		} else
 			n_ret = scan_swap_map_slots(si, SWAP_HAS_CACHE,


