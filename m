Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB2E573D1B
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 21:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiGMT2J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 15:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiGMT2I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 15:28:08 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BFF2CCBD
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 12:28:07 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 72so11381565pge.0
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 12:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G2/nDij6l+rKa5tcaBB3MMr3CZN2Afym4gqpCenG9FU=;
        b=qfN852fskmHUCx1ehzgE3v2PnIm0OlHM03o/BUiDJa7JezBgkdzgQF3BDElyAhKadL
         U2eqEwkS7BNQoypqIg3OZHNCQsqNoRyGAQgY9VXN+nu8ZCalMH4DR0YqYd5ky31KGzyR
         yIyujWpO8aN5AFykzecHOqj+EZSs361DcNMZsHMwr17Ml9jNXEckGjT5zo4QFPaDCQxT
         zSKS4Ht8cmJlGRW/bgzV/i3jkFxGV1ob6UM1b5hnJV/qQASQ3VuI4H9gkZ51xhgamuJI
         rzOW1UiL6WISzUf9PzRwRX9gU+ny2GVdIPiLMUTHuUFKk5B5u14x46dRqO4jIIILwyRF
         lirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G2/nDij6l+rKa5tcaBB3MMr3CZN2Afym4gqpCenG9FU=;
        b=aS+F/LwtnqlzJACxg2xtFNno+khV1jeLhRJp7pk7AMS0mOA8VE8NFZLWarscYbvXUG
         GWWL0FSomS4mScUWR3VppGwAl3NOm7bLw04N2QCpQeB7itVkTFSQn11acyFKks4him/x
         e0jwRK0W2gjvA/mysK0csCaSZZ4zb/xjtD3XALZd73aKunq6C6ecMMMYzIJrvPPzw5su
         juuKjwT7owulPe/DKfyr0xd2x3TkS48Mu2NeUhZD4NxJbdSpk/7WWpVdYw420rvYbTti
         wDjfjNio+zEVZoQF6d+WVxLSZ8cwgFi0a7m7ED4zaMPwRenvVt2/Dk79+FX4xEi51Ul2
         xbcQ==
X-Gm-Message-State: AJIora+5DUDhGs/X9axNt/4Ijn7Cma0DG4BjzpX6Biq3efFJprckBZTN
        8m5wUYgtMwPy86//blNepQpINqiqvpUr5A==
X-Google-Smtp-Source: AGRyM1t4FBOjTMEhCe2cebyFxTaBr2bPOFY9okxcWiatr/NOIp6aTnpHgYAp/o+3VqqZikrtoGhAEg==
X-Received: by 2002:a05:6a00:1da9:b0:52a:c339:c520 with SMTP id z41-20020a056a001da900b0052ac339c520mr4677015pfw.70.1657740487287;
        Wed, 13 Jul 2022 12:28:07 -0700 (PDT)
Received: from desktop.hsd1.or.comcast.net ([2601:1c0:4c00:ad20:feaa:14ff:fe3a:b225])
        by smtp.gmail.com with ESMTPSA id i68-20020a626d47000000b005255263a864sm9173009pfc.169.2022.07.13.12.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 12:28:06 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     stable@vger.kernel.org
Cc:     Baokun Li <libaokun1@huawei.com>,
        syzbot+2cc95c8e803bc7c9e5cb@syzkaller.appspotmail.com,
        Hulk Robot <hulkci@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH v5.4] ext4: fix race condition between ext4_write and ext4_convert_inline_data
Date:   Wed, 13 Jul 2022 12:27:55 -0700
Message-Id: <20220713192755.66019-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

This is backport to 5.4 stable kernel.
It fixes an issue reported by syzkaller.

commit f87c7a4b084afc13190cbb263538e444cb2b392a upstream

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
Reported-by: syzbot+2cc95c8e803bc7c9e5cb@syzkaller.appspotmail.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://syzkaller.appspot.com/bug?id=184195865fd95e1e551f8af0fe43858126d15076
Link: https://lore.kernel.org/r/20220428134031.4153381-1-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 fs/ext4/extents.c | 8 +++++---
 fs/ext4/inode.c   | 9 ---------
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index f1bbce4350c4..d5e649e578cb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4932,13 +4932,15 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
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
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1cac574911a7..d8fee911d4f4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4322,15 +4322,6 @@ int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
 
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
-- 
2.36.1
