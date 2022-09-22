Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781A95E61C6
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 13:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231558AbiIVLxx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 07:53:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiIVLxv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 07:53:51 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426299752A;
        Thu, 22 Sep 2022 04:53:50 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MYDCF4mg8zHp14;
        Thu, 22 Sep 2022 19:51:37 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Thu, 22 Sep
 2022 19:53:47 +0800
From:   Baokun Li <libaokun1@huawei.com>
To:     <linux-ext4@vger.kernel.org>
CC:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <jack@suse.cz>,
        <ritesh.list@gmail.com>, <lczerner@redhat.com>,
        <enwlinux@gmail.com>, <linux-kernel@vger.kernel.org>,
        <yi.zhang@huawei.com>, <yebin10@huawei.com>,
        <chengzhihao1@huawei.com>, <yukuai3@huawei.com>,
        <libaokun1@huawei.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] ext4: fix use-after-free in ext4_ext_shift_extents
Date:   Thu, 22 Sep 2022 20:04:34 +0800
Message-ID: <20220922120434.1294789-1-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.127.227]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the starting position of our insert range happens to be in the hole
between the two ext4_extent_idx, because the lblk of the ext4_extent in
the previous ext4_extent_idx is always less than the start, which leads
to the "extent" variable access across the boundary, the following UAF is
triggered:
==================================================================
BUG: KASAN: use-after-free in ext4_ext_shift_extents+0x257/0x790
Read of size 4 at addr ffff88819807a008 by task fallocate/8010
CPU: 3 PID: 8010 Comm: fallocate Tainted: G            E     5.10.0+ #492
Call Trace:
 dump_stack+0x7d/0xa3
 print_address_description.constprop.0+0x1e/0x220
 kasan_report.cold+0x67/0x7f
 ext4_ext_shift_extents+0x257/0x790
 ext4_insert_range+0x5b6/0x700
 ext4_fallocate+0x39e/0x3d0
 vfs_fallocate+0x26f/0x470
 ksys_fallocate+0x3a/0x70
 __x64_sys_fallocate+0x4f/0x60
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
==================================================================

For right shifts, we can divide them into the following situations：

1. When the first ee_block of ext4_extent_idx is greater than or equal to
   start, make right shifts directly from the first ee_block.
    1) If it is greater than start, we need to continue searching in the
       previous ext4_extent_idx.
    2) If it is equal to start, we can exit the loop (iterator=NULL).

2. When the first ee_block of ext4_extent_idx is less than start, then
   traverse from the last extent to find the first extent whose ee_block
   is less than start.
    1) If extent is still the last extent after traversal, it means that
       the last ee_block of ext4_extent_idx is less than start, that is,
       start is located in the hole between idx and (idx+1), so we can
       exit the loop directly (break) without right shifts.
    2) Otherwise, make right shifts at the corresponding position of the
       found extent, and then exit the loop (iterator=NULL).

Fixes: 331573febb6a ("ext4: Add support FALLOC_FL_INSERT_RANGE for fallocate")
Cc: stable@vger.kernel.org # v4.2+
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
V1->V2:
  Initialize "ret" after the "again:" label to avoid return value mismatch.
  Refactoring reduces cycles and makes code more readable.

 fs/ext4/extents.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c148bb97b527..39c9f87de0be 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5179,6 +5179,7 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	 * and it is decreased till we reach start.
 	 */
 again:
+	ret = 0;
 	if (SHIFT == SHIFT_LEFT)
 		iterator = &start;
 	else
@@ -5222,14 +5223,21 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 					ext4_ext_get_actual_len(extent);
 		} else {
 			extent = EXT_FIRST_EXTENT(path[depth].p_hdr);
-			if (le32_to_cpu(extent->ee_block) > 0)
+			if (le32_to_cpu(extent->ee_block) > start)
 				*iterator = le32_to_cpu(extent->ee_block) - 1;
-			else
-				/* Beginning is reached, end of the loop */
+			else if (le32_to_cpu(extent->ee_block) == start)
 				iterator = NULL;
-			/* Update path extent in case we need to stop */
-			while (le32_to_cpu(extent->ee_block) < start)
+			else {
+				extent = EXT_LAST_EXTENT(path[depth].p_hdr);
+				while (le32_to_cpu(extent->ee_block) >= start)
+					extent--;
+
+				if (extent == EXT_LAST_EXTENT(path[depth].p_hdr))
+					break;
+
 				extent++;
+				iterator = NULL;
+			}
 			path[depth].p_ext = extent;
 		}
 		ret = ext4_ext_shift_path_extents(path, shift, inode,
-- 
2.31.1

