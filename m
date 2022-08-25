Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9CE45A0612
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiHYBil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbiHYBiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:38:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158D09C1E6;
        Wed, 24 Aug 2022 18:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1036CB826E0;
        Thu, 25 Aug 2022 01:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECD5C433D7;
        Thu, 25 Aug 2022 01:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391427;
        bh=T3r+/Pwj90M3kIgzbMwXY+0exEa8J8YV2LYUmrKgXwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hvdsYxS5swddMjWyE4awXIxZKGuqOlmkMajGteyyM379trGfu6fiqnNi/n/xmjRCv
         dKpC7NRB8hXg/34VEfW2LexjzGMBq5exVmPxcigxy+UXwmc3mK66CxaIy1IPguYzSy
         qRktE6+xNrPUucRjwId0cdW0w4ewB0zflQ8bZvkOgs4lMEbb7tu9duIfGJNqK5bhqK
         i9VHVOAuwUdKNTio5USF8S6tLFs6HYhLjZro1JY9BRqj1MuaN3JZkr7rAFpHRPhUnS
         On28Zo5r+9k5KWVOFlAFpwhbyS2/eUOOSosST1vsGNoIUejFsWdeC+IyuU9eSuRfhR
         6qLhcg7FnbatQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 35/38] btrfs: move lockdep class helpers to locking.c
Date:   Wed, 24 Aug 2022 21:33:58 -0400
Message-Id: <20220825013401.22096-35-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
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
index bc3030661583..a2505cfc6bc1 100644
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
index 4ee8c42c9f78..b4962b7d7117 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -148,14 +148,4 @@ int btrfs_init_root_free_objectid(struct btrfs_root *root);
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
index bbc45534ae9a..b21372cab840 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -131,4 +131,13 @@ void btrfs_drew_write_unlock(struct btrfs_drew_lock *lock);
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

