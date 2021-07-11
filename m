Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668483C37E4
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233215AbhGJXxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231966AbhGJXwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C3DE613B6;
        Sat, 10 Jul 2021 23:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961008;
        bh=+d+NrJHSUO1Jp+cYzRpOOmeIY7BOrMO7ae8ByJmcd2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9NWbJSqqZbWAtNd/Hl6+BnGol43x7m7oBnHx0Te+vYYl0HN8gVPtPfHVRaALwRgv
         j8nuU+yOZ7I8Owb6FrNTzs5kHh2uqg7C8r2jqqjTVZEd5u4YILR/eB6MT0QkSp3Bdg
         Ea6zeOkMtz7jgikMFwgHHf70GEHQWAenq7irsqPbY4Jl4QPYg41pzs8+ecdvk1lof2
         qoWlpotGF0BfRYBLegteVV5WRZb7i97O7TQ+ARCPbRVegrGcORSfv8FdRx5l97DCI1
         CYUJ2JdZ1yFXZmnMWVwTK2Z9wQULkVFgNqX97UT6O1vhmU8GRSO+QhXFEr6KVw9LsO
         LDRFiJ3fpvnWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ye Bin <yebin10@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 38/43] ext4: fix WARN_ON_ONCE(!buffer_uptodate) after an error writing the superblock
Date:   Sat, 10 Jul 2021 19:49:10 -0400
Message-Id: <20210710234915.3220342-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ye Bin <yebin10@huawei.com>

[ Upstream commit 558d6450c7755aa005d89021204b6cdcae5e848f ]

If a writeback of the superblock fails with an I/O error, the buffer
is marked not uptodate.  However, this can cause a WARN_ON to trigger
when we attempt to write superblock a second time.  (Which might
succeed this time, for cerrtain types of block devices such as iSCSI
devices over a flaky network.)

Try to detect this case in flush_stashed_error_work(), and also change
__ext4_handle_dirty_metadata() so we always set the uptodate flag, not
just in the nojournal case.

Before this commit, this problem can be repliciated via:

1. dmsetup  create dust1 --table  '0 2097152 dust /dev/sdc 0 4096'
2. mount  /dev/mapper/dust1  /home/test
3. dmsetup message dust1 0 addbadblock 0 10
4. cd /home/test
5. echo "XXXXXXX" > t

After a few seconds, we got following warning:

[   80.654487] end_buffer_async_write: bh=0xffff88842f18bdd0
[   80.656134] Buffer I/O error on dev dm-0, logical block 0, lost async page write
[   85.774450] EXT4-fs error (device dm-0): ext4_check_bdev_write_error:193: comm kworker/u16:8: Error while async write back metadata
[   91.415513] mark_buffer_dirty: bh=0xffff88842f18bdd0
[   91.417038] ------------[ cut here ]------------
[   91.418450] WARNING: CPU: 1 PID: 1944 at fs/buffer.c:1092 mark_buffer_dirty.cold+0x1c/0x5e
[   91.440322] Call Trace:
[   91.440652]  __jbd2_journal_temp_unlink_buffer+0x135/0x220
[   91.441354]  __jbd2_journal_unfile_buffer+0x24/0x90
[   91.441981]  __jbd2_journal_refile_buffer+0x134/0x1d0
[   91.442628]  jbd2_journal_commit_transaction+0x249a/0x3240
[   91.443336]  ? put_prev_entity+0x2a/0x200
[   91.443856]  ? kjournald2+0x12e/0x510
[   91.444324]  kjournald2+0x12e/0x510
[   91.444773]  ? woken_wake_function+0x30/0x30
[   91.445326]  kthread+0x150/0x1b0
[   91.445739]  ? commit_timeout+0x20/0x20
[   91.446258]  ? kthread_flush_worker+0xb0/0xb0
[   91.446818]  ret_from_fork+0x1f/0x30
[   91.447293] ---[ end trace 66f0b6bf3d1abade ]---

Signed-off-by: Ye Bin <yebin10@huawei.com>
Link: https://lore.kernel.org/r/20210615090537.3423231-1-yebin10@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4_jbd2.c |  2 +-
 fs/ext4/super.c     | 12 ++++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index be799040a415..b96ecba91899 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -327,6 +327,7 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 
 	set_buffer_meta(bh);
 	set_buffer_prio(bh);
+	set_buffer_uptodate(bh);
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_dirty_metadata(handle, bh);
 		/* Errors can only happen due to aborted journal or a nasty bug */
@@ -355,7 +356,6 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 					 err);
 		}
 	} else {
-		set_buffer_uptodate(bh);
 		if (inode)
 			mark_buffer_dirty_inode(bh, inode);
 		else
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0e3a847b5d27..67fb3cb34c6f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -705,15 +705,23 @@ static void flush_stashed_error_work(struct work_struct *work)
 	 * ext4 error handling code during handling of previous errors.
 	 */
 	if (!sb_rdonly(sbi->s_sb) && journal) {
+		struct buffer_head *sbh = sbi->s_sbh;
 		handle = jbd2_journal_start(journal, 1);
 		if (IS_ERR(handle))
 			goto write_directly;
-		if (jbd2_journal_get_write_access(handle, sbi->s_sbh)) {
+		if (jbd2_journal_get_write_access(handle, sbh)) {
 			jbd2_journal_stop(handle);
 			goto write_directly;
 		}
 		ext4_update_super(sbi->s_sb);
-		if (jbd2_journal_dirty_metadata(handle, sbi->s_sbh)) {
+		if (buffer_write_io_error(sbh) || !buffer_uptodate(sbh)) {
+			ext4_msg(sbi->s_sb, KERN_ERR, "previous I/O error to "
+				 "superblock detected");
+			clear_buffer_write_io_error(sbh);
+			set_buffer_uptodate(sbh);
+		}
+
+		if (jbd2_journal_dirty_metadata(handle, sbh)) {
 			jbd2_journal_stop(handle);
 			goto write_directly;
 		}
-- 
2.30.2

