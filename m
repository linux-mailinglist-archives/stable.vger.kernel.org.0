Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10FE266C912
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbjAPQqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:46:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbjAPQph (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:45:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63552F7A8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:33:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 530166104F
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C91C433D2;
        Mon, 16 Jan 2023 16:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886788;
        bh=0vAp1rcYJAz6nVK/IdQyD4twSfeO9EYkiEe22id3hQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JOCIcMjN2eLwMdTBz7RM6UtOZZnfydpUX8i+ZRCsMZIFjIKW6c3OJI04p+otlE3h/
         888ksqpSuH4HEG1vKE9HCOtC1NEVd/TmW9Jx6IXzrUeghYSIO8/G0MAP9hJhLQzcox
         xPZh/Ea8AW7WPAccP6mTiytZnZveuX8ORuDBdFQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 563/658] ext4: remove EA inode entry from mbcache on inode eviction
Date:   Mon, 16 Jan 2023 16:50:51 +0100
Message-Id: <20230116154935.245958733@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit 6bc0d63dad7f9f54d381925ee855b402f652fa39 ]

Currently we remove EA inode from mbcache as soon as its xattr refcount
drops to zero. However there can be pending attempts to reuse the inode
and thus refcount handling code has to handle the situation when
refcount increases from zero anyway. So save some work and just keep EA
inode in mbcache until it is getting evicted. At that moment we are sure
following iget() of EA inode will fail anyway (or wait for eviction to
finish and load things from the disk again) and so removing mbcache
entry at that moment is fine and simplifies the code a bit.

CC: stable@vger.kernel.org
Fixes: 82939d7999df ("ext4: convert to mbcache2")
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20220712105436.32204-3-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a44e84a9b776 ("ext4: fix deadlock due to mbcache entry corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c |  2 ++
 fs/ext4/xattr.c | 24 ++++++++----------------
 fs/ext4/xattr.h |  1 +
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a26e5ed6d61c..b38427b8d083 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -207,6 +207,8 @@ void ext4_evict_inode(struct inode *inode)
 
 	trace_ext4_evict_inode(inode);
 
+	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)
+		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
 		/*
 		 * When journalling data dirty buffers are tracked only in the
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 8f0e8b60ea20..4ade87a32315 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -434,6 +434,14 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 	return err;
 }
 
+/* Remove entry from mbcache when EA inode is getting evicted */
+void ext4_evict_ea_inode(struct inode *inode)
+{
+	if (EA_INODE_CACHE(inode))
+		mb_cache_entry_delete(EA_INODE_CACHE(inode),
+			ext4_xattr_inode_get_hash(inode), inode->i_ino);
+}
+
 static int
 ext4_xattr_inode_verify_hashes(struct inode *ea_inode,
 			       struct ext4_xattr_entry *entry, void *buffer,
@@ -1019,10 +1027,8 @@ static int ext4_xattr_ensure_credits(handle_t *handle, struct inode *inode,
 static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
 				       int ref_change)
 {
-	struct mb_cache *ea_inode_cache = EA_INODE_CACHE(ea_inode);
 	struct ext4_iloc iloc;
 	s64 ref_count;
-	u32 hash;
 	int ret;
 
 	inode_lock(ea_inode);
@@ -1045,14 +1051,6 @@ static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
 
 			set_nlink(ea_inode, 1);
 			ext4_orphan_del(handle, ea_inode);
-
-			if (ea_inode_cache) {
-				hash = ext4_xattr_inode_get_hash(ea_inode);
-				mb_cache_entry_create(ea_inode_cache,
-						      GFP_NOFS, hash,
-						      ea_inode->i_ino,
-						      true /* reusable */);
-			}
 		}
 	} else {
 		WARN_ONCE(ref_count < 0, "EA inode %lu ref_count=%lld",
@@ -1065,12 +1063,6 @@ static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
 
 			clear_nlink(ea_inode);
 			ext4_orphan_add(handle, ea_inode);
-
-			if (ea_inode_cache) {
-				hash = ext4_xattr_inode_get_hash(ea_inode);
-				mb_cache_entry_delete(ea_inode_cache, hash,
-						      ea_inode->i_ino);
-			}
 		}
 	}
 
diff --git a/fs/ext4/xattr.h b/fs/ext4/xattr.h
index 990084e00374..231ef308d10c 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -190,6 +190,7 @@ extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
 
 extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			    struct ext4_inode *raw_inode, handle_t *handle);
+extern void ext4_evict_ea_inode(struct inode *inode);
 
 extern const struct xattr_handler *ext4_xattr_handlers[];
 
-- 
2.35.1



