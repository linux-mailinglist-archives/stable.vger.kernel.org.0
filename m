Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3606820DEF4
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733004AbgF2Ua7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:30:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbgF2TZT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14E01253DB;
        Mon, 29 Jun 2020 15:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445317;
        bh=q+kG1Sa+lQ0cXuiS+umqu2lRV66Ub13zt01QatBAZcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jPuhe1dFp4iQw8wlLao9h3vSfQEQIWsNNKz8EHQpp3S5HavL5B/osqBszAIcm9zZe
         gKDJdDQWiJzSZL3+zpcnJDhkvebFvSJwXiDd4uw7PO/jHIk+21eFQ2QopPbX8INeWc
         gKZJ3NPtK4QUw0UKuW0u2uRL1NfH6uI/8rxf5K8Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jeffle Xu <jefflexu@linux.alibaba.com>,
        Eric Whitney <enwlinux@gmail.com>, stable@kernel.org,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 085/191] ext4: fix partial cluster initialization when splitting extent
Date:   Mon, 29 Jun 2020 11:38:21 -0400
Message-Id: <20200629154007.2495120-86-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffle Xu <jefflexu@linux.alibaba.com>

[ Upstream commit cfb3c85a600c6aa25a2581b3c1c4db3460f14e46 ]

Fix the bug when calculating the physical block number of the first
block in the split extent.

This bug will cause xfstests shared/298 failure on ext4 with bigalloc
enabled occasionally. Ext4 error messages indicate that previously freed
blocks are being freed again, and the following fsck will fail due to
the inconsistency of block bitmap and bg descriptor.

The following is an example case:

1. First, Initialize a ext4 filesystem with cluster size '16K', block size
'4K', in which case, one cluster contains four blocks.

2. Create one file (e.g., xxx.img) on this ext4 filesystem. Now the extent
tree of this file is like:

...
36864:[0]4:220160
36868:[0]14332:145408
51200:[0]2:231424
...

3. Then execute PUNCH_HOLE fallocate on this file. The hole range is
like:

..
ext4_ext_remove_space: dev 254,16 ino 12 since 49506 end 49506 depth 1
ext4_ext_remove_space: dev 254,16 ino 12 since 49544 end 49546 depth 1
ext4_ext_remove_space: dev 254,16 ino 12 since 49605 end 49607 depth 1
...

4. Then the extent tree of this file after punching is like

...
49507:[0]37:158047
49547:[0]58:158087
...

5. Detailed procedure of punching hole [49544, 49546]

5.1. The block address space:
```
lblk        ~49505  49506   49507~49543     49544~49546    49547~
	  ---------+------+-------------+----------------+--------
	    extent | hole |   extent	|	hole	 | extent
	  ---------+------+-------------+----------------+--------
pblk       ~158045  158046  158047~158083  158084~158086   158087~
```

5.2. The detailed layout of cluster 39521:
```
		cluster 39521
	<------------------------------->

		hole		  extent
	<----------------------><--------

lblk      49544   49545   49546   49547
	+-------+-------+-------+-------+
	|	|	|	|	|
	+-------+-------+-------+-------+
pblk     158084  1580845  158086  158087
```

5.3. The ftrace output when punching hole [49544, 49546]:
- ext4_ext_remove_space (start 49544, end 49546)
  - ext4_ext_rm_leaf (start 49544, end 49546, last_extent [49507(158047), 40], partial [pclu 39522 lblk 0 state 2])
    - ext4_remove_blocks (extent [49507(158047), 40], from 49544 to 49546, partial [pclu 39522 lblk 0 state 2]
      - ext4_free_blocks: (block 158084 count 4)
        - ext4_mballoc_free (extent 1/6753/1)

5.4. Ext4 error message in dmesg:
EXT4-fs error (device vdb): mb_free_blocks:1457: group 1, block 158084:freeing already freed block (bit 6753); block bitmap corrupt.
EXT4-fs error (device vdb): ext4_mb_generate_buddy:747: group 1, block bitmap and bg descriptor inconsistent: 19550 vs 19551 free clusters

In this case, the whole cluster 39521 is freed mistakenly when freeing
pblock 158084~158086 (i.e., the first three blocks of this cluster),
although pblock 158087 (the last remaining block of this cluster) has
not been freed yet.

The root cause of this isuue is that, the pclu of the partial cluster is
calculated mistakenly in ext4_ext_remove_space(). The correct
partial_cluster.pclu (i.e., the cluster number of the first block in the
next extent, that is, lblock 49597 (pblock 158086)) should be 39521 rather
than 39522.

Fixes: f4226d9ea400 ("ext4: fix partial cluster initialization")
Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Eric Whitney <enwlinux@gmail.com>
Cc: stable@kernel.org # v3.19+
Link: https://lore.kernel.org/r/1590121124-37096-1-git-send-email-jefflexu@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/extents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 51c2713a615a1..ab19f61bd04bc 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2916,7 +2916,7 @@ int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 			 * in use to avoid freeing it when removing blocks.
 			 */
 			if (sbi->s_cluster_ratio > 1) {
-				pblk = ext4_ext_pblock(ex) + end - ee_block + 2;
+				pblk = ext4_ext_pblock(ex) + end - ee_block + 1;
 				partial_cluster =
 					-(long long) EXT4_B2C(sbi, pblk);
 			}
-- 
2.25.1

