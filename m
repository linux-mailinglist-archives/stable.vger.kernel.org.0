Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE22F6DEEFF
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjDLIqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbjDLIqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:46:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE2293CB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:46:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67A73630F3
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF0DC433EF;
        Wed, 12 Apr 2023 08:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289155;
        bh=Ay019e/cUmSejcYxX5ULbWyk/ijoD+YO/yOxaFEWTb0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AnqTInmiaSmyT3lSr8T0qLv+FwfUPaOFlea6ZjcVQVF3lZB8aymuvFa1Tu7SMlO11
         uvvqG1mib7dZRl5hVCyal5K9/XkELLXg7kLULiJAllUz21ddIPHo/OkgSFyQCMP8Ro
         ZoPU0FjyBkQv7wIn6fbYRR/Myejo9QyYP9RhyWgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stable@vger.kernel.org,
        Liam Howlett <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 157/164] maple_tree: be more cautious about dead nodes
Date:   Wed, 12 Apr 2023 10:34:39 +0200
Message-Id: <20230412082843.316425583@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 39d0bd86c499ecd6abae42a9b7112056c5560691 upstream.

ma_pivots() and ma_data_end() may be called with a dead node.  Ensure to
that the node isn't dead before using the returned values.

This is necessary for RCU mode of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-1-surenb@google.com
Link: https://lkml.kernel.org/r/20230227173632.3292573-2-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   52 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 9 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -534,6 +534,7 @@ static inline bool ma_dead_node(const st
 
 	return (parent == node);
 }
+
 /*
  * mte_dead_node() - check if the @enode is dead.
  * @enode: The encoded maple node
@@ -615,6 +616,8 @@ static inline unsigned int mas_alloc_req
  * @node - the maple node
  * @type - the node type
  *
+ * In the event of a dead node, this array may be %NULL
+ *
  * Return: A pointer to the maple node pivots
  */
 static inline unsigned long *ma_pivots(struct maple_node *node,
@@ -1086,8 +1089,11 @@ static int mas_ascend(struct ma_state *m
 		a_type = mas_parent_enum(mas, p_enode);
 		a_node = mte_parent(p_enode);
 		a_slot = mte_parent_slot(p_enode);
-		pivots = ma_pivots(a_node, a_type);
 		a_enode = mt_mk_node(a_node, a_type);
+		pivots = ma_pivots(a_node, a_type);
+
+		if (unlikely(ma_dead_node(a_node)))
+			return 1;
 
 		if (!set_min && a_slot) {
 			set_min = true;
@@ -1393,6 +1399,9 @@ static inline unsigned char ma_data_end(
 {
 	unsigned char offset;
 
+	if (!pivots)
+		return 0;
+
 	if (type == maple_arange_64)
 		return ma_meta_end(node, type);
 
@@ -1428,6 +1437,9 @@ static inline unsigned char mas_data_end
 		return ma_meta_end(node, type);
 
 	pivots = ma_pivots(node, type);
+	if (unlikely(ma_dead_node(node)))
+		return 0;
+
 	offset = mt_pivots[type] - 1;
 	if (likely(!pivots[offset]))
 		return ma_meta_end(node, type);
@@ -4493,6 +4505,9 @@ static inline int mas_prev_node(struct m
 	node = mas_mn(mas);
 	slots = ma_slots(node, mt);
 	pivots = ma_pivots(node, mt);
+	if (unlikely(ma_dead_node(node)))
+		return 1;
+
 	mas->max = pivots[offset];
 	if (offset)
 		mas->min = pivots[offset - 1] + 1;
@@ -4514,6 +4529,9 @@ static inline int mas_prev_node(struct m
 		slots = ma_slots(node, mt);
 		pivots = ma_pivots(node, mt);
 		offset = ma_data_end(node, mt, pivots, mas->max);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
 		if (offset)
 			mas->min = pivots[offset - 1] + 1;
 
@@ -4562,6 +4580,7 @@ static inline int mas_next_node(struct m
 	struct maple_enode *enode;
 	int level = 0;
 	unsigned char offset;
+	unsigned char node_end;
 	enum maple_type mt;
 	void __rcu **slots;
 
@@ -4585,7 +4604,11 @@ static inline int mas_next_node(struct m
 		node = mas_mn(mas);
 		mt = mte_node_type(mas->node);
 		pivots = ma_pivots(node, mt);
-	} while (unlikely(offset == ma_data_end(node, mt, pivots, mas->max)));
+		node_end = ma_data_end(node, mt, pivots, mas->max);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
+	} while (unlikely(offset == node_end));
 
 	slots = ma_slots(node, mt);
 	pivot = mas_safe_pivot(mas, pivots, ++offset, mt);
@@ -4601,6 +4624,9 @@ static inline int mas_next_node(struct m
 		mt = mte_node_type(mas->node);
 		slots = ma_slots(node, mt);
 		pivots = ma_pivots(node, mt);
+		if (unlikely(ma_dead_node(node)))
+			return 1;
+
 		offset = 0;
 		pivot = pivots[0];
 	}
@@ -4647,11 +4673,14 @@ static inline void *mas_next_nentry(stru
 		return NULL;
 	}
 
-	pivots = ma_pivots(node, type);
 	slots = ma_slots(node, type);
-	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	pivots = ma_pivots(node, type);
 	count = ma_data_end(node, type, pivots, mas->max);
-	if (ma_dead_node(node))
+	if (unlikely(ma_dead_node(node)))
+		return NULL;
+
+	mas->index = mas_safe_min(mas, pivots, mas->offset);
+	if (unlikely(ma_dead_node(node)))
 		return NULL;
 
 	if (mas->index > max)
@@ -4809,6 +4838,11 @@ retry:
 
 	slots = ma_slots(mn, mt);
 	pivots = ma_pivots(mn, mt);
+	if (unlikely(ma_dead_node(mn))) {
+		mas_rewalk(mas, index);
+		goto retry;
+	}
+
 	if (offset == mt_pivots[mt])
 		pivot = mas->max;
 	else
@@ -6611,11 +6645,11 @@ static inline void *mas_first_entry(stru
 	while (likely(!ma_is_leaf(mt))) {
 		MT_BUG_ON(mas->tree, mte_dead_node(mas->node));
 		slots = ma_slots(mn, mt);
-		pivots = ma_pivots(mn, mt);
-		max = pivots[0];
 		entry = mas_slot(mas, slots, 0);
+		pivots = ma_pivots(mn, mt);
 		if (unlikely(ma_dead_node(mn)))
 			return NULL;
+		max = pivots[0];
 		mas->node = entry;
 		mn = mas_mn(mas);
 		mt = mte_node_type(mas->node);
@@ -6635,13 +6669,13 @@ static inline void *mas_first_entry(stru
 	if (likely(entry))
 		return entry;
 
-	pivots = ma_pivots(mn, mt);
-	mas->index = pivots[0] + 1;
 	mas->offset = 1;
 	entry = mas_slot(mas, slots, 1);
+	pivots = ma_pivots(mn, mt);
 	if (unlikely(ma_dead_node(mn)))
 		return NULL;
 
+	mas->index = pivots[0] + 1;
 	if (mas->index > limit)
 		goto none;
 


