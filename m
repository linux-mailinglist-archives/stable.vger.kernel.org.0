Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6837A63C5FA
	for <lists+stable@lfdr.de>; Tue, 29 Nov 2022 18:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235807AbiK2RA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Nov 2022 12:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236142AbiK2RAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Nov 2022 12:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C470E6D956
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 08:57:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FB9561846
        for <stable@vger.kernel.org>; Tue, 29 Nov 2022 16:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5220BC433D6;
        Tue, 29 Nov 2022 16:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669741029;
        bh=ciFlN59RgJHrqnK7xmBHdJxN/iJSJn/9HP02Eg8mol8=;
        h=Subject:To:Cc:From:Date:From;
        b=OwP7LpJsWwwRSqJsLogo34aRamV16AI4CenHfl+monOzEclLQT0gFNlrmJKUO1DOo
         cpWizXX9mI534gykxN0lRABCXyBuQX+Dz2eL0vjkuUOccRpkJiZGZUorcCOPxutryZ
         ESpbP33sxqUcmyJcJk/PhyWeBzdW+H3dgcLkD2Mc=
Subject: FAILED: patch "[PATCH] ext4: fix use-after-free in ext4_ext_shift_extents" failed to apply to 4.14-stable tree
To:     libaokun1@huawei.com, chengzhihao1@huawei.com, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 29 Nov 2022 17:57:03 +0100
Message-ID: <16697410231194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f6b1a1cf1c3e ("ext4: fix use-after-free in ext4_ext_shift_extents")
1811bc401aa5 ("ext4: refresh the ext4_ext_path struct after dropping i_data_sem.")
4268496e48dc ("ext4: ensure enough credits in ext4_ext_shift_path_extents")
4756ee183f25 ("ext4: use true,false for bool variable")
83448bdfb597 ("ext4: Reserve revoke credits for freed blocks")
fdc3ef882a5d ("jbd2: Reserve space for revoke descriptor blocks")
ec8b6f600e49 ("jbd2: Factor out common parts of stopping and restarting a handle")
5559b2d81b51 ("jbd2: Drop pointless wakeup from jbd2_journal_stop()")
dfaf5ffda227 ("jbd2: Reorganize jbd2_journal_stop()")
a9a8344ee171 ("ext4, jbd2: Provide accessor function for handle credits")
a413036791d0 ("ext4: Provide function to handle transaction restarts")
6cb367c2d1f8 ("ext4: Use ext4_journal_extend() instead of jbd2_journal_extend()")
538bcaa6261b ("jbd2: fix race when writing superblock")
32ea275008d8 ("jbd2: update locking documentation for transaction_t")
fb265c9cb49e ("ext4: add ext4_sb_bread() to disambiguate ENOMEM cases")
53692ec074d0 ("ext4: fix buffer leak in ext4_expand_extra_isize_ea() on error path")
4f32c38b4662 ("ext4: avoid possible double brelse() in add_new_gdb() on error path")
0b02f4c0d6d9 ("ext4: fix reserved cluster accounting at delayed write time")
1dc0aa46e74a ("ext4: add new pending reservation mechanism")
ad431025aecd ("ext4: generalize extents status tree search functions")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f6b1a1cf1c3ee430d3f5e47847047ce789a690aa Mon Sep 17 00:00:00 2001
From: Baokun Li <libaokun1@huawei.com>
Date: Thu, 22 Sep 2022 20:04:34 +0800
Subject: [PATCH] ext4: fix use-after-free in ext4_ext_shift_extents
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Link: https://lore.kernel.org/r/20220922120434.1294789-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f1956288307f..6c399a8b22b3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5184,6 +5184,7 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
 	 * and it is decreased till we reach start.
 	 */
 again:
+	ret = 0;
 	if (SHIFT == SHIFT_LEFT)
 		iterator = &start;
 	else
@@ -5227,14 +5228,21 @@ ext4_ext_shift_extents(struct inode *inode, handle_t *handle,
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

