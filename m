Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FB365D6C1
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 16:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjADPCe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 10:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjADPCd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 10:02:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13A2A466
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 07:02:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5ADBBCE17EF
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 15:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32427C433F2;
        Wed,  4 Jan 2023 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672844548;
        bh=0bSncO40yspqMWT5whflBc6X2vhp6r6z8NaxdKKC7eI=;
        h=Subject:To:Cc:From:Date:From;
        b=T9xDudZw1EH4k6yUrFxgj+/LoRGp8NdDRCuRZhL2QdhvgMJJjFFNZDweT9TO2oCyY
         z0KOIlfxZj/vp1iQ9ACJnjNY0wIkcY/BhbQAOUFj291Q784BY4RueSRYow47k2eatZ
         YbtmqQL+KGy/ug6hVKmiX7fuG5CoDZFWxYPRZyUg=
Subject: FAILED: patch "[PATCH] ext4: disable fast-commit of encrypted dir operations" failed to apply to 5.15-stable tree
To:     ebiggers@google.com, stable@vger.kernel.org, tytso@mit.edu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 16:01:24 +0100
Message-ID: <167284448465164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

0fbcb5251fc8 ("ext4: disable fast-commit of encrypted dir operations")
7af1974af0a9 ("ext4: fix ext4_fc_stats trace point")
c864ccd182d6 ("ext4: remove unused enum EXT4_FC_COMMIT_FAILED")
e85c81ba8859 ("ext4: fast commit may not fallback for ineligible commit")
0915e464cb27 ("ext4: simplify updating of fast commit stats")
7bbbe241ec7c ("ext4: drop ineligible txn start stop APIs")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0fbcb5251fc81b58969b272c4fb7374a7b922e3e Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Sun, 6 Nov 2022 14:48:35 -0800
Subject: [PATCH] ext4: disable fast-commit of encrypted dir operations

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

diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0f6d0a80467d..6d98f2b39b77 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -420,25 +420,34 @@ static int __track_dentry_update(struct inode *inode, void *arg, bool update)
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
+		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_ENCRYPTED_FILENAME,
+					NULL);
+		mutex_lock(&ei->i_fc_lock);
+		return -EOPNOTSUPP;
+	}
+
 	node = kmem_cache_alloc(ext4_fc_dentry_cachep, GFP_NOFS);
 	if (!node) {
-		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, NULL);
+		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM, NULL);
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
-				EXT4_FC_REASON_NOMEM, NULL);
+			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM, NULL);
 			mutex_lock(&ei->i_fc_lock);
 			return -ENOMEM;
 		}
@@ -2249,17 +2258,17 @@ void ext4_fc_init(struct super_block *sb, journal_t *journal)
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
diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
index a6154c3ed135..256f2ad27204 100644
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -96,6 +96,7 @@ enum {
 	EXT4_FC_REASON_RENAME_DIR,
 	EXT4_FC_REASON_FALLOC_RANGE,
 	EXT4_FC_REASON_INODE_JOURNAL_DATA,
+	EXT4_FC_REASON_ENCRYPTED_FILENAME,
 	EXT4_FC_REASON_MAX
 };
 
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 44dc438c9242..77b426ae0064 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -104,6 +104,7 @@ TRACE_DEFINE_ENUM(EXT4_FC_REASON_RESIZE);
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
@@ -2799,7 +2801,7 @@ TRACE_EVENT(ext4_fc_stats,
 	),
 
 	TP_printk("dev %d,%d fc ineligible reasons:\n"
-		  "%s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u "
+		  "%s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u"
 		  "num_commits:%lu, ineligible: %lu, numblks: %lu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_XATTR),
@@ -2811,6 +2813,7 @@ TRACE_EVENT(ext4_fc_stats,
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_RENAME_DIR),
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_FALLOC_RANGE),
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_INODE_JOURNAL_DATA),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_ENCRYPTED_FILENAME),
 		  __entry->fc_commits, __entry->fc_ineligible_commits,
 		  __entry->fc_numblks)
 );

