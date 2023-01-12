Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8828E6677D9
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240062AbjALOtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239810AbjALOtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:49:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4188FE030
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:36:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAB116202D
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62F1C433D2;
        Thu, 12 Jan 2023 14:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534175;
        bh=Qox4VgHxX58wLY10NdN5SvYSrYIM/n29LmG2WeU5/ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKjgYXbRSw/SvneXThWcoVCPKwBpkCIixtjRp7yJaLf6Js5KMalVDGDxFYEw17Clb
         h7GDinThifCnlUdM+chMBPKdLPVI1rav9L8DRa0yRy0znbGArJwG7DXc9qm3lW5rYq
         FWYoEDlIkN3LRt+ZFKHVQv1J+iLP9qE93kqofgLk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 720/783] ext4: unindent codeblock in ext4_xattr_block_set()
Date:   Thu, 12 Jan 2023 14:57:16 +0100
Message-Id: <20230112135557.740943761@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit fd48e9acdf26d0cbd80051de07d4a735d05d29b2 ]

Remove unnecessary else (and thus indentation level) from a code block
in ext4_xattr_block_set(). It will also make following code changes
easier. No functional changes.

CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220712105436.32204-4-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a44e84a9b776 ("ext4: fix deadlock due to mbcache entry corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/xattr.c | 77 ++++++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 39 deletions(-)

diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 0555f32f0fd4..9d5ccc90eb63 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1846,6 +1846,8 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 #define header(x) ((struct ext4_xattr_header *)(x))
 
 	if (s->base) {
+		int offset = (char *)s->here - bs->bh->b_data;
+
 		BUFFER_TRACE(bs->bh, "get_write_access");
 		error = ext4_journal_get_write_access(handle, bs->bh);
 		if (error)
@@ -1877,49 +1879,46 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			if (error)
 				goto cleanup;
 			goto inserted;
-		} else {
-			int offset = (char *)s->here - bs->bh->b_data;
+		}
+		unlock_buffer(bs->bh);
+		ea_bdebug(bs->bh, "cloning");
+		s->base = kmemdup(BHDR(bs->bh), bs->bh->b_size, GFP_NOFS);
+		error = -ENOMEM;
+		if (s->base == NULL)
+			goto cleanup;
+		s->first = ENTRY(header(s->base)+1);
+		header(s->base)->h_refcount = cpu_to_le32(1);
+		s->here = ENTRY(s->base + offset);
+		s->end = s->base + bs->bh->b_size;
 
-			unlock_buffer(bs->bh);
-			ea_bdebug(bs->bh, "cloning");
-			s->base = kmemdup(BHDR(bs->bh), bs->bh->b_size, GFP_NOFS);
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
2.35.1



