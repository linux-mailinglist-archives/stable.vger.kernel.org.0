Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C270514B62C
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgA1ODG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:03:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:49638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgA1ODF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:03:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC1A224690;
        Tue, 28 Jan 2020 14:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220184;
        bh=HYdllY688tTh57TvTwrqRqOkvSRMoKMz3ctzfOQdcpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JacGP60zbHkSC3TJKLft2dRCysdsOZ8izok6d59mAqncXX1dKqt9VFfT3jaGaCzX8
         OCwzToRT69HEvAy8YCYQ1fXIaIOFgqXPt3/HuRS4pyuh6HYCxubUCB6RGpFHt7TLQ/
         OyNVuxr0jmlY0Shm2Nry5Pw+2NW7UKxpeQgpXtTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.4 051/104] XArray: Fix xa_find_after with multi-index entries
Date:   Tue, 28 Jan 2020 15:00:12 +0100
Message-Id: <20200128135824.702029064@linuxfoundation.org>
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

commit 19c30f4dd0923ef191f35c652ee4058e91e89056 upstream.

If the entry is of an order which is a multiple of XA_CHUNK_SIZE,
the current detection of sibling entries does not work.  Factor out
an xas_sibling() function to make xa_find_after() a little more
understandable, and write a new implementation that doesn't suffer from
the same bug.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/test_xarray.c |   32 +++++++++++++++++++-------------
 lib/xarray.c      |   20 +++++++++++++-------
 2 files changed, 32 insertions(+), 20 deletions(-)

--- a/lib/test_xarray.c
+++ b/lib/test_xarray.c
@@ -902,28 +902,30 @@ static noinline void check_store_iter(st
 	XA_BUG_ON(xa, !xa_empty(xa));
 }
 
-static noinline void check_multi_find(struct xarray *xa)
+static noinline void check_multi_find_1(struct xarray *xa, unsigned order)
 {
 #ifdef CONFIG_XARRAY_MULTI
+	unsigned long multi = 3 << order;
+	unsigned long next = 4 << order;
 	unsigned long index;
 
-	xa_store_order(xa, 12, 2, xa_mk_value(12), GFP_KERNEL);
-	XA_BUG_ON(xa, xa_store_index(xa, 16, GFP_KERNEL) != NULL);
+	xa_store_order(xa, multi, order, xa_mk_value(multi), GFP_KERNEL);
+	XA_BUG_ON(xa, xa_store_index(xa, next, GFP_KERNEL) != NULL);
 
 	index = 0;
 	XA_BUG_ON(xa, xa_find(xa, &index, ULONG_MAX, XA_PRESENT) !=
-			xa_mk_value(12));
-	XA_BUG_ON(xa, index != 12);
-	index = 13;
+			xa_mk_value(multi));
+	XA_BUG_ON(xa, index != multi);
+	index = multi + 1;
 	XA_BUG_ON(xa, xa_find(xa, &index, ULONG_MAX, XA_PRESENT) !=
-			xa_mk_value(12));
-	XA_BUG_ON(xa, (index < 12) || (index >= 16));
+			xa_mk_value(multi));
+	XA_BUG_ON(xa, (index < multi) || (index >= next));
 	XA_BUG_ON(xa, xa_find_after(xa, &index, ULONG_MAX, XA_PRESENT) !=
-			xa_mk_value(16));
-	XA_BUG_ON(xa, index != 16);
+			xa_mk_value(next));
+	XA_BUG_ON(xa, index != next);
 
-	xa_erase_index(xa, 12);
-	xa_erase_index(xa, 16);
+	xa_erase_index(xa, multi);
+	xa_erase_index(xa, next);
 	XA_BUG_ON(xa, !xa_empty(xa));
 #endif
 }
@@ -1064,11 +1066,15 @@ static noinline void check_find_4(struct
 
 static noinline void check_find(struct xarray *xa)
 {
+	unsigned i;
+
 	check_find_1(xa);
 	check_find_2(xa);
 	check_find_3(xa);
 	check_find_4(xa);
-	check_multi_find(xa);
+
+	for (i = 2; i < 10; i++)
+		check_multi_find_1(xa, i);
 	check_multi_find_2(xa);
 }
 
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1824,6 +1824,17 @@ void *xa_find(struct xarray *xa, unsigne
 }
 EXPORT_SYMBOL(xa_find);
 
+static bool xas_sibling(struct xa_state *xas)
+{
+	struct xa_node *node = xas->xa_node;
+	unsigned long mask;
+
+	if (!node)
+		return false;
+	mask = (XA_CHUNK_SIZE << node->shift) - 1;
+	return (xas->xa_index & mask) > (xas->xa_offset << node->shift);
+}
+
 /**
  * xa_find_after() - Search the XArray for a present entry.
  * @xa: XArray.
@@ -1858,13 +1869,8 @@ void *xa_find_after(struct xarray *xa, u
 			entry = xas_find(&xas, max);
 		if (xas.xa_node == XAS_BOUNDS)
 			break;
-		if (xas.xa_shift) {
-			if (xas.xa_index & ((1UL << xas.xa_shift) - 1))
-				continue;
-		} else {
-			if (xas.xa_offset < (xas.xa_index & XA_CHUNK_MASK))
-				continue;
-		}
+		if (xas_sibling(&xas))
+			continue;
 		if (!xas_retry(&xas, entry))
 			break;
 	}


