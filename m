Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67AD56FC20
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiGKJjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbiGKJjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:39:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66BA501AF;
        Mon, 11 Jul 2022 02:20:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C60FB80E6D;
        Mon, 11 Jul 2022 09:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AABDC34115;
        Mon, 11 Jul 2022 09:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531205;
        bh=mh8G2iS5VNUGeerfvoPdRHC6B3Jn8BQ3uuNu5i2Z+gw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOyIT7yyLaFIveWAveD6ax1QRcXJ/samm3BAvKCMoG3oEGVT8c1TN5dnC4mqOZiyV
         SIefgZJa7xXGLfDAPhTWfQvESMgDWBmELcgjkhkUhs17oZn6L4PDX66aMGEPT4j65w
         whmBiFbOSr5c5JOJddE6H4vHzhgpIX51U1mWGvRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/230] btrfs: add additional parameters to btrfs_init_tree_ref/btrfs_init_data_ref
Date:   Mon, 11 Jul 2022 11:04:37 +0200
Message-Id: <20220711090604.675057261@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Borisov <nborisov@suse.com>

[ Upstream commit f42c5da6c12e990d8ec415199600b4d593c63bf5 ]

In order to make 'real_root' used only in ref-verify it's required to
have the necessary context to perform the same checks that this member
is used for. So add 'mod_root' which will contain the root on behalf of
which a delayed ref was created and a 'skip_group' parameter which
will contain callsite-specific override of skip_qgroup.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-ref.h |  5 +++--
 fs/btrfs/extent-tree.c | 17 +++++++++++------
 fs/btrfs/file.c        | 13 ++++++++-----
 fs/btrfs/inode.c       |  3 ++-
 fs/btrfs/relocation.c  | 21 ++++++++++++++-------
 fs/btrfs/tree-log.c    |  2 +-
 6 files changed, 39 insertions(+), 22 deletions(-)

diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
index e22fba272e4f..31266ba1d430 100644
--- a/fs/btrfs/delayed-ref.h
+++ b/fs/btrfs/delayed-ref.h
@@ -271,7 +271,7 @@ static inline void btrfs_init_generic_ref(struct btrfs_ref *generic_ref,
 }
 
 static inline void btrfs_init_tree_ref(struct btrfs_ref *generic_ref,
-				int level, u64 root)
+				int level, u64 root, u64 mod_root, bool skip_qgroup)
 {
 	/* If @real_root not set, use @root as fallback */
 	if (!generic_ref->real_root)
@@ -282,7 +282,8 @@ static inline void btrfs_init_tree_ref(struct btrfs_ref *generic_ref,
 }
 
 static inline void btrfs_init_data_ref(struct btrfs_ref *generic_ref,
-				u64 ref_root, u64 ino, u64 offset)
+				u64 ref_root, u64 ino, u64 offset, u64 mod_root,
+				bool skip_qgroup)
 {
 	/* If @real_root not set, use @root as fallback */
 	if (!generic_ref->real_root)
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 514adc83577f..e01b9344fb9c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2440,7 +2440,8 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 					       num_bytes, parent);
 			generic_ref.real_root = root->root_key.objectid;
 			btrfs_init_data_ref(&generic_ref, ref_root, key.objectid,
-					    key.offset);
+					    key.offset, root->root_key.objectid,
+					    for_reloc);
 			generic_ref.skip_qgroup = for_reloc;
 			if (inc)
 				ret = btrfs_inc_extent_ref(trans, &generic_ref);
@@ -2454,7 +2455,8 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 			btrfs_init_generic_ref(&generic_ref, action, bytenr,
 					       num_bytes, parent);
 			generic_ref.real_root = root->root_key.objectid;
-			btrfs_init_tree_ref(&generic_ref, level - 1, ref_root);
+			btrfs_init_tree_ref(&generic_ref, level - 1, ref_root,
+					    root->root_key.objectid, for_reloc);
 			generic_ref.skip_qgroup = for_reloc;
 			if (inc)
 				ret = btrfs_inc_extent_ref(trans, &generic_ref);
@@ -3289,7 +3291,7 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_init_generic_ref(&generic_ref, BTRFS_DROP_DELAYED_REF,
 			       buf->start, buf->len, parent);
 	btrfs_init_tree_ref(&generic_ref, btrfs_header_level(buf),
-			    root->root_key.objectid);
+			    root->root_key.objectid, 0, false);
 
 	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
 		btrfs_ref_tree_mod(fs_info, &generic_ref);
@@ -4705,7 +4707,8 @@ int btrfs_alloc_reserved_file_extent(struct btrfs_trans_handle *trans,
 
 	btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_EXTENT,
 			       ins->objectid, ins->offset, 0);
-	btrfs_init_data_ref(&generic_ref, root->root_key.objectid, owner, offset);
+	btrfs_init_data_ref(&generic_ref, root->root_key.objectid, owner,
+			    offset, 0, false);
 	btrfs_ref_tree_mod(root->fs_info, &generic_ref);
 
 	return btrfs_add_delayed_data_ref(trans, &generic_ref, ram_bytes);
@@ -4898,7 +4901,8 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
 		btrfs_init_generic_ref(&generic_ref, BTRFS_ADD_DELAYED_EXTENT,
 				       ins.objectid, ins.offset, parent);
 		generic_ref.real_root = root->root_key.objectid;
-		btrfs_init_tree_ref(&generic_ref, level, root_objectid);
+		btrfs_init_tree_ref(&generic_ref, level, root_objectid,
+				    root->root_key.objectid, false);
 		btrfs_ref_tree_mod(fs_info, &generic_ref);
 		ret = btrfs_add_delayed_tree_ref(trans, &generic_ref, extent_op);
 		if (ret)
@@ -5315,7 +5319,8 @@ static noinline int do_walk_down(struct btrfs_trans_handle *trans,
 
 		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, bytenr,
 				       fs_info->nodesize, parent);
-		btrfs_init_tree_ref(&ref, level - 1, root->root_key.objectid);
+		btrfs_init_tree_ref(&ref, level - 1, root->root_key.objectid,
+				    0, false);
 		ret = btrfs_free_extent(trans, &ref);
 		if (ret)
 			goto out_unlock;
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a06c8366a8f4..1c597cd6c024 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -869,7 +869,8 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 				btrfs_init_data_ref(&ref,
 						root->root_key.objectid,
 						new_key.objectid,
-						args->start - extent_offset);
+						args->start - extent_offset,
+						0, false);
 				ret = btrfs_inc_extent_ref(trans, &ref);
 				BUG_ON(ret); /* -ENOMEM */
 			}
@@ -955,7 +956,8 @@ int btrfs_drop_extents(struct btrfs_trans_handle *trans,
 				btrfs_init_data_ref(&ref,
 						root->root_key.objectid,
 						key.objectid,
-						key.offset - extent_offset);
+						key.offset - extent_offset, 0,
+						false);
 				ret = btrfs_free_extent(trans, &ref);
 				BUG_ON(ret); /* -ENOMEM */
 				args->bytes_found += extent_end - key.offset;
@@ -1232,7 +1234,7 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, bytenr,
 				       num_bytes, 0);
 		btrfs_init_data_ref(&ref, root->root_key.objectid, ino,
-				    orig_offset);
+				    orig_offset, 0, false);
 		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
@@ -1257,7 +1259,8 @@ int btrfs_mark_extent_written(struct btrfs_trans_handle *trans,
 	other_end = 0;
 	btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, bytenr,
 			       num_bytes, 0);
-	btrfs_init_data_ref(&ref, root->root_key.objectid, ino, orig_offset);
+	btrfs_init_data_ref(&ref, root->root_key.objectid, ino, orig_offset,
+			    0, false);
 	if (extent_mergeable(leaf, path->slots[0] + 1,
 			     ino, bytenr, orig_offset,
 			     &other_start, &other_end)) {
@@ -2715,7 +2718,7 @@ static int btrfs_insert_replace_extent(struct btrfs_trans_handle *trans,
 				       extent_info->disk_len, 0);
 		ref_offset = extent_info->file_offset - extent_info->data_offset;
 		btrfs_init_data_ref(&ref, root->root_key.objectid,
-				    btrfs_ino(inode), ref_offset);
+				    btrfs_ino(inode), ref_offset, 0, false);
 		ret = btrfs_inc_extent_ref(trans, &ref);
 	}
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 044d584c3467..d644dcaf3004 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4919,7 +4919,8 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
 					extent_start, extent_num_bytes, 0);
 			ref.real_root = root->root_key.objectid;
 			btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
-					ino, extent_offset);
+					ino, extent_offset,
+					root->root_key.objectid, false);
 			ret = btrfs_free_extent(trans, &ref);
 			if (ret) {
 				btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a6661f2ad2c0..0300770c0a89 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1147,7 +1147,8 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 				       num_bytes, parent);
 		ref.real_root = root->root_key.objectid;
 		btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
-				    key.objectid, key.offset);
+				    key.objectid, key.offset,
+				    root->root_key.objectid, false);
 		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
@@ -1158,7 +1159,8 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 				       num_bytes, parent);
 		ref.real_root = root->root_key.objectid;
 		btrfs_init_data_ref(&ref, btrfs_header_owner(leaf),
-				    key.objectid, key.offset);
+				    key.objectid, key.offset,
+				    root->root_key.objectid, false);
 		ret = btrfs_free_extent(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
@@ -1368,7 +1370,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, old_bytenr,
 				       blocksize, path->nodes[level]->start);
 		ref.skip_qgroup = true;
-		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid);
+		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid,
+				    0, true);
 		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
@@ -1377,7 +1380,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		btrfs_init_generic_ref(&ref, BTRFS_ADD_DELAYED_REF, new_bytenr,
 				       blocksize, 0);
 		ref.skip_qgroup = true;
-		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid);
+		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid, 0,
+				    true);
 		ret = btrfs_inc_extent_ref(trans, &ref);
 		if (ret) {
 			btrfs_abort_transaction(trans, ret);
@@ -1386,7 +1390,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 
 		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, new_bytenr,
 				       blocksize, path->nodes[level]->start);
-		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid);
+		btrfs_init_tree_ref(&ref, level - 1, src->root_key.objectid,
+				    0, true);
 		ref.skip_qgroup = true;
 		ret = btrfs_free_extent(trans, &ref);
 		if (ret) {
@@ -1396,7 +1401,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 
 		btrfs_init_generic_ref(&ref, BTRFS_DROP_DELAYED_REF, old_bytenr,
 				       blocksize, 0);
-		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid);
+		btrfs_init_tree_ref(&ref, level - 1, dest->root_key.objectid,
+				    0, true);
 		ref.skip_qgroup = true;
 		ret = btrfs_free_extent(trans, &ref);
 		if (ret) {
@@ -2475,7 +2481,8 @@ static int do_relocation(struct btrfs_trans_handle *trans,
 					       upper->eb->start);
 			ref.real_root = root->root_key.objectid;
 			btrfs_init_tree_ref(&ref, node->level,
-					    btrfs_header_owner(upper->eb));
+					    btrfs_header_owner(upper->eb),
+					    root->root_key.objectid, false);
 			ret = btrfs_inc_extent_ref(trans, &ref);
 			if (!ret)
 				ret = btrfs_drop_subtree(trans, root, eb,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1221d8483d63..bed6811476b0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -761,7 +761,7 @@ static noinline int replay_one_extent(struct btrfs_trans_handle *trans,
 						ins.objectid, ins.offset, 0);
 				btrfs_init_data_ref(&ref,
 						root->root_key.objectid,
-						key->objectid, offset);
+						key->objectid, offset, 0, false);
 				ret = btrfs_inc_extent_ref(trans, &ref);
 				if (ret)
 					goto out;
-- 
2.35.1



