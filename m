Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D4C19C9A9
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389223AbgDBTNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46772 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389261AbgDBTNj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id j17so5512959wru.13
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=rJc6rCFvp9B10/3LoWPYgHGhGrPs5OmZBHWIxiKdOvQ=;
        b=pfTfd7xMnBTMJKy2dmDkUHogxTTawANdPou9mDzlofmDQcuuNMd0gRYMzHMGckly2Z
         mPGEHWAEuLBJZpRnjhsFterPZl+BEPgV0pn3ony6xQaOeDcVXzv2+GQ6ZbVdLK/wGW+l
         6WcC0Vfc/ZpoQxP2PTOxXMRY6LuCG54NDVsSWHEkZ6mst28/DNCtZ6Oqlbu/GblsLrCj
         09WBqZesDeOVnrLb2sZOJ6VzhM0rbHeOIMV9lzN+VKBkZioqzB0koWk7675AVLLFt+a1
         mfahZtmpgfpvR6uyAxYNf17c/+45R1tylTbI9SlUzQS/LLsSYA7F9GRtELsHX8aIcIVD
         iLpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rJc6rCFvp9B10/3LoWPYgHGhGrPs5OmZBHWIxiKdOvQ=;
        b=kFAqT1b/WcGmdAzarnre+53JOEKI1oe3qhX9oW1pU82Lhtul5Z/XpSJrpftx5Cqwu+
         82qjRt70h1l859eRPb6/3Ij2Kz4sWNY4Bgh/Qmbvze+dliwiSz2nPul23J0MC5HTzFnR
         NiKbtbOTKyGS60xDdgYkbABryle3zwgO9O5fjwepdjJbh1/qHdrO91S3zfTpsOxrJbFQ
         mssNX/rRK3vZvMd+wIz6sSxcgktMmf22l2o001/H//K+N+PWdjxO3j6EjXitbyL4YuQG
         gc30d5XecXxWdQ4UOK+BtlgUjkZVg/7eQI6gxUmzXmffW2UXFDfrtAOfYgdhWQ8W5VsI
         ZRig==
X-Gm-Message-State: AGi0Pua8vEp2ln9mHra+Y9aorRrBXN/7aB8cXFtAEgTEmYrzp0Ltuz0R
        htzCRtzv2WCh40xQctfuc1RlGk1moM9cGQ==
X-Google-Smtp-Source: APiQypLLrVtAgayQ5Sf8gny+DvkFd/vzN0hN//8VlQsdn4CbAmhpjPyYOk/P/ZbvyE11hgYUi5l1rA==
X-Received: by 2002:a5d:4c48:: with SMTP id n8mr4876239wrt.414.1585854815142;
        Thu, 02 Apr 2020 12:13:35 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:34 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 33/33] lib/list_sort: simplify and remove MAX_LIST_LENGTH_BITS
Date:   Thu,  2 Apr 2020 20:13:53 +0100
Message-Id: <20200402191353.787836-33-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Spelvin <lkml@sdf.org>

[ Upstream commit 043b3f7b6388fca6be86ca82979f66c5723a0d10 ]

Rather than a fixed-size array of pending sorted runs, use the ->prev
links to keep track of things.  This reduces stack usage, eliminates
some ugly overflow handling, and reduces the code size.

Also:
* merge() no longer needs to handle NULL inputs, so simplify.
* The same applies to merge_and_restore_back_links(), which is renamed
  to the less ponderous merge_final().  (It's a static helper function,
  so we don't need a super-descriptive name; comments will do.)
* Document the actual return value requirements on the (*cmp)()
  function; some callers are already using this feature.

x86-64 code size 1086 -> 739 bytes (-347)

(Yes, I see checkpatch complaining about no space after comma in
"__attribute__((nonnull(2,3,4,5)))".  Checkpatch is wrong.)

Feedback from Rasmus Villemoes, Andy Shevchenko and Geert Uytterhoeven.

[akpm@linux-foundation.org: remove __pure usage due to mysterious warning]
Link: http://lkml.kernel.org/r/f63c410e0ff76009c9b58e01027e751ff7fdb749.1552704200.git.lkml@sdf.org
Signed-off-by: George Spelvin <lkml@sdf.org>
Acked-by: Andrey Abramov <st5pub@yandex.ru>
Acked-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Daniel Wagner <daniel.wagner@siemens.com>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Don Mullis <don.mullis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/list_sort.h |   1 +
 lib/list_sort.c           | 165 ++++++++++++++++++++++++--------------
 2 files changed, 104 insertions(+), 62 deletions(-)

diff --git a/include/linux/list_sort.h b/include/linux/list_sort.h
index ba79956e848d5..20f178c24e9d1 100644
--- a/include/linux/list_sort.h
+++ b/include/linux/list_sort.h
@@ -6,6 +6,7 @@
 
 struct list_head;
 
+__attribute__((nonnull(2,3)))
 void list_sort(void *priv, struct list_head *head,
 	       int (*cmp)(void *priv, struct list_head *a,
 			  struct list_head *b));
diff --git a/lib/list_sort.c b/lib/list_sort.c
index 85759928215b4..ba9431bcac0bc 100644
--- a/lib/list_sort.c
+++ b/lib/list_sort.c
@@ -7,33 +7,41 @@
 #include <linux/list_sort.h>
 #include <linux/list.h>
 
-#define MAX_LIST_LENGTH_BITS 20
+typedef int __attribute__((nonnull(2,3))) (*cmp_func)(void *,
+		struct list_head const *, struct list_head const *);
 
 /*
  * Returns a list organized in an intermediate format suited
  * to chaining of merge() calls: null-terminated, no reserved or
  * sentinel head node, "prev" links not maintained.
  */
-static struct list_head *merge(void *priv,
-				int (*cmp)(void *priv, struct list_head *a,
-					struct list_head *b),
+__attribute__((nonnull(2,3,4)))
+static struct list_head *merge(void *priv, cmp_func cmp,
 				struct list_head *a, struct list_head *b)
 {
-	struct list_head head, *tail = &head;
+	struct list_head *head, **tail = &head;
 
-	while (a && b) {
+	for (;;) {
 		/* if equal, take 'a' -- important for sort stability */
-		if ((*cmp)(priv, a, b) <= 0) {
-			tail->next = a;
+		if (cmp(priv, a, b) <= 0) {
+			*tail = a;
+			tail = &a->next;
 			a = a->next;
+			if (!a) {
+				*tail = b;
+				break;
+			}
 		} else {
-			tail->next = b;
+			*tail = b;
+			tail = &b->next;
 			b = b->next;
+			if (!b) {
+				*tail = a;
+				break;
+			}
 		}
-		tail = tail->next;
 	}
-	tail->next = a?:b;
-	return head.next;
+	return head;
 }
 
 /*
@@ -43,44 +51,52 @@ static struct list_head *merge(void *priv,
  * prev-link restoration pass, or maintaining the prev links
  * throughout.
  */
-static void merge_and_restore_back_links(void *priv,
-				int (*cmp)(void *priv, struct list_head *a,
-					struct list_head *b),
-				struct list_head *head,
-				struct list_head *a, struct list_head *b)
+__attribute__((nonnull(2,3,4,5)))
+static void merge_final(void *priv, cmp_func cmp, struct list_head *head,
+			struct list_head *a, struct list_head *b)
 {
 	struct list_head *tail = head;
 	u8 count = 0;
 
-	while (a && b) {
+	for (;;) {
 		/* if equal, take 'a' -- important for sort stability */
-		if ((*cmp)(priv, a, b) <= 0) {
+		if (cmp(priv, a, b) <= 0) {
 			tail->next = a;
 			a->prev = tail;
+			tail = a;
 			a = a->next;
+			if (!a)
+				break;
 		} else {
 			tail->next = b;
 			b->prev = tail;
+			tail = b;
 			b = b->next;
+			if (!b) {
+				b = a;
+				break;
+			}
 		}
-		tail = tail->next;
 	}
-	tail->next = a ? : b;
 
+	/* Finish linking remainder of list b on to tail */
+	tail->next = b;
 	do {
 		/*
-		 * In worst cases this loop may run many iterations.
+		 * If the merge is highly unbalanced (e.g. the input is
+		 * already sorted), this loop may run many iterations.
 		 * Continue callbacks to the client even though no
 		 * element comparison is needed, so the client's cmp()
 		 * routine can invoke cond_resched() periodically.
 		 */
-		if (unlikely(!(++count)))
-			(*cmp)(priv, tail->next, tail->next);
-
-		tail->next->prev = tail;
-		tail = tail->next;
-	} while (tail->next);
-
+		if (unlikely(!++count))
+			cmp(priv, b, b);
+		b->prev = tail;
+		tail = b;
+		b = b->next;
+	} while (b);
+
+	/* And the final links to make a circular doubly-linked list */
 	tail->next = head;
 	head->prev = tail;
 }
@@ -91,55 +107,80 @@ static void merge_and_restore_back_links(void *priv,
  * @head: the list to sort
  * @cmp: the elements comparison function
  *
- * This function implements "merge sort", which has O(nlog(n))
- * complexity.
+ * This function implements a bottom-up merge sort, which has O(nlog(n))
+ * complexity.  We use depth-first order to take advantage of cacheing.
+ * (E.g. when we get to the fourth element, we immediately merge the
+ * first two 2-element lists.)
+ *
+ * The comparison funtion @cmp must return > 0 if @a should sort after
+ * @b ("@a > @b" if you want an ascending sort), and <= 0 if @a should
+ * sort before @b *or* their original order should be preserved.  It is
+ * always called with the element that came first in the input in @a,
+ * and list_sort is a stable sort, so it is not necessary to distinguish
+ * the @a < @b and @a == @b cases.
  *
- * The comparison function @cmp must return a negative value if @a
- * should sort before @b, and a positive value if @a should sort after
- * @b. If @a and @b are equivalent, and their original relative
- * ordering is to be preserved, @cmp must return 0.
+ * This is compatible with two styles of @cmp function:
+ * - The traditional style which returns <0 / =0 / >0, or
+ * - Returning a boolean 0/1.
+ * The latter offers a chance to save a few cycles in the comparison
+ * (which is used by e.g. plug_ctx_cmp() in block/blk-mq.c).
+ *
+ * A good way to write a multi-word comparison is
+ *	if (a->high != b->high)
+ *		return a->high > b->high;
+ *	if (a->middle != b->middle)
+ *		return a->middle > b->middle;
+ *	return a->low > b->low;
  */
+__attribute__((nonnull(2,3)))
 void list_sort(void *priv, struct list_head *head,
 		int (*cmp)(void *priv, struct list_head *a,
 			struct list_head *b))
 {
-	struct list_head *part[MAX_LIST_LENGTH_BITS+1]; /* sorted partial lists
-						-- last slot is a sentinel */
-	int lev;  /* index into part[] */
-	int max_lev = 0;
-	struct list_head *list;
+	struct list_head *list = head->next, *pending = NULL;
+	size_t count = 0;	/* Count of pending */
 
-	if (list_empty(head))
+	if (list == head->prev)	/* Zero or one elements */
 		return;
 
-	memset(part, 0, sizeof(part));
-
+	/* Convert to a null-terminated singly-linked list. */
 	head->prev->next = NULL;
-	list = head->next;
 
-	while (list) {
+	/*
+	 * Data structure invariants:
+	 * - All lists are singly linked and null-terminated; prev
+	 *   pointers are not maintained.
+	 * - pending is a prev-linked "list of lists" of sorted
+	 *   sublists awaiting further merging.
+	 * - Each of the sorted sublists is power-of-two in size,
+	 *   corresponding to bits set in "count".
+	 * - Sublists are sorted by size and age, smallest & newest at front.
+	 */
+	do {
+		size_t bits;
 		struct list_head *cur = list;
+
+		/* Extract the head of "list" as a single-element list "cur" */
 		list = list->next;
 		cur->next = NULL;
 
-		for (lev = 0; part[lev]; lev++) {
-			cur = merge(priv, cmp, part[lev], cur);
-			part[lev] = NULL;
+		/* Do merges corresponding to set lsbits in count */
+		for (bits = count; bits & 1; bits >>= 1) {
+			cur = merge(priv, (cmp_func)cmp, pending, cur);
+			pending = pending->prev;  /* Untouched by merge() */
 		}
-		if (lev > max_lev) {
-			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
-				printk_once(KERN_DEBUG "list too long for efficiency\n");
-				lev--;
-			}
-			max_lev = lev;
-		}
-		part[lev] = cur;
+		/* And place the result at the head of "pending" */
+		cur->prev = pending;
+		pending = cur;
+		count++;
+	} while (list->next);
+
+	/* Now merge together last element with all pending lists */
+	while (pending->prev) {
+		list = merge(priv, (cmp_func)cmp, pending, list);
+		pending = pending->prev;
 	}
-
-	for (lev = 0; lev < max_lev; lev++)
-		if (part[lev])
-			list = merge(priv, cmp, part[lev], list);
-
-	merge_and_restore_back_links(priv, cmp, head, part[max_lev], list);
+	/* The final merge, rebuilding prev links */
+	merge_final(priv, (cmp_func)cmp, head, pending, list);
 }
 EXPORT_SYMBOL(list_sort);
-- 
2.25.1

