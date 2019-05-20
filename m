Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A080E2378C
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387527AbfETMvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:51:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733107AbfETMUG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:20:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDA4720656;
        Mon, 20 May 2019 12:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354805;
        bh=7pthDh/v0aDGlvjdne4/NwJEb+6uwVQBaiBChHV5NoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAGLWUveiHrCOF3edyJVv7lOsPxBJfoSDGgvBtnZ1xUIzqWsaJfS0dVzly13TWya/
         3Q9Hu3GJi5gltiLb3ddHgF38IU9iPac8RJF2UPuH0cgf94BsxIE3onxeXr7F+NT0P+
         1Wuqc2snnSVi7egSC1DhHvJGSUjrz/EPO5PVqBVU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Barret Rhoden <brho@google.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 4.14 48/63] ext4: fix use-after-free race with debug_want_extra_isize
Date:   Mon, 20 May 2019 14:14:27 +0200
Message-Id: <20190520115236.343866678@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115231.137981521@linuxfoundation.org>
References: <20190520115231.137981521@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Barret Rhoden <brho@google.com>

commit 7bc04c5c2cc467c5b40f2b03ba08da174a0d5fa7 upstream.

When remounting with debug_want_extra_isize, we were not performing the
same checks that we do during a normal mount.  That allowed us to set a
value for s_want_extra_isize that reached outside the s_inode_size.

Fixes: e2b911c53584 ("ext4: clean up feature test macros with predicate functions")
Reported-by: syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Barret Rhoden <brho@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |   58 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3454,6 +3454,37 @@ int ext4_calculate_overhead(struct super
 	return 0;
 }
 
+static void ext4_clamp_want_extra_isize(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_super_block *es = sbi->s_es;
+
+	/* determine the minimum size of new large inodes, if present */
+	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE &&
+	    sbi->s_want_extra_isize == 0) {
+		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
+						     EXT4_GOOD_OLD_INODE_SIZE;
+		if (ext4_has_feature_extra_isize(sb)) {
+			if (sbi->s_want_extra_isize <
+			    le16_to_cpu(es->s_want_extra_isize))
+				sbi->s_want_extra_isize =
+					le16_to_cpu(es->s_want_extra_isize);
+			if (sbi->s_want_extra_isize <
+			    le16_to_cpu(es->s_min_extra_isize))
+				sbi->s_want_extra_isize =
+					le16_to_cpu(es->s_min_extra_isize);
+		}
+	}
+	/* Check if enough inode space is available */
+	if (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
+							sbi->s_inode_size) {
+		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
+						       EXT4_GOOD_OLD_INODE_SIZE;
+		ext4_msg(sb, KERN_INFO,
+			 "required extra inode space not available");
+	}
+}
+
 static void ext4_set_resv_clusters(struct super_block *sb)
 {
 	ext4_fsblk_t resv_clusters;
@@ -4320,30 +4351,7 @@ no_journal:
 	if (ext4_setup_super(sb, es, sb_rdonly(sb)))
 		sb->s_flags |= MS_RDONLY;
 
-	/* determine the minimum size of new large inodes, if present */
-	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE &&
-	    sbi->s_want_extra_isize == 0) {
-		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
-						     EXT4_GOOD_OLD_INODE_SIZE;
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
-	if (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
-							sbi->s_inode_size) {
-		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
-						       EXT4_GOOD_OLD_INODE_SIZE;
-		ext4_msg(sb, KERN_INFO, "required extra inode space not"
-			 "available");
-	}
+	ext4_clamp_want_extra_isize(sb);
 
 	ext4_set_resv_clusters(sb);
 
@@ -5128,6 +5136,8 @@ static int ext4_remount(struct super_blo
 		goto restore_opts;
 	}
 
+	ext4_clamp_want_extra_isize(sb);
+
 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
 	    test_opt(sb, JOURNAL_CHECKSUM)) {
 		ext4_msg(sb, KERN_ERR, "changing journal_checksum "


