Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BDD5799FA
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238124AbiGSMKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238528AbiGSMIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:08:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C7850053;
        Tue, 19 Jul 2022 05:01:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9455A61718;
        Tue, 19 Jul 2022 12:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406E3C341C6;
        Tue, 19 Jul 2022 12:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232115;
        bh=qbKWgO0NCKXeR6j3EMyJA7WA+N9cl37PJFS7H+0UlYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VoNy2ySTGw0NMRRftnhhMiM0ZhTqOLCMgXZBJesUS+BaARF/e57+mfw6qjB92q/LC
         S/iXPB2qeSzU/fJ9ZMJhSmgKVusvLDvsh01Kavs4Kb0MsalBUzPCyBxqldH+qHUgXA
         kts91MJJQMZiPhsVI4Js4IkOQqGKkRWA8q7HFQkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Baokun Li <libaokun1@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.4 18/71] ext4: fix race condition between ext4_write and ext4_convert_inline_data
Date:   Tue, 19 Jul 2022 13:53:41 +0200
Message-Id: <20220719114554.005626687@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

commit f87c7a4b084afc13190cbb263538e444cb2b392a upstream.

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
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/extents.c |    8 +++++---
 fs/ext4/inode.c   |    9 ---------
 2 files changed, 5 insertions(+), 12 deletions(-)

--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4932,13 +4932,15 @@ long ext4_fallocate(struct file *file, i
 		     FALLOC_FL_INSERT_RANGE))
 		return -EOPNOTSUPP;
 
-	if (mode & FALLOC_FL_PUNCH_HOLE)
-		return ext4_punch_hole(inode, offset, len);
-
+	inode_lock(inode);
 	ret = ext4_convert_inline_data(inode);
+	inode_unlock(inode);
 	if (ret)
 		return ret;
 
+	if (mode & FALLOC_FL_PUNCH_HOLE)
+		return ext4_punch_hole(inode, offset, len);
+
 	if (mode & FALLOC_FL_COLLAPSE_RANGE)
 		return ext4_collapse_range(inode, offset, len);
 
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4322,15 +4322,6 @@ int ext4_punch_hole(struct inode *inode,
 
 	trace_ext4_punch_hole(inode, offset, length, 0);
 
-	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
-	if (ext4_has_inline_data(inode)) {
-		down_write(&EXT4_I(inode)->i_mmap_sem);
-		ret = ext4_convert_inline_data(inode);
-		up_write(&EXT4_I(inode)->i_mmap_sem);
-		if (ret)
-			return ret;
-	}
-
 	/*
 	 * Write out all dirty pages to avoid race conditions
 	 * Then release them.


