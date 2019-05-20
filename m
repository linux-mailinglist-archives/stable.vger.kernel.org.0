Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED8A32361A
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389238AbfETM3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:29:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389834AbfETM3M (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:29:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFB4020675;
        Mon, 20 May 2019 12:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355351;
        bh=RPLq+m8T3vSNN8s9DhNSSyP3IgbA/VzYKO7i2/BFzUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOiLczp3FqxYZ+hOnkanl5DqPX1NYG81Vce2Xr+U7W+H+fQzm7FaieJ0J5JFzpGe9
         17W66Ue6C0bye87UEayNFzu+d56bGg8yh+To8bxELadFq3xuqc2ZOuW3MYGDvRjr6A
         BDV8fwcPtGukgrdtIADooNJyHvYAzV/n6S4nFELA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com,
        Jan Kara <jack@suse.cz>, Barret Rhoden <brho@google.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.0 086/123] ext4: fix use-after-free race with debug_want_extra_isize
Date:   Mon, 20 May 2019 14:14:26 +0200
Message-Id: <20190520115250.599899313@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
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
@@ -3514,6 +3514,37 @@ int ext4_calculate_overhead(struct super
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
@@ -4388,30 +4419,7 @@ no_journal:
 	} else if (ret)
 		goto failed_mount4a;
 
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
 
@@ -5195,6 +5203,8 @@ static int ext4_remount(struct super_blo
 		goto restore_opts;
 	}
 
+	ext4_clamp_want_extra_isize(sb);
+
 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
 	    test_opt(sb, JOURNAL_CHECKSUM)) {
 		ext4_msg(sb, KERN_ERR, "changing journal_checksum "


