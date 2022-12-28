Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338246582FB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234970AbiL1Qny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiL1Qn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:43:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7030B49
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:37:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FD7DB8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BA8C433EF;
        Wed, 28 Dec 2022 16:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245458;
        bh=3UcKbcofwLkR8kAs0YAUDXkw+/DMlnfihZ75Bgz68dI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kmiKV4oRq8AOKWuQI7rfvZQLXbP8HZeLC5zGIjju82CLvdwzyqSo+wZCc2HXhoc2G
         T16dAco5RxFNrtsHUhkN/Dzxl60dgJxc8TIX4LvDPQuGCnTtJPGe7BH6NdE4TMX9vZ
         o5UOi28yvycBQYLsPsQd1rp6dEH3bI25Qg2IU8Z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+e91619dd4c11c4960706@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0899/1073] nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()
Date:   Wed, 28 Dec 2022 15:41:27 +0100
Message-Id: <20221228144352.447847168@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 610a2a3d7d8be3537458a378ec69396a76c385b6 ]

Patch series "nilfs2: fix UBSAN shift-out-of-bounds warnings on mount
time".

The first patch fixes a bug reported by syzbot, and the second one fixes
the remaining bug of the same kind.  Although they are triggered by the
same super block data anomaly, I divided it into the above two because the
details of the issues and how to fix it are different.

Both are required to eliminate the shift-out-of-bounds issues at mount
time.

This patch (of 2):

If the block size exponent information written in an on-disk superblock is
corrupted, nilfs_sb2_bad_offset helper function can trigger
shift-out-of-bounds warning followed by a kernel panic (if panic_on_warn
is set):

 shift exponent 38983 is too large for 64-bit type 'unsigned long long'
 Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0x1b1/0x28e lib/dump_stack.c:106
  ubsan_epilogue lib/ubsan.c:151 [inline]
  __ubsan_handle_shift_out_of_bounds+0x33d/0x3b0 lib/ubsan.c:322
  nilfs_sb2_bad_offset fs/nilfs2/the_nilfs.c:449 [inline]
  nilfs_load_super_block+0xdf5/0xe00 fs/nilfs2/the_nilfs.c:523
  init_nilfs+0xb7/0x7d0 fs/nilfs2/the_nilfs.c:577
  nilfs_fill_super+0xb1/0x5d0 fs/nilfs2/super.c:1047
  nilfs_mount+0x613/0x9b0 fs/nilfs2/super.c:1317
  ...

In addition, since nilfs_sb2_bad_offset() performs multiplication without
considering the upper bound, the computation may overflow if the disk
layout parameters are not normal.

This fixes these issues by inserting preliminary sanity checks for those
parameters and by converting the comparison from one involving
multiplication and left bit-shifting to one using division and right
bit-shifting.

Link: https://lkml.kernel.org/r/20221027044306.42774-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20221027044306.42774-2-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+e91619dd4c11c4960706@syzkaller.appspotmail.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/the_nilfs.c | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index c8b89b4f94e0..a7c829a7d4f1 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -13,6 +13,7 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/random.h>
+#include <linux/log2.h>
 #include <linux/crc32.h>
 #include "nilfs.h"
 #include "segment.h"
@@ -443,11 +444,33 @@ static int nilfs_valid_sb(struct nilfs_super_block *sbp)
 	return crc == le32_to_cpu(sbp->s_sum);
 }
 
-static int nilfs_sb2_bad_offset(struct nilfs_super_block *sbp, u64 offset)
+/**
+ * nilfs_sb2_bad_offset - check the location of the second superblock
+ * @sbp: superblock raw data buffer
+ * @offset: byte offset of second superblock calculated from device size
+ *
+ * nilfs_sb2_bad_offset() checks if the position on the second
+ * superblock is valid or not based on the filesystem parameters
+ * stored in @sbp.  If @offset points to a location within the segment
+ * area, or if the parameters themselves are not normal, it is
+ * determined to be invalid.
+ *
+ * Return Value: true if invalid, false if valid.
+ */
+static bool nilfs_sb2_bad_offset(struct nilfs_super_block *sbp, u64 offset)
 {
-	return offset < ((le64_to_cpu(sbp->s_nsegments) *
-			  le32_to_cpu(sbp->s_blocks_per_segment)) <<
-			 (le32_to_cpu(sbp->s_log_block_size) + 10));
+	unsigned int shift_bits = le32_to_cpu(sbp->s_log_block_size);
+	u32 blocks_per_segment = le32_to_cpu(sbp->s_blocks_per_segment);
+	u64 nsegments = le64_to_cpu(sbp->s_nsegments);
+	u64 index;
+
+	if (blocks_per_segment < NILFS_SEG_MIN_BLOCKS ||
+	    shift_bits > ilog2(NILFS_MAX_BLOCK_SIZE) - BLOCK_SIZE_BITS)
+		return true;
+
+	index = offset >> (shift_bits + BLOCK_SIZE_BITS);
+	do_div(index, blocks_per_segment);
+	return index < nsegments;
 }
 
 static void nilfs_release_super_block(struct the_nilfs *nilfs)
-- 
2.35.1



