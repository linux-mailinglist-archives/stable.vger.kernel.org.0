Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E64354B55C
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 18:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356426AbiFNQGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 12:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344072AbiFNQGK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 12:06:10 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF89C3E5C4;
        Tue, 14 Jun 2022 09:06:05 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 4648821BA9;
        Tue, 14 Jun 2022 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1655222764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oywNUz5AJxJGQS/S4TwqmPZC3zYUkQpZ1pG7Zrgrw/I=;
        b=ANvzpgu/y8K/FVhWu0CwFxMfZIgZI/pmpVEk+5dlqzsYDEnCqNEbh/jF2Hq/mab2jHN7An
        coZlfjBENvF2IM2gNczksk08WTNctOOnE/SLn+Gix5Dww7c150y3ewCNEiaGbyNocPZTPZ
        h/OAYjra66OLF5q2rP4KxkmZoALzVc8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1655222764;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oywNUz5AJxJGQS/S4TwqmPZC3zYUkQpZ1pG7Zrgrw/I=;
        b=8L47UKkxCjTp7G00c9QE6sAWKDUanJwjaMJKyYxOL4x4saMxDRqYlMAm9oxk81elhgC4cc
        4cRDfFHVBHJDNODA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 274F72C142;
        Tue, 14 Jun 2022 16:06:04 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id CD0E0A0637; Tue, 14 Jun 2022 18:06:03 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Subject: [PATCH 03/10] ext4: Remove EA inode entry from mbcache on inode eviction
Date:   Tue, 14 Jun 2022 18:05:17 +0200
Message-Id: <20220614160603.20566-3-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220614124146.21594-1-jack@suse.cz>
References: <20220614124146.21594-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3631; h=from:subject; bh=Rqg6o/lSmRio+PHAlM3U8k5/eMarefy35m+9vLzUtIQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBiqLG9CsXqqv3TVjFtV/DNyhvcL5aF8/fhLz5l684F 4sbPCiSJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCYqixvQAKCRCcnaoHP2RA2UnGCA C2uqDyFFtkDTMG66iQaG8RYD/TzxpLFkUb1ZgTZsJTCl+9FF+B5+NQSm++rnlR6JSnzcwk9K5RwJAn uiO93Gz6jawpjwBty7/Hdjf/ABSXWPBVLFWgt77jqRWSM2xROgV9d5BuHGp7M2Z4eQH+PajmLhGzNV hum50+ekuDjX8qkbQvLMG1gbF6+SIM8r47YRyHmg//alOlDuMhg2c8ecJN9IJctLeoiX9fqmFRUTsT OPFBhHc7SyS5Cdth1n14Xi/UIVDdTb5n3zqpisDJ5iba9hwT/ApvDHHGG/xSFMNeJY8WSYVXTbOQ9K cXUtve9gRoqQF76LxLBPtlOFnVwUHA
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
---
 fs/ext4/inode.c |  2 ++
 fs/ext4/xattr.c | 24 ++++++++----------------
 fs/ext4/xattr.h |  1 +
 3 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 3dce7d058985..7450ee734262 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -177,6 +177,8 @@ void ext4_evict_inode(struct inode *inode)
 
 	trace_ext4_evict_inode(inode);
 
+	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)
+		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
 		/*
 		 * When journalling data dirty buffers are tracked only in the
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 042325349098..7fc40fb1e6b3 100644
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
index 77efb9a627ad..060b7a2f485c 100644
--- a/fs/ext4/xattr.h
+++ b/fs/ext4/xattr.h
@@ -178,6 +178,7 @@ extern void ext4_xattr_inode_array_free(struct ext4_xattr_inode_array *array);
 
 extern int ext4_expand_extra_isize_ea(struct inode *inode, int new_extra_isize,
 			    struct ext4_inode *raw_inode, handle_t *handle);
+extern void ext4_evict_ea_inode(struct inode *inode);
 
 extern const struct xattr_handler *ext4_xattr_handlers[];
 
-- 
2.35.3

