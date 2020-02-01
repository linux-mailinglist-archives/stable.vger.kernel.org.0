Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4756714F686
	for <lists+stable@lfdr.de>; Sat,  1 Feb 2020 06:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgBAFHQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Feb 2020 00:07:16 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41181 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgBAFHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Feb 2020 00:07:16 -0500
Received: by mail-pg1-f194.google.com with SMTP id l3so599403pgi.8
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 21:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=icrw+2/LnAMhusOkqwrV4IvPZhWPo+FSElww6CsUp8o=;
        b=ehKaTfqTPRq2MHI7atazDlZPBO4WMc1uCeBUAa8eIBup717uJcLkowcsPmDOtFHDXG
         8PEFG8JVTELXF3+5aqItFG/8rvt1kxjIf6woHOm+Me+JD0JDnwctpKsyfFXRP3jyv1+i
         0qc/dK8kiL/J+kNwWLUXeZHivuq0ISDyfaJBA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=icrw+2/LnAMhusOkqwrV4IvPZhWPo+FSElww6CsUp8o=;
        b=j1tc6laNn42guRYYO8Vyyj25VgUUDUFLfs3FtkXtKCcHrX9xlcwR5U6FCGNzPj77ti
         ECuB6wgeRTiMMVtHyhDitVk99Jx4eR/a8ovjQyyHfNs195pCM4lgfZ7lBpm29wsb8xEV
         RYEho+41n5Eg2AgGPLo5CKas5RyvdnM1fxgDKiRMDwmlUMuGfDKt755nJW7CUNYL1L4b
         a0VMsQorqbu24Dx7VspN/p6/Nljv78ddrd3vO/tsxBR3bpuvJdlODfxELIl/L6E6enwA
         SKIfpGvEwNYPAHzd6by63MOlllr0C1P0mubef8QGDTLP+Bp/Qqwu/NBPxarRNf2coebb
         HoTg==
X-Gm-Message-State: APjAAAXEwd/Fl/Qaufu5LS+UroXsWkoI5/cM14br1UxXj/Sy3CDKm8Ka
        3rFh+g9mAvY08Ug3JWoR4AxbqzjtGgaqGg==
X-Google-Smtp-Source: APXvYqyq2FPn/aDMaKP772wVuniSV5/PRmPKH3vhLrcV8me09xgaFhcRiVbR4BVKsDKK49EULXJ+Aw==
X-Received: by 2002:a62:cec5:: with SMTP id y188mr14070337pfg.52.1580533635344;
        Fri, 31 Jan 2020 21:07:15 -0800 (PST)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id b65sm12147626pgc.18.2020.01.31.21.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 21:07:14 -0800 (PST)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org, tytso@mit.edu,
        adilger.kernel@dilger.ca
Subject: [PATCH v4.14.y] ext4: validate the debug_want_extra_isize mount option at parse time
Date:   Fri, 31 Jan 2020 21:07:10 -0800
Message-Id: <20200201050710.148431-1-zsm@chromium.org>
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
* Syzkaller triggered a UAF on 4.14 kernels with the following
stacktrace:
 __dump_stack lib/dump_stack.c:17 [inline]
 dump_stack+0xc1/0x111 lib/dump_stack.c:58
 print_address_description+0x67/0x22d mm/kasan/report.c:256
 kasan_report_error mm/kasan/report.c:355 [inline]
 kasan_report mm/kasan/report.c:413 [inline]
 kasan_report+0x250/0x28e mm/kasan/report.c:397
 ext4_xattr_set_entry+0x45e/0x21d9 fs/ext4/xattr.c:1603
 ext4_xattr_ibody_set+0x7d/0x226 fs/ext4/xattr.c:2239
 ext4_xattr_set_handle+0x553/0xa8a fs/ext4/xattr.c:2395
 ext4_xattr_set+0x16a/0x200 fs/ext4/xattr.c:2507
 __vfs_setxattr+0xfc/0x13d fs/xattr.c:150
 __vfs_setxattr_noperm+0xf5/0x19c fs/xattr.c:181
 vfs_setxattr+0x9c/0xca fs/xattr.c:224
 setxattr+0x20e/0x275 fs/xattr.c:453
 path_setxattr+0xca/0x144 fs/xattr.c:472
 SYSC_lsetxattr fs/xattr.c:494 [inline]
 SyS_lsetxattr+0x3e/0x46 fs/xattr.c:490
 do_syscall_64+0x201/0x23f arch/x86/entry/common.c:293
 entry_SYSCALL_64_after_hwframe+0x42/0xb7


* This commit is present in linux-5.4.y. A backport for 4.19.y has been
sent separately.

* This patch resolves conflicts related to the following commits not
being present in linux-4.14.y:
	188d20bcd1eb ("vfs: Add file timestamp range support")
	4881c4971df0 ("ext4: Initialize timestamps limits")

* Tests run: Chrome OS tryjobs, Syzkaller reproducer

 fs/ext4/super.c | 127 +++++++++++++++++++++++++-----------------------
 1 file changed, 66 insertions(+), 61 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1a0a566479746..93d8aa6ef6611 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1782,6 +1782,13 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
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
@@ -3454,40 +3461,6 @@ int ext4_calculate_overhead(struct super_block *sb)
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
@@ -3695,6 +3668,65 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -3893,29 +3925,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -4354,8 +4363,6 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (ext4_setup_super(sb, es, sb_rdonly(sb)))
 		sb->s_flags |= MS_RDONLY;
 
-	ext4_clamp_want_extra_isize(sb);
-
 	ext4_set_resv_clusters(sb);
 
 	err = ext4_setup_system_zone(sb);
@@ -5139,8 +5146,6 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
-	ext4_clamp_want_extra_isize(sb);
-
 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
 	    test_opt(sb, JOURNAL_CHECKSUM)) {
 		ext4_msg(sb, KERN_ERR, "changing journal_checksum "
-- 
2.25.0.341.g760bfbb309-goog

