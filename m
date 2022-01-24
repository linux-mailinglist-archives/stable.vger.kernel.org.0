Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F207C498A82
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344929AbiAXTEY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:04:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:32836 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237110AbiAXTCX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:02:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 353D260BFB;
        Mon, 24 Jan 2022 19:02:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3D5C340E5;
        Mon, 24 Jan 2022 19:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050942;
        bh=TpG7FVjmqICJYubPQPE/JrnyvkEd1i2n0LOWSOYT5vM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0g3rHd0qiKXPaWCF3wZwW5HuS2+oZz/P+aqB6VjFO/1Br6hm1A/BhrCYg6bhgZKlh
         jRV7ywqDGtYygjAAum8eYBI9ZJ1TescR6d4f/9hb3f2SbSJq7x+Xw394aEqYL0HDHT
         rd+11hZ0DaeqbQK+zvuh7uYDeOA48bzH3KSquxTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Davidlohr Bueso <dbueso@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 153/157] lib/timerqueue: Rely on rbtree semantics for next timer
Date:   Mon, 24 Jan 2022 19:44:03 +0100
Message-Id: <20220124183937.610181088@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

commit 511885d7061eda3eb1faf3f57dcc936ff75863f1 upstream.

Simplify the timerqueue code by using cached rbtrees and rely on the tree
leftmost node semantics to get the timer with earliest expiration time.
This is a drop in conversion, and therefore semantics remain untouched.

The runtime overhead of cached rbtrees is be pretty much the same as the
current head->next method, noting that when removing the leftmost node,
a common operation for the timerqueue, the rb_next(leftmost) is O(1) as
well, so the next timer will either be the right node or its parent.
Therefore no extra pointer chasing. Finally, the size of the struct
timerqueue_head remains the same.

Passes several hours of rcutorture.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190724152323.bojciei3muvfxalm@linux-r8p5
[bwh: While this was supposed to be just refactoring, it also fixed a
 security flaw (CVE-2021-20317).  Backported to 4.9:
 - Deleted code in timerqueue_del() is different before commit d852d39432f5
   "timerqueue: Use rb_entry_safe() instead of open-coding it"
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/timerqueue.h |   13 ++++++-------
 lib/timerqueue.c           |   31 ++++++++++++-------------------
 2 files changed, 18 insertions(+), 26 deletions(-)

--- a/include/linux/timerqueue.h
+++ b/include/linux/timerqueue.h
@@ -11,8 +11,7 @@ struct timerqueue_node {
 };
 
 struct timerqueue_head {
-	struct rb_root head;
-	struct timerqueue_node *next;
+	struct rb_root_cached rb_root;
 };
 
 
@@ -28,13 +27,14 @@ extern struct timerqueue_node *timerqueu
  *
  * @head: head of timerqueue
  *
- * Returns a pointer to the timer node that has the
- * earliest expiration time.
+ * Returns a pointer to the timer node that has the earliest expiration time.
  */
 static inline
 struct timerqueue_node *timerqueue_getnext(struct timerqueue_head *head)
 {
-	return head->next;
+	struct rb_node *leftmost = rb_first_cached(&head->rb_root);
+
+	return rb_entry(leftmost, struct timerqueue_node, node);
 }
 
 static inline void timerqueue_init(struct timerqueue_node *node)
@@ -44,7 +44,6 @@ static inline void timerqueue_init(struc
 
 static inline void timerqueue_init_head(struct timerqueue_head *head)
 {
-	head->head = RB_ROOT;
-	head->next = NULL;
+	head->rb_root = RB_ROOT_CACHED;
 }
 #endif /* _LINUX_TIMERQUEUE_H */
--- a/lib/timerqueue.c
+++ b/lib/timerqueue.c
@@ -38,9 +38,10 @@
  */
 bool timerqueue_add(struct timerqueue_head *head, struct timerqueue_node *node)
 {
-	struct rb_node **p = &head->head.rb_node;
+	struct rb_node **p = &head->rb_root.rb_root.rb_node;
 	struct rb_node *parent = NULL;
-	struct timerqueue_node  *ptr;
+	struct timerqueue_node *ptr;
+	bool leftmost = true;
 
 	/* Make sure we don't add nodes that are already added */
 	WARN_ON_ONCE(!RB_EMPTY_NODE(&node->node));
@@ -48,19 +49,17 @@ bool timerqueue_add(struct timerqueue_he
 	while (*p) {
 		parent = *p;
 		ptr = rb_entry(parent, struct timerqueue_node, node);
-		if (node->expires.tv64 < ptr->expires.tv64)
+		if (node->expires.tv64 < ptr->expires.tv64) {
 			p = &(*p)->rb_left;
-		else
+		} else {
 			p = &(*p)->rb_right;
+			leftmost = false;
+		}
 	}
 	rb_link_node(&node->node, parent, p);
-	rb_insert_color(&node->node, &head->head);
+	rb_insert_color_cached(&node->node, &head->rb_root, leftmost);
 
-	if (!head->next || node->expires.tv64 < head->next->expires.tv64) {
-		head->next = node;
-		return true;
-	}
-	return false;
+	return leftmost;
 }
 EXPORT_SYMBOL_GPL(timerqueue_add);
 
@@ -76,16 +75,10 @@ bool timerqueue_del(struct timerqueue_he
 {
 	WARN_ON_ONCE(RB_EMPTY_NODE(&node->node));
 
-	/* update next pointer */
-	if (head->next == node) {
-		struct rb_node *rbn = rb_next(&node->node);
-
-		head->next = rbn ?
-			rb_entry(rbn, struct timerqueue_node, node) : NULL;
-	}
-	rb_erase(&node->node, &head->head);
+	rb_erase_cached(&node->node, &head->rb_root);
 	RB_CLEAR_NODE(&node->node);
-	return head->next != NULL;
+
+	return !RB_EMPTY_ROOT(&head->rb_root.rb_root);
 }
 EXPORT_SYMBOL_GPL(timerqueue_del);
 


