Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF542531E
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 14:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241347AbhJGMfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 08:35:15 -0400
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:56848 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241418AbhJGMfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 08:35:15 -0400
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 197CWnXs001383; Thu, 7 Oct 2021 21:32:49 +0900
X-Iguazu-Qid: 2wGqtKF1i4Blh3A4bx
X-Iguazu-QSIG: v=2; s=0; t=1633609968; q=2wGqtKF1i4Blh3A4bx; m=Wb/61zp/cz184/0OTYc5HqF1k4y6pXmQ9Xm03ZVbIzk=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1112) id 197CWkPl015081
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 7 Oct 2021 21:32:46 +0900
Received: from enc01.toshiba.co.jp (enc01.toshiba.co.jp [106.186.93.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by imx2-a.toshiba.co.jp (Postfix) with ESMTPS id 6086D100103;
        Thu,  7 Oct 2021 21:32:46 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 197CWjkI032090;
        Thu, 7 Oct 2021 21:32:46 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        Davidlohr Bueso <dbueso@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [RFC/PATCH for 4.14 and 4.19] lib/timerqueue: Rely on rbtree semantics for next timer
Date:   Thu,  7 Oct 2021 21:32:43 +0900
X-TSB-HOP: ON
Message-Id: <20211007123243.595438-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
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
Reference: CVE-2021-20317
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 include/linux/timerqueue.h | 13 ++++++-------
 lib/timerqueue.c           | 30 ++++++++++++------------------
 2 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/include/linux/timerqueue.h b/include/linux/timerqueue.h
index 78b8cc73f12fc9..aff122f1062a83 100644
--- a/include/linux/timerqueue.h
+++ b/include/linux/timerqueue.h
@@ -12,8 +12,7 @@ struct timerqueue_node {
 };
 
 struct timerqueue_head {
-	struct rb_root head;
-	struct timerqueue_node *next;
+	struct rb_root_cached rb_root;
 };
 
 
@@ -29,13 +28,14 @@ extern struct timerqueue_node *timerqueue_iterate_next(
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
@@ -45,7 +45,6 @@ static inline void timerqueue_init(struct timerqueue_node *node)
 
 static inline void timerqueue_init_head(struct timerqueue_head *head)
 {
-	head->head = RB_ROOT;
-	head->next = NULL;
+	head->rb_root = RB_ROOT_CACHED;
 }
 #endif /* _LINUX_TIMERQUEUE_H */
diff --git a/lib/timerqueue.c b/lib/timerqueue.c
index 0d54bcbc8170c7..7a8ae3d5fd4057 100644
--- a/lib/timerqueue.c
+++ b/lib/timerqueue.c
@@ -39,9 +39,10 @@
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
@@ -49,19 +50,17 @@ bool timerqueue_add(struct timerqueue_head *head, struct timerqueue_node *node)
 	while (*p) {
 		parent = *p;
 		ptr = rb_entry(parent, struct timerqueue_node, node);
-		if (node->expires < ptr->expires)
+		if (node->expires < ptr->expires) {
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
 
-	if (!head->next || node->expires < head->next->expires) {
-		head->next = node;
-		return true;
-	}
-	return false;
+	return leftmost;
 }
 EXPORT_SYMBOL_GPL(timerqueue_add);
 
@@ -78,15 +77,10 @@ bool timerqueue_del(struct timerqueue_head *head, struct timerqueue_node *node)
 {
 	WARN_ON_ONCE(RB_EMPTY_NODE(&node->node));
 
-	/* update next pointer */
-	if (head->next == node) {
-		struct rb_node *rbn = rb_next(&node->node);
-
-		head->next = rb_entry_safe(rbn, struct timerqueue_node, node);
-	}
-	rb_erase(&node->node, &head->head);
+	rb_erase_cached(&node->node, &head->rb_root);
 	RB_CLEAR_NODE(&node->node);
-	return head->next != NULL;
+
+	return !RB_EMPTY_ROOT(&head->rb_root.rb_root);
 }
 EXPORT_SYMBOL_GPL(timerqueue_del);
 
-- 
2.33.0


