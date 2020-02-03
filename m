Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C1E150C0D
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgBCQc7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:32:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730504AbgBCQc6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:32:58 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 923A72051A;
        Mon,  3 Feb 2020 16:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747578;
        bh=s79AFNuWI6DuIPhPDSa54BwdoM9eLCk/ctOOg7bL6uQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhlTT6TYAYiiW22e56YOyW17R9bsP7RWtv5fiy0y78+Utc//s4r+27uDQqbQIypcc
         rQECfynKfkl7zS5Mwqn0enYD6djoWEWEpgYTUfcyZOW+xMY7o2miIxo0kgwcDLjuOV
         JbBS4OtyeBCqtGn4dO8V8pF67yMWnPVv3s/M16D4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@kernel.org,
        Theodore Tso <tytso@mit.edu>, Zubin Mithra <zsm@chromium.org>,
        syzbot+4a39a025912b265cacef@syzkaller.appspotmail.com
Subject: [PATCH 4.19 12/70] ext4: validate the debug_want_extra_isize mount option at parse time
Date:   Mon,  3 Feb 2020 16:19:24 +0000
Message-Id: <20200203161914.334164647@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
References: <20200203161912.158976871@linuxfoundation.org>
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
Signed-off-by: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |  127 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 66 insertions(+), 61 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1842,6 +1842,13 @@ static int handle_mount_opt(struct super
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
@@ -3513,40 +3520,6 @@ int ext4_calculate_overhead(struct super
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
@@ -3754,6 +3727,65 @@ static int ext4_fill_super(struct super_
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
@@ -3955,29 +3987,6 @@ static int ext4_fill_super(struct super_
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
@@ -4421,8 +4430,6 @@ no_journal:
 	} else if (ret)
 		goto failed_mount4a;
 
-	ext4_clamp_want_extra_isize(sb);
-
 	ext4_set_resv_clusters(sb);
 
 	err = ext4_setup_system_zone(sb);
@@ -5207,8 +5214,6 @@ static int ext4_remount(struct super_blo
 		goto restore_opts;
 	}
 
-	ext4_clamp_want_extra_isize(sb);
-
 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
 	    test_opt(sb, JOURNAL_CHECKSUM)) {
 		ext4_msg(sb, KERN_ERR, "changing journal_checksum "


