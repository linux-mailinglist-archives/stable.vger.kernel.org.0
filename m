Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4BC1A0526
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 05:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgDGDKo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Apr 2020 23:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbgDGDKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Apr 2020 23:10:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95E24206B8;
        Tue,  7 Apr 2020 03:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586229043;
        bh=+L3zYw4pehU5L4OgkeHb5v2q1Y3IAihsXIdnBEB0DLM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=T056HuXraZJA9gljN5AbrZYgvg97bMYfLG9sQhulgIG6e16lV6ti5u3tesh1jnDCx
         aLGqkCxbEiq4vkyPqLR4tFtzJleeoFyGN9hQDByHxlMz1FB/2XSdd46PdFpTMbgBkC
         rWRfwr25Qmq453EUeugzoK7JGDjz929Qg/E8unWo=
Date:   Mon, 06 Apr 2020 20:10:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chris-wilson.co.uk,
        David.Laight@ACULAB.COM, elver@google.com, linux-mm@kvack.org,
        mark.rutland@arm.com, mm-commits@vger.kernel.org,
        paulmck@kernel.org, rdunlap@infradead.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 125/166] lib/list: prevent compiler reloads inside
 'safe' list iteration
Message-ID: <20200407031042.8o-fYMox-%akpm@linux-foundation.org>
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: lib/list: prevent compiler reloads inside 'safe' list iteration

Instruct the compiler to read the next element in the list iteration
once, and that it is not allowed to reload the value from the stale
element later. This is important as during the course of the safe
iteration, the stale element may be poisoned (unbeknownst to the
compiler).

This helps prevent kcsan warnings over 'unsafe' conduct in releasing the
list elements during list_for_each_entry_safe() and friends.

Link: http://lkml.kernel.org/r/20200310092119.14965-1-chris@chris-wilson.co.uk
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h |   50 +++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 14 deletions(-)

--- a/include/linux/list.h~list-prevent-compiler-reloads-inside-safe-list-iteration
+++ a/include/linux/list.h
@@ -537,6 +537,17 @@ static inline void list_splice_tail_init
 	list_entry((pos)->member.next, typeof(*(pos)), member)
 
 /**
+ * list_next_entry_safe - get the next element in list [once]
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_head within the struct.
+ *
+ * Like list_next_entry() but prevents the compiler from reloading the
+ * next element.
+ */
+#define list_next_entry_safe(pos, member) \
+	list_entry(READ_ONCE((pos)->member.next), typeof(*(pos)), member)
+
+/**
  * list_prev_entry - get the prev element in list
  * @pos:	the type * to cursor
  * @member:	the name of the list_head within the struct.
@@ -545,6 +556,17 @@ static inline void list_splice_tail_init
 	list_entry((pos)->member.prev, typeof(*(pos)), member)
 
 /**
+ * list_prev_entry_safe - get the prev element in list [once]
+ * @pos:	the type * to cursor
+ * @member:	the name of the list_head within the struct.
+ *
+ * Like list_prev_entry() but prevents the compiler from reloading the
+ * previous element.
+ */
+#define list_prev_entry_safe(pos, member) \
+	list_entry(READ_ONCE((pos)->member.prev), typeof(*(pos)), member)
+
+/**
  * list_for_each	-	iterate over a list
  * @pos:	the &struct list_head to use as a loop cursor.
  * @head:	the head for your list.
@@ -686,9 +708,9 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_first_entry(head, typeof(*pos), member),	\
-		n = list_next_entry(pos, member);			\
+		n = list_next_entry_safe(pos, member);			\
 	     &pos->member != (head); 					\
-	     pos = n, n = list_next_entry(n, member))
+	     pos = n, n = list_next_entry_safe(n, member))
 
 /**
  * list_for_each_entry_safe_continue - continue list iteration safe against removal
@@ -700,11 +722,11 @@ static inline void list_splice_tail_init
  * Iterate over list of given type, continuing after current point,
  * safe against removal of list entry.
  */
-#define list_for_each_entry_safe_continue(pos, n, head, member) 		\
-	for (pos = list_next_entry(pos, member), 				\
-		n = list_next_entry(pos, member);				\
-	     &pos->member != (head);						\
-	     pos = n, n = list_next_entry(n, member))
+#define list_for_each_entry_safe_continue(pos, n, head, member) 	\
+	for (pos = list_next_entry(pos, member), 			\
+		n = list_next_entry_safe(pos, member);			\
+	     &pos->member != (head);					\
+	     pos = n, n = list_next_entry_safe(n, member))
 
 /**
  * list_for_each_entry_safe_from - iterate over list from current point safe against removal
@@ -716,10 +738,10 @@ static inline void list_splice_tail_init
  * Iterate over list of given type from current point, safe against
  * removal of list entry.
  */
-#define list_for_each_entry_safe_from(pos, n, head, member) 			\
-	for (n = list_next_entry(pos, member);					\
-	     &pos->member != (head);						\
-	     pos = n, n = list_next_entry(n, member))
+#define list_for_each_entry_safe_from(pos, n, head, member) 		\
+	for (n = list_next_entry_safe(pos, member);			\
+	     &pos->member != (head);					\
+	     pos = n, n = list_next_entry_safe(n, member))
 
 /**
  * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
@@ -733,9 +755,9 @@ static inline void list_splice_tail_init
  */
 #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
 	for (pos = list_last_entry(head, typeof(*pos), member),		\
-		n = list_prev_entry(pos, member);			\
+		n = list_prev_entry_safe(pos, member);			\
 	     &pos->member != (head); 					\
-	     pos = n, n = list_prev_entry(n, member))
+	     pos = n, n = list_prev_entry_safe(n, member))
 
 /**
  * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
@@ -750,7 +772,7 @@ static inline void list_splice_tail_init
  * completing the current iteration of the loop body.
  */
 #define list_safe_reset_next(pos, n, member)				\
-	n = list_next_entry(pos, member)
+	n = list_next_entry_safe(pos, member)
 
 /*
  * Double linked lists with a single pointer list head.
_
