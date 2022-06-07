Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D1B540EF2
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352707AbiFGS6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353972AbiFGSzT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:55:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF38314B2C5;
        Tue,  7 Jun 2022 11:03:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1F966171C;
        Tue,  7 Jun 2022 18:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F94C3411F;
        Tue,  7 Jun 2022 18:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625036;
        bh=sfIrPoe/Tw/3gsCBONHPPZdTzRMV+EyfeA3glh9/G5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVmN7p6FgjHw6gyHKX+RTx7/vmQIDkiMGPirOMmeex1ffrutq7jtLzRjCHW5eci4b
         HlTI7fSXeTuPAP/lbMZ5UndDdenBDk50gCIruy4//QKuUBm905ZtdRJZkIpTMGUc4C
         2QvvQY1a/SVyHGA+k8k1IktCoblhvD4Z+6NX7ukA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ye Bin <yebin10@huawei.com>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.15 543/667] ext4: fix warning in ext4_handle_inode_extension
Date:   Tue,  7 Jun 2022 19:03:28 +0200
Message-Id: <20220607164950.982259385@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

From: Ye Bin <yebin10@huawei.com>

commit f4534c9fc94d22383f187b9409abb3f9df2e3db3 upstream.

We got issue as follows:
EXT4-fs error (device loop0) in ext4_reserve_inode_write:5741: Out of memory
EXT4-fs error (device loop0): ext4_setattr:5462: inode #13: comm syz-executor.0: mark_inode_dirty error
EXT4-fs error (device loop0) in ext4_setattr:5519: Out of memory
EXT4-fs error (device loop0): ext4_ind_map_blocks:595: inode #13: comm syz-executor.0: Can't allocate blocks for non-extent mapped inodes with bigalloc
------------[ cut here ]------------
WARNING: CPU: 1 PID: 4361 at fs/ext4/file.c:301 ext4_file_write_iter+0x11c9/0x1220
Modules linked in:
CPU: 1 PID: 4361 Comm: syz-executor.0 Not tainted 5.10.0+ #1
RIP: 0010:ext4_file_write_iter+0x11c9/0x1220
RSP: 0018:ffff924d80b27c00 EFLAGS: 00010282
RAX: ffffffff815a3379 RBX: 0000000000000000 RCX: 000000003b000000
RDX: ffff924d81601000 RSI: 00000000000009cc RDI: 00000000000009cd
RBP: 000000000000000d R08: ffffffffbc5a2c6b R09: 0000902e0e52a96f
R10: ffff902e2b7c1b40 R11: ffff902e2b7c1b40 R12: 000000000000000a
R13: 0000000000000001 R14: ffff902e0e52aa10 R15: ffffffffffffff8b
FS:  00007f81a7f65700(0000) GS:ffff902e3bc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 000000012db88001 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 do_iter_readv_writev+0x2e5/0x360
 do_iter_write+0x112/0x4c0
 do_pwritev+0x1e5/0x390
 __x64_sys_pwritev2+0x7e/0xa0
 do_syscall_64+0x37/0x50
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Above issue may happen as follows:
Assume
inode.i_size=4096
EXT4_I(inode)->i_disksize=4096

step 1: set inode->i_isize = 8192
ext4_setattr
  if (attr->ia_size != inode->i_size)
    EXT4_I(inode)->i_disksize = attr->ia_size;
    rc = ext4_mark_inode_dirty
       ext4_reserve_inode_write
          ext4_get_inode_loc
            __ext4_get_inode_loc
              sb_getblk --> return -ENOMEM
   ...
   if (!error)  ->will not update i_size
     i_size_write(inode, attr->ia_size);
Now:
inode.i_size=4096
EXT4_I(inode)->i_disksize=8192

step 2: Direct write 4096 bytes
ext4_file_write_iter
 ext4_dio_write_iter
   iomap_dio_rw ->return error
 if (extend)
   ext4_handle_inode_extension
     WARN_ON_ONCE(i_size_read(inode) < EXT4_I(inode)->i_disksize);
->Then trigger warning.

To solve above issue, if mark inode dirty failed in ext4_setattr just
set 'EXT4_I(inode)->i_disksize' with old value.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20220326065351.761952-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5364,6 +5364,7 @@ int ext4_setattr(struct user_namespace *
 	if (attr->ia_valid & ATTR_SIZE) {
 		handle_t *handle;
 		loff_t oldsize = inode->i_size;
+		loff_t old_disksize;
 		int shrink = (attr->ia_size < inode->i_size);
 
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
@@ -5437,6 +5438,7 @@ int ext4_setattr(struct user_namespace *
 					inode->i_sb->s_blocksize_bits);
 
 			down_write(&EXT4_I(inode)->i_data_sem);
+			old_disksize = EXT4_I(inode)->i_disksize;
 			EXT4_I(inode)->i_disksize = attr->ia_size;
 			rc = ext4_mark_inode_dirty(handle, inode);
 			if (!error)
@@ -5448,6 +5450,8 @@ int ext4_setattr(struct user_namespace *
 			 */
 			if (!error)
 				i_size_write(inode, attr->ia_size);
+			else
+				EXT4_I(inode)->i_disksize = old_disksize;
 			up_write(&EXT4_I(inode)->i_data_sem);
 			ext4_journal_stop(handle);
 			if (error)


