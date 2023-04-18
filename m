Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36816E6E0A
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 23:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjDRVXK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 17:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbjDRVXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 17:23:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E17A27B;
        Tue, 18 Apr 2023 14:22:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4A806393E;
        Tue, 18 Apr 2023 21:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CF0C4339C;
        Tue, 18 Apr 2023 21:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681852969;
        bh=5XXao1oa8SpJ82sdseIg4KOVuy2/gESpZepOq+R1vIw=;
        h=Date:To:From:Subject:From;
        b=UZRD3J9aU94ok+nTRIcsaH9ugyjP6YKJcmwm05JBT8iKaawV3oZHGWLkyPXDj4Lc1
         itAUjielTlxekLZ2a8+JkHzlbf0pTJ2AN1tLY4Xco7A05bmho2rB4J9UvHHE2w5kRA
         0D5ndIkOCWmpccjbAtXB2YKyj8wErB8mkbLmqz0U=
Date:   Tue, 18 Apr 2023 14:22:48 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        glider@google.com, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-initialize-unused-bytes-in-segment-summary-blocks.patch removed from -mm tree
Message-Id: <20230418212249.46CF0C4339C@smtp.kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: nilfs2: initialize unused bytes in segment summary blocks
has been removed from the -mm tree.  Its filename was
     nilfs2-initialize-unused-bytes-in-segment-summary-blocks.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: initialize unused bytes in segment summary blocks
Date: Tue, 18 Apr 2023 02:35:13 +0900

Syzbot still reports uninit-value in nilfs_add_checksums_on_logs() for
KMSAN enabled kernels after applying commit 7397031622e0 ("nilfs2:
initialize "struct nilfs_binfo_dat"->bi_pad field").

This is because the unused bytes at the end of each block in segment
summaries are not initialized.  So this fixes the issue by padding the
unused bytes with null bytes.

Link: https://lkml.kernel.org/r/20230417173513.12598-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+048585f3f4227bb2b49b@syzkaller.appspotmail.com
  Link: https://syzkaller.appspot.com/bug?extid=048585f3f4227bb2b49b
Cc: Alexander Potapenko <glider@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/segment.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/fs/nilfs2/segment.c~nilfs2-initialize-unused-bytes-in-segment-summary-blocks
+++ a/fs/nilfs2/segment.c
@@ -430,6 +430,23 @@ static int nilfs_segctor_reset_segment_b
 	return 0;
 }
 
+/**
+ * nilfs_segctor_zeropad_segsum - zero pad the rest of the segment summary area
+ * @sci: segment constructor object
+ *
+ * nilfs_segctor_zeropad_segsum() zero-fills unallocated space at the end of
+ * the current segment summary block.
+ */
+static void nilfs_segctor_zeropad_segsum(struct nilfs_sc_info *sci)
+{
+	struct nilfs_segsum_pointer *ssp;
+
+	ssp = sci->sc_blk_cnt > 0 ? &sci->sc_binfo_ptr : &sci->sc_finfo_ptr;
+	if (ssp->offset < ssp->bh->b_size)
+		memset(ssp->bh->b_data + ssp->offset, 0,
+		       ssp->bh->b_size - ssp->offset);
+}
+
 static int nilfs_segctor_feed_segment(struct nilfs_sc_info *sci)
 {
 	sci->sc_nblk_this_inc += sci->sc_curseg->sb_sum.nblocks;
@@ -438,6 +455,7 @@ static int nilfs_segctor_feed_segment(st
 				* The current segment is filled up
 				* (internal code)
 				*/
+	nilfs_segctor_zeropad_segsum(sci);
 	sci->sc_curseg = NILFS_NEXT_SEGBUF(sci->sc_curseg);
 	return nilfs_segctor_reset_segment_buffer(sci);
 }
@@ -542,6 +560,7 @@ static int nilfs_segctor_add_file_block(
 		goto retry;
 	}
 	if (unlikely(required)) {
+		nilfs_segctor_zeropad_segsum(sci);
 		err = nilfs_segbuf_extend_segsum(segbuf);
 		if (unlikely(err))
 			goto failed;
@@ -1533,6 +1552,7 @@ static int nilfs_segctor_collect(struct
 		nadd = min_t(int, nadd << 1, SC_MAX_SEGDELTA);
 		sci->sc_stage = prev_stage;
 	}
+	nilfs_segctor_zeropad_segsum(sci);
 	nilfs_segctor_truncate_segments(sci, sci->sc_curseg, nilfs->ns_sufile);
 	return 0;
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


