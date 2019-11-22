Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB655106F9B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:16:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfKVKuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:50:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:32800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728006AbfKVKut (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:50:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FCD220656;
        Fri, 22 Nov 2019 10:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419848;
        bh=0fKSn/6t25Xp9f8N5Uee9DlHvJWj5SqkHIrfON8LGSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5b2d6fBw/istAEvnaSxCsGLSsVrHIPjkUHIZf4XoNnk3ISrT3f6EoseLxnh54HtI
         kb4MVwos3fAUDXv+vc6/tUrFM5LTXbEJ1aJIyhnhfADMbeC+ze4u0G7bTl9VJl3PEt
         2y3BCTv23szCk9Zz8RWD1yiuLp4JZAW5e90/9zBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 4.14 005/122] idr: Fix idr_get_next race with idr_remove
Date:   Fri, 22 Nov 2019 11:27:38 +0100
Message-Id: <20191122100724.918031839@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 5c089fd0c73411f2170ab795c9ffc16718c7d007 upstream.

If the entry is deleted from the IDR between the call to
radix_tree_iter_find() and rcu_dereference_raw(), idr_get_next()
will return NULL, which will end the iteration prematurely.  We should
instead continue to the next entry in the IDR.  This only happens if the
iteration is protected by the RCU lock.  Most IDR users use a spinlock
or semaphore to exclude simultaneous modifications.  It was noticed once
the PID allocator was converted to use the IDR, as it uses the RCU lock,
but there may be other users elsewhere in the kernel.

We can't use the normal pattern of calling radix_tree_deref_retry()
(which catches both a retry entry in a leaf node and a node entry in
the root) as the IDR supports storing entries which are unaligned,
which will trigger an infinite loop if they are encountered.  Instead,
we have to explicitly check whether the entry is a retry entry.

Fixes: 0a835c4f090a ("Reimplement IDR and IDA using the radix tree")
Reported-by: Brendan Gregg <bgregg@netflix.com>
Tested-by: Brendan Gregg <bgregg@netflix.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 lib/idr.c                           |   18 +++++++++++-
 tools/testing/radix-tree/idr-test.c |   52 ++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 2 deletions(-)

--- a/lib/idr.c
+++ b/lib/idr.c
@@ -111,13 +111,27 @@ void *idr_get_next(struct idr *idr, int
 {
 	struct radix_tree_iter iter;
 	void __rcu **slot;
+	void *entry = NULL;
 
-	slot = radix_tree_iter_find(&idr->idr_rt, &iter, *nextid);
+	radix_tree_for_each_slot(slot, &idr->idr_rt, &iter, *nextid) {
+		entry = radix_tree_deref_slot(slot);
+		if (!entry)
+			continue;
+		if (!radix_tree_deref_retry(entry))
+			break;
+		if (slot != (void *)&idr->idr_rt.rnode &&
+				entry != (void *)RADIX_TREE_INTERNAL_NODE)
+			break;
+		slot = radix_tree_iter_retry(&iter);
+	}
 	if (!slot)
 		return NULL;
 
+	if (WARN_ON_ONCE(iter.index > INT_MAX))
+		return NULL;
+
 	*nextid = iter.index;
-	return rcu_dereference_raw(*slot);
+	return entry;
 }
 EXPORT_SYMBOL(idr_get_next);
 
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -177,6 +177,57 @@ void idr_get_next_test(void)
 	idr_destroy(&idr);
 }
 
+static inline void *idr_mk_value(unsigned long v)
+{
+	BUG_ON((long)v < 0);
+	return (void *)((v & 1) | 2 | (v << 1));
+}
+
+DEFINE_IDR(find_idr);
+
+static void *idr_throbber(void *arg)
+{
+	time_t start = time(NULL);
+	int id = *(int *)arg;
+
+	rcu_register_thread();
+	do {
+		idr_alloc(&find_idr, idr_mk_value(id), id, id + 1, GFP_KERNEL);
+		idr_remove(&find_idr, id);
+	} while (time(NULL) < start + 10);
+	rcu_unregister_thread();
+
+	return NULL;
+}
+
+void idr_find_test_1(int anchor_id, int throbber_id)
+{
+	pthread_t throbber;
+	time_t start = time(NULL);
+
+	pthread_create(&throbber, NULL, idr_throbber, &throbber_id);
+
+	BUG_ON(idr_alloc(&find_idr, idr_mk_value(anchor_id), anchor_id,
+				anchor_id + 1, GFP_KERNEL) != anchor_id);
+
+	do {
+		int id = 0;
+		void *entry = idr_get_next(&find_idr, &id);
+		BUG_ON(entry != idr_mk_value(id));
+	} while (time(NULL) < start + 11);
+
+	pthread_join(throbber, NULL);
+
+	idr_remove(&find_idr, anchor_id);
+	BUG_ON(!idr_is_empty(&find_idr));
+}
+
+void idr_find_test(void)
+{
+	idr_find_test_1(100000, 0);
+	idr_find_test_1(0, 100000);
+}
+
 void idr_checks(void)
 {
 	unsigned long i;
@@ -234,6 +285,7 @@ void idr_checks(void)
 	idr_null_test();
 	idr_nowait_test();
 	idr_get_next_test();
+	idr_find_test();
 }
 
 /*


