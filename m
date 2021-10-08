Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0994268E5
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240361AbhJHLcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240949AbhJHLbg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:31:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75A5761038;
        Fri,  8 Oct 2021 11:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692575;
        bh=2Sc+hYFpuWB13klQkc59xSGuEuPdy8osJpURZ5drutU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CIak6Tb7VsdTdt4v3f8DP0x7lMSXk/IDon+wVkh5DlGzSQUCXrwMBJTDM5sVEBbVJ
         IXIuhOlOVuB67i4IzuNIIu/YD3C3qeJJ6YhfBhNC8Mo1qQSoZT174+y5adJbRQIsPu
         HBU11Hwt09833eI+UCyXua8dBo2A3dO0iIa/d/eE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davidlohr Bueso <dbueso@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.14 10/10] lib/timerqueue: Rely on rbtree semantics for next timer
Date:   Fri,  8 Oct 2021 13:27:51 +0200
Message-Id: <20211008112714.780766407@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112714.445637990@linuxfoundation.org>
References: <20211008112714.445637990@linuxfoundation.org>
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
Reference: CVE-2021-20317
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/timerqueue.h |   13 ++++++-------
 lib/timerqueue.c           |   30 ++++++++++++------------------
 2 files changed, 18 insertions(+), 25 deletions(-)

--- a/include/linux/timerqueue.h
+++ b/include/linux/timerqueue.h
@@ -12,8 +12,7 @@ struct timerqueue_node {
 };
 
 struct timerqueue_head {
-	struct rb_root head;
-	struct timerqueue_node *next;
+	struct rb_root_cached rb_root;
 };
 
 
@@ -29,13 +28,14 @@ extern struct timerqueue_node *timerqueu
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
@@ -45,7 +45,6 @@ static inline void timerqueue_init(struc
 
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
 
@@ -76,15 +75,10 @@ bool timerqueue_del(struct timerqueue_he
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
 


