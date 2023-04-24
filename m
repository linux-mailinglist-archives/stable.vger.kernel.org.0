Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284366ECD26
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjDXNVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbjDXNUz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:20:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671455261
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:20:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 474B9621FD
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A6DC433EF;
        Mon, 24 Apr 2023 13:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342436;
        bh=LvP7QrQe49AfyW2vov+5OvXDAGbRc/YpJZlTrayh36o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OPAuZSYkCz79B7bErCtDANb3CtoU0V7rM7s1ZYiCW9AKHLbDXECBcwIzSHsOtXD0
         nOQpQoBgZHqNJnuTHfokGzanytlpEmyGbhkldRyDzMoRRVLLeXYNyCmog7dZoZa+Xe
         Vd0/xGpYrehRPibs5RhQ/hHZQBtcIccBFydCVfA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+048585f3f4227bb2b49b@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 38/73] nilfs2: initialize unused bytes in segment summary blocks
Date:   Mon, 24 Apr 2023 15:16:52 +0200
Message-Id: <20230424131130.371738284@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
References: <20230424131129.040707961@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit ef832747a82dfbc22a3702219cc716f449b24e4a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/segment.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
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
@@ -1531,6 +1550,7 @@ static int nilfs_segctor_collect(struct
 		nadd = min_t(int, nadd << 1, SC_MAX_SEGDELTA);
 		sci->sc_stage = prev_stage;
 	}
+	nilfs_segctor_zeropad_segsum(sci);
 	nilfs_segctor_truncate_segments(sci, sci->sc_curseg, nilfs->ns_sufile);
 	return 0;
 


