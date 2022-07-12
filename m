Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64E0D5724AB
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbiGLTF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbiGLTEt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:04:49 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1E0E192C
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 11:50:43 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g4so8424986pgc.1
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 11:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xJnmi2tg90RIvDUjfIuMtD/dW52577mkIZjdxV7S4+U=;
        b=kyLpnVValVYvtCXSJoO3EIJLEgKt3aKIeUGqfEotBgFaJ8XlHuRkKja4Tesrk2Ta25
         VCViiTrVdKJWcSAopLBJwc5urcD/OZBgP4oAlCXfB6bhg3t8CSBrcXB5him9x/LCvqwe
         +xFvQKgtrbS1LCLdAvTQmW/7EYWzkeCgrD/sF7M7M2z/t7/fEt7YoThIfKf6SesQgjZI
         Q2hhMnHZU119xnz3GgFO9njAUnKpGVaS23G0iXKKFkSs9qVxDK4D+b5cMWLwcVO+Hq0I
         xz0XUTiicqg0reJN3TQUlFy9PwbcmMj7U8GeEJmaYIPBoinUVnEPfhbxe+VLOO6/g/sl
         +bug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xJnmi2tg90RIvDUjfIuMtD/dW52577mkIZjdxV7S4+U=;
        b=DPXcoIuiY4Yzt+iXe3Pv2PUVnRWoUKRV3VptB4l7r8f/JaWu31EDOR5WeOOYSZGRq5
         F+iS6C9eDjuelEsJSAg82GkJvnHs99iTOs6m9UBWG2TOZEUBvvWZDgXd1/ggL3LnwkF3
         whmqHfU1JRg5aVJS5Wpz4fxpBX4mIN8UN9Um+CgbUua26ZA+RVW8NqAwmMAOHycNkoH/
         XrhIX4I9mL6/9HelrxPLpkDCMQgmw3we3sBPPPMJ0w3fpB/Z7KKALTHqciG85UiGtwAs
         /EbnS3gM/Q5OftYJEnYvEwOtsi/VMIwhOGpP3evXGvmLAFA0YN7gDCrwX1lNX+wN9KiE
         HijQ==
X-Gm-Message-State: AJIora9aKu0RTjKvg4M0KwsOCgUNgTZtU2rNy+JuH/Avu9wEFmZK1AKY
        jpbWE9ska2d/8fRO7juGUqHVq+UNI/obwA==
X-Google-Smtp-Source: AGRyM1uodObbpH4h8+aRdGIXtKw3pePQvNMuO3a3f8Itwmz/HH07Kh4aMrZnlH3hPYby0/Oqk6bmOg==
X-Received: by 2002:a63:ff0c:0:b0:3fd:29dd:c478 with SMTP id k12-20020a63ff0c000000b003fd29ddc478mr22121520pgi.291.1657651842802;
        Tue, 12 Jul 2022 11:50:42 -0700 (PDT)
Received: from desktop.hsd1.or.comcast.net ([2601:1c0:4c00:ad20:feaa:14ff:fe3a:b225])
        by smtp.gmail.com with ESMTPSA id l1-20020a170902f68100b0016bfbd99f64sm7128941plg.118.2022.07.12.11.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 11:50:42 -0700 (PDT)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     stable@vger.kernel.org
Cc:     Baokun Li <libaokun1@huawei.com>,
        syzbot+2cc95c8e803bc7c9e5cb@syzkaller.appspotmail.com,
        Hulk Robot <hulkci@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>,
        Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: [PATCH 5.10] ext4: fix race condition between ext4_write and ext4_convert_inline_data
Date:   Tue, 12 Jul 2022 11:50:26 -0700
Message-Id: <20220712185026.2801747-1-tadeusz.struk@linaro.org>
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

This is backport to 5.10 stable kernel only.
This patch has already been applied to kernels > 5.10.

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
 fs/ext4/extents.c | 9 +++++----
 fs/ext4/inode.c   | 9 ---------
 2 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6641b74ad462..0f49bf547b84 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4691,16 +4691,17 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 		return -EOPNOTSUPP;
 
 	ext4_fc_start_update(inode);
+	inode_lock(inode);
+	ret = ext4_convert_inline_data(inode);
+	inode_unlock(inode);
+	if (ret)
+		goto exit;
 
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
index 72e3f55f1e07..bd0d0a10ca42 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4042,15 +4042,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 
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
