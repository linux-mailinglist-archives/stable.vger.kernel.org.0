Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFAEF6E5573
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 01:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjDQXzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 19:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDQXzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 19:55:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B32358C;
        Mon, 17 Apr 2023 16:55:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C8A1621C4;
        Mon, 17 Apr 2023 23:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DCD4C4339C;
        Mon, 17 Apr 2023 23:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681775707;
        bh=EgtqkulILVECeKR2N6I/3hFuaLEzyMmxF2IWfVuKV9g=;
        h=Date:To:From:Subject:From;
        b=RYgi+TfJbnbPXRDYN+eGr+H5h8Df4KA4zsDxeeFB+AqkDznMgsG+FifrgWEkdYEC4
         ALoG4CrmG17lxMhQB0AHPeGdLVRA0hjtny2lUn36ColsNHsQdrgZft6MTkvdaXdL44
         wsLRJMviJuR47q8xfyDMApy/Z2iZNailrjpAKKhE=
Date:   Mon, 17 Apr 2023 16:55:06 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        glider@google.com, konishi.ryusuke@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-initialize-unused-bytes-in-segment-summary-blocks.patch added to mm-hotfixes-unstable branch
Message-Id: <20230417235507.7DCD4C4339C@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: nilfs2: initialize unused bytes in segment summary blocks
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-initialize-unused-bytes-in-segment-summary-blocks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-initialize-unused-bytes-in-segment-summary-blocks.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

nilfs2-initialize-unused-bytes-in-segment-summary-blocks.patch

