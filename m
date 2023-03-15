Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B706BB129
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjCOMZG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbjCOMYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:24:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DF592BE5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:23:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1F36B81E08
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:23:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F1CC433D2;
        Wed, 15 Mar 2023 12:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883027;
        bh=2YXZZdMxsHNClM8fs9zRnaBV5Q5BOqD7OCb5PE/x4gU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdFYR5Lp5X4GhpI3WCwphZsFPAlNi5t8zQ7ZAJgKu6sBRb+0BeSc3U6qpJvYBomz3
         ead/SbL1Pk5yEC4ysrBAHsAcM4wrg220Q6YTOTqywsBPN7gmGxbmpslr6zjaQYS6Ua
         izXfyzAwyhGcPKXmsvOnaX7u1AQ1D7H4tVWHlF4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Theodore Tso <tytso@mit.edu>,
        Tudor Ambarus <tudor.ambarus@linaro.org>
Subject: [PATCH 5.10 092/104] ext4: add ext4_sb_block_valid() refactored out of ext4_inode_block_valid()
Date:   Wed, 15 Mar 2023 13:13:03 +0100
Message-Id: <20230315115735.790817663@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115731.942692602@linuxfoundation.org>
References: <20230315115731.942692602@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ritesh Harjani <riteshh@linux.ibm.com>

commit 6bc6c2bdf1baca6522b8d9ba976257d722423085 upstream.

This API will be needed at places where we don't have an inode
for e.g. while freeing blocks in ext4_group_add_blocks()

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ritesh Harjani <riteshh@linux.ibm.com>
Link: https://lore.kernel.org/r/dd34a236543ad5ae7123eeebe0cb69e6bdd44f34.1644992610.git.riteshh@linux.ibm.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/block_validity.c |   26 +++++++++++++++++---------
 fs/ext4/ext4.h           |    3 +++
 2 files changed, 20 insertions(+), 9 deletions(-)

--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -294,15 +294,10 @@ void ext4_release_system_zone(struct sup
 		call_rcu(&system_blks->rcu, ext4_destroy_system_zone);
 }
 
-/*
- * Returns 1 if the passed-in block region (start_blk,
- * start_blk+count) is valid; 0 if some part of the block region
- * overlaps with some other filesystem metadata blocks.
- */
-int ext4_inode_block_valid(struct inode *inode, ext4_fsblk_t start_blk,
-			  unsigned int count)
+int ext4_sb_block_valid(struct super_block *sb, struct inode *inode,
+				ext4_fsblk_t start_blk, unsigned int count)
 {
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_system_blocks *system_blks;
 	struct ext4_system_zone *entry;
 	struct rb_node *n;
@@ -331,7 +326,9 @@ int ext4_inode_block_valid(struct inode
 		else if (start_blk >= (entry->start_blk + entry->count))
 			n = n->rb_right;
 		else {
-			ret = (entry->ino == inode->i_ino);
+			ret = 0;
+			if (inode)
+				ret = (entry->ino == inode->i_ino);
 			break;
 		}
 	}
@@ -340,6 +337,17 @@ out_rcu:
 	return ret;
 }
 
+/*
+ * Returns 1 if the passed-in block region (start_blk,
+ * start_blk+count) is valid; 0 if some part of the block region
+ * overlaps with some other filesystem metadata blocks.
+ */
+int ext4_inode_block_valid(struct inode *inode, ext4_fsblk_t start_blk,
+			  unsigned int count)
+{
+	return ext4_sb_block_valid(inode->i_sb, inode, start_blk, count);
+}
+
 int ext4_check_blockref(const char *function, unsigned int line,
 			struct inode *inode, __le32 *p, unsigned int max)
 {
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3536,6 +3536,9 @@ extern int ext4_inode_block_valid(struct
 				  unsigned int count);
 extern int ext4_check_blockref(const char *, unsigned int,
 			       struct inode *, __le32 *, unsigned int);
+extern int ext4_sb_block_valid(struct super_block *sb, struct inode *inode,
+				ext4_fsblk_t start_blk, unsigned int count);
+
 
 /* extents.c */
 struct ext4_ext_path;


