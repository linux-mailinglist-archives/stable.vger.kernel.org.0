Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 673C23EB7B8
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241183AbhHMPIw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241127AbhHMPIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:08:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E623D61153;
        Fri, 13 Aug 2021 15:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867301;
        bh=N95X6vvnJYJ0RYkEtYepk8jK3Izt2Eu+vkdvc+bxJR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acbw/idRWdRIkDXZXoKqegkzKm+PZ6tMostmdN9UhjgymiTVRl6LBjhS5abLsXCBY
         J6J/MXKGffMteZkhq2EF8Mog2NhJOoD1YZU4wdwGJJDgl/rJLKGZz+r/ZC7m5BrlKL
         6YVNfT1/PuPx6c2bJBUUCxaHfDl34N63aonAFqZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 18/25] reiserfs: add check for root_inode in reiserfs_fill_super
Date:   Fri, 13 Aug 2021 17:06:42 +0200
Message-Id: <20210813150521.310784553@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.718161915@linuxfoundation.org>
References: <20210813150520.718161915@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 2acf15b94d5b8ea8392c4b6753a6ffac3135cd78 ]

Our syzcaller report a NULL pointer dereference:

BUG: kernel NULL pointer dereference, address: 0000000000000000
PGD 116e95067 P4D 116e95067 PUD 1080b5067 PMD 0
Oops: 0010 [#1] SMP KASAN
CPU: 7 PID: 592 Comm: a.out Not tainted 5.13.0-next-20210629-dirty #67
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-p4
RIP: 0010:0x0
Code: Unable to access opcode bytes at RIP 0xffffffffffffffd6.
RSP: 0018:ffff888114e779b8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff110229cef39 RCX: ffffffffaa67e1aa
RDX: 0000000000000000 RSI: ffff88810a58ee00 RDI: ffff8881233180b0
RBP: ffffffffac38e9c0 R08: ffffffffaa67e17e R09: 0000000000000001
R10: ffffffffb91c5557 R11: fffffbfff7238aaa R12: ffff88810a58ee00
R13: ffff888114e77aa0 R14: 0000000000000000 R15: ffff8881233180b0
FS:  00007f946163c480(0000) GS:ffff88839f1c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 00000001099c1000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __lookup_slow+0x116/0x2d0
 ? page_put_link+0x120/0x120
 ? __d_lookup+0xfc/0x320
 ? d_lookup+0x49/0x90
 lookup_one_len+0x13c/0x170
 ? __lookup_slow+0x2d0/0x2d0
 ? reiserfs_schedule_old_flush+0x31/0x130
 reiserfs_lookup_privroot+0x64/0x150
 reiserfs_fill_super+0x158c/0x1b90
 ? finish_unfinished+0xb10/0xb10
 ? bprintf+0xe0/0xe0
 ? __mutex_lock_slowpath+0x30/0x30
 ? __kasan_check_write+0x20/0x30
 ? up_write+0x51/0xb0
 ? set_blocksize+0x9f/0x1f0
 mount_bdev+0x27c/0x2d0
 ? finish_unfinished+0xb10/0xb10
 ? reiserfs_kill_sb+0x120/0x120
 get_super_block+0x19/0x30
 legacy_get_tree+0x76/0xf0
 vfs_get_tree+0x49/0x160
 ? capable+0x1d/0x30
 path_mount+0xacc/0x1380
 ? putname+0x97/0xd0
 ? finish_automount+0x450/0x450
 ? kmem_cache_free+0xf8/0x5a0
 ? putname+0x97/0xd0
 do_mount+0xe2/0x110
 ? path_mount+0x1380/0x1380
 ? copy_mount_options+0x69/0x140
 __x64_sys_mount+0xf0/0x190
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

This is because 'root_inode' is initialized with wrong mode, and
it's i_op is set to 'reiserfs_special_inode_operations'. Thus add
check for 'root_inode' to fix the problem.

Link: https://lore.kernel.org/r/20210702040743.1918552-1-yukuai3@huawei.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/reiserfs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 503d8c06e0d9..2ffcbe451202 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2050,6 +2050,14 @@ static int reiserfs_fill_super(struct super_block *s, void *data, int silent)
 		unlock_new_inode(root_inode);
 	}
 
+	if (!S_ISDIR(root_inode->i_mode) || !inode_get_bytes(root_inode) ||
+	    !root_inode->i_size) {
+		SWARN(silent, s, "", "corrupt root inode, run fsck");
+		iput(root_inode);
+		errval = -EUCLEAN;
+		goto error;
+	}
+
 	s->s_root = d_make_root(root_inode);
 	if (!s->s_root)
 		goto error;
-- 
2.30.2



