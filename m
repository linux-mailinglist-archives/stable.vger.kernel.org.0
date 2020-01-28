Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C71B314BB65
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbgA1ODI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:49702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbgA1ODH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:03:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA425205F4;
        Tue, 28 Jan 2020 14:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220187;
        bh=1VaWgngj5dqi19Qe5fBQE0LN91i0fO+8Xqz1atubdHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0TKPax1RI2ftBHwDziVWF5qf2FPc46ApKDLWrqK4XWSAu3LatUF2U9k+E/e4G5udh
         1KXEtzRnwMxS4n5T5MZZoclijNQAL2XQsJCTCxYIPKjpiMrUBNmw4xRUjfE+xJ/rH7
         6fz+TWbmrOXXhiQ8wGx5IPBVCQesjqNlujJvUc5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.4 052/104] XArray: Fix xas_find returning too many entries
Date:   Tue, 28 Jan 2020 15:00:13 +0100
Message-Id: <20200128135824.828594165@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit c44aa5e8ab58b5f4cf473970ec784c3333496a2e upstream.

If you call xas_find() with the initial index > max, it should have
returned NULL but was returning the entry at index.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/test_xarray.c |    5 +++++
 lib/xarray.c      |   10 ++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -2,6 +2,7 @@
 /*
  * test_xarray.c: Test the XArray API
  * Copyright (c) 2017-2018 Microsoft Corporation
+ * Copyright (c) 2019-2020 Oracle
  * Author: Matthew Wilcox <willy@infradead.org>
  */
 
@@ -911,6 +912,7 @@ static noinline void check_multi_find_1(
 
 	xa_store_order(xa, multi, order, xa_mk_value(multi), GFP_KERNEL);
 	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
+	XA_BUG_ON(xa, xa_store_index(xa, next + 1, GFP_KERNEL) != NULL);
 
 	index = 0;
 	XA_BUG_ON(xa, xa_find(xa, &index, ULONG_MAX, XA_PRESENT) !=
@@ -923,9 +925,12 @@ static noinline void check_multi_find_1(
 	XA_BUG_ON(xa, xa_find_after(xa, &index, ULONG_MAX, XA_PRESENT) !=
 			xa_mk_value(next));
 	XA_BUG_ON(xa, index != next);
+	XA_BUG_ON(xa, xa_find_after(xa, &index, next, XA_PRESENT) != NULL);
+	XA_BUG_ON(xa, index != next);
 
 	xa_erase_index(xa, multi);
 	xa_erase_index(xa, next);
+	xa_erase_index(xa, next + 1);
 	XA_BUG_ON(xa, !xa_empty(xa));
 #endif
 }
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
  * XArray implementation
- * Copyright (c) 2017 Microsoft Corporation
+ * Copyright (c) 2017-2018 Microsoft Corporation
+ * Copyright (c) 2018-2020 Oracle
  * Author: Matthew Wilcox <willy@infradead.org>
  */
 
@@ -1081,6 +1082,8 @@ void *xas_find(struct xa_state *xas, uns
 
 	if (xas_error(xas))
 		return NULL;
+	if (xas->xa_index > max)
+		return set_bounds(xas);
 
 	if (!xas->xa_node) {
 		xas->xa_index = 1;
@@ -1150,6 +1153,8 @@ void *xas_find_marked(struct xa_state *x
 
 	if (xas_error(xas))
 		return NULL;
+	if (xas->xa_index > max)
+		goto max;
 
 	if (!xas->xa_node) {
 		xas->xa_index = 1;
@@ -1867,7 +1872,8 @@ void *xa_find_after(struct xarray *xa, u
 			entry = xas_find_marked(&xas, max, filter);
 		else
 			entry = xas_find(&xas, max);
-		if (xas.xa_node == XAS_BOUNDS)
+
+		if (xas_invalid(&xas))
 			break;
 		if (xas_sibling(&xas))
 			continue;


