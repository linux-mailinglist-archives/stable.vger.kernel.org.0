Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F058B5FB56E
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiJKOyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiJKOxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:53:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18B39AFD7;
        Tue, 11 Oct 2022 07:51:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE60611AB;
        Tue, 11 Oct 2022 14:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159A8C433D6;
        Tue, 11 Oct 2022 14:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665499877;
        bh=cLXgvj0T9awL6P216CPUddH+QuGc2O3OJqYE4x8E1Qs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=asa3oU5K/OcebMz9tpZksnyDDZte989bgI724hU3B62Aa1FKtN3sRGk7dUiDiG1jl
         Rr+7lXEl97iWsyPLh4T2Y93Er53r3tDp03VIMfy4AvKB0FjpSoBy+mE/z4e8vITe88
         LPOtTGVtqWpB241t30lqflaX6RdobY7+w7684670F9MJjzECtUvy7f9FduCdhXLXqV
         5PesWpm/hARE59EVm+2thW92kH6wxQ64UAJm9C28foaZEZiVJY/yawHl9kaC2iaOeS
         K5W0GGCKTQ4zT1UYNQMUciJc5CshEtFmKk3izIoWNqwbXkJxt2EL4X35upZNGoEl0O
         4xLkDzmGcM2vQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 40/46] btrfs: separate out the eb and extent state leak helpers
Date:   Tue, 11 Oct 2022 10:50:08 -0400
Message-Id: <20221011145015.1622882-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221011145015.1622882-1-sashal@kernel.org>
References: <20221011145015.1622882-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit a40246e8afc0af3ffdee21854fb755c9364b8346 ]

Currently we have the add/del functions generic so that we can use them
for both extent buffers and extent states.  We want to separate this
code however, so separate these helpers into per-object helpers in
anticipation of the split.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 58 +++++++++++++++++++++++++++++---------------
 1 file changed, 38 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cf4f19e80e2f..d9d254b59bd1 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -44,25 +44,42 @@ static inline bool extent_state_in_tree(const struct extent_state *state)
 static LIST_HEAD(states);
 static DEFINE_SPINLOCK(leak_lock);
 
-static inline void btrfs_leak_debug_add(spinlock_t *lock,
-					struct list_head *new,
-					struct list_head *head)
+static inline void btrfs_leak_debug_add_eb(struct extent_buffer *eb)
+{
+	struct btrfs_fs_info *fs_info = eb->fs_info;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fs_info->eb_leak_lock, flags);
+	list_add(&eb->leak_list, &fs_info->allocated_ebs);
+	spin_unlock_irqrestore(&fs_info->eb_leak_lock, flags);
+}
+
+static inline void btrfs_leak_debug_add_state(struct extent_state *state)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(lock, flags);
-	list_add(new, head);
-	spin_unlock_irqrestore(lock, flags);
+	spin_lock_irqsave(&leak_lock, flags);
+	list_add(&state->leak_list, &states);
+	spin_unlock_irqrestore(&leak_lock, flags);
+}
+
+static inline void btrfs_leak_debug_del_eb(struct extent_buffer *eb)
+{
+	struct btrfs_fs_info *fs_info = eb->fs_info;
+	unsigned long flags;
+
+	spin_lock_irqsave(&fs_info->eb_leak_lock, flags);
+	list_del(&eb->leak_list);
+	spin_unlock_irqrestore(&fs_info->eb_leak_lock, flags);
 }
 
-static inline void btrfs_leak_debug_del(spinlock_t *lock,
-					struct list_head *entry)
+static inline void btrfs_leak_debug_del_state(struct extent_state *state)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(lock, flags);
-	list_del(entry);
-	spin_unlock_irqrestore(lock, flags);
+	spin_lock_irqsave(&leak_lock, flags);
+	list_del(&state->leak_list);
+	spin_unlock_irqrestore(&leak_lock, flags);
 }
 
 void btrfs_extent_buffer_leak_debug_check(struct btrfs_fs_info *fs_info)
@@ -126,9 +143,11 @@ static inline void __btrfs_debug_check_extent_io_range(const char *caller,
 	}
 }
 #else
-#define btrfs_leak_debug_add(lock, new, head)	do {} while (0)
-#define btrfs_leak_debug_del(lock, entry)	do {} while (0)
-#define btrfs_extent_state_leak_debug_check()	do {} while (0)
+#define btrfs_leak_debug_add_eb(eb)			do {} while (0)
+#define btrfs_leak_debug_add_state(state)		do {} while (0)
+#define btrfs_leak_debug_del_eb(eb)			do {} while (0)
+#define btrfs_leak_debug_del_state(state)		do {} while (0)
+#define btrfs_extent_state_leak_debug_check()		do {} while (0)
 #define btrfs_debug_check_extent_io_range(c, s, e)	do {} while (0)
 #endif
 
@@ -353,7 +372,7 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
 	state->state = 0;
 	state->failrec = NULL;
 	RB_CLEAR_NODE(&state->rb_node);
-	btrfs_leak_debug_add(&leak_lock, &state->leak_list, &states);
+	btrfs_leak_debug_add_state(state);
 	refcount_set(&state->refs, 1);
 	init_waitqueue_head(&state->wq);
 	trace_alloc_extent_state(state, mask, _RET_IP_);
@@ -366,7 +385,7 @@ void free_extent_state(struct extent_state *state)
 		return;
 	if (refcount_dec_and_test(&state->refs)) {
 		WARN_ON(extent_state_in_tree(state));
-		btrfs_leak_debug_del(&leak_lock, &state->leak_list);
+		btrfs_leak_debug_del_state(state);
 		trace_free_extent_state(state, _RET_IP_);
 		kmem_cache_free(extent_state_cache, state);
 	}
@@ -5856,7 +5875,7 @@ static void btrfs_release_extent_buffer_pages(struct extent_buffer *eb)
 static inline void btrfs_release_extent_buffer(struct extent_buffer *eb)
 {
 	btrfs_release_extent_buffer_pages(eb);
-	btrfs_leak_debug_del(&eb->fs_info->eb_leak_lock, &eb->leak_list);
+	btrfs_leak_debug_del_eb(eb);
 	__free_extent_buffer(eb);
 }
 
@@ -5873,8 +5892,7 @@ __alloc_extent_buffer(struct btrfs_fs_info *fs_info, u64 start,
 	eb->bflags = 0;
 	init_rwsem(&eb->lock);
 
-	btrfs_leak_debug_add(&fs_info->eb_leak_lock, &eb->leak_list,
-			     &fs_info->allocated_ebs);
+	btrfs_leak_debug_add_eb(eb);
 	INIT_LIST_HEAD(&eb->release_list);
 
 	spin_lock_init(&eb->refs_lock);
@@ -6342,7 +6360,7 @@ static int release_extent_buffer(struct extent_buffer *eb)
 			spin_unlock(&eb->refs_lock);
 		}
 
-		btrfs_leak_debug_del(&eb->fs_info->eb_leak_lock, &eb->leak_list);
+		btrfs_leak_debug_del_eb(eb);
 		/* Should be safe to release our pages at this point */
 		btrfs_release_extent_buffer_pages(eb);
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
-- 
2.35.1

