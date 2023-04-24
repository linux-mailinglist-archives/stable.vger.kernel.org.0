Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5883B6ECD7A
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbjDXNX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbjDXNXh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:23:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6865B85
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE20462255
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07DBC433EF;
        Mon, 24 Apr 2023 13:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342611;
        bh=AKJjnQTk5JOtBQiVmMZdPAAcCpl0V8NySXxfjJ0HErY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCH62Suk5ayO+bSE4ETEdrQUWtu5DzNuTRxqe98nae6kejZwMRckvK1ywzvZd7IDn
         lhst7LCLf/h78KAg+nPlmDpL0Cp1JBBc+9B5OsaP4LsFF04k3lY2npZhMpXHrfcYph
         nSnIUoUwdngfksitlJXC0QBN0yXp3ZtxVBSjrbe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, stable@kernel.org,
        Hulk Robot <hulkci@huawei.com>,
        Baokun Li <libaokun1@huawei.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 5.4 30/39] ext4: fix use-after-free in ext4_xattr_set_entry
Date:   Mon, 24 Apr 2023 15:17:33 +0200
Message-Id: <20230424131124.214776261@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
References: <20230424131123.040556994@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 67d7d8ad99beccd9fe92d585b87f1760dc9018e3 ]

Hulk Robot reported a issue:
==================================================================
BUG: KASAN: use-after-free in ext4_xattr_set_entry+0x18ab/0x3500
Write of size 4105 at addr ffff8881675ef5f4 by task syz-executor.0/7092

CPU: 1 PID: 7092 Comm: syz-executor.0 Not tainted 4.19.90-dirty #17
Call Trace:
[...]
 memcpy+0x34/0x50 mm/kasan/kasan.c:303
 ext4_xattr_set_entry+0x18ab/0x3500 fs/ext4/xattr.c:1747
 ext4_xattr_ibody_inline_set+0x86/0x2a0 fs/ext4/xattr.c:2205
 ext4_xattr_set_handle+0x940/0x1300 fs/ext4/xattr.c:2386
 ext4_xattr_set+0x1da/0x300 fs/ext4/xattr.c:2498
 __vfs_setxattr+0x112/0x170 fs/xattr.c:149
 __vfs_setxattr_noperm+0x11b/0x2a0 fs/xattr.c:180
 __vfs_setxattr_locked+0x17b/0x250 fs/xattr.c:238
 vfs_setxattr+0xed/0x270 fs/xattr.c:255
 setxattr+0x235/0x330 fs/xattr.c:520
 path_setxattr+0x176/0x190 fs/xattr.c:539
 __do_sys_lsetxattr fs/xattr.c:561 [inline]
 __se_sys_lsetxattr fs/xattr.c:557 [inline]
 __x64_sys_lsetxattr+0xc2/0x160 fs/xattr.c:557
 do_syscall_64+0xdf/0x530 arch/x86/entry/common.c:298
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x459fe9
RSP: 002b:00007fa5e54b4c08 EFLAGS: 00000246 ORIG_RAX: 00000000000000bd
RAX: ffffffffffffffda RBX: 000000000051bf60 RCX: 0000000000459fe9
RDX: 00000000200003c0 RSI: 0000000020000180 RDI: 0000000020000140
RBP: 000000000051bf60 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000001009 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc73c93fc0 R14: 000000000051bf60 R15: 00007fa5e54b4d80
[...]
==================================================================

Above issue may happen as follows:
-------------------------------------
ext4_xattr_set
  ext4_xattr_set_handle
    ext4_xattr_ibody_find
      >> s->end < s->base
      >> no EXT4_STATE_XATTR
      >> xattr_check_inode is not executed
    ext4_xattr_ibody_set
      ext4_xattr_set_entry
       >> size_t min_offs = s->end - s->base
       >> UAF in memcpy

we can easily reproduce this problem with the following commands:
    mkfs.ext4 -F /dev/sda
    mount -o debug_want_extra_isize=128 /dev/sda /mnt
    touch /mnt/file
    setfattr -n user.cat -v `seq -s z 4096|tr -d '[:digit:]'` /mnt/file

In ext4_xattr_ibody_find, we have the following assignment logic:
  header = IHDR(inode, raw_inode)
         = raw_inode + EXT4_GOOD_OLD_INODE_SIZE + i_extra_isize
  is->s.base = IFIRST(header)
             = header + sizeof(struct ext4_xattr_ibody_header)
  is->s.end = raw_inode + s_inode_size

In ext4_xattr_set_entry
  min_offs = s->end - s->base
           = s_inode_size - EXT4_GOOD_OLD_INODE_SIZE - i_extra_isize -
	     sizeof(struct ext4_xattr_ibody_header)
  last = s->first
  free = min_offs - ((void *)last - s->base) - sizeof(__u32)
       = s_inode_size - EXT4_GOOD_OLD_INODE_SIZE - i_extra_isize -
         sizeof(struct ext4_xattr_ibody_header) - sizeof(__u32)

In the calculation formula, all values except s_inode_size and
i_extra_size are fixed values. When i_extra_size is the maximum value
s_inode_size - EXT4_GOOD_OLD_INODE_SIZE, min_offs is -4 and free is -8.
The value overflows. As a result, the preceding issue is triggered when
memcpy is executed.

Therefore, when finding xattr or setting xattr, check whether
there is space for storing xattr in the inode to resolve this issue.

Cc: stable@kernel.org
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220616021358.2504451-3-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2210,8 +2210,9 @@ int ext4_xattr_ibody_find(struct inode *
 	struct ext4_inode *raw_inode;
 	int error;
 
-	if (EXT4_I(inode)->i_extra_isize == 0)
+	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
 		return 0;
+
 	raw_inode = ext4_raw_inode(&is->iloc);
 	header = IHDR(inode, raw_inode);
 	is->s.base = is->s.first = IFIRST(header);
@@ -2239,8 +2240,9 @@ int ext4_xattr_ibody_set(handle_t *handl
 	struct ext4_xattr_search *s = &is->s;
 	int error;
 
-	if (EXT4_I(inode)->i_extra_isize == 0)
+	if (!EXT4_INODE_HAS_XATTR_SPACE(inode))
 		return -ENOSPC;
+
 	error = ext4_xattr_set_entry(i, s, handle, inode, false /* is_block */);
 	if (error)
 		return error;


