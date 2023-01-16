Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8036966C8EC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbjAPQo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbjAPQn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:43:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575F23E61C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:31:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E828A6106E
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0623CC433D2;
        Mon, 16 Jan 2023 16:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886696;
        bh=X5AqnLfcG61rNuZkULnfqcqS1CwtRe6XFgKQmW0IppE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gz6n4Q9uc0BeSWRkGNOBMBO40aZrIeFGawqefQ2EozWbLvM8q1oNXrGLBcVtHP/Zs
         V6K9uRWe4byyrXbuYpkkqcN0j/lTao1UulD6HPqYYSghEwatvz3iTvQPjNc8Xys1+2
         MpmOrbyRw5IE5+QRrxFNx/o/U8an5wZdsLXscqv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+98346927678ac3059c77@syzkaller.appspotmail.com,
        Ye Bin <yebin10@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.4 528/658] ext4: init quota for old.inode in ext4_rename
Date:   Mon, 16 Jan 2023 16:50:16 +0100
Message-Id: <20230116154933.718642870@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

commit fae381a3d79bb94aa2eb752170d47458d778b797 upstream.

Syzbot found the following issue:
ext4_parse_param: s_want_extra_isize=128
ext4_inode_info_init: s_want_extra_isize=32
ext4_rename: old.inode=ffff88823869a2c8 old.dir=ffff888238699828 new.inode=ffff88823869d7e8 new.dir=ffff888238699828
__ext4_mark_inode_dirty: inode=ffff888238699828 ea_isize=32 want_ea_size=128
__ext4_mark_inode_dirty: inode=ffff88823869a2c8 ea_isize=32 want_ea_size=128
ext4_xattr_block_set: inode=ffff88823869a2c8
------------[ cut here ]------------
WARNING: CPU: 13 PID: 2234 at fs/ext4/xattr.c:2070 ext4_xattr_block_set.cold+0x22/0x980
Modules linked in:
RIP: 0010:ext4_xattr_block_set.cold+0x22/0x980
RSP: 0018:ffff888227d3f3b0 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffff88823007a000 RCX: 0000000000000000
RDX: 0000000000000a03 RSI: 0000000000000040 RDI: ffff888230078178
RBP: 0000000000000000 R08: 000000000000002c R09: ffffed1075c7df8e
R10: ffff8883ae3efc6b R11: ffffed1075c7df8d R12: 0000000000000000
R13: ffff88823869a2c8 R14: ffff8881012e0460 R15: dffffc0000000000
FS:  00007f350ac1f740(0000) GS:ffff8883ae200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f350a6ed6a0 CR3: 0000000237456000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ? ext4_xattr_set_entry+0x3b7/0x2320
 ? ext4_xattr_block_set+0x0/0x2020
 ? ext4_xattr_set_entry+0x0/0x2320
 ? ext4_xattr_check_entries+0x77/0x310
 ? ext4_xattr_ibody_set+0x23b/0x340
 ext4_xattr_move_to_block+0x594/0x720
 ext4_expand_extra_isize_ea+0x59a/0x10f0
 __ext4_expand_extra_isize+0x278/0x3f0
 __ext4_mark_inode_dirty.cold+0x347/0x410
 ext4_rename+0xed3/0x174f
 vfs_rename+0x13a7/0x2510
 do_renameat2+0x55d/0x920
 __x64_sys_rename+0x7d/0xb0
 do_syscall_64+0x3b/0xa0
 entry_SYSCALL_64_after_hwframe+0x72/0xdc

As 'ext4_rename' will modify 'old.inode' ctime and mark inode dirty,
which may trigger expand 'extra_isize' and allocate block. If inode
didn't init quota will lead to warning.  To solve above issue, init
'old.inode' firstly in 'ext4_rename'.

Reported-by: syzbot+98346927678ac3059c77@syzkaller.appspotmail.com
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20221107015335.2524319-1-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3780,6 +3780,9 @@ static int ext4_rename(struct inode *old
 	retval = dquot_initialize(old.dir);
 	if (retval)
 		return retval;
+	retval = dquot_initialize(old.inode);
+	if (retval)
+		return retval;
 	retval = dquot_initialize(new.dir);
 	if (retval)
 		return retval;


