Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2435F5DC74
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 04:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfGCCW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 22:22:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:53636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727482AbfGCCPT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 22:15:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A970A21881;
        Wed,  3 Jul 2019 02:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120118;
        bh=0HHrHpTAdfLrEOsan/In0mpf9OzeIbpV4oZoWeelD7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z99RFiwrx6MwTmqZXo7cZG+R8Q472LNTKOMnn39txKeIppNAdQaWM/TbVXdwPAhFn
         mUc38NQuL2zN/Qi0oLUdfIowhas2xRr6n10h/yuXLewRF1Mw/tsIJ3zsC3rczF3Sb3
         i9aq14voEeeI/o/tZNNgyWAsLl2AIo4hGaRXSTnM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Brendan Gregg <bgregg@netflix.com>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 03/39] idr: Fix idr_get_next race with idr_remove
Date:   Tue,  2 Jul 2019 22:14:38 -0400
Message-Id: <20190703021514.17727-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021514.17727-1-sashal@kernel.org>
References: <20190703021514.17727-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit 5c089fd0c73411f2170ab795c9ffc16718c7d007 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/idr.c                           | 14 +++++++--
 tools/testing/radix-tree/idr-test.c | 46 +++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index cb1db9b8d3f6..da3021e7c2b5 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -227,11 +227,21 @@ void *idr_get_next(struct idr *idr, int *nextid)
 {
 	struct radix_tree_iter iter;
 	void __rcu **slot;
+	void *entry = NULL;
 	unsigned long base = idr->idr_base;
 	unsigned long id = *nextid;
 
 	id = (id < base) ? 0 : id - base;
-	slot = radix_tree_iter_find(&idr->idr_rt, &iter, id);
+	radix_tree_for_each_slot(slot, &idr->idr_rt, &iter, id) {
+		entry = rcu_dereference_raw(*slot);
+		if (!entry)
+			continue;
+		if (!xa_is_internal(entry))
+			break;
+		if (slot != &idr->idr_rt.xa_head && !xa_is_retry(entry))
+			break;
+		slot = radix_tree_iter_retry(&iter);
+	}
 	if (!slot)
 		return NULL;
 	id = iter.index + base;
@@ -240,7 +250,7 @@ void *idr_get_next(struct idr *idr, int *nextid)
 		return NULL;
 
 	*nextid = id;
-	return rcu_dereference_raw(*slot);
+	return entry;
 }
 EXPORT_SYMBOL(idr_get_next);
 
diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 1b63bdb7688f..fe33be4c2475 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -287,6 +287,51 @@ static void idr_align_test(struct idr *idr)
 	}
 }
 
+DEFINE_IDR(find_idr);
+
+static void *idr_throbber(void *arg)
+{
+	time_t start = time(NULL);
+	int id = *(int *)arg;
+
+	rcu_register_thread();
+	do {
+		idr_alloc(&find_idr, xa_mk_value(id), id, id + 1, GFP_KERNEL);
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
+	BUG_ON(idr_alloc(&find_idr, xa_mk_value(anchor_id), anchor_id,
+				anchor_id + 1, GFP_KERNEL) != anchor_id);
+
+	do {
+		int id = 0;
+		void *entry = idr_get_next(&find_idr, &id);
+		BUG_ON(entry != xa_mk_value(id));
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
@@ -368,6 +413,7 @@ void idr_checks(void)
 	idr_u32_test(1);
 	idr_u32_test(0);
 	idr_align_test(&idr);
+	idr_find_test();
 }
 
 #define module_init(x)
-- 
2.20.1

