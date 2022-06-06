Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00CA453EB33
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbiFFMKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbiFFMKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:10:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E9E26563
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 05:10:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DD3DB81813
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 12:10:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078C7C3411D;
        Mon,  6 Jun 2022 12:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654517434;
        bh=kI7JdRNsZvnHcPS+vXrA9kQ3XAWUbtikmoU4Amd3/bU=;
        h=Subject:To:Cc:From:Date:From;
        b=okyrMAWChZGozdG4lGfnYHFeo7x7o2upxvJ2f5cRAJPGGzFT33XaWlxbmvS8L2dMj
         o3G+Ned5F9V7fBuWBQGg8eO7SZrrG3rFF4ulz1mCVVqVNuaM3D56DEhv7hvnifRehK
         w7aOG9u1ILM6GjhIQhIoK3LTf0HES15fEhxJypLE=
Subject: FAILED: patch "[PATCH] ext4: fix race condition between ext4_write and" failed to apply to 4.19-stable tree
To:     libaokun1@huawei.com, hulkci@huawei.com, jack@suse.cz,
        tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 06 Jun 2022 14:10:27 +0200
Message-ID: <16545174276999@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f87c7a4b084afc13190cbb263538e444cb2b392a Mon Sep 17 00:00:00 2001
From: Baokun Li <libaokun1@huawei.com>
Date: Thu, 28 Apr 2022 21:40:31 +0800
Subject: [PATCH] ext4: fix race condition between ext4_write and
 ext4_convert_inline_data

Hulk Robot reported a BUG_ON:
 ==================================================================
 EXT4-fs error (device loop3): ext4_mb_generate_buddy:805: group 0,
 block bitmap and bg descriptor inconsistent: 25 vs 31513 free clusters
 kernel BUG at fs/ext4/ext4_jbd2.c:53!
 invalid opcode: 0000 [#1] SMP KASAN PTI
 CPU: 0 PID: 25371 Comm: syz-executor.3 Not tainted 5.10.0+ #1
 RIP: 0010:ext4_put_nojournal fs/ext4/ext4_jbd2.c:53 [inline]
 RIP: 0010:__ext4_journal_stop+0x10e/0x110 fs/ext4/ext4_jbd2.c:116
 [...]
 Call Trace:
  ext4_write_inline_data_end+0x59a/0x730 fs/ext4/inline.c:795
  generic_perform_write+0x279/0x3c0 mm/filemap.c:3344
  ext4_buffered_write_iter+0x2e3/0x3d0 fs/ext4/file.c:270
  ext4_file_write_iter+0x30a/0x11c0 fs/ext4/file.c:520
  do_iter_readv_writev+0x339/0x3c0 fs/read_write.c:732
  do_iter_write+0x107/0x430 fs/read_write.c:861
  vfs_writev fs/read_write.c:934 [inline]
  do_pwritev+0x1e5/0x380 fs/read_write.c:1031
 [...]
 ==================================================================

Above issue may happen as follows:
           cpu1                     cpu2
__________________________|__________________________
do_pwritev
 vfs_writev
  do_iter_write
   ext4_file_write_iter
    ext4_buffered_write_iter
     generic_perform_write
      ext4_da_write_begin
                           vfs_fallocate
                            ext4_fallocate
                             ext4_convert_inline_data
                              ext4_convert_inline_data_nolock
                               ext4_destroy_inline_data_nolock
                                clear EXT4_STATE_MAY_INLINE_DATA
                               ext4_map_blocks
                                ext4_ext_map_blocks
                                 ext4_mb_new_blocks
                                  ext4_mb_regular_allocator
                                   ext4_mb_good_group_nolock
                                    ext4_mb_init_group
                                     ext4_mb_init_cache
                                      ext4_mb_generate_buddy  --> error
       ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)
                                ext4_restore_inline_data
                                 set EXT4_STATE_MAY_INLINE_DATA
       ext4_block_write_begin
      ext4_da_write_end
       ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)
       ext4_write_inline_data_end
        handle=NULL
        ext4_journal_stop(handle)
         __ext4_journal_stop
          ext4_put_nojournal(handle)
           ref_cnt = (unsigned long)handle
           BUG_ON(ref_cnt == 0)  ---> BUG_ON

The lock held by ext4_convert_inline_data is xattr_sem, but the lock
held by generic_perform_write is i_rwsem. Therefore, the two locks can
be concurrent.

To solve above issue, we add inode_lock() for ext4_convert_inline_data().
At the same time, move ext4_convert_inline_data() in front of
ext4_punch_hole(), remove similar handling from ext4_punch_hole().

Fixes: 0c8d414f163f ("ext4: let fallocate handle inline data correctly")
Cc: stable@vger.kernel.org
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220428134031.4153381-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e473fde6b64b..474479ce76e0 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4693,15 +4693,17 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		     FALLOC_FL_INSERT_RANGE))
 		return -EOPNOTSUPP;
 
+	inode_lock(inode);
+	ret = ext4_convert_inline_data(inode);
+	inode_unlock(inode);
+	if (ret)
+		goto exit;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		ret = ext4_punch_hole(file, offset, len);
 		goto exit;
 	}
 
-	ret = ext4_convert_inline_data(inode);
-	if (ret)
-		goto exit;
-
 	if (mode & FALLOC_FL_COLLAPSE_RANGE) {
 		ret = ext4_collapse_range(file, offset, len);
 		goto exit;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5948bbba28e3..890f769d6e20 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3979,15 +3979,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 
 	trace_ext4_punch_hole(inode, offset, length, 0);
 
-	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
-	if (ext4_has_inline_data(inode)) {
-		filemap_invalidate_lock(mapping);
-		ret = ext4_convert_inline_data(inode);
-		filemap_invalidate_unlock(mapping);
-		if (ret)
-			return ret;
-	}
-
 	/*
 	 * Write out all dirty pages to avoid race conditions
 	 * Then release them.

