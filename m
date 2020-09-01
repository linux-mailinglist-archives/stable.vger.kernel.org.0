Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ECA2593D6
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730720AbgIAPbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730716AbgIAPbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:31:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D47E20866;
        Tue,  1 Sep 2020 15:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974296;
        bh=Kij61g+lMUKE50blkEAmO9H0baD1yB4lC7Fyd6ZOOoM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2JhH7DzzhUHUtnngYoRep7dseFWaK1P+evWuz3pAPfFw3vbaFjcKgS0AxdCuR1y9
         k5InBR+KiXWObKNlOh01cfcZyXw5RNcEYn7ZwVdGLDcSgHqroibeuNVKAS154vZcxu
         feGrcUhbIoLcGoM/zjC2CCPV0oE/wjMNASLuvaSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xianting Tian <xianting_tian@126.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/214] fs: prevent BUG_ON in submit_bh_wbc()
Date:   Tue,  1 Sep 2020 17:10:01 +0200
Message-Id: <20200901150958.786011822@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150952.963606936@linuxfoundation.org>
References: <20200901150952.963606936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xianting Tian <xianting_tian@126.com>

[ Upstream commit 377254b2cd2252c7c3151b113cbdf93a7736c2e9 ]

If a device is hot-removed --- for example, when a physical device is
unplugged from pcie slot or a nbd device's network is shutdown ---
this can result in a BUG_ON() crash in submit_bh_wbc().  This is
because the when the block device dies, the buffer heads will have
their Buffer_Mapped flag get cleared, leading to the crash in
submit_bh_wbc.

We had attempted to work around this problem in commit a17712c8
("ext4: check superblock mapped prior to committing").  Unfortunately,
it's still possible to hit the BUG_ON(!buffer_mapped(bh)) if the
device dies between when the work-around check in ext4_commit_super()
and when submit_bh_wbh() is finally called:

Code path:
ext4_commit_super
    judge if 'buffer_mapped(sbh)' is false, return <== commit a17712c8
          lock_buffer(sbh)
          ...
          unlock_buffer(sbh)
               __sync_dirty_buffer(sbh,...
                    lock_buffer(sbh)
                        judge if 'buffer_mapped(sbh))' is false, return <== added by this patch
                            submit_bh(...,sbh)
                                submit_bh_wbc(...,sbh,...)

[100722.966497] kernel BUG at fs/buffer.c:3095! <== BUG_ON(!buffer_mapped(bh))' in submit_bh_wbc()
[100722.966503] invalid opcode: 0000 [#1] SMP
[100722.966566] task: ffff8817e15a9e40 task.stack: ffffc90024744000
[100722.966574] RIP: 0010:submit_bh_wbc+0x180/0x190
[100722.966575] RSP: 0018:ffffc90024747a90 EFLAGS: 00010246
[100722.966576] RAX: 0000000000620005 RBX: ffff8818a80603a8 RCX: 0000000000000000
[100722.966576] RDX: ffff8818a80603a8 RSI: 0000000000020800 RDI: 0000000000000001
[100722.966577] RBP: ffffc90024747ac0 R08: 0000000000000000 R09: ffff88207f94170d
[100722.966578] R10: 00000000000437c8 R11: 0000000000000001 R12: 0000000000020800
[100722.966578] R13: 0000000000000001 R14: 000000000bf9a438 R15: ffff88195f333000
[100722.966580] FS:  00007fa2eee27700(0000) GS:ffff88203d840000(0000) knlGS:0000000000000000
[100722.966580] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[100722.966581] CR2: 0000000000f0b008 CR3: 000000201a622003 CR4: 00000000007606e0
[100722.966582] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[100722.966583] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[100722.966583] PKRU: 55555554
[100722.966583] Call Trace:
[100722.966588]  __sync_dirty_buffer+0x6e/0xd0
[100722.966614]  ext4_commit_super+0x1d8/0x290 [ext4]
[100722.966626]  __ext4_std_error+0x78/0x100 [ext4]
[100722.966635]  ? __ext4_journal_get_write_access+0xca/0x120 [ext4]
[100722.966646]  ext4_reserve_inode_write+0x58/0xb0 [ext4]
[100722.966655]  ? ext4_dirty_inode+0x48/0x70 [ext4]
[100722.966663]  ext4_mark_inode_dirty+0x53/0x1e0 [ext4]
[100722.966671]  ? __ext4_journal_start_sb+0x6d/0xf0 [ext4]
[100722.966679]  ext4_dirty_inode+0x48/0x70 [ext4]
[100722.966682]  __mark_inode_dirty+0x17f/0x350
[100722.966686]  generic_update_time+0x87/0xd0
[100722.966687]  touch_atime+0xa9/0xd0
[100722.966690]  generic_file_read_iter+0xa09/0xcd0
[100722.966694]  ? page_cache_tree_insert+0xb0/0xb0
[100722.966704]  ext4_file_read_iter+0x4a/0x100 [ext4]
[100722.966707]  ? __inode_security_revalidate+0x4f/0x60
[100722.966709]  __vfs_read+0xec/0x160
[100722.966711]  vfs_read+0x8c/0x130
[100722.966712]  SyS_pread64+0x87/0xb0
[100722.966716]  do_syscall_64+0x67/0x1b0
[100722.966719]  entry_SYSCALL64_slow_path+0x25/0x25

To address this, add the check of 'buffer_mapped(bh)' to
__sync_dirty_buffer().  This also has the benefit of fixing this for
other file systems.

With this addition, we can drop the workaround in ext4_commit_supper().

[ Commit description rewritten by tytso. ]

Signed-off-by: Xianting Tian <xianting_tian@126.com>
Link: https://lore.kernel.org/r/1596211825-8750-1-git-send-email-xianting_tian@126.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/buffer.c     | 9 +++++++++
 fs/ext4/super.c | 7 -------
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 79c9562434a8d..22d8ac4a8c40a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3170,6 +3170,15 @@ int __sync_dirty_buffer(struct buffer_head *bh, int op_flags)
 	WARN_ON(atomic_read(&bh->b_count) < 1);
 	lock_buffer(bh);
 	if (test_clear_buffer_dirty(bh)) {
+		/*
+		 * The bh should be mapped, but it might not be if the
+		 * device was hot-removed. Not much we can do but fail the I/O.
+		 */
+		if (!buffer_mapped(bh)) {
+			unlock_buffer(bh);
+			return -EIO;
+		}
+
 		get_bh(bh);
 		bh->b_end_io = end_buffer_write_sync;
 		ret = submit_bh(REQ_OP_WRITE, op_flags, bh);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 184f2d737efc9..4aae7e3e89a12 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5059,13 +5059,6 @@ static int ext4_commit_super(struct super_block *sb, int sync)
 	if (!sbh || block_device_ejected(sb))
 		return error;
 
-	/*
-	 * The superblock bh should be mapped, but it might not be if the
-	 * device was hot-removed. Not much we can do but fail the I/O.
-	 */
-	if (!buffer_mapped(sbh))
-		return error;
-
 	/*
 	 * If the file system is mounted read-only, don't update the
 	 * superblock write time.  This avoids updating the superblock
-- 
2.25.1



