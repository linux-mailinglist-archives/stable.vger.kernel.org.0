Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CF744ACDA
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 12:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343579AbhKILvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 06:51:35 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:51008 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242051AbhKILvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 06:51:35 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C67C71FDB7;
        Tue,  9 Nov 2021 11:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1636458528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=RNH1zhG55lKiISJ8oySE9cPF7clUgLqqBnz7BLeCSjg=;
        b=fGkzfezjACCpwJxgYx0E67X3GtPDJwVk6Kict2uP6aTfQ+/DVO2yEuDhj2U7r+jmuO//JT
        OBjioEDP5krP9odKma1fU0NInJsKhW+sbuaShvgehQ+vQSPK7L+d0O651/Bn/jYhJ2bleG
        Ouxtb+KrhOD6ZHyEmUQFBtBz3ku3pLI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1636458528;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=RNH1zhG55lKiISJ8oySE9cPF7clUgLqqBnz7BLeCSjg=;
        b=Y6CClXUnTfDRXRXYtJ7f3wR8058hld0yRoPZkIZzWybpb9ngDVUVvrXmLkEFIU+rS3at8S
        FYAMLkvx/bTzAODg==
Received: from quack2.suse.cz (unknown [10.100.200.198])
        by relay2.suse.de (Postfix) with ESMTP id B8358A3B87;
        Tue,  9 Nov 2021 11:48:48 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 694BF1E14ED; Tue,  9 Nov 2021 12:48:48 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Nathan Wilson <nate@chickenbrittle.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH] udf: Fix crash after seekdir
Date:   Tue,  9 Nov 2021 12:48:41 +0100
Message-Id: <20211109114841.30310-1-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5229; h=from:subject; bh=WDh3QibNLGEWnbd4eCBgrER5UCOMYnAUKorpJO6XCuE=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBhil/vatT7CbVbhpHvpz5eaOCkE0pIhghOcOThpD92 vKP0dhKJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYYpf7wAKCRCcnaoHP2RA2ZamCA DfwNk1m8Pbxt+COqFRSMWyIzmTUIwZrlxSpWCfwdmS+Mwlfe2ugvqEaQd/O9bYS8jlC78SLrBFmb4D xLY1GviRurndiI/fy8Nd96hfuBeOtA3UEJbo3f7+S5WlcIMNDvIEcilkjd3oE/01J32nBEZHih4h1t SQGfgovq++cjy7EHiJDJe4eo8JWIEb25zoAtviEQS5Y4bawC239ZQ8eVVVCkYM4v6Is1JoITr0hRxb Qpg18iGTTH+bnTp91QhLjeLvgAR2ROpk/RCnq7cSWpdwOxz9dU6ZR2oPKcH6BbYSGGsgFxsRWjM/ZQ pynkeiRtQ/9KwM0T32HevswadfZAcG
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

udf_readdir() didn't validate the directory position it should start
reading from. Thus when user uses lseek(2) on directory file descriptor
it can trick udf_readdir() into reading from a position in the middle of
directory entry which then upsets directory parsing code resulting in
errors or even possible kernel crashes. Similarly when the directory is
modified between two readdir calls, the directory position need not be
valid anymore.

Add code to validate current offset in the directory. This is actually
rather expensive for UDF as we need to read from the beginning of the
directory and parse all directory entries. This is because in UDF a
directory is just a stream of data containing directory entries and
since file names are fully under user's control we cannot depend on
detecting magic numbers and checksums in the header of directory entry
as a malicious attacker could fake them. We skip this step if we detect
that nothing changed since the last readdir call.

Reported-by: Nathan Wilson <nate@chickenbrittle.com>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/dir.c   | 32 ++++++++++++++++++++++++++++++--
 fs/udf/namei.c |  3 +++
 fs/udf/super.c |  2 ++
 3 files changed, 35 insertions(+), 2 deletions(-)

I plan to merge this patch through my tree.

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 70abdfad2df1..42e3e551fa4c 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -31,6 +31,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/bio.h>
+#include <linux/iversion.h>
 
 #include "udf_i.h"
 #include "udf_sb.h"
@@ -43,7 +44,7 @@ static int udf_readdir(struct file *file, struct dir_context *ctx)
 	struct fileIdentDesc *fi = NULL;
 	struct fileIdentDesc cfi;
 	udf_pblk_t block, iblock;
-	loff_t nf_pos;
+	loff_t nf_pos, emit_pos = 0;
 	int flen;
 	unsigned char *fname = NULL, *copy_name = NULL;
 	unsigned char *nameptr;
@@ -57,6 +58,7 @@ static int udf_readdir(struct file *file, struct dir_context *ctx)
 	int i, num, ret = 0;
 	struct extent_position epos = { NULL, 0, {0, 0} };
 	struct super_block *sb = dir->i_sb;
+	bool pos_valid = false;
 
 	if (ctx->pos == 0) {
 		if (!dir_emit_dot(file, ctx))
@@ -67,6 +69,21 @@ static int udf_readdir(struct file *file, struct dir_context *ctx)
 	if (nf_pos >= size)
 		goto out;
 
+	/*
+	 * Something changed since last readdir (either lseek was called or dir
+	 * changed)?  We need to verify the position correctly points at the
+	 * beginning of some dir entry so that the directory parsing code does
+	 * not get confused. Since UDF does not have any reliable way of
+	 * identifying beginning of dir entry (names are under user control),
+	 * we need to scan the directory from the beginning.
+	 */
+	if (!inode_eq_iversion(dir, file->f_version)) {
+		emit_pos = nf_pos;
+		nf_pos = 0;
+	} else {
+		pos_valid = true;
+	}
+
 	fname = kmalloc(UDF_NAME_LEN, GFP_NOFS);
 	if (!fname) {
 		ret = -ENOMEM;
@@ -122,13 +139,21 @@ static int udf_readdir(struct file *file, struct dir_context *ctx)
 
 	while (nf_pos < size) {
 		struct kernel_lb_addr tloc;
+		loff_t cur_pos = nf_pos;
 
-		ctx->pos = (nf_pos >> 2) + 1;
+		/* Update file position only if we got past the current one */
+		if (nf_pos >= emit_pos) {
+			ctx->pos = (nf_pos >> 2) + 1;
+			pos_valid = true;
+		}
 
 		fi = udf_fileident_read(dir, &nf_pos, &fibh, &cfi, &epos, &eloc,
 					&elen, &offset);
 		if (!fi)
 			goto out;
+		/* Still not at offset where user asked us to read from? */
+		if (cur_pos < emit_pos)
+			continue;
 
 		liu = le16_to_cpu(cfi.lengthOfImpUse);
 		lfi = cfi.lengthFileIdent;
@@ -186,8 +211,11 @@ static int udf_readdir(struct file *file, struct dir_context *ctx)
 	} /* end while */
 
 	ctx->pos = (nf_pos >> 2) + 1;
+	pos_valid = true;
 
 out:
+	if (pos_valid)
+		file->f_version = inode_query_iversion(dir);
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index caeef08efed2..0ed4861b038f 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -30,6 +30,7 @@
 #include <linux/sched.h>
 #include <linux/crc-itu-t.h>
 #include <linux/exportfs.h>
+#include <linux/iversion.h>
 
 static inline int udf_match(int len1, const unsigned char *name1, int len2,
 			    const unsigned char *name2)
@@ -134,6 +135,8 @@ int udf_write_fi(struct inode *inode, struct fileIdentDesc *cfi,
 			mark_buffer_dirty_inode(fibh->ebh, inode);
 		mark_buffer_dirty_inode(fibh->sbh, inode);
 	}
+	inode_inc_iversion(inode);
+
 	return 0;
 }
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index b2d7c57d0688..aa2f6093d3f6 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -57,6 +57,7 @@
 #include <linux/crc-itu-t.h>
 #include <linux/log2.h>
 #include <asm/byteorder.h>
+#include <linux/iversion.h>
 
 #include "udf_sb.h"
 #include "udf_i.h"
@@ -149,6 +150,7 @@ static struct inode *udf_alloc_inode(struct super_block *sb)
 	init_rwsem(&ei->i_data_sem);
 	ei->cached_extent.lstart = -1;
 	spin_lock_init(&ei->i_extent_cache_lock);
+	inode_set_iversion(&ei->vfs_inode, 1);
 
 	return &ei->vfs_inode;
 }
-- 
2.26.2

