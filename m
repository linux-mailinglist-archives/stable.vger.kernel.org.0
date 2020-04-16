Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631631AC469
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgDPN7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:59:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898851AbgDPN7S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:59:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6481E21734;
        Thu, 16 Apr 2020 13:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045556;
        bh=0t/oLzkgFXhjX5DcSYiAxTJvv2saLqLGZ+qwSaWFEk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdLGDjgJNXy7HI6vKfgeQjxFVVsVibdneKNMksjj5Eb+hO03NyZhpNo/cMJib6Qxf
         ThBOcpxY4cNqI7Z6JMgJ/1kjFOHxROgzepbgVzyDBgozzCDF4McvFKtKzIqqj5yESL
         1SkWXR9SgeVL9fea4o1en3XvQxL5I84mWuTg97xM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.6 181/254] XArray: Fix xas_pause for large multi-index entries
Date:   Thu, 16 Apr 2020 15:24:30 +0200
Message-Id: <20200416131349.034610037@linuxfoundation.org>
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

commit c36d451ad386b34f452fc3c8621ff14b9eaa31a6 upstream.

Inspired by the recent Coverity report, I looked for other places where
the offset wasn't being converted to an unsigned long before being
shifted, and I found one in xas_pause() when the entry being paused is
of order >32.

Fixes: b803b42823d0 ("xarray: Add XArray iterators")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/test_xarray.c |   37 +++++++++++++++++++++++++++++++++++++
 lib/xarray.c      |    2 +-
 2 files changed, 38 insertions(+), 1 deletion(-)

--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1156,6 +1156,42 @@ static noinline void check_find_entry(st
 	XA_BUG_ON(xa, !xa_empty(xa));
 }
 
+static noinline void check_pause(struct xarray *xa)
+{
+	XA_STATE(xas, xa, 0);
+	void *entry;
+	unsigned int order;
+	unsigned long index = 1;
+	unsigned int count = 0;
+
+	for (order = 0; order < order_limit; order++) {
+		XA_BUG_ON(xa, xa_store_order(xa, index, order,
+					xa_mk_index(index), GFP_KERNEL));
+		index += 1UL << order;
+	}
+
+	rcu_read_lock();
+	xas_for_each(&xas, entry, ULONG_MAX) {
+		XA_BUG_ON(xa, entry != xa_mk_index(1UL << count));
+		count++;
+	}
+	rcu_read_unlock();
+	XA_BUG_ON(xa, count != order_limit);
+
+	count = 0;
+	xas_set(&xas, 0);
+	rcu_read_lock();
+	xas_for_each(&xas, entry, ULONG_MAX) {
+		XA_BUG_ON(xa, entry != xa_mk_index(1UL << count));
+		count++;
+		xas_pause(&xas);
+	}
+	rcu_read_unlock();
+	XA_BUG_ON(xa, count != order_limit);
+
+	xa_destroy(xa);
+}
+
 static noinline void check_move_tiny(struct xarray *xa)
 {
 	XA_STATE(xas, xa, 0);
@@ -1664,6 +1700,7 @@ static int xarray_checks(void)
 	check_xa_alloc();
 	check_find(&array);
 	check_find_entry(&array);
+	check_pause(&array);
 	check_account(&array);
 	check_destroy(&array);
 	check_move(&array);
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -970,7 +970,7 @@ void xas_pause(struct xa_state *xas)
 
 	xas->xa_node = XAS_RESTART;
 	if (node) {
-		unsigned int offset = xas->xa_offset;
+		unsigned long offset = xas->xa_offset;
 		while (++offset < XA_CHUNK_SIZE) {
 			if (!xa_is_sibling(xa_entry(xas->xa, node, offset)))
 				break;


