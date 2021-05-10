Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695E5378840
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbhEJLVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:04 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:2614 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235297AbhEJLKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 07:10:14 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FdytL09h4zmVKB;
        Mon, 10 May 2021 19:06:50 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.498.0; Mon, 10 May 2021
 19:08:49 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <stable@vger.kernel.org>, <tytso@mit.edu>,
        <adilger.kernel@dilger.ca>, <yangyingliang@huawei.com>
Subject: [PATCH] ext4: return error code when ext4_fill_flex_info() fails
Date:   Mon, 10 May 2021 19:10:51 +0800
Message-ID: <20210510111051.55650-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I got a null-ptr-deref when doing fuzz test:

[  148.490559] EXT4-fs (loop0): not enough memory for 1 flex group pointers
[  148.491529] EXT4-fs (loop0): unable to initialize flex_bg meta info!
[  148.492759] EXT4-fs (loop0): mount failed
[  148.495070] general protection fault, probably for non-canonical address 0xdffffc000000001c: 0000 [#1] SMP KASAN PTI
[  148.496560] KASAN: null-ptr-deref in range [0x00000000000000e0-0x00000000000000e7]
[  148.497611] CPU: 1 PID: 2575 Comm: mount Tainted: G        W         5.13.0-rc1 #109
[  148.498687] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[  148.499968] RIP: 0010:legacy_get_tree+0x12d/0x200
[  148.500651] Code: 66 02 48 89 c5 48 3d 00 f0 ff ff 77 73 e8 9b 1f c5 ff 48 8d bd e0 00 00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 bd 00 00 00 48 83 bd e0 00 00 00 00 74 49 e8 6a
[  148.503325] RSP: 0018:ffff88810bfe7d00 EFLAGS: 00010202
[  148.504159] RAX: dffffc0000000000 RBX: ffff88810d44d800 RCX: ffffffff8999b945
[  148.505271] RDX: 000000000000001c RSI: 0000000000000000 RDI: 00000000000000e0
[  148.506469] RBP: 0000000000000000 R08: 0000000000000001 R09: fffffbfff1d1ab98
[  148.507592] R10: 0000000000000001 R11: fffffbfff1d1ab97 R12: ffff88811490c480
[  148.508820] R13: ffffffff89c30260 R14: ffff888100f14260 R15: ffff88810d44d800
[  148.510160] FS:  00007fe977c1d080(0000) GS:ffff88811ae80000(0000) knlGS:0000000000000000
[  148.511678] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  148.512773] CR2: 000055b8ff4ec018 CR3: 000000010d24a005 CR4: 0000000000770ee0
[  148.514078] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  148.515374] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  148.516678] PKRU: 55555554
[  148.517231] Call Trace:
[  148.517665]  vfs_get_tree+0x8c/0x2d0
[  148.518383]  path_mount+0x4bf/0x19d0
[  148.519058]  ? finish_automount+0x850/0x850
[  148.519821]  ? getname_flags+0x232/0x560
[  148.520587]  do_mount+0xe8/0x100
[  148.521180]  ? path_mount+0x19d0/0x19d0
[  148.521875]  ? _copy_from_user+0xcb/0x110
[  148.522602]  ? memdup_user+0x68/0xa0
[  148.523261]  __x64_sys_mount+0x19c/0x1e0
[  148.524028]  do_syscall_64+0x3c/0x80
[  148.524685]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  148.525646] RIP: 0033:0x7fe9774dd3ca
[  148.526325] Code: 48 8b 0d c1 8a 2c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8e 8a 2c 00 f7 d8 64 89 01 48
[  148.529779] RSP: 002b:00007fff2fbf37b8 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
[  148.531225] RAX: ffffffffffffffda RBX: 000055b8ff4dca50 RCX: 00007fe9774dd3ca
[  148.532595] RDX: 000055b8ff4e59b0 RSI: 000055b8ff4dcc90 RDI: 000055b8ff4e5990
[  148.533907] RBP: 0000000000000000 R08: 0000000000000000 R09: 000055b8ff4dcc50
[  148.535204] R10: 00000000c0ed0000 R11: 0000000000000206 R12: 000055b8ff4e5990
[  148.536496] R13: 000055b8ff4e59b0 R14: 0000000000000000 R15: 00007fe9779fe8a4
[  148.537755] Modules linked in:
[  148.538366] Dumping ftrace buffer:
[  148.539002]    (ftrace buffer empty)
[  148.539861] ---[ end trace 4e7a13bbcda00a47 ]---

After commit c89128a00838 ("ext4: handle errors on ext4_commit_super"), 'ret' may
be set to 0 before calling ext4_fill_flex_info(), if ext4_fill_flex_info() fails
ext4_mount() doesn't return error code, it makes 'root' is null which causes
crash in legacy_get_tree().

Fixes: c89128a00838 ("ext4: handle errors on ext4_commit_super")
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: <stable@vger.kernel.org> # v4.18+
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7dc94f3e18e6..6cb76a44b184 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5052,6 +5052,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			ext4_msg(sb, KERN_ERR,
 			       "unable to initialize "
 			       "flex_bg meta info!");
+			ret = -ENOMEM;
 			goto failed_mount6;
 		}
 
-- 
2.25.1

