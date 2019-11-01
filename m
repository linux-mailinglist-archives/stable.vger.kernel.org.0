Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2CBD1024F1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 13:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfKSM4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 07:56:08 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:54816 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfKSM4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 07:56:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Resent-To:Resent-Message-ID:Resent-Date:Resent-From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Sender:Resent-Cc:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=632Tt0ty3zzQ0GZkuJr5PZW7MUMhvFVMhU5VFLhLGoU=; b=RYswK1jPRfAJQ1t3xv6sAZBvp
        ItcgrV8MBQvYVBVXXRd3ogsXgdMUYekox6iUOhnjMW8bcewKwywy/TJQG/sy+8uxPKEm1sQmjqS1Y
        a01uwlMM2fq5i32GVcBhgV6JWLPQtBocQgkfA8v3Qsh8LPa9IDneBINt/mai+ptzukHlLWeW0Pknv
        udGP8Jvp+o0w+xe2uZvV+E0MYMvg6MoPij4kQg/qCudq0rqkJy/T6MIWbGhC5M8MCveuvCeej+RQM
        VfoEW2tpw4aIOx9hFImNgpq8/qF1ZrfjOtS+i7reqjhwHXZ/ZAp+i53t2my6DVu+b9blbmnV3x6Dm
        Gs1wtLp1w==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iX338-0001xF-OV
        for stable@vger.kernel.org; Tue, 19 Nov 2019 12:56:06 +0000
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQZzD-000829-UH; Fri, 01 Nov 2019 16:41:19 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jakub Jankowski <jjankowski@open-systems.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, stable@kernel.org,
        Mathias Hemsley <mhemsley@open-systems.com>,
        Ramon Schwammberger <rschwammberger@open-systems.com>,
        Brendan Gregg <bgregg@netflix.com>
Subject: [PATCH 4.19] idr: Fix idr_get_next race with idr_remove
Date:   Fri,  1 Nov 2019 09:41:05 -0700
Message-Id: <20191101164105.30789-1-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <7e81dcaf18a7b5a41f8a79a8a6496935ea8f3e5d.camel@open-systems.com>
References: <7e81dcaf18a7b5a41f8a79a8a6496935ea8f3e5d.camel@open-systems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

commit 5c089fd0c73411f2170ab795c9ffc16718c7d007 upstream

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
---
 lib/idr.c                           | 15 +++++++--
 tools/testing/radix-tree/idr-test.c | 52 +++++++++++++++++++++++++++++
 2 files changed, 65 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index fab2fd5bc326..6747ba16cf7a 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -231,11 +231,22 @@ void *idr_get_next(struct idr *idr, int *nextid)
 {
 	struct radix_tree_iter iter;
 	void __rcu **slot;
+	void *entry = NULL;
 	unsigned long base = idr->idr_base;
 	unsigned long id = *nextid;
 
 	id = (id < base) ? 0 : id - base;
-	slot = radix_tree_iter_find(&idr->idr_rt, &iter, id);
+	radix_tree_for_each_slot(slot, &idr->idr_rt, &iter, id) {
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
 	id = iter.index + base;
@@ -244,7 +255,7 @@ void *idr_get_next(struct idr *idr, int *nextid)
 		return NULL;
 
 	*nextid = id;
-	return rcu_dereference_raw(*slot);
+	return entry;
 }
 EXPORT_SYMBOL(idr_get_next);
 
diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 321ba92c70d2..235eef71f3d1 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -227,6 +227,57 @@ void idr_u32_test(int base)
 	idr_u32_test1(&idr, 0xffffffff);
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
@@ -307,6 +358,7 @@ void idr_checks(void)
 	idr_u32_test(4);
 	idr_u32_test(1);
 	idr_u32_test(0);
+	idr_find_test();
 }
 
 #define module_init(x)
-- 
2.24.0.rc1

