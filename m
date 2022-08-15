Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37EC593C91
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243729AbiHOT52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345849AbiHOT4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:56:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DA1760F0;
        Mon, 15 Aug 2022 11:52:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 908F86122E;
        Mon, 15 Aug 2022 18:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F39C433D7;
        Mon, 15 Aug 2022 18:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589541;
        bh=zLusqmtt8FCzf2eQCnY3drYtt3XHjinfQgVkLkJZbKE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZtqKpptIY8BgHd+2m69YtkhsPlf0r2LP2qkerFXRwO2wPGuojeOBXIRGrkWPcwLIm
         VUSZsyFmhMSWcbikGSFgnR3C/J/IeDCj8qeCMcozQJM8hCNFmjyIokdcGUl6M1+VZP
         vwcF3HmlZvxNnWiflrHlREoLP28dZbGrFFRMqxRU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 750/779] ext4: remove EA inode entry from mbcache on inode eviction
Date:   Mon, 15 Aug 2022 20:06:34 +0200
Message-Id: <20220815180409.535130622@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c |  2 ++
 fs/ext4/xattr.c | 24 ++++++++----------------
 fs/ext4/xattr.h |  1 +
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 360a7d153955..98f381f6fc18 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -179,6 +179,8 @@ void ext4_evict_inode(struct inode *inode)
 
 	trace_ext4_evict_inode(inode);
 
+	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)
+		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
 		/*
 		 * When journalling data dirty buffers are tracked only in the
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index c3c3194f3ee1..b57fd07fbdba 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -436,6 +436,14 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
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
@@ -976,10 +984,8 @@ int __ext4_xattr_set_credits(struct super_block *sb, struct inode *inode,
 static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
 				       int ref_change)
 {
-	struct mb_cache *ea_inode_cache = EA_INODE_CACHE(ea_inode);
 	struct ext4_iloc iloc;
 	s64 ref_count;
-	u32 hash;
 	int ret;
 
 	inode_lock(ea_inode);
@@ -1002,14 +1008,6 @@ static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
 
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
@@ -1022,12 +1020,6 @@ static int ext4_xattr_inode_update_ref(handle_t *handle, struct inode *ea_inode,
 
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
index f885f362add4..e5e36bd11f05 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -191,6 +191,7 @@ extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
 
 extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			    struct ext4_inode *raw_inode, handle_t *handle);
+extern void ext4_evict_ea_inode(struct inode *inode);
 
 extern const struct xattr_handler *ext4_xattr_handlers[];
 
-- 
2.35.1



