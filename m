Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000F01B69A1
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgDWXG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:06:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48140 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727873AbgDWXG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:27 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvI-0004ZU-86; Fri, 24 Apr 2020 00:06:24 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvH-00E6ez-Lp; Fri, 24 Apr 2020 00:06:23 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Lukas Czerner" <lczerner@redhat.com>,
        "Josef Bacik" <jbacik@fb.com>
Date:   Fri, 24 Apr 2020 00:03:58 +0100
Message-ID: <lsq.1587683028.714148599@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 011/245] ext4: only call ext4_truncate when size <= isize
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <jbacik@fb.com>

commit 3da40c7b089810ac9cf2bb1e59633f619f3a7312 upstream.

At LSF we decided that if we truncate up from isize we shouldn't trim
fallocated blocks that were fallocated with KEEP_SIZE and are past the
new i_size.  This patch fixes ext4 to do this.

[ Completely reworked patch so that i_disksize would actually get set
  when truncating up.  Also reworked the code for handling truncate so
  that it's easier to handle. -- tytso ]

Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
[bwh: Backported to 3.16 as dependency of commit ea3d7209ca01
 "ext4: fix races between page faults and hole punching":
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/inode.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4809,8 +4809,10 @@ int ext4_setattr(struct dentry *dentry,
 		ext4_journal_stop(handle);
 	}
 
-	if (attr->ia_valid & ATTR_SIZE && attr->ia_size != inode->i_size) {
+	if (attr->ia_valid & ATTR_SIZE) {
 		handle_t *handle;
+		loff_t oldsize = inode->i_size;
+		int shrink = (attr->ia_size <= inode->i_size);
 
 		if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
 			struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
@@ -4818,24 +4820,26 @@ int ext4_setattr(struct dentry *dentry,
 			if (attr->ia_size > sbi->s_bitmap_maxbytes)
 				return -EFBIG;
 		}
+		if (!S_ISREG(inode->i_mode))
+			return -EINVAL;
 
 		if (IS_I_VERSION(inode) && attr->ia_size != inode->i_size)
 			inode_inc_iversion(inode);
 
-		if (S_ISREG(inode->i_mode) &&
+		if (ext4_should_order_data(inode) &&
 		    (attr->ia_size < inode->i_size)) {
-			if (ext4_should_order_data(inode)) {
-				error = ext4_begin_ordered_truncate(inode,
+			error = ext4_begin_ordered_truncate(inode,
 							    attr->ia_size);
-				if (error)
-					goto err_out;
-			}
+			if (error)
+				goto err_out;
+		}
+		if (attr->ia_size != inode->i_size) {
 			handle = ext4_journal_start(inode, EXT4_HT_INODE, 3);
 			if (IS_ERR(handle)) {
 				error = PTR_ERR(handle);
 				goto err_out;
 			}
-			if (ext4_handle_valid(handle)) {
+			if (ext4_handle_valid(handle) && shrink) {
 				error = ext4_orphan_add(handle, inode);
 				orphan = 1;
 			}
@@ -4854,15 +4858,13 @@ int ext4_setattr(struct dentry *dentry,
 			up_write(&EXT4_I(inode)->i_data_sem);
 			ext4_journal_stop(handle);
 			if (error) {
-				ext4_orphan_del(NULL, inode);
+				if (orphan)
+					ext4_orphan_del(NULL, inode);
 				goto err_out;
 			}
-		} else {
-			loff_t oldsize = inode->i_size;
-
-			i_size_write(inode, attr->ia_size);
-			pagecache_isize_extended(inode, oldsize, inode->i_size);
 		}
+		if (!shrink)
+			pagecache_isize_extended(inode, oldsize, inode->i_size);
 
 		/*
 		 * Blocks are going to be removed from the inode. Wait
@@ -4882,13 +4884,9 @@ int ext4_setattr(struct dentry *dentry,
 		 * in data=journal mode to make pages freeable.
 		 */
 			truncate_pagecache(inode, inode->i_size);
+		if (shrink)
+			ext4_truncate(inode);
 	}
-	/*
-	 * We want to call ext4_truncate() even if attr->ia_size ==
-	 * inode->i_size for cases like truncation of fallocated space
-	 */
-	if (attr->ia_valid & ATTR_SIZE)
-		ext4_truncate(inode);
 
 	if (!rc) {
 		setattr_copy(inode, attr);

