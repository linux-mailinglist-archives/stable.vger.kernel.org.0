Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2351621A4D
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 17:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbfEQPIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 11:08:20 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42993 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728935AbfEQPIU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 11:08:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C31E4220CA;
        Fri, 17 May 2019 11:08:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 11:08:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kLuuO8
        bUHrjdy6+96r8Stc31pzfReZ2mFo8dr2mLR7c=; b=FQn1CFTcB6tc8tZTRTEHXR
        7xQ7eBqKFrWsyr9PRw/noVliumIllEQLPlQ/bYGzYRJjpJ/kGdapCDkO0kJ26u8R
        Yd4b8s0s9mEnUnRbOblmzEKoKIMEmAiP10sblkxKMoUlEC6p6e0D2iGF1q1jOc2j
        Aoi+uLZ6/a+cGZ7e43vq2G7OUGOO/kq4VRCAyUkkRWQh9zFaceqZB9nY+zocg5Cl
        Fw/Cv2c2NAKIxz5ueswkXh4pQUX1E2l9NUhiiJr3BKcs+J7556e3nF7ms/DdYDSR
        /1Eu29KDFemwYHYqjibZT9cQUJfUP3lFmURxd4QvDEhG3e+MreQgb76M0ZsEu2sQ
        ==
X-ME-Sender: <xms:Ys7eXElUKzEpZ7LfbwlH9fTva4dc5O_13fK1ahKfmG2412fUDlkr_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Ys7eXOUgNIkckVm3UlWgbRHN6qsHtY9-awklcK3qIPngVjIk_mGBug>
    <xmx:Ys7eXPlcAXDVYs83MC-wa2xy6forahI_BKeUQgihOf8RQ6VTg07zBw>
    <xmx:Ys7eXDQTFakYaXahnSFAmTz0XT4dabU48qwiVM7Sz7RioxduUxIVWQ>
    <xmx:Ys7eXP1zBW2Sy4eYtCpL3RVxBd2z0fwM5q7_5xeH3r5BnqQFCesJaw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B984480061;
        Fri, 17 May 2019 11:08:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ext4: fix use-after-free race with debug_want_extra_isize" failed to apply to 4.9-stable tree
To:     brho@google.com, jack@suse.cz, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 17:08:15 +0200
Message-ID: <1558105695128196@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

