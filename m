Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5D420DE36
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388829AbgF2UXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732565AbgF2TZc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56C3225349;
        Mon, 29 Jun 2020 15:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445187;
        bh=YQvt4AgL3IdwEuFjsf6V9cIKCbQ8atShrwEL2kGC0R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJRgmqObLbPpwstik7N+UuNz8p4VtpMz8igWBKOTViALlerLYteJFxnfLy1aB+qvR
         yaXO6iqSwmX+Lf0oOIV415T+F99E22A/xdITmUzapP1xjvsqpR3WZ2054oiW8Hw9Mt
         Mpt9NeGvtegSrybJ8h0UvA0RpTdYwe3qh4lQC3Yw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Bin <zhengbin13@huawei.com>,
        Ren Xudong <renxudong1@huawei.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 77/78] xfs: add agf freeblocks verify in xfs_agf_verify
Date:   Mon, 29 Jun 2020 11:38:05 -0400
Message-Id: <20200629153806.2494953-78-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

[ Upstream commit d0c7feaf87678371c2c09b3709400be416b2dc62 ]

We recently used fuzz(hydra) to test XFS and automatically generate
tmp.img(XFS v5 format, but some metadata is wrong)

xfs_repair information(just one AG):
agf_freeblks 0, counted 3224 in ag 0
agf_longest 536874136, counted 3224 in ag 0
sb_fdblocks 613, counted 3228

Test as follows:
mount tmp.img tmpdir
cp file1M tmpdir
sync

In 4.19-stable, sync will stuck, the reason is:
xfs_mountfs
  xfs_check_summary_counts
    if ((!xfs_sb_version_haslazysbcount(&mp->m_sb) ||
       XFS_LAST_UNMOUNT_WAS_CLEAN(mp)) &&
       !xfs_fs_has_sickness(mp, XFS_SICK_FS_COUNTERS))
	return 0;  -->just return, incore sb_fdblocks still be 613
    xfs_initialize_perag_data

cp file1M tmpdir -->ok(write file to pagecache)
sync -->stuck(write pagecache to disk)
xfs_map_blocks
  xfs_iomap_write_allocate
    while (count_fsb != 0) {
      nimaps = 0;
      while (nimaps == 0) { --> endless loop
         nimaps = 1;
         xfs_bmapi_write(..., &nimaps) --> nimaps becomes 0 again
xfs_bmapi_write
  xfs_bmap_alloc
    xfs_bmap_btalloc
      xfs_alloc_vextent
        xfs_alloc_fix_freelist
          xfs_alloc_space_available -->fail(agf_freeblks is 0)

In linux-next, sync not stuck, cause commit c2b3164320b5 ("xfs:
use the latest extent at writeback delalloc conversion time") remove
the above while, dmesg is as follows:
[   55.250114] XFS (loop0): page discard on page ffffea0008bc7380, inode 0x1b0c, offset 0.

Users do not know why this page is discard, the better soultion is:
1. Like xfs_repair, make sure sb_fdblocks is equal to counted
(xfs_initialize_perag_data did this, who is not called at this mount)
2. Add agf verify, if fail, will tell users to repair

This patch use the second soultion.

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Signed-off-by: Ren Xudong <renxudong1@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 516e0c57cf9c4..a10d9a3c181e4 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2529,6 +2529,13 @@ xfs_agf_verify(
 	      be32_to_cpu(agf->agf_flcount) <= xfs_agfl_size(mp)))
 		return false;
 
+	if (be32_to_cpu(agf->agf_length) > mp->m_sb.sb_dblocks)
+		return false;
+
+	if (be32_to_cpu(agf->agf_freeblks) < be32_to_cpu(agf->agf_longest) ||
+	    be32_to_cpu(agf->agf_freeblks) > be32_to_cpu(agf->agf_length))
+		return false;
+
 	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) > XFS_BTREE_MAXLEVELS ||
@@ -2540,6 +2547,10 @@ xfs_agf_verify(
 	     be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS))
 		return false;
 
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_rmap_blocks) > be32_to_cpu(agf->agf_length))
+		return false;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
@@ -2553,6 +2564,11 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return false;
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_refcount_blocks) >
+	    be32_to_cpu(agf->agf_length))
+		return false;
+
 	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
 	    (be32_to_cpu(agf->agf_refcount_level) < 1 ||
 	     be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS))
-- 
2.25.1

