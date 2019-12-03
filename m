Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E263111E44
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbfLCW55 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:57:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbfLCW55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:57:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39C8F2053B;
        Tue,  3 Dec 2019 22:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413875;
        bh=iuNjQ46ZvPenrzQWoSNSZF0zXRLuNcDpd2AvYkeFFKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1y452eiujOFiivufFdQ/DePcWIsodPKF90IzKGgzUBa2ZC2hfFpEf+mwSij3n9bsG
         W/f8nOg4lfaprvdL8eC8Pt9y89xHUFjMCukHEPoc4d9oyI6skM47OOt1Szz4laufbq
         cCtjZ2tWhO6HSossI6bvPF3FlRsmpYVWo9wnbkpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f8d6f8386ceacdbfff57@syzkaller.appspotmail.com,
        syzbot+33d7ea72e47de3bdf4e1@syzkaller.appspotmail.com,
        syzbot+44b6763edfc17144296f@syzkaller.appspotmail.com,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.19 294/321] ext4: add more paranoia checking in ext4_expand_extra_isize handling
Date:   Tue,  3 Dec 2019 23:36:00 +0100
Message-Id: <20191203223442.449933084@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inode.c |   15 +++++++++++++++
 fs/ext4/super.c |   21 ++++++++++++---------
 2 files changed, 27 insertions(+), 9 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5904,8 +5904,23 @@ static int __ext4_expand_extra_isize(str
 {
 	struct ext4_inode *raw_inode;
 	struct ext4_xattr_ibody_header *header;
+	unsigned int inode_size = EXT4_INODE_SIZE(inode->i_sb);
+	struct ext4_inode_info *ei = EXT4_I(inode);
 	int error;
 
+	/* this was checked at iget time, but double check for good measure */
+	if ((EXT4_GOOD_OLD_INODE_SIZE + ei->i_extra_isize > inode_size) ||
+	    (ei->i_extra_isize & 3)) {
+		EXT4_ERROR_INODE(inode, "bad extra_isize %u (inode size %u)",
+				 ei->i_extra_isize,
+				 EXT4_INODE_SIZE(inode->i_sb));
+		return -EFSCORRUPTED;
+	}
+	if ((new_extra_isize < ei->i_extra_isize) ||
+	    (new_extra_isize < 4) ||
+	    (new_extra_isize > inode_size - EXT4_GOOD_OLD_INODE_SIZE))
+		return -EINVAL;	/* Should never happen */
+
 	raw_inode = ext4_raw_inode(iloc);
 
 	header = IHDR(inode, raw_inode);
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3517,12 +3517,15 @@ static void ext4_clamp_want_extra_isize(
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
+	unsigned def_extra_isize = sizeof(struct ext4_inode) -
+						EXT4_GOOD_OLD_INODE_SIZE;
 
-	/* determine the minimum size of new large inodes, if present */
-	if (sbi->s_inode_size > EXT4_GOOD_OLD_INODE_SIZE &&
-	    sbi->s_want_extra_isize == 0) {
-		sbi->s_want_extra_isize = sizeof(struct ext4_inode) -
-						     EXT4_GOOD_OLD_INODE_SIZE;
+	if (sbi->s_inode_size == EXT4_GOOD_OLD_INODE_SIZE) {
+		sbi->s_want_extra_isize = 0;
+		return;
+	}
+	if (sbi->s_want_extra_isize < 4) {
+		sbi->s_want_extra_isize = def_extra_isize;
 		if (ext4_has_feature_extra_isize(sb)) {
 			if (sbi->s_want_extra_isize <
 			    le16_to_cpu(es->s_want_extra_isize))
@@ -3535,10 +3538,10 @@ static void ext4_clamp_want_extra_isize(
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


