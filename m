Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E336238F
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732394AbfGHPcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732377AbfGHPci (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:32:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 589B921537;
        Mon,  8 Jul 2019 15:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599957;
        bh=GJjTOXqbqgHDFASrn9drflgFS1R+sgfX9aM1EesWgXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CfEYfn0g/FHyyi189SuXRoqVBn+a7pKSqA9cKnhT+tdrZYvkHlIVqUZOHQre+5V8O
         mbrPLf9M3J6hN97+caGVdA0gg23ANutqAC65aLBGjnFsErWJV3Zs4UJ1rkD1l0wwqn
         ONqMoWFoOdhIO5osnRhbM4h50fZT7+vusSWacvpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brendan Gregg <bgregg@netflix.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.1 07/96] idr: Fix idr_get_next race with idr_remove
Date:   Mon,  8 Jul 2019 17:12:39 +0200
Message-Id: <20190708150526.709425198@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
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
 lib/idr.c                           |   14 +++++++++-
 tools/testing/radix-tree/idr-test.c |   46 ++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 2 deletions(-)

--- a/lib/idr.c
+++ b/lib/idr.c
@@ -227,11 +227,21 @@ void *idr_get_next(struct idr *idr, int
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
@@ -240,7 +250,7 @@ void *idr_get_next(struct idr *idr, int
 		return NULL;
 
 	*nextid = id;
-	return rcu_dereference_raw(*slot);
+	return entry;
 }
 EXPORT_SYMBOL(idr_get_next);
 
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -287,6 +287,51 @@ static void idr_align_test(struct idr *i
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


