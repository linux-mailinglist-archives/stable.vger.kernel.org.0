Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15FA71DF459
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 05:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387492AbgEWDS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 May 2020 23:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387490AbgEWDS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 May 2020 23:18:57 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16D5C061A0E
        for <stable@vger.kernel.org>; Fri, 22 May 2020 20:18:57 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id z64so1549549pfb.1
        for <stable@vger.kernel.org>; Fri, 22 May 2020 20:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OfxnsyjMD0LUeX/K2p126j6q9JL5CanOnRufSYlmhXc=;
        b=brR4wD4XG5/bPdUFU14ITDLBLhjwKZBWZSsRRK4vWUi3h78Q0Dt6vLc2fHU5RtNY73
         Wr7iGPy/inpFCUGD2nggrEMl/4ulMRMWEqai52zm9O6NrPMZH+UB9mfGKkc5Dmd0dczK
         MTia3vC2CHwbWWNMD0Jbr+oo98/DvTICulZNNjC5nIQ4QcGsAuC5UO5PpogdyOdo/oOh
         1yBswD7+XG4SIsXuPnTU/ogduZEg8r93lZMPLvV0TrCpFF14pWcwidxE6/BG+QQngEvP
         LJmt/RKiMosJxkkNQ5ri7BgFlQpQwknWGvvMiobzgMz0eH7Z/BL7eLq91SvNXZLPjKg/
         9fvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=OfxnsyjMD0LUeX/K2p126j6q9JL5CanOnRufSYlmhXc=;
        b=oWYMulmBP4NwbNN2gLTFkcaKW4wS1gJ+XHzcrijewvUfKNXnH6IpfDePeY68OAtE0J
         olkZi5jeYZ0j4dm/RgJDSN9RrGeYehHJVbXKodg/M6KilRrA0Nu3GuOC2MbRMHin7fDF
         m3vlrWgf+lpFhvdSe8knsmMroKeaoMjMTgZW6FWQDxbzQsLVWxi+E3K22FlIp3EyY0lh
         Uis8QGXdN9yepPOrI3mTsXJH9efVP/rQwz6PNgyH3WDhPGKWaMa1r7ZRteD+GC4VHK9I
         ly80WOr9XUcHb5PwcxLDIdCtYjapD/g8VEUz23IFkdshN5sjV1IL8ebyS8ZGpfLMz3Fc
         EhbQ==
X-Gm-Message-State: AOAM530DDhHppzTmkcAooqgN3arb6Sl3fEnNBD1e5+aFMRdUOdf54xry
        H8s8iKopDUBiOrHB7dyA+Zg=
X-Google-Smtp-Source: ABdhPJx/7DyztHs4bvXXmStQGWckaRUSlrN4t4y/DndHZRumKvrwxgw/HU5lHNQz3tFDKjj6RLm+kQ==
X-Received: by 2002:a63:4cc:: with SMTP id 195mr16503193pge.294.1590203936985;
        Fri, 22 May 2020 20:18:56 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-68.cust.tzulo.com. [198.54.129.68])
        by smtp.gmail.com with ESMTPSA id m14sm7204334pgt.6.2020.05.22.20.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 20:18:56 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
To:     gregkh@linuxfoundation.org
Cc:     colin.king@canonical.com, stable@vger.kernel.org, tytso@mit.edu,
        Sultan Alsawaf <sultan@kerneltoast.com>
Subject: [PATCH] ext4: lock the xattr block before checksuming it
Date:   Fri, 22 May 2020 20:18:21 -0700
Message-Id: <20200523031821.501455-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1490633793174140@kroah.com>
References: <1490633793174140@kroah.com>
MIME-Version: 1.0
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
---
Hi,

I've been experiencing spurious ext4 checksum failures on 4.4 because
this patch is missing (which is quite painful with panic-on-error
enabled). This backport fixes the issue for me.
 fs/ext4/xattr.c | 66 ++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 34 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 53679716baca..18b9213ce0bd 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -139,31 +139,26 @@ static __le32 ext4_xattr_block_csum(struct inode *inode,
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
@@ -226,7 +221,7 @@ ext4_xattr_check_block(struct inode *inode, struct buffer_head *bh)
 	if (buffer_verified(bh))
 		return 0;
 
-	if (!ext4_xattr_block_csum_verify(inode, bh->b_blocknr, BHDR(bh)))
+	if (!ext4_xattr_block_csum_verify(inode, bh))
 		return -EFSBADCRC;
 	error = ext4_xattr_check_names(BFIRST(bh), bh->b_data + bh->b_size,
 				       bh->b_data);
@@ -590,23 +585,23 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
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
@@ -837,13 +832,14 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
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
-- 
2.26.2

