Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9179F21A4E
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 17:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbfEQPI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 11:08:29 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58595 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728935AbfEQPI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 11:08:29 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1457323AD6;
        Fri, 17 May 2019 11:08:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Fri, 17 May 2019 11:08:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pskXYa
        mvhwaCLOU+0u/pYJfpxh2I8LGGGtPTzJ1gkIE=; b=u4bHa/cwpo+GzMu10df1gE
        sVzsauomwsHN29Yrp2VOf7YKY8Xg5FO30ZgljWX5tqELFgny8etNlKiZQe+gB29k
        H3ZfnjExSkoJr9S7CLPeJ0uvIfKDVb+SB1ZtC2IxafVjma3pfxtmr9xkug1GloDZ
        uNycXYLiNSIn56g0IRUN05Cljis1N8lgZ1Oui+VhzswG2A9uMk+C8Hs7mo7tvEx5
        IJtAtPyjVa1sZ86lfXebHQibskMmf6VjLrNn59G7SJzPb3DdSy3KIAC5nJ+l9E/f
        taDqPgyIVjjKT9vPy4oKPaLbZTFVHKtw3qQdJZ1Y6BwZNGuCR4liw6BZyNAT2wag
        ==
X-ME-Sender: <xms:a87eXBw3vZCKX4hKJHP_GIgSOy8O0rs6lI5pj4D0xrf9-n_MjHe3yw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:a87eXFiUCFdP5mC-VO3W3G0C6ljyFsMuz5XnT6utHNviUBIMKEvVGA>
    <xmx:a87eXGUmuZbVa74kazZc4KcUd3KhhPc5mrItomkVONdLZJNAoO61tg>
    <xmx:a87eXH0gb4_R4edriWNroDaMBBZd7o6PHe6jDXVlTVYWl7S7I_jm3Q>
    <xmx:bM7eXMDf9zvCaNn_H46J_oYD4r7yfN-Rl6bdpNx5UQyzhGHUcTVwmw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 537EF103DB;
        Fri, 17 May 2019 11:08:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix use-after-free race with debug_want_extra_isize" failed to apply to 4.4-stable tree
To:     brho@google.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 17:08:17 +0200
Message-ID: <1558105697218149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7bc04c5c2cc467c5b40f2b03ba08da174a0d5fa7 Mon Sep 17 00:00:00 2001
From: Barret Rhoden <brho@google.com>
Date: Thu, 25 Apr 2019 11:55:50 -0400
Subject: [PATCH] ext4: fix use-after-free race with debug_want_extra_isize

When remounting with debug_want_extra_isize, we were not performing the
same checks that we do during a normal mount.  That allowed us to set a
value for s_want_extra_isize that reached outside the s_inode_size.

Fixes: e2b911c53584 ("ext4: clean up feature test macros with predicate functions")
Reported-by: syzbot+f584efa0ac7213c226b7@syzkaller.appspotmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Barret Rhoden <brho@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6ed4eb81e674..184944d4d8d1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3513,6 +3513,37 @@ int ext4_calculate_overhead(struct super_block *sb)
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
@@ -4387,30 +4418,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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
 
@@ -5194,6 +5202,8 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 		goto restore_opts;
 	}
 
+	ext4_clamp_want_extra_isize(sb);
+
 	if ((old_opts.s_mount_opt & EXT4_MOUNT_JOURNAL_CHECKSUM) ^
 	    test_opt(sb, JOURNAL_CHECKSUM)) {
 		ext4_msg(sb, KERN_ERR, "changing journal_checksum "

