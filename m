Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF3665D9AE
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239885AbjADQ1C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239910AbjADQ07 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:26:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423BA3D1D3
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:26:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A660161798
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:26:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A435C433D2;
        Wed,  4 Jan 2023 16:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849617;
        bh=+ky/T4rRKQ6CMcI+XRS4OfAEZaD6uWMt99Y/01oJ3NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0jvr72dY3ssf9eDO8z7mu0WPM7Y7yo9aF7qFT4J/Rg6kK6c0tsWYqYAYbsRVpatFh
         YB/m+h3E8yRl9Tzp9m3Fiwb4eMV0ftjEhiCrlpucd0QYz6tXgHTP55Vs1r6541B0vc
         sWTgc8uo5z6OnrLLT4q1oa47i5dus6QgNYcJNhzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+4faa160fa96bfba639f8@syzkaller.appspotmail.com,
        Jun Nie <jun.nie@linaro.org>, Ye Bin <yebin10@huawei.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 6.0 163/177] ext4: fix kernel BUG in ext4_write_inline_data_end()
Date:   Wed,  4 Jan 2023 17:07:34 +0100
Message-Id: <20230104160512.616592144@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

commit 5c099c4fdc438014d5893629e70a8ba934433ee8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1315,7 +1315,8 @@ static int ext4_write_end(struct file *f
 
 	trace_ext4_write_end(inode, pos, len, copied);
 
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		return ext4_write_inline_data_end(inode, pos, len, copied, page);
 
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);


