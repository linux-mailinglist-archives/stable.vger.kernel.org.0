Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE7E1024F2
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 13:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbfKSM4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 07:56:11 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:54924 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfKSM4K (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 07:56:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Resent-To:Resent-Message-ID:Resent-Date:Resent-From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Sender:Resent-Cc:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0tgIlFJjpjpbDdix/1oQ/HFhEM8dR4TKNHBx9u5EotA=; b=L1Uf4wrrGFMxqztstHlopfe0f
        fC76FI3OduqoS3Ry0FEo4PqUOPefZFZ9TmpgGVDWO4YBgkEYir6rJ+6xNxthQtiPEJElcRYLOiP9M
        6cb1a+7+zfr7ka80e3y5Kq0T61BOvOjj2CmAKT67XU/yoLB+yVbDejFF9juxGWKlBiueJdRnbs7+Y
        NrNyhnUg5dhVV7X/r39DSYJbX1eUXpYTzO/b+E4GoygXLmoVKdfob2OIMIXL5h6n92Ij0dX17X8Uj
        Q3t6yC0fG0aPWVtpLACnZLTkQvUGyaN1GhPsWkSH3ikqYXURiC8LFM8SWlfI7BHV7PgP+om1INFiM
        P3EocsEBQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iX33C-0001zy-Es
        for stable@vger.kernel.org; Tue, 19 Nov 2019 12:56:10 +0000
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iQdIB-0007EX-Hm; Fri, 01 Nov 2019 20:13:07 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Jakub Jankowski <jjankowski@open-systems.com>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, stable@kernel.org,
        Mathias Hemsley <mhemsley@open-systems.com>,
        Ramon Schwammberger <rschwammberger@open-systems.com>,
        Brendan Gregg <bgregg@netflix.com>
Subject: [PATCH 4.14] idr: Fix idr_get_next race with idr_remove
Date:   Fri,  1 Nov 2019 13:12:57 -0700
Message-Id: <20191101201257.27753-1-willy@infradead.org>
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
 lib/idr.c                           | 20 +++++++++--
 tools/testing/radix-tree/idr-test.c | 52 +++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index edd9b2be1651..948ee5320921 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -111,13 +111,27 @@ void *idr_get_next(struct idr *idr, int *nextid)
 {
 	struct radix_tree_iter iter;
 	void __rcu **slot;
-
-	slot = radix_tree_iter_find(&idr->idr_rt, &iter, *nextid);
+	void *entry = NULL;
+
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
 
diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 8e61aad0ca3f..07cec1b5a0d8 100644
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
-- 
2.24.0.rc1

