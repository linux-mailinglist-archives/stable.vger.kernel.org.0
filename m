Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33AFD66769D
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237853AbjALOdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238490AbjALOdQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:33:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89BB59D2C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:24:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B08FB81E67
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:24:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC86C433D2;
        Thu, 12 Jan 2023 14:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533481;
        bh=IphdAMJ66tqZu+zaLbnpmZ0S25J5Xgvanlbbpz8qojM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7ffKY13uaJTogETn5ojHMf2M9Vx1On9qhSt+y8ViPwxw5FennKlESXT3kILOcxQR
         B/ZKQDovCU4m8mg30noIz179u3DmijaOLJdfCASN2ALOYduS8hztspCJFIl96wBCo/
         umROUDYCGiGvqQ4Ox4c0nO438+H/WE+jWBHOhzzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+e91619dd4c11c4960706@syzkaller.appspotmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 492/783] nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()
Date:   Thu, 12 Jan 2023 14:53:28 +0100
Message-Id: <20230112135547.009846757@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index ce103dd39b89..6e2ccdd79c89 100644
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



