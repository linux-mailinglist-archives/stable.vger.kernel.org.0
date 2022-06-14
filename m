Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10CC54B564
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 18:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbiFNQGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 12:06:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235750AbiFNQGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 12:06:10 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC703B2AD;
        Tue, 14 Jun 2022 09:06:05 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4441E1F930;
        Tue, 14 Jun 2022 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655222764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NzQF6jjl6sCzOady0+DskTyshd/ZX+tm+xLmhj2laP4=;
        b=ak+/nY4UWnbOzs7Mt4yg7wX82E5loTyl3SP7VJ09LiEGq17YFgvMlIjLPPn7Y3GvPQd111
        OfGRvUGdZ2xqCfiaAjaNRaLMOsop2UmjJLxbc1owaAq1vggPMk5Dy0OAtI2na0uQCbyPxg
        udWKERRMSfX/uV3+nPCKcvM/IKjywt4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655222764;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NzQF6jjl6sCzOady0+DskTyshd/ZX+tm+xLmhj2laP4=;
        b=sFPbqA6iYLK1Vo5BvVIizbhLrHvs2Ru0tioBrzMMrxGpX/W4FfHH6BVhe7c/j09gbAnhdL
        RGWQqh45V2KmVhAw==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2F0C12C149;
        Tue, 14 Jun 2022 16:06:04 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id D4B6CA0638; Tue, 14 Jun 2022 18:06:03 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 04/10] ext4: Unindent codeblock in ext4_xattr_block_set()
Date:   Tue, 14 Jun 2022 18:05:18 +0200
Message-Id: <20220614160603.20566-4-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220614124146.21594-1-jack@suse.cz>
References: <20220614124146.21594-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3820; h=from:subject; bh=b0Q0FRkazKsuzkM3//e3DZoWquWYEbbD0gLdIO8gLP0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiqLG+OXP8x1Ee+UnOh+iY/DD0U5ajIub+6GepdrsG goG9uEeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYqixvgAKCRCcnaoHP2RA2RNqCA CNqrcESS9f7nTyjR06py40v2AB9LgNfpxoCfNWHANy8nZfU291RmhzDyTUOjG7UihVdto2wgD/BqtL t8+qCab7Y0UWzyS7x0A5FgNXvD/UHBpVmfJOFDHjn5+Ki4zga1VRSh2IRpu1cwqtr63Bh6PTImuZ5z Tn9yprQo81r/xrVvP0O0NNWGkFGT/Hc6Eazoa6T51i7CTt/cFF6SoXPqy0q0o2STvWL5eZm2G5XBrP FPkwSS9W1iqKBbNWfXclwBP/16fKBkZmfshTp8l+xufdiMYHgjWtVJKVIadGfgLYWUL8rD1BACseQG AJUp1yvPhJhVE31X0nP+q6OI8xnXCn
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remove unnecessary else (and thus indentation level) from a code block
in ext4_xattr_block_set(). It will also make following code changes
easier. No functional changes.

CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/xattr.c | 79 ++++++++++++++++++++++++-------------------------
 1 file changed, 39 insertions(+), 40 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 7fc40fb1e6b3..aadfae53d055 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1850,6 +1850,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 #define header(x) ((struct ext4_xattr_header *)(x))
 
 	if (s->base) {
+		int offset = (char *)s->here - bs->bh->b_data;
+
 		BUFFER_TRACE(bs->bh, "get_write_access");
 		error = ext4_journal_get_write_access(handle, sb, bs->bh,
 						      EXT4_JTR_NONE);
@@ -1882,50 +1884,47 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			if (error)
 				goto cleanup;
 			goto inserted;
-		} else {
-			int offset = (char *)s->here - bs->bh->b_data;
+		}
+		unlock_buffer(bs->bh);
+		ea_bdebug(bs->bh, "cloning");
+		s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
+		error = -ENOMEM;
+		if (s->base == NULL)
+			goto cleanup;
+		memcpy(s->base, BHDR(bs->bh), bs->bh->b_size);
+		s->first = ENTRY(header(s->base)+1);
+		header(s->base)->h_refcount = cpu_to_le32(1);
+		s->here = ENTRY(s->base + offset);
+		s->end = s->base + bs->bh->b_size;
 
-			unlock_buffer(bs->bh);
-			ea_bdebug(bs->bh, "cloning");
-			s->base = kmalloc(bs->bh->b_size, GFP_NOFS);
-			error = -ENOMEM;
-			if (s->base == NULL)
+		/*
+		 * If existing entry points to an xattr inode, we need
+		 * to prevent ext4_xattr_set_entry() from decrementing
+		 * ref count on it because the reference belongs to the
+		 * original block. In this case, make the entry look
+		 * like it has an empty value.
+		 */
+		if (!s->not_found && s->here->e_value_inum) {
+			ea_ino = le32_to_cpu(s->here->e_value_inum);
+			error = ext4_xattr_inode_iget(inode, ea_ino,
+				      le32_to_cpu(s->here->e_hash),
+				      &tmp_inode);
+			if (error)
 				goto cleanup;
-			memcpy(s->base, BHDR(bs->bh), bs->bh->b_size);
-			s->first = ENTRY(header(s->base)+1);
-			header(s->base)->h_refcount = cpu_to_le32(1);
-			s->here = ENTRY(s->base + offset);
-			s->end = s->base + bs->bh->b_size;
 
-			/*
-			 * If existing entry points to an xattr inode, we need
-			 * to prevent ext4_xattr_set_entry() from decrementing
-			 * ref count on it because the reference belongs to the
-			 * original block. In this case, make the entry look
-			 * like it has an empty value.
-			 */
-			if (!s->not_found && s->here->e_value_inum) {
-				ea_ino = le32_to_cpu(s->here->e_value_inum);
-				error = ext4_xattr_inode_iget(inode, ea_ino,
-					      le32_to_cpu(s->here->e_hash),
-					      &tmp_inode);
-				if (error)
-					goto cleanup;
-
-				if (!ext4_test_inode_state(tmp_inode,
-						EXT4_STATE_LUSTRE_EA_INODE)) {
-					/*
-					 * Defer quota free call for previous
-					 * inode until success is guaranteed.
-					 */
-					old_ea_inode_quota = le32_to_cpu(
-							s->here->e_value_size);
-				}
-				iput(tmp_inode);
-
-				s->here->e_value_inum = 0;
-				s->here->e_value_size = 0;
+			if (!ext4_test_inode_state(tmp_inode,
+					EXT4_STATE_LUSTRE_EA_INODE)) {
+				/*
+				 * Defer quota free call for previous
+				 * inode until success is guaranteed.
+				 */
+				old_ea_inode_quota = le32_to_cpu(
+						s->here->e_value_size);
 			}
+			iput(tmp_inode);
+
+			s->here->e_value_inum = 0;
+			s->here->e_value_size = 0;
 		}
 	} else {
 		/* Allocate a buffer where we construct the new block. */
-- 
2.35.3

