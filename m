Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5FB0134BE9
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbgAHTsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:48:03 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43708 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730462AbgAHTqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:04 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006oj-RA; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-007dp2-D8; Wed, 08 Jan 2020 19:45:59 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+33d7ea72e47de3bdf4e1@syzkaller.appspotmail.com,
        "Theodore Ts'o" <tytso@mit.edu>,
        syzbot+f8d6f8386ceacdbfff57@syzkaller.appspotmail.com,
        syzbot+44b6763edfc17144296f@syzkaller.appspotmail.com
Date:   Wed, 08 Jan 2020 19:43:55 +0000
Message-ID: <lsq.1578512578.53067570@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 57/63] ext4: add more paranoia checking in
 ext4_expand_extra_isize handling
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 4ea99936a1630f51fc3a2d61a58ec4a1c4b7d55a upstream.

It's possible to specify a non-zero s_want_extra_isize via debugging
option, and this can cause bad things(tm) to happen when using a file
system with an inode size of 128 bytes.

Add better checking when the file system is mounted, as well as when
we are actually doing the trying to do the inode expansion.

Link: https://lore.kernel.org/r/20191110121510.GH23325@mit.edu
Reported-by: syzbot+f8d6f8386ceacdbfff57@syzkaller.appspotmail.com
Reported-by: syzbot+33d7ea72e47de3bdf4e1@syzkaller.appspotmail.com
Reported-by: syzbot+44b6763edfc17144296f@syzkaller.appspotmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[bwh: Backported to 3.16:
 - Use EIO instead of EFSCORRUPTED
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5094,10 +5094,25 @@ static int ext4_expand_extra_isize(struc
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
+	unsigned int inode_size = EXT4_INODE_SIZE(inode->i_sb);
+	struct ext4_inode_info *ei = EXT4_I(inode);
 
 	if (EXT4_I(inode)->i_extra_isize >= new_extra_isize)
 		return 0;
 
+	/* this was checked at iget time, but double check for good measure */
+	if ((EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize > inode_size) ||
+	    (ei->i_extra_isize & 3)) {
+		EXT4_ERROR_INODE(inode, "bad extra_isize %u (inode size %u)",
+				 ei->i_extra_isize,
+				 EXT4_INODE_SIZE(inode->i_sb));
+		return -EIO;
+	}
+	if ((new_extra_isize < ei->i_extra_isize) ||
+	    (new_extra_isize < 4) ||
+	    (new_extra_isize > inode_size - EXT4_GOOD_OLD_INODE_SIZE))
+		return -EINVAL;	/* Should never happen */
+
 	raw_inode = ext4_raw_inode(&iloc);
 
 	header = IHDR(inode, raw_inode);
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3427,11 +3427,15 @@ static void ext4_clamp_want_extra_isize(
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
+	unsigned def_extra_isize = sizeof(struct ext4_inode) -
+						EXT4_GOOD_OLD_INODE_SIZE;
 
-	/* determine the minimum size of new large inodes, if present */
-	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE) {
-		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
-						     EXT4_GOOD_OLD_INODE_SIZE;
+	if (sbi->s_inode_size == EXT4_GOOD_OLD_INODE_SIZE) {
+		sbi->s_want_extra_isize = 0;
+		return;
+	}
+	if (sbi->s_want_extra_isize < 4) {
+		sbi->s_want_extra_isize = def_extra_isize;
 		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 				       EXT4_FEATURE_RO_COMPAT_EXTRA_ISIZE)) {
 			if (sbi->s_want_extra_isize <
@@ -3445,10 +3449,10 @@ static void ext4_clamp_want_extra_isize(
 		}
 	}
 	/* Check if enough inode space is available */
-	if (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
-							sbi->s_inode_size) {
-		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
-						       EXT4_GOOD_OLD_INODE_SIZE;
+	if ((sbi->s_want_extra_isize > sbi->s_inode_size) ||
+	    (EXT4_GOOD_OLD_INODE_SIZE + sbi->s_want_extra_isize >
+							sbi->s_inode_size)) {
+		sbi->s_want_extra_isize = def_extra_isize;
 		ext4_msg(sb, KERN_INFO,
 			 "required extra inode space not available");
 	}

