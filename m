Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E218B50F64A
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234231AbiDZIqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346633AbiDZIpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C38C614F;
        Tue, 26 Apr 2022 01:35:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6B4DB81CF9;
        Tue, 26 Apr 2022 08:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2339C385B0;
        Tue, 26 Apr 2022 08:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962110;
        bh=prg0ccc8WbVoA8h1qxxeQBwEqiYeIiTWEWcYDLRAoTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPp6FGICWaEjfxhOi/GULFYHYLw7Kz4CfAltAYHm8WwR+uCqPGboPLKvEb+ZRv4lO
         C9+rVOyPsDGSptqYS1tofQ8XiKKBELET3pqpzwmTGsvwimiMP5fZloNz/XrF+o6+JO
         OLrjquQiuTJCYDcodF7DufWHvNb24YBgtw5PwTzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.10 74/86] ext4: fix fallocate to use file_modified to update permissions consistently
Date:   Tue, 26 Apr 2022 10:21:42 +0200
Message-Id: <20220426081743.345737451@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

commit ad5cd4f4ee4d5fcdb1bfb7a0c073072961e70783 upstream.

Since the initial introduction of (posix) fallocate back at the turn of
the century, it has been possible to use this syscall to change the
user-visible contents of files.  This can happen by extending the file
size during a preallocation, or through any of the newer modes (punch,
zero, collapse, insert range).  Because the call can be used to change
file contents, we should treat it like we do any other modification to a
file -- update the mtime, and drop set[ug]id privileges/capabilities.

The VFS function file_modified() does all this for us if pass it a
locked inode, so let's make fallocate drop permissions correctly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20220308185043.GA117678@magnolia
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h    |    2 +-
 fs/ext4/extents.c |   32 +++++++++++++++++++++++++-------
 fs/ext4/inode.c   |    7 ++++++-
 3 files changed, 32 insertions(+), 9 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2870,7 +2870,7 @@ extern int ext4_inode_attach_jinode(stru
 extern int ext4_can_truncate(struct inode *inode);
 extern int ext4_truncate(struct inode *);
 extern int ext4_break_layouts(struct inode *);
-extern int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length);
+extern int ext4_punch_hole(struct file *file, loff_t offset, loff_t length);
 extern void ext4_set_inode_flags(struct inode *, bool init);
 extern int ext4_alloc_da_blocks(struct inode *inode);
 extern void ext4_set_aops(struct inode *inode);
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4498,9 +4498,9 @@ retry:
 	return ret > 0 ? ret2 : ret;
 }
 
-static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len);
+static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len);
 
-static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len);
+static int ext4_insert_range(struct file *file, loff_t offset, loff_t len);
 
 static long ext4_zero_range(struct file *file, loff_t offset,
 			    loff_t len, int mode)
@@ -4571,6 +4571,10 @@ static long ext4_zero_range(struct file
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_mutex;
+
 	/* Preallocate the range including the unaligned edges */
 	if (partial_begin || partial_end) {
 		ret = ext4_alloc_file_blocks(file,
@@ -4689,7 +4693,7 @@ long ext4_fallocate(struct file *file, i
 	ext4_fc_start_update(inode);
 
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
-		ret = ext4_punch_hole(inode, offset, len);
+		ret = ext4_punch_hole(file, offset, len);
 		goto exit;
 	}
 
@@ -4698,12 +4702,12 @@ long ext4_fallocate(struct file *file, i
 		goto exit;
 
 	if (mode & FALLOC_FL_COLLAPSE_RANGE) {
-		ret = ext4_collapse_range(inode, offset, len);
+		ret = ext4_collapse_range(file, offset, len);
 		goto exit;
 	}
 
 	if (mode & FALLOC_FL_INSERT_RANGE) {
-		ret = ext4_insert_range(inode, offset, len);
+		ret = ext4_insert_range(file, offset, len);
 		goto exit;
 	}
 
@@ -4739,6 +4743,10 @@ long ext4_fallocate(struct file *file, i
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out;
+
 	ret = ext4_alloc_file_blocks(file, lblk, max_blocks, new_size, flags);
 	if (ret)
 		goto out;
@@ -5241,8 +5249,9 @@ out:
  * This implements the fallocate's collapse range functionality for ext4
  * Returns: 0 and non-zero on error.
  */
-static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
+static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 {
+	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t punch_start, punch_stop;
 	handle_t *handle;
@@ -5293,6 +5302,10 @@ static int ext4_collapse_range(struct in
 	/* Wait for existing dio to complete */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_mutex;
+
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
 	 * page cache.
@@ -5387,8 +5400,9 @@ out_mutex:
  * by len bytes.
  * Returns 0 on success, error otherwise.
  */
-static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
+static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 {
+	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	handle_t *handle;
 	struct ext4_ext_path *path;
@@ -5444,6 +5458,10 @@ static int ext4_insert_range(struct inod
 	/* Wait for existing dio to complete */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_mutex;
+
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
 	 * page cache.
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4028,8 +4028,9 @@ int ext4_break_layouts(struct inode *ino
  * Returns: 0 on success or negative on failure
  */
 
-int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
+int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 {
+	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t first_block, stop_block;
 	struct address_space *mapping = inode->i_mapping;
@@ -4091,6 +4092,10 @@ int ext4_punch_hole(struct inode *inode,
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_mutex;
+
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
 	 * page cache.


