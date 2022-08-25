Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5480E5A0693
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbiHYBmS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbiHYBla (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:41:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978019D8EF;
        Wed, 24 Aug 2022 18:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E73E61AF3;
        Thu, 25 Aug 2022 01:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED376C4347C;
        Thu, 25 Aug 2022 01:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391504;
        bh=8N+mzoNMN7tQAB6gKqF+atcRFl7OB0EncNmJEg7+B8U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HvGbfRhKFhHMQ/QYljq6ycIj0VsFAF0jQYWXVUEZn+am+8oVTaq49LlFppA+BomTn
         7pEarfRBVapDOWGG74Qeejkj+/90SPOEc0zp/JSwzbwkDWWd0MeFfSs27Dm/eW6g1Y
         NLeqHJciwJfq7O84Ok0cmUoRqdAVhsEnzE8/mfJ6H1N4aCIK8gG9+T4XgHGB5PSsYv
         g9gnYDpR+2F9aKGPn3hZehWAVTGtknTCz3Sy1Ji0YePz3KypLz/ebzbqK7YOwhsDUS
         8s6h/yyfsvCuk9JKx7B/xUmPpdBQ1ok039PFEH9SjCo1N7MgAurjyWzIoPqPcFFSZe
         miEo0lYOUHKzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 17/20] btrfs: move lockdep class helpers to locking.c
Date:   Wed, 24 Aug 2022 21:37:09 -0400
Message-Id: <20220825013713.22656-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013713.22656-1-sashal@kernel.org>
References: <20220825013713.22656-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 0a27a0474d146eb79e09ec88bf0d4229f4cfc1b8 ]

These definitions exist in disk-io.c, which is not related to the
locking.  Move this over to locking.h/c where it makes more sense.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 82 ----------------------------------------------
 fs/btrfs/disk-io.h | 10 ------
 fs/btrfs/locking.c | 80 ++++++++++++++++++++++++++++++++++++++++++++
 fs/btrfs/locking.h |  9 +++++
 4 files changed, 89 insertions(+), 92 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e65c3039caf1..c9edc668b3d9 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -121,88 +121,6 @@ struct async_submit_bio {
 	blk_status_t status;
 };
 
-/*
- * Lockdep class keys for extent_buffer->lock's in this root.  For a given
- * eb, the lockdep key is determined by the btrfs_root it belongs to and
- * the level the eb occupies in the tree.
- *
- * Different roots are used for different purposes and may nest inside each
- * other and they require separate keysets.  As lockdep keys should be
- * static, assign keysets according to the purpose of the root as indicated
- * by btrfs_root->root_key.objectid.  This ensures that all special purpose
- * roots have separate keysets.
- *
- * Lock-nesting across peer nodes is always done with the immediate parent
- * node locked thus preventing deadlock.  As lockdep doesn't know this, use
- * subclass to avoid triggering lockdep warning in such cases.
- *
- * The key is set by the readpage_end_io_hook after the buffer has passed
- * csum validation but before the pages are unlocked.  It is also set by
- * btrfs_init_new_buffer on freshly allocated blocks.
- *
- * We also add a check to make sure the highest level of the tree is the
- * same as our lockdep setup here.  If BTRFS_MAX_LEVEL changes, this code
- * needs update as well.
- */
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# if BTRFS_MAX_LEVEL != 8
-#  error
-# endif
-
-#define DEFINE_LEVEL(stem, level)					\
-	.names[level] = "btrfs-" stem "-0" #level,
-
-#define DEFINE_NAME(stem)						\
-	DEFINE_LEVEL(stem, 0)						\
-	DEFINE_LEVEL(stem, 1)						\
-	DEFINE_LEVEL(stem, 2)						\
-	DEFINE_LEVEL(stem, 3)						\
-	DEFINE_LEVEL(stem, 4)						\
-	DEFINE_LEVEL(stem, 5)						\
-	DEFINE_LEVEL(stem, 6)						\
-	DEFINE_LEVEL(stem, 7)
-
-static struct btrfs_lockdep_keyset {
-	u64			id;		/* root objectid */
-	/* Longest entry: btrfs-free-space-00 */
-	char			names[BTRFS_MAX_LEVEL][20];
-	struct lock_class_key	keys[BTRFS_MAX_LEVEL];
-} btrfs_lockdep_keysets[] = {
-	{ .id = BTRFS_ROOT_TREE_OBJECTID,	DEFINE_NAME("root")	},
-	{ .id = BTRFS_EXTENT_TREE_OBJECTID,	DEFINE_NAME("extent")	},
-	{ .id = BTRFS_CHUNK_TREE_OBJECTID,	DEFINE_NAME("chunk")	},
-	{ .id = BTRFS_DEV_TREE_OBJECTID,	DEFINE_NAME("dev")	},
-	{ .id = BTRFS_CSUM_TREE_OBJECTID,	DEFINE_NAME("csum")	},
-	{ .id = BTRFS_QUOTA_TREE_OBJECTID,	DEFINE_NAME("quota")	},
-	{ .id = BTRFS_TREE_LOG_OBJECTID,	DEFINE_NAME("log")	},
-	{ .id = BTRFS_TREE_RELOC_OBJECTID,	DEFINE_NAME("treloc")	},
-	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	DEFINE_NAME("dreloc")	},
-	{ .id = BTRFS_UUID_TREE_OBJECTID,	DEFINE_NAME("uuid")	},
-	{ .id = BTRFS_FREE_SPACE_TREE_OBJECTID,	DEFINE_NAME("free-space") },
-	{ .id = 0,				DEFINE_NAME("tree")	},
-};
-
-#undef DEFINE_LEVEL
-#undef DEFINE_NAME
-
-void btrfs_set_buffer_lockdep_class(u64 objectid, struct extent_buffer *eb,
-				    int level)
-{
-	struct btrfs_lockdep_keyset *ks;
-
-	BUG_ON(level >= ARRAY_SIZE(ks->keys));
-
-	/* find the matching keyset, id 0 is the default entry */
-	for (ks = btrfs_lockdep_keysets; ks->id; ks++)
-		if (ks->id == objectid)
-			break;
-
-	lockdep_set_class_and_name(&eb->lock,
-				   &ks->keys[level], ks->names[level]);
-}
-
-#endif
-
 /*
  * Compute the csum of a btree block and store the result to provided buffer.
  */
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 0e7e9526b6a8..1b8fd3deafc9 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -140,14 +140,4 @@ int btrfs_init_root_free_objectid(struct btrfs_root *root);
 int __init btrfs_end_io_wq_init(void);
 void __cold btrfs_end_io_wq_exit(void);
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-void btrfs_set_buffer_lockdep_class(u64 objectid,
-			            struct extent_buffer *eb, int level);
-#else
-static inline void btrfs_set_buffer_lockdep_class(u64 objectid,
-					struct extent_buffer *eb, int level)
-{
-}
-#endif
-
 #endif
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 33461b4f9c8b..5747c63929df 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -13,6 +13,86 @@
 #include "extent_io.h"
 #include "locking.h"
 
+/*
+ * Lockdep class keys for extent_buffer->lock's in this root.  For a given
+ * eb, the lockdep key is determined by the btrfs_root it belongs to and
+ * the level the eb occupies in the tree.
+ *
+ * Different roots are used for different purposes and may nest inside each
+ * other and they require separate keysets.  As lockdep keys should be
+ * static, assign keysets according to the purpose of the root as indicated
+ * by btrfs_root->root_key.objectid.  This ensures that all special purpose
+ * roots have separate keysets.
+ *
+ * Lock-nesting across peer nodes is always done with the immediate parent
+ * node locked thus preventing deadlock.  As lockdep doesn't know this, use
+ * subclass to avoid triggering lockdep warning in such cases.
+ *
+ * The key is set by the readpage_end_io_hook after the buffer has passed
+ * csum validation but before the pages are unlocked.  It is also set by
+ * btrfs_init_new_buffer on freshly allocated blocks.
+ *
+ * We also add a check to make sure the highest level of the tree is the
+ * same as our lockdep setup here.  If BTRFS_MAX_LEVEL changes, this code
+ * needs update as well.
+ */
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#if BTRFS_MAX_LEVEL != 8
+#error
+#endif
+
+#define DEFINE_LEVEL(stem, level)					\
+	.names[level] = "btrfs-" stem "-0" #level,
+
+#define DEFINE_NAME(stem)						\
+	DEFINE_LEVEL(stem, 0)						\
+	DEFINE_LEVEL(stem, 1)						\
+	DEFINE_LEVEL(stem, 2)						\
+	DEFINE_LEVEL(stem, 3)						\
+	DEFINE_LEVEL(stem, 4)						\
+	DEFINE_LEVEL(stem, 5)						\
+	DEFINE_LEVEL(stem, 6)						\
+	DEFINE_LEVEL(stem, 7)
+
+static struct btrfs_lockdep_keyset {
+	u64			id;		/* root objectid */
+	/* Longest entry: btrfs-free-space-00 */
+	char			names[BTRFS_MAX_LEVEL][20];
+	struct lock_class_key	keys[BTRFS_MAX_LEVEL];
+} btrfs_lockdep_keysets[] = {
+	{ .id = BTRFS_ROOT_TREE_OBJECTID,	DEFINE_NAME("root")	},
+	{ .id = BTRFS_EXTENT_TREE_OBJECTID,	DEFINE_NAME("extent")	},
+	{ .id = BTRFS_CHUNK_TREE_OBJECTID,	DEFINE_NAME("chunk")	},
+	{ .id = BTRFS_DEV_TREE_OBJECTID,	DEFINE_NAME("dev")	},
+	{ .id = BTRFS_CSUM_TREE_OBJECTID,	DEFINE_NAME("csum")	},
+	{ .id = BTRFS_QUOTA_TREE_OBJECTID,	DEFINE_NAME("quota")	},
+	{ .id = BTRFS_TREE_LOG_OBJECTID,	DEFINE_NAME("log")	},
+	{ .id = BTRFS_TREE_RELOC_OBJECTID,	DEFINE_NAME("treloc")	},
+	{ .id = BTRFS_DATA_RELOC_TREE_OBJECTID,	DEFINE_NAME("dreloc")	},
+	{ .id = BTRFS_UUID_TREE_OBJECTID,	DEFINE_NAME("uuid")	},
+	{ .id = BTRFS_FREE_SPACE_TREE_OBJECTID,	DEFINE_NAME("free-space") },
+	{ .id = 0,				DEFINE_NAME("tree")	},
+};
+
+#undef DEFINE_LEVEL
+#undef DEFINE_NAME
+
+void btrfs_set_buffer_lockdep_class(u64 objectid, struct extent_buffer *eb, int level)
+{
+	struct btrfs_lockdep_keyset *ks;
+
+	BUG_ON(level >= ARRAY_SIZE(ks->keys));
+
+	/* Find the matching keyset, id 0 is the default entry */
+	for (ks = btrfs_lockdep_keysets; ks->id; ks++)
+		if (ks->id == objectid)
+			break;
+
+	lockdep_set_class_and_name(&eb->lock, &ks->keys[level], ks->names[level]);
+}
+
+#endif
+
 /*
  * Extent buffer locking
  * =====================
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index a2e1f1f5c6e3..97370ec0cd29 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -130,4 +130,13 @@ void btrfs_drew_write_unlock(struct btrfs_drew_lock *lock);
 void btrfs_drew_read_lock(struct btrfs_drew_lock *lock);
 void btrfs_drew_read_unlock(struct btrfs_drew_lock *lock);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+void btrfs_set_buffer_lockdep_class(u64 objectid, struct extent_buffer *eb, int level);
+#else
+static inline void btrfs_set_buffer_lockdep_class(u64 objectid,
+					struct extent_buffer *eb, int level)
+{
+}
+#endif
+
 #endif
-- 
2.35.1

