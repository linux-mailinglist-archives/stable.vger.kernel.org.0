Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113CD360D97
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbhDOPEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:04:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235348AbhDOPA7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15F776140C;
        Thu, 15 Apr 2021 14:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498627;
        bh=hZaut/XJ3BAQas+BQW8JkOE5/rywcPBslHBMjj9DkLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxfBNop7W7QIsh+mNmxvHc9U2/gEDyNVZWi55t+U3MB18CvzInPltmDoQrXD4A8vO
         F+HEYTxIBMKzDOJr1MZKrKfU5OF+2AdMLAI5lsDwn8UyWBgpW2Sq+VKUXmq+gv3/oW
         ecfTND88DRPuz4mI4lJqhskeSwa2fC+MLwc7XLlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 11/25] XArray: Fix splitting to non-zero orders
Date:   Thu, 15 Apr 2021 16:48:05 +0200
Message-Id: <20210415144413.521566369@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
References: <20210415144413.165663182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 3012110d71f41410932924e1d188f9eb57f1f824 ]

Splitting an order-4 entry into order-2 entries would leave the array
containing pointers to 000040008000c000 instead of 000044448888cccc.
This is a one-character fix, but enhance the test suite to check this
case.

Reported-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_xarray.c | 26 ++++++++++++++------------
 lib/xarray.c      |  4 ++--
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/lib/test_xarray.c b/lib/test_xarray.c
index 8294f43f4981..8b1c318189ce 100644
--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -1530,24 +1530,24 @@ static noinline void check_store_range(struct xarray *xa)
 
 #ifdef CONFIG_XARRAY_MULTI
 static void check_split_1(struct xarray *xa, unsigned long index,
-							unsigned int order)
+				unsigned int order, unsigned int new_order)
 {
-	XA_STATE(xas, xa, index);
-	void *entry;
-	unsigned int i = 0;
+	XA_STATE_ORDER(xas, xa, index, new_order);
+	unsigned int i;
 
 	xa_store_order(xa, index, order, xa, GFP_KERNEL);
 
 	xas_split_alloc(&xas, xa, order, GFP_KERNEL);
 	xas_lock(&xas);
 	xas_split(&xas, xa, order);
+	for (i = 0; i < (1 << order); i += (1 << new_order))
+		__xa_store(xa, index + i, xa_mk_index(index + i), 0);
 	xas_unlock(&xas);
 
-	xa_for_each(xa, index, entry) {
-		XA_BUG_ON(xa, entry != xa);
-		i++;
+	for (i = 0; i < (1 << order); i++) {
+		unsigned int val = index + (i & ~((1 << new_order) - 1));
+		XA_BUG_ON(xa, xa_load(xa, index + i) != xa_mk_index(val));
 	}
-	XA_BUG_ON(xa, i != 1 << order);
 
 	xa_set_mark(xa, index, XA_MARK_0);
 	XA_BUG_ON(xa, !xa_get_mark(xa, index, XA_MARK_0));
@@ -1557,14 +1557,16 @@ static void check_split_1(struct xarray *xa, unsigned long index,
 
 static noinline void check_split(struct xarray *xa)
 {
-	unsigned int order;
+	unsigned int order, new_order;
 
 	XA_BUG_ON(xa, !xa_empty(xa));
 
 	for (order = 1; order < 2 * XA_CHUNK_SHIFT; order++) {
-		check_split_1(xa, 0, order);
-		check_split_1(xa, 1UL << order, order);
-		check_split_1(xa, 3UL << order, order);
+		for (new_order = 0; new_order < order; new_order++) {
+			check_split_1(xa, 0, order, new_order);
+			check_split_1(xa, 1UL << order, order, new_order);
+			check_split_1(xa, 3UL << order, order, new_order);
+		}
 	}
 }
 #else
diff --git a/lib/xarray.c b/lib/xarray.c
index 5fa51614802a..ed775dee1074 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1011,7 +1011,7 @@ void xas_split_alloc(struct xa_state *xas, void *entry, unsigned int order,
 
 	do {
 		unsigned int i;
-		void *sibling;
+		void *sibling = NULL;
 		struct xa_node *node;
 
 		node = kmem_cache_alloc(radix_tree_node_cachep, gfp);
@@ -1021,7 +1021,7 @@ void xas_split_alloc(struct xa_state *xas, void *entry, unsigned int order,
 		for (i = 0; i < XA_CHUNK_SIZE; i++) {
 			if ((i & mask) == 0) {
 				RCU_INIT_POINTER(node->slots[i], entry);
-				sibling = xa_mk_sibling(0);
+				sibling = xa_mk_sibling(i);
 			} else {
 				RCU_INIT_POINTER(node->slots[i], sibling);
 			}
-- 
2.30.2



