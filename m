Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E190414F685
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 06:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgBAFGJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 00:06:09 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33326 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgBAFGI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Feb 2020 00:06:08 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so4717053pgk.0
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 21:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mOGl0G2/Wnvc6F5Lh8EETth4NH2n2G5Q1Up/XyhGx+I=;
        b=bk8H7qKDQcKu7GabwVHJN3yb1L0MzVPX2o0/sjux5oyCuWl75/BGYNKvZ2AV9oyCJM
         oNpiiXYc8M76FPP/GZUJcjc9UJCZTUWZbgujTgUuJFbY4xHNiVS9zqZznpOJ/bzgbAUc
         L3kprlTU269nP8xZ8ZuS8TmejzxbK8Y+h54EY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mOGl0G2/Wnvc6F5Lh8EETth4NH2n2G5Q1Up/XyhGx+I=;
        b=lX/Q2958Vk8J2PuiJnkGeDzyOeH3XQZxYGlPjbpnGULDjg0/GVkAI7vC68tcf89uD2
         t0kNsTS/6mL+x+MSr3z3oyWx3riEwCWY9g2Yo1N1P9AM7IKmwRXvAA7l5QFKnpZSzjNh
         IdoAC4Ch3NXoURPqC8wyqfE5Bjk5v1MjyvbQeMOt625i+B1vMolFF58s+XyUNbQQZ3n0
         VcGNMyCpHtUskK5qVwtUwqjX0x1bJMrHci8R/+IwdP6BI/+FDryJ2iolOlyCN8sJ26cb
         AMuMy7EpHkeJRztpoyXNjUyz3AKfPJdUtwfVIRRvVsru6eypXsEO3uCmYUfe8CVsMaWr
         1UWA==
X-Gm-Message-State: APjAAAUaWRYgeZJmRnB35USxZyGDQak9VstYbJccFr0r5s1UcAGaVUxd
        BK1uS9V+KKOapbRMlsrPLZNVgcQdk10=
X-Google-Smtp-Source: APXvYqwvXedVF2WfsabcdrzzWAqvOjREtgyjytdw+4N1iqITS/fHCi6MyLQu3eFSxVi8yyShbUKkgA==
X-Received: by 2002:a63:de47:: with SMTP id y7mr13486092pgi.270.1580533567117;
        Fri, 31 Jan 2020 21:06:07 -0800 (PST)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id k12sm11600510pgm.65.2020.01.31.21.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 21:06:06 -0800 (PST)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org, tytso@mit.edu,
        adilger.kernel@dilger.ca
Subject: [PATCH v4.19.y] ext4: validate the debug_want_extra_isize mount option at parse time
Date:   Fri, 31 Jan 2020 21:06:01 -0800
Message-Id: <20200201050601.148009-1-zsm@chromium.org>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit 9803387c55f7d2ce69aa64340c5fdc6b3027dbc8 upstream.

Instead of setting s_want_extra_size and then making sure that it is a
valid value afterwards, validate the field before we set it.  This
avoids races and other problems when remounting the file system.

Link: https://lore.kernel.org/r/20191215063020.GA11512@mit.edu
Cc: stable@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reported-and-tested-by: syzbot+4a39a025912b265cacef@syzkaller.appspotmail.com
Signed-off-by: Zubin Mithra <zsm@chromium.org>
---
Notes:
* Syzkaller triggered a UAF on 4.19 kernels with the following
stacktrace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0xc8/0x129 lib/dump_stack.c:113
 print_address_description+0x67/0x22a mm/kasan/report.c:256
 kasan_report_error mm/kasan/report.c:354 [inline]
 kasan_report mm/kasan/report.c:412 [inline]
 kasan_report+0x251/0x28f mm/kasan/report.c:396
 ext4_xattr_set_entry+0x45e/0x2222 fs/ext4/xattr.c:1604
 ext4_xattr_ibody_set+0x7d/0x226 fs/ext4/xattr.c:2240
 ext4_xattr_set_handle+0x553/0xa92 fs/ext4/xattr.c:2396
 ext4_xattr_set+0x16a/0x200 fs/ext4/xattr.c:2508
 __vfs_setxattr+0xfc/0x13d fs/xattr.c:149
 __vfs_setxattr_noperm+0xf5/0x19c fs/xattr.c:180
 vfs_setxattr+0x9c/0xca fs/xattr.c:223
 setxattr+0x20e/0x275 fs/xattr.c:450
 path_setxattr+0xca/0x144 fs/xattr.c:469
 __do_sys_lsetxattr fs/xattr.c:491 [inline]
 __se_sys_lsetxattr fs/xattr.c:487 [inline]
 __x64_sys_lsetxattr+0xd7/0xe1 fs/xattr.c:487
 do_syscall_64+0xfe/0x137 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

* This commit is present in linux-5.4.y. A backport for 4.14.y has been
sent separately.

* This patch resolves conflicts related to the following commits not
being present in linux-4.19.y:
	188d20bcd1eb ("vfs: Add file timestamp range support")
	4881c4971df0 ("ext4: Initialize timestamps limits")

* Tests run: Chrome OS tryjobs, Syzkaller reproducer

 fs/ext4/super.c | 127 +++++++++++++++++++++++++-----------------------
 1 file changed, 66 insertions(+), 61 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1a8d57fe0b1a8..32d8bdf683bbf 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1842,6 +1842,13 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
 			arg = JBD2_DEFAULT_MAX_COMMIT_AGE;
 		sbi->s_commit_interval = HZ * arg;
 	} else if (token == Opt_debug_want_extra_isize) {
+		if ((arg & 1) ||
+		    (arg < 4) ||
+		    (arg > (sbi->s_inode_size - EXT4_GOOD_OLD_INODE_SIZE))) {
+			ext4_msg(sb, KERN_ERR,
+				 "Invalid want_extra_isize %d", arg);
+			return -1;
+		}
 		sbi->s_want_extra_isize = arg;
 	} else if (token == Opt_max_batch_time) {
 		sbi->s_max_batch_time = arg;
@@ -3513,40 +3520,6 @@ int ext4_calculate_overhead(struct super_block *sb)
 	return 0;
 }
 
-static void ext4_clamp_want_extra_isize(struct super_block *sb)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct ext4_super_block *es = sbi->s_es;
-	unsigned def_extra_isize = sizeof(struct ext4_inode) -
-						EXT4_GOOD_OLD_INODE_SIZE;
-
-	if (sbi->s_inode_size == EXT4_GOOD_OLD_INODE_SIZE) {
-		sbi->s_want_extra_isize = 0;
-		return;
-	}
-	if (sbi->s_want_extra_isize < 4) {
-		sbi->s_want_extra_isize = def_extra_isize;
-		if (ext4_has_feature_extra_isize(sb)) {
-			if (sbi->s_want_extra_isize <
-			    le16_to_cpu(es->s_want_extra_isize))
-				sbi->s_want_extra_isize =
-					le16_to_cpu(es->s_want_extra_isize);
-			if (sbi->s_want_extra_isize <
-			    le16_to_cpu(es->s_min_extra_isize))
-				sbi->s_want_extra_isize =
-					le16_to_cpu(es->s_min_extra_isize);
-		}
-	}
-	/* Check if enough inode space is available */
-	if ((sbi->s_want_extra_isize > sbi->s_inode_size) ||
-	    (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
-							sbi->s_inode_size)) {
-		sbi->s_want_extra_isize = def_extra_isize;
-		ext4_msg(sb, KERN_INFO,
-			 "required extra inode space not available");
-	}
-}
-
 static void ext4_set_resv_clusters(struct super_block *sb)
 {
 	ext4_fsblk_t resv_clusters;
@@ -3754,6 +3727,65 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	 */
 	sbi->s_li_wait_mult = EXT4_DEF_LI_WAIT_MULT;
 
+	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
+		sbi->s_inode_size = EXT4_GOOD_OLD_INODE_SIZE;
+		sbi->s_first_ino = EXT4_GOOD_OLD_FIRST_INO;
+	} else {
+		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
+		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
+		if (sbi->s_first_ino < EXT4_GOOD_OLD_FIRST_INO) {
+			ext4_msg(sb, KERN_ERR, "invalid first ino: %u",
+				 sbi->s_first_ino);
+			goto failed_mount;
+		}
+		if ((sbi->s_inode_size < EXT4_GOOD_OLD_INODE_SIZE) ||
+		    (!is_power_of_2(sbi->s_inode_size)) ||
+		    (sbi->s_inode_size > blocksize)) {
+			ext4_msg(sb, KERN_ERR,
+			       "unsupported inode size: %d",
+			       sbi->s_inode_size);
+			goto failed_mount;
+		}
+		/*
+		 * i_atime_extra is the last extra field available for
+		 * [acm]times in struct ext4_inode. Checking for that
+		 * field should suffice to ensure we have extra space
+		 * for all three.
+		 */
+		if (sbi->s_inode_size >= offsetof(struct ext4_inode, i_atime_extra) +
+			sizeof(((struct ext4_inode *)0)->i_atime_extra)) {
+			sb->s_time_gran = 1;
+		} else {
+			sb->s_time_gran = NSEC_PER_SEC;
+		}
+	}
+	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
+		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
+			EXT4_GOOD_OLD_INODE_SIZE;
+		if (ext4_has_feature_extra_isize(sb)) {
+			unsigned v, max = (sbi->s_inode_size -
+					   EXT4_GOOD_OLD_INODE_SIZE);
+
+			v = le16_to_cpu(es->s_want_extra_isize);
+			if (v > max) {
+				ext4_msg(sb, KERN_ERR,
+					 "bad s_want_extra_isize: %d", v);
+				goto failed_mount;
+			}
+			if (sbi->s_want_extra_isize < v)
+				sbi->s_want_extra_isize = v;
+
+			v = le16_to_cpu(es->s_min_extra_isize);
+			if (v > max) {
+				ext4_msg(sb, KERN_ERR,
+					 "bad s_min_extra_isize: %d", v);
+				goto failed_mount;
+			}
+			if (sbi->s_want_extra_isize < v)
+				sbi->s_want_extra_isize = v;
+		}
+	}
+
 	if (sbi->s_es->s_mount_opts[0]) {
 		char *s_mount_opts = kstrndup(sbi->s_es->s_mount_opts,
 					      sizeof(sbi->s_es->s_mount_opts),
@@ -3955,29 +3987,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 						      has_huge_files);
 	sb->s_maxbytes = ext4_max_size(sb->s_blocksize_bits, has_huge_files);
 
-	if (le32_to_cpu(es->s_rev_level) == EXT4_GOOD_OLD_REV) {
-		sbi->s_inode_size = EXT4_GOOD_OLD_INODE_SIZE;
-		sbi->s_first_ino = EXT4_GOOD_OLD_FIRST_INO;
-	} else {
-		sbi->s_inode_size = le16_to_cpu(es->s_inode_size);
-		sbi->s_first_ino = le32_to_cpu(es->s_first_ino);
-		if (sbi->s_first_ino < EXT4_GOOD_OLD_FIRST_INO) {
-			ext4_msg(sb, KERN_ERR, "invalid first ino: %u",
-				 sbi->s_first_ino);
-			goto failed_mount;
-		}
-		if ((sbi->s_inode_size < EXT4_GOOD_OLD_INODE_SIZE) ||
-		    (!is_power_of_2(sbi->s_inode_size)) ||
-		    (sbi->s_inode_size > blocksize)) {
-			ext4_msg(sb, KERN_ERR,
-			       "unsupported inode size: %d",
-			       sbi->s_inode_size);
-			goto failed_mount;
-		}
-		if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE)
-			sb->s_time_gran = 1 << (EXT4_EPOCH_BITS - 2);
-	}
-
 	sbi->s_desc_size = le16_to_cpu(es->s_desc_size);
 	if (ext4_has_feature_64bit(sb)) {
 		if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT ||
@@ -4421,8 +4430,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	} else if (ret)
 		goto failed_mount4a;
 
-	ext4_clamp_want_extra_isize(sb);
-
 	ext4_set_resv_clusters(sb);
 
 	err = ext4_setup_system_zone(sb);
@@ -5207,8 +5214,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
-	ext4_clamp_want_extra_isize(sb);
-
 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
 	    test_opt(sb, JOURNAL_CHECKSUM)) {
 		ext4_msg(sb, KERN_ERR, "changing journal_checksum "
-- 
2.25.0.341.g760bfbb309-goog

