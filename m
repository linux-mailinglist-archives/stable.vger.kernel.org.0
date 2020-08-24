Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0612504B2
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHXRG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:06:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728228AbgHXQia (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:38:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85DBD22DBF;
        Mon, 24 Aug 2020 16:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598287079;
        bh=eYhWix2xUao8vCB3n9SUDaOvJAJW8cGFpF+RV79FK3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eKYes8nFbayLC2/ULExFtccajCY+2fAfgFISh+UTpZc6Jgc3DwTQcrPX3qw6kRdB8
         o1aB5L35OVz9hM3dCnpPlWLx4FYdDlcLHxz4F0TNA/kxojZvHukFvNht5gDSS4OGKV
         o1phcuYqD8Ftusv86cqfbbdFXM7i5OQoiANauX8k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lukas Czerner <lczerner@redhat.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/38] ext4: handle option set by mount flags correctly
Date:   Mon, 24 Aug 2020 12:37:18 -0400
Message-Id: <20200824163751.606577-6-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163751.606577-1-sashal@kernel.org>
References: <20200824163751.606577-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Czerner <lczerner@redhat.com>

[ Upstream commit f25391ebb475d3ffb3aa61bb90e3594c841749ef ]

Currently there is a problem with mount options that can be both set by
vfs using mount flags or by a string parsing in ext4.

i_version/iversion options gets lost after remount, for example

$ mount -o i_version /dev/pmem0 /mnt
$ grep pmem0 /proc/self/mountinfo | grep i_version
310 95 259:0 / /mnt rw,relatime shared:163 - ext4 /dev/pmem0 rw,seclabel,i_version
$ mount -o remount,ro /mnt
$ grep pmem0 /proc/self/mountinfo | grep i_version

nolazytime gets ignored by ext4 on remount, for example

$ mount -o lazytime /dev/pmem0 /mnt
$ grep pmem0 /proc/self/mountinfo | grep lazytime
310 95 259:0 / /mnt rw,relatime shared:163 - ext4 /dev/pmem0 rw,lazytime,seclabel
$ mount -o remount,nolazytime /mnt
$ grep pmem0 /proc/self/mountinfo | grep lazytime
310 95 259:0 / /mnt rw,relatime shared:163 - ext4 /dev/pmem0 rw,lazytime,seclabel

Fix it by applying the SB_LAZYTIME and SB_I_VERSION flags from *flags to
s_flags before we parse the option and use the resulting state of the
same flags in *flags at the end of successful remount.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/20200723150526.19931-1-lczerner@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 76c5529394395..92a6741c4bdd9 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5342,7 +5342,7 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct ext4_super_block *es;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	unsigned long old_sb_flags;
+	unsigned long old_sb_flags, vfs_flags;
 	struct ext4_mount_options old_opts;
 	int enable_quota = 0;
 	ext4_group_t g;
@@ -5385,6 +5385,14 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	if (sbi->s_journal && sbi->s_journal->j_task->io_context)
 		journal_ioprio = sbi->s_journal->j_task->io_context->ioprio;
 
+	/*
+	 * Some options can be enabled by ext4 and/or by VFS mount flag
+	 * either way we need to make sure it matches in both *flags and
+	 * s_flags. Copy those selected flags from *flags to s_flags
+	 */
+	vfs_flags = SB_LAZYTIME | SB_I_VERSION;
+	sb->s_flags = (sb->s_flags & ~vfs_flags) | (*flags & vfs_flags);
+
 	if (!parse_options(data, sb, NULL, &journal_ioprio, 1)) {
 		err = -EINVAL;
 		goto restore_opts;
@@ -5438,9 +5446,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 	}
 
-	if (*flags & SB_LAZYTIME)
-		sb->s_flags |= SB_LAZYTIME;
-
 	if ((bool)(*flags & SB_RDONLY) != sb_rdonly(sb)) {
 		if (sbi->s_mount_flags & EXT4_MF_FS_ABORTED) {
 			err = -EROFS;
@@ -5580,7 +5585,13 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 	}
 #endif
 
-	*flags = (*flags & ~SB_LAZYTIME) | (sb->s_flags & SB_LAZYTIME);
+	/*
+	 * Some options can be enabled by ext4 and/or by VFS mount flag
+	 * either way we need to make sure it matches in both *flags and
+	 * s_flags. Copy those selected flags from s_flags to *flags
+	 */
+	*flags = (*flags & ~vfs_flags) | (sb->s_flags & vfs_flags);
+
 	ext4_msg(sb, KERN_INFO, "re-mounted. Opts: %s", orig_data);
 	kfree(orig_data);
 	return 0;
-- 
2.25.1

