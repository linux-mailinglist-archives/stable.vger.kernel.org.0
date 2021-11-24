Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2823145C3C7
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350714AbhKXNmh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:42:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:34754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349219AbhKXNkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:40:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7882D6137D;
        Wed, 24 Nov 2021 12:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758630;
        bh=I4Fj5AWIxz0HBNrQX4HLVuZTC5yPXbA5VpMNR1c3KEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHKleTCVL6S5KVPJoWimSBFxBxlayaY5yGr9yjjPvWY0fe4brZZH2yyhNN/+nccxH
         ZKj5LSoIdmVucGYdE/KESZhhWNppaZR2Do4EIGXuYJlRjliwKobWxo56OejExICmD0
         HQQ8eNCSkXKhRcR2+m9ofiRjfnqe6DvU6N80Nn+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Wilson <nate@chickenbrittle.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5.10 132/154] udf: Fix crash after seekdir
Date:   Wed, 24 Nov 2021 12:58:48 +0100
Message-Id: <20211124115706.574308633@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit a48fc69fe6588b48d878d69de223b91a386a7cb4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/dir.c   |   32 ++++++++++++++++++++++++++++++--
 fs/udf/namei.c |    3 +++
 fs/udf/super.c |    2 ++
 3 files changed, 35 insertions(+), 2 deletions(-)

--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -31,6 +31,7 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/bio.h>
+#include <linux/iversion.h>
 
 #include "udf_i.h"
 #include "udf_sb.h"
@@ -44,7 +45,7 @@ static int udf_readdir(struct file *file
 	struct fileIdentDesc *fi = NULL;
 	struct fileIdentDesc cfi;
 	udf_pblk_t block, iblock;
-	loff_t nf_pos;
+	loff_t nf_pos, emit_pos = 0;
 	int flen;
 	unsigned char *fname = NULL, *copy_name = NULL;
 	unsigned char *nameptr;
@@ -58,6 +59,7 @@ static int udf_readdir(struct file *file
 	int i, num, ret = 0;
 	struct extent_position epos = { NULL, 0, {0, 0} };
 	struct super_block *sb = dir->i_sb;
+	bool pos_valid = false;
 
 	if (ctx->pos == 0) {
 		if (!dir_emit_dot(file, ctx))
@@ -68,6 +70,21 @@ static int udf_readdir(struct file *file
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
@@ -123,13 +140,21 @@ static int udf_readdir(struct file *file
 
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
@@ -187,8 +212,11 @@ static int udf_readdir(struct file *file
 	} /* end while */
 
 	ctx->pos = (nf_pos >> 2) + 1;
+	pos_valid = true;
 
 out:
+	if (pos_valid)
+		file->f_version = inode_query_iversion(dir);
 	if (fibh.sbh != fibh.ebh)
 		brelse(fibh.ebh);
 	brelse(fibh.sbh);
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -30,6 +30,7 @@
 #include <linux/sched.h>
 #include <linux/crc-itu-t.h>
 #include <linux/exportfs.h>
+#include <linux/iversion.h>
 
 static inline int udf_match(int len1, const unsigned char *name1, int len2,
 			    const unsigned char *name2)
@@ -135,6 +136,8 @@ int udf_write_fi(struct inode *inode, st
 			mark_buffer_dirty_inode(fibh->ebh, inode);
 		mark_buffer_dirty_inode(fibh->sbh, inode);
 	}
+	inode_inc_iversion(inode);
+
 	return 0;
 }
 
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -57,6 +57,7 @@
 #include <linux/crc-itu-t.h>
 #include <linux/log2.h>
 #include <asm/byteorder.h>
+#include <linux/iversion.h>
 
 #include "udf_sb.h"
 #include "udf_i.h"
@@ -149,6 +150,7 @@ static struct inode *udf_alloc_inode(str
 	init_rwsem(&ei->i_data_sem);
 	ei->cached_extent.lstart = -1;
 	spin_lock_init(&ei->i_extent_cache_lock);
+	inode_set_iversion(&ei->vfs_inode, 1);
 
 	return &ei->vfs_inode;
 }


