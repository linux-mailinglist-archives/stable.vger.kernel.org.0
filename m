Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20170667818
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240049AbjALOwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240053AbjALOvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:51:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A5A44345
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:38:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA64C61FCB
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BB8C433EF;
        Thu, 12 Jan 2023 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534334;
        bh=Qn/uZgpFzYJ0Qli3MHI5Fo+1b7EZxpU0Fc79wEHaoDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cHfiRCWk5xbt3kIfQ6R7KYFDDSQgfux2SV9iyOwUoklJvrnk/69pgGtb2DkMBHlKT
         brsP3QzMd0xsiHOquTP8NJ8xWMWj+wRSd1jQcmYInZmhb+IqVyT5vOQg5APsVxtmhj
         4OgDQaN1oboaXqchCZAC+pr7RAUlIFL0lQEhsLd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 774/783] ext4: disable fast-commit of encrypted dir operations
Date:   Thu, 12 Jan 2023 14:58:10 +0100
Message-Id: <20230112135600.261724977@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 0fbcb5251fc81b58969b272c4fb7374a7b922e3e upstream.

fast-commit of create, link, and unlink operations in encrypted
directories is completely broken because the unencrypted filenames are
being written to the fast-commit journal instead of the encrypted
filenames.  These operations can't be replayed, as encryption keys
aren't present at journal replay time.  It is also an information leak.

Until if/when we can get this working properly, make encrypted directory
operations ineligible for fast-commit.

Note that fast-commit operations on encrypted regular files continue to
be allowed, as they seem to work.

Fixes: aa75f4d3daae ("ext4: main fast-commit commit path")
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20221106224841.279231-2-ebiggers@kernel.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c       |   40 ++++++++++++++++++++++++----------------
 fs/ext4/fast_commit.h       |    1 +
 include/trace/events/ext4.h |    7 +++++--
 3 files changed, 30 insertions(+), 18 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -371,25 +371,33 @@ static int __track_dentry_update(struct
 	struct __track_dentry_update_args *dentry_update =
 		(struct __track_dentry_update_args *)arg;
 	struct dentry *dentry = dentry_update->dentry;
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	mutex_unlock(&ei->i_fc_lock);
+
+	if (IS_ENCRYPTED(dir)) {
+		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_ENCRYPTED_FILENAME);
+		mutex_lock(&ei->i_fc_lock);
+		return -EOPNOTSUPP;
+	}
+
 	node = kmem_cache_alloc(ext4_fc_dentry_cachep, GFP_NOFS);
 	if (!node) {
-		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM);
+		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM);
 		mutex_lock(&ei->i_fc_lock);
 		return -ENOMEM;
 	}
 
 	node->fcd_op = dentry_update->op;
-	node->fcd_parent = dentry->d_parent->d_inode->i_ino;
+	node->fcd_parent = dir->i_ino;
 	node->fcd_ino = inode->i_ino;
 	if (dentry->d_name.len > DNAME_INLINE_LEN) {
 		node->fcd_name.name = kmalloc(dentry->d_name.len, GFP_NOFS);
 		if (!node->fcd_name.name) {
 			kmem_cache_free(ext4_fc_dentry_cachep, node);
-			ext4_fc_mark_ineligible(inode->i_sb,
-				EXT4_FC_REASON_NOMEM);
+			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM);
 			mutex_lock(&ei->i_fc_lock);
 			return -ENOMEM;
 		}
@@ -2142,17 +2150,17 @@ void ext4_fc_init(struct super_block *sb
 	journal->j_fc_cleanup_callback = ext4_fc_cleanup;
 }
 
-static const char *fc_ineligible_reasons[] = {
-	"Extended attributes changed",
-	"Cross rename",
-	"Journal flag changed",
-	"Insufficient memory",
-	"Swap boot",
-	"Resize",
-	"Dir renamed",
-	"Falloc range op",
-	"Data journalling",
-	"FC Commit Failed"
+static const char * const fc_ineligible_reasons[] = {
+	[EXT4_FC_REASON_XATTR] = "Extended attributes changed",
+	[EXT4_FC_REASON_CROSS_RENAME] = "Cross rename",
+	[EXT4_FC_REASON_JOURNAL_FLAG_CHANGE] = "Journal flag changed",
+	[EXT4_FC_REASON_NOMEM] = "Insufficient memory",
+	[EXT4_FC_REASON_SWAP_BOOT] = "Swap boot",
+	[EXT4_FC_REASON_RESIZE] = "Resize",
+	[EXT4_FC_REASON_RENAME_DIR] = "Dir renamed",
+	[EXT4_FC_REASON_FALLOC_RANGE] = "Falloc range op",
+	[EXT4_FC_REASON_INODE_JOURNAL_DATA] = "Data journalling",
+	[EXT4_FC_REASON_ENCRYPTED_FILENAME] = "Encrypted filename",
 };
 
 int ext4_fc_info_show(struct seq_file *seq, void *v)
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -104,6 +104,7 @@ enum {
 	EXT4_FC_REASON_FALLOC_RANGE,
 	EXT4_FC_REASON_INODE_JOURNAL_DATA,
 	EXT4_FC_COMMIT_FAILED,
+	EXT4_FC_REASON_ENCRYPTED_FILENAME,
 	EXT4_FC_REASON_MAX
 };
 
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -104,6 +104,7 @@ TRACE_DEFINE_ENUM(EXT4_FC_REASON_RESIZE)
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_RENAME_DIR);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_FALLOC_RANGE);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_INODE_JOURNAL_DATA);
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_ENCRYPTED_FILENAME);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_MAX);
 
 #define show_fc_reason(reason)						\
@@ -116,7 +117,8 @@ TRACE_DEFINE_ENUM(EXT4_FC_REASON_MAX);
 		{ EXT4_FC_REASON_RESIZE,	"RESIZE"},		\
 		{ EXT4_FC_REASON_RENAME_DIR,	"RENAME_DIR"},		\
 		{ EXT4_FC_REASON_FALLOC_RANGE,	"FALLOC_RANGE"},	\
-		{ EXT4_FC_REASON_INODE_JOURNAL_DATA,	"INODE_JOURNAL_DATA"})
+		{ EXT4_FC_REASON_INODE_JOURNAL_DATA,	"INODE_JOURNAL_DATA"}, \
+		{ EXT4_FC_REASON_ENCRYPTED_FILENAME,	"ENCRYPTED_FILENAME"})
 
 TRACE_EVENT(ext4_other_inode_update_time,
 	TP_PROTO(struct inode *inode, ino_t orig_ino),
@@ -2940,7 +2942,7 @@ TRACE_EVENT(ext4_fc_stats,
 	),
 
 	TP_printk("dev %d,%d fc ineligible reasons:\n"
-		  "%s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u "
+		  "%s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u"
 		  "num_commits:%lu, ineligible: %lu, numblks: %lu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_XATTR),
@@ -2952,6 +2954,7 @@ TRACE_EVENT(ext4_fc_stats,
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_RENAME_DIR),
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_FALLOC_RANGE),
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_INODE_JOURNAL_DATA),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_ENCRYPTED_FILENAME),
 		  __entry->fc_commits, __entry->fc_ineligible_commits,
 		  __entry->fc_numblks)
 );


