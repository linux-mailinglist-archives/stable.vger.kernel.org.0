Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D476ECF07
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbjDXNhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbjDXNha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:37:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B099E9EEB
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07FA8623DB
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA77C433D2;
        Mon, 24 Apr 2023 13:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343410;
        bh=NGy/DCFlIB43PR+L9JioMxEytiBRgGeR/rXqFiYuosY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pF+2CmnuoI08XeQ2C7CJbYuktFI/BT57QkeLsPwPS2a+6ZhHo8SelI/VH5UsM1p3x
         272YbR9ZLa2sBNe0NT02/71t4L/7IaNnDGd4jlg25oIR6NxDIUJiiGaa6Mtm1iY6t9
         iyhNt1F44t4euTol+QwPi2yqp1GVWy5i+7bNX4cw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+048585f3f4227bb2b49b@syzkaller.appspotmail.com,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.14 15/28] nilfs2: initialize unused bytes in segment summary blocks
Date:   Mon, 24 Apr 2023 15:18:36 +0200
Message-Id: <20230424131121.827867590@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
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
@@ -444,6 +444,23 @@ static int nilfs_segctor_reset_segment_b
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
@@ -452,6 +469,7 @@ static int nilfs_segctor_feed_segment(st
 				* The current segment is filled up
 				* (internal code)
 				*/
+	nilfs_segctor_zeropad_segsum(sci);
 	sci->sc_curseg = NILFS_NEXT_SEGBUF(sci->sc_curseg);
 	return nilfs_segctor_reset_segment_buffer(sci);
 }
@@ -556,6 +574,7 @@ static int nilfs_segctor_add_file_block(
 		goto retry;
 	}
 	if (unlikely(required)) {
+		nilfs_segctor_zeropad_segsum(sci);
 		err = nilfs_segbuf_extend_segsum(segbuf);
 		if (unlikely(err))
 			goto failed;
@@ -1544,6 +1563,7 @@ static int nilfs_segctor_collect(struct
 		nadd = min_t(int, nadd << 1, SC_MAX_SEGDELTA);
 		sci->sc_stage = prev_stage;
 	}
+	nilfs_segctor_zeropad_segsum(sci);
 	nilfs_segctor_truncate_segments(sci, sci->sc_curseg, nilfs->ns_sufile);
 	return 0;
 


