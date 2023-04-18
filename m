Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20A86E64E3
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbjDRMx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232248AbjDRMxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19431A275
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:53:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5696163466
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BE2C433EF;
        Tue, 18 Apr 2023 12:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822383;
        bh=7LDD/xBz/TwO2+c7fqTXVr85Nb0HEZeIa/qy3SvRtYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsUrNadmwOkNFpEP0z5MqngD5zNUFRh7lVs6XMZEmCd7iNJRxsZ6Wz6/QhnLgr6ua
         axZmrmehX8hSprCcVoEQkJpeY7dv2cg5JyzOmgXXLx+hC72RI0cWJJNjUkB4BMRv8s
         jTQTKz92cIw1Bsn1DcgCoOWBcHKVQHa1jdCNMSpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 102/139] maple_tree: fix write memory barrier of nodes once dead for RCU mode
Date:   Tue, 18 Apr 2023 14:22:47 +0200
Message-Id: <20230418120317.628357621@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liam R. Howlett <Liam.Howlett@oracle.com>

[ Upstream commit c13af03de46ba27674dd9fb31a17c0d480081139 ]

During the development of the maple tree, the strategy of freeing multiple
nodes changed and, in the process, the pivots were reused to store
pointers to dead nodes.  To ensure the readers see accurate pivots, the
writers need to mark the nodes as dead and call smp_wmb() to ensure any
readers can identify the node as dead before using the pivot values.

There were two places where the old method of marking the node as dead
without smp_wmb() were being used, which resulted in RCU readers seeing
the wrong pivot value before seeing the node was dead.  Fix this race
condition by using mte_set_node_dead() which has the smp_wmb() call to
ensure the race is closed.

Add a WARN_ON() to the ma_free_rcu() call to ensure all nodes being freed
are marked as dead to ensure there are no other call paths besides the two
updated paths.

This is necessary for the RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-6-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/maple_tree.c                 |  7 +++++--
 tools/testing/radix-tree/maple.c | 16 ++++++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index fb452873914f2..022573f499578 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -178,7 +178,7 @@ static void mt_free_rcu(struct rcu_head *head)
  */
 static void ma_free_rcu(struct maple_node *node)
 {
-	node->parent = ma_parent_ptr(node);
+	WARN_ON(node->parent != ma_parent_ptr(node));
 	call_rcu(&node->rcu, mt_free_rcu);
 }
 
@@ -1785,8 +1785,10 @@ static inline void mas_replace(struct ma_state *mas, bool advanced)
 		rcu_assign_pointer(slots[offset], mas->node);
 	}
 
-	if (!advanced)
+	if (!advanced) {
+		mte_set_node_dead(old_enode);
 		mas_free(mas, old_enode);
+	}
 }
 
 /*
@@ -4221,6 +4223,7 @@ static inline bool mas_wr_node_store(struct ma_wr_state *wr_mas)
 done:
 	mas_leaf_set_meta(mas, newnode, dst_pivots, maple_leaf_64, new_end);
 	if (in_rcu) {
+		mte_set_node_dead(mas->node);
 		mas->node = mt_mk_node(newnode, wr_mas->type);
 		mas_replace(mas, false);
 	} else {
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index 1f36bc1c5d362..2a16939cf0285 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -108,6 +108,7 @@ static noinline void check_new_node(struct maple_tree *mt)
 	MT_BUG_ON(mt, mn->slot[1] != NULL);
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
 
+	mn->parent = ma_parent_ptr(mn);
 	ma_free_rcu(mn);
 	mas.node = MAS_START;
 	mas_nomem(&mas, GFP_KERNEL);
@@ -160,6 +161,7 @@ static noinline void check_new_node(struct maple_tree *mt)
 		MT_BUG_ON(mt, mas_allocated(&mas) != i);
 		MT_BUG_ON(mt, !mn);
 		MT_BUG_ON(mt, not_empty(mn));
+		mn->parent = ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 	}
 
@@ -192,6 +194,7 @@ static noinline void check_new_node(struct maple_tree *mt)
 		MT_BUG_ON(mt, not_empty(mn));
 		MT_BUG_ON(mt, mas_allocated(&mas) != i - 1);
 		MT_BUG_ON(mt, !mn);
+		mn->parent = ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 	}
 
@@ -210,6 +213,7 @@ static noinline void check_new_node(struct maple_tree *mt)
 			mn = mas_pop_node(&mas);
 			MT_BUG_ON(mt, not_empty(mn));
 			MT_BUG_ON(mt, mas_allocated(&mas) != j - 1);
+			mn->parent = ma_parent_ptr(mn);
 			ma_free_rcu(mn);
 		}
 		MT_BUG_ON(mt, mas_allocated(&mas) != 0);
@@ -233,6 +237,7 @@ static noinline void check_new_node(struct maple_tree *mt)
 			MT_BUG_ON(mt, mas_allocated(&mas) != i - j);
 			mn = mas_pop_node(&mas);
 			MT_BUG_ON(mt, not_empty(mn));
+			mn->parent = ma_parent_ptr(mn);
 			ma_free_rcu(mn);
 			MT_BUG_ON(mt, mas_allocated(&mas) != i - j - 1);
 		}
@@ -269,6 +274,7 @@ static noinline void check_new_node(struct maple_tree *mt)
 			mn = mas_pop_node(&mas); /* get the next node. */
 			MT_BUG_ON(mt, mn == NULL);
 			MT_BUG_ON(mt, not_empty(mn));
+			mn->parent = ma_parent_ptr(mn);
 			ma_free_rcu(mn);
 		}
 		MT_BUG_ON(mt, mas_allocated(&mas) != 0);
@@ -294,6 +300,7 @@ static noinline void check_new_node(struct maple_tree *mt)
 			mn = mas_pop_node(&mas2); /* get the next node. */
 			MT_BUG_ON(mt, mn == NULL);
 			MT_BUG_ON(mt, not_empty(mn));
+			mn->parent = ma_parent_ptr(mn);
 			ma_free_rcu(mn);
 		}
 		MT_BUG_ON(mt, mas_allocated(&mas2) != 0);
@@ -334,10 +341,12 @@ static noinline void check_new_node(struct maple_tree *mt)
 	MT_BUG_ON(mt, mas_allocated(&mas) != MAPLE_ALLOC_SLOTS + 2);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, not_empty(mn));
+	mn->parent = ma_parent_ptr(mn);
 	ma_free_rcu(mn);
 	for (i = 1; i <= MAPLE_ALLOC_SLOTS + 1; i++) {
 		mn = mas_pop_node(&mas);
 		MT_BUG_ON(mt, not_empty(mn));
+		mn->parent = ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 	}
 	MT_BUG_ON(mt, mas_allocated(&mas) != 0);
@@ -375,6 +384,7 @@ static noinline void check_new_node(struct maple_tree *mt)
 		mas_node_count(&mas, i); /* Request */
 		mas_nomem(&mas, GFP_KERNEL); /* Fill request */
 		mn = mas_pop_node(&mas); /* get the next node. */
+		mn->parent = ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 		mas_destroy(&mas);
 
@@ -382,10 +392,13 @@ static noinline void check_new_node(struct maple_tree *mt)
 		mas_node_count(&mas, i); /* Request */
 		mas_nomem(&mas, GFP_KERNEL); /* Fill request */
 		mn = mas_pop_node(&mas); /* get the next node. */
+		mn->parent = ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 		mn = mas_pop_node(&mas); /* get the next node. */
+		mn->parent = ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 		mn = mas_pop_node(&mas); /* get the next node. */
+		mn->parent = ma_parent_ptr(mn);
 		ma_free_rcu(mn);
 		mas_destroy(&mas);
 	}
@@ -35369,6 +35382,7 @@ static noinline void check_prealloc(struct maple_tree *mt)
 	MT_BUG_ON(mt, allocated != 1 + height * 3);
 	mn = mas_pop_node(&mas);
 	MT_BUG_ON(mt, mas_allocated(&mas) != allocated - 1);
+	mn->parent = ma_parent_ptr(mn);
 	ma_free_rcu(mn);
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
 	mas_destroy(&mas);
@@ -35386,6 +35400,7 @@ static noinline void check_prealloc(struct maple_tree *mt)
 	mas_destroy(&mas);
 	allocated = mas_allocated(&mas);
 	MT_BUG_ON(mt, allocated != 0);
+	mn->parent = ma_parent_ptr(mn);
 	ma_free_rcu(mn);
 
 	MT_BUG_ON(mt, mas_preallocate(&mas, ptr, GFP_KERNEL) != 0);
@@ -35756,6 +35771,7 @@ void farmer_tests(void)
 	tree.ma_root = mt_mk_node(node, maple_leaf_64);
 	mt_dump(&tree);
 
+	node->parent = ma_parent_ptr(node);
 	ma_free_rcu(node);
 
 	/* Check things that will make lockdep angry */
-- 
2.39.2



