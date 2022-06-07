Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15657540E75
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353871AbiFGSzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353959AbiFGSqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951D818DACC;
        Tue,  7 Jun 2022 10:59:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4778617B0;
        Tue,  7 Jun 2022 17:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB302C385A5;
        Tue,  7 Jun 2022 17:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624789;
        bh=hSWpuQNgtfGxMK0qxriGWEo5+jxTx1f5mPVJZ7Rbkxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqhBJq8qF1WDFQp3MEFPNcJApLH+Nh9G3Btt/tN5x4RMV7zwuY5yG5nYZYDjNmsNa
         qPGyeLwhp+bSsvI/B+EEs0dDsNpwVxWqG9lVld+IpTHmBowwg4scujuBvqh2TjosYh
         Xn/Aj+3Q/IA1Sf1UCgj2ldNqe78Um6bnDdigRPcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 437/667] list: introduce list_is_head() helper and re-use it in list.h
Date:   Tue,  7 Jun 2022 19:01:42 +0200
Message-Id: <20220607164947.829070767@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 0425473037db40d9e322631f2d4dc6ef51f97e88 ]

Introduce list_is_head() in the similar (*) way as it's done for
list_entry_is_head().  Make use of it in the list.h.

*) it's done as inliner and not a macro to be aligned with other
   list_is_*() APIs; while at it, make all three to have the same
   style.

Link: https://lkml.kernel.org/r/20211201141824.81400-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/list.h | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index f2af4b4aa4e9..a5709c9955e4 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -256,8 +256,7 @@ static inline void list_bulk_move_tail(struct list_head *head,
  * @list: the entry to test
  * @head: the head of the list
  */
-static inline int list_is_first(const struct list_head *list,
-					const struct list_head *head)
+static inline int list_is_first(const struct list_head *list, const struct list_head *head)
 {
 	return list->prev == head;
 }
@@ -267,12 +266,21 @@ static inline int list_is_first(const struct list_head *list,
  * @list: the entry to test
  * @head: the head of the list
  */
-static inline int list_is_last(const struct list_head *list,
-				const struct list_head *head)
+static inline int list_is_last(const struct list_head *list, const struct list_head *head)
 {
 	return list->next == head;
 }
 
+/**
+ * list_is_head - tests whether @list is the list @head
+ * @list: the entry to test
+ * @head: the head of the list
+ */
+static inline int list_is_head(const struct list_head *list, const struct list_head *head)
+{
+	return list == head;
+}
+
 /**
  * list_empty - tests whether a list is empty
  * @head: the list to test.
@@ -316,7 +324,7 @@ static inline void list_del_init_careful(struct list_head *entry)
 static inline int list_empty_careful(const struct list_head *head)
 {
 	struct list_head *next = smp_load_acquire(&head->next);
-	return (next == head) && (next == head->prev);
+	return list_is_head(next, head) && (next == head->prev);
 }
 
 /**
@@ -391,10 +399,9 @@ static inline void list_cut_position(struct list_head *list,
 {
 	if (list_empty(head))
 		return;
-	if (list_is_singular(head) &&
-		(head->next != entry && head != entry))
+	if (list_is_singular(head) && !list_is_head(entry, head) && (entry != head->next))
 		return;
-	if (entry == head)
+	if (list_is_head(entry, head))
 		INIT_LIST_HEAD(list);
 	else
 		__list_cut_position(list, head, entry);
@@ -568,7 +575,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @head:	the head for your list.
  */
 #define list_for_each(pos, head) \
-	for (pos = (head)->next; pos != (head); pos = pos->next)
+	for (pos = (head)->next; !list_is_head(pos, (head)); pos = pos->next)
 
 /**
  * list_for_each_continue - continue iteration over a list
@@ -578,7 +585,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * Continue to iterate over a list, continuing after the current position.
  */
 #define list_for_each_continue(pos, head) \
-	for (pos = pos->next; pos != (head); pos = pos->next)
+	for (pos = pos->next; !list_is_head(pos, (head)); pos = pos->next)
 
 /**
  * list_for_each_prev	-	iterate over a list backwards
@@ -586,7 +593,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @head:	the head for your list.
  */
 #define list_for_each_prev(pos, head) \
-	for (pos = (head)->prev; pos != (head); pos = pos->prev)
+	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
 
 /**
  * list_for_each_safe - iterate over a list safe against removal of list entry
@@ -595,8 +602,9 @@ static inline void list_splice_tail_init(struct list_head *list,
  * @head:	the head for your list.
  */
 #define list_for_each_safe(pos, n, head) \
-	for (pos = (head)->next, n = pos->next; pos != (head); \
-		pos = n, n = pos->next)
+	for (pos = (head)->next, n = pos->next; \
+	     !list_is_head(pos, (head)); \
+	     pos = n, n = pos->next)
 
 /**
  * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
@@ -606,7 +614,7 @@ static inline void list_splice_tail_init(struct list_head *list,
  */
 #define list_for_each_prev_safe(pos, n, head) \
 	for (pos = (head)->prev, n = pos->prev; \
-	     pos != (head); \
+	     !list_is_head(pos, (head)); \
 	     pos = n, n = pos->prev)
 
 /**
-- 
2.35.1



