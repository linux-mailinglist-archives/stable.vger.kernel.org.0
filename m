Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07BB21A2D27
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 03:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgDIBDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 21:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbgDIBDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 21:03:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C23F2078E;
        Thu,  9 Apr 2020 01:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586394191;
        bh=yFe0bDb3GRU2UIlglMnHan32F7Rf73lSWqIAytH1pJY=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1iERrRoYLShSLKMkh1ScyVqbJa+0RWyAiFet14v+wRAvl/V1qFJlOG1U+aWnJeMn4
         2HSHxcmPXxosrOonojXKew0YwUOIy/bisDfDSwI/Tm7k+4Au0nXEDCTrmdlsn62CLi
         Lno6dY4Tu9YGjv/WOs6p0Lp/bWBhl0aPyxkJTF7c=
Date:   Wed, 08 Apr 2020 18:03:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     chris@chris-wilson.co.uk, David.Laight@ACULAB.COM,
        elver@google.com, mark.rutland@arm.com, mm-commits@vger.kernel.org,
        paulmck@kernel.org, rdunlap@infradead.org, stable@vger.kernel.org
Subject:  [nacked]
 list-prevent-compiler-reloads-inside-safe-list-iteration.patch removed from
 -mm tree
Message-ID: <20200409010311._VBPnmIWD%akpm@linux-foundation.org>
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: lib/list: prevent compiler reloads inside 'safe' list iteration
has been removed from the -mm tree.  Its filename was
     list-prevent-compiler-reloads-inside-safe-list-iteration.patch

This patch was dropped because it was nacked

------------------------------------------------------
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

Patches currently in -mm which might be from chris@chris-wilson.co.uk are


