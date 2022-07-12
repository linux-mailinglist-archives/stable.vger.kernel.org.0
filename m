Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27E345717A6
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 12:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiGLKyl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 06:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiGLKyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 06:54:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27F3AE3BD;
        Tue, 12 Jul 2022 03:54:38 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 6E4FF2295C;
        Tue, 12 Jul 2022 10:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1657623277; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NzQF6jjl6sCzOady0+DskTyshd/ZX+tm+xLmhj2laP4=;
        b=a0oNfKPlH+i1dGooMHLVGCcIthIIhrKQlzZ5Q0az2fbXG999QPX9ADZLOR21KNrxpWaA7U
        LGZcgfiAwk6zdElj1aWatoDxYXFwnp3D6KQs/67EnfhBdjKOvWQUVZ37JGkenI4szqJPRF
        bXwjih+ZNewSdLU0d42iqQcv7JylO0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1657623277;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NzQF6jjl6sCzOady0+DskTyshd/ZX+tm+xLmhj2laP4=;
        b=kemXKntCLtcSqgepGXeYLq0sz8/XE2/zAr8kX5KT7mUmhyaKXBLHip03o75HzWpy/r3gpH
        tvF2/q+qUENjo1BQ==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 5FA622C146;
        Tue, 12 Jul 2022 10:54:37 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 0F044A0643; Tue, 12 Jul 2022 12:54:37 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 04/10] ext4: Unindent codeblock in ext4_xattr_block_set()
Date:   Tue, 12 Jul 2022 12:54:23 +0200
Message-Id: <20220712105436.32204-4-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220712104519.29887-1-jack@suse.cz>
References: <20220712104519.29887-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3820; h=from:subject; bh=b0Q0FRkazKsuzkM3//e3DZoWquWYEbbD0gLdIO8gLP0=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBizVLfOXP8x1Ee+UnOh+iY/DD0U5ajIub+6GepdrsG goG9uEeJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYs1S3wAKCRCcnaoHP2RA2XhFCA DIth+vrqjCgzsOaFn+cU8sETzzV6zGYBWkg8oxSPn5FH5rwA/iomHyMpDHgTRfVDn1fijjABufnfmO 0p9+plgqUpT2n5VRxyD4ncsjsPu3+9sqS8lcIo+nTdD8g8CF0UP/sqz+8Z4XSM3N8sJVqFRfgf9Jzc 4exHjnSp14aEweDfnCL9tQd7c74Or7GB6cOnD+1EGqSxbj2reds1stsMKOqv/0NxNvA/SX9apwInA4 +7Dwu/fMwhHnQgLqp4AnsR9ljd05zvaqLIN6DRiMa1l9tCN9QB0fSssaxtwd7OzKZ+jeG4jSUCg7VE QHQo7KyPvO7C4MwUY0XdEPEli86hYP
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

