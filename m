Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DC250F6A2
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345516AbiDZI5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345881AbiDZI4r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:56:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AA0DD947;
        Tue, 26 Apr 2022 01:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CC5660A72;
        Tue, 26 Apr 2022 08:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92632C385A0;
        Tue, 26 Apr 2022 08:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962490;
        bh=bTTEixW6BtI8qE3xR7dSh2ppK1QVV9nMDTjkMPr2NA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zYISRifi7RcOmVoy/89v+FXR3EzWo+shmUzKgo8wkZrbR/IYFLSswwoDIjEKy0VVO
         Qw2hPcBCaQWwXA/Z2REUF8RpoVqTuy1g9PzJNf9GzsrQx3bjfn6LJ9F007/gXA2mlv
         YPchJ91yqUglPiJp9/EBD297BHi/KM5ZZrcxABeY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 5.15 113/124] ext4: fix fallocate to use file_modified to update permissions consistently
Date:   Tue, 26 Apr 2022 10:21:54 +0200
Message-Id: <20220426081750.504887067@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
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
@@ -3027,7 +3027,7 @@ extern int ext4_inode_attach_jinode(stru
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
@@ -4504,9 +4504,9 @@ retry:
 	return ret > 0 ? ret2 : ret;
 }
 
-static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len);
+static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len);
 
-static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len);
+static int ext4_insert_range(struct file *file, loff_t offset, loff_t len);
 
 static long ext4_zero_range(struct file *file, loff_t offset,
 			    loff_t len, int mode)
@@ -4578,6 +4578,10 @@ static long ext4_zero_range(struct file
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_mutex;
+
 	/* Preallocate the range including the unaligned edges */
 	if (partial_begin || partial_end) {
 		ret = ext4_alloc_file_blocks(file,
@@ -4696,7 +4700,7 @@ long ext4_fallocate(struct file *file, i
 	ext4_fc_start_update(inode);
 
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
-		ret = ext4_punch_hole(inode, offset, len);
+		ret = ext4_punch_hole(file, offset, len);
 		goto exit;
 	}
 
@@ -4705,12 +4709,12 @@ long ext4_fallocate(struct file *file, i
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
 
@@ -4746,6 +4750,10 @@ long ext4_fallocate(struct file *file, i
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out;
+
 	ret = ext4_alloc_file_blocks(file, lblk, max_blocks, new_size, flags);
 	if (ret)
 		goto out;
@@ -5248,8 +5256,9 @@ out:
  * This implements the fallocate's collapse range functionality for ext4
  * Returns: 0 and non-zero on error.
  */
-static int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
+static int ext4_collapse_range(struct file *file, loff_t offset, loff_t len)
 {
+	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
 	ext4_lblk_t punch_start, punch_stop;
@@ -5301,6 +5310,10 @@ static int ext4_collapse_range(struct in
 	/* Wait for existing dio to complete */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_mutex;
+
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
 	 * page cache.
@@ -5394,8 +5407,9 @@ out_mutex:
  * by len bytes.
  * Returns 0 on success, error otherwise.
  */
-static int ext4_insert_range(struct inode *inode, loff_t offset, loff_t len)
+static int ext4_insert_range(struct file *file, loff_t offset, loff_t len)
 {
+	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
 	handle_t *handle;
@@ -5452,6 +5466,10 @@ static int ext4_insert_range(struct inod
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
@@ -3939,8 +3939,9 @@ int ext4_break_layouts(struct inode *ino
  * Returns: 0 on success or negative on failure
  */
 
-int ext4_punch_hole(struct inode *inode, loff_t offset, loff_t length)
+int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 {
+	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t first_block, stop_block;
 	struct address_space *mapping = inode->i_mapping;
@@ -4002,6 +4003,10 @@ int ext4_punch_hole(struct inode *inode,
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	inode_dio_wait(inode);
 
+	ret = file_modified(file);
+	if (ret)
+		goto out_mutex;
+
 	/*
 	 * Prevent page faults from reinstantiating pages we have released from
 	 * page cache.


