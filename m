Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13E812C919
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733257AbfL2SAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 13:00:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387427AbfL2R54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:57:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 354E1208C4;
        Sun, 29 Dec 2019 17:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642275;
        bh=0gHSSahcHyO98eDoaLTHCt1zmatxXEaglOV/Fe7U+8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQ3lQjPlNJ3nyTOA4vIqIV27jVmf2YZNAT1US4H9nEzcbd295CDy9QvZ5m/1lGaDa
         2RfR51W1if2+mV0Mv2NwpVZcYtoIkPj9BLwU2aFklOOjX1g92im5RJXplOdGXNBLHh
         QE3dWZ9L3SwqwsDfaUvMkARvHhPU8aW5gigePLgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>,
        syzbot+4a39a025912b265cacef@syzkaller.appspotmail.com
Subject: [PATCH 5.4 413/434] ext4: validate the debug_want_extra_isize mount option at parse time
Date:   Sun, 29 Dec 2019 18:27:46 +0100
Message-Id: <20191229172730.199563165@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |  143 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 69 insertions(+), 74 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1887,6 +1887,13 @@ static int handle_mount_opt(struct super
 		}
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
@@ -3551,40 +3558,6 @@ int ext4_calculate_overhead(struct super
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
@@ -3792,6 +3765,68 @@ static int ext4_fill_super(struct super_
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
+			sb->s_time_max = EXT4_EXTRA_TIMESTAMP_MAX;
+		} else {
+			sb->s_time_gran = NSEC_PER_SEC;
+			sb->s_time_max = EXT4_NON_EXTRA_TIMESTAMP_MAX;
+		}
+		sb->s_time_min = EXT4_TIMESTAMP_MIN;
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
@@ -4030,42 +4065,6 @@ static int ext4_fill_super(struct super_
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
-		/*
-		 * i_atime_extra is the last extra field available for [acm]times in
-		 * struct ext4_inode. Checking for that field should suffice to ensure
-		 * we have extra space for all three.
-		 */
-		if (sbi->s_inode_size >= offsetof(struct ext4_inode, i_atime_extra) +
-			sizeof(((struct ext4_inode *)0)->i_atime_extra)) {
-			sb->s_time_gran = 1;
-			sb->s_time_max = EXT4_EXTRA_TIMESTAMP_MAX;
-		} else {
-			sb->s_time_gran = NSEC_PER_SEC;
-			sb->s_time_max = EXT4_NON_EXTRA_TIMESTAMP_MAX;
-		}
-
-		sb->s_time_min = EXT4_TIMESTAMP_MIN;
-	}
-
 	sbi->s_desc_size = le16_to_cpu(es->s_desc_size);
 	if (ext4_has_feature_64bit(sb)) {
 		if (sbi->s_desc_size < EXT4_MIN_DESC_SIZE_64BIT ||
@@ -4521,8 +4520,6 @@ no_journal:
 	} else if (ret)
 		goto failed_mount4a;
 
-	ext4_clamp_want_extra_isize(sb);
-
 	ext4_set_resv_clusters(sb);
 
 	err = ext4_setup_system_zone(sb);
@@ -5310,8 +5307,6 @@ static int ext4_remount(struct super_blo
 		goto restore_opts;
 	}
 
-	ext4_clamp_want_extra_isize(sb);
-
 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
 	    test_opt(sb, JOURNAL_CHECKSUM)) {
 		ext4_msg(sb, KERN_ERR, "changing journal_checksum "


