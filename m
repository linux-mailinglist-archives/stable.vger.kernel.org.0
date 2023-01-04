Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAB265D6E6
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239173AbjADPIO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234875AbjADPIM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:08:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E221706B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:08:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3801BB8169E
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C2FC433EF;
        Wed,  4 Jan 2023 15:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844888;
        bh=BsMeH3nOKfmO/ajClRPz3pHsOffA8sgGmWQviLFjla4=;
        h=Subject:To:Cc:From:Date:From;
        b=HfgbMyS3XSfMahTegRd2YrYG+n1bStIi/Hv4QmVH/RKPDouxdTKWVLVbGoEoiAl4/
         K1OuscdnKElMYgYVXlcG4mKUMhu+Zdxpasd+WfmqTn4a11GJ0JZgR8q3YqPR2o3w8/
         cQWB2uYrjDhLaO8xyqbEOM/FABBiDdqnsoSz4o6A=
Subject: FAILED: patch "[PATCH] ext4: fix kernel BUG in 'ext4_write_inline_data_end()'" failed to apply to 4.9-stable tree
To:     yebin10@huawei.com, jun.nie@linaro.org, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:08:00 +0100
Message-ID: <167284488016124@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

5c099c4fdc43 ("ext4: fix kernel BUG in 'ext4_write_inline_data_end()'")
6984aef59814 ("ext4: factor out write end code of inline file")
55ce2f649b9e ("ext4: correct the error path of ext4_write_inline_data_end()")
4df031ff5876 ("ext4: check and update i_disksize properly")
4209ae12b122 ("ext4: handle ext4_mark_inode_dirty errors")
4337ecd1fe99 ("ext4: remove EXT4_EOFBLOCKS_FL and associated code")
43f816772ff3 ("ext4: make some functions static in extents.c")
9b02e4987ab0 ("ext4: clean up len and offset checks in ext4_fallocate()")
c7df4a1ecb85 ("ext4: work around deleting a file with i_nlink == 0 safely")
8d0d47ea1640 ("Merge branch 'mb/dio' into master")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5c099c4fdc438014d5893629e70a8ba934433ee8 Mon Sep 17 00:00:00 2001
From: Ye Bin <yebin10@huawei.com>
Date: Tue, 6 Dec 2022 22:41:34 +0800
Subject: [PATCH] ext4: fix kernel BUG in 'ext4_write_inline_data_end()'

Syzbot report follow issue:
------------[ cut here ]------------
kernel BUG at fs/ext4/inline.c:227!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 3629 Comm: syz-executor212 Not tainted 6.1.0-rc5-syzkaller-00018-g59d0d52c30d4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:ext4_write_inline_data+0x344/0x3e0 fs/ext4/inline.c:227
RSP: 0018:ffffc90003b3f368 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880704e16c0 RCX: 0000000000000000
RDX: ffff888021763a80 RSI: ffffffff821e31a4 RDI: 0000000000000006
RBP: 000000000006818e R08: 0000000000000006 R09: 0000000000068199
R10: 0000000000000079 R11: 0000000000000000 R12: 000000000000000b
R13: 0000000000068199 R14: ffffc90003b3f408 R15: ffff8880704e1c82
FS:  000055555723e3c0(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fffe8ac9080 CR3: 0000000079f81000 CR4: 0000000000350ee0
Call Trace:
 <TASK>
 ext4_write_inline_data_end+0x2a3/0x12f0 fs/ext4/inline.c:768
 ext4_write_end+0x242/0xdd0 fs/ext4/inode.c:1313
 ext4_da_write_end+0x3ed/0xa30 fs/ext4/inode.c:3063
 generic_perform_write+0x316/0x570 mm/filemap.c:3764
 ext4_buffered_write_iter+0x15b/0x460 fs/ext4/file.c:285
 ext4_file_write_iter+0x8bc/0x16e0 fs/ext4/file.c:700
 call_write_iter include/linux/fs.h:2191 [inline]
 do_iter_readv_writev+0x20b/0x3b0 fs/read_write.c:735
 do_iter_write+0x182/0x700 fs/read_write.c:861
 vfs_iter_write+0x74/0xa0 fs/read_write.c:902
 iter_file_splice_write+0x745/0xc90 fs/splice.c:686
 do_splice_from fs/splice.c:764 [inline]
 direct_splice_actor+0x114/0x180 fs/splice.c:931
 splice_direct_to_actor+0x335/0x8a0 fs/splice.c:886
 do_splice_direct+0x1ab/0x280 fs/splice.c:974
 do_sendfile+0xb19/0x1270 fs/read_write.c:1255
 __do_sys_sendfile64 fs/read_write.c:1323 [inline]
 __se_sys_sendfile64 fs/read_write.c:1309 [inline]
 __x64_sys_sendfile64+0x1d0/0x210 fs/read_write.c:1309
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
---[ end trace 0000000000000000 ]---

Above issue may happens as follows:
ext4_da_write_begin
  ext4_da_write_inline_data_begin
    ext4_da_convert_inline_data_to_extent
      ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
ext4_da_write_end

ext4_run_li_request
  ext4_mb_prefetch
    ext4_read_block_bitmap_nowait
      ext4_validate_block_bitmap
        ext4_mark_group_bitmap_corrupted(sb, block_group, EXT4_GROUP_INFO_BBITMAP_CORRUPT)
	 percpu_counter_sub(&sbi->s_freeclusters_counter,grp->bb_free);
	  -> sbi->s_freeclusters_counter become zero
ext4_da_write_begin
  if (ext4_nonda_switch(inode->i_sb)) -> As freeclusters_counter is zero will return true
    *fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
    ext4_write_begin
ext4_da_write_end
  if (write_mode == FALL_BACK_TO_NONDELALLOC)
    ext4_write_end
      if (inline_data)
        ext4_write_inline_data_end
	  ext4_write_inline_data
	    BUG_ON(pos + len > EXT4_I(inode)->i_inline_size);
           -> As inode is already convert to extent, so 'pos + len' > inline_size
	   -> then trigger BUG.

To solve this issue, instead of checking ext4_has_inline_data() which
is only cleared after data has been written back, check the
EXT4_STATE_MAY_INLINE_DATA flag in ext4_write_end().

Fixes: f19d5870cbf7 ("ext4: add normal write support for inline data")
Reported-by: syzbot+4faa160fa96bfba639f8@syzkaller.appspotmail.com
Reported-by: Jun Nie <jun.nie@linaro.org>
Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20221206144134.1919987-1-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 181bc161b1ac..a0f4d4197a0b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1315,7 +1315,8 @@ static int ext4_write_end(struct file *file,
 
 	trace_ext4_write_end(inode, pos, len, copied);
 
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		return ext4_write_inline_data_end(inode, pos, len, copied, page);
 
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);

