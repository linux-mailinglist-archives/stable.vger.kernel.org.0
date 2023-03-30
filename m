Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9FE6D071B
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 15:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjC3NnO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 09:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjC3NnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 09:43:13 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA19ABDCB
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 06:42:42 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j11so24541968lfg.13
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 06:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680183758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ciy/j7+gGpGGitemo6zgFmtrTpHLEWhuusaBGl9ec5Q=;
        b=T+UONiVles7QSlLTBwZEbV0faj7CrqST29KkE+UlBDfk7bionukH/9OM0YOq9zjxoa
         T+Op4cMRQRAqxVBYeLCLucVKivl+yDUkckhKbad/XGjaoZJLVLYn25+4lBGVHD97Zhto
         2I6REBckOisb962zv73UkrhIsjjZvSC8UGOmAYgIx/Ba54siHP8uHtIZfRHkN3t9/G4E
         oAzUcgWff8/tg2JjxRk941gyU3OI7PNtro/T/zZqQdLVXy8ysbTwDEGgkKh2juv5FzYL
         Hdxu+8QoUr5c6njEEhXx/9d+rGA7XDmmzA8yzbfApVBzGrx724SSQCQLZuezrYRCRAI4
         17sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680183758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ciy/j7+gGpGGitemo6zgFmtrTpHLEWhuusaBGl9ec5Q=;
        b=VaK6e0DqOvsav/o2l03CAuS1WyAuyYZ19QFDIqLuw4waKSfTv9Fex+z1uqm7YTi2KX
         oHUsaDnEkircaDYsjS/y0Fys9UYcaPqoAvixoTOrAE29DgRnkmD0NaTqn/Q9CfUy8Xp1
         b9ZHVDYrq5NZid2yHwl9U+1BpkYwiY1DZ/c/ADuPnzqy8LVZbdgdXlfIKayOm3Qbjkfa
         RVW9NbK4k5hZPEVE6DN0n7VSRWudbir9NU0e1OvPlci0BHzTy7jZY9hhqaP2iM3BrO6U
         RtOPc1imPXYgJvYxeeNzG5ZsfEJjA21+wcxGE0FCyi7wN5LUXRtoRV74vQELTZt8M00g
         w6sw==
X-Gm-Message-State: AAQBX9cjaOZDnbrb+yp70DZA3ZW0LReJbwXlqrY9BvDlT34dw9xha43e
        hv4toZbJG4qcPOBT+qT5kony6w==
X-Google-Smtp-Source: AKy350Y9KerGNjDv64cU9kzSoNCuewKUv+cuq95fj5p1J7M64jevLHIqZYRQP8Mws6GAvR+hqn/Zcg==
X-Received: by 2002:a19:7003:0:b0:4dd:af76:d3c with SMTP id h3-20020a197003000000b004ddaf760d3cmr7640686lfc.48.1680183757940;
        Thu, 30 Mar 2023 06:42:37 -0700 (PDT)
Received: from ta1.c.googlers.com.com (61.215.228.35.bc.googleusercontent.com. [35.228.215.61])
        by smtp.gmail.com with ESMTPSA id m10-20020ac2428a000000b004b6f00832cesm5848001lfh.166.2023.03.30.06.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 06:42:37 -0700 (PDT)
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca, boyu.mt@taobao.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        leejones@google.com, yebin10@huawei.com,
        syzbot+4faa160fa96bfba639f8@syzkaller.appspotmail.com,
        jun.nie@linaro.org, stable@kernel.org,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH v2][for-stable 5.10, 5.4, 4.19, 4.14] ext4: fix kernel BUG in 'ext4_write_inline_data_end()'
Date:   Thu, 30 Mar 2023 13:42:33 +0000
Message-Id: <20230330134233.3407390-1-tudor.ambarus@linaro.org>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 5c099c4fdc438014d5893629e70a8ba934433ee8 ]

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
[ta: Fix conflict in if expression and use the local variable inline_data
as it is initialized with ext4_has_inline_data(inode) anyway.]
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
---
v2: update description on how the conflict was fixed

 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6ba185b46ba3..9bd5f8b0511b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1303,7 +1303,8 @@ static int ext4_write_end(struct file *file,
 	bool verity = ext4_verity_in_progress(inode);
 
 	trace_ext4_write_end(inode, pos, len, copied);
-	if (inline_data) {
+	if (inline_data &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
 		ret = ext4_write_inline_data_end(inode, pos, len,
 						 copied, page);
 		if (ret < 0) {
-- 
2.40.0.348.gf938b09366-goog

