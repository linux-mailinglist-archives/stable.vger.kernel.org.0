Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C8054983F
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358341AbiFMMGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358685AbiFMMEd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:04:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F086D2CCA4;
        Mon, 13 Jun 2022 03:57:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9B3B61257;
        Mon, 13 Jun 2022 10:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9208C34114;
        Mon, 13 Jun 2022 10:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117857;
        bh=uRPDDsx1s7riDkm4FdUqxl0hiwITvGsKOAy504hjLg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YTHZYWWV0Ce6IP4KxRfELB6jOPjE29S3eRUednL+YUxayUAoJOXmrcmoxxnrF8HRk
         ML8HexmxGjlUJ8Q5gieyQjQEu8hNyhOgbpU3uzF5rJ46nTnaYoAQBhFP0vpJdphd4f
         /LeiDuyQ9knHlsEIow3TCcsdre886HrTlZ83Wmyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: =?UTF-8?q?=5BPATCH=204=2E19=20145/287=5D=20fs-writeback=3A=20writeback=5Fsb=5Finodes=EF=BC=9ARecalculate=20wrote=20according=20skipped=20pages?=
Date:   Mon, 13 Jun 2022 12:09:29 +0200
Message-Id: <20220613094928.273550569@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

commit 68f4c6eba70df70a720188bce95c85570ddfcc87 upstream.

Commit 505a666ee3fc ("writeback: plug writeback in wb_writeback() and
writeback_inodes_wb()") has us holding a plug during wb_writeback, which
may cause a potential ABBA dead lock:

    wb_writeback		fat_file_fsync
blk_start_plug(&plug)
for (;;) {
  iter i-1: some reqs have been added into plug->mq_list  // LOCK A
  iter i:
    progress = __writeback_inodes_wb(wb, work)
    . writeback_sb_inodes // fat's bdev
    .   __writeback_single_inode
    .   . generic_writepages
    .   .   __block_write_full_page
    .   .   . . 	    __generic_file_fsync
    .   .   . . 	      sync_inode_metadata
    .   .   . . 	        writeback_single_inode
    .   .   . . 		  __writeback_single_inode
    .   .   . . 		    fat_write_inode
    .   .   . . 		      __fat_write_inode
    .   .   . . 		        sync_dirty_buffer	// fat's bdev
    .   .   . . 			  lock_buffer(bh)	// LOCK B
    .   .   . . 			    submit_bh
    .   .   . . 			      blk_mq_get_tag	// LOCK A
    .   .   . trylock_buffer(bh)  // LOCK B
    .   .   .   redirty_page_for_writepage
    .   .   .     wbc->pages_skipped++
    .   .   --wbc->nr_to_write
    .   wrote += write_chunk - wbc.nr_to_write  // wrote > 0
    .   requeue_inode
    .     redirty_tail_locked
    if (progress)    // progress > 0
      continue;
  iter i+1:
      queue_io
      // similar process with iter i, infinite for-loop !
}
blk_finish_plug(&plug)   // flush plug won't be called

Above process triggers a hungtask like:
[  399.044861] INFO: task bb:2607 blocked for more than 30 seconds.
[  399.046824]       Not tainted 5.18.0-rc1-00005-gefae4d9eb6a2-dirty
[  399.051539] task:bb              state:D stack:    0 pid: 2607 ppid:
2426 flags:0x00004000
[  399.051556] Call Trace:
[  399.051570]  __schedule+0x480/0x1050
[  399.051592]  schedule+0x92/0x1a0
[  399.051602]  io_schedule+0x22/0x50
[  399.051613]  blk_mq_get_tag+0x1d3/0x3c0
[  399.051640]  __blk_mq_alloc_requests+0x21d/0x3f0
[  399.051657]  blk_mq_submit_bio+0x68d/0xca0
[  399.051674]  __submit_bio+0x1b5/0x2d0
[  399.051708]  submit_bio_noacct+0x34e/0x720
[  399.051718]  submit_bio+0x3b/0x150
[  399.051725]  submit_bh_wbc+0x161/0x230
[  399.051734]  __sync_dirty_buffer+0xd1/0x420
[  399.051744]  sync_dirty_buffer+0x17/0x20
[  399.051750]  __fat_write_inode+0x289/0x310
[  399.051766]  fat_write_inode+0x2a/0xa0
[  399.051783]  __writeback_single_inode+0x53c/0x6f0
[  399.051795]  writeback_single_inode+0x145/0x200
[  399.051803]  sync_inode_metadata+0x45/0x70
[  399.051856]  __generic_file_fsync+0xa3/0x150
[  399.051880]  fat_file_fsync+0x1d/0x80
[  399.051895]  vfs_fsync_range+0x40/0xb0
[  399.051929]  __x64_sys_fsync+0x18/0x30

In my test, 'need_resched()' (which is imported by 590dca3a71 "fs-writeback:
unplug before cond_resched in writeback_sb_inodes") in function
'writeback_sb_inodes()' seldom comes true, unless cond_resched() is deleted
from write_cache_pages().

Fix it by correcting wrote number according number of skipped pages
in writeback_sb_inodes().

Goto Link to find a reproducer.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215837
Cc: stable@vger.kernel.org # v4.3
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20220510133805.1988292-1-chengzhihao1@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1568,11 +1568,12 @@ static long writeback_sb_inodes(struct s
 	};
 	unsigned long start_time = jiffies;
 	long write_chunk;
-	long wrote = 0;  /* count both pages and inodes */
+	long total_wrote = 0;  /* count both pages and inodes */
 
 	while (!list_empty(&wb->b_io)) {
 		struct inode *inode = wb_inode(wb->b_io.prev);
 		struct bdi_writeback *tmp_wb;
+		long wrote;
 
 		if (inode->i_sb != sb) {
 			if (work->sb) {
@@ -1648,7 +1649,9 @@ static long writeback_sb_inodes(struct s
 
 		wbc_detach_inode(&wbc);
 		work->nr_pages -= write_chunk - wbc.nr_to_write;
-		wrote += write_chunk - wbc.nr_to_write;
+		wrote = write_chunk - wbc.nr_to_write - wbc.pages_skipped;
+		wrote = wrote < 0 ? 0 : wrote;
+		total_wrote += wrote;
 
 		if (need_resched()) {
 			/*
@@ -1670,7 +1673,7 @@ static long writeback_sb_inodes(struct s
 		tmp_wb = inode_to_wb_and_lock_list(inode);
 		spin_lock(&inode->i_lock);
 		if (!(inode->i_state & I_DIRTY_ALL))
-			wrote++;
+			total_wrote++;
 		requeue_inode(inode, tmp_wb, &wbc);
 		inode_sync_complete(inode);
 		spin_unlock(&inode->i_lock);
@@ -1684,14 +1687,14 @@ static long writeback_sb_inodes(struct s
 		 * bail out to wb_writeback() often enough to check
 		 * background threshold and other termination conditions.
 		 */
-		if (wrote) {
+		if (total_wrote) {
 			if (time_is_before_jiffies(start_time + HZ / 10UL))
 				break;
 			if (work->nr_pages <= 0)
 				break;
 		}
 	}
-	return wrote;
+	return total_wrote;
 }
 
 static long __writeback_inodes_wb(struct bdi_writeback *wb,


