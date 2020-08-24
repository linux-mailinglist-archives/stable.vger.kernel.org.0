Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C06624F59F
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbgHXIvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:51:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729254AbgHXIva (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:51:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D142A207D3;
        Mon, 24 Aug 2020 08:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598259089;
        bh=nC8NZqLMbKGC1b1B62iictftXYj2AuovET5e6dcqmfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x7paNuEmc6OXf5EgVkO5Bps0exayXnP5WhaaN4aTRVbLOsPS2+HxKbVSLgHo5IUYb
         NsY920TOcgYP9DKgNKUFKfep312hAXnfpFbuRIawjDQSIIgxXuZPpK/i2+iFk9L36m
         uQKDM/5sGtEG3gZxx8WoBq37VCRrUa06or+oQmz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 16/39] ext4: clean up ext4_match() and callers
Date:   Mon, 24 Aug 2020 10:31:15 +0200
Message-Id: <20200824082349.319235024@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082348.445866152@linuxfoundation.org>
References: <20200824082348.445866152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit d9b9f8d5a88cb7881d9f1c2b7e9de9a3fe1dc9e2 ]

When ext4 encryption was originally merged, we were encrypting the
user-specified filename in ext4_match(), introducing a lot of additional
complexity into ext4_match() and its callers.  This has since been
changed to encrypt the filename earlier, so we can remove the gunk
that's no longer needed.  This more or less reverts ext4_search_dir()
and ext4_find_dest_de() to the way they were in the v4.0 kernel.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 81 +++++++++++++++----------------------------------
 1 file changed, 25 insertions(+), 56 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 6225ce9f1884c..dd42d533d2816 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1251,19 +1251,18 @@ static void dx_insert_block(struct dx_frame *frame, u32 hash, ext4_lblk_t block)
 }
 
 /*
- * NOTE! unlike strncmp, ext4_match returns 1 for success, 0 for failure.
+ * Test whether a directory entry matches the filename being searched for.
  *
- * `len <= EXT4_NAME_LEN' is guaranteed by caller.
- * `de != NULL' is guaranteed by caller.
+ * Return: %true if the directory entry matches, otherwise %false.
  */
-static inline int ext4_match(struct ext4_filename *fname,
-			     struct ext4_dir_entry_2 *de)
+static inline bool ext4_match(const struct ext4_filename *fname,
+			      const struct ext4_dir_entry_2 *de)
 {
 	const void *name = fname_name(fname);
 	u32 len = fname_len(fname);
 
 	if (!de->inode)
-		return 0;
+		return false;
 
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
 	if (unlikely(!name)) {
@@ -1295,48 +1294,31 @@ int ext4_search_dir(struct buffer_head *bh, char *search_buf, int buf_size,
 	struct ext4_dir_entry_2 * de;
 	char * dlimit;
 	int de_len;
-	int res;
 
 	de = (struct ext4_dir_entry_2 *)search_buf;
 	dlimit = search_buf + buf_size;
 	while ((char *) de < dlimit) {
 		/* this code is executed quadratically often */
 		/* do minimal checking `by hand' */
-		if ((char *) de + de->name_len <= dlimit) {
-			res = ext4_match(fname, de);
-			if (res < 0) {
-				res = -1;
-				goto return_result;
-			}
-			if (res > 0) {
-				/* found a match - just to be sure, do
-				 * a full check */
-				if (ext4_check_dir_entry(dir, NULL, de, bh,
-						bh->b_data,
-						 bh->b_size, offset)) {
-					res = -1;
-					goto return_result;
-				}
-				*res_dir = de;
-				res = 1;
-				goto return_result;
-			}
-
+		if ((char *) de + de->name_len <= dlimit &&
+		    ext4_match(fname, de)) {
+			/* found a match - just to be sure, do
+			 * a full check */
+			if (ext4_check_dir_entry(dir, NULL, de, bh, bh->b_data,
+						 bh->b_size, offset))
+				return -1;
+			*res_dir = de;
+			return 1;
 		}
 		/* prevent looping on a bad block */
 		de_len = ext4_rec_len_from_disk(de->rec_len,
 						dir->i_sb->s_blocksize);
-		if (de_len <= 0) {
-			res = -1;
-			goto return_result;
-		}
+		if (de_len <= 0)
+			return -1;
 		offset += de_len;
 		de = (struct ext4_dir_entry_2 *) ((char *) de + de_len);
 	}
-
-	res = 0;
-return_result:
-	return res;
+	return 0;
 }
 
 static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
@@ -1853,24 +1835,15 @@ int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 	int nlen, rlen;
 	unsigned int offset = 0;
 	char *top;
-	int res;
 
 	de = (struct ext4_dir_entry_2 *)buf;
 	top = buf + buf_size - reclen;
 	while ((char *) de <= top) {
 		if (ext4_check_dir_entry(dir, NULL, de, bh,
-					 buf, buf_size, offset)) {
-			res = -EFSCORRUPTED;
-			goto return_result;
-		}
-		/* Provide crypto context and crypto buffer to ext4 match */
-		res = ext4_match(fname, de);
-		if (res < 0)
-			goto return_result;
-		if (res > 0) {
-			res = -EEXIST;
-			goto return_result;
-		}
+					 buf, buf_size, offset))
+			return -EFSCORRUPTED;
+		if (ext4_match(fname, de))
+			return -EEXIST;
 		nlen = EXT4_DIR_REC_LEN(de->name_len);
 		rlen = ext4_rec_len_from_disk(de->rec_len, buf_size);
 		if ((de->inode ? rlen - nlen : rlen) >= reclen)
@@ -1878,15 +1851,11 @@ int ext4_find_dest_de(struct inode *dir, struct inode *inode,
 		de = (struct ext4_dir_entry_2 *)((char *)de + rlen);
 		offset += rlen;
 	}
-
 	if ((char *) de > top)
-		res = -ENOSPC;
-	else {
-		*dest_de = de;
-		res = 0;
-	}
-return_result:
-	return res;
+		return -ENOSPC;
+
+	*dest_de = de;
+	return 0;
 }
 
 int ext4_insert_dentry(struct inode *dir,
-- 
2.25.1



