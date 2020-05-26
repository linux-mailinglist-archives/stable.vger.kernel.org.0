Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47D91E2F11
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389630AbgEZSzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:55:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389600AbgEZSzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B21452086A;
        Tue, 26 May 2020 18:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519345;
        bh=eMtE+JBaMmlzLtICDuGyHLpacDpmAxayQKApB2U+tyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8Aa2Wz/DuWTZ6lS80+3+ywk8anX5gMH7bUF14dvaJcJMVD0mO3SZeCwNAhvpUzeq
         672RfLB2XD38NbhRGUSgPGAPJuVFbqv5zCUzjTLKFf1hgcPTP1AjPfoNKX3x1sd9gW
         XcY+o9mD9cXWXvxrLfuCeVootN74omv4ypXMKSFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Theodore Tso <tytso@mit.edu>,
        Sultan Alsawaf <sultan@kerneltoast.com>
Subject: [PATCH 4.4 31/65] ext4: lock the xattr block before checksuming it
Date:   Tue, 26 May 2020 20:52:50 +0200
Message-Id: <20200526183917.592537446@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

commit dac7a4b4b1f664934e8b713f529b629f67db313c upstream.

We must lock the xattr block before calculating or verifying the
checksum in order to avoid spurious checksum failures.

https://bugzilla.kernel.org/show_bug.cgi?id=193661

Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/xattr.c |   66 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -139,31 +139,26 @@ static __le32 ext4_xattr_block_csum(stru
 }
 
 static int ext4_xattr_block_csum_verify(struct inode *inode,
-					sector_t block_nr,
-					struct ext4_xattr_header *hdr)
+					struct buffer_head *bh)
 {
-	if (ext4_has_metadata_csum(inode->i_sb) &&
-	    (hdr->h_checksum != ext4_xattr_block_csum(inode, block_nr, hdr)))
-		return 0;
-	return 1;
-}
-
-static void ext4_xattr_block_csum_set(struct inode *inode,
-				      sector_t block_nr,
-				      struct ext4_xattr_header *hdr)
-{
-	if (!ext4_has_metadata_csum(inode->i_sb))
-		return;
+	struct ext4_xattr_header *hdr = BHDR(bh);
+	int ret = 1;
 
-	hdr->h_checksum = ext4_xattr_block_csum(inode, block_nr, hdr);
+	if (ext4_has_metadata_csum(inode->i_sb)) {
+		lock_buffer(bh);
+		ret = (hdr->h_checksum == ext4_xattr_block_csum(inode,
+							bh->b_blocknr, hdr));
+		unlock_buffer(bh);
+	}
+	return ret;
 }
 
-static inline int ext4_handle_dirty_xattr_block(handle_t *handle,
-						struct inode *inode,
-						struct buffer_head *bh)
+static void ext4_xattr_block_csum_set(struct inode *inode,
+				      struct buffer_head *bh)
 {
-	ext4_xattr_block_csum_set(inode, bh->b_blocknr, BHDR(bh));
-	return ext4_handle_dirty_metadata(handle, inode, bh);
+	if (ext4_has_metadata_csum(inode->i_sb))
+		BHDR(bh)->h_checksum = ext4_xattr_block_csum(inode,
+						bh->b_blocknr, BHDR(bh));
 }
 
 static inline const struct xattr_handler *
@@ -226,7 +221,7 @@ ext4_xattr_check_block(struct inode *ino
 	if (buffer_verified(bh))
 		return 0;
 
-	if (!ext4_xattr_block_csum_verify(inode, bh->b_blocknr, BHDR(bh)))
+	if (!ext4_xattr_block_csum_verify(inode, bh))
 		return -EFSBADCRC;
 	error = ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size,
 				       bh->b_data);
@@ -590,23 +585,23 @@ ext4_xattr_release_block(handle_t *handl
 		le32_add_cpu(&BHDR(bh)->h_refcount, -1);
 		if (ce)
 			mb_cache_entry_release(ce);
+
+		ext4_xattr_block_csum_set(inode, bh);
 		/*
 		 * Beware of this ugliness: Releasing of xattr block references
 		 * from different inodes can race and so we have to protect
 		 * from a race where someone else frees the block (and releases
 		 * its journal_head) before we are done dirtying the buffer. In
 		 * nojournal mode this race is harmless and we actually cannot
-		 * call ext4_handle_dirty_xattr_block() with locked buffer as
+		 * call ext4_handle_dirty_metadata() with locked buffer as
 		 * that function can call sync_dirty_buffer() so for that case
 		 * we handle the dirtying after unlocking the buffer.
 		 */
 		if (ext4_handle_valid(handle))
-			error = ext4_handle_dirty_xattr_block(handle, inode,
-							      bh);
+			error = ext4_handle_dirty_metadata(handle, inode, bh);
 		unlock_buffer(bh);
 		if (!ext4_handle_valid(handle))
-			error = ext4_handle_dirty_xattr_block(handle, inode,
-							      bh);
+			error = ext4_handle_dirty_metadata(handle, inode, bh);
 		if (IS_SYNC(inode))
 			ext4_handle_sync(handle);
 		dquot_free_block(inode, EXT4_C2B(EXT4_SB(inode->i_sb), 1));
@@ -837,13 +832,14 @@ ext4_xattr_block_set(handle_t *handle, s
 					ext4_xattr_rehash(header(s->base),
 							  s->here);
 			}
+			ext4_xattr_block_csum_set(inode, bs->bh);
 			unlock_buffer(bs->bh);
 			if (error == -EFSCORRUPTED)
 				goto bad_block;
 			if (!error)
-				error = ext4_handle_dirty_xattr_block(handle,
-								      inode,
-								      bs->bh);
+				error = ext4_handle_dirty_metadata(handle,
+								   inode,
+								   bs->bh);
 			if (error)
 				goto cleanup;
 			goto inserted;
@@ -912,10 +908,11 @@ inserted:
 				le32_add_cpu(&BHDR(new_bh)->h_refcount, 1);
 				ea_bdebug(new_bh, "reusing; refcount now=%d",
 					le32_to_cpu(BHDR(new_bh)->h_refcount));
+				ext4_xattr_block_csum_set(inode, new_bh);
 				unlock_buffer(new_bh);
-				error = ext4_handle_dirty_xattr_block(handle,
-								      inode,
-								      new_bh);
+				error = ext4_handle_dirty_metadata(handle,
+								   inode,
+								   new_bh);
 				if (error)
 					goto cleanup_dquot;
 			}
@@ -965,11 +962,12 @@ getblk_failed:
 				goto getblk_failed;
 			}
 			memcpy(new_bh->b_data, s->base, new_bh->b_size);
+			ext4_xattr_block_csum_set(inode, new_bh);
 			set_buffer_uptodate(new_bh);
 			unlock_buffer(new_bh);
 			ext4_xattr_cache_insert(ext4_mb_cache, new_bh);
-			error = ext4_handle_dirty_xattr_block(handle,
-							      inode, new_bh);
+			error = ext4_handle_dirty_metadata(handle, inode,
+							   new_bh);
 			if (error)
 				goto cleanup;
 		}


