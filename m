Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457A21AC693
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgDPOlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392752AbgDPOBP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 10:01:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 268CF20732;
        Thu, 16 Apr 2020 14:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045674;
        bh=6TTcpu+0ILQXfGivzEXVIP+0l4H93b4bpnRFX31rZqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HhgYA9TAegDBd4GFu0QKsD52A3NfCwd0QCJuQ56F/f1tqpYljnwUAGjDZ2INdiyNR
         CkNBlSruY3jvzJ9Jy/Vp3BK/XkejFy/hdIdZxAMS5tRED5f4Z9uKVATMjxbycN4XEt
         eAIJwR6KIk3we5lkSsVdffOspXnXdNO5/3QGi2+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.6 182/254] xarray: Fix early termination of xas_for_each_marked
Date:   Thu, 16 Apr 2020 15:24:31 +0200
Message-Id: <20200416131349.154274290@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 7e934cf5ace1dceeb804f7493fa28bb697ed3c52 upstream.

xas_for_each_marked() is using entry == NULL as a termination condition
of the iteration. When xas_for_each_marked() is used protected only by
RCU, this can however race with xas_store(xas, NULL) in the following
way:

TASK1                                   TASK2
page_cache_delete()         	        find_get_pages_range_tag()
                                          xas_for_each_marked()
                                            xas_find_marked()
                                              off = xas_find_chunk()

  xas_store(&xas, NULL)
    xas_init_marks(&xas);
    ...
    rcu_assign_pointer(*slot, NULL);
                                              entry = xa_entry(off);

And thus xas_for_each_marked() terminates prematurely possibly leading
to missed entries in the iteration (translating to missing writeback of
some pages or a similar problem).

If we find a NULL entry that has been marked, skip it (unless we're trying
to allocate an entry).

Reported-by: Jan Kara <jack@suse.cz>
CC: stable@vger.kernel.org
Fixes: ef8e5717db01 ("page cache: Convert delete_batch to XArray")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/xarray.h                       |    6 +
 lib/xarray.c                                 |    2 
 tools/testing/radix-tree/Makefile            |    4 -
 tools/testing/radix-tree/iteration_check_2.c |   87 +++++++++++++++++++++++++++
 tools/testing/radix-tree/main.c              |    1 
 tools/testing/radix-tree/test.h              |    1 
 6 files changed, 98 insertions(+), 3 deletions(-)

--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1648,6 +1648,7 @@ static inline void *xas_next_marked(stru
 								xa_mark_t mark)
 {
 	struct xa_node *node = xas->xa_node;
+	void *entry;
 	unsigned int offset;
 
 	if (unlikely(xas_not_node(node) || node->shift))
@@ -1659,7 +1660,10 @@ static inline void *xas_next_marked(stru
 		return NULL;
 	if (offset == XA_CHUNK_SIZE)
 		return xas_find_marked(xas, max, mark);
-	return xa_entry(xas->xa, node, offset);
+	entry = xa_entry(xas->xa, node, offset);
+	if (!entry)
+		return xas_find_marked(xas, max, mark);
+	return entry;
 }
 
 /*
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1208,6 +1208,8 @@ void *xas_find_marked(struct xa_state *x
 		}
 
 		entry = xa_entry(xas->xa, xas->xa_node, xas->xa_offset);
+		if (!entry && !(xa_track_free(xas->xa) && mark == XA_FREE_MARK))
+			continue;
 		if (!xa_is_node(entry))
 			return entry;
 		xas->xa_node = xa_to_node(entry);
--- a/tools/testing/radix-tree/Makefile
+++ b/tools/testing/radix-tree/Makefile
@@ -7,8 +7,8 @@ LDLIBS+= -lpthread -lurcu
 TARGETS = main idr-test multiorder xarray
 CORE_OFILES := xarray.o radix-tree.o idr.o linux.o test.o find_bit.o bitmap.o
 OFILES = main.o $(CORE_OFILES) regression1.o regression2.o regression3.o \
-	 regression4.o \
-	 tag_check.o multiorder.o idr-test.o iteration_check.o benchmark.o
+	 regression4.o tag_check.o multiorder.o idr-test.o iteration_check.o \
+	 iteration_check_2.o benchmark.o
 
 ifndef SHIFT
 	SHIFT=3
--- /dev/null
+++ b/tools/testing/radix-tree/iteration_check_2.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * iteration_check_2.c: Check that deleting a tagged entry doesn't cause
+ * an RCU walker to finish early.
+ * Copyright (c) 2020 Oracle
+ * Author: Matthew Wilcox <willy@infradead.org>
+ */
+#include <pthread.h>
+#include "test.h"
+
+static volatile bool test_complete;
+
+static void *iterator(void *arg)
+{
+	XA_STATE(xas, arg, 0);
+	void *entry;
+
+	rcu_register_thread();
+
+	while (!test_complete) {
+		xas_set(&xas, 0);
+		rcu_read_lock();
+		xas_for_each_marked(&xas, entry, ULONG_MAX, XA_MARK_0)
+			;
+		rcu_read_unlock();
+		assert(xas.xa_index >= 100);
+	}
+
+	rcu_unregister_thread();
+	return NULL;
+}
+
+static void *throbber(void *arg)
+{
+	struct xarray *xa = arg;
+
+	rcu_register_thread();
+
+	while (!test_complete) {
+		int i;
+
+		for (i = 0; i < 100; i++) {
+			xa_store(xa, i, xa_mk_value(i), GFP_KERNEL);
+			xa_set_mark(xa, i, XA_MARK_0);
+		}
+		for (i = 0; i < 100; i++)
+			xa_erase(xa, i);
+	}
+
+	rcu_unregister_thread();
+	return NULL;
+}
+
+void iteration_test2(unsigned test_duration)
+{
+	pthread_t threads[2];
+	DEFINE_XARRAY(array);
+	int i;
+
+	printv(1, "Running iteration test 2 for %d seconds\n", test_duration);
+
+	test_complete = false;
+
+	xa_store(&array, 100, xa_mk_value(100), GFP_KERNEL);
+	xa_set_mark(&array, 100, XA_MARK_0);
+
+	if (pthread_create(&threads[0], NULL, iterator, &array)) {
+		perror("create iterator thread");
+		exit(1);
+	}
+	if (pthread_create(&threads[1], NULL, throbber, &array)) {
+		perror("create throbber thread");
+		exit(1);
+	}
+
+	sleep(test_duration);
+	test_complete = true;
+
+	for (i = 0; i < 2; i++) {
+		if (pthread_join(threads[i], NULL)) {
+			perror("pthread_join");
+			exit(1);
+		}
+	}
+
+	xa_destroy(&array);
+}
--- a/tools/testing/radix-tree/main.c
+++ b/tools/testing/radix-tree/main.c
@@ -311,6 +311,7 @@ int main(int argc, char **argv)
 	regression4_test();
 	iteration_test(0, 10 + 90 * long_run);
 	iteration_test(7, 10 + 90 * long_run);
+	iteration_test2(10 + 90 * long_run);
 	single_thread_tests(long_run);
 
 	/* Free any remaining preallocated nodes */
--- a/tools/testing/radix-tree/test.h
+++ b/tools/testing/radix-tree/test.h
@@ -34,6 +34,7 @@ void xarray_tests(void);
 void tag_check(void);
 void multiorder_checks(void);
 void iteration_test(unsigned order, unsigned duration);
+void iteration_test2(unsigned duration);
 void benchmark(void);
 void idr_checks(void);
 void ida_tests(void);


